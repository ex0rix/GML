class_name Neuron

var _output : float
var _weights : Array
var _bias : float
var _delta : float

func _init(nInputs):
	_weights.resize(nInputs)
	_weights.fill(0.0)

func getDelta():
	return _delta

func getWeight(idx):
	return _weights[idx]

func getWeights():
	return _weights

func getOutput():
	return _output

func _sigmoid(x):
	return 1 / (1 + exp(-x))

func _sigmoidDx(x):
	return x * (1 - x)

func calc(values : Array) -> float:
	var x = 0.0
	for i in values.size():
		x += values[i] * _weights[i]
	_output = _sigmoid(x + _bias)
	return _output

func calcDelta(connectedDeltas : Array, connectedWeights : Array):
	var error = 0.0
	for i in connectedDeltas.size():
		error += connectedDeltas[i] * connectedWeights[i]
	_delta = error * _sigmoidDx(_output)
	#print(_delta)

func applyDelta(neuronInputs : Array, stepSize):
	 ##deltaBias = delta * stepSize
	_bias += _delta * stepSize * 0.1
	#_bias = -1
	##deltaWeight = stepSize
	for i in _weights.size():
		_weights[i] += stepSize * _delta * neuronInputs[i]

func _randomize_weights(stepSize):
	for i in _weights.size():
		_weights[i] = clamp(0.0 + stepSize * (randf() - 0.5), -5.0, 5.0)
	_bias = clamp(_bias + stepSize * (randf() - 0.5), -5.0, 5.0)
	_bias = -2.5
