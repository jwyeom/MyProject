<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html>
    <head>
        <title>jsPlumb - state machine demonstration</title>
        <meta http-equiv="content-type" content="text/html;charset=utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no"/>
        <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" rel="stylesheet">
        <link href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css" rel="stylesheet">
        <link href="//fonts.googleapis.com/css?family=Lato:400,700" rel="stylesheet">

        <link rel="stylesheet" href="./css/default.css">
        <link rel="stylesheet" href="./css/demo.css">
        <link rel="stylesheet" href="./demo/statemachine/demo.css">
	<style>
	.custom-menu {
		z-index: 1000;
		position: absolute;
		background-color: aliceblue;
		border: 1px solid black;
		padding: 5px;
	}
	</style>
	</head>
	<!-- JS -->
	<!-- support lib for bezier stuff -->
	<script src="./node_modules/jsbezier/js/jsbezier.js"></script>
	<!-- event adapter -->
	<script src="./node_modules/mottle/js/mottle.js"></script>
	<!-- geometry functions -->
	<script src="./node_modules/biltong/src/biltong.js"></script>
	<!-- drag -->
	<script src="./node_modules/katavorio/src/katavorio.js"></script>
	<!-- jsplumb util -->
	<script src="./src/util.js"></script>
	<script src="./src/browser-util.js"></script>
	<!-- main jsplumb engine -->
	<script src="./src/jsPlumb.js"></script>
	<!-- base DOM adapter -->
	<script src="./src/dom-adapter.js"></script>
	<script src="./src/overlay-component.js"></script>
	<!-- endpoint -->
	<script src="./src/endpoint.js"></script>
	<!-- connection -->
	<script src="./src/connection.js"></script>
	<!-- anchors -->
	<script src="./src/anchors.js"></script>
	<!-- connectors, endpoint and overlays  -->
	<script src="./src/defaults.js"></script>
	<!-- bezier connectors -->
	<script src="./src/connectors-bezier.js"></script>
	<!-- state machine connectors -->
	<script src="./src/connectors-statemachine.js"></script>
	<!-- flowchart connectors -->
	<script src="./src/connectors-flowchart.js"></script>
	<!-- straight connectors -->
	<script src="./src/connectors-straight.js"></script>
	<!-- SVG renderer -->
	<script src="./src/renderers-svg.js"></script>
	
	<!-- common adapter -->
	<script src="./src/base-library-adapter.js"></script>
	<!-- no library jsPlumb adapter -->
	<script src="./src/dom.jsPlumb.js"></script>
	<script src="./src/bezier-editor.js"></script>
	<!-- /JS -->
	
	<!--  demo code -->
	<script src="./demo/statemachine/demo.js"></script> 
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
	<script>
		var cp = false;
		var str = "";
		var id= "";
		var type = "";
		var jsonArray = new Array();
		$(document).keyup(function(e) {
			if (e.keyCode === 67) cp=true;
			if (e.keyCode === 86) {
				if(cp === true) {
			        newNode(1100, 300, str, type);
			        cp = false;
			    }
			}
		});
		
		
		function highlight(source) {
			for(var i = 0; i < jsonArray.length; i ++) {
				if(jsonArray[i].sourceId === source) {
					var target = jsonArray[i].targetId;
					 $('#' + target).css('background-color', 'red');
						setTimeout(function() {
							$('#' + target).css('background-color', '');
							highlight(target);

						}, 1000);
						console.log(target);
				}
			}
		}
		
		function start() {
			var begin;
			
			for(var i = 0; i < jsonArray.length; i ++) {
				var check = true;
				for(var j = 0; j < jsonArray.length; j++) {
					if(jsonArray[i].sourceId === jsonArray[j].targetId)
						check = false;
				} 
				if(check === true)
					begin = jsonArray[i].sourceId;
			}
			
			 $('#' + begin).css('background-color', 'red');
			setTimeout(function() {
				$('#' + begin).css('background-color', '');
				highlight(begin);
			}, 1000);
					
		}
		
		function msgClick() {
			var name = prompt('서비스명 : ');
			if(name !== null)
				newNode(1100, 300, name, 'w');
		}
	       		
		function brClick() {
	       	var name = prompt('분기명 : ');
	       	if(name !== null)
	       		newNode(1100, 300, name, 'd');
		}
	       		
		function sqlClick() {
			var name = prompt('SQL명 : ');
			if (name !== null)
				newNode(1100, 300, name, 'c');
	
		}
		
		function removeConn(source, target) {
			for(var i = 0; i < jsonArray.length; i ++) {
				if(jsonArray[i].sourceId === source && jsonArray[i].targetId === target) {
					jsonArray.splice(i, 1);
				}
			}
		}
		
		function updateConn(sourceId, targetId) {
			var json = new Object();
			json.sourceId = sourceId;
			json.targetId = targetId;
			jsonArray.push(json);
		}
		

		$(document).bind("click", function(event) {
			$("div.custom-menu").hide();
		});
		

	</script>
	<body data-demo-id="statemachine">
        <div class="jtk-demo-main" style="margin: 0;">
        <div style="width: 100%; height: 30%;">
        	<input type="button" id="msg" value="전문" onclick="javascript:msgClick();"> 
        	<input type="button" id="msg" value="분기" onclick="javascript:brClick();"> 
        	<input type="button" id="msg" value="SQL" onclick="javascript:sqlClick();"> 
        	<input type="button" id="start" value="시작" onclick="javascript:start();">
        </div>
            <!-- demo -->
            <div class="jtk-demo-canvas canvas-wide statemachine-demo jtk-surface jtk-surface-nopan" id="canvas">
            </div>
            <!-- /demo -->
        </div>
    </body>

</html>
