extends Node2D

# Example options dictionary
var options = [
	{"chance": 1, "effects": {"1": 0, "2": 0}, "name": "a"},
	{"chance": 2, "effects": {"1": 0, "2": 0}, "name": "b"},
	{"chance": 3, "effects": {"1": 0, "2": 0}, "name": "c"}
]

# Radius of the wheel
var wheel_radius = 30

# Function to create the wheel segments
func _ready():
	var total_chance = 0
	for option in options:
		total_chance += option["chance"]
	
	var start_angle = 0.0
	for option in options:
		var segment = Polygon2D.new()
		var angle = (option["chance"] / total_chance) * 360.0
		segment.polygon = create_segment_polygon(start_angle, start_angle + angle)
		segment.color = Color(randf(), randf(), randf())
		segment.position = get_viewport().size / 2  # Center the wheel
		add_child(segment)
		
		var label = Label.new()
		label.text = option["name"]
		label.position = segment.position + Vector2(cos(deg_to_rad(start_angle + angle / 2)) * wheel_radius / 2, sin(deg_to_rad(start_angle + angle / 2)) * wheel_radius / 2)
		add_child(label)
		
		start_angle += angle

# Function to create a polygon for a wheel segment
func create_segment_polygon(start_angle, end_angle):
	var points = []
	points.append(Vector2.ZERO)
	for angle in range(int(start_angle), int(end_angle) + 1):
		var rad = deg_to_rad(angle)
		points.append(Vector2(cos(rad), sin(rad)) * wheel_radius)
	return points

# Function to spin the wheel
func spin_wheel():
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(self, "rotation_degrees", 0, 360 * 5, 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	tween.Callable("tween_completed", self, "_on_tween_completed")

# Function to handle the end of the spin
func _on_tween_completed(obj, key):
	var selected_option = weighted_random_selection()
	print("Selected option: ", selected_option["name"])

# Function to perform weighted random selection
func weighted_random_selection():
	var total_chance = 0
	for option in options:
		total_chance += option["chance"]
	
	var random_value = randi() % total_chance
	var cumulative_chance = 0
	for option in options:
		cumulative_chance += option["chance"]
		if random_value < cumulative_chance:
			return option
	return options[0]  # Fallback in case of error
