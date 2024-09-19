extends Node2D

var options = []
var save_path = "user://wheels/"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	$Button.connect("pressed", Callable(self, "_on_button_pressed"))
	$ConfirmButton.connect("pressed", Callable(self, "_on_confirm_button_pressed"))
	$wheel_save_button.connect("pressed", Callable(self, "_on_wheel_save_button_pressed"))
	$reset_wheel.connect("pressed", Callable(self, "_on_reset_wheel_pressed"))
	var dir = DirAccess.open("user://wheels")
	if dir == null:
		DirAccess.make_dir_absolute("user://wheels")
	if Global.wheel_options != null:
		options = Global.wheel_options
		Global.wheel_options.clear()
	create_elements_menu()
	load_saved_wheels()

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
	if options.size() == 0:
		print("No options available.")
		return
	var total_chance = 0
	for option in options:
		total_chance += option["chance"]
	var random_value = randf() * total_chance
	
	var cumulative_chance = 0
	for option in options:
		cumulative_chance += option["chance"]
		if random_value <= cumulative_chance && option["chance"] != 0:
			print("Selected option: ", option["name"])
			return


func _on_button_pressed() -> void:
	spin_wheel() # Replace with function body.

func load_saved_wheels() -> void:
	var dir = DirAccess.open(save_path)
	if dir != null:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir() and file_name.ends_with(".json"):
				print("Saved wheel: ", file_name)
				var item = Button.new()
				item.text = file_name
				item.connect("pressed", Callable(self, "_on_wheel_button_pressed").bind(file_name))
				$ScrollContainer/VBoxContainer.add_child(item)
			file_name = dir.get_next()
		dir.list_dir_end()

func _on_wheel_button_pressed(file_name: String) -> void:
	load_wheel(file_name)

func load_wheel(file_name: String) -> void:
	var file = FileAccess.open(save_path + file_name, FileAccess.READ)
	if file != null:
		var data = JSON.parse_string(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			options = data.get("options", [])
			Global.elements = data.get("elements", [])
			print("Loaded wheel: ", options)
			print("Loaded elements: ", Global.elements)
		else:
			print("Error: Invalid wheel data format.")

func _on_confirm_button_pressed() -> void:
	var option_name = $option_name.text
	var chance = $option_chance.value
	if $option_name.text == "":
		print("Given input incorrect as a name is missing")
		return
	var effects = {}
	var scroll_container = $elements_wheel.get_node("ElementModifications")
	if scroll_container != null:
		print("scroll container found")
	for element in Global.elements:
		print("this is element: ", element)
		var input_field = scroll_container.find_child(element + "_spinbox", true, false)
		if input_field != null:
			print("Found SpinBox for element: ", element, " with value: ", input_field.value)
			effects[element] = input_field.value
		else:
			print("Could not find SpinBox for element: ", element)
	options.append({"name": option_name, "chance": chance, "effects": effects})
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

func save_wheel(file_name: String) -> void:
	var file = FileAccess.open(save_path + file_name + ".json", FileAccess.WRITE)
	if file != null:
		var wheel_data = {
			"options": options,
			"elements": Global.elements
		}
		file.store_string(JSON.stringify(wheel_data))
		file.close()


func _on_wheel_save_button_pressed() -> void:
	var wheel_name = $wheel_name.text
	if wheel_name == "":
		print("please provide a wheel name")
	else:
		save_wheel(wheel_name)
		$wheel_name.text = ""
		var file_name = wheel_name + ".json"
		var exists = false
		for child in $ScrollContainer/VBoxContainer.get_children():
			if child is Button and child.text == file_name:
				exists = true
				break
		if not exists:
			var item = Button.new()
			item.text = file_name
			item.connect("pressed", Callable(self, "_on_wheel_button_pressed").bind(file_name))
			$ScrollContainer/VBoxContainer.add_child(item)


func _on_reset_wheel_pressed() -> void:
	options.clear()
	Global.elements.clear()
	print("Wheel has been reset")


func _on_modify_existing_options_pressed() -> void:
	Global.wheel_options = options
	get_tree().change_scene_to_file("res://modify_options.tscn")
