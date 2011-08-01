from countershape.doc import *
import countershape

from countershape import  markup
this.titlePrefix = ns.titlePrefix + "[Build | Preview] "

ns.blk_sidemenu = countershape.widgets.SiblingPageIndex(
                '/build/preview/partitioning.html',
        )


pages = [
    Page("partitioning.md",
        title="1. Partitioning", 
        pageTitle="Drive Partitioning"),
        
    Page("removablestorage.md",
        title="2. Removable", 
        pageTitle="Removable Storage"),
        
    Page("packagemanagement.md",
        title="3. Packages", 
        pageTitle="Package Management"),
        
    Page("usermanagement.md",
        title="4. Users", 
        pageTitle="User Management"),
        
    Page("afterboot.md",
        title="5. After Boot", 
        pageTitle="After Boot"),
        
    Page("misc.md",
        title="6. Miscellaneous", 
        pageTitle="Miscellaneous"),
        
    Page("multiboot.md",
        title="7. Dual Boot", 
        pageTitle="Dual Boot"),
        
    Page("rc.conf.md",
        title="8. Start Up", 
        pageTitle="Start Up Configuration"),
        
    Page("hardware.md",
        title="9. Hardware Tests", 
        pageTitle="Hardware Tests"),
        
    Page("cryptpart.md",
        title="10. Cyphered Disks", 
        pageTitle="Encrypting Partitions"),
        
 ]
