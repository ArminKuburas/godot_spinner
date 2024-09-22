extends Polygon2D

var options = []
var total_chance = 0.0
var slices = []
var colors = []
var is_spinning = false
var slice_amount = 0

func _ready() -> void:
	# Prepare the initial wheel if options exist
	if options.size() > 0:
		update_wheel()

func update_wheel():
	total_chance = 0.0
	slices.clear()
	colors.clear()

	# Calculate total chance
	for option in options:
		total_chance += option.chance

	# Create slices based on the chance values
	var start_angle = 0.0
	for option in options:
		var slice_angle = option.chance / total_chance * PI * 2.0
		var slice = create_slice(start_angle, slice_angle)
		slice_amount += 1
		slices.append(slice)

		# Determine color based on slice size
		var color_intensity = option.chance / total_chance
		var color = Color(0.0, 0.0, 1.0, 1.0)  # Base blue color
		color = color.darkened(1.0 - color_intensity)
		colors.append(color)

		start_angle += slice_angle
	
	# Set the points and colors of the Polygon2D
	self.polygon = merge_slices(slices)
	if colors.size() == 1:
			self.color = colors[0]  # If only one color, just use the first color
	if colors.size() > 1:
		self.colors = merge_colors(colors)  # Apply the colors

func create_slice(start_angle: float, slice_angle: float) -> PackedVector2Array:
	var slice = PackedVector2Array()
	var segments = slice_amount  # Number of segments for smoothness
	slice.append(Vector2(0, 0))  # Center of the circle
	for i in range(segments + 1):
		var angle = start_angle + i * slice_angle / segments
		slice.append(Vector2(cos(angle), sin(angle)) * 100)  # 100 is the radius
	return slice

func merge_slices(slices: Array) -> PackedVector2Array:
	var merged = PackedVector2Array()
	for slice in slices:
		merged.append_array(slice)
	return merged

func merge_colors(colors: Array) -> PackedColorArray:
	var merged_colors = PackedColorArray()
	for i in range(colors.size()):
		for j in range(slice_amount):  # Repeat the color for each segment
			merged_colors.append(colors[i])
	return merged_colors

func spin_wheel():
	if is_spinning:
		return

	is_spinning = true
	var tween = create_tween()
	var rotation_duration = 2.0  # Adjust duration as needed
	var target_rotation = randf() * 360 + 1080  # Spin at least 3 full rotations
	tween.tween_property(self, "rotation_degrees", target_rotation, rotation_duration)
	tween.tween_callback(Callable(self, "_on_spin_complete"))

func _on_spin_complete():
	is_spinning = false
	# Calculate which option was selected based on the final rotation angle
	var final_angle = (fmod(rotation_degrees, 360.0)) / 360 * PI * 2.0
	var cumulative_angle = 0.0

	for i in range(slices.size()):
		cumulative_angle += slices[i][1].angle()  # Approximate the slice angle
		if final_angle <= cumulative_angle:
			print("Selected option: ", options[i]["name"])
			break
