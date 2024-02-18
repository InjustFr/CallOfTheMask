extends RayCast2D


class_name FOVComponent


@export var orientation_component : OrientationComponent
@export var angle : int = 90;
@export var angle_step : int = 5;
@export var scan_range : int = 64;

var target : Node2D = null:
	get:
		return target


func _process(_delta):
	rotation = orientation_component.orientation.angle()
	target = scan();

func scan() -> Node2D:
	@warning_ignore("integer_division")
	var steps : int = int(angle / angle_step)	 + 1

	var detected_bodies : Array[Node2D] = [];
	for i in steps:
		var scan_angle = - angle / 2.0 + i * angle_step

		target_position = Vector2(scan_range, 0).rotated(deg_to_rad(scan_angle))
		force_raycast_update()
		var collider = get_collider()
		if collider and not detected_bodies.has(collider):
			detected_bodies.push_back(collider)

	var min_distance : float = scan_range
	var body : Node2D = null
	for db: Node2D in detected_bodies:
		var distance : float = global_position.distance_to(db.global_position)
		if distance < min_distance:
			body = db;
			min_distance = distance

	return body
