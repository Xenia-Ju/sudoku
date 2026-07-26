extends WorldEnvironment

var cube_material=StandardMaterial3D.new()
var cube_material_slice=StandardMaterial3D.new()
var cube_material_button=StandardMaterial3D.new()
var cube_material_invisible=StandardMaterial3D.new()
var cube_mesh=BoxMesh.new()
var cubes=[]


var text_color_given = Color(0.88,0.88,0.88)
var text_color_open = Color(1,1,1)
var text_color_slice = Color(1,1,0)	
var text_color_button = Color(1,0.6,0)
var text_color_wrong = Color(1.0, 0, 0)
enum Font_size {EMPTY = 85, FULL = 200, PENCIL = 65}
	
	

var label=[]

var distance=1.6
var field=[]  # c,b,a


func load_data():
	
	field = $"../../../../Controls".field
	for c in range(9):
		for b in range(9):
			for a in range(9):  # fild order a b c 
				cubes[c][b][a].material_override=cube_material
				label[c][b][a].font_size = Font_size.FULL
				
				label[c][b][a].text = str(field[8-c][8-b][a][0])
				if field[8-c][8-b][a][1]==true:
					label[c][b][a].modulate = text_color_given
				#	label[c][b][a].outline_modulate=Color("ffffff")
				else:
					label[c][b][a].text = "●" # "▢"
					label[c][b][a].font_size = Font_size.EMPTY
					label[c][b][a].modulate = text_color_open
				#	label[c][b][a].outline_modulate=Color("000000")
	return 


var label_layer 
func _ready() -> void:
	$"../../../../Controls".active_slice_signal.connect(_active_slice_signal) 
	$"../../../../Controls".active_button_signal.connect(_active_button_signal) 
	$"../../../../Controls".number_change_signal.connect(_number_change_signal)
	$"../../../../Controls".check_signal.connect(_check_signal)
	$"../../../../Controls/Top_Panel/Visibility/MarginContainer/VBoxContainer/Swap".depression_signal.connect(_change_visibility)
	$"../../../../Controls/Top_Panel/Visibility/MarginContainer/VBoxContainer/Invis".depression_signal.connect(_change_visibility)
	$"../../../../Controls/Top_Panel/Visibility/MarginContainer/VBoxContainer/Visible".depression_signal.connect(_change_visibility)
	$SpringArm3D.change_view_signal.connect(_change_view_signal)
#	$SpringArm3D.active_button_signal.connect(_active_button_signal)
	cube_material.albedo_color=Color(0.2, 0.2, 0.2, 0.15)
	cube_material.transparency=1
	cube_material_slice.albedo_color=Color(1, 1, 0, 0.35)
	cube_material_slice.transparency=1
	cube_material_button.albedo_color=Color(1, 0.6, 0, 0.70)
	cube_material_button.transparency=1
	cube_material_invisible.albedo_color=Color(0, 0, 0, 0)
	cube_material_invisible.transparency=1

	if true:
		label_layer = $"../../SubViewport2"
		for c in range(9):
			cubes.append([])
			label.append([])
			for b in range(9):
				cubes[c].append([])
				label[c].append([])
				for a in range(9):
					cubes[c][b].append(MeshInstance3D.new())
					cubes[c][b][a].mesh=cube_mesh
					cubes[c][b][a].material_override=cube_material_invisible
					cubes[c][b][a].position=Vector3(b*distance,c*distance,a*distance)
					add_child(cubes[c][b][a])
					label[c][b].append(Label3D.new())
					label[c][b][a].position = Vector3(b*distance,c*distance,a*distance)
					label_layer.add_child(label[c][b][a])
					label[c][b][a].billboard = 1
					label[c][b][a].sorting_offset = 20
					label[c][b][a].outline_size = 10
					label[c][b][a].alpha_cut = 1 # discard


var render_control=false
var viewport_size=Vector2i(0,0)
var render_delay = false
func _process(delta: float) -> void:
	if render_delay == true:
		render_delay = false
		return
	if viewport_size!=get_viewport().size:
		viewport_size = get_viewport().size
		$"..".render_target_update_mode = $"..".UPDATE_ONCE
		$"../../SubViewport2".render_target_update_mode = $"../../SubViewport2".UPDATE_ONCE
	if render_control==false:
		render_control=true
		$"..".render_target_update_mode = $"..".UPDATE_ONCE
		$"../../SubViewport2".render_target_update_mode = $"../../SubViewport2".UPDATE_ONCE


func _change_view_signal():
	render_control = false




var slice_direction
var slice_layer
func _active_slice_signal(slice):
	button_position[0] = false
	render_control = false
	var temp_direction = slice_direction
	var temp_layer = slice_layer
	slice_direction = slice.left(1)
	slice_layer = int(slice.right(1)) -1
	if temp_direction != null:
		change_color_slice(temp_direction, temp_layer)
	change_color_slice(slice_direction, slice_layer)
	

func change_color_slice(direction, layer):
	render_control = false
	if direction == "X":
		var a = layer
		for b in range(8,-1,-1):
			for c in range(8,-1,-1):
				block_representation(c, b, a, "color")
	elif direction == "Y":
		var b = layer
		for a in range(9):
			for c in range(8,-1,-1):
				block_representation(c, b, a, "color")
	elif direction == "Z":
		var c = layer
		for a in range(9):
			for b in range(9):
				block_representation(c, b, a, "color")


var button_position = [false,null]
func _active_button_signal(button):
	render_control = false
	if button == "New_Game":
		if slice_direction != null:
			var temp_direction = slice_direction
			slice_direction = null
			change_color_slice(temp_direction, slice_layer)
			
		load_data()
		return
	var c=8-int(button)%10
	var b=int(button)/10%10
	var a=int(button)/100
	if button_position[0] == true:
		var cc=8-int(button_position[1])%10
		var bb=int(button_position[1])/10%10
		var aa=int(button_position[1])/100
		button_position[0] = null
		block_representation(cc, bb, aa, "color")
	button_position[0] = true
	button_position[1] = button
	block_representation(c, b, a, "color")


func _number_change_signal():
	render_control = false
	var c=8-int(button_position[1])%10
	var b=int(button_position[1])/10%10
	var a=int(button_position[1])/100
	block_representation(c, b, a, "value")


func _change_visibility(origin):
	if field == []:
		return
	render_control = false
	origin = str(origin).left(-21)
	if origin == "Invis":
		if button_position[0] == false:
			return
		var c=8-int(button_position[1])%10
		var b=int(button_position[1])/10%10
		var a=int(button_position[1])/100
		field[8-c][8-b][a] [2] = false
		block_representation(c, b, a)
	if origin == "Visible":
		for c in range(9):
			for b in range(9):
				for a in range(9):
					if field[8-c][8-b][a] [2] == false:
						field[8-c][8-b][a] [2] = true
						block_representation(c, b, a)
	if origin == "Swap":
		for c in range(9):
			for b in range(9):
				for a in range(9):
					field[8-c][8-b][a] [2] = !field[8-c][8-b][a] [2]
					block_representation(c, b, a)


func block_representation (c, b, a, mode = null):
	if field[8-c][8-b][a] [2] == false:
		label[c][b][a].text=""
		cubes[c][b][a].material_override = cube_material_invisible
		return
	
	if mode == null or mode == "color":
		if button_position[1] == str(a) + str(b) + str(8-c) and\
			button_position[0] == true:
			cubes[c][b][a].material_override = cube_material_button
			if wrong_cells.has(str(8-c)+str(8-b)+str(a)):
				label[c][b][a].modulate = text_color_wrong
			else:
				label[c][b][a].modulate = text_color_button
		elif (c == slice_layer and slice_direction == "Z") or\
			 (b == slice_layer and slice_direction == "Y") or\
			 (a == slice_layer and slice_direction == "X"):
			cubes[c][b][a].material_override = cube_material_slice
			if wrong_cells.has(str(8-c)+str(8-b)+str(a)):
				label[c][b][a].modulate = text_color_wrong
			else:
				label[c][b][a].modulate = text_color_slice
		else: 
			cubes[c][b][a].material_override = cube_material
			if field[8-c][8-b][a] [1] == true:
				label[c][b][a].modulate = text_color_given
			elif wrong_cells.has(str(8-c)+str(8-b)+str(a)):
				label[c][b][a].modulate = text_color_wrong
			else:
				label[c][b][a].modulate = text_color_open

	if mode == null or mode == "value":
		if field[8-c][8-b][a][0] != "":
			label[c][b][a].font_size = Font_size.FULL
			label[c][b][a].text=str(field[8-c][8-b][a][0])
			return
		else:
			var text = ""
			for i in range(1,10):
				if field[8-c][8-b][a] [3][i]:
					text += str(i)
			if text == "":
				label[c][b][a].text = "●"
				label[c][b][a].font_size = Font_size.EMPTY
				return
			label[c][b][a].font_size = Font_size.PENCIL
			if text.length() > 5:
				text = text.insert(5,"\n")
			label[c][b][a].text = text


var wrong_cells = []
func _check_signal(new_wrong_cells):
	wrong_cells = new_wrong_cells
	for c in range(9):
		for b in range(9):
			for a in range(9):
				block_representation(c,b,a)
	render_control = false
