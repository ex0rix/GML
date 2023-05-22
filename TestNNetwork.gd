extends Node

onready var chart: Chart = $Chart
var neuralNetwork : NeuralNetwork

var chartFuncs = [Function.new(
			[-1, 0], [1, 1], "And",
			{
				color = Color(0.992188, 0, 1),
				marker = Function.Marker.NONE,
				type = Function.Type.AREA,
			}
		)]

var run = true

var trainSetAnd = {
	"inputs" : [[0.0, 0.0], [0.0, 1.0], [1.0, 0.0], [1.0, 1.0]],
	"outputs" : [[0.0], [1.0], [1.0], [0.0]]
}

func _ready():
	neuralNetwork = NeuralNetwork.new([2, 4, 1], 5.1)
	seed(42069)
	neuralNetwork._radomize_weights()
	
	chart.plot(chartFuncs, initContext())

var iter = 0
var bestOutputDif = 1.0
var bestVars = null
func _process(delta):
	if run:
		var totalError = 0.0
		var nTrainingSets = trainSetAnd["inputs"].size()
		for i in nTrainingSets:
			var outputs = neuralNetwork.calc(trainSetAnd["inputs"][i])
			##Only ONE output at moment TODO array lenght
			var outputDif = pow(trainSetAnd["outputs"][i][0] - outputs[0], 2)
			totalError += outputDif
		totalError = totalError / nTrainingSets
		
		if bestOutputDif > totalError:# || iter % 100 == 0:
			bestOutputDif = totalError
			##Print debug###
			print(iter, ": ", bestOutputDif)
			for i in nTrainingSets:
				print(trainSetAnd["inputs"][i], " => ",neuralNetwork.calc(trainSetAnd["inputs"][i]))
		chartFuncs[0].add_point(iter, totalError)
		
		#neuralNetwork._radomize_weights()
		
		##Only ONE output at moment TODO array lenght
		var i = randi() % 4
		neuralNetwork.backProp(trainSetAnd["inputs"][i] , [totalError])
	
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
	cp.y_tick_size = 0.0001
	cp.title = "ML AI fitness over time"
	cp.x_label = "Iterration"
	cp.y_label = "Fitness"
	cp.x_scale = 10
	cp.y_scale = 2
	cp.interactive = true # false by default, it allows the chart to create a tooltip to show point values
	return cp
