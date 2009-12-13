<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>jQuery Enhanced Viewer</title>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js"></script>
<link href="screen.css" rel="stylesheet" type="text/css" />
</head>

<body>
<div id="head" class="wrapper">
WhosOnCFC jView Viewer  <input id="allToggle" type="button" value="Turn Show All Off" onclick="showAllToggle()" /> / <input id="hiddenToggle" type="button" value="Turn Show Hidden Off" onclick="showHiddenToggle()" />
</div>
<div id="wrapper" class="wrapper">
	<div id="leftpane" style="width: 300px; float: left;"></div>
	<div id="rightpane" style="width: 495px; float: right;">
		<div id="detail" class="detail">Click on an item to see the details</div>
	</div>
	<br style="clear: both;" />
</div>

<script type="text/javascript">
	appInit = 0;
	jsonData = new Object();
	colMap = new Object();
	currentClient = '';
	showAll = true;
	showHidden = true;
	fadeSpeed = 3000;
	
	function showAllToggle(){
		if(showAll==true){
			showAll=false;
			$('#allToggle').val('Turn Show All On');
		} else {
			showAll=true;
			$('#allToggle').val('Turn Show All Off');			
		}
	}
	
	function showHiddenToggle(){
		if(showHidden==true){
			showHidden=false;
			$('#hiddenToggle').val('Turn Show Hidden On');
		} else {
			showHidden=true;
			$('#hiddenToggle').val('Turn Show Hidden Off');			
		}
	}
	
	function drawScreens(){
		var pane = '';
		var div1 = '<div id="';
		var div2 = '';
		var thisClient = '';
		
		// leftpane
		
		if(appInit == 0){
			for(var i=0; i<jsonData.DATA.length; i++){
				pane = $('#leftpane').html();
				
				div2 = '" class="client" style="display: none;" >';
			
				pane += div1 + jsonData.DATA[i][colMap["CLIENTID"]] + div2;
				pane += jsonData.DATA[i][colMap['HOSTNAME']] + '<br />';
				pane += jsonData.DATA[i][colMap['LASTUPDATED']] + '<br />';
				pane += '</div>';
				
				$('#leftpane').html(pane);
			}
			appInit=1;
		} else {
			// App initialized, update the client list
			
			// Delete timed out clients
			$('[class^=client]').each(function(){
				var found = 0;
				
				for(var i=0; i<jsonData.DATA.length; i++){	
					if( $(this).attr('id') == jsonData.DATA[i][colMap["CLIENTID"]] ) found=1;
				}
				
				if(!found){
					//if( currentClient == $(this).attr('id') ) viewClient(jsonDataDATA[0][colMap["CLIENTID"]];
					$(this).fadeOut(fadeSpeed, function() { $(this).remove(); });
				}
			});
			
			for(i=0; i<jsonData.DATA.length; i++){
				if( $('[id^=' + jsonData.DATA[i][colMap["CLIENTID"]] +']').length == 0){
				
					pane = $('#leftpane').html();
					thisClient = "'" + jsonData.DATA[i][colMap["CLIENTID"]] + "'";
					
					div2 = '" class="client" onclick="viewClient(' + thisClient + ')" style="display: none;" >';
				
					pane += div1 + jsonData.DATA[i][colMap["CLIENTID"]] + div2;
					pane += jsonData.DATA[i][colMap['HOSTNAME']] + '<br />';
					pane += jsonData.DATA[i][colMap['LASTUPDATED']] + '<br />';
					pane += '</div>';				
					
					$('#leftpane').html(pane);
				} else {
					pane = '';
					
					pane += jsonData.DATA[i][colMap['HOSTNAME']] + '<br />';
					pane += jsonData.DATA[i][colMap['LASTUPDATED']] + '<br />';
					
					$('[id^=' + jsonData.DATA[i][colMap["CLIENTID"]] +']').html(pane);
				}
			}
		}
		
		//if( $('#leftpane').height() > $('#rightpane').height() ) $('#rightpane').height( $('#leftpane').height() );
		
		if(currentClient.length) viewClient(currentClient);
		$('[class^=client]').each(function(){
			if( $(this).css('display') == 'none') $(this).fadeIn(fadeSpeed,function(){setHover()});
		});
		setTimeout('getData()',30000);
	}
	
	function setHover(){
		$('[class^=client]').hover(
							  
			function () {
				$(this).css({ 'background-color' : '#666666', 'color' : '#FFF', 'cursor' : 'pointer' });
				viewClient( $(this).attr('id') );
			}, 
			function () {
				$(this).css({ 'background-color' : '#ccc', 'color' : '#000' });
			}
							  
		); 		
	}
	
	function getData(){
		
		var data =  $.ajax({
			url:	'ajaxProxy.cfc?method=getUserData',
			data: ({
				showAll : showAll,
				showHidden : showHidden
			}),
			async:	false
		}).responseText;
		
		jsonData = JSON.parse(data);
		
		for(var i = 0; i < jsonData.COLUMNS.length; i++) {
			colMap[jsonData.COLUMNS[i]] = i;        
		}		
		
		drawScreens();
	}
	
	function viewClient(id){
		currentClient=id;
		for(var i=0; i<jsonData.DATA.length; i++){
			if(jsonData.DATA[i][colMap['CLIENTID']]==id){
				var innerHTML = ''
				innerHTML += '<strong>Viewing details for</strong>: ' + id + '<br /><br />';
				innerHTML += '<strong>Created</strong>: ' + jsonData.DATA[i][colMap['CREATED']] + '<br />';
				innerHTML += '<strong>City/Country</strong>: ' + jsonData.DATA[i][colMap['CITY']] + '/' + jsonData.DATA[i][colMap['COUNTRY']] + '<br />';
				innerHTML += '<strong>Entry Page</strong>: ' + jsonData.DATA[i][colMap['ENTRYPAGE']] + '<br />';
				innerHTML += '<strong>Referrer</strong>: ' + jsonData.DATA[i][colMap['REFERER']] + '<br />';				
				innerHTML += '<strong>Last Updated</strong>: ' + jsonData.DATA[i][colMap['LASTUPDATED']] + '<br />';
				innerHTML += '<strong>IP</strong>: ' + jsonData.DATA[i][colMap['IP']] + '<br />';
				innerHTML += '<strong>Host Name</strong>: ' + jsonData.DATA[i][colMap['HOSTNAME']] + '<br />';
				innerHTML += '<strong>User Agent</strong>: ' + jsonData.DATA[i][colMap['USERAGENT']] + '<br />';
				innerHTML += '<strong>Current Page</strong>: ' + jsonData.DATA[i][colMap['CURRENTPAGE']] + '<br />';
				innerHTML += '<strong>Pages in History</strong>: ' + jsonData.DATA[i][colMap['PAGEHISTORY']].length + '<br />';
				
				var tableHead = '<table style="width: 465px; display: block; overflow: hidden; white-space: nowrap;" cellpadding="0" cellspacing="2" border="0">';
				var tableFoot = '</table>';
				
				if(jsonData.DATA[i][colMap['PAGEHISTORY']].length){
					innerHTML += tableHead;
				
					for(var j=0; j<jsonData.DATA[i][colMap['PAGEHISTORY']].length; j++){
						innerHTML += '<tr><td valign="top" >' + jsonData.DATA[i][colMap['PAGEHISTORY']][j].PAGETIME + 's ' + '</td>' ;
						innerHTML += '<td >' + jsonData.DATA[i][colMap['PAGEHISTORY']][j].PAGE + '</td></tr>';
					}
					
					innerHTML += tableFoot;
				}
				
				$('#detail').html(innerHTML); 
			}
		}
	}
	
	$(document).ready(function(){
		getData();	
		//scroll the message box to the top offset of browser's scrool bar
		
		$(window).scroll(function(){				  
		  	$('#detail').animate({top:($(window).scrollTop()+ 47 )+"px" },{queue: false, duration: 100});
		});
	});
</script>

</body>
</html>