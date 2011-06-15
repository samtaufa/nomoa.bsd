from countershape.doc import *
import countershape

this.titlePrefix = ns.titlePrefix + "[Build | Install] "

ns.blk_sidemenu = countershape.widgets.SiblingPageIndex(
                '/build/install/useradmin.html',
        )


pages = [

    Page("checklist.mdtext", 
        title="Checklist", 
        pageTitle="Checklist"),    
		
    Page("useradmin.mdtext", 
        title="User Admin", 
        pageTitle="User Administration"),    

    Page("usercreate.mdtext",
        title="User Creation", 
        pageTitle="User Creation"),
            
    Page("userdelete.mdtext",
        title="User Deletion", 
        pageTitle="User Deletion"),
        
    Page("sudoers.mdtext", 
        title="Sudo Users", 
        pageTitle="sudo Users"),
]
