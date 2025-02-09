## Structure Management

Production will be a workflow-chain process that the player sets up.  Each Structure will have inputs, outputs, capacities and possibly process rates and requirements.  Structures will be built via a template or by hand (savable as a template) out of Structure types (see below), ala structures in Eve Online Planetary production.  Basic 3D models will be created and available for all of the various Structure types available to the player, and they can slate them for building, linking and activation/tasking.  

	Example: A basic mining structure
	  Extractor(s) --> Storage --> Processor(s) --> Storage --> Transport

	Example: A basic combining structure where multiple elements are combined into two usable outputs
	  Storage ----> Processor --> Storage --> Transport
	  Storage --/             \-> Storage --> (Further processing or transport)
	  Storage --/

Ground installations will be simple mining and production facilities, readying raw or simple materials for shipment.  Everything is basic.  Processing will be a simple 'recipe' of inputs and outputs, with an associated set of costs or requirements.  Creating water out of H and O will require energy, and have a single output, H2O.  Breaking water into H and O2 will have a single input, energy requirements, and two outputs.  

Processors and storage structures can be chained however the player wishes, connected by automated transport 'pipes' between structures.  Pipes will require constant availability of power to the whole, entire facility.  If power is interrupted, pipes may freeze/burst/break and cause maintenance issues, costing time, energy and drone maintenance attention.

Orbital installations can be warehouses of materials, shipping hubs, sale points, transit endpoints into/out of system, fueling stations, complex material production facilities, defense platforms.

Any time that a Structure is assigned a task ('produce <product>', 'mine <element>'), any lacking required materials or elements will trigger workflow interruptions, notifications, alarms.  Any interruptions will require manual intervention to solve the shortage and restart the process.

Linking structures together into a Hive will allow production of goods that are used through the player's world, sold, etc.  

Every structure will have a unique ID and name (player set), for use with queries and commands.

Every structure will have energy requirements that can be solved in various ways:
	solar power
	thermodynamic power
	hydrodynamic power
	turbine power (burning fuels)
The energy grid of an installation is operated by stores of that energy, each hour checked to ensure minimum requirement is present, and based on that hour's requirement vs production, how long the current stores of fuel (turbines only) will last.


Inspirations:
	Eve Planetary Production
	Screeps

Commands:
	```select <colony>```
	```mine <element>```
	```build storage```
	```build processing <element>```
	```build manufacturing <product>```
	```link <structure> to <structure>```
	```build launchpad```
	```supply <product|item> to <other location>```

Structure build requirements:
	materials for the build of the structure
	energy to fuel the build process
	drones to do the building, the more drones, the quicker the build`
	direction on type of structure and any designations given
	arrangement (3D position if in space/2D position if on ground, angle)

Structure attributes:
	inputs []
	output []
	capacity []
	contents []
	status []
	rate []

Structure types:
	Solar array
	Heat exchanger
	Dam
	Powerplant
	Refinery
	Extractor
	Collector
	Storage silo
	Processor
	Assembler
	Refinery
