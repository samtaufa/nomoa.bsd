
<!-- begin: template: _frontpage.tpl -->

<div id="doc2" class="yui-t5">  <!-- #doc2 = 950px width, centered, .yui-t5 240px on right -->
    <div id="hd" role="banner">
        $!blk_banner!$
	</div>   <!--  _frontpage.tpl:  hd.banner -->
    <div id="bd">   
		<div id="yui-main">   
			<div class="yui-b" role="main">
				<div class="yui-g">$!body!$
				</div>  <!--  end: _frontpage.tpl: yui-main.yui.g -->
			</div>  <!--  end: _frontpage.tpl: yui-main.yui.b -->
		</div>  <!--  end: _frontpage.tpl: yui-main -->
		<div class="yui-b">
$!blk_relatedsites!$
		</div>   <!--  end: _frontpage.tpl: yui.b -->
     </div>  <!-- end: _frontpage.tpl:  bd.main -->
    <div id="ft" role="contentinfo">
        $!blk_footer!$
	</div>   <!--  end: _frontpage.tpl: contentinfo -->
</div>  <!-- end: _frontpage.tpl: doc2.yui-t5 -->

<!-- end: template: _frontpage.tpl -->
