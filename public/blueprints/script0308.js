let cnt = 0;
let x, y;
function dragstart_handler(ev) {
    let id = ev.currentTarget.id;
    let dragdiv = document.getElementById(id);
    console.log(typeof dragdiv);
    if(dragdiv.getAttribute("class") == "items"){
        dragdiv.style.opacity = 0.5;
    }
    ev.dataTransfer.setData("text", ev.currentTarget.id);
    ev.dataTransfer.setDragImage(dragdiv,0,0);
    // Tell the browser both copy and move are possible
    ev.effectAllowed = "copyMove";
    
}
function dragover_handler(ev) {
    ev.preventDefault();
    console.log("dragOver");
}
function drop_handler(ev) {
    x = ev.clientX;
    y = ev.clientY;
    console.log("Drop");
    ev.preventDefault();
    let id = ev.dataTransfer.getData("text");
    let dragDiv = document.getElementById(id);
    if (dragDiv.getAttribute("class") == "sourceItems" && ev.target.id == "dest_copy") {
        var nodeCopy = dragDiv.cloneNode(true);
        nodeCopy.id = cnt;
        nodeCopy.style.cssText = `position: fixed; left: ${x}px; top: ${y}px;`;
        nodeCopy.setAttribute("oncontextmenu", "rightClick(event);");
        nodeCopy.setAttribute("class", "items");
        ev.target.appendChild(nodeCopy);
        cnt++;
    }
    // here is a bug, when the target location is outside of the "dest_copy" but still inside the current div (ev.target.id == id), it still works for the drag
    else if (dragDiv.getAttribute("class") == "items" && (ev.target.id == "dest_copy" || ev.target.id == id)) {
       dragDiv.style.cssText = `position: fixed; left: ${x}px; top: ${y}px;`;
    }
}
function dragend_handler(ev) {
    console.log("dragEnd");
    document.getElementById(ev.currentTarget.id).style.opacity = 1;
    // Remove all of the drag data
    ev.dataTransfer.clearData();
}
function rightClick(e){
    e.preventDefault();
    closeMenu();
    let menu = createMenu(e);
    let canvas = document.getElementById("dest_copy");
    canvas.appendChild(menu);

    canvas.addEventListener('click', function(e){
        closeMenu();
    })
}
function closeMenu(){
    let findMenu = document.getElementById("deletionMenu");
    if(findMenu){
        findMenu.remove();
    }
}

function createMenu(e){
    x = e.clientX;
    y = e.clientY;
    let newDiv = document.createElement("div");
    newDiv.id = "deletionMenu";
    newDiv.style.cssText = `background: white; position: fixed; left: ${x}px; top: ${y}px;`;
    let sub1 = createOptionsInMenu(e, "delete");
    newDiv.appendChild(sub1);
    return newDiv;
}
// str represents the text
function createOptionsInMenu(e, str){
    let opt = document.createElement("div");
    opt.textContent = str;
    let id = e.currentTarget.id;
    opt.setAttribute("onclick", `deleteItem(${id});`);
    opt.style.border = "solid";
    return opt;
}
// select deletion
function deleteItem(id){
    console.log("complete deletion");
    document.getElementById(id).remove();
}
