extends Control

var options = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	options = Global.wheel_options
	print("These are options: ", options)
	populate_options_menu()
	pass # Replace with function body.
func populate_options_menu() -> void:
	var vbox = $Options_Container/VBoxContainer
	for idx in vbox.get_child_count():
		vbox.queue_free()
	for option in Global.wheel_options:
		var hbox = HBoxContainer.new()
		var name_label = Label.new()
		name_label.text = "Name:"
		hbox.add_child(name_label)
		var name_edit = LineEdit.new()
		name_edit.text = option["name"]
		name_edit.name = option["name"] + "_name"
		hbox.add_child(name_edit)
		var chance_label = Label.new()
		chance_label.text = "Chance:"
		hbox.add_child(chance_label)
		var chance_spinbox = SpinBox.new()
		chance_spinbox.value = option["chance"]
		chance_spinbox.name = option["name"] + "_chance"
		hbox.add_child(chance_spinbox)
# Element modifications
		for element in Global.elements:
			var element_label = Label.new()
			element_label.text = element + ":"
			hbox.add_child(element_label)
			var element_spinbox = SpinBox.new()
			element_spinbox.value = option["effects"].get(element, 0)
			element_spinbox.name = option["name"] + "_" + element + "_spinbox"
			hbox.add_child(element_spinbox)
		vbox.add_child(hbox)

func save_modified_options() -> void:
	var vbox = $Options_Container/VBoxContainer
	for hbox in vbox.get_children():
		var option_name = hbox.get_child(1).text
		var old_name = hbox.get_child(1).name.replace("_name", "")
		var option_chance = hbox.get_child(3).value

		var effects = {}
		for element in Global.elements:
			var element_spinbox = hbox.get_node(old_name + "_" + element + "_spinbox")
			effects[element] = element_spinbox.value

		# Find and update the corresponding option in Global.options
		for option in Global.wheel_options:
			if option["name"] == hbox.get_child(1).name.replace("_name", ""):
				option["name"] = option_name
				option["chance"] = option_chance
				option["effects"] = effects

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_return_to_spin_pressed() -> void:
	get_tree().change_scene_to_file("res://node_2d.tscn")


func _on_save_changes_pressed() -> void:
	save_modified_options()
