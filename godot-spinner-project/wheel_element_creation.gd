extends Control

var elements = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_add_element_pressed() -> void:
	var element_name = $element_name.text.strip_edges()
	if elements != "":
		elements[element_name] = 0
		update_element_list()


func _on_finish_pressed() -> void:
	pass # Replace with function body.
