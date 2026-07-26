extends Button # CheckBox

signal depression_signal(origin)

var counter=0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".pressed.connect(_button_pressed)
	var new_style=StyleBoxEmpty.new()
	$".".add_theme_stylebox_override("focus",new_style)

func _button_pressed():
	depression_signal.emit(self)
