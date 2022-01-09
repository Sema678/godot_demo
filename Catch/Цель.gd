extends KinematicBody2D

var velocity = Vector2()
var rng = RandomNumberGenerator.new()
var ENGINE_POWER = 2000
var MAX_SPEED = 500
var MAX_HEALTH = 5 # 5 секунд непрерывного урона
var health = MAX_HEALTH


func _ready():
	rng.randomize()
	position.x = rng.randf_range(0, get_viewport().size.x)
	

# управление пользователем	
func get_user_input(delta):
	var direction
	if Input.is_action_pressed("ui_left"):
		direction = Vector2.LEFT
	if Input.is_action_pressed("ui_right"):
		direction = Vector2.RIGHT
	if Input.is_action_pressed("ui_up"):
		direction = Vector2.UP 
	if Input.is_action_pressed("ui_down"):
		direction = Vector2.DOWN
	if direction:
		velocity += direction * ENGINE_POWER
		
		
func move():
	# скорость движения не должна быть слишом большой
	if (velocity.length() > MAX_SPEED):
		velocity /= velocity.length()
		velocity *= MAX_SPEED
	# обращаемся к движку, чтобы переместиться
	velocity = move_and_slide(velocity, Vector2.UP)


func _process(delta):
	if (health > 0):
		# если мы еще живы, проверяем ввод и двигаемся
		get_user_input(delta)
		move()
	else:
		visible = false



