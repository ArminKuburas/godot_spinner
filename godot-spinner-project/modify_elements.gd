extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	populate_elements_menu()
	pass # Replace with function body.

func populate_elements_menu() -> void:
	var vbox = $Elements_Container/VBoxContainer
	for element_name in Global.elements.keys():
		var hbox = HBoxContainer.new()
		var name_label = Label.new()
		name_label.text = "Element:"
		hbox.add_child(name_label)
		var name_edit = LineEdit.new()
		name_edit.text = element_name
		name_edit.name = element_name + "_name_edit"
		hbox.add_child(name_edit)
		vbox.add_child(hbox)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://node_2d.tscn")


func _on_save_pressed() -> void:
	var vbox = $Elements_Container/VBoxContainer
	var new_elements = {}
	for hbox in vbox.get_children():
		var old_name = hbox.get_child(1).name.replace("_name_edit", "")
		var new_name = hbox.get_child(1).text

		if old_name != new_name:
			# Update element in the Global.elements
			new_elements[new_name] = Global.elements[old_name]
			Global.elements.erase(old_name)
			hbox.get_child(1).name = hbox.get_child(1).text + "_name_edit"

			# Update the options to reflect the new element name
			for option in Global.wheel_options:
				if option["effects"].has(old_name):
					option["effects"][new_name] = option["effects"].erase(old_name)
		else:
			new_elements[old_name] = Global.elements[old_name]

	Global.elements = new_elements
