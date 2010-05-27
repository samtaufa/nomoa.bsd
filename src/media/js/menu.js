////////////////////////////////////////////////
//  DHTML MENU BUILDER 2.5.126                //
//  (c)xFX JumpStart                          //
//                                            //
//  PSN: 198657-TWB-4089-5A59                 //
//                                            //
//  GENERATED: 23/05/2001 - 11:37:50 AM       //
////////////////////////////////////////////////

	
	var nStyle = new Array;
	var hStyle = new Array;
	var nLayer = new Array;
	var hLayer = new Array;
	var NSLayerCW = 0;
	var NSLayerCH = 0;
	
	var ParentMenu = '';
	var CurMenu = '';
	var tCmd = '';
	var cCmd = '';
	var AnimStep = 0;
	var as = 0;
	var DoFormsTweak = false;
	
var BV=parseInt(navigator.appVersion);
var BN=window.navigator.appName;
var IsMac=(navigator.userAgent.indexOf('Mac')!=-1)?true:false;
var Opera=(navigator.userAgent.indexOf('Opera')!=-1)?true:false;
var NS=(BN.indexOf('Netscape')!=-1&&(BV==4)&&!Opera)?true:false;
var IE=(BN.indexOf('Explorer')!=-1&&(BV>=4)&&!Opera)?true:false;

	
	if ((frames.length==0) && IsMac) {
	frames.top = window;
	}
	var mFrame = eval(frames['top']);
	var cFrame = eval(frames['top']);
	
	var fx = 1;


	
	nStyle[0]="border: 1px;  font-family: Tahoma; font-size: 9pt; font-weight: none; font-style: none; color: #000000; background-color: #C0C0C0; cursor: hand";
	hStyle[0]="border: 1px;  font-family: Tahoma; font-size: 9pt; font-weight: none; font-style: none; color: #FFFFFF; background-color: #0000FF; cursor: hand;";
	nLayer[1]="<p align=left><font face=Tahoma point-size=9 color=#000000>Web Server</font>";
	hLayer[1]="<p align=left><font face=Tahoma point-size=9 color=#FFFFFF>Web Server</font>";

	
	function HideAll() {
		if(!as) {
			Hide('mnuDynamicWeb');
		}
	}


	function GetCurCmd() {
		//IE
		//This function will return the current command under the mouse pointer. It will return null if the mouse is not over any command.
		//------------------------------
		//Version 1.3
		//
		
		if(event==null)
			var cc = mFrame.window.event.srcElement;
		else
			var cc = window.event.srcElement;
		while((cc.id=="") && (cc.tagName!="TD")) {
			cc = cc.parentElement;
			if(cc==null)
				break;
		}
		return cc;
	}

	function HoverSel(mode, imgName) {
		//IE
		//This is the function called every time the mouse pointer is moved over or away from a command.
		//------------------------------
		//mode: 0 if the mouse is moving over the command and 1 if is moving away
		//imgName: Name of the image object, if any, used in the selected command
		//------------------------------
		//Version 7.2
		//
		var mc = GetCurCmd();
		var img = new Image;
		var imgRsc = new Image;
		
		with(mc) {
			if(mode) {
				style.background = "";
				style.cssText = nStyle[id];
				if(imgName!=''){imgRsc = eval(imgName+"Off");}
			} else {
				style.cssText = hStyle[id];
				if(imgName!=''){imgRsc = eval(imgName+"On");}
			}
		}
		if(imgName!='') {
			img = eval("mFrame.document.images."+imgName);
			img.src = imgRsc.src;
		}
		cCmd = mc;
	}

	function NSHoverSel(cNSCmd, mode, n, bcolor, w, h) {
		//NS
		//This is the function called every time the mouse pointer is moved over or away from a command.
		//------------------------------
		//cNSCmd: Name of the layer that corresponds to the selected command
		//mode: 0 if the mouse is moving over the command and 1 if is moving away
		//n: Unique ID that identifies this command. Used to retrieve the data from the nLayer or hLayer array.
		//bcolor: Background color of the command. Ignored if the group uses a background image.
		//w: Width of the command's layer.
		//h: Height of the command's layer.
		//------------------------------
		//Version 9.4
		//
		if(mode)
			var LayerHTM = nLayer[n];
		else
			var LayerHTM = hLayer[n];
		
		if(cCmd!=cNSCmd || mode) {
			cNSCmd.document.open();
			cNSCmd.document.write(LayerHTM);
			cNSCmd.document.close();
			if(!mode)
				cNSCmd.bgColor = bcolor;
			else
				if(cNSCmd.parentLayer.background.src!="")
					cNSCmd.bgColor = null;
				else
					cNSCmd.bgColor = bcolor;
			cNSCmd.resizeTo(w,h);
		}
		cCmd=cNSCmd;
	}

	function Hide(menuId) {
		//IE,NS
		//This function hides the group identified by the menuId parameter.
		//It also resets the values of the CurMenu and ParentMenu variables to reflect the changes of the hidden menu.
		//------------------------------
		//menuId: Name of the group's <div> or <layer> to be hidden.
		//------------------------------
		//Version 1.6
		//
		if(IE)
			var Menu = mFrame.document.all[menuId].style;
		
		if(NS)
			var Menu = mFrame.document.layers[menuId];
		
		with(Menu)
			visibility = "hidden";
		if(ParentMenu!='') {
			CurMenu = ParentMenu;
			ParentMenu = '';
			tCmd = '';
		} else {
			cCmd = '';
			CurMenu = '';
		}
	}

	function DoClear() {
		//IE,NS
		//This function resets the variables use to know which menus are being displayed and also hides all the currently visible menus.
		//------------------------------
		//Version 1.0
		//
		tCmd = '';
		ParentMenu = '';
		HideAll();
	}

	function ShowMenu(menuId, x, y, isCascading) {
		//IE,NS
		//This is the main function to show the menus when a hotspot is triggered or a cascading command is activated.
		//------------------------------
		//menuId: Name of the <div> or <layer> to be shown.
		//x: Left position of the menu.
		//y: Top position of the menu.
		//isCascading: True if the menu has been triggered from a command, and not from a hotspot.
		//------------------------------
		//Version 12.7
		//
		if(IE) {
			cCmd = GetCurCmd();
			if(cCmd==tCmd)
				return;
		}
		if(as) {
			window.clearTimeout(as);
			as = 0;
		}
		if(isCascading) {
			if(ParentMenu!="")
				Hide(CurMenu);
			ParentMenu = CurMenu;
			tCmd = cCmd;
		} else
			DoClear();
		if(IE) {
			var Menu = mFrame.document.all[menuId].style;
			if(isCascading)
				var pMenu = mFrame.document.all[CurMenu].style;
			with(Menu) {
				if(isCascading) {
					left = parseInt(pMenu.left) + parseInt(pMenu.width) - 6;
					top =  y + parseInt(pMenu.top) - 5;
				} else {
					left = x;
					top =  y;
				}
				if(!IsMac)
					clip = "rect(0 0 0 0)";
			}
		}
		if(NS) {
			var Menu = mFrame.document.layers[menuId];
			var pMenu = mFrame.document.layers[CurMenu];
			with(Menu.clip) {
				NSLayerCW = width;
				NSLayerCH = height;
			}
			if(isCascading) {
				x = pMenu.left + pMenu.clip.width;
				y = pMenu.top + cCmd.top;
			} else {
				x = parseInt(x);
				y = parseInt(y);
			}
			Menu.moveToAbsolute(x,y);
		}
		CurMenu = menuId;
		Menu.visibility = "visible";
		if(isCascading)
			Menu.zIndex = parseInt(pMenu.zIndex) + 1;
		if(IE && !IsMac)
			as = window.setTimeout("Animate('" + menuId + "')", 10);
		FormsTweak("hidden");
	}

	function Animate(menuId) {
		//IE,NS
		//This function is called by ShowMenu every time a new group must be displayed and produces the predefined unfolding effect.
		//Currently is disabled for Navigator, because of some weird bugs we found with the clip property of the layers.
		//------------------------------
		//menuId: Name of the <div> or <layer> to be animated.
		//------------------------------
		//Version 1.3
		//
		var r = '';
		var nw = nh = 0;
		switch(fx) {
			case 1:
				if(IE) r = "0 " + AnimStep + "% " + AnimStep + "% 0";
				if(NS) nw = AnimStep; nh = AnimStep;
				break;
			case 2:
				if(IE) r = "0 100% " + AnimStep + "% 0";
				if(NS) nw = 100; nh = AnimStep;
				break;
			case 3:
				if(IE) r = "0 " + AnimStep + "% 100% 0";
				if(NS) nw = AnimStep; nh = 100;
				break;
			case 0:
				if(IE) r = "0 100% 100% 0";
				if(NS) nw = 100; nh = 100;
				break;
		}
		if(IE)
			mFrame.document.all[menuId].style.clip =  "rect(" + r + ")";
		if(NS)
			with(mFrame.document.layers[menuId].clip) {
				width = NSLayerCW*(nw/100);
				height = NSLayerCH*(nh/100);
			}
		AnimStep += 20;
		if(AnimStep<=100)
			as = window.setTimeout("Animate('" + menuId + "')",25);
		else {
			window.clearTimeout(as);
			as = 0;
			AnimStep = 0;
		}
	}

	function InMenu(mX, mY, m) {
		//IE,NS
		//This function returns true if the mouse pointer is over a group.
		//------------------------------
		//mX: Current X position of the mouse pointer.
		//mY: Current Y position of the mouse pointer.
		//m: <div> or <layer> object to be tested.
		//------------------------------
		//Version 1.2
		//
		var l = parseInt(m.left);
		var r = l+((IE)?parseInt(m.width):m.clip.width);
		var t = parseInt(m.top);
		var b = t+((IE)?parseInt(m.height):m.clip.height);
		return ((mX>=l && mX<=r) && (mY>=t && mY<=b));
	}

	function HideMenus(e) {
		//IE,NS
		//This function checks if the mouse pointer is on a valid position and if the current menu should be kept visible.
		//The function is called every time the mouse pointer is moved over the document area.
		//------------------------------
		//e: Only used under Navigator, corresponds to the Event object.
		//------------------------------
		//Version 23.9
		//
		if(IE) {
			if(event==null)
				var e = mFrame.window.event;
			else
				var e = event;
			var mX = e.clientX + mFrame.document.body.scrollLeft;
			var mY = e.clientY + mFrame.document.body.scrollTop;
			if(CurMenu!="")
				var lm = mFrame.document.all[CurMenu].style;
			if(ParentMenu!="")
				var pm = mFrame.document.all[ParentMenu].style;
		}
		if(NS) {
			var mX = e.pageX + window.pageXOffset;
			var mY = e.pageY + window.pageYOffset;
			var lm = mFrame.document.layers[CurMenu];
			if(ParentMenu!="")
				var pm = mFrame.document.layers[ParentMenu];
		}
		
		if(CurMenu!='' && cCmd!='' && !as) {
			if(ParentMenu=='') {
				if(!InMenu(mX, mY, lm))
					Hide(CurMenu);
			} else {
				if(!InMenu(mX, mY, lm) && (cCmd!=tCmd)) {
					Hide(CurMenu);
					return;
				} else {
					if(!InMenu(mX, mY, lm) && !InMenu(mX, mY, pm))
						HideAll();
				}
			}
		}
	}

	function FormsTweak(str) {
		//IE
		//This is an undocumented function, which can be used to hide every form element on a page.
		//This can be useful if the menus will be displayed over an area where is a combo box, which is an element that cannot be placed behind the menus and it will always appear over the menus resulting in a very undesirable effect.
		//------------------------------
		//Version 1.0
		//
		if(DoFormsTweak)
			for(var i = 0; i <= (mFrame.document.forms.length - 1); i++)
				mFrame.document.forms[i].style.visibility = str;
	}

	function execURL(url, tframe) {
		//IE,NS
		//This function is called every time a command is triggered to jump to another page or execute some javascript code.
		//------------------------------
		//url: Encrypted URL that must be opened or executed.
		//tframe: If the url is a document location, tframe is the target frame where this document will be opened.
		//------------------------------
		//Version 1.0
		//
		DoClear();
		window.setTimeout("execURL2('" + url + "', '" + tframe + "')", 100);
	}

	function execURL2(url, tframe) {
		//IE,NS
		//This function is called every time a command is triggered to jump to another page or execute some javascript code.
		//------------------------------
		//url: Encrypted URL that must be opened or executed.
		//tframe: If the url is a document location, tframe is the target frame where this document will be opened.
		//------------------------------
		//Version 1.0
		//
		tframe = rStr(tframe);
		var fObj = eval(tframe);
		url = rStr(url);
		if(url.indexOf("javascript")!=url.indexOf("vbscript"))
			eval(url);
		else
			fObj.location.href = url;
	}

	function rStr(s) {
		//IE,NS
		//This function is used to decrypt the URL parameter from the triggered command.
		//------------------------------
		//Version 1.1
		//
		s = xrep(s,"\x1E","'");
		s = xrep(s,"\x1D","\x22");
		s = xrep(s,"\x1C",",");
		return s;
	}

	function xrep(s, f, n) {
		//IE,NS
		//This function looks for any occurrence of the f string and replaces it with the n string.
		//------------------------------
		//Version 1.0
		//
		var tmp = s.split(f);
		return tmp.join(n);
	}

	function PrepareEvents() {
		//NS
		//This function is called right after the menus are rendered.
		//It changes the OnFocus event, set by DHTML Menu Builder, for the OnMouseUp event on every command.
		//------------------------------
		//Version 1.0
		//
		for(var l=0; l<mFrame.document.layers.length; l++) {
			var lo = mFrame.document.layers[l];
			for(var sl=0; sl<lo.layers.length; sl++) {
				var slo = mFrame.document.layers[l].layers[sl];
				if((slo.name.indexOf("MC")==0) && (typeof(slo.onfocus)=="function")) {
					slo.captureEvents(Event.MOUSEUP);
					slo.onmouseup = slo.onfocus;
					slo.releaseEvents(Event.FOCUS);
				}
			}
		}
	}

	function ShowContextMenu() {
		//IE
		//This function is called when a user rightclicks on the document and it will show a predefined menu.
		//
		//Just change the value of this variable to the name of the group
		//you want to display when the user rightclicks on the document.
		var MenuName = 'mnuNav';
						
		ShowMenu(MenuName, event.x, event.y, false);
		return false;
	}

	
	if(IE)
		with(document) {
			open();
			write("<div id=\"mnuDynamicWeb\" style=\"position: absolute; top: 0%; left: 0%; width: 83; height: 24; z-index: 100; visibility: hidden;\"><table id=\"dmbMenu\" background=\"\" border=\"0\" cellpadding=\"1\" style=\"background-color: #C0C0C0; color: #000000; border-left: #E0E0E0 solid 1; border-right: 1 solid #808080; border-top: 1 solid #E0E0E0; border-bottom: 1 solid #808080\" width=\"83\"><tr><td nowrap height=\"18\" align=\"left\" style=\"border: 1px; font-family: Tahoma; font-size: 9pt; font-weight: none; font-style: none; color: #000000; cursor: hand; background-color: #C0C0C0;\" id=\"0\" OnClick=\"frames[\'top\'].execURL(\'apache.html\', \'this\');;\" OnMouseOver=\"frames[\'top\'].HoverSel(0,\'\');window.status=\'Web Server\';\" OnMouseOut=\"frames[\'top\'].HoverSel(1,\'\');window.status=\'\';\">Web Server</td></tr></table></div>");
			close();
		}
	if(NS)
		with(document) {
			open();
			write("<layer name=\"mnuDynamicWeb\" background=\"\" top=\"0%\" left=\"0%\" clip=\"0,0,81,21\" z-index=100  bgColor=\"#C0C0C0\" visibility=\"hidden\"><layer name=MC01EH top=2 left=0 width=81 height=16 z-index=101 OnMouseOut=\"frames[\'top\'].NSHoverSel(frames[\'top\'].document.layers[\'mnuDynamicWeb\'].layers[\'MC01\'],1,1,\'#C0C0C0\',79,16);window.status=\'\';\" OnMouseOver=\"frames[\'top\'].NSHoverSel(frames[\'top\'].document.layers[\'mnuDynamicWeb\'].layers[\'MC01\'],0,1,\'#0000FF\',79,16);window.status=\'Web Server\';\" OnFocus=\"frames[\'top\'].execURL(\'apache.html\', \'this\');\"></layer><layer name=MC01 top=2 left=2 width=77 height=16 z-index=100  bgcolor=\"#C0C0C0\"><p align=left><font face=Tahoma point-size=9 color=#000000>Web Server</font></layer></layer>");
			close();
		}

	

	

	
	if(NS) {
		mFrame.captureEvents(Event.MOUSEMOVE);
		mFrame.onmousemove = HideMenus;
		PrepareEvents();
	}
	document.onmousemove = HideMenus;
	
//This event handler will capture whenever a user tries to
//rightclick anywhere on the document
	document.oncontextmenu = ShowContextMenu;

