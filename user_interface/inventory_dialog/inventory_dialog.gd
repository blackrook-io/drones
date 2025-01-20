class_name InventoryDialog
extends PanelContainer

@export var slot_scene:PackedScene
@onready var grid_container: GridContainer = %GridContainer



func open(inventory:Inventory):
	show()
	
	for key in inventory.list_items():
		var slot = slot_scene.instantiate()
		grid_container.add_child(slot)
		

func _on_close_button_pressed() -> void:
	hide()  # Hide the dialog.
