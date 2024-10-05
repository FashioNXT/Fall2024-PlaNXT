let cnt = 0;
let x, y, offsetx, offsety;
let canvas = document.getElementById("dest_copy");
let editable = true;
let tableItems = document.getElementById("tableItems");
let time = 0;
class Item{
    // item_id is the auto-generated id for each item as soon as it's constructed
    item_id;
    // count_id;
    name;
    start_time; 
    end_time;
    owner;
    setup_time;
    breakdown_time;
    // type should be consistent with the id of the items in the repository shown in HTML
    type;
    pos_x;
    pos_y;
    rotate;
    width;
    length;
    constructor(){
        
    }
    draw(){
        if(this.start_time > time || this.end_time < time){
            return;
        }
        console.log("item drawing ", this.type, this.item_id);
        let div = document.getElementById(this.type);
        let copy = div.cloneNode(true);
        copy.id = this.item_id;
        copy.name = this.name;
        copy.setAttribute("class", "items");
        copy.setAttribute("oncontextmenu", "rightClick(event);");
        copy.setAttribute("onclick", "leftClick(event);")
        copy.style.cssText += `position: absolute; left: ${this.pos_x}px; top: ${this.pos_y}px;`;
        canvas.appendChild(copy);
    }
}
class Plan{
    items;
    constructor(){
        // I use hashmap to store all the items to make sure the storage used is low and deleting and searching fast.
        // However, I still need to perform the sorting algorithm, I would prefer to generate a new array and then sort it by the required attribute
        // the time complexity is O(n + nlogn) = O(nlogn)
        this.items = new Map();
    }
    addItem(item){
        let id = item.item_id;
        if(this.items.has(id)){
            // it's wrong, as the id is self-incremented, we shouldn't have 
        }else{
            this.items.set(id, item);
        }
    }
    deleteItem(id){
        if(this.items.has(id)){
            this.items.delete(id);
        }else{
            // no such item
        }
    }
    draw(){
        console.log("plan drawing");
        console.log(this.items.size);
        while(canvas.hasChildNodes()){
            canvas.removeChild(canvas.firstChild);
        }
        this.items.forEach(drawItems);
    }
    generateTable(){
        $("#tableItemsBody").remove();
        $("#tableItems").append("<tbody id='tableItemsBody'></tbody>");
        console.log("this is what i want ", plan.items);
        this.items.forEach(generateTableItems);
    }
}
let plan = new Plan();
// hashmap iteration function
function drawItems(value, key, map){
    value.draw();
}
function generateTableItems(value, key, map){
    let id = value.item_id;
    let tr = `<tr onclick="leftClickById(${id});"><td>${value.item_id}</td><td>${value.name}</td><td>${value.start_time}</td><td>${value.end_time}</td><td>${value.owner}</td></tr>`;
    $("#tableItemsBody").append(tr);
}
// button action
function clickToEdit(e){
    //
    editable = true;
    console.log(editable);
    return;
}
function clickToSave(e){
    // location.reload(false);
    editable = false;
    // communicate with the server
    return;
}
// click to submit
function clickToSubmit(){
    // hide the editing table
    document.getElementById("editing_page").style.visibility = "hidden";
    // update the parameters
    // get the current id
    let curID = document.getElementById("cur_id").value;
    let curName = document.getElementById("cur_name").value;
    let curStart = document.getElementById("cur_start_time").value;
    let curEnd = document.getElementById("cur_end_time").value;
    let curOwner = document.getElementById("cur_owner").value;
    // get the item from plan
    let curItem = plan.items.get(parseInt(curID));
    // update the current item
    console.log(plan.items);
    console.log(curID, typeof(parseInt(curID)));
    curItem.name = curName;
    curItem.start_time = parseInt(curStart);
    curItem.end_time = parseInt(curEnd);
    curItem.owner = curOwner;

    plan.generateTable();
    plan.draw();

    document.getElementById("editing_page").style.visibility = "hidden";
    document.getElementById("cur_id").value = -1;
}
function selectTheTime(){
    console.log("test clicking the timebar");
    time = document.getElementById("timebar").value;
    console.log("current time is ", time);
    //
    plan.draw();
}
function showTime(){
    let time = document.getElementById("timebar").value;
    document.getElementById("showTimeBar").value = time;
}
function dragstart_handler(ev) {
    if(editable == false){
        return;
    }
    let dragdiv = ev.currentTarget;
    let id = dragdiv.id;
    offsetx = ev.clientX - dragdiv.getBoundingClientRect().left;
    offsety = ev.clientY - dragdiv.getBoundingClientRect().top;
    if(dragdiv.getAttribute("class") == "items"){
        dragdiv.style.opacity = 0.5;
    }
    // update the dataTransfer
    ev.dataTransfer.setData("text", ev.currentTarget.id);
    ev.dataTransfer.setDragImage(dragdiv, offsetx * 2, offsety * 2);
    // Tell the browser both copy and move are possible
    ev.effectAllowed = "copyMove";
    
}
function dragover_handler(ev) {
    ev.preventDefault();
    console.log("dragOver");
}

function drop_handler(ev) {
    if(editable == false){
        return;
    }
    x = ev.pageX;
    y = ev.pageY;
    console.log("Drop");
    ev.preventDefault();
    let id = ev.dataTransfer.getData("text");
    let dragDiv = document.getElementById(id);
    if (dragDiv.getAttribute("class") == "sourceItems" && ev.target.id == "dest_copy") {
        // copy an item and show it on the screen
        // "true" in parentheses ensures that the entire div is copied, including deeper elements
        var nodeCopy = dragDiv.cloneNode(true);
        nodeCopy.id = cnt;
        nodeCopy.style.cssText += `position: absolute; left: ${x - offsetx}px; top: ${y - offsety}px;`;
        nodeCopy.setAttribute("oncontextmenu", "rightClick(event);");
        nodeCopy.setAttribute("class", "items");
        nodeCopy.setAttribute("onclick", "leftClick(event);")
        ev.target.appendChild(nodeCopy);
        cnt++;
        // create a new item, then insert it into the plan and finally update the table
        let current_item = new Item();
        current_item.item_id = parseInt(nodeCopy.id);
        current_item.pos_x = x - offsetx;
        current_item.pos_y = y - offsety;
        current_item.type = dragDiv.id;
        plan.addItem(current_item);
        plan.generateTable();
        // editing information
        showEditingPage(current_item);
    }
    // here is a bug, when the target location is outside of the "dest_copy" but still inside
    // the current div (ev.target.id == id), it still works for the drag
    else if (dragDiv.getAttribute("class") == "items" && (ev.currentTarget.id == "dest_copy" || ev.currentTarget.id == id)) {
        dragDiv.style.cssText = "position:absolute; left: 120px; top: 240px;";
        dragDiv.style.cssText += `position: absolute; left: ${x - offsetx}px; top: ${y - offsety}px;`;
        // update the attributes of dragged div
        console.log("w yao d id", typeof(dragDiv.id));
        // console.log(plan.items);
        let cur = plan.items.get(parseInt(dragDiv.id));
        cur.pos_x = x - offsetx;
        cur.pos_y = y - offsety;
    }

}
function dragend_handler(ev) {
    console.log("dragEnd");
    document.getElementById(ev.currentTarget.id).style.opacity = 1;
    // Remove all of the drag data
    ev.dataTransfer.clearData();
}
function showEditingPage(current_item){
    document.getElementById("editing_page").style.visibility = "visible";
    console.log(typeof(current_item));
    document.getElementById("cur_id").value = current_item.item_id;
    document.getElementById("cur_name").value = current_item.name;
    document.getElementById("cur_start_time").value = current_item.start_time;
    document.getElementById("cur_end_time").value = current_item.end_time;
    document.getElementById("cur_owner").value = current_item.owner;

}
function rightClick(e){
    if(editable == false){
        return;
    }
    e.preventDefault();
    closeMenu();
    let menu = createMenu(e);
    canvas.appendChild(menu);
}
// when clicking on any other space except the menu, the menu disappear
document.addEventListener('click', function(e){
    console.log("clickingggggggggggggg");
    closeMenu();
})
function leftClick(e){
    console.log("leftClick on the item");
    let cur_id = parseInt(e.currentTarget.id);
    showEditingPage(plan.items.get(cur_id));
}
function leftClickById(id){
    showEditingPage(plan.items.get(parseInt(id)));
}
function closeMenu(){
    // console.log("clickingggggggggggggg");
    let findMenu = document.getElementById("deletionMenu");
    if(findMenu){
        findMenu.remove();
    }
}

function createMenu(e){
    x = e.pageX;
    y = e.pageY;
    let newDiv = document.createElement("ul");
    newDiv.id = "deletionMenu";
    newDiv.setAttribute("class", "context-menu");
    newDiv.style.cssText = `position: absolute; left: ${x}px; top: ${y}px;`;
    let sub1 = createOptionsInMenu(e, "delete");
    let sub2 = createOptionsInMenu(e, "edit");
    newDiv.appendChild(sub1);
    newDiv.appendChild(sub2);
    return newDiv;
}
// str represents the text
function createOptionsInMenu(e, str){
    let opt = document.createElement("li");
    opt.textContent = str;
    let id = e.currentTarget.id;
    opt.setAttribute("onclick", `${str}Item(${id});`);
    return opt;
}
// select deletion
function deleteItem(id){
    console.log("complete deletion");
    document.getElementById(id).remove();
    console.log("yyyy",typeof(id))
    plan.items.delete(id);
    plan.generateTable();
}
function editItem(id){
    showEditingPage(plan.items.get(id));
}

// decode from JSON
function decodeJSON(str){
    // update current cnt, it should be acquired from the JSON code
    cnt = 16;
    let plan = new Plan();
    // decode the JSON
    
    // mock a plan
    let it1 = new Item();
    it1.name = "weiwei";
    it1.item_id = 0;
    it1.start_time = 0;
    it1.end_time = 10;
    it1.type = "src_copy0";
    it1.pos_x = 400;
    it1.pos_y = 200;
    it1.owner = "chu";

    let it2 = new Item();
    it2.name = "chuxi";
    it2.item_id = 11;
    it2.start_time = 11;
    it2.end_time = 16;
    it2.type = "src_copy2";
    it2.pos_x = 700;
    it2.pos_y = 400;
    it2.owner = "zhang";

    let it3 = new Item();
    it3.name = "zhang";
    it3.item_id = 14;
    it3.start_time = 14;
    it3.end_time = 18;
    it3.type = "src_copy1";
    it3.pos_x = 480;
    it3.pos_y = 180;
    it3.owner = "youli";

    plan.items.set(0, it1);
    plan.items.set(11, it2);
    plan.items.set(14, it3);
    console.log("decodeJson " + plan.items.size);
    return plan;
}
// get JSON from server
function getJSON(){
    let str = new String();
    // maybe calling the interface from the server
    return str;
}
// when loading, get the JSON data and then draw the plan
// plan is a global variable
window.onload = function(){
    // firstly, try to get data (JSON) from local cache, if cannot find the required data, then get it from the server
    console.log("loading");
    let json = getJSON();
    plan = decodeJSON(json);
    plan.draw();
    plan.generateTable();
}

