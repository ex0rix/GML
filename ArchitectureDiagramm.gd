
extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var spalte = $Spalte
onready var grid = $Grid
onready var drawer = $Drawer
export(int)var Spaltenanzahl = 6;
export(Array,int) var anzahlProSpalte = [51,5,3,9,2,11]
 
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in Spaltenanzahl:
		var newSpalte = spalte.duplicate()
		print(newSpalte)
#		var parent = newSpalte.get_parent()
#		print(parent)
#		parent.remove_child(newSpalte);
		grid.add_child(newSpalte)

		if Spaltenanzahl > anzahlProSpalte.size():
			for j in Spaltenanzahl - anzahlProSpalte.size():
				anzahlProSpalte.append(1)
		for j in anzahlProSpalte[i]:
			if j <11:
				newSpalte.get_child(j).visible = true
				print(newSpalte.get_child(j).rect_global_position)
			else:
				break
	for i in grid.get_child_count():
		print(grid.get_child(i))
	$Timer.start()

func changeDiagramm(Anzahl, aProSpalte):
	for i in grid.get_child_count():
		grid.get_child(i).queue_free()
	print(Anzahl)
	print(aProSpalte)
	Spaltenanzahl = Anzahl
	anzahlProSpalte = aProSpalte
	for i in Spaltenanzahl:
		var newSpalte = spalte.duplicate()
		
#		var parent = newSpalte.get_parent()
#		print(parent)
#		parent.remove_child(newSpalte);
		grid.add_child(newSpalte)

		if Spaltenanzahl > anzahlProSpalte.size():
			for j in Spaltenanzahl - anzahlProSpalte.size():
				anzahlProSpalte.append(1)
		for j in anzahlProSpalte[i]:
			if j <11:
				newSpalte.get_child(j).visible = true
				
			else:
				break
	$Timer.start()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _draw():
	pass

func inputchange(inputs,outputs):
	pass

func _on_Timer_timeout():
	drawer.setDrawPoints(Spaltenanzahl,anzahlProSpalte)
