class_name Gen_new_game
var Basisfelder = [
	"583174692142659738967238514216895473358427169794361825679542381431986257825713946421596873679382451835741269947613582162958347583274916314869725258137694796425138796823145358417926214965387835742691479136258621589734582371469967254813143698572857931426216574389349682175164327958523869714978145263795418632682793541431256897162745938493826517578319642789451326641273895235698471826937154314562789957184263934268751785193264621457893352986147897514632416732589143625978579841326268379415245619387831745692796823451578164239914382576362957148457296813123478965689531724318457269967238145452196738623579814785641923149823657231784596896315472574962381679382514524961873183574926491238765236795481857416392968153247745629138312847659",
	"193824657674593812258617349716382495582941763439765128325476981841239576967158234825761493319482576467359128258194637943576281671238954796815342532647819184923765746935281582176934931248765394657812167823549825419376418392657679581423253764198517386924438925167692471853149263578825197436763854291254638719986712345371549682384259716926714385175863492637548129491632857258971643869127534713495268542386971269147538751638249843592671582719364376485912914326785137954826425863197698271453471598362893267451526134987965871243214359678387642519642783195158926734739415826938672145265341798714985236873426951659718324142593867581269473397154682426837519652413879147859623389726514421935786738264195596187432973541268264378951815692347",
	"953681274421597386867234915692413857315768492784925163578142639149376528236859741214759638678423591539168427847592316926341785153876249362985174785214963491637852786342159395816742142975863531687924478259631269134578914763285623598417857421396345167892762389415918452376459276183287913564631548927893624751576831249124795638891524763534671928276893154728139645163485279945762831657318492412957386389246517627938541189245637453716289316854792594627318872391456241579863938462175765183924472895316953162874681347592165728439849536127327419685736251948294683751518974263539216487816734259724589631273941568651872943498653712185497326367125894942368175168473925247958163395621748984365271732194856516287394429836517851749632673512489",
	"312748659954631728768259341243976815685312974179485263496123587837564192521897436549163872687925134123874965856231497791548326432697581215789643964312758378456219876592413231487596495316287917854632324769158568123749783645921152978364649231875921687345368254971574193628689412753147935862253768194832576419795841236416329587457931286192876453836542719325687941968124537714359628579418362641293875283765194683425197745319862219768534471593286532876419896241375164932758328657941957184623134259768526748319987631452798365124213487695645912837351894276479126583862573941265874931879163245341925876132748569456291783987536412628357194513489627794612358798316524413592687652487193564129378879653241321874956947261835286735419135948762",
	"152394867683527419947618532418253976365749281729861345594136728836972154271485693794186325215943678368275194536497812972618453841532769127854936459361287683729541836752941479861253521439786297186534184325697653974128368297415712548369945613872348569172196782345275143869689314257723856914514297683432678591961425738857931426527431698834695721619827453372568149451972836968143572785319264243786915196254387961278534752314986483956217145729368896431725237685491619542873578193642324867159285643719347159862196782345861975423539264178472318956953421687624837591718596234473915286961278534852364971724831695618597342395426817246783159187659423539142768619827453528436197734591628953642781247183569186759234871965342395214876462378915",
	"813462975254379681796581342678124593135796824429835167547618239382957416961243758679815234381624597425793168942358716867241359513967482196432875754186923238579641542937816967158423138246759351679248294583671786412935823795164619324587475861392796381542125746938384925671413267859972854163658193724231579486867412395549638217251674389843592716967138425729485631586319247134726598678241953495863172312957864438259167679813254512467893865931472341672985297548316954386721123795648786124539387596421512437869649812537296743185453168792871259643765924318938671254124385976125743698496281375873659214534816927718925436962374851389167542241538769657492183964128753738965142251374986187592364629437518345681279412853697576249831893716425",
	"681372594957164823324985167165837942478629351293541786716258439842793615539416278432859671168723945795641238329415867516378429847296513284937156953164782671582394579416382243598716816237459784962135932154678651783294395641827167825943428379561396281745475936182182754396817693254269547813534812967941325678628479531753168429754693218821475639963128574692754381345281796178369425537816942419532867286947153218547963639812457547369821453128679781936542926475138862794315375681294194253786147935826392681574658472913531246798824793165769158342473569281286317459915824637923168457586247391471593682248379516697815234315624879159482763734956128862731945865724139714359268239816745976581423153462987482937651628173594591248376347695812"
	]
var lines_a = []
var lines_b = []
var lines_c = []
var blocks_a = []
var blocks_b = []
var blocks_c = []
var field = []
var onlys_2d = []
var onlys_3d = []
var singles_2d = []
var singles_3d = []


func generate_new_game():
	var counter_holes=500
	
	# Sudokufeld wählen
	var Basisfeld = Basisfelder.pick_random()
	
	# feld generieren
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
	
	var position = 0
	for a in range(0,9):
		field.append([])
		for b in range(0,9):
			field[a].append([])
			for c in range(0,9):
				field[a][b].append([int(Basisfeld[position]), false, false, false, false, false, false, false, false, false])
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
	
	# poke holes
	while counter_holes>0:
	#	if counter_holes%10 == 0:
	#		await get_tree().create_timer(0.0001).timeout
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
		#	else:
		#		print("!")
			onlys_3d.remove_at(index)
		#	print(counter_holes)
	
	
	
	# mix values
	var mixer = [1,2,3,4,5,6,7,8,9]
	mixer.shuffle()
	for a in range(9):
		for b in range(9):
			for c in range(9):
				if field[a][b][c][0] != 0:
					field[a][b][c] = mixer[field[a][b][c][0]-1]
				else: 
					field[a][b][c] = 0
	
	# rotate
	var direction_list = [0,1,2,3,4,5]
	var direction_a = direction_list.pick_random()
	direction_list.erase(direction_a)
	if direction_a < 3:
		direction_list.erase(direction_a+3)
	else:
		direction_list.erase(direction_a-3)
	var direction_b = direction_list.pick_random()
	direction_list.erase(direction_b)
	if direction_b < 3:
		direction_list.erase(direction_b+3)
	else:
		direction_list.erase(direction_b-3)
	var direction_c = direction_list.pick_random()
	var new_field = []
	for a in range(9):
		new_field.append([])
		for b in range(9):
			new_field[a].append([0,0,0, 0,0,0, 0,0,0])
			for c in range(9):
				var list = [-a, -b, -c, a, b, c]
				new_field[a][b][c] = field[list[direction_a]][list[direction_b]][list[direction_c]]
	
	return new_field
	








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
