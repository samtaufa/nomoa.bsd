from countershape.doc import *
import countershape

this.titlePrefix = ns.titlePrefix + "[Build | Install] "

ns.blk_sidemenu = countershape.widgets.SiblingPageIndex(
                '/build/install/useradmin.html',
        )


pages = [

    Page("checklist.md", 
        title="Checklist", 
        pageTitle="Checklist"),    
		
    Page("useradmin.md", 
        title="User Admin", 
        pageTitle="User Administration"),    

    Page("usercreate.md",
        title="User Creation", 
        pageTitle="User Creation"),
            
    Page("userdelete.md",
        title="User Deletion", 
        pageTitle="User Deletion"),
        
    Page("sudoers.md", 
        title="Sudo Users", 
        pageTitle="sudo Users"),
]
