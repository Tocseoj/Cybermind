extends AnimatedSprite

export(float, -2, 5, 0.1) var speed = 1 setget speed_set
var _speed = 60.0

var input_axes = Vector2(0, 0)
var keys = {
	left = false,
	right = false,
	up = false,
	down = false
}

func _ready():
	set_process_input(true)
	set_process(true)
	self.play("idle_down")

func _input(event):
	if event.type != InputEvent.KEY:
		return
	# Let go of WASD
	if event.is_action_released("right"):
		keys.right = false
		if keys.left:
			input_axes.x = -1
		else:
			input_axes.x = 0
	elif event.is_action_released("left"):
		keys.left = false
		if keys.right:
			input_axes.x = 1
		else:
			input_axes.x = 0
	elif event.is_action_released("down"):
		keys.down = false
		if keys.up:
			input_axes.y = -1
		else:
			input_axes.y = 0
	elif event.is_action_released("up"):
		keys.up = false
		if keys.down:
			input_axes.y = 1
		else:
			input_axes.y = 0
	# New input
	elif event.is_action_pressed("right"):
		keys.right = true
		if input_axes.x == 0:
			input_axes.x = 1
	elif event.is_action_pressed("left"):
		keys.left = true
		if input_axes.x == 0:
			input_axes.x = -1
	elif event.is_action_pressed("down"):
		keys.down = true
		if input_axes.y == 0:
			input_axes.y = 1
	elif event.is_action_pressed("up"):
		keys.up = true
		if input_axes.y == 0:
			input_axes.y = -1
	# Set correct animation
	if input_axes.x == 0 && input_axes.y == 0:
		self.play("idle" + get_animation().right(4))
	elif input_axes.x == 1:
		self.play("walk_right")
	elif input_axes.x == -1:
		self.play("walk_left")
	elif input_axes.y == 1:
		self.play("walk_down")
	else:
		self.play("walk_up")

func _process(delta):
	if input_axes.length() != 0:
		set_pos((get_pos() + (input_axes.normalized() * delta * _speed)) \
		.snapped(Vector2(1,1)))
	
	#END

func speed_set(new):
	speed = new
	_speed = 60 * new
	for anim in get_sprite_frames().animations:
		get_sprite_frames().set_animation_speed(anim.name, 8 * new)