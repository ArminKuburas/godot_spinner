extends Node2D

var options = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize() # Replace with function body.
	$Button.connect("pressed", Callable(self, "_on_button_pressed"))
	$ConfirmButton.connect("pressed", Callable(self, "_on_confirm_button_pressed"))


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
		if random_value <= cumulative_chance:
			print("Selected option: ", option["name"])
			return


func _on_button_pressed() -> void:
	spin_wheel() # Replace with function body.


func _on_confirm_button_pressed() -> void:
	var option_name = $option_name.text
	var chance = $option_chance.value
	
	options.append({"name": option_name, "chance": chance})
	$option_chance.value = 0
	$option_name.text = ""
