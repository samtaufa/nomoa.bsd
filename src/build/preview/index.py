from countershape.doc import *
import countershape

from countershape import  markup
this.markup = markup.Markdown(extras=["code-friendly"])
this.titlePrefix = ns.titlePrefix + "[Build | Preview] "

ns.blk_sidemenu = countershape.widgets.SiblingPageIndex(
                '/build/preview/partitioning.html',
        )


pages = [
    Page("partitioning.mdtext",
        title="1. Partitioning", 
        pageTitle="Drive Partitioning"),
        
    Page("removablestorage.mdtext",
        title="2. Removable", 
        pageTitle="Removable Storage"),
        
    Page("packagemanagement.mdtext",
        title="3. Packages", 
        pageTitle="Package Management"),
        
    Page("usermanagement.mdtext",
        title="4. Users", 
        pageTitle="User Management"),
        
    Page("afterboot.mdtext",
        title="5. After Boot", 
        pageTitle="After Boot"),
        
    Page("misc.mdtext",
        title="6. Miscellaneous", 
        pageTitle="Miscellaneous"),
        
    Page("multiboot.mdtext",
        title="7. Dual Boot", 
        pageTitle="Dual Boot"),
        
    Page("rc.conf.mdtext",
        title="8. Start Up", 
        pageTitle="Start Up Configuration"),
        
    Page("hardware.mdtext",
        title="9. Hardware Tests", 
        pageTitle="Hardware Tests"),
        
    Page("cryptpart.mdtext",
        title="10. Cyphered Disks", 
        pageTitle="Encrypting Partitions"),
        
 ]
