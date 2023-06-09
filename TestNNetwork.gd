extends Node

onready var chart: Chart = $HSplitContainer2/HSplitContainer/Container/Chart
var neuralNetwork : NeuralNetwork

var chartFuncs = [Function.new(
			[-1, 0], [0.5, 0.5], "And",
			{
				color = Color(0.992188, 0, 1),
				marker = Function.Marker.NONE,
				type = Function.Type.AREA,
			}
		)]

var run = false

var trainSetAND = {
	"inputs" : [[0.0, 0.0], [0.0, 1.0], [1.0, 0.0], [1.0, 1.0]],
	"outputs" : [[0.0], [0.0], [0.0], [1.0]]
}

var trainSetXOR = {
	"inputs" : [[0.0, 0.0], [0.0, 1.0], [1.0, 0.0], [1.0, 1.0]],
	"outputs" : [[0.0], [1.0], [1.0], [0.0]]
}

var curDataSet = trainSetXOR

func _ready():
	neuralNetwork = NeuralNetwork.new([2, 4, 1], 1.8)
	#$HSplitContainer2/HSplitContainer/Panel/Settings._on_run_pressed()
	run = false
	#seed(42069)
	randomize()
	neuralNetwork.radomize_weights(1.9)
	
	chart.plot(chartFuncs, initContext())

var iter = 0
var bestOutputDif = 1.0
var bestVars = null
func _process(delta):
	if run:
		var totalError = 0.0
		var nTrainingSets = curDataSet["inputs"].size()
		for i in nTrainingSets:
			var outputs = neuralNetwork.calc(curDataSet["inputs"][i])
			##Only ONE output at moment TODO array lenght
			var outputDif = pow(curDataSet["outputs"][i][0] - outputs[0], 2)
			totalError += outputDif
		if totalError != 0:
			totalError = totalError / nTrainingSets
		
		if bestOutputDif > totalError:# || iter % 500 == 0:
			bestOutputDif = totalError
			##Print debug###
			#print(iter, ": ", bestOutputDif)
			var bestLabel = $HSplitContainer2/HSplitContainer/Panel/Settings.get_node("HBoxContainer/Label")
			bestLabel.text = ""
			for i in nTrainingSets:
				
				bestLabel.text += String(curDataSet["inputs"][i])+ " => "
				for j in neuralNetwork.calc(curDataSet["inputs"][i]).size():
					bestLabel.text += "%2.4f" % neuralNetwork.calc(curDataSet["inputs"][i])[j] + "\n"
				#print(curDataSet["inputs"][i], " => ",neuralNetwork.calc(curDataSet["inputs"][i]))
		if iter != 0:
			chartFuncs[0].add_point(iter, totalError)
		
		#neuralNetwork.radomize_weights(-1.1)
		
		##Only ONE output at moment TODO array lenght
		var i = randi() % 4
		var outputs = neuralNetwork.calc(curDataSet["inputs"][i])
		var trainDif = curDataSet["outputs"][i][0] - outputs[0]
		neuralNetwork.backProp(trainSetXOR["inputs"][i] , [trainDif])
	
	##Saves performance
	if iter % 10 == 0:
		chart.update()
	iter += 1

func _on_CheckButton_toggled(button_pressed):
	run = !run

func initContext():
	# Let's customize the chart properties, which specify how the chart
	# should look, plus some additional elements like labels, the scale, etc...
	var cp = ChartProperties.new()
	cp.colors.frame = Color("#161a1d")
	cp.colors.background = Color.transparent
	cp.colors.grid = Color("#283442")
	cp.colors.ticks = Color("#283442")
	cp.colors.text = Color.whitesmoke
	cp.draw_bounding_box = true
	cp.y_tick_size = 1
	cp.title = "ML AI fitness over time"
	cp.x_label = "Iterration"
	cp.y_label = "Fit"
	cp.x_scale = 2
	cp.y_scale = 2
	cp.interactive = true # false by default, it allows the chart to create a tooltip to show point values
	return cp


func _on_Settings_run(nLayer, stepSize, newDataSet):
	curDataSet = newDataSet
	#print("==>", nLayer, stepSize)
	run = true
	neuralNetwork = NeuralNetwork.new(nLayer, stepSize)
	neuralNetwork.radomize_weights(1.9)
	iter = 0
	bestOutputDif = 1.0



func _on_ScrollContainer_resized():
	$HSplitContainer2/ScrollContainer/ArchitectureDiagramm.get_child(0).update()
