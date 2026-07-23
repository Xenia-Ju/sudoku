extends Control


var dim1=0
var dim2=0
var dim3=0
var dim4=0
var dim1_lim=9
var dim2_lim=9
var dim3_lim=9
var dim4_lim=9
var generation_seed=0  #4??
# 1-5
# 4 1:11

# 1,120,181,301,337,360,361,540,
var field=[]
var field_storage=[]
var cells=[]
var line_lookup=[]
var line_lookup_storage=[]
var block_lookup=[]
var block_lookup_storage=[]
var last_value_storage = []
var current_storage = []
var sector_last=[]
var field_backup = []


var current_plane=0
var Failcounter=0
var timer3_memory=Time.get_ticks_msec()
var timer3=1



var new_line_counter1=0
var new_line_counter2=0
var counter=0

var current_a=0
var current_b=0
var current_c=0
var current_d=0

var max_temp=0
var min_temp=0

func create_field(): # erstellung einer 4 dimensionalen matrix
	for d in range(0,9):
		field.append([])
		for c in range(0,9):
			field[d].append([])
			for b in range(0,9):
				field[d][c].append([])
				for a in range(0,9):
					field[d][c][b].append([])
					# [value, 9 * true/false, num possible]
					field[d][c][b][a].append(0)
					for e in range (1,10):
						field[d][c][b][a].append(true)
					field[d][c][b][a].append(9)
	for i in range(0,2): # a,b,c
		line_lookup.append([])
		for j in range(0,9):
			line_lookup[i].append([])
			for k in range(0,9):
				line_lookup[i][j].append([])
				for l in range(0,10):
					line_lookup[i][j][k].append(9)
	for i in range(0,3):
		block_lookup.append([])
		for j in range(0,3):
			block_lookup[i].append([])
			for k in range(0,3):
				block_lookup[i][j].append([])
				for l in range(0,9):
					block_lookup[i][j][k].append([])
					for m in range(0,10):
						block_lookup[i][j][k][l].append(9)




func update_lookup(c,b,a,n):
#	new_line_counter1-=Time.get_ticks_msec()*100000	
#	if a== 7 and b == 7 and c == 3:
#		print("!")
	if line_lookup[0][b][c][n]==1 :
#		print("lookup_kill 0 ", c,b,a," ",n)
#		if a == 7 and b == 7 and c == 3: 
#			pass
		return false
	if line_lookup[1][a][c][n]==1 :
#		print("lookup_kill 1 ", c,b,a," ",n)
#		if a == 7 and b == 7 and c == 3: 
#			pass
		return false
	if block_lookup[0][a/3][b/3][c][n]==1 :
#		print("lookup_kill 2 ", c,b,a," ",n)
#		if a == 7 and b == 3 and c == 3: 
#			pass
		return false
	if block_lookup[1][a/3][c/3][b][n]==1 :
#		print("lookup_kill 3 ", c,b,a," ",n)
#		if a == 7 and b == 3 and c == 3: 
#			pass
		return false
	if block_lookup[2][b/3][c/3][a][n]==1:
#		print("lookup_kill 4 ", c,b,a," ",n)
#		if a == 7 and b == 7 and c == 3: 
#			pass
		return false
#	var chosen_lookup = -1
	if line_lookup[0][b][c][n]!=-1:
		line_lookup[0][b][c] [n] -=1
		if line_lookup[0][b][c][n]==1:
			sector_last.append([0,a,b,c,n])
	if line_lookup[1][a][c][n]!=-1:
		line_lookup[1][a][c] [n] -=1
		if line_lookup[1][a][c][n]==1:
			# introduce checks if the value has already been appended
			sector_last.append([1,a,b,c,n])
	
	if block_lookup[0][a/3][b/3][c][n]!=-1:
		block_lookup[0][a/3][b/3][c] [n] -=1
		if block_lookup[0][a/3][b/3][c][n]==1:
			sector_last.append([3,a/3*3,b/3*3,c,n])
	if block_lookup[1][a/3][c/3][b][n]!=-1:
		block_lookup[1][a/3][c/3][b] [n] -=1
		if block_lookup[1][a/3][c/3][b][n]==1:
			sector_last.append([4,a/3*3,b,c/3*3,n])
	if block_lookup[2][b/3][c/3][a][n]!=-1:
		block_lookup[2][b/3][c/3][a][n] -=1
		if block_lookup[2][b/3][c/3][a][n]==1:
			sector_last.append([5,a,b/3*3,c/3*3,n])
	return true

func only_in_sector_helper(c,b,a,n):
	var local_field = field[0][c][b][a]
	field_backup.append([0,c,b,a,local_field.duplicate(true)])
	for m in range(1,10): # [n+1,false,false...]
		if local_field[m]==true and m!=n:
			if !update_lookup(c,b,a,m):
				return false
			local_field[m]=false
	local_field[10]=1
	determined_pic(0,c,b,a,n)
	return clear_field(0,c,b,a)


var sec_a= 0
var sec_b= 0
var sec_c= 0
var sec_ab=0
var sec_ac=0
var sec_bc=0



func only_in_sector(): 
	while sector_last:
		var sector = sector_last[-1][0]
		var a=sector_last[-1][1]
		var b=sector_last[-1][2]
		var c=sector_last[-1][3]
		var n=sector_last[-1][4]
		sector_last.remove_at(-1)
		if sector==0:
			# only possible position in a lines
			if line_lookup[0][b][c][n]==1:
				for k in range(0,9):
					if field[0][c][b][k][n]==true and field[0][c][b][k][0]==0:
						if only_in_sector_helper(c,b,k,n)==false:
							return false
						sec_a+=1
						break
		elif sector==1:
			# only possible position in b lines
			if line_lookup[1][a][c][n]==1:
				for k in range(0,9):
					if field[0][c][k][a][n]==true and field[0][c][k][a][0]==0:
						if only_in_sector_helper(c,k,a,n)== false:
							return false
						sec_b+=1
						break
		elif sector==3:
			# only possible in a-b 3x3 slices
			if block_lookup[0][a/3][b/3][c][n]==1:
				var breaker=false
				for i in range (a,a+3):
					for j in range(b,b+3):
						if field[0][c][j][i][n]==true and field[0][c][j][i][0]==0:
							if only_in_sector_helper(c,j,i,n)== false:
								return false
							breaker=true
							break
					if breaker==true:
						sec_ab += 1
						break
		elif sector==4:
			# only possible in a-c 3x3 slices
			if block_lookup[1][a/3][c/3][b][n]==1:
				var breaker=false
				for i in range (a,a+3):
					for j in range(max(current_c,c),c+3):
						if field[0][j][b][i][n]==true and field[0][j][b][i][0]==0:
							if only_in_sector_helper(j,b,i,n) == false:
								return false
							breaker=true
							break
					if breaker==true:
						sec_ac += 1
						break
		elif sector==5:
			# only possible in b-c 3x3 slices
			if block_lookup[2][b/3][c/3][a][n]==1:
				var breaker=false
				for i in range (b,b+3):
					for j in range(c,c+3):
						if field[0][j][i][a][n]==true and field[0][j][i][a][0]==0:
							if only_in_sector_helper(j,i,a,n) == false:
								return false
							breaker=true
							break
					if breaker==true:
						sec_bc += 1
						break
	



func clear_field(d,c,b,a):
	var list=[]
	var to_clear=[]
	while true:
		var local_field_1 = field[d]
		var local_field_2 = local_field_1[c]
		var local_field_3 = local_field_2[b]
		var value=field[d][c][b][a][0]
		# lines
		for i in range (0,9): # a
			var local_field = local_field_3[i]
			if local_field[0]==0 and local_field[value]==true : # a
				if local_field[10]==1 or !update_lookup(c,b,i,value):
					return false
				field_backup.append([d,c,b,i,local_field.duplicate(true)])
				local_field[value]=false
				local_field[10]-=1
				if local_field[10]==1:
					list.append([d,c,b,i])
		for i in range (0,9): # b
		#	if c==3 and i==7:
		#		print("here ",value, " ",c,b,a)
		#		print(field[d][c][i][a])
			if field[d][c][i][a][0]==0 and field[d][c][i][a][value]==true : # b
				
			#	if c==3 and i==7:
			#		print("yes")
				if field[d][c][i][a][10]==1 or !update_lookup(c,i,a,value):
					return false
				field_backup.append([d,c,i,a,field[d][c][i][a].duplicate(true)])
				field[d][c][i][a][value]=false
				field[d][c][i][a][10]-=1
				if field[d][c][i][a][10]==1:
					list.append([d,c,i,a])
				
			#	if c==3 and i==7:
			#		print(field[d][c][i][a])
				
				
		# 3x3 square checks
		if true: 
			for i in range((a/3*3),(a/3*3+3)): # a b
				for j in range((b/3*3),(b/3*3+3)): 
					if field[d][c][j][i][0]==0 and field[d][c][j][i][value]==true:
						if field[d][c][j][i][10]==1 or !update_lookup(c,j,i,value):
							return false
						field_backup.append([d,c,j,i,field[d][c][j][i].duplicate(true)])
						field[d][c][j][i][value] =false
						field[d][c][j][i][10]-=1
						if field[d][c][j][i][10]==1:
							list.append([d,c,j,i])
							
		if c < 2: 
			for i in range (0,9): # a
				var local_field = local_field_1[i][b][a]
				if local_field[0]==0 and local_field[value]==true : # c
					if local_field[10]==1 or !update_lookup(i,b,a,value):
						return false
					field_backup.append([d,i,b,a,local_field.duplicate(true)])
					local_field[value]=false
					local_field[10]-=1
					if local_field[10]==1:
						list.append([d,i,b,a])	
						
			for i in range((a/3*3),(a/3*3+3)): # a c
				for j in range((c/3*3),(c/3*3+3)): 
					if field[d][j][b][i][0]==0 and field[d][j][b][i][value]==true:
						if field[d][j][b][i][10]==1 or !update_lookup(j,b,i,value):
							return false
						field_backup.append([d,j,b,i,field[d][j][b][i].duplicate(true)])
						field[d][j][b][i][value] =false
						field[d][j][b][i][10]-=1
						if field[d][j][b][i][10]==1:
							list.append([d,j,b,i])
			for i in range((b/3*3),(b/3*3+3)): # a c
				for j in range((c/3*3),(c/3*3+3)): 
					if field[d][j][i][a][0]==0 and field[d][j][i][a][value]==true:
						if field[d][j][i][a][10]==1 or !update_lookup(j,i,a,value):
							return false
						field_backup.append([d,j,i,a,field[d][j][i][a].duplicate(true)])
						field[d][j][i][a][value] =false
						field[d][j][i][a][10]-=1
						if field[d][j][i][a][10]==1:
							list.append([d,j,i,a])
		
		
		
		if list.size()==0:
			return true
		d=list[-1][0]
		c=list[-1][1]
		b=list[-1][2]
		a=list[-1][3]
		random_pic(d,c,b,a)
		list.remove_at(-1)
		


func new_plane_restrictions(d,c,bb):
	var list = []
	var local_field = []
	var local_field_2 = []
	for b in range(bb-3,bb):
		for a in range(0,9):
			local_field = field[d]
			var value = local_field[c][b][a][0]
			for i in range (current_c,9): # c
				local_field_2 = local_field[i][b][a]
				if local_field_2[0]==0 and local_field_2[value]==true : # c
					if local_field_2[10]==1 or !update_lookup(i,b,a,value):
						return false
					field_backup.append([d,i,b,a,local_field_2.duplicate(true)])
					local_field_2[value]=false
					local_field_2[10]-=1
					if local_field_2[10]==1:
						list.append([d,i,b,a])
			if c >= 6:
				continue
			
			for j in range(max(current_c, c/3*3),(c/3*3+3)): 
				local_field_2 = local_field[j]
				for i in range((b/3*3),(b/3*3+3)): # b c
					if local_field_2[i][a][0]==0 and local_field_2[i][a][value]==true:
						if local_field_2[i][a][10]==1 or !update_lookup(j,i,a,value):
							return false
						field_backup.append([d,j,i,a,local_field_2[i][a].duplicate(true)])
						local_field_2[i][a][value]=false
						local_field_2[i][a][10]-=1
						if local_field_2[i][a][10]==1:
							list.append([d,j,i,a])
				local_field_2 = local_field_2[b]
				for i in range((a/3*3),(a/3*3+3)): # a c
					if local_field_2[i][0]==0 and local_field_2[i][value]==true:
						if local_field_2[i][10]==1 or !update_lookup(j,b,i,value):
							return false
						field_backup.append([d,j,b,i,local_field_2[i].duplicate(true)])
						local_field_2[i][value]=false
						local_field_2[i][10]-=1
						if local_field_2[i][10]==1:
							list.append([d,j,b,i])
	for i in list:
		random_pic(i[0],i[1],i[2],i[3])
	
	for i in list:
		if !clear_field(i[0],i[1],i[2],i[3]):
			return false
	if only_in_sector()==false:
		return false
	return true



func determined_pic(d,c,b,a,n):
	if field[d][c][b][a][10] != 1:
		print("ups1")
		random_pic(d,c,b,a)
		return
	if field[d][c][b][a][n] == false:
		print("ups2")
		random_pic(d,c,b,a)
		return
	count_change += 1
	field[d][c][b][a][0]=n
#	print(d,c,b,a," ",n)
	cells.append([d,c,b,a])
#	line_lookup[0][b][c][0]-=1
	line_lookup[0][b][c] [n] =-1
#	line_lookup[1][a][c][0]-=1
	line_lookup[1][a][c] [n] =-1
#	block_lookup[0][a/3][b/3][c][0]-=1
	block_lookup[0][a/3][b/3][c] [n] =-1
#	block_lookup[1][a/3][c/3][b][0]-=1
	block_lookup[1][a/3][c/3][b] [n] =-1
#	block_lookup[2][b/3][c/3][a][0]-=1
	block_lookup[2][b/3][c/3][a] [n] =-1
#	time_pic+=Time.get_ticks_msec()
	return
	
	
func random_pic(d,c,b,a): # enters the vallue itself
	# var count=randi_range(1,field[a][b][c][d][10])
#	time_pic-=Time.get_ticks_msec()
	var local_field = field[d][c][b][a]
	count_change += 1
	var count = (generation_seed * cells.size()) % local_field[10]
#	print()
#	print(cells.size())
#	print(count)
#	var count = generation_seed % local_field[10]
	if count == 0:
		count = local_field[10]

	while count>0 :
		for i in range(1,10):
			if local_field[i]==true:
				count-=1
				if count==0:
	#				print(i)
					local_field[0]=i  #!!!!
					cells.append([d,c,b,a])
	#				print(d,c,b,a," ",i)
					if local_field[10]>1:
						for n in range(1,10):
							if n!=i and local_field[n]==true:
								update_lookup(c,b,a,n)
					
				#	line_lookup[0][b][c][0]-=1
					line_lookup[0][b][c] [i] =-1
				#	line_lookup[1][a][c][0]-=1
					line_lookup[1][a][c] [i] =-1
					
				#	block_lookup[0][a/3][b/3][c][0]-=1
					block_lookup[0][a/3][b/3][c] [i] =-1
				#	block_lookup[1][a/3][c/3][b][0]-=1
					block_lookup[1][a/3][c/3][b] [i] =-1
				#	block_lookup[2][b/3][c/3][a][0]-=1
					block_lookup[2][b/3][c/3][a] [i] =-1
					
					if a==0 and b==0 and c%3==0:
						field[d][c][b][a]=[i,false,false,false,false,false,false,false,false,false,1]
						local_field[i]=true
					if a==0 and b==0 and c==7 and field[d][c+1][b][a][10]==2:
						field[d][c][b][a]=[i,false,false,false,false,false,false,false,false,false,1]
						local_field[i]=true
				#	time_pic+=Time.get_ticks_msec()
					return

var count_change = 0
func block_in_a_line_restrictions(d,c,bb):
	var changed = true
	if changed:
		changed = false
		var list = []
		for a in [0,3,6]:
			for b in range(bb, bb/3*3+3):
				var value_a = [field[d][c][b/3*3][a][0], false, []]
				var value_b = [field[d][c][b/3*3][a+1][0], false, []]
				var value_c = [field[d][c][b/3*3][a+2][0], false, []]
				var all = {}
				for j in [value_a,value_b,value_c]:
					for i in range(0,9):
						if j[0] == field[d][c][b][i][0] :
							j[1] = true
							j[2] == [i]
							all[i] = null
							break
						if field[d][c][b][i][0] == 0  and field[d][c][b][i][j[0]]:
							j[2].append(i)
							all[i] = null
				if all.size() == 1:
					return false
					print("this should not")
				if all.size() == 2:
				#	print("bad")
					return false
					for i in range(0,9):
						print(field[d][c][b][i])
					return false
				if all.size() == 3:
				#	print("this")
				#	print(value_a[0],value_b[0],value_c[0])
				#	print(all)
					var values = {value_a[0]:null,value_b[0]:null,value_c[0]:null}
					for j in all:
						if field[d][c][b][j][0] == 0 :
						#	print(field[d][c][b][j])
							for i in range(1,10): # value
								if field[d][c][b][j][i] == true:
									if !values.has(i):
								#		count_change += 1
							#			print(d,c,b,j,i)
										if !update_lookup(c,b,j,i):
											return false
										field_backup.append([d,c,b,j,field[d][c][b][j].duplicate(true)])
										field[d][c][b][j][i]=false
										field[d][c][b][j][10]-=1
										changed = true
										if field[d][c][b][j][10]==1:
											list.append([d,c,b,j])
				
		for i in list:
			random_pic(i[0],i[1],i[2],i[3])
		for i in list:
			if !clear_field(i[0],i[1],i[2],i[3]):
				return false
		if only_in_sector()==false:
			return false
		
	return true


func block_in_a_line_up_restrictions(d,cc,b):
	return true
	var changed = true
	if changed:
		changed = false
		var list = []
		for a in [0,3,6]:
			for c in range(cc, cc/3*3+3):
				var value_a = [field[d][c/3*3][b][a][0], false, []]
				var value_b = [field[d][c/3*3][b][a+1][0], false, []]
				var value_c = [field[d][c/3*3][b][a+2][0], false, []]
				var all = {}
				for j in [value_a,value_b,value_c]:
					for i in range(0,9):
						if j[0] == field[d][c][b][i][0] :
							j[1] = true
							j[2] == [i]
							all[i] = null
							break
						if field[d][c][b][i][0] == 0  and field[d][c][b][i][j[0]]:
							j[2].append(i)
							all[i] = null
				if all.size() == 1:
					print("this should not")
				if all.size() == 2:
					print("bad")
					return false
					for i in range(0,9):
						print(field[d][c][b][i])
					return false
				if all.size() == 3:
				#	print("this")
				#	print(value_a[0],value_b[0],value_c[0])
				#	print(all)
					var values = {value_a[0]:null,value_b[0]:null,value_c[0]:null}
					for j in all:
						if field[d][c][b][j][0] == 0 :
						#	print(field[d][c][b][j])
							for i in range(1,10): # value
								if field[d][c][b][j][i] == true:
									if !values.has(i):
								#		count_change += 1
										print(d,cc,b)
										print(value_a[0],value_b[0],value_c[0])
										print(all)
										print(d,c,b,j,i)
										
										if !update_lookup(c,b,j,i):
											return false
										field_backup.append([d,c,b,j,field[d][c][b][j].duplicate(true)])
										field[d][c][b][j][i]=false
										field[d][c][b][j][10]-=1
										changed = true
										if field[d][c][b][j][10]==1:
											list.append([d,c,b,j])
				
		for i in list:
			random_pic(i[0],i[1],i[2],i[3])
		for i in list:
			if !clear_field(i[0],i[1],i[2],i[3]):
				return false
		if only_in_sector()==false:
			return false
		
	return true



func block_in_b_line_restrictions(d,c):
	var changed = true
	if changed:
		changed = false
		var list = []
		for b in [0]:
			for aa in range(0,9):
				var value_a = [field[d][c][b][aa][0], false, []]
				var value_b = [field[d][c][b+1][aa][0], false, []]
				var value_c = [field[d][c][b+2][aa][0], false, []]
				for a in range(aa/3*3, aa/3*3+3):
					if aa == a: continue
				#	print(a)
				#	print(value_a,value_b,value_c)
					var all = {}
					for j in [value_a,value_b,value_c]:
						for i in range(0,9):
							if j[0] == field[d][c][i][a][0] :
								j[1] = true
								j[2] == [i]
								all[i] = null
								break
							if field[d][c][i][a][0] == 0  and field[d][c][i][a][j[0]]:
								j[2].append(i)
								all[i] = null
					if all.size() == 1:
						print("this should not")
					if all.size() == 2:
						print("bad")
					#	for i in range(0,9):
					#		print(field[d][c][i][a])
						return false
					if all.size() == 3:
					#	continue
					#	print("this")
					#	print(value_a[0],value_b[0],value_c[0])
					#	print(all)
						var values = {value_a[0]:null,value_b[0]:null,value_c[0]:null}
						for j in all:
						#	print(d,c,j,a,field[d][c][j][a])
							if field[d][c][j][a][0] == 0 :
								print("possible")
								print(field[d][c][j][a])
								for i in range(1,10): # value
									if field[d][c][j][a][i] == true:
										if !values.has(i):
									#		count_change += 1
											print(d,c,j,a,i)
											if !update_lookup(c,j,a,i):
												return false
											field_backup.append([d,c,j,a,field[d][c][j][a].duplicate(true)])
											field[d][c][j][a][i]=false
											field[d][c][j][a][10]-=1
											changed = true
											if field[d][c][j][a][10]==1:
												list.append([d,c,j,a])
					
		for i in list:
			random_pic(i[0],i[1],i[2],i[3])
		for i in list:
			if !clear_field(i[0],i[1],i[2],i[3]):
				return false
		if only_in_sector()==false:
			return false
		
	return true


func a_line_check_for_added_restrictions(d,c,b):
	return true
	var changed = true
	while changed:
		changed = false
		var list = []
		for n in range(1,10): #value
			# a b blocks.
		#	(block_lookup[0][4/3][1/3][1][4])
			var check_1 = block_lookup[0][1][b/3][c][n]  # a b block

			for i in range(3,6):
				if field[d][c][b][i][n] == true:
					check_1 -= 1
			if check_1 == 0:
				for i in range(0,9):
					if i == 3 or i==4 or i==5: continue
			#		print(i)
					if field[d][c][b][i][n] == true:
						if field[d][c][b][i][0] != 0:
							print("this should not happen, a line added checks")
							return false
						if !update_lookup(c,b,i,n):
							return false
						field_backup.append([d,c,b,i,field[d][c][b][i].duplicate(true)])
						field[d][c][b][i][n]=false
						field[d][c][b][i][10]-=1
						changed = true
						if field[d][c][b][i][10]==1:
							list.append([d,c,b,i])

	#	print("!")
		for i in list:
			random_pic(i[0],i[1],i[2],i[3])
		for i in list:
			if !clear_field(i[0],i[1],i[2],i[3]):
				return false
		if only_in_sector()==false:
			return false
	return true


func reduction_4th_layer():
#	print("here")
	var b = 0
	var a = 0
	var breaker = false
	for j in range(0,3):
		for i in range(0,9):
			if field[0][4][j][i][10]==2:
				b=j
				a=i
				breaker = true
		if breaker == true:
			break
	if breaker == true:
		field_backup.append([0,4,b,a,field[0][4][b][a].duplicate(true)])
		random_pic(0,4,b,a)
		field[0][4][b][a]=[field[0][4][b][a][0],false,false,false,false,false,false,false,false,false,1]
		field[0][4][b][a][field[0][4][b][a][0]]=true
		if !clear_field(0,4,b,a):
			return false
		if only_in_sector()==false:
			return false
#	else:
#		show_higher()
	return true
	
	
func next_number():
	var d=0
	var c=current_c
	var b=current_b
	var a=current_a
	var save = true
	
	if b % 3 != 0 and save == true:
		save = block_in_a_line_restrictions(d,c,b)
#	if save == true and b % 3 != 0:
#		save = block_in_a_line_up_restrictions(d,c,b-1)

	while cells.has([d,c,b,a]) and save == true:
		a+=1 
		if a==9:
			a=0
			var s=""
			for i in (9):
				s+= str(field[d][c][b][i][0])
	#		if c < 3:
	#			print(d,c,b," ", s)
			b+=1
			if b % 3 == 0 and c >= 2:
				save = new_plane_restrictions(d,c,b)
				if save == false: break
				if c == 3 and b == 3:
					save = reduction_4th_layer()
					if save == false: break
		#		if c >= 3 and b >=3 and b <6:
		#			save = block_in_b_line_restrictions(d,c)
		#			if save == false: break
		#	if b != 9:
		#		save = a_line_check_for_added_restrictions(d,c,b)
		#		if save == false: break
			if b % 3 != 0:
				save = block_in_a_line_restrictions(d,c,b)
				if save == false: break
				save = block_in_a_line_up_restrictions(d,c,b-1)
				if save == false: break
			if b==9:
				b=0
				c+=1
				if c==9:
					break
	if c<current_plane:
		if current_plane>=6 and c<6:
			timer3_memory=Time.get_ticks_msec()
		current_plane=c
	if c>current_plane:
		current_plane=c
		if current_plane==6:
			timer3=timer3+Time.get_ticks_msec()-timer3_memory
	if c>=6:
		pass
	return [d,c,b,a,save]


func show_display(start_time):
	if min_temp>current_c*100+current_b*10+current_a:
		min_temp=current_c*100+current_b*10+current_a
	if max_temp<current_c*100+current_b*10+current_a:
		max_temp=current_c*100+current_b*10+current_a
		min_temp=max_temp
	$Label.text=(str(min_temp-1)+" "+str(max_temp-1)+" "+str(100*current_c+10*current_b+current_a-1)+"  "+str(counter)+" "+str(Failcounter)+" "+str(new_line_counter1)+" "+str(new_line_counter2))
	var text_l2=""
	var text_l3=""
	var text_l4=""
	var text_l5=""
	var text_l6=""
	var timer=(Time.get_ticks_msec()-start_time)/1000
	timer=str(timer/3600)+"h "+str(timer%3600/60)+"m "+str(timer%3600%60)+"s"
	for i in range (0,9):
		text_l2=text_l2+" "+str(field[current_d][3][0][i][10])
		text_l3=text_l3+" "+str(field[current_d][3][1][i][10])
		text_l4=text_l4+" "+str(field[current_d][3][2][i][10])
		text_l5=text_l5+" "+str(field[current_d][3][3][i][10])
		text_l6=text_l6+" "+str(field[current_d][6][0][i][10])
	$Label2.text=(text_l2)
	$Label3.text=(text_l3)
	$Label4.text=(text_l4)
	$Label5.text=(text_l5)
	$Label6.text=(text_l6)
	$Label7.text=timer
	
#	OS.delay_msec(500)


var fail_1 = 0
var fail_2 = 0
var time_backup = 0
var time_save = 0
var time_next = 0
var time_pic = 0
var time_checks = 0
var time_only = 0

func show_remaining():
	var local_field = field[0][3]
	
	for j in range(3,9):
		var line = ""
		for i in range(0,9):
			var remaining = ""
			for n in range(1,10):
				if local_field[j][i][n] == true:
					remaining += str(n)
			line = line + remaining + " "
		print(line)
		
func show_higher():
	var local_field = field[0][6]
	print()
	for j in range(0,3):
		var line = ""
		for i in range(0,9):
			var remaining = ""
			for n in range(1,10):
				if local_field[j][i][n] == true:
					remaining += str(n)
			line = line + remaining + " "
		print(line)

func save_data():
	var save_d = ""
	for a in range(0,1):
		for b in range(0,9):
			for c in range(0,9):
				for d in range(0,9):
					save_d = save_d + str(field[a][b][c][d][0])
					field[a][b][c][d] = field[a][b][c][d][0]
	var save_path="res://seeds/Seed_"+str(generation_seed).pad_zeros(5)+".sv"
	var save_file=FileAccess.open(save_path,FileAccess.WRITE)
	OS.delay_msec(1)
	save_file.store_var(save_d)
	save_file.close()


func _ready():
	var start_time =Time.get_ticks_msec()
	print(start_time)
	create_field()	
	print(Time.get_ticks_msec()-start_time)
	
	while true:
		field=[]
		field_storage=[]
		cells=[]
		line_lookup=[]
		line_lookup_storage=[]
		block_lookup=[]
		block_lookup_storage=[]
		last_value_storage = []
		current_storage = []
		sector_last=[]
		field_backup = []
		current_plane=0
		Failcounter=0
		timer3_memory=Time.get_ticks_msec()
		timer3=1
		new_line_counter1=0
		new_line_counter2=0
		counter=0
		current_a=0
		current_b=0
		current_c=0
		current_d=0
		generation_seed+=1
		start_time =Time.get_ticks_msec()
		create_field()	
		var found_it = true
		while current_c<9:
			if (Time.get_ticks_msec()-start_time)>1000:
				found_it = false
				break
			counter+=1
			if counter%10==0:
				await get_tree().create_timer(0.001).timeout
				show_display(start_time)
			
			var secures=""
			
			while true: 
			#	var s = ""
			#	for i in range(0,9):
			#		if field[0][3][7][i][6] == true:
			#			s+= "X"
			#		else:
			#			s+= "6"
			#	print("! ",s)
			#	print("! ",line_lookup[0][7][3][6])
			#	print("next ", current_d,current_c,current_b,current_a)
		#		if current_c==3 and current_b==3 and current_a==0:
		#			show_remaining()
		#			print()
				if current_c==6:
					pass
					if current_b==0 and current_a == 0:
				#		show_higher()
						pass
				if secures=="kill":
					secures=""
					while true:
						time_backup-=Time.get_ticks_msec()
						Failcounter+=1
				#		print("fail	")
						
						while field[cells[-1][0]] [cells[-1][1]] [cells[-1][2]] [cells[-1][3]][10]<=1:
							cells.remove_at(cells.size()-1)
						current_d=cells[-1][0]
						current_c=cells[-1][1]
						current_b=cells[-1][2]
						current_a=cells[-1][3]
						if current_c==7 and current_b==0 and current_a==0 and field[current_d][current_c][current_b][current_a][10]!=1:
							print(field[current_d][current_c][current_b][current_a])
						var temp=field[current_d][current_c][current_b][current_a]
						
						field_backup.reverse()
						for i in field_backup:
							field[i[0]][i[1]][i[2]][i[3]] = i[4]
						field_backup = []
						
						if cells[-1] == last_value_storage[-1]:
							last_value_storage.remove_at(-1)
							
							field_backup = field_storage[-1]
							field_backup.reverse()
							for i in field_backup:
								field[i[0]][i[1]][i[2]][i[3]] = i[4]
							field_backup = []
							field_storage.remove_at(-1)
							
							line_lookup_storage.remove_at(-1)
							block_lookup_storage.remove_at(-1)
						
						line_lookup=line_lookup_storage[-1].duplicate(true)
						block_lookup=block_lookup_storage[-1].duplicate(true)
						cells.remove_at(cells.size()-1)
						
						var sector_kill = false
						field_backup.append([current_d,current_c,current_b,current_a,field[current_d][current_c][current_b][current_a].duplicate(true)])
						for n in range(1,10):
							if field[current_d][current_c][current_b][current_a][n]==true and temp[n]==false:
								if !update_lookup(current_c,current_b,current_a,n):
									sector_kill = true
									break
						if sector_kill == true or update_lookup(current_c,current_b,current_a,temp[0]) == false:
							print("rerun")
							continue
						field[current_d][current_c][current_b][current_a]=temp
						field[current_d][current_c][current_b][current_a][ temp[0]]=false
						field[current_d][current_c][current_b][current_a][10]-=1
						field[current_d][current_c][current_b][current_a][0]=0
						
						time_backup+=Time.get_ticks_msec()
						break
						
						
						
				else:
					if field[current_d][current_c][current_b][current_a][0]!=0:
						pass
						print(current_d,current_c,current_b,current_a)
						print(field[current_d][current_c][current_b][current_a])
						pass
					# error catcher
					if field[current_d][current_c][current_b][current_a][10]<1:
						print("Stopper ready next number bricht field[a][b][c][d][10]<1")
						print(current_d,current_c,current_b,current_a)
						print(field[current_d][current_c][current_b][current_a])
						await get_tree().create_timer(100000).timeout
						
					
					
					var breaker=true
					var temp_position =[]
					if cells.has([current_d,current_c,current_b,current_a])==false:
						
						time_pic-=Time.get_ticks_msec()
						field_backup.append([current_d,current_c,current_b,current_a,field[current_d][current_c][current_b][current_a].duplicate(true)])
						random_pic(current_d,current_c,current_b,current_a)
						time_pic+=Time.get_ticks_msec()
						time_checks-=Time.get_ticks_msec()
						if clear_field(current_d,current_c,current_b,current_a)==false:
							fail_1 += 1
							breaker=false
							secures="kill" # neede to return to eliminating numbers
							pass
						time_checks+=Time.get_ticks_msec()
						time_only-=Time.get_ticks_msec()
						if breaker == true:
							if only_in_sector()==false:
								fail_2 += 1
								breaker=false
								secures="kill" # neede to return to eliminating numbers
								pass
						
						time_only+=Time.get_ticks_msec()
						# generate next number
						if breaker == true:
							time_next-=Time.get_ticks_msec()
							temp_position=next_number()
						#	current_d=temp_position[0]
						#	current_c=temp_position[1]
						#	current_b=temp_position[2]
						#	current_a=temp_position[3]
							var local_breaker = temp_position[4]
							if current_c==9:
								break
							if local_breaker == false:
								fail_2 += 1
								secures = "kill"
								breaker = false
							time_next+=Time.get_ticks_msec()
						if breaker==true:
							time_save-=Time.get_ticks_msec()
							if field[current_d][current_c][current_b][current_a][10]>1: # currently causes an error.
								last_value_storage.append([current_d, current_c, current_b, current_a])
								field_storage.append(field_backup.duplicate(true))
								line_lookup_storage.append(line_lookup.duplicate(true))
								block_lookup_storage.append(block_lookup.duplicate(true))
							elif current_a!=0 or current_b!=0 or current_c!=0 :
								field_storage[-1].append_array(field_backup)
								line_lookup_storage[-1]=line_lookup.duplicate(true)
								block_lookup_storage[-1]=block_lookup.duplicate(true)
							field_backup = []
							time_save+=Time.get_ticks_msec()
								
								
						if temp_position != []:
							current_d=temp_position[0]
							current_c=temp_position[1]
							current_b=temp_position[2]
							current_a=temp_position[3]
					
					sector_last=[]
					if breaker==true:
						break
			pass
		
		var runtime = (Time.get_ticks_msec()-start_time)/1000
		var minutes = runtime/60
		var seconds = runtime%60
		if seconds < 10:
			seconds = "0"+str(seconds)
		if found_it:
			save_data()
	#	if !found_it:
	#		found_it=""
		print(generation_seed," ",minutes,":",seconds," ",found_it)
		if generation_seed == 10000:
			break
		
	if true:
		if current_d > 8:
			current_d = 8
		if current_c > 8:
			current_c = 8
		show_display(start_time)
	
	if true:
		for cc in range(0,9):
			print("c",cc+1)
			for bb in range(0,9):
				var result=""
				for aa in range(0,9):
					result=result+str(field[0][cc][bb][aa][0])+" "
				print(result)
			print()
	print(Time.get_ticks_msec()-start_time)
	print(cells.size())
	print(9*9*9)
	var check_dict={}
	for i in cells:
		if i in check_dict:
			print(i)
		else:
			check_dict[i]= true
#	save_data()
	print()
	print(sec_a)
	print(sec_b)
	print(sec_c)
	print(sec_ab)
	print(sec_ac)
	print(sec_bc)
	print()
	print(fail_1)
	print(fail_2)
	print()
	print(time_backup)
	print(time_save)
	print(time_next)
	print(time_pic)
	print(time_checks)
	print(time_only)
	print()
	print(count_change)
	await get_tree().create_timer(0.01).timeout
	
	print(timer3)
