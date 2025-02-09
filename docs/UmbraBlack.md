# UmbraBlack
The goal is to build a simulation game where drones are built, tasked and managed by the player.  Starting with a set amount of resources, the player builds drones, creates Tasks for them to complete (sometimes indefinitely in the form of Jobs). 

**Game genre and themes includes sandbox simulation, base-building, exploration, attack/defense(?), technology research, idle play.**

New facilities can be established to expand operations, to spread the hive and ensure longevity. Technologies can researched and honed to provide new capabilities or lower costs of current operations.

Manufacturing shall be simplified so that it does not need to be realistic (no complex 'recipe' trees) and more flexible.  Think of 4D games where a handful of resources are combined or required in various amounts to complete tasks. The goal here is expandability and flexibility, so that all resources are valuable, not just a key few. These resources might be abstracted and non-realistic names, to diverge from any criticism of "realistic" requirements and adherence to real-world chemistry and manufacturing. 

Player begins with a single starting source Facility on an asteroid in a field, starting resource pools, starting technology capabilities.  Those starting resources should help them begin their path on expansion.  Differing difficulties will influence starting resources.  Gathering the resources, the player can either build things, or find a way to market those items.

In the area there will be multiple targets for exploration, survey and developing operational annex facilities.  The goal is to expand the hive, establish longevity and fend off possible future rival drone colony attacks.

## Story background

Humans expanded and left earth, exploring the galaxy.

In one remote system, they found a planet torn apart by the gravitational field of a larger gas giant, turning the planet into a ring system rich in materials and elements.

An effort was made, using drones, to start mining that ring system, but something happened to the human settlers that erased them from the system.

Game picks up in the future, as the 'hive' or 'colony' or 'initial settlement' comes out of the umbra of the planet to be exposed to the star's light.  This melts ice that covered solar panels, charging the last remaining drone(s), waking them up.  This is where the player starts, with bare minimum supplies, infrastructure, and resources. 


# Needed Game Code

## Decision-making logic engine for driving drones
"Processor" logic engine for continuous industrial processes such as refining, manufacturing, harvesting, etc.  Thus, when combining two resources into a third, this engine decrements the two resources and increments the third, provided that the "processing check" passes.  

"Processing checks" can introduce failures, problems in the manufacturing chains, shortages, breakdowns, etc.  Chaos in the system so that not everything runs smoothly.  

## Movement-along-path engine
This engine checks each mobile game unit, checks for various interrupters (enemy, combat, path block), and then moves the unit a set amount along their current path.

## Hive task and job engine
Hives should be smart enough to decide for themselves what major tasks need to be completed or undertaken, but not to an 'AI' level, as this is still a game for the player.  They should be autonomously reactive to the game environment via various stimulus, for example prioritizing defense when attacked, prioritizing specific resource gathering during shortages, and building/repairing facilities when needed.

## System for exploration and survey
The game should have a randomizing/procedural engine for generating locations for exploration for the drones. This should result in a storable 'map' of a location, dictating what is available where.  Surveying the location will reveal what is available.  From there, the drones can start doing things with the located resources.  To keep it simple, exploration and survey can be randomized with some chaos and risk, but the longer a drone studies a location, the chances of finding any present resources goes up with time.  

## Data/world persistence
Need to be able to survive a crash or shutdown, cleanly starting up after, and only losing a very short amount of game world time passage.


# Graphics style
## 3D Style
Blocks or cubes, perhaps a icosohedron or triangle-based globes for Orbital bodies.  The models from Blender are simple primitives, not a lot of geometry, and instituting LOD model variants.  Things are gray until scanned or surveyed, depending on the object type, then findings show up in color.

Locations and Resource sites will show up, after being successfully surveyed, as colored locations on the surface (heat map style 'strength').  Further surveying can reveal the entirety of a 'vein' of a Resource, and when that is complete, the surface of the Orbital turns translucent to show the size/strength of the vein found. As a site is mined out, this 'spiderweb' of color under the surface should 'dry up'.

Maps of Resources are procedural-generated randomly for each player at each Orbital during the initial survey that is successful.  

Splash screen idea:  Translucent atmosphere layer over a gray surface, with color tendrils representing Resources located through survey, with an Extractor structure.


# Economy
## Resource Locations
Resource locations are unique findings for each player in a multi-player environment, generated for that player at that Orbital once the Orbital is surveyed for the first time successfully.  Resources and existing Facilities on that Orbital then need to be scanned down using survey drones or from orbit (which takes longer).  Resource sites, whether they have another player's Facility on it or not, are visible if scanned down.

Once a Resource has a Facility built on it, that Resource cannot be built on (due to Facility safe zone radius).  However, this may inspire other players to attack and destroy an established player Facility.

## Resource Visuals
Surfaces of Orbitals are gray until surveyed, then findings show up in color (heat map style 'strength').  Further surveying can reveal the entirety of a 'vein' of a Resource, and when that is complete, the surface of the Orbital turns translucent to show the size/strength of the vein found.  As a site is mined out, this 'spiderweb' of color under the surface should 'dry up', shrinking back to the site where the extractor facility is located.  When fully mined out (which should take months), the color disappears and the Facility shuts down with a Notification.

Unowned Resource veins are only visible when a drone is in the vicinity of that location, actively scanning periodically.

# App Development
## Release Names
Proximus  (0.1 - 0.9)
Dawn      (1.0)
Genesis   (2.0)
Scorpius  (3.0)

## Icon Production
https://cloudconvert.com provides a way to convert png files to icns, and allows for all OSes (.icns for Mac, .ico for Windows, Linux uses png already, all at 256x256px).  A single high-res (1024px) png image is all that is required to generate all the icon files that the app will need.

## Soundtrack
The game background soundtrack will be entirely by Stellardrone, with heavy documentation and links to his work on SoundCloud.  Players can of course turn off background music.

## UI Sounds
Will need to source a UI pack from Sonniss.com, preferably something that is very drone-ish.  Might also need some atmospheric sounds.

## Update Server
AWS or GCP server (with a DNS pointer) with a public S3 fileshare for downloads.  Can also use a public repo on GitHub to utilize the Releases section, without uploading the game code, just a README.md.  Game should automatically check for both code and data updates in the background, notifying the player on downloads in the background.  Data downloads should be automatic, but code updates are optional.
