extends Node2D

var options = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	var dir = DirAccess.open("user://wheels")
	if dir == null:
		DirAccess.make_dir_absolute("user://wheels")
	if Global.wheel_options != []:
		options = Global.wheel_options.duplicate(true)
		Global.wheel_options.clear()
	print("Type of options: ", typeof(options))
	create_elements_menu()
	$wheel.options = options
	$wheel.update_wheel()

func create_elements_menu() -> void:
	var scroll_container = $elements_wheel.get_node("ElementModifications")
	for element in Global.elements:
		var hbox = HBoxContainer.new()
		var label = Label.new()
		label.text = element
		hbox.add_child(label)
		var spinbox = SpinBox.new()
		spinbox.name = element + "_spinbox"
		hbox.add_child(spinbox)
		hbox.name = element
		scroll_container.add_child(hbox)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func spin_wheel():
	$wheel.spin_wheel()
#	if options.size() == 0:
#		print("No options available.")
		#return
	#var total_chance = 0
	#for option in options:
		#total_chance += option["chance"]
	#var random_value = randf() * total_chance
	#
	#var cumulative_chance = 0
	#for option in options:
		#cumulative_chance += option["chance"]
		#if random_value <= cumulative_chance && option["chance"] != 0:
			#print("Selected option: ", option["name"])
			#return


func _on_button_pressed() -> void:
	spin_wheel() # Replace with function body.

func _on_confirm_button_pressed() -> void:
	var option_name = $option_name.text
	var chance = $option_chance.value
	print("Type of options: ", typeof(options))
	if $option_name.text == "":
		print("Given input incorrect as a name is missing")
		return
	var effects = {}
	var scroll_container = $elements_wheel.get_node("ElementModifications")
	for element in Global.elements:
		print("this is element: ", element)
		var input_field = scroll_container.find_child(element + "_spinbox", true, false)
		if input_field != null:
			print("Found SpinBox for element: ", element, " with value: ", input_field.value)
			effects[element] = input_field.value
		else:
			print("Could not find SpinBox for element: ", element)
	print("Type of options: ", typeof(options))
	options.push_back({"name": option_name, "chance": chance, "effects": effects})
	$wheel.options = options
	$wheel.update_wheel()
	$option_chance.value = 0
	$option_name.text = ""
	reset_spinbox_values()
	
func reset_spinbox_values() -> void:
	var scroll_container = $elements_wheel.get_node("ElementModifications")

	for child in scroll_container.get_children():
		if child is HBoxContainer:
			print("found HBoxContainer. child.name is: ", child.name)
			var spinbox = child.find_child(child.name + "_spinbox", true, false)
			if spinbox is SpinBox:
				spinbox.value = 0
				print("Reset SpinBox value for: ", child.name)

func _on_reset_wheel_pressed() -> void:
	options.clear()
	Global.elements.clear()
	print("Wheel has been reset")


func _on_modify_existing_options_pressed() -> void:
	Global.wheel_options = options
	get_tree().change_scene_to_file("res://modify_options.tscn")


func _on_modify_elements_pressed() -> void:
	Global.wheel_options = options
	get_tree().change_scene_to_file("res://modify_elements.tscn")


func _on_save_or_load_wheel_pressed() -> void:
	Global.wheel_options = options
	get_tree().change_scene_to_file("res://load_save_file.tscn")
