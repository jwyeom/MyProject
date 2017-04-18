 var instance;

jsPlumb.ready(function () {

    // setup some defaults for jsPlumb.
   instance = jsPlumb.getInstance({
        Endpoint: ["Dot", {radius: 2}],
        Connector:"StateMachine",
        HoverPaintStyle: {stroke: "#1e8151", strokeWidth: 2 },
        ConnectionOverlays: [
            [ "Arrow", {
                location: 1,
                id: "arrow",
                length: 14,
                foldback: 0.8
            } ],
            [ "Label", { label: "New Node", id: "label", cssClass: "aLabel" }]
        ],
        Container: "canvas"
    });
    
    instance.registerConnectionType("basic", { anchor:"Continuous", connector:"StateMachine" });

    window.jsp = instance;
    var canvas = document.getElementById("canvas");
    var windows = jsPlumb.getSelector(".statemachine-demo .w");

    // bind a click listener to each connection; the connection is deleted. you could of course
    // just do this: jsPlumb.bind("click", jsPlumb.detach), but I wanted to make it clear what was
    // happening.
    instance.bind("click", function (c) {
        instance.detach(c);
    });

    // bind a connection listener. note that the parameter passed to this function contains more than
    // just the new connection - see the documentation for a full list of what is included in 'info'.
    // this listener sets the connection's internal
    // id as the label overlay's text.
    instance.bind("connection", function (info) {
        info.connection.getOverlay("label").setLabel(info.connection.id);
    });

  /*  // bind a double click listener to "canvas"; add new node when this occurs.
    jsPlumb.on(canvas, "dblclick", function(e) {
    	newNode(e.offsetX, e.offsetY);
    });*/
});

    //
    // initialise element as connection targets and source.
    //
    var initNode = function(el) {        
    	// initialise draggable elements.
        instance.draggable(el);

        instance.makeSource(el, {
            filter: ".ep",
            anchor: "Continuous",
            connectorStyle: { stroke: "#5c96bc", strokeWidth: 2, outlineStroke: "transparent", outlineWidth: 4 },
            connectionType:"basic",
            extract:{
                "action":"the-action"
            },
            maxConnections: 2,
            onMaxConnections: function (info, e) {
                alert("Maximum connections (" + info.maxConnections + ") reached");
            }
        });

        instance.makeTarget(el, {
            dropOptions: { hoverClass: "dragHover" },
            anchor: "Continuous",
            allowLoopback: true
        });

        // this is not part of the core demo functionality; it is a means for the Toolkit edition's wrapped
        // version of this demo to find out about new nodes being added.
        //
        instance.fire("jsPlumbDemoNodeAdded", el);
        jsPlumb.fire("jsPlumbDemoLoaded", instance);
    };

    var newNode = function(x, y, name, figure) {
    	var d = document.createElement("div");
        var id = name;
        d.className = figure;
        var header = document.getElementsByClassName('jtk-draggable'); 
        d.id = figure + id + header.length;
   
        d.innerHTML = id + "<div class=\"ep\"></div>";
        d.style.left = x + "px";
        d.style.top = y + "px";
        instance.getContainer().appendChild(d);
        initNode(d);
         			
		for( var i = 0 ; i < header.length; i ++) {
			header = document.getElementsByClassName('jtk-draggable'); 
			header[i].onclick = function() {
				id = this.id;
				for(var j = 0; j < header.length; j++) {
					if(header[j].id !== id) { 
						$('#' + header[j].id).css("border","1px solid #2e6f9a");
					}
				}
				$('#' + id).css("border","1px solid red");
				str = this.innerText;
				type = this.id[0];
   			}
		}
		
		
	    var element = document.getElementsByClassName('jtk-draggable'); 
	    for( var i = 0 ; i < element.length; i ++) {
	    	element[i].addEventListener('contextmenu', function(e) {
	    		 str = this.innerText;
				 id = this.id;
				 type = this.id[0];
			   	 event.preventDefault();
				 $("<div class='custom-menu' onClick='javascript:copy(" + e.pageX + ","+e.pageY + ");'>복사하기</div>")
			    	 .appendTo("body")
			    	 .css({top: e.pageY + "px", left: e.pageX + "px"});
			 }, false);
		}		
        return d;
    };	 
	function copy(x, y) {
		newNode(x, y, str, type);
		  $("div.custom-menu").hide();
		  $(".jtk-draggable").css("border", "1px solid #2e6f9a");

	}
    
