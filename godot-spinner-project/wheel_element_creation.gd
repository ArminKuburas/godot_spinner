extends Control

var elements = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.elements != null:
		Global.elements.clear()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_add_element_pressed() -> void:
	var element_name = $element_name.text.strip_edges()
	if element_name != "":
		elements[element_name] = 0
		var label = Label.new()
		label.text = element_name
		$ScrollContainer/VBoxContainer.add_child(label)
		Global.element_amount += 1
		$element_name.clear()


func _on_finish_pressed() -> void:
	get_tree().change_scene_to_file("res://node_2d.tscn")
	print("This is what the elements are: ", elements)
	print("there are in total ", Global.element_amount, " elements")
	Global.elements = elements
