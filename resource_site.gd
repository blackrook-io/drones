extends StaticBody3D

# TODO: These need to be randomly generated and assigned by the world builder.
@export var RESOURCE: String
@export var NAME: String


@export_range (0, 10000, 1) var QUANTITY: int = 1000
@export_range (1, 10, 1) var QUALITY: int = 1


func _ready() -> void:
	add_to_group("resource_sites")


func harvest_resource(quantity: int):
	# This should trigger a timer that, on expiry, harvests.
	
	if QUANTITY == 0:
		# TODO: Destroy or 'retire' the resource site object.
		print("Resource site is depleted.")
		return false
	else:
		print("Resource Site harvested ", quantity)
		QUANTITY -= quantity
		return true
