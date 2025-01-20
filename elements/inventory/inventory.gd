class_name Inventory

var _content:Dictionary = {
	"Fe": 200,
	"Al": 140
}

func add_item(key, value):
	if _content.has(key):
		var new_value = _content.get(key) + value
		_content[key] = new_value
		print("Inventory add_item ", key, " updated to ", new_value)
	else:
		_content[key] = value
		print("Inventory add_item ", key, " added with value ", value)


func remove_item(key):
	_content.erase(key)


func list_items() -> Dictionary:
	return _content
