class_name Neuron

var _value : float
var _weights : Array
var _bias : float
var _stepSize : float
var _delta : float

func _init(nInputs, stepSize):
	self._stepSize = stepSize
	_weights.resize(2)
	_weights.fill(0.0)
	

func _activationF(x):
	return 1 / (1 + exp(-x))

func _activationFdx(x):
	return x * (1 - x)

func calc(values : Array) -> float:
	var x = 0.0
	for i in values.size():
		x += values[i] * _weights[i]
	_value = _activationF(x) + _bias
	return _value

##When using this on Output layer use error as single connectedDeltas and a Weight of 1
# This like error = error
func calcDelta(connectedDeltas : Array, connectedWeights : Array):
	var error = 0.0
	for i in connectedDeltas.size():
		error += connectedDeltas[i] * connectedWeights[i]
	_delta = error * _activationFdx(_value)

func applyDelta():
	_bias += _delta * _stepSize
	for i in _weights.size():
		_weights[i] += _value * _delta * _stepSize

func _randomize_weights():
	for i in _weights.size():
		_weights[i] = clamp(_weights[i] + _stepSize * (randf() - 0.5), -1.0, 1.0)
