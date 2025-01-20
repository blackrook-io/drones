extends CanvasLayer

@onready var drone: CharacterBody3D = %Drone
@onready var inventory_dialog: InventoryDialog = %InventoryDialog


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("Inventory"):
		inventory_dialog.open(drone.inventory)
