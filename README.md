Magda Sánchez
Colaborativa
July 2011

Code developed using Arduino v0022 and processing language. This repository contains the code for controlling five Like Box unit, each is made up of one Arduino ethernet and two ht1632 Matrix Display from sure electronics. The code needs to be customized with the Remote Server IP address, the Arduino MAC addresses and the php script calls that update the facebook or twitter information.

--------------------
LED MATRIX DISPLAY
--------------------
For Programming the Led Matrix Display with the HT1632 Microcontroller we have used the following library found on GitHub, we thank Gauravmm for sharing his code, it is an excellent library.

https://github.com/gauravmm/HT1632-for-Arduino

--------------------
STRING LIBRARY
--------------------
We do not use the processing string library for managing string of characters. This is due to some bugs when reusing strings in Arduino v0022.
Therefore we use the C language string approach, only fixed string/static size are allocated along the code, we do not use dynamic pointers. It words perfectly, no memory leakage at all.
For more information read this post:
http://www.magdasanchez.es/2011/12/arduino-0022-problems-coming-from-string-and-serial-libraries/
