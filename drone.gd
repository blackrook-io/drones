extends CharacterBody3D


@onready var nav_agent: NavigationAgent3D = get_node("NavigationAgent3D")
@onready var timer: Timer = get_parent().get_node("Global_Tick_Timer")
# TODO:  Need to pass a resource_site object.  From that task_target, we can
#        know the attributes of that object (such as the Resource present,
#        and the amount of that Resource).

@export var movement_speed: float = 1.0
@export var drone_state = "IDLE"

@onready var site_iron: StaticBody3D = %Site_Iron
@onready var site_storage: StaticBody3D = %Site_Storage

var job: Dictionary
var HARVEST_AMOUNT: int = 10
var inventory:Inventory = Inventory.new()


enum {
	IDLE,
	HARVEST,
	TRANSPORT,
	MOVE,
	DELIVER
}


func _ready() -> void:
	add_to_group("drones")
	nav_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	
	# Subscribe to the Global_Tick_Timer signal.
	# timer.timeout.connect()

func _process(_delta: float) -> void:
	pass
	#match drone_state:
		#IDLE:
			## Play idle animation
			#pass
		#HARVEST:
			## Play loading animation
			#pass
		#TRANSPORT:
			## Move with load
			#pass
		#MOVE:
			## Move without load
			#pass
		#DELIVER:
			## Play unloading animation
			#pass


func _physics_process(_delta: float) -> void:
	# Do not query when the map has never synchronized and is empty.
	if NavigationServer3D.map_get_iteration_id(nav_agent.get_navigation_map()) == 0:
		return

	if drone_state == "IDLE":
		if job:
			print("Drone: Executing Job ", job.number)
			return
		else:
			print("Drone: state is IDLE but no Job.")
			return

	if drone_state == "MOVE":
		if nav_agent.is_navigation_finished():
			# TODO: Maybe this should be a Collision check on the source? A signal?
			print("Drone: Navigation finished.")
			drone_state = "HARVEST"  # BUG:  This doesn't work when we are arriving at the (target) site_storage location!
			set_movement_target(job.target.global_transform.origin)
			return
		else:
			var next_path_position: Vector3 = nav_agent.get_next_path_position()
			var new_velocity: Vector3 = global_position.direction_to(next_path_position) * movement_speed
			if nav_agent.avoidance_enabled:
				nav_agent.set_velocity(new_velocity)
			else:
				_on_velocity_computed(new_velocity)
				return


# BUG: This is called from world.gd _physics_process setting it to the
# resource_site.global_transform.origin
func set_movement_target(movement_target: Vector3):
	print("Drone: set_movement_target called ", movement_target)
	nav_agent.set_target_position(movement_target)


func _on_velocity_computed(safe_velocity: Vector3):
	velocity = safe_velocity
	move_and_slide()


func _harvest_resource(resource_site, harvest_amount):
	if resource_site.harvest_resource(harvest_amount):
		inventory.add_item(resource_site.RESOURCE, harvest_amount)


func _deliver_resource():
	pass


func _on_global_tick_timer_timeout() -> void:
	if drone_state == "HARVEST":
		if job.source.harvest_resource(HARVEST_AMOUNT):
			inventory.add_item(job.source.RESOURCE, HARVEST_AMOUNT)
			print("Drone: Harvested ", HARVEST_AMOUNT, " ", job.source.RESOURCE)
			return
		else:
			print("Drone: Harvest unsuccessful, Resource Site depleted.")
			set_movement_target(job.target.global_transform.origin)
			drone_state = "MOVE"


func start_job():
		# If no Job, get one.
	if !job:
		job = {
			"number" : 1,
			"type" : "HARVEST",
			"cargo_type" : "Fe",
			"source" : site_iron,
			"target" : site_storage
		}
		print("Starting new Job.")
	else:
		print("Starting existing Job.")
	
	set_movement_target(job.source.global_transform.origin)
	# This should be pulled, somehow, from the Job template of Tasks.
	drone_state = "MOVE"
