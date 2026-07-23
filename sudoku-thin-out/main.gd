extends Control

var field
var counter_holes=500
var possibles
var onlys_2d
var onlys_3d
var singles_2d
var singles_3d
var lines_a = []
var lines_b = []
var lines_c = []
var blocks_a = []
var blocks_b = []
var blocks_c = []
	
func initialization():
	for i in range(9):
		lines_a.append([])
		lines_b.append([])
		lines_c.append([])
		blocks_a.append([])
		blocks_b.append([])
		blocks_c.append([])
		for j in range(9):
			lines_a[i].append([null, 0,0,0, 0,0,0, 0,0,0, null, false,false,false, false,false,false, false,false,false])
			lines_b[i].append([null, 0,0,0, 0,0,0, 0,0,0, null, false,false,false, false,false,false, false,false,false])
			lines_c[i].append([null, 0,0,0, 0,0,0, 0,0,0, null, false,false,false, false,false,false, false,false,false])
			blocks_a[i].append([null, 0,0,0, 0,0,0, 0,0,0, null, false,false,false, false,false,false, false,false,false])
			blocks_b[i].append([null, 0,0,0, 0,0,0, 0,0,0, null, false,false,false, false,false,false, false,false,false])
			blocks_c[i].append([null, 0,0,0, 0,0,0, 0,0,0, null, false,false,false, false,false,false, false,false,false])



func load_data():
	
	var seed="00110"
	var load_path="res://seeds/Seed_"+seed+".sv"
	var load_file=FileAccess.open(load_path,FileAccess.READ)
	var position = 0
	var data
	data = load_file.get_var()
	field = []
	onlys_2d = []
	onlys_3d = []
	singles_2d = []
	singles_3d = []
	for a in range(0,9):
		field.append([])
		for b in range(0,9):
			field[a].append([])
			for c in range(0,9):
				field[a][b].append([int(data[position]), false, false, false, false, false, false, false, false, false])
				field[a][b][c] [field[a][b][c][0]] == true
				lines_a[b][c][field[a][b][c][0]] = str(a)+str(b)+str(c)
				lines_a[b][c][field[a][b][c][0]+10] = true
				lines_b[a][c][field[a][b][c][0]] = str(a)+str(b)+str(c)
				lines_b[a][c][field[a][b][c][0]+10] = true
				lines_c[a][b][field[a][b][c][0]] = str(a)+str(b)+str(c)
				lines_c[a][b][field[a][b][c][0]+10] = true
				blocks_a[a][b/3*3+c/3] [field[a][b][c][0]] = str(a)+str(b)+str(c)
				blocks_a[a][b/3*3+c/3] [field[a][b][c][0]+10] = true
				blocks_b[b][a/3*3+c/3] [field[a][b][c][0]] = str(a)+str(b)+str(c)
				blocks_b[b][a/3*3+c/3] [field[a][b][c][0]+10] = true
				blocks_c[c][a/3*3+b/3] [field[a][b][c][0]] = str(a)+str(b)+str(c)
				blocks_c[c][a/3*3+b/3] [field[a][b][c][0]+10] = true
				position = position + 1
				onlys_2d.append(str(a)+str(b)+str(c))
				onlys_3d.append(str(a)+str(b)+str(c))
				singles_2d.append(str(a)+str(b)+str(c))
				singles_3d.append(str(a)+str(b)+str(c))
	load_file.close()
#	print(field)
	return
	
func save_data():
	for a in range(0,9):
		for b in range(0,9):
			for c in range(0,9):
				field[a][b][c] = field[a][b][c][0]
	var seed="00040_test"
	var save_path="res://seeds/Seed_"+seed+".sv"
	var save_file=FileAccess.open(save_path,FileAccess.WRITE)
	save_file.store_var(field)
	save_file.close()
	print("saved")
	print(field)
	return
	
	
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialization()
	load_data()
	while counter_holes>0:
		if counter_holes%10 == 0:
			await get_tree().create_timer(0.0001).timeout
		var pos
		var value
		if onlys_3d.size() == 0:
			break
		else:
			var index = randi_range(0,onlys_3d.size()-1)
			pos = onlys_2d[index]
			value = field[int(pos[0])] [int(pos[1])] [int(pos[2])] [0]
			var result_onlys = check_onlys(pos, value)
			if result_onlys[1] == true:
				var a = int(pos[0])
				var b = int(pos[1])
				var c = int(pos[2])
				field[int(pos[0])] [int(pos[1])] [int(pos[2])] [0] = 0
				counter_holes-=1
				lines_a[b][c][value+10] = false
				lines_b[a][c][value+10] = false
				lines_c[a][b][value+10] = false
				blocks_a[a][b/3*3+c/3] [value+10] = false
				blocks_b[b][a/3*3+c/3] [value+10] = false
				blocks_c[c][a/3*3+b/3] [value+10] = false
			else:
				print("!")
			onlys_3d.remove_at(index)
			print(counter_holes)
		
	
	await get_tree().create_timer(0.0001).timeout
	save_data()
	await get_tree().create_timer(0.0001).timeout
	return
		
	if false:
		var pos #remove this line if recover!!
		possibles=[]
		for a in range(9):
			for b in range(9):
				for c in range(9):
					if field[a][b][c]!=0 and test(a,b,c)==true:
						possibles.append([a,b,c])
		
		if possibles.size()!=0:
	#		var pos=randi_range(0,possibles.size()-1)
			field[possibles[pos][0]][possibles[pos][1]][possibles[pos][2]]=0 
			counter_holes-=1
			print(counter_holes)
		else:
			counter_holes=0
	save_data()


func check_onlys(pos, value):
	var a = int(pos[0])
	var b = int(pos[1])
	var c = int(pos[2])
	var status_3d = false
	var catch_1 = []
	var catch_2 = []
	# checking c lines
	for i in range(3):
		#  check in block with change.
		if c != c/3*3+i:
			if field[a][b][c/3*3+i][0] == 0:
				if lines_b[a][c/3*3+i][value+10] == false:
					catch_1.append(c/3*3+i)
				if lines_a[b][c/3*3+i][value+10] == false:
					catch_2.append(c/3*3+i)
		# check blocks along line.
		if c/3 == i:
			continue
		if blocks_a[a][b/3*3 + i] [value+10] == false:
			for j in range(3):
				if field[a][b][i*3+j][0] == 0:
					if lines_b[a][i*3+j][value+10] == false:
						catch_1.append(i*3+j)
		if blocks_b[b][a/3*3 + i] [value+10] == false:
			for j in range(3):
				if field[a][b][i*3+j][0] == 0:
					if lines_a[b][i*3+j][value+10] == false:
						catch_2.append(i*3+j)
	if catch_1.is_empty() or catch_2.is_empty():
		return [true, true]
	# check for 3d confirmation.
	elif status_3d == false:
		var breaker = false
		for i in catch_1:
			if catch_2.has(i):
				if blocks_c[i][a/3*3 + b/3] [value+10] == false:
					breaker = true
					break
		if breaker == false:
			status_3d = true
		

	catch_1 = []
	catch_2 = []
	# checking b lines
	for i in range(3):
		#  check in block with change.
		if b != b/3*3+i:
			if field[a][b/3*3+i][c][0] == 0:
				if lines_c[a][b/3*3+i][value+10] == false:
					catch_1.append(b/3*3+i)
				if lines_a[b][b/3*3+i][value+10] == false:
					catch_2.append(b/3*3+i)
		# check blocks along line.
		if b/3 == i:
			continue
		if blocks_a[a][i*3 + c/3] [value+10] == false:
			for j in range(3):
				if field[a][i*3+j][c][0] == 0:
					if lines_c[a][i*3+j][value+10] == false:
						catch_1.append(i*3+j)
		if blocks_c[c][a/3*3 + i] [value+10] == false:
			for j in range(3):
				if field[a][i*3+j][c][0] == 0:
					if lines_a[i*3+j][c][value+10] == false:
						catch_2.append(i*3+j)
	if catch_1.is_empty() or catch_2.is_empty():
		return [true, true]
	# check for 3d confirmation.
	elif status_3d == false:
		var breaker = false
		for i in catch_1:
			if catch_2.has(i):
				if blocks_b[i][a/3*3 + c/3] [value+10] == false:
					breaker = true
					break
		if breaker == false:
			status_3d = true


	catch_1 = []
	catch_2 = []
	# checking a lines
	for i in range(3):
		#  check in block with change.
		if a != a/3*3+i:
			if field[a/3*3+i][b][c][0] == 0:
				if lines_b[a/3*3+i][c][value+10] == false:
					catch_1.append(a/3*3+i)
				if lines_c[a/3*3+i][b][value+10] == false:
					catch_2.append(a/3*3+i)
		# check blocks along line.
		if a/3 == i:
			continue
		if blocks_c[c][i*3 + b/3] [value+10] == false:
			for j in range(3):
				if field[i*3+j][b][c][0] == 0:
					if lines_b[i*3+j][c][value+10] == false:
						catch_1.append(i*3+j)
		if blocks_b[b][i*3 + c/3] [value+10] == false:
			for j in range(3):
				if field[i*3+j][b][c][0] == 0:
					if lines_c[i*3+j][b][value+10] == false:
						catch_2.append(i*3+j)
	if catch_1.is_empty() or catch_2.is_empty():
		return [true, true]
	# check for 3d confirmation.
	elif status_3d == false:
		var breaker = false
		for i in catch_1:
			if catch_2.has(i):
				if blocks_a[i][b/3*3 + c/3] [value+10] == false:
					breaker = true
					break
		if breaker == false:
			status_3d = true
	return [false, status_3d]













func test(a,b,c):
	
	# 2D naked singles
	if true :
		# a b
		var possible_numbers=[9,true,true,true,true,true,true,true,true,true]
		for aa in range (9):
			if aa!=a and field[aa][b][c]!=0 and possible_numbers[field[aa][b][c]]==true:
				possible_numbers[field[aa][b][c]]=false
				possible_numbers[0]-=1
		for bb in range (9):
			if bb!=b and field[a][bb][c]!=0 and possible_numbers[field[a][bb][c]]==true:
				possible_numbers[field[a][bb][c]]=false
				possible_numbers[0]-=1
		
		# 3*3
		if true:
			for aa in range(a/3*3,a/3*3+3):
				for bb in range(b/3*3,b/3*3+3):
					if aa!=a or bb!=b:
						if field[aa][bb][c]!=0 and possible_numbers[field[aa][bb][c]]==true:
							possible_numbers[field[aa][bb][c]]=false
							possible_numbers[0]-=1
		if possible_numbers[0]==1:
			return true
		
		possible_numbers=[9,true,true,true,true,true,true,true,true,true]
		for aa in range (9):
			if aa!=a and field[aa][b][c]!=0 and possible_numbers[field[aa][b][c]]==true:
				possible_numbers[field[aa][b][c]]=false
				possible_numbers[0]-=1
		for cc in range (9):
			if cc!=c and field[a][b][cc]!=0 and possible_numbers[field[a][b][cc]]==true:
				possible_numbers[field[a][b][cc]]=false
				possible_numbers[0]-=1
		# 3*3
		if true:
			for aa in range(a/3*3,a/3*3+3):
				for cc in range(c/3*3,c/3*3+3):
					if aa!=a or cc!=c:
						if field[aa][b][cc]!=0 and possible_numbers[field[aa][b][cc]]==true:
							possible_numbers[field[aa][b][cc]]=false
							possible_numbers[0]-=1
		if possible_numbers[0]==1:
			return true
			
		possible_numbers=[9,true,true,true,true,true,true,true,true,true]
		for cc in range (9):
			if cc!=c and field[a][b][cc]!=0 and possible_numbers[field[a][b][cc]]==true:
				possible_numbers[field[a][b][cc]]=false
				possible_numbers[0]-=1
		for bb in range (9):
			if bb!=b and field[a][bb][c]!=0 and possible_numbers[field[a][bb][c]]==true:
				possible_numbers[field[a][bb][c]]=false
				possible_numbers[0]-=1
		# 3*3
		if true:
			for cc in range(c/3*3,c/3*3+3):
				for bb in range(b/3*3,b/3*3+3):
					if cc!=c or bb!=b:
						if field[a][bb][cc]!=0 and possible_numbers[field[a][bb][cc]]==true:
							possible_numbers[field[a][bb][cc]]=false
							possible_numbers[0]-=1
		if possible_numbers[0]==1:
			return true
		
	return false
