extends Node


class Neuron:
	var _weights : Array
	var _bias : float
	var _stepSize : float

	func _init(nInputs, stepSize):
		self._stepSize = stepSize
		_weights.resize(2)
		_weights.fill(0.0)

	func _aF(x):
		return x
#		if x > 0:
#			return x
#		return 0

	func calc(values : Array) -> float:
		var x = 0.0
		for i in values.size():
			x += values[i] * _weights[i]
		return _aF(x) + _bias

	func _randomize_weights():
		for i in _weights.size():
			_weights[i] = clamp(_weights[i] + _stepSize * (randf() - 0.5), -1.0, 1.0)




var dataAdd = {
		"inputs" : [[0.5, 0.5], [1.0, 0.5], [1.0, 0.0], [0.0, 0.0], [1.0, 1.0], [0.5, 1.0], [0.5, 0.0]],
		"outputs" : [1.0, 1.5, 1.0, 0.0, 2.0, 1.5, 0.5]
}

var dataSub = {
		"inputs" : [[0.5, 0.5], [1.0, 0.5], [1.0, 0.0], [0.0, 0.0], [1.0, 1.0], [0.5, 1.0], [0.5, 0.0]],
		"outputs" : [0.0, 0.5, 1.0, 0.0, 0.0, -0.5, 0.5]
}

var data = dataAdd

#var sNeuron
var neuronEnvs : Array 

func _ready():
	randomize()
	var randSeed = randi()
	seed(6001)
	print("Rand Seed : ",randSeed)
	#sNeuron = Neuron.new(2, 0.5)
	
	var chartFuncs = [
		Function.new(
			[-1, 0], [1, 1], "Add5.0",
			{
				color = Color(0.476562, 1, 0),
				marker = Function.Marker.NONE,
				type = Function.Type.AREA,
			}
		),
		Function.new(
			[-1, 0], [1, 1], "Add2.5",
			{
				color = Color(0.382812, 1, 0),
				marker = Function.Marker.NONE,
				type = Function.Type.AREA,
			}
		),
		Function.new(
			[-1, 0], [1, 1], "Add0.5",
			{
				color = Color(0, 1, 0.4375),
				marker = Function.Marker.NONE,
				type = Function.Type.AREA,
			}
		),
				Function.new(
			[-1, 0], [1, 1], "Sub5.0",
			{
				color = Color(1, 0, 0.890625),
				marker = Function.Marker.NONE,
				type = Function.Type.AREA,
			}
		),
		Function.new(
			[-1, 0], [1, 1], "Sub2.5",
			{
				color = Color(1, 0, 0.304688),
				marker = Function.Marker.NONE,
				type = Function.Type.AREA,
			}
		),
		Function.new(
			[-1, 0], [1, 1], "Sub0.5",
			{
				color = Color(0.992188, 0, 1),
				marker = Function.Marker.NONE,
				type = Function.Type.AREA,
			}
		),
	]
	
	neuronEnvs = [
	{
		neuron = Neuron.new(2, 2.5),
		data = dataAdd,
		chartFunc = chartFuncs[0],
		bestOutputDif = 1.0,
		bestWeights = [],
		resetNum = 50,
		fitnessMult = 1.9
	},{
		neuron = Neuron.new(2, 2.5),
		data = dataAdd,
		chartFunc = chartFuncs[1],
		bestOutputDif = 1.0,
		bestWeights = [],
		resetNum = 50,
		fitnessMult = 1.9
	},{
		neuron = Neuron.new(2, 2.5),
		data = dataAdd,
		chartFunc = chartFuncs[2],
		bestOutputDif = 1.0,
		bestWeights = [],
		resetNum = 50,
		fitnessMult = 1.9
	},{
		neuron = Neuron.new(2, 2.5),
		data = dataSub,
		chartFunc = chartFuncs[3],
		bestOutputDif = 1.0,
		bestWeights = [],
		resetNum = 50,
		fitnessMult = 1.9
	},{
		neuron = Neuron.new(2, 2.5),
		data = dataSub,
		chartFunc = chartFuncs[4],
		bestOutputDif = 1.0,
		bestWeights = [],
		resetNum = 50,
		fitnessMult = 1.9
	},{
		neuron = Neuron.new(2, 2.5),
		data = dataSub,
		chartFunc = chartFuncs[5],
		bestOutputDif = 1.0,
		bestWeights = [],
		resetNum = 50,
		fitnessMult = 1.9
	}]
	randomize()
	chart.plot(chartFuncs, initContext())

onready var chart: Chart = $Chart
var f1: Function
var cp: ChartProperties

func initContext():
	
	# Let's customize the chart properties, which specify how the chart
	# should look, plus some additional elements like labels, the scale, etc...
	cp = ChartProperties.new()
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

var iter = 0
var startTime
var end = false
func _process(delta):
	iter += 1
	var i = 0
	while i < neuronEnvs.size():
		if updateNeuron(neuronEnvs[i], iter) == "done":
			neuronEnvs.remove(i)
			i -= 1
		i += 1
	if iter == 1:
		startTime = OS.get_unix_time()
	if end == false && neuronEnvs.size() == 0:
		end = true
		var timeForTask = OS.get_unix_time() - startTime;
		$CheckButton.disabled == true
		$Label.text += String(timeForTask)
	if iter % 10 == 0:
		chart.update()

func updateNeuron(neuronEnv, iter):
	var avgOutputDif : float = 0.0
	for dataIdx in neuronEnv.data["inputs"].size():
#		if String(sNeuron._weights) == "[1, -1]":
#			breakpoint
		#print("dataInput : ", data["inputs"][dataIdx])
		var trainOutput = neuronEnv.neuron.calc(neuronEnv.data["inputs"][dataIdx])
		#print("Output : ", data["outputs"][dataIdx], " - ",trainOutput, " = ")
		var outputDif = abs(neuronEnv.data["outputs"][dataIdx] - trainOutput)
		#var outputDif = 0.5*pow(neuronEnv.data["outputs"][dataIdx] - trainOutput, 2.0)
		#print("Err : ", outputDif)
		avgOutputDif += outputDif
	avgOutputDif /= neuronEnv.data["inputs"].size()
	#avgOutputDif *= 0.5
	
	neuronEnv.chartFunc.add_point(iter, avgOutputDif)
	#chart.update()
	
	neuronEnv.neuron._randomize_weights()
	#print("Weights : ", sNeuron._weights)
	
	if neuronEnv.bestOutputDif > avgOutputDif:
		neuronEnv.bestOutputDif = avgOutputDif
		if avgOutputDif < 0.00_1:
			#set_process(false)
			print("Training Done")
			print("\n === Training Done === \n - ", neuronEnv.chartFunc.name," -  - ", iter ," -\n")
			#data["inputs"].append_array([[200, 2], [35, 64]])
			for dataIdx in data["inputs"].size():
				var trainOutput = neuronEnv.neuron.calc(data["inputs"][dataIdx])
				print("Input : ", data["inputs"][dataIdx],"; Output : ", int(trainOutput * 100) / 100.0)
			return "done"
		neuronEnv.neuron._stepSize = avgOutputDif * neuronEnv.fitnessMult
		neuronEnv.bestWeights.clear()
		neuronEnv.bestWeights.append_array(neuronEnv.neuron._weights)
		#print(">>>", neuronEnv.neuron._stepSize, "; Best Weights : ", neuronEnv.bestWeights)

	##opt
	if neuronEnv.resetNum > 0 and iter % neuronEnv.resetNum == 0:
		#print("\n === reset Weights === \n - ", iter ," -\n")
		neuronEnv.neuron._weights.clear()

		neuronEnv.neuron._weights.append_array(neuronEnv.bestWeights)
		#print("Best Weights : ", neuronEnv.neuron._weights, "; fitness : ", neuronEnv.bestOutputDif)
		#print("Cur Weights : ", sNeuron._weights, "; fitness : ", avgOutputDif, "; stepSize : ", sNeuron._stepSize)

func _on_CheckButton_toggled(button_pressed):
	set_process(button_pressed)
