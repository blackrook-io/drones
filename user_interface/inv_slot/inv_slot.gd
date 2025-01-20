extends HBoxContainer


@onready var resource_label: Label = %ResourceLabel
@onready var amount_label: Label = %AmountLabel


func display_inv(entry):
	resource_label.text = entry[0]
	amount_label.text = entry[1]
	
