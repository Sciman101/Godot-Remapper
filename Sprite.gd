extends Sprite

const SPEED = 100

func _process(delta):
	position.x += Input.get_action_strength("right") * SPEED * delta
	position.x -= Input.get_action_strength("left") * SPEED * delta
	position.y += Input.get_action_strength("down") * SPEED * delta
	position.y -= Input.get_action_strength("up") * SPEED * delta
