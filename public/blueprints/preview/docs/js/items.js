// add items to the "Add Items" tab
$(document).ready(function () {
    var items = [
        {
            "name": "Closed Door",
            "image": "models/thumbnails/door_closed.png",
            "model": "models/js/door_closed.js",
            "type": "7"
        },
        {
            "name": "Open Door",
            "image": "models/thumbnails/door_open.png",
            "model": "models/js/door_open.js",
            "type": "7"
        },
        {
            "name": "Window",
            "image": "models/thumbnails/window.png",
            "model": "models/js/window.js",
            "type": "3"
        },
        {
            "name": "Chair",
            "image": "models/thumbnails/chair.jpg",
            "model": "models/js/chair.js",
            "type": "1"
        },
        {
            "name": "Red Chair",
            "image": "models/thumbnails/chair_red.png",
            "model": "models/js/chair_red.js",
            "type": "1"
        },
        {
            "name": "Blue Chair",
            "image": "models/thumbnails/chair_blue.png",
            "model": "models/js/chair_blue.js",
            "type": "1"
        },
        {
            "name": "Sofa",
            "image": "models/thumbnails/sofa.jpg",
            "model": "models/js/sofa.js",
            "type": "1"
        },
        {
            "name": "Media Console",
            "image": "models/thumbnails/media.jpg",
            "model": "models/js/media.js",
            "type": "1"
        },
        {
            "name": "Floor Lamp",
            "image": "models/thumbnails/lamp.png",
            "model": "models/js/lamp.js",
            "type": "1"
        },
        {
            "name": "Shelf",
            "image": "models/thumbnails/shelf.png",
            "model": "models/js/shelf.js",
            "type": "1"
        },
        {
            "name": "Bookshelf",
            "image": "models/thumbnails/bookcase.jpg",
            "model": "models/js/bookcase.js",
            "type": "1"
        },
        /*
        {
            "name": "Storage",
            "image": "models/thumbnails/storage.jpg",
            "model": "models/js/storage.js",
            "type": "1"
        },
        */
        {
            "name": "Wooden Trunk",
            "image": "models/thumbnails/trunk.jpg",
            "model": "models/js/trunk.js",
            "type": "1"
        },
        {
            "name": "Coffee Table",
            "image": "models/thumbnails/table_coffee.jpg",
            "model": "models/js/table_coffee.js",
            "type": "1"
        },
        {
            "name": "Meeting Table",
            "image": "models/thumbnails/table_rec.png",
            "model": "models/js/table_rec.js",
            "type": "1"
        },
        {
            "name": "Round Table",
            "image": "models/thumbnails/table_rnd.jpg",
            "model": "models/js/table_rnd.js",
            "type": "1"
        },
        {
            "name": "Side Table",
            "image": "models/thumbnails/table_side.png",
            "model": "models/js/table_side.js",
            "type": "1"
        },
        {
            "name": "Man",
            "image": "models/thumbnails/man.png",
            "model": "models/js/man.js",
            "type": "1"
        },
        {
            "name": "Woman",
            "image": "models/thumbnails/woman.png",
            "model": "models/js/woman.js",
            "type": "1"
        },
        {
            "name": "Podium",
            "image": "models/thumbnails/podium.png",
            "model": "models/js/podium.js",
            "type": "1"
        },
        {
            "name": "Array of Chairs (8)",
            "image": "models/thumbnails/arr8.png",
            "model": "models/js/arr8.js",
            "type": "1"
        },
        {
            "name": "Array of Chairs (14)",
            "image": "models/thumbnails/arr14.png",
            "model": "models/js/arr14.js",
            "type": "1"
        },
        {
            "name": "Rectangle Table Set (2)",
            "image": "models/thumbnails/rec2.png",
            "model": "models/js/rec2.js",
            "type": "1"
        },
        {
            "name": "Rectangle Table Set (4)",
            "image": "models/thumbnails/rec4.png",
            "model": "models/js/rec4.js",
            "type": "1"
        },
        {
            "name": "Rectangle Table Set (8)",
            "image": "models/thumbnails/rec8.png",
            "model": "models/js/rec8.js",
            "type": "1"
        },
        {
            "name": "Round Table Set (2)",
            "image": "models/thumbnails/rnd2.png",
            "model": "models/js/rnd2.js",
            "type": "1"
        },
        {
            "name": "Round Table Set (4)",
            "image": "models/thumbnails/rnd4.png",
            "model": "models/js/rnd4.js",
            "type": "1"
        },
        {
            "name": "Round Table Set (8)",
            "image": "models/thumbnails/rnd8.png",
            "model": "models/js/rnd8.js",
            "type": "1"
        },
        {
            "name": "Square Table Set (2)",
            "image": "models/thumbnails/sq2.png",
            "model": "models/js/sq2.js",
            "type": "1"
        },
        {
            "name": "Square Table Set (4)",
            "image": "models/thumbnails/sq4.png",
            "model": "models/js/sq4.js",
            "type": "1"
        },
        {
            "name": "Square Table Set (8)",
            "image": "models/thumbnails/sq8.png",
            "model": "models/js/sq8.js",
            "type": "1"
        },
        {
            "name": "Camera",
            "image": "models/thumbnails/camera.png",
            "model": "models/js/camera.js",
            "type": "1"
        },
        {
            "name": "Poster",
            "image": "models/thumbnails/poster.jpg",
            "model": "models/js/poster.js",
            "type": "2"
        },
        /*
        {
            "name": "Blue Rug",
            "image": "models/thumbnails/rug_blue.png",
            "model": "models/js/rug_blue.js",
            "type": "8"
        },
        */
        {
            "name": "Color Rug",
            "image": "models/thumbnails/rug.png",
            "model": "models/js/rug.js",
            "type": "8"
        }
    ]

    var itemsDiv = $("#items-wrapper")
    for (var i = 0; i < items.length; i++) {
        var item = items[i];
        var html = '<div class="col-sm-4">' +
            '<a class="thumbnail add-item" model-name="' +
            item.name +
            '" model-url="' +
            item.model +
            '" model-type="' +
            item.type +
            '"><img src="' +
            item.image +
            '" alt="Add Item"> ' +
            item.name +
            '</a></div>';
        itemsDiv.append(html);
    }
});