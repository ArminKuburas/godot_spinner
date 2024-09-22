extends Control
var save_path = "user://wheels/"
var file_to_delete = ""
var hbox_to_remove = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_saved_wheels()

func load_saved_wheels() -> void:
	var dir = DirAccess.open(save_path)
	if dir != null:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir() and file_name.ends_with(".json"):
				var hbox = HBoxContainer.new()
				# Create the load button
				var load_button = Button.new()
				load_button.text = file_name.substr(0, file_name.length() - 5) # Remove ".json"
				load_button.connect("pressed", Callable(self, "_on_wheel_button_pressed").bind(file_name))
				hbox.add_child(load_button)
				# Create the delete button
				var delete_button = Button.new()
				delete_button.text = "Delete"
				delete_button.connect("pressed", Callable(self, "_on_delete_button_pressed").bind(file_name, hbox))
				hbox.add_child(delete_button)
				$save_files_ScrollContainer/save_files_VBoxContainer.add_child(hbox)
			file_name = dir.get_next()
		dir.list_dir_end()

func _on_delete_button_pressed(file_name: String, hbox: HBoxContainer) -> void:
	file_to_delete = file_name
	hbox_to_remove = hbox
	$DeleteConfirmationDialog.popup_centered()

func _on_wheel_button_pressed(file_name: String) -> void:
	load_wheel(file_name)

func load_wheel(file_name: String) -> void:
	var file = FileAccess.open(save_path + file_name, FileAccess.READ)
	if file != null:
		var data = JSON.parse_string(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			Global.wheel_options = data.get("options", [])
			Global.elements = data.get("elements", [])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_wheel_save_button_pressed() -> void:
	var wheel_name = $wheel_name.text
	if wheel_name == "":
		print("please provide a wheel name")
	else:
		save_wheel(wheel_name)
		$wheel_name.text = ""
		var file_name = wheel_name + ".json"
		var exists = false
		for child in $save_files_ScrollContainer/save_files_VBoxContainer.get_children():
			if child is Button and child.text == file_name:
				exists = true
				break
		if not exists:
			var hbox = HBoxContainer.new()
			var load_button = Button.new()
			load_button.text = file_name.substr(0, file_name.length() - 5)
			load_button.connect("pressed", Callable(self, "_on_wheel_button_pressed").bind(file_name))
			hbox.add_child(load_button)
			var delete_button = Button.new()
			delete_button.text = "Delete"
			delete_button.connect("pressed", Callable(self, "_on_delete_button_pressed").bind(file_name, hbox))
			hbox.add_child(delete_button)
			$save_files_ScrollContainer/save_files_VBoxContainer.add_child(hbox)

func save_wheel(file_name: String) -> void:
	var file = FileAccess.open(save_path + file_name + ".json", FileAccess.WRITE)
	if file != null:
		var wheel_data = {
			"options": Global.wheel_options,
			"elements": Global.elements
		}
		file.store_string(JSON.stringify(wheel_data))
		file.close()


func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://node_2d.tscn")	

func _on_delete_dialog_confirmed() -> void:
	if file_to_delete != "" and hbox_to_remove != null:
		var file_path = save_path + "/" + file_to_delete
		if FileAccess.file_exists(file_path):
			DirAccess.remove_absolute(file_path)
			$save_files_ScrollContainer/save_files_VBoxContainer.remove_child(hbox_to_remove)
			hbox_to_remove.queue_free() # Removes the HBoxContainer holding the buttons from the scene tree
		file_to_delete = ""
		hbox_to_remove = null
