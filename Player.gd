extends Area2D

signal hit

export var speed = 400  # How fast the player will move (pixels/sec).
var screen_size  # Size of the game window
var target = Vector2()

func _ready():
    screen_size = get_viewport_rect().size
    hide()
	
func start(pos):
	print("start")
	position = pos
	target = pos
	show()
	$CollisionShape2D.disabled = false
	
# Change the target whenever a touch event happens.
func _input(event):
	# print("input " + event.pressed)
	if event is InputEventScreenTouch and event.pressed:
		target = event.position

func _process(delta):
	var velocity = Vector2()
	if position.distance_to(target) > 10:
        velocity = (target - position).normalized() * speed
	
	if velocity.length() > 0:
        velocity = velocity.normalized() * speed
        $AnimatedSprite.play()
	else:
        $AnimatedSprite.stop()

	position += velocity * delta

	if velocity.x != 0:
	    $AnimatedSprite.animation = "right"
	    $AnimatedSprite.flip_v = false
	    # See the note below about boolean assignment
	    $AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
	    $AnimatedSprite.animation = "up"
	    $AnimatedSprite.flip_h = false
	    $AnimatedSprite.flip_v = velocity.y > 0

func _on_Player_body_entered(body):
    hide()  # Player disappears after being hit.
    emit_signal("hit")
    $CollisionShape2D.call_deferred("set_disabled", true)
