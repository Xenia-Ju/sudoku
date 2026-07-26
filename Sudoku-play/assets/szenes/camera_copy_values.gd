extends SpringArm3D


# Called when the node enters the scene tree for the first time.
func _ready():
	$"../../SubViewport/WorldEnvironment/SpringArm3D".copy_values.connect(_copy_values)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _copy_values(pos, dir):
	position = pos
	rotation = dir
