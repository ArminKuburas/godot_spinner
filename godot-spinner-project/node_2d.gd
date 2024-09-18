extends Node2D

var options = ["Option 1", "Option 2", "Option 3", "Option 4"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize() # Replace with function body.
	$Button.connect("pressed", Callable(self, "_on_button_pressed"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func spin_wheel():
	var selected_option = options[randi() % options.size()]
	print ("Selected option ", selected_option)


func _on_button_pressed() -> void:
	spin_wheel() # Replace with function body.
