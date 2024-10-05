
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
      var metadata = {
        itemName: $(this).attr("model-name"),
        resizable: true,
        modelUrl: modelUrl,
        itemType: itemType
      }
      room3d.model.scene.addItem(itemType, modelUrl, metadata);
      setCurrentState(scope.states.DEFAULT);
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
    room3d.model.loadSerialized('{"floorplan":{"corners":{"f90da5e3-9e0e-eba7-173d-eb0b071e838e":{"x":204.85099999999989,"y":289.052},"da026c08-d76a-a944-8e7b-096b752da9ed":{"x":672.2109999999999,"y":289.052},"4e3d65cb-54c0-0681-28bf-bddcc7bdb571":{"x":672.2109999999999,"y":-178.308},"71d4f128-ae80-3d58-9bd2-711c6ce6cdf2":{"x":204.85099999999989,"y":-178.308}},"walls":[{"corner1":"71d4f128-ae80-3d58-9bd2-711c6ce6cdf2","corner2":"f90da5e3-9e0e-eba7-173d-eb0b071e838e","frontTexture":{"url":"rooms/textures/wallmap.png","stretch":true,"scale":0},"backTexture":{"url":"rooms/textures/wallmap.png","stretch":true,"scale":0}},{"corner1":"f90da5e3-9e0e-eba7-173d-eb0b071e838e","corner2":"da026c08-d76a-a944-8e7b-096b752da9ed","frontTexture":{"url":"rooms/textures/wallmap.png","stretch":true,"scale":0},"backTexture":{"url":"rooms/textures/wallmap.png","stretch":true,"scale":0}},{"corner1":"da026c08-d76a-a944-8e7b-096b752da9ed","corner2":"4e3d65cb-54c0-0681-28bf-bddcc7bdb571","frontTexture":{"url":"rooms/textures/wallmap.png","stretch":true,"scale":0},"backTexture":{"url":"rooms/textures/wallmap.png","stretch":true,"scale":0}},{"corner1":"4e3d65cb-54c0-0681-28bf-bddcc7bdb571","corner2":"71d4f128-ae80-3d58-9bd2-711c6ce6cdf2","frontTexture":{"url":"rooms/textures/wallmap.png","stretch":true,"scale":0},"backTexture":{"url":"rooms/textures/wallmap.png","stretch":true,"scale":0}}],"wallTextures":[],"floorTextures":{},"newFloorTextures":{}},"items":[]}');
  }

  function loadDesign() {
    files = $("#loadFile").get(0).files;
    var reader  = new FileReader();
    reader.onload = function(event) {
        var data = event.target.result;
        room3d.model.loadSerialized(data);
    }
    reader.readAsText(files[0]);
  }

  function saveDesign() {
    var data = room3d.model.exportSerialized();
    var a = window.document.createElement('a');
    var blob = new Blob([data], {type : 'text'});
    a.href = window.URL.createObjectURL(blob);
    a.download = 'design.room3d';
    document.body.appendChild(a)
    a.click();
    document.body.removeChild(a)
  }

  function init() {
    $("#new").click(newDesign);
    $("#loadFile").change(loadDesign);
    $("#saveFile").click(saveDesign);
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
    widget: false
  }
  var room3d = new Blueprint3d(opts);

  var modalEffects = new ModalEffects(room3d);
  var viewerFloorplanner = new ViewerFloorplanner(room3d);
  var contextMenu = new ContextMenu(room3d);
  var sideMenu = new SideMenu(room3d, viewerFloorplanner, modalEffects);
  var textureSelector = new TextureSelector(room3d, sideMenu);        
  var cameraButtons = new CameraButtons(room3d);
  mainControls(room3d);

  // This serialization format needs work
  // Load a simple rectangle room

  function loadDesign() {
    files = $("#loadFile").get(0).files;
    var reader = new FileReader();
    reader.onload = function (event) {
      var data = event.target.result;
      room3d.model.loadSerialized(data);
    };
    reader.readAsText(files[0]);
  }

  function convertRubyHashToJSON(rubyHashString) {
    // Replace => with :
    let jsonString = rubyHashString.replace(/=>/g, ":");

    // Wrap string keys without double quotes in double quotes
    jsonString = jsonString.replace(/([\{,\s])([a-zA-Z0-9_]+)(?=:)/g, '$1"$2"');

    // Convert 'nil' to 'null'
    jsonString = jsonString.replace(/\bnil\b/g, "null");

    return jsonString;
  }

  data = `{
    "floorplan": {
      "corners": {
        "5e41ae41-49ab-0dad-8f5d-41e7591a8253": {
          "x": 294.64,
          "y": -225.04399999999998
        },
        "3c17f7d0-358c-5dda-f8a6-bf18f101f07e": {
          "x": 1044.702,
          "y": -225.04399999999998
        },
        "4f2ebf96-e96e-d1f3-9b88-ff6a879e7019": {
          "x": 294.64,
          "y": 232.664
        },
        "ca981c17-0d4d-e834-f2f3-300ba7c645bb": {
          "x": 1044.702,
          "y": 232.664
        }
      },
      "walls": [
        {
          "corner1": "5e41ae41-49ab-0dad-8f5d-41e7591a8253",
          "corner2": "4f2ebf96-e96e-d1f3-9b88-ff6a879e7019",
          "frontTexture": {
            "url": "rooms/textures/wallmap.png",
            "stretch": true,
            "scale": 0
          },
          "backTexture": {
            "url": "https://blueprint-dev.s3.amazonaws.com/uploads/floor_wall_texture/file/wallmap_yellow.png",
            "stretch": true,
            "scale": null
          }
        },
        {
          "corner1": "ca981c17-0d4d-e834-f2f3-300ba7c645bb",
          "corner2": "3c17f7d0-358c-5dda-f8a6-bf18f101f07e",
          "frontTexture": {
            "url": "rooms/textures/wallmap.png",
            "stretch": true,
            "scale": 0
          },
          "backTexture": {
            "url": "https://blueprint-dev.s3.amazonaws.com/uploads/floor_wall_texture/file/light_brick.jpg",
            "stretch": false,
            "scale": 100
          }
        },
        {
          "corner1": "5e41ae41-49ab-0dad-8f5d-41e7591a8253",
          "corner2": "3c17f7d0-358c-5dda-f8a6-bf18f101f07e",
          "frontTexture": {
            "url": "rooms/textures/wallmap.png",
            "stretch": true,
            "scale": 0
          },
          "backTexture": {
            "url": "rooms/textures/wallmap.png",
            "stretch": true,
            "scale": 0
          }
        },
        {
          "corner1": "4f2ebf96-e96e-d1f3-9b88-ff6a879e7019",
          "corner2": "ca981c17-0d4d-e834-f2f3-300ba7c645bb",
          "frontTexture": {
            "url": "rooms/textures/wallmap.png",
            "stretch": true,
            "scale": 0
          },
          "backTexture": {
            "url": "rooms/textures/wallmap.png",
            "stretch": true,
            "scale": 0
          }
        }
      ],
      "wallTextures": [],
      "floorTextures": {},
      "newFloorTextures": {}
    },
    "items": [
      {
        "item_name": "Media Console",
        "item_type": 1,
        "model_url": "models/js/media.js",
        "xpos": 636.467945801762,
        "ypos": 67.88999754395999,
        "zpos": -121.8183670462854,
        "rotation": -0.8154,
        "scale_x": 1,
        "scale_y": 1,
        "scale_z": 1,
        "fixed": false
      },
      {
        "item_name": "Color Rug",
        "item_type": 8,
        "model_url": "models/js/rug.js",
        "xpos": 905.87,
        "ypos": 0.25000500000000003,
        "zpos": 44.6,
        "rotation": -1.57,
        "scale_x": 1,
        "scale_y": 1,
        "scale_z": 1,
        "fixed": false
      },
      {
        "item_name": "Poster",
        "item_type": 2,
        "model_url": "models/js/poster.js",
        "xpos": 1038.448,
        "ypos": 146.226,
        "zpos": 148.65,
        "rotation": -1.5707963267948966,
        "scale_x": 1,
        "scale_y": 1,
        "scale_z": 1,
        "fixed": false
      },
      {
        "item_name": "Sofa",
        "item_type": 1,
        "model_url": "models/js/sofa.js",
        "xpos": 356.9267,
        "ypos": 42.54509923821,
        "zpos": -21.686,
        "rotation": 1.57,
        "scale_x": 1,
        "scale_y": 1,
        "scale_z": 1,
        "fixed": false
      },
      {
        "item_name": "Coffee Table",
        "item_type": 1,
        "model_url": "models/js/table_coffee.js",
        "xpos": 468.479,
        "ypos": 24.01483158034958,
        "zpos": -23.47,
        "rotation": 1.57,
        "scale_x": 1,
        "scale_y": 1,
        "scale_z": 1,
        "fixed": false
      },
      {
        "item_name": "Floor Lamp",
        "item_type": 1,
        "model_url": "models/js/lamp.js",
        "xpos": 346.697,
        "ypos": 72.163997943445,
        "zpos": -175.2,
        "rotation": 0,
        "scale_x": 1,
        "scale_y": 1,
        "scale_z": 1,
        "fixed": false
      }
    ]
  }`;
  var snapshotRubyHash = $("#snapshotData").data("param");

  data = convertRubyHashToJSON(snapshotRubyHash);

  room3d.model.loadSerialized(data);
});
