First, download the appropriate firmware from the CISCO website. You will need
to be a registered user to do this. In most cases you want the "Advanced IP
Services" image.

If you are using minicom, make sure you have the lrzsz package installed, which
implements the ymodem implementation we use below.

<pre class="command-line">
>
> enable 
# terminal speed 115200
# copy ymodem: flash:filename
# configure terminal
(config)# boot system flash:filename
(config)# exit
# copy running-config startup-config
# reload
</pre>

If the image you downloaded is a tarball, you will need to untar it once it's
on the switch. Note that the filename that should be used for the __boot__
command is that of the .bin image that will be extracted:

<pre class="command-line">
# archive tar /xtract flash:tarball
</pre>

If the flash filesystem is full, you may need to do something like this to
clear space:

<pre class="command-line">
#dir flash:
#delete flash:filename
</pre>