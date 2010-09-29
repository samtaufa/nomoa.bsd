from countershape.doc import *

this.titlePrefix = ns.titlePrefix + "[Build | Install] "

pages = [

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
