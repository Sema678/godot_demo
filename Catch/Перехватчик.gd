extends KinematicBody2D

var velocity = Vector2()
var MAX_SPEED = 200
var ATTACK_RANGE = 110
var attacking = false


func _ready():
	# ничего не делаем
	pass
	
	
func start_attack(target):
	# вычислим и запомним направление на цель
	var direction = target.position - self.position
	# нарисуем лазерный луч до цели 
	var laser_beam = get_node("Луч")
	laser_beam.points[1] = direction
	laser_beam.visible = true
	# нарисуем вспышки от источник луча
	var emitter = get_node("Луч/Источник")
	emitter.visible = true
	emitter.emitting = true
	emitter.process_material.direction = Vector3(direction.x, direction.y, 0)
	# нарисуем вспышки от цели
	var receiver = get_node("Луч/Приемник")
	receiver.position = target.position - self.position
	receiver.visible = true
	receiver.emitting = true
	receiver.process_material.direction = Vector3(direction.x, direction.y, 0)


func stop_attack(target):
	# спрячем лазерный луч до цели
	var laser_beam = get_node("Луч")
	laser_beam.visible = false
	# уберем вспышки от источника
	var emitter = get_node("Луч/Источник")
	emitter.visible = false
	emitter.emitting = false
	# уберем вспышки от цели
	var receiver = get_node("Луч/Приемник")
	receiver.visible = false
	receiver.emitting = false
	
	
func catch(target, delta):
	# летим к цели, с "упреждением" на ее скорость
	velocity = target.position - self.position + 0.7 * target.velocity
	
	
func attack(target, delta):
	# ищем расстояние до цели
	var dist = (target.position - self.position).length()
	if dist < ATTACK_RANGE:
		# мы близко, атакуем цель
		start_attack(target)
		target.health -= delta
		if (target.health < 0):
			get_node("../Конец").popup_centered()
			stop_attack(target)
	else: 
		# мы слишком далеко, прекращаем атаковать
		stop_attack(target)


func move():
	# скорость движения не должна быть слишом большой
	if (velocity.length() > MAX_SPEED):
		velocity /= velocity.length()
		velocity *= MAX_SPEED
	# обращаемся к движку, чтобы переместиться
	velocity = move_and_slide(velocity, Vector2.UP)
	

func _process(delta):
	# получаем цель
	var target = get_node("../Цель")
	# если цель еще жива
	if target.health > 0:
		# преследуем ее
		catch(target, delta)
		# и атакуем, если возможно
		attack(target, delta)
	else:
		# иначе бездействуем
		stop_attack(target)
		
	# в любом случае, двигаемся
	move()
