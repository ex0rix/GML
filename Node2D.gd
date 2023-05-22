extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var grid = get_parent().get_node("Grid")
var beginnDraw = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
var currentPointLeft
var currentPointRight
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#update()
	pass
var spaltenAnzahl
var anzahlProSpalte
func setDrawPoints( uebergabeSpaltenAnzahl, uebergabeAnzahlProSpalte ):
	print(spaltenAnzahl)
	beginnDraw = true
	spaltenAnzahl = uebergabeSpaltenAnzahl
	anzahlProSpalte = uebergabeAnzahlProSpalte
	update()

func _draw():
	#print(currentPointLeft.rect_global_position)
	if beginnDraw == true:
		for i in spaltenAnzahl:
			if i+1 < spaltenAnzahl:
				var currentSpalte =grid.get_child(i)
				var nextSpalte = grid.get_child(i+1)
				for j in anzahlProSpalte[i]:
					if j <11:
						currentPointLeft = currentSpalte.get_child(j)
						#print(currentPointLeft.rect_global_position)
						for n in anzahlProSpalte[i+1]:
							currentPointRight = nextSpalte.get_child(n)
	#						print(j)
	#						print(n)
	#						print(currentPointRight)
							var leftPos = Vector2(currentPointLeft.rect_global_position.x+(currentPointLeft.rect_size.x/2),currentPointLeft.rect_global_position.y+(currentPointLeft.rect_size.y/2))
							var rightPos = Vector2(currentPointRight.rect_global_position.x+(currentPointRight.rect_size.x/2),currentPointRight.rect_global_position.y+(currentPointRight.rect_size.y/2))
							draw_line(to_local(leftPos), to_local(rightPos), Color(0, 255, 0), 1.5)
		
		





#func setDrawPoints( spaltenAnzahl, anzahlProSpalte ):
#	print(spaltenAnzahl)
#	beginnDraw = true
#	for i in spaltenAnzahl:
#
#		if i+1 < spaltenAnzahl:
#			var currentSpalte =grid.get_child(i)
#			var nextSpalte = grid.get_child(i+1)
#			for j in anzahlProSpalte[i]:
#				if j <11:
#					currentPointLeft = currentSpalte.get_child(j)
#					print(currentPointLeft.rect_global_position)
#					for n in anzahlProSpalte[i+1]:
#						currentPointRight = nextSpalte.get_child(n)
##						print(j)
##						print(n)
##						print(currentPointRight)
#						_draw()
#	print("aaaaaaaaaaaaaaaaaaaaaaaaaa")
#
#func _draw():
#	#print(currentPointLeft.rect_global_position)
#	if beginnDraw == true:
#		draw_line(currentPointLeft.rect_global_position , currentPointRight.rect_global_position, Color(255, 0, 0), 1)
#	pass
