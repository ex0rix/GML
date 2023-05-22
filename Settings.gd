extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var anzahlHiddenlayer = 0
var anzahlInputs = 1
var anzahlOutputs = 1
var neuronenProHiddenlayer = []
var inputs = []
var outputs = []
onready var inputContainer = $VBoxContainer/HBoxContainer4/VBoxContainer/Inputs
onready var outputContainer = $VBoxContainer/HBoxContainer4/VBoxContainer2/outputs
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.




func _on_anzahlHiddenlayer_text_changed(new_text):
	anzahlHiddenlayer = int(new_text)
	if int(new_text) > 0:
		$VBoxContainer/VBoxContainer2.visible = true
	else:
		$VBoxContainer/VBoxContainer2.visible = false









func _on_anzahlInputs_text_entered(new_text):
	anzahlInputs = int(new_text)
	if anzahlInputs > 9:
		anzahlInputs = 9
	for i in inputContainer.get_child_count():
		if i < int(new_text):
			inputContainer.get_child(i).visible = true
		else:
			inputContainer.get_child(i).visible = false
	if int(new_text) == 0:
		anzahlInputs = 1
		inputContainer.get_child(0).visible = true

func _on_anzahlOutputs_text_entered(new_text):
	anzahlOutputs = int(new_text)
	if anzahlOutputs > 9:
		anzahlOutputs = 9
	for i in outputContainer.get_child_count():
		if i < int(new_text):
			outputContainer.get_child(i).visible = true
		else:
			outputContainer.get_child(i).visible = false
	if int(new_text) == 0:
		anzahlOutputs = 1
		inputContainer.get_child(0).visible = true

	

func _on_neuronenProHiddenlayer_text_entered(new_text):
	neuronenProHiddenlayer.clear()
	var stringNeuronenProHiddenlayer = new_text.split(",")
	for i in stringNeuronenProHiddenlayer.size():
		if int(stringNeuronenProHiddenlayer[i]) != null:
			neuronenProHiddenlayer.append( int(stringNeuronenProHiddenlayer[i]))
	print(neuronenProHiddenlayer)




func _on_run_pressed():
	inputs.clear()
	outputs.clear()
	for i in anzahlInputs:
		inputs.append([])
		for j in inputContainer.get_child(i).get_child_count()-1:
			inputs[i].append( int(inputContainer.get_child(i).get_child(j+1).text))
	for i in anzahlOutputs:
		outputs.append([])
		for j in outputContainer.get_child(i).get_child_count()-1:
			outputs[i].append( int(outputContainer.get_child(i).get_child(j+1).text))
	var aProSpalte= []
	aProSpalte[0] = anzahlInputs
	aProSpalte.append_array(neuronenProHiddenlayer)
	aProSpalte[aProSpalte.size()-1] = anzahlOutputs
	get_parent().get_node("ArchitectureDiagramm").changeDiagramm(anzahlHiddenlayer+2, neuronenProHiddenlayer)


func _on_addOneLine_pressed():
	
	for i in inputContainer.get_child_count():
		print("asdasdaa")
		inputContainer.get_child(i).add_child( inputContainer.get_child(i).get_child(1).duplicate())
	for i in outputContainer.get_child_count():
		outputContainer.get_child(i).add_child( outputContainer.get_child(i).get_child(1).duplicate())


func _on_deleteOneLine_pressed():
	if inputContainer.get_child(0).get_child_count() > 2:
		print(inputContainer.get_child_count()-1)
		for i in inputContainer.get_child_count():
			inputContainer.get_child(i).get_child(inputContainer.get_child(i).get_child_count()-1).queue_free()
		for i in outputContainer.get_child_count():
			outputContainer.get_child(i).get_child(outputContainer.get_child(i).get_child_count()-1).queue_free()
