extends AnimatedSprite

export var speed = 100.0
var _dest

func _ready():
	set_process_input(true)
	set_process(true)
	_dest = Vector2(0,0)
	self.play("idle_down")

func _input(event):
	if event.is_action_pressed("mouse_1"):
		_dest = event.pos
		print("Mouse Click: ",event.pos)

func _process(delta):
	var dir = _dest - get_pos()
	if dir.length() > EPSILON():
		# Animation direction
		if dir.angle() > PI/4 && dir.angle() < 3*PI/4:
			self.play("walk_right")
		elif dir.angle() < -PI/4 && dir.angle() > -3*PI/4:
			self.play("walk_left")
		elif dir.angle() >= -PI/4 && dir.angle() <= PI/4:
			self.play("walk_down")
		else:
			self.play("walk_up")
		
		set_pos((get_pos() + (dir.normalized() * delta * speed)).snapped(Vector2(1,1)))
	elif (_dest - get_pos()).length() != 0:
		set_pos(_dest)
	
	if _dest == get_pos():
		self.play("idle" + get_animation().right(4))

func EPSILON():
	if speed <= 100:
		return 1
	else:
		return speed/100