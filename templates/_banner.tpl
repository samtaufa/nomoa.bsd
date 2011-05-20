
<!-- begin: template: _banner.tpl -->

<div id="navBar">
    <div id="navBarContent">   
        <a href="$!homelink!$" style="float:right"
            onMouseOver="changeImages('openbsd', '@!urlTo("media/images/banner/openbsd.hover.gif")!@' ); return true;"
            onMouseOut="changeImages('openbsd', '@!urlTo("media/images/banner/openbsd.gif")!@' ); return true;"
            onMouseDown="changeImages('openbsd', '@!urlTo("media/images/banner/openbsd.click.gif")!@' ); return true;"
            onMouseUp="changeImages('openbsd', '@!urlTo("media/images/banner/openbsd.gif")!@' ); return true;">
            <img src= '@!urlTo("media/images/banner/openbsd.gif")!@' alt="OpenBSD ... The Only way to Go ..."
                border="0" height="50"  width="368" />
        </a>
        <!-- Navigation Line One -->
        <div id="navBarLineOne"> 
            @!blk_menubar!@ 
        </div>
        <div class="clear"></div>
        <!-- Navigation Line Two -->
        <div id="navBarLineTwo"> 
            @!blk_submenu!@ 
        </div>
    </div>
    <div class="clear"></div>
</div>
<!-- end: template: _banner.tpl -->
