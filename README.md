API Manager
============


API Manager, gui interface to Win32 APIs, to examine or change window properties


Screenshots
-----------

![windows](http://www.benibela.de/img/tools/apiv.gif) ![processes](http://www.benibela.de/img/tools/apiv2.gif)


Installation
------------

The easiest is to download the provided [binaries from my home page](http://www.benibela.de/tools_en.html#apim).

To compile it you need Lazarus.


Example usages
-----------

APIM provides access to most of the GUI related functions of the Win32 API, for the windows of all processes.


You can e.g. select a window, and enable the stay-on-top and transparency flags for it. 

Or you can kill a process.

Or you can select the start button and make it invisible.

Or on older Windows version, you can select an edit box containing a password, and disable the password flag, letting you see the password in plaintext. (it uses dll injection, to also show the password in not trivial cases)


