extends RigidBody2D

@export var back_wheel: RigidBody2D
@export var front_wheel: RigidBody2D
@export var player: CollisionShape2D

@export var spin_velocity: Curve
@export var spin_base_velocity: float
@export var acceleration: Curve
@export var base_acceleration: float
@export var max_feasible_velocity: float

var torque_pressed_time: float = 0.0

func _process(delta):
	if Input.is_action_just_pressed("Tilt Back") || Input.is_action_just_pressed("Tilt Front"):
		torque_pressed_time = 0.0
	
	if Input.is_action_pressed("Tilt Back"):
		#TODO: Move center of mass instead of torque
		torque_pressed_time = clamp(torque_pressed_time + delta, spin_velocity.min_value, spin_velocity.max_value)
		self.apply_torque_impulse(-get_spin_torque())
	if Input.is_action_pressed("Tilt Front"):
		torque_pressed_time = clamp(torque_pressed_time + delta, spin_velocity.min_value, spin_velocity.max_value)
		self.apply_torque_impulse(get_spin_torque())
	
	if Input.is_action_pressed("Accelerate"):
		var additional_boost = acceleration.sample(back_wheel.angular_velocity / max_feasible_velocity)
		back_wheel.apply_torque(base_acceleration + additional_boost)
	
	if Input.is_action_pressed("Brake"):
		back_wheel.apply_torque(-base_acceleration)

func _physics_process(delta):
	pass

func get_spin_torque() -> float:
	return spin_velocity.sample(torque_pressed_time) + spin_base_velocity
