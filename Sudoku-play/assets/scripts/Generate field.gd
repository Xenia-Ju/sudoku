extends VBoxContainer

var signals_slices=[]
var signals_numpad=[]	 

func load_signals():
	signals_slices=[
		$"Top_Panel/2D_Slice/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Check X1",
		$"Top_Panel/2D_Slice/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Check X2",
		$"Top_Panel/2D_Slice/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Check X3",
		$"Top_Panel/2D_Slice/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Check X4",
		$"Top_Panel/2D_Slice/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Check X5",
		$"Top_Panel/2D_Slice/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Check X6",
		$"Top_Panel/2D_Slice/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Check X7",
		$"Top_Panel/2D_Slice/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Check X8",
		$"Top_Panel/2D_Slice/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Check X9",
		$"Top_Panel/2D_Slice/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Check Y1",
		$"Top_Panel/2D_Slice/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Check Y2",
		$"Top_Panel/2D_Slice/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Check Y3",
		$"Top_Panel/2D_Slice/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Check Y4",
		$"Top_Panel/2D_Slice/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Check Y5",
		$"Top_Panel/2D_Slice/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Check Y6",
		$"Top_Panel/2D_Slice/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Check Y7",
		$"Top_Panel/2D_Slice/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Check Y8",
		$"Top_Panel/2D_Slice/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Check Y9",
		$"Top_Panel/2D_Slice/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer3/Check Z1",
		$"Top_Panel/2D_Slice/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer3/Check Z2",
		$"Top_Panel/2D_Slice/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer3/Check Z3",
		$"Top_Panel/2D_Slice/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer3/Check Z4",
		$"Top_Panel/2D_Slice/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer3/Check Z5",
		$"Top_Panel/2D_Slice/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer3/Check Z6",
		$"Top_Panel/2D_Slice/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer3/Check Z7",
		$"Top_Panel/2D_Slice/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer3/Check Z8",
		$"Top_Panel/2D_Slice/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer3/Check Z9",
		]
	signals_numpad=[
		$"Numpad/MarginContainer/VBoxContainer/HBoxContainer/Pad 7",
		$"Numpad/MarginContainer/VBoxContainer/HBoxContainer/Pad 8",
		$"Numpad/MarginContainer/VBoxContainer/HBoxContainer/Pad 9",
		$"Numpad/MarginContainer/VBoxContainer/HBoxContainer/full",
		$"Numpad/MarginContainer/VBoxContainer/HBoxContainer2/Pad 4",
		$"Numpad/MarginContainer/VBoxContainer/HBoxContainer2/Pad 5",
		$"Numpad/MarginContainer/VBoxContainer/HBoxContainer2/Pad 6",
		$"Numpad/MarginContainer/VBoxContainer/HBoxContainer2/pencil",
		$"Numpad/MarginContainer/VBoxContainer/HBoxContainer3/Pad 1",
		$"Numpad/MarginContainer/VBoxContainer/HBoxContainer3/Pad 2",
		$"Numpad/MarginContainer/VBoxContainer/HBoxContainer3/Pad 3",
		$"Numpad/MarginContainer/VBoxContainer/HBoxContainer4/Back",
		$"Numpad/MarginContainer/VBoxContainer/HBoxContainer4/Pad Del",
		$"Numpad/MarginContainer/VBoxContainer/HBoxContainer4/Forward",
		$"Numpad/MarginContainer/VBoxContainer/HBoxContainer4/Check",
		$"Options/MarginContainer/HBoxContainer/Menue",
		$"Options/MarginContainer/HBoxContainer/Visibility",
		$"Options/MarginContainer/HBoxContainer/Slice",
		$"Top_Panel/Menue/MarginContainer/VBoxContainer/Game 1",
		$"Top_Panel/Menue/MarginContainer/VBoxContainer/Game 2",
		$"Top_Panel/Menue/MarginContainer/VBoxContainer/Game 3",
		$"Top_Panel/Menue/MarginContainer/VBoxContainer/Game 4",
		]
	
	
signal active_slice_signal(slice)
signal active_button_signal(button)
signal number_change_signal()
signal check_signal(wrong)


var buttons = []
var label = []
var field = []  # c b a
var undo_stack = []
var undo_position = 0

enum Mode {FULL = 0, PENCIL = 1}
var current_mode = Mode.FULL
enum Font_size {FULL = 21, PENCIL = 9}
var text_color_given = Color(0,0,0)
var text_color_open = Color(1,1,1)
var text_color_wrong = Color(1,0.7,0.6)

func load_data(game):
#	var load_seed="00040_test"
#	var load_path="res://seeds/Seed_"+load_seed+".sv"
#	var load_file=FileAccess.open(load_path,FileAccess.READ)
#	get_tree().create_timer(0.001).timeout
#	field=load_file.get_var().duplicate(true)
# 	load_file.close()
#	print(field)
	if game == 1:
		field = [[[1, 2, 3, 4, 5, 6, 7, 8, 9], [4, 5, 6, 7, 8, 9, 1, 2, 3], [7, 8, 9, 1, 2, 3, 4, 5, 6], [2, 1, 4, 3, 6, 5, 8, 9, 7], [3, 6, 5, 8, 9, 7, 2, 1, 4], [8, 9, 7, 2, 1, 4, 3, 6, 5], [5, 3, 1, 0, 4, 2, 9, 7, 8], [6, 4, 2, 9, 7, 8, 5, 3, 1], [9, 7, 8, 0, 3, 1, 6, 4, 2]], [[5, 6, 4, 8, 9, 7, 2, 3, 1], [8, 9, 7, 2, 3, 1, 5, 6, 4], [2, 3, 1, 5, 6, 4, 8, 9, 7], [6, 5, 3, 9, 7, 8, 1, 4, 2], [9, 7, 8, 1, 4, 2, 6, 5, 3], [1, 4, 2, 6, 5, 3, 9, 7, 8], [4, 0, 6, 7, 8, 9, 3, 1, 5], [7, 8, 9, 3, 1, 5, 4, 2, 6], [3, 1, 5, 4, 2, 6, 7, 8, 9]], [[9, 7, 8, 3, 1, 2, 6, 4, 5], [3, 1, 2, 6, 4, 5, 9, 7, 8], [6, 4, 5, 9, 7, 8, 3, 1, 2], [7, 8, 9, 4, 2, 1, 5, 3, 6], [4, 2, 1, 5, 3, 6, 7, 8, 0], [5, 3, 6, 7, 8, 9, 4, 2, 1], [8, 9, 7, 1, 5, 3, 2, 6, 4], [1, 5, 3, 2, 6, 4, 8, 9, 7], [2, 6, 4, 8, 9, 7, 1, 5, 3]], [[2, 1, 5, 6, 3, 4, 8, 9, 7], [6, 3, 4, 8, 9, 7, 2, 1, 5], [8, 9, 7, 2, 1, 5, 6, 3, 4], [1, 2, 6, 5, 4, 3, 7, 8, 9], [5, 4, 3, 7, 8, 9, 1, 2, 6], [7, 8, 9, 1, 2, 6, 5, 4, 3], [3, 6, 2, 9, 7, 8, 4, 5, 1], [9, 7, 8, 4, 5, 1, 3, 6, 2], [4, 5, 1, 3, 6, 2, 9, 7, 8]], [[3, 4, 6, 9, 7, 8, 1, 5, 2], [9, 7, 8, 1, 5, 2, 3, 4, 6], [1, 5, 2, 3, 4, 6, 9, 7, 8], [4, 3, 5, 8, 9, 7, 2, 6, 1], [8, 9, 7, 2, 6, 1, 4, 3, 5], [2, 6, 1, 4, 3, 5, 0, 9, 7], [7, 8, 9, 5, 1, 4, 6, 2, 3], [5, 1, 4, 6, 2, 3, 7, 8, 9], [6, 2, 3, 7, 8, 9, 5, 1, 4]], [[7, 8, 9, 5, 2, 1, 4, 6, 3], [5, 2, 1, 4, 6, 3, 7, 8, 9], [4, 6, 3, 7, 8, 9, 5, 2, 1], [9, 7, 8, 6, 1, 2, 3, 5, 4], [6, 1, 2, 3, 5, 4, 9, 7, 8], [3, 5, 4, 9, 7, 8, 6, 1, 2], [1, 4, 5, 2, 3, 6, 8, 9, 7], [2, 3, 6, 8, 9, 7, 1, 4, 5], [8, 9, 7, 1, 4, 0, 2, 3, 6]], [[4, 3, 1, 2, 6, 5, 9, 7, 8], [7, 8, 9, 3, 1, 4, 6, 5, 2], [5, 2, 6, 8, 9, 7, 1, 4, 3], [3, 6, 7, 1, 8, 9, 4, 2, 5], [2, 5, 4, 6, 7, 3, 0, 9, 1], [9, 1, 8, 5, 4, 2, 7, 3, 6], [6, 7, 3, 4, 2, 1, 5, 8, 9], [8, 9, 5, 7, 3, 6, 2, 1, 4], [1, 4, 2, 9, 5, 8, 3, 6, 7]], [[6, 5, 2, 7, 8, 9, 3, 1, 4], [1, 4, 3, 5, 2, 6, 8, 9, 7], [9, 7, 8, 4, 3, 1, 2, 6, 5], [8, 9, 1, 2, 5, 4, 6, 7, 3], [7, 3, 6, 9, 1, 8, 5, 4, 2], [4, 2, 5, 3, 6, 7, 1, 8, 9], [2, 1, 4, 8, 9, 5, 7, 3, 6], [3, 6, 7, 1, 4, 2, 9, 5, 8], [5, 8, 9, 6, 7, 3, 4, 2, 1]], [[8, 9, 7, 1, 4, 3, 5, 2, 6], [2, 6, 5, 9, 7, 8, 4, 3, 1], [3, 1, 4, 6, 5, 2, 0, 8, 9], [5, 4, 2, 7, 3, 6, 9, 1, 8], [1, 8, 9, 4, 2, 5, 3, 6, 7], [6, 7, 3, 8, 9, 1, 2, 5, 4], [9, 5, 8, 3, 0, 7, 1, 4, 2], [4, 2, 0, 5, 8, 9, 6, 7, 3], [7, 3, 6, 2, 1, 4, 8, 9, 5]]]
	if game == 2:
		field = [[[0, 8, 3, 0, 0, 5, 4, 2, 1], [7, 0, 5, 4, 2, 1, 0, 8, 3], [4, 0, 1, 0, 8, 3, 7, 6, 5], [8, 5, 0, 0, 7, 4, 3, 1, 2], [6, 7, 4, 3, 0, 2, 8, 0, 9], [3, 1, 2, 8, 5, 9, 6, 7, 0], [5, 0, 0, 2, 0, 8, 1, 4, 6], [2, 9, 8, 1, 0, 6, 0, 0, 7], [1, 4, 6, 5, 3, 7, 2, 0, 8]], [[6, 0, 7, 2, 0, 4, 0, 0, 9], [2, 0, 4, 8, 3, 9, 6, 0, 0], [8, 3, 9, 6, 5, 0, 2, 0, 4], [0, 4, 6, 1, 2, 3, 5, 0, 8], [1, 0, 0, 5, 9, 8, 7, 4, 6], [0, 9, 8, 0, 4, 6, 0, 0, 0], [9, 8, 2, 4, 6, 1, 0, 0, 5], [4, 6, 1, 3, 7, 0, 0, 8, 2], [0, 7, 5, 9, 8, 2, 4, 6, 0]], [[1, 4, 2, 0, 0, 8, 5, 0, 6], [3, 0, 8, 0, 7, 6, 1, 0, 2], [0, 0, 6, 1, 0, 2, 3, 0, 0], [2, 3, 1, 0, 0, 0, 0, 6, 0], [9, 8, 5, 0, 6, 7, 2, 3, 0], [4, 6, 7, 2, 0, 1, 9, 8, 5], [6, 1, 4, 7, 0, 3, 0, 0, 0], [7, 5, 0, 8, 2, 9, 6, 0, 0], [0, 0, 0, 0, 1, 4, 7, 5, 3]], [[8, 0, 0, 5, 7, 2, 3, 1, 0], [0, 7, 2, 3, 1, 4, 8, 9, 0], [3, 0, 0, 0, 9, 6, 5, 0, 2], [0, 8, 5, 7, 4, 1, 6, 0, 3], [0, 0, 1, 6, 2, 0, 9, 8, 0], [6, 2, 3, 9, 8, 5, 7, 0, 0], [4, 9, 6, 1, 3, 7, 0, 5, 8], [0, 0, 7, 0, 0, 8, 0, 0, 9], [2, 5, 8, 0, 0, 0, 1, 3, 7]], [[0, 2, 5, 1, 4, 3, 9, 6, 0], [1, 0, 3, 0, 6, 0, 7, 2, 5], [0, 0, 8, 7, 2, 5, 1, 4, 3], [0, 1, 7, 2, 3, 0, 0, 0, 9], [0, 3, 6, 8, 5, 9, 0, 1, 7], [8, 5, 0, 0, 1, 7, 2, 3, 0], [3, 7, 1, 5, 0, 0, 0, 9, 4], [5, 8, 2, 0, 9, 0, 3, 0, 1], [0, 6, 0, 3, 7, 0, 0, 8, 0]], [[4, 3, 1, 0, 8, 9, 2, 0, 7], [9, 8, 0, 0, 0, 0, 4, 3, 1], [0, 0, 7, 4, 3, 0, 0, 8, 9], [3, 6, 2, 5, 9, 8, 1, 0, 4], [5, 9, 8, 0, 0, 4, 3, 6, 0], [0, 0, 4, 3, 0, 2, 5, 9, 8], [8, 2, 5, 0, 4, 6, 7, 1, 0], [6, 4, 0, 7, 0, 3, 8, 2, 5], [0, 1, 3, 8, 0, 5, 9, 0, 0]], [[5, 0, 8, 0, 2, 0, 7, 4, 3], [4, 3, 7, 1, 8, 0, 2, 0, 0], [9, 6, 2, 3, 7, 4, 0, 0, 1], [0, 0, 4, 0, 0, 0, 0, 0, 0], [3, 5, 0, 7, 4, 1, 0, 2, 8], [2, 8, 0, 5, 9, 3, 0, 1, 7], [7, 0, 3, 0, 0, 9, 5, 8, 2], [8, 0, 5, 0, 0, 7, 0, 9, 0], [6, 9, 1, 2, 5, 0, 3, 0, 4]], [[3, 7, 0, 8, 0, 1, 0, 9, 2], [6, 0, 9, 7, 4, 3, 5, 1, 8], [1, 8, 0, 2, 6, 9, 0, 3, 0], [0, 9, 0, 4, 0, 7, 2, 0, 6], [8, 6, 2, 9, 0, 5, 0, 7, 4], [7, 4, 1, 6, 2, 8, 3, 5, 9], [2, 5, 8, 3, 7, 4, 9, 6, 1], [9, 1, 6, 5, 8, 2, 7, 4, 3], [4, 3, 7, 1, 0, 6, 0, 0, 0]], [[2, 9, 6, 0, 3, 7, 1, 8, 5], [8, 0, 1, 6, 9, 2, 3, 7, 4], [7, 4, 3, 5, 1, 8, 9, 2, 6], [0, 2, 8, 3, 5, 9, 7, 4, 1], [4, 1, 7, 2, 8, 6, 5, 9, 3], [9, 3, 5, 1, 7, 4, 8, 6, 2], [1, 6, 9, 8, 2, 5, 4, 3, 7], [3, 7, 4, 9, 6, 1, 2, 5, 8], [5, 8, 2, 0, 4, 3, 6, 1, 9]]]
	if game == 3:
		field = [[[0, 6, 0, 0, 0, 2, 0, 0, 1], [0, 7, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 5, 0, 2, 9, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 8, 0, 0, 0, 0, 0, 0], [0, 1, 0, 0, 5, 0, 3, 9, 0]], [[0, 0, 0, 0, 0, 0, 7, 0, 0], [0, 3, 4, 0, 0, 6, 0, 0, 0], [0, 0, 0, 0, 0, 0, 1, 0, 0], [3, 0, 8, 0, 0, 2, 0, 6, 0], [0, 5, 0, 0, 6, 7, 0, 1, 0], [0, 0, 7, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 2, 0, 6, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 7, 0, 0, 2, 0]], [[0, 1, 0, 6, 0, 0, 0, 0, 8], [0, 0, 0, 0, 0, 8, 4, 0, 0], [3, 0, 0, 0, 0, 0, 6, 0, 9], [0, 4, 0, 0, 0, 0, 2, 9, 3], [0, 0, 0, 2, 9, 3, 0, 0, 0], [0, 0, 3, 5, 0, 0, 0, 0, 1], [0, 0, 2, 0, 0, 0, 0, 8, 0], [7, 0, 0, 0, 0, 5, 0, 0, 0], [0, 8, 0, 0, 3, 0, 0, 0, 0]], [[0, 0, 9, 0, 2, 1, 0, 0, 0], [0, 0, 0, 6, 5, 4, 0, 0, 9], [6, 0, 4, 8, 0, 9, 0, 2, 0], [0, 0, 2, 4, 8, 0, 0, 0, 6], [4, 8, 0, 0, 1, 6, 9, 7, 0], [3, 0, 0, 0, 0, 0, 4, 0, 0], [5, 0, 0, 0, 4, 0, 0, 0, 0], [0, 0, 0, 0, 6, 0, 0, 9, 7], [0, 6, 0, 0, 0, 0, 0, 0, 3]], [[5, 0, 0, 3, 9, 0, 2, 0, 0], [0, 0, 8, 0, 1, 0, 0, 4, 0], [2, 0, 0, 0, 0, 0, 3, 0, 8], [0, 0, 0, 1, 6, 3, 7, 2, 9], [0, 0, 0, 7, 2, 9, 0, 5, 4], [0, 2, 0, 0, 5, 0, 1, 6, 3], [0, 8, 0, 0, 7, 0, 4, 0, 0], [0, 7, 0, 0, 3, 2, 0, 8, 0], [0, 3, 2, 6, 0, 1, 9, 7, 5]], [[0, 0, 0, 4, 0, 5, 0, 0, 0], [0, 6, 5, 0, 0, 3, 1, 7, 0], [0, 0, 3, 1, 7, 0, 4, 0, 5], [0, 3, 1, 2, 0, 7, 0, 4, 8], [2, 0, 0, 5, 0, 8, 6, 0, 1], [0, 4, 8, 0, 3, 0, 2, 9, 7], [3, 2, 0, 8, 0, 6, 0, 0, 9], [0, 1, 6, 7, 5, 9, 0, 0, 4], [7, 5, 9, 0, 0, 4, 0, 1, 6]], [[7, 5, 0, 9, 4, 0, 0, 6, 2], [9, 4, 0, 0, 6, 2, 0, 0, 1], [8, 6, 2, 0, 5, 1, 0, 0, 0], [1, 9, 7, 5, 2, 8, 6, 3, 4], [5, 2, 8, 6, 3, 0, 1, 9, 0], [6, 0, 4, 1, 9, 7, 0, 0, 0], [2, 1, 5, 4, 8, 9, 3, 7, 6], [4, 8, 9, 0, 7, 6, 0, 1, 5], [3, 7, 6, 2, 1, 5, 4, 0, 0]], [[6, 2, 8, 0, 1, 7, 4, 3, 9], [5, 1, 7, 4, 3, 9, 6, 0, 8], [4, 3, 9, 6, 2, 8, 0, 0, 0], [2, 8, 5, 3, 4, 6, 9, 7, 1], [3, 4, 6, 9, 7, 1, 2, 8, 5], [9, 7, 1, 2, 0, 5, 3, 4, 0], [0, 6, 3, 1, 5, 2, 8, 9, 4], [1, 5, 2, 8, 9, 0, 0, 6, 3], [0, 9, 4, 7, 0, 3, 1, 5, 2]], [[0, 9, 4, 2, 8, 6, 1, 7, 5], [2, 8, 6, 0, 7, 5, 3, 9, 4], [1, 7, 5, 3, 9, 4, 2, 8, 6], [4, 6, 3, 7, 1, 9, 8, 5, 2], [7, 1, 9, 8, 5, 2, 0, 6, 3], [8, 5, 2, 4, 6, 3, 7, 1, 9], [9, 4, 8, 6, 0, 7, 5, 2, 1], [6, 3, 7, 5, 2, 1, 9, 4, 8], [5, 2, 1, 9, 4, 8, 6, 3, 7]]]
	if game == 4:
		var Generator = Gen_new_game.new()
		field = Generator.generate_new_game()
	for a in range(9):
		for b in range(9):
			for c in range(9):
				if field[a][b][c]!=0:
					field[a][b][c]=[str(field[a][b][c]), true, true, [false, false,false,false,false,false, false,false,false,false]]
				else:			# value, set/given, visible, [pencil]
					field[a][b][c]=["", false, true, [false, false,false,false,false,false, false,false,false,false]]
	return 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_signals()
	for i in signals_slices:
		i.depression_signal.connect(_depression_signal_slices)
	for i in signals_numpad:
		i.depression_signal.connect(_depression_signal_numpad)
	$"../VBoxContainer/SubViewportContainer/SubViewport/WorldEnvironment/SpringArm3D".active_block.connect(_active_block)
	for b in range(9):
		buttons.append([])
		label.append([])
		for a in range(9):
			buttons[b].append(Button.new())
			buttons[b][a].set_script(load("res://scripts/Checkbox_XYZ.gd"))
			buttons[b][a].name="Button_"+str(b)+str(a)
			$"Top_Panel/2D_Slice/PanelContainer2/MarginContainer/GridContainer".add_child(buttons[b][a])
			buttons[b][a].custom_minimum_size=Vector2(30,30)
			buttons[b][a].add_theme_stylebox_override("focus",StyleBoxEmpty.new())
			buttons[b][a].flat = true
			buttons[b][a].action_mode = 0
			buttons[b][a].depression_signal.connect(_active_button) 
			
			label[b].append(Label.new())
			buttons[b][a].add_child(label[b][a])
			label[b][a].add_theme_font_size_override("font_size", Font_size.FULL)
			label[b][a].add_theme_constant_override("line_spacing", -4)
			label[b][a].set_anchors_and_offsets_preset(PRESET_FULL_RECT,PRESET_MODE_KEEP_SIZE,0) 
			label[b][a].set_horizontal_alignment(HORIZONTAL_ALIGNMENT_CENTER)
			label[b][a].set_vertical_alignment(VERTICAL_ALIGNMENT_CENTER)
			
	$"Numpad/MarginContainer/VBoxContainer/HBoxContainer/full".set_pressed(true)

func new_game():
	if check_display == true:
		check_sudoku()
	if last_button != null:
	#	last_button.toggle_mode = false
		last_button.flat = true
		last_button = null
		last_button_position=""
	if last_slice_button != null:
		last_slice_button.set_pressed(false)
		last_slice_button = null
	for b in range(9):
		for a in range(9):
			label[b][a].text=""
	undo_stack = []
	undo_position = 0
	active_button_signal.emit("New_Game")


func _process(delta: float) -> void:
# 	print($"../../..".size)
	pass


var last_slice_button
var last_origin
func _depression_signal_slices(origin) -> void:
	origin.set_pressed(true)
	if last_slice_button == origin:
		return
	if last_slice_button != null and origin != last_slice_button:
		last_slice_button.set_pressed(false)
	last_slice_button = origin
	origin = str(origin)
	origin = origin.left(8)
	origin = origin.right(2)
	change_field(origin,true)
	last_origin = origin
	active_slice_signal.emit(origin)


func change_field(origin,change):
	if origin == null:
		return
	if last_button != null and change == true:
		last_button.toggle_mode = false
		last_button.flat = true
		last_button = null
		last_button_position=""
	var direction = origin.left(1)
	var layer = int(origin.right(1))
	if direction == "X":
		var a=layer-1
		for c in range(9):
			for b in range(9):
				if field[c][8-b][a][1] == true:
					label[c][b].add_theme_color_override("font_color", text_color_given)
				else:
					label[c][b].add_theme_color_override("font_color",  text_color_open)
					if field[c][8-b][a][0] != "" and wrong_cells.has(str(c)+str(8-b)+str(a)):
						label[c][b].add_theme_color_override("font_color",  text_color_wrong)
				if str(field[c][8-b][a][0]) != "":
					label[c][b].add_theme_font_size_override("font_size", Font_size.FULL)
					label[c][b].text=str(field[c][8-b][a][0])
				else:
					var text = ""
					for i in range(1,10):
						if field[c][8-b][a] [3][i]:
							text += str(i)
					if text.length() > 5:
						text = text.insert(5,"\n")
					label[c][b].text = text
					label[c][b].add_theme_font_size_override("font_size", Font_size.PENCIL)
	elif direction == "Y":
		var b = 9-layer
		for a in range(9):
			for c in range(9):
				if field[c][b][a] [1] == true:
					label[c][a].add_theme_color_override("font_color", text_color_given)
				else:
					label[c][a].add_theme_color_override("font_color", text_color_open)
					if field[c][b][a][0] != "" and wrong_cells.has(str(c)+str(b)+str(a)):
						label[c][a].add_theme_color_override("font_color",  text_color_wrong)
				if str(field[c][b][a] [0]) != "":
					label[c][a].add_theme_font_size_override("font_size", Font_size.FULL)
					label[c][a].text = str(field[c][b][a] [0])
				else:
					var text = ""
					for i in range(1,10):
						if field[c][b][a] [3][i]:
							text += str(i)
					if text.length() > 5:
						text = text.insert(5,"\n")
					label[c][a].text = text
					label[c][a].add_theme_font_size_override("font_size", Font_size.PENCIL)
	elif direction=="Z":
		var c=9-layer
		for a in range(9):
			for b in range(9):
				if field[c][b][a] [1] == true:
					label[b][a].add_theme_color_override("font_color", text_color_given)
				else:
					label[b][a].add_theme_color_override("font_color", text_color_open)
					if field[c][b][a][0] != "" and wrong_cells.has(str(c)+str(b)+str(a)):
						label[b][a].add_theme_color_override("font_color",  text_color_wrong)
				if str(field[c][b][a] [0]) != "":
					label[b][a].add_theme_font_size_override("font_size", Font_size.FULL)
					label[b][a].text = str(field[c][b][a] [0])
				else:
					var text = ""
					for i in range(1,10):
						if field[c][b][a] [3][i]:
							text += str(i)
					if text.length() > 5:
						text = text.insert(5,"\n")
					label[b][a].text = text
					label[b][a].add_theme_font_size_override("font_size", Font_size.PENCIL)


func _depression_signal_numpad(origin) -> void:
	origin=str(origin)
	origin=origin.left(-21)
	if origin=="Back":
		if undo_position == 0:
			return
		undo_position -= 1
		_depression_signal_slices(undo_stack[undo_position][0])
		_active_button(undo_stack[undo_position][1])
		var c=int(last_button_position)%10
		var b=8-int(last_button_position)/10%10
		var a=int(last_button_position)/100
		if field[c][b][a] [1] == false:
			field[c][b][a] =  undo_stack[undo_position][2].duplicate(true)
			var value = field[c][b][a] [0]
			change_field(last_origin,false)
			number_change_signal.emit()
	elif origin=="Forward":
		if undo_position == undo_stack.size():
			return
		_depression_signal_slices(undo_stack[undo_position][0])
		_active_button(undo_stack[undo_position][1])
		var c=int(last_button_position)%10
		var b=8-int(last_button_position)/10%10
		var a=int(last_button_position)/100
		if field[c][b][a] [1] == false:
			field[c][b][a] = undo_stack[undo_position][3].duplicate(true)
			var value = field[c][b][a] [0]
			change_field(last_origin,false)
			number_change_signal.emit()
		undo_position += 1
	elif origin=="Menue":
		$"Top_Panel".move_child($"Top_Panel/Menue", 2)
	elif origin=="Visibility":
		$"Top_Panel".move_child($"Top_Panel/Visibility", 2)
	elif origin=="Slice":
		$"Top_Panel".move_child($"Top_Panel/2D_Slice", 2)
	elif origin=="Game 1":
		load_data(1)
		new_game()
		$"Top_Panel".move_child($"Top_Panel/2D_Slice", 2)
	elif origin=="Game 2":
		load_data(2)
		new_game()
		$"Top_Panel".move_child($"Top_Panel/2D_Slice", 2)
	elif origin=="Game 3":
		load_data(3)
		new_game()
		$"Top_Panel".move_child($"Top_Panel/2D_Slice", 2)
	elif origin=="Game 4":
		load_data(4)
		new_game()
		$"Top_Panel".move_child($"Top_Panel/2D_Slice", 2)
	elif origin=="New_Game":
		new_game()
	elif origin=="Save_Load":
		print("Save")
	elif origin=="Check":
		check_sudoku()
	elif origin == "full":
		if current_mode == Mode.PENCIL:
			current_mode = Mode.FULL
			$"Numpad/MarginContainer/VBoxContainer/HBoxContainer2/pencil".set_pressed(false)
		$"Numpad/MarginContainer/VBoxContainer/HBoxContainer/full".set_pressed(true)
	elif origin == "pencil":
		if current_mode == Mode.FULL:
			current_mode = Mode.PENCIL
			$"Numpad/MarginContainer/VBoxContainer/HBoxContainer/full".set_pressed(false)
		$"Numpad/MarginContainer/VBoxContainer/HBoxContainer2/pencil".set_pressed(true)
	elif last_button_position != "":  # new value
		var c=int(last_button_position)%10
		var b=8-int(last_button_position)/10%10
		var a=int(last_button_position)/100
		if field[c][b][a] [1] == false:
			var value = origin.right(-4)
			if value == "Del":
				value = ""
			if field[c][b][a][0] == value and current_mode == Mode.FULL:
				return
			if field[c][b][a][0] != "" and current_mode == Mode.PENCIL:
				return
			undo_stack.resize(undo_position)
			undo_stack.append([last_slice_button, last_button, field[c][b][a].duplicate(true)])
			undo_position += 1
			if current_mode == Mode.FULL:
				field[c][b][a][0] = value
				if value != "" and check_display == true:
					check_sudoku()
			else:
				if value == "":
					field[c][b][a] [3] = [false, false,false,false,false,false, false,false,false,false,false]
				field[c][b][a] [3][int(value)] = !field[c][b][a] [3][int(value)]
			undo_stack[-1].append(field[c][b][a].duplicate(true))
			change_field(last_origin,false)
			number_change_signal.emit()
	return
	

var check_display=false
var wrong_cells = {}
var wrong
func check_sudoku():
	if field == []:
		return
	wrong_cells = {}
	check_display = !check_display
	if check_display == false:
		change_background_color(Color("427aff"))
		change_field(last_origin,false)
		check_signal.emit(wrong_cells)
		return
		
	wrong = false
	for c in range(9):
		for b in range(9):
			for a in range(9):
				if field[c][b][a][1] == true:
					continue
				if !check_cell(c,b,a):
					wrong = true
					wrong_cells[str(c)+str(b)+str(a)] = true
	if wrong == true:
		change_background_color(Color("ff0000"))
		change_field(last_origin,false)
		check_signal.emit(wrong_cells)
	else:
		change_background_color(Color("00ff00"))
	return


func check_cell(c,b,a):
	if field[c][b][a][0] == "":
		return false
	for test in range(9):
		if field[c][b][test][0]==field[c][b][a][0] and test != a:
			return false
		if field[c][test][a][0]==field[c][b][a][0] and test != b:
			return false
		if field[test][b][a][0]==field[c][b][a][0] and test != c:
			return false
	for bb in range(b/3*3,b/3*3+3):
		for aa in range(a/3*3,a/3*3+3):
			if field[c][bb][aa][0]==field[c][b][a][0]:
				if aa == a and bb == b : continue
				return false
		for cc in range(c/3*3,c/3*3+3):
			if field[cc][bb][a][0]==field[c][b][a][0]:
				if bb == b and cc == c : continue
				return false
	for cc in range(c/3*3,c/3*3+3):
		for aa in range(a/3*3,a/3*3+3):
			if field[cc][b][aa][0]==field[c][b][a][0]:
				if aa == a and cc == c : continue
				return false
	return true



func change_background_color(color):
	$"Options".get_theme_stylebox("panel").bg_color=color
	$"Top_Panel/2D_Slice/PanelContainer".get_theme_stylebox("panel").bg_color=color
	$"Top_Panel/2D_Slice/PanelContainer2".get_theme_stylebox("panel").bg_color=color
	$"Top_Panel/Visibility".get_theme_stylebox("panel").bg_color=color
	$"Top_Panel/Menue".get_theme_stylebox("panel").bg_color=color
	$"Numpad".get_theme_stylebox("panel").bg_color=color
	return
  

		
var last_button
var last_button_position = ""
func _active_button(origin):
	if last_button != null and origin != last_button:
	#	last_button.toggle_mode = false
		last_button.flat = true
		last_button_position = ""
	if last_slice_button != null:
		last_button = origin
		last_button.toggle_mode=true
		last_button.set_pressed(true)
		last_button.flat = false
		origin=str(origin)
		origin=origin.left(9)
		origin=origin.right(2)

		var layer=str(last_slice_button)
		layer=layer.left(8)
		layer=layer.right(2)
		var direction=layer.left(1)
		layer=int(layer.right(1))
		if direction=="X":
			var a=str(layer-1)
			var b=origin.left(1)
			var c=origin.right(1)
			last_button_position=a+c+b
			active_button_signal.emit(a+c+b)
		elif direction=="Y":
			var b=str(layer-1)
			var a=origin.left(1)
			var c=origin.right(1)
			last_button_position=c+b+a
			active_button_signal.emit(c+b+a)
		elif direction=="Z":
			var c=str(9-layer)
			var a=str(8-int(origin.left(1)))
			var b=origin.right(1)
			last_button_position=b+a+c
			active_button_signal.emit(b+a+c)

func _active_block(origin): #zxy
	_depression_signal_slices(signals_slices[int(origin[1])+9])
	_active_button(buttons[int(origin[2])] [int(origin[0])] )

var value_keys = {  KEY_1:"1", KEY_KP_1:"1",
					KEY_2:"2", KEY_KP_2:"2",
					KEY_3:"3", KEY_KP_3:"3",
					KEY_4:"4", KEY_KP_4:"4",
					KEY_5:"5", KEY_KP_5:"5",
					KEY_6:"6", KEY_KP_6:"6",
					KEY_7:"7", KEY_KP_7:"7",
					KEY_8:"8", KEY_KP_8:"8",
					KEY_9:"9", KEY_KP_9:"9",
					KEY_0:"", KEY_KP_0:"",
					KEY_DELETE:"", KEY_BACKSPACE:"", KEY_SPACE:"",
					}
func _input(event:InputEvent):
	if last_button_position != "":
		var c=int(last_button_position)%10
		var b=8-int(last_button_position)/10%10
		var a=int(last_button_position)/100
		if field[c][b][a][1] == false:
			if event is InputEventKey:
				if event.pressed and value_keys.has(event.keycode):
					var value = value_keys[event.keycode]
					if field[c][b][a][0] == value and current_mode == Mode.FULL:
						return
					if field[c][b][a][0] != "" and current_mode == Mode.PENCIL:
						return
					undo_stack.resize(undo_position)
					undo_stack.append([last_slice_button, last_button, field[c][b][a].duplicate(true)])
					undo_position += 1
					if current_mode == Mode.FULL:
						field[c][b][a][0] = value
						if value != "" and check_display == true:
							check_sudoku()
					else:
						if value == "":
							field[c][b][a] [3] = [false, false,false,false,false,false, false,false,false,false,false]
						field[c][b][a] [3][int(value)] = !field[c][b][a] [3][int(value)]
					undo_stack[-1].append(field[c][b][a].duplicate(true))
					change_field(last_origin,false)
					number_change_signal.emit()
	return
