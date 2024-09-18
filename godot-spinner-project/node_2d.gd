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
	load_saved_wheels()


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
				$VBoxContainer.add_child(item)
			file_name = dir.get_next()
		dir.list_dir_end()

func _on_wheel_button_pressed(file_name: String) -> void:
	load_wheel(file_name)

func load_wheel(file_name: String) -> void:
	var file = FileAccess.open(save_path + file_name, FileAccess.READ)
	if file != null:
		var data = JSON.parse_string(file.get_as_text())
		file.close()
		options = data
		print("Loaded wheel: ", options)

func _on_confirm_button_pressed() -> void:
	var option_name = $option_name.text
	var chance = $option_chance.value
	if $option_name.text == "":
		print("Given input incorrect as a name is missing")
		return
	options.append({"name": option_name, "chance": chance})
	$option_chance.value = 0
	$option_name.text = ""

func save_wheel(file_name: String) -> void:
	var file = FileAccess.open(save_path + file_name + ".json", FileAccess.WRITE)
	if file != null:
		file.store_string(JSON.stringify(options))
		file.close()


func _on_wheel_save_button_pressed() -> void:
	var wheel_name = $wheel_name.text
	if wheel_name != "":
		save_wheel(wheel_name)
		$wheel_name.text = ""
		var item = Button.new()
		var file_name = wheel_name + ".json"
		item.text = file_name
		item.connect("pressed", Callable(self, "_on_wheel_button_pressed").bind(file_name))
		$VBoxContainer.add_child(item)
	else:
		print("please provide a wheel name")


func _on_reset_wheel_pressed() -> void:
	options.clear()
	print("Wheel has been reset")
