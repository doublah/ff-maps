Title                   : conc_school
Date                    : 9-12-2009
Filename                : conc_school.bsp
Author                  : Alex "Dr.Satan" Laswell
Email Address           : alaswell@dctrs8tnc.om
Description             : Conc Map - This map is designed to be helpful to the new players who are generally lost when playing in a concmap. Hopefully it will help!

================================================================
conc_school changelog 9/12/2009

* final version released
* removed the interest and overview images being blurry for some players
* fixed top floor of juggle missing lighting
* fixed the water not showing up in previous final versions
* added numbered signs to all jumps 
* removed some cubemaps (had way too many in the map)

Known issues:

* players can get stuck in an infinite loop of hitting water on certain jumps 
	+ this is a physics issue that would mess up the mobility of the jumps if I fixed it. It has been left alone on purpose.
* prop_physics in final_room do not show up like they do in the .vmf 
	+ I kinda like the effect this makes, so I've decided to leave it in. 

_b3 changelog 6/27/2009:

* fixed welcome_slate 
* fixed points_of_interest and overview flythrough
* fixed interest and overview image missing
* added signs at each jump 

Known issues:

* top floor of juggle missing lighting
* players can get stuck in an infinite loop of hitting water on certain jumps

_b2 changelog 6/2/2008:

* fixed map overview
* fixed prop_static in end room not touching floor
* fixed location_jump7 - '¿' is not recognized by the game
* fixed location_jump15 - triple was spelled wrong (tripple)
* added missing chalkboard model texture

Known issues:

* welcome_slate says "coresponds with the jump..." should be spelled corresponds
* points_of_interest flythrough is not working (need to add a new path_mapguide entity and tie it to "1" and tie "15" back to it)
* chairs in finish room don't show up like in the .vmf (finish board would need changing and props need lifted up to be mesh with the floor)


Credits:

* Jester for compiling and testing _b2
* A1win for allowing me to use his map (ff_juggle_this) in mine
* Squeek, pon, Jester, Crazy Carl, Sh4x for all their help with the .lua and other mapping issues I had
* [AE] 82694 for compiling this for me when my computer couldn't handle it! 
* GambiT for help with optomizing this! 
* geokill, jester, firefox11, and others for poiting out issues with _b1
* Anyone else I missed!

Email with comments or questions.
alaswell@dctrs8tn.com

You may distribute this map in anyway you see fit. However, you MUST include this readme with it!