
/*
 * Camera Buttons
 */

var CameraButtons = function(room3d) {

  var orbitControls = room3d.three.controls;
  var three = room3d.three;

  var panSpeed = 30;
  var directions = {
    UP: 1,
    DOWN: 2,
    LEFT: 3,
    RIGHT: 4
  }

  function init() {
    // Camera controls
    $("#zoom-in").click(zoomIn);
    $("#zoom-out").click(zoomOut);  
    $("#zoom-in").dblclick(preventDefault);
    $("#zoom-out").dblclick(preventDefault);

    $("#reset-view").click(three.centerCamera)

    $("#move-left").click(function(){
      pan(directions.LEFT)
    })
    $("#move-right").click(function(){
      pan(directions.RIGHT)
    })
    $("#move-up").click(function(){
      pan(directions.UP)
    })
    $("#move-down").click(function(){
      pan(directions.DOWN)
    })

    $("#move-left").dblclick(preventDefault);
    $("#move-right").dblclick(preventDefault);
    $("#move-up").dblclick(preventDefault);
    $("#move-down").dblclick(preventDefault);
  }

  function preventDefault(e) {
    e.preventDefault();
    e.stopPropagation();
  }

  function pan(direction) {
    switch (direction) {
      case directions.UP:
        orbitControls.panXY(0, panSpeed);
        break;
      case directions.DOWN:
        orbitControls.panXY(0, -panSpeed);
        break;
      case directions.LEFT:
        orbitControls.panXY(panSpeed, 0);
        break;
      case directions.RIGHT:
        orbitControls.panXY(-panSpeed, 0);
        break;
    }
  }

  function zoomIn(e) {
    e.preventDefault();
    orbitControls.dollyIn(1.1);
    orbitControls.update();
  }

  function zoomOut(e) {
    e.preventDefault;
    orbitControls.dollyOut(1.1);
    orbitControls.update();
  }

  init();
}

/*
 * Context menu for selected item
 */ 

var ContextMenu = function(room3d) {

  var scope = this;
  var selectedItem;
  var three = room3d.three;

  function init() {
    $("#context-menu-delete").click(function(event) {
        selectedItem.remove();
    });

    three.itemSelectedCallbacks.add(itemSelected);
    three.itemUnselectedCallbacks.add(itemUnselected);

    initResize();

    $("#fixed").click(function() {
        var checked = $(this).prop('checked');
        selectedItem.setFixed(checked);
    });
  }

  function cmToIn(cm) {
    return cm / 2.54;
  }

  function inToCm(inches) {
    return inches * 2.54;
  }

  function itemSelected(item) {
    selectedItem = item;
    console.log(item);

    $("#context-menu-name").text(item.metadata.itemName);

    $("#item-width").val(cmToIn(selectedItem.getWidth()).toFixed(0));
    $("#item-height").val(cmToIn(selectedItem.getHeight()).toFixed(0));
    $("#item-depth").val(cmToIn(selectedItem.getDepth()).toFixed(0));

    $("#context-menu").show();

    $("#fixed").prop('checked', item.fixed);
  }

  function resize() {
    selectedItem.resize(
      inToCm($("#item-height").val()),
      inToCm($("#item-width").val()),
      inToCm($("#item-depth").val())
    );
    console.log("selected",selectedItem);
    fetch(`/items/${selectedItem.metadata.item_id}`, {
      method: 'PUT',
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content
      },
      body: JSON.stringify({ item: {
        width: inToCm($("#item-width").val()),
        depth: inToCm($("#item-depth").val()),
        } 
      })
      })
      .then(data => {
      console.log('Item updated successfully:', data);
      })
      .catch((error) => {
      console.error('Error updating item:', error);
      });
  }

  function initResize() {
    $("#item-height").change(resize);
    $("#item-width").change(resize);
    $("#item-depth").change(resize);
  }

  function itemUnselected() {
    selectedItem = null;
    $("#context-menu").hide();
  }

  init();
}

/*
 * Loading modal for items
 */

var ModalEffects = function(room3d) {

  var scope = this;
  var room3d = room3d;
  var itemsLoading = 0;

  this.setActiveItem = function(active) {
    itemSelected = active;
    update();
  }

  function update() {
    if (itemsLoading > 0) {
      $("#loading-modal").show();
    } else {
      $("#loading-modal").hide();
    }
  }

  function init() {
    room3d.model.scene.itemLoadingCallbacks.add(function() {
      itemsLoading += 1;
      update();
    });

     room3d.model.scene.itemLoadedCallbacks.add(function() {
      itemsLoading -= 1;
      update();
    });   

    update();
  }

  init();
}

/*
 * Side menu
 */

var SideMenu = function(room3d, floorplanControls, modalEffects) {
  var room3d = room3d;
  var floorplanControls = floorplanControls;
  var modalEffects = modalEffects;

  var ACTIVE_CLASS = "active";

  var tabs = {
    "FLOORPLAN" : $("#floorplan_tab"),
    "SHOP" : $("#items_tab"),
    "DESIGN" : $("#design_tab")
  }

  var scope = this;
  this.stateChangeCallbacks = $.Callbacks();

  this.states = {
    "DEFAULT" : {
      "div" : $("#viewer"),
      "tab" : tabs.DESIGN
    },
    "FLOORPLAN" : {
      "div" : $("#floorplanner"),
      "tab" : tabs.FLOORPLAN
    },
    "SHOP" : {
      "div" : $("#add-items"),
      "tab" : tabs.SHOP
    }
  }

  // sidebar state
  var currentState = scope.states.FLOORPLAN;

  function init() {
    for (var tab in tabs) {
      var elem = tabs[tab];
      elem.click(tabClicked(elem));
    }

    $("#update-floorplan").click(floorplanUpdate);

    initLeftMenu();

    room3d.three.updateWindowSize();
    handleWindowResize();

    initItems();

    setCurrentState(scope.states.DEFAULT);
  }

  function floorplanUpdate() {
    setCurrentState(scope.states.DEFAULT);
  }

  function tabClicked(tab) {
    return function() {
      // Stop three from spinning
      room3d.three.stopSpin();

      // Selected a new tab
      for (var key in scope.states) {
        var state = scope.states[key];
        if (state.tab == tab) {
          setCurrentState(state);
          break;
        }
      }
    }
  }
  
  function setCurrentState(newState) {

    if (currentState == newState) {
      return;
    }

    // show the right tab as active
    if (currentState.tab !== newState.tab) {
      if (currentState.tab != null) {
        currentState.tab.removeClass(ACTIVE_CLASS);          
      }
      if (newState.tab != null) {
        newState.tab.addClass(ACTIVE_CLASS);
      }
    }

    // set item unselected
    room3d.three.getController().setSelectedObject(null);

    // show and hide the right divs
    currentState.div.hide()
    newState.div.show()

    // custom actions
    if (newState == scope.states.FLOORPLAN) {
      floorplanControls.updateFloorplanView();
      floorplanControls.handleWindowResize();
    } 

    if (currentState == scope.states.FLOORPLAN) {
      room3d.model.floorplan.update();
    }

    if (newState == scope.states.DEFAULT) {
      room3d.three.updateWindowSize();
    }
 
    // set new state
    handleWindowResize();    
    currentState = newState;

    scope.stateChangeCallbacks.fire(newState);
  }

  function initLeftMenu() {
    $( window ).resize( handleWindowResize );
    handleWindowResize();
  }

  function handleWindowResize() {
    $(".sidebar").height(window.innerHeight);
    $("#add-items").height(window.innerHeight);

  };

  // TODO: this doesn't really belong here
  function initItems() {
    $("#add-items").find(".add-item").mousedown(function(e) {

      var modelUrl = $(this).attr("model-url");
      var itemType = parseInt($(this).attr("model-type"));
      var itemId = parseInt($(this).attr("item-id"));
      var itemName = $(this).attr("model-name");
      var metadata = {
        item_name: itemName,
        resizable: true,
        model_url: modelUrl,
        item_type: itemType,
        item_id: 0,
        setup_start: null,
        setup_end: null,
        breakdown_start: null,
        breakdown_end: null,
      }
      let fullFloorplanObj = null;
      fetch("../../../floorplan.json")
        .then(response => response.json())
        .then(json => {
          fullFloorplanObj = json;
          venue_start = fullFloorplanObj.timeline.start_time;
          venue_end = fullFloorplanObj.timeline.end_time;
          step_id = fullFloorplanObj.step_id.step_id
          room3d.model.scene.addItemClicked(itemType, modelUrl, metadata, step_id, venue_start, venue_end);  
          setCurrentState(scope.states.DEFAULT);
        });
    });
  }
  init();

}

/*
 * Change floor and wall textures
 */

var TextureSelector = function (room3d, sideMenu) {

  var scope = this;
  var three = room3d.three;
  var isAdmin = isAdmin;

  var currentTarget = null;

  function initTextureSelectors() {
    $(".texture-select-thumbnail").click(function(e) {
      var textureUrl = $(this).attr("texture-url");
      var textureStretch = ($(this).attr("texture-stretch") == "true");
      var textureScale = parseInt($(this).attr("texture-scale"));
      currentTarget.setTexture(textureUrl, textureStretch, textureScale);

      e.preventDefault();
    });
  }

  function init() {
    three.wallClicked.add(wallClicked);
    three.floorClicked.add(floorClicked);
    three.itemSelectedCallbacks.add(reset);
    three.nothingClicked.add(reset);
    sideMenu.stateChangeCallbacks.add(reset);
    initTextureSelectors();
  }

  function wallClicked(halfEdge) {
    currentTarget = halfEdge;
    $("#floorTexturesDiv").hide();  
    $("#wallTextures").show();  
  }

  function floorClicked(room) {
    currentTarget = room;
    $("#wallTextures").hide();  
    $("#floorTexturesDiv").show();  
  }

  function reset() {
    $("#wallTextures").hide();  
    $("#floorTexturesDiv").hide();  
  }

  init();
}

/*
 * Floorplanner controls
 */

var ViewerFloorplanner = function(room3d) {

  var canvasWrapper = '#floorplanner';

  // buttons
  var move = '#move';
  var remove = '#delete';
  var draw = '#draw';

  var activeStlye = 'btn-primary disabled';

  this.floorplanner = room3d.floorplanner;

  var scope = this;

  function init() {

    $( window ).resize( scope.handleWindowResize );
    scope.handleWindowResize();

    // mode buttons
    scope.floorplanner.modeResetCallbacks.add(function(mode) {
      $(draw).removeClass(activeStlye);
      $(remove).removeClass(activeStlye);
      $(move).removeClass(activeStlye);
      if (mode == scope.floorplanner.modes.MOVE) {
          $(move).addClass(activeStlye);
      } else if (mode == scope.floorplanner.modes.DRAW) {
          $(draw).addClass(activeStlye);
      } else if (mode == scope.floorplanner.modes.DELETE) {
          $(remove).addClass(activeStlye);
      }

      if (mode == scope.floorplanner.modes.DRAW) {
        $("#draw-walls-hint").show();
        scope.handleWindowResize();
      } else {
        $("#draw-walls-hint").hide();
      }
    });

    $(move).click(function(){
      scope.floorplanner.setMode(scope.floorplanner.modes.MOVE);
    });

    $(draw).click(function(){
      scope.floorplanner.setMode(scope.floorplanner.modes.DRAW);
    });

    $(remove).click(function(){
      scope.floorplanner.setMode(scope.floorplanner.modes.DELETE);
    });
  }

  this.updateFloorplanView = function() {
    scope.floorplanner.reset();
  }

  this.handleWindowResize = function() {
    $(canvasWrapper).height(window.innerHeight - $(canvasWrapper).offset().top);
    scope.floorplanner.resizeView();
  };

  init();
}; 

var mainControls = function(room3d) {
  var room3d = room3d;

  function newDesign() {
    
  }

  function loadDesign() {

  }

  function saveDesign() {

  }

  function init() {

  }

  init();
}

/*
 * Initialize!
 */

$(document).ready(function() {
  // main setup
  var opts = {
    floorplannerElement: 'floorplanner-canvas',
    threeElement: '#viewer',
    threeCanvasElement: 'three-canvas',
    textureDir: "models/textures/",
    widget: false,
    spin: false
  }
  var room3d = new Blueprint3d(opts);

  // Setting spin to false in the options does not stop spin, so this is a workaround
  room3d.three.stopSpin();

  var modalEffects = new ModalEffects(room3d);
  var viewerFloorplanner = new ViewerFloorplanner(room3d);
  var contextMenu = new ContextMenu(room3d);
  var sideMenu = new SideMenu(room3d, viewerFloorplanner, modalEffects);
  var textureSelector = new TextureSelector(room3d, sideMenu);        
  var cameraButtons = new CameraButtons(room3d);
  let fullFloorplanObj = null;
  let currentFloorplanObj = null;

  let startTime = null;
  let endTime = null;
  let timelineBar = document.getElementById('timeline-bar-3d');

  mainControls(room3d);

  // This serialization format needs work
  // Load a simple rectangle room

  // function loadDesign() {
  //   files = $("#loadFile").get(0).files;
  //   var reader = new FileReader();
  //   reader.onload = function (event) {
  //     var data = event.target.result;
  //     room3d.model.loadSerialized(data);
  //   };
  //   reader.readAsText(files[0]);
  // }

  function msToMins(ms) {
    return Math.floor(ms / 60000)
  }

  function minsToMs(mins) {
    return mins * 60000;
  }

  function setupTimelineBar() {
    // expect fullFloorplanObj to be populated

    startTime = new Date(fullFloorplanObj.timeline.start_time);
    endTime = new Date(fullFloorplanObj.timeline.end_time);

    mins = msToMins(endTime - startTime)

    // console.log(mins)

    timelineBar.setAttribute('min', 0);
    timelineBar.setAttribute('max', mins);
    timelineBar.setAttribute('value', 0);
    timelineBar.setAttribute('step', 1);

    timelineBar.addEventListener("input", updateViewFromTimeline);

    currentFloorplanObj = {...fullFloorplanObj}
    room3d.model.loadFromObject(currentFloorplanObj);
  }

  function updateViewFromTimeline() {

    let currTime = new Date(minsToMs(timelineBar.value) + startTime.getTime());

    // console.log(startTime, endTime)
    // console.log(minsToMs(timelineBar.value), startTime.getTime())
    // console.log(currTime)

    // console.log(room3d.model.scene.getItems());
    // console.log(this);


    room3d.model.scene.getItems().forEach((item) => {

      let setupStart = new Date(item.metadata.setup_start);
      let breakdownEnd = new Date(item.metadata.breakdown_end);

      // Each 'Item' object 'inherits' from THREE.Mesh, which has a 'visible'
      // property which can be used for toggling the visibility of an obj
      console.log(item, item.visible, currTime, setupStart, breakdownEnd)
      item.visible = currTime >= setupStart && currTime <= breakdownEnd
    })

    room3d.model.scene.needsUpdate = true;

  }

  fetch("../../floorplan.json")
  .then(response => response.json())
  .then(json => {
    fullFloorplanObj = json;
    setupTimelineBar();
    updateViewFromTimeline();
    // Force a re-render
    room3d.three.forceRender();
  });
  
});
