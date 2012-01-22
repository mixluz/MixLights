**MixLights** is a simple iOS app that communicates with a TCP-to-DALI bridge
to control fluorescent lamps via iPhone/iPad.

The TCP-to-DALI bridge is made of a Digi Connect ME ([see digi.com](http://www.digi.com/products/wireless-wired-embedded-solutions/solutions-on-module/digi-connect/digiconnectme#overview))
to interface TCP to a serial port. This serial port is then connected
to a Serial-to-DALI PIC-based bridge circuit built according to
Microchip Application Note [AN811](http://www.microchip.com/stellent/idcplg?IdcService=SS_GET_PAGE&nodeId=1824&appnote=en012007).

The PIC code of the bridge has been modified to support 4 additional
commands (three returning a acknowledge byte after sending data is complete,
so the iOS app can pace its sends, 0x30,0x31,0x33, and a query command
that returns only one instead of 2 bytes answer, 0x32).
Contact me if you want to build something like this and actually need the modified
PIC sources; eventually, I'll add them here when I find time to clean
everything up.

**The main use for publishing this code is as an example how to do
the binary (random) search for DALI devices**.

I could not find a description
or sample code so I had to figure it out myself. See assignAddressRandom
and assignAddressPhysical methods in FlipsideViewController.m.
Note that phsyical selection seems to have a bug with Osram EVGs
(all units respond to PROGRAM SHORT ADDRESS in Physical Selection Mode,
instead of only the selected one). That's why the physical selection
is not wired to a UI button at this time.

[![Flattr this git repo](http://api.flattr.com/button/flattr-badge-large.png)](https://flattr.com/submit/auto?user_id=luz&url=https://github.com/mixluz/MixLights&title=MixLights&language=&tags=github&category=software)

October 2010-Jan 2012, luz@mixwerk.ch