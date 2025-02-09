extends Node


# BUG:
# Right now, this script simply sends all drones to the single resource_site
# by hardcoding everything.  This behavior should be calling each drone's
# individual decision-making "What am I doing next?" function


@onready var drone = $Drone  # Actor/Mover
@onready var resource_site = $Site_Iron  # Target


func _ready() -> void:
	get_tree().call_group("drones", "start_job")

func _physics_process(_delta: float) -> void:
	# Move Drones toward the Resource Sites.  
	# TODO: This is temporary code for prototyping.
	#get_tree().call_group("drones", "set_movement_target", resource_site.global_transform.origin)
	pass


# Perhaps a better way to implement this is to implement a Game Tick
# mechanism here, and on every Timer.timeout() or "Tick", we call
# get_tree().call_group("drones", "do_task")
# and each drone processes that, based on it's current job tasking
# and executes accordingly.  So, if harvesting, it does a single harvest()
# function call.
