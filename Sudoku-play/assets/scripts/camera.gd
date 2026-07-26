extends SpringArm3D

signal change_view_signal()
signal copy_values(position, direction)
signal active_block(button)

@export var mouse_sensibility_rotation: float=0.005
@export var mouse_sensibility_pan:float=0.02

#var center=Vector3(1.5*4, 1.5*4, 1.5*4)
var direction_start = Vector3(20,20,20)
var direction = direction_start
#var distance=30



func _ready() -> void:
	pass # Replace with function body.

var mouse_left_pressed = false
var mouse_right_pressed = false
var mouse_middle_pressed = false
func _input(event: InputEvent):  
	# select 
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			if $"..".field == []:
				return
			var start_time = Time.get_ticks_usec()
			
			var cam_distance = spring_length
			var display_size = $"../..".size
			var aspect_ratio = float(display_size.x) / display_size.y
			var fov_rad = deg_to_rad($"Camera3D".fov)
			
			var basis_rotation = Basis.from_euler(rotation)
			
			var cam_position = (position + basis_rotation.z * cam_distance)

			
			var pos_x = (event.position.x / display_size.x) * 2.0 - 1.0
			var pos_y = (event.position.y / display_size.y) * 2.0 - 1.0
			
			var angle_x = pos_x * tan(fov_rad / 2.0) * aspect_ratio
			var angle_y = -pos_y * tan(fov_rad / 2.0)
			var local_dir = Vector3(angle_x, angle_y, -1.0).normalized()
			
			var global_dir = basis_rotation * local_dir
			var basis_new = Basis.looking_at(global_dir, basis_rotation.y)
			
			
			var block_distance = $"..".distance
			
			var block_x = []
			var block_y = []
			var block_z = []
			for i in [[block_x,0], [block_y,1], [block_z,2]]:
				if basis_new.z[i[1]] >= 0:  # remove "=" ?
					for j in range(9):
						if j*block_distance-0.5 + 0.06 >= cam_position[i[1]]:
							break
						var temp = []
						temp.append(j*block_distance-0.5)
						temp.append(j*block_distance+0.5)
						if basis_new.z[i[1]] != 0:
							temp.append((cam_position[i[1]] - temp[0]) / basis_new.z[i[1]])
							temp.append((cam_position[i[1]] - temp[1]) / basis_new.z[i[1]])
						else :
							temp.append(1000000.0)
							temp.append(1000000.0)
						i[0].append(temp)
				else:
					for j in range(8,-1,-1):
						if j*block_distance+0.5 - 0.06 <= cam_position[i[1]]:
							break
						var temp = []
						temp.append(j*block_distance+0.5)
						temp.append(j*block_distance-0.5)
						if basis_new.z[i[1]] != 0:
							temp.append((cam_position[i[1]] - temp[0]) / basis_new.z[i[1]])
							temp.append((cam_position[i[1]] - temp[1]) / basis_new.z[i[1]])
						else :
							temp.append(1000000.0)
							temp.append(1000000.0)
						i[0].append(temp)
						
			
			if !block_x or !block_y or !block_z: 
				return
			
			var exit_distance = min( block_x[0][2], block_y[0][2], block_z[0][2])
			
			
			var current_distance = 0
			var result_distance 
			var result_cell
			var result_x
			var result_y
			var result_z
			
			# detechtion loop
			for i in (30):
				if i == 28: 
					return
				if block_x[-1][3] > exit_distance :
					return
				if block_y[-1][3] > exit_distance :
					return
				if block_z[-1][3] > exit_distance :
					return
				
				if block_x[-1][3] <= current_distance :
					if block_x.size() == 1:
						result_cell = "y"
						result_distance = 1000000.0
					elif block_x[-2][3] > exit_distance:
						result_cell = "y"
						result_distance = 1000000.0
					else: 
						result_cell = "x"
						result_distance = block_x[-2][3]
				else:
					result_cell = "x"
					result_distance = block_x[-1][3]
				if block_y[-1][3] <= current_distance :
					if block_y.size() == 1:
						pass
					elif block_y[-2][3] > exit_distance:
						pass
					else: 
						if result_distance > block_y[-2][3]:
							result_cell = "y"
							result_distance = block_y[-2][3]
				else:
					if result_distance > block_y[-1][3]:
						result_cell = "y"
						result_distance = block_y[-1][3]
				if block_z[-1][3] <= current_distance :
					if block_z.size() == 1:
						pass
					elif block_z[-2][3] > exit_distance:
						pass
					else: 
						if result_distance > block_z[-2][3]:
							result_cell = "z"
							result_distance = block_z[-2][3]
				else:
					if result_distance > block_z[-1][3]:
						result_cell = "z"
						result_distance = block_z[-1][3]
				
				if result_distance > exit_distance:
				#	print("result_distance > exit_distance")
					return
				
				current_distance = result_distance
				if result_cell == "x":
					if block_y[-1][2] > current_distance and block_y[-1][3] < current_distance:
						if block_z[-1][2] > current_distance and block_z[-1][3] < current_distance:
							if block_x[-1][3] != current_distance:
								block_x.remove_at(-1)
							result_x = block_x.size()-1
							result_y = block_y.size()-1
							result_z = block_z.size()-1
							if basis_new.z[0] < 0:
								result_x = 8-result_x
							if basis_new.z[1] < 0:
								result_y = 8-result_y
							if basis_new.z[2] < 0:
								result_z = 8-result_z
							if $"..".field[8-result_y][8-result_x][result_z] [2] == true:
								break
				elif result_cell == "y":
					if block_x[-1][2] > current_distance and block_x[-1][3] < current_distance:
						if block_z[-1][2] > current_distance and block_z[-1][3] < current_distance:
							if block_y[-1][3] != current_distance:
								block_y.remove_at(-1)
							result_x = block_x.size()-1
							result_y = block_y.size()-1
							result_z = block_z.size()-1
							if basis_new.z[0] < 0:
								result_x = 8-result_x
							if basis_new.z[1] < 0:
								result_y = 8-result_y
							if basis_new.z[2] < 0:
								result_z = 8-result_z
							if $"..".field[8-result_y][8-result_x][result_z] [2] == true:
								break
				elif result_cell == "z":
					if block_y[-1][2] > current_distance and block_y[-1][3] < current_distance:
						if block_x[-1][2] > current_distance and block_x[-1][3] < current_distance:
							if block_z[-1][3] != current_distance:
								block_z.remove_at(-1)
							result_x = block_x.size()-1
							result_y = block_y.size()-1
							result_z = block_z.size()-1
							if basis_new.z[0] < 0:
								result_x = 8-result_x
							if basis_new.z[1] < 0:
								result_y = 8-result_y
							if basis_new.z[2] < 0:
								result_z = 8-result_z
							if $"..".field[8-result_y][8-result_x][result_z] [2] == true:
								break
				
				while !block_x[-1][2] >= current_distance:
					block_x.remove_at(-1)
					if !block_x:
						return
				while !block_y[-1][2] >= current_distance:
					block_y.remove_at(-1)
					if !block_y:
						return
				while !block_z[-1][2] >= current_distance:
					block_z.remove_at(-1)
					if !block_z:
						return	
			
			active_block.emit(str(result_z)+str(result_x)+str(8-result_y))
			
		#	print(Time.get_ticks_usec()-start_time)
			return
	# rotate
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:   
		if event.is_pressed():
			mouse_right_pressed=true
		else:
			mouse_right_pressed=false
	if event is InputEventMouseMotion and mouse_right_pressed==true:
		rotation.y -= event.relative.x * mouse_sensibility_rotation
		rotation.x -= event.relative.y * mouse_sensibility_rotation
		change_view_signal.emit()
	
	# pan
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_MIDDLE:
		if event.is_pressed():
			mouse_middle_pressed=true
		else:
			mouse_middle_pressed=false
	if event is InputEventMouseMotion and mouse_middle_pressed==true:
		position -=basis.x * event.relative.x * mouse_sensibility_pan
		position +=basis.y * event.relative.y * mouse_sensibility_pan
		change_view_signal.emit()
		
	# zoom
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP:
	#	$".".spring_length-=0.5
		position -= basis.z * 0.5
		change_view_signal.emit()
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
	#	$".".spring_length+=0.5
		position += basis.z * 0.5
		change_view_signal.emit()
	copy_values.emit(position, rotation)
	
	
	
