class_name NeuralNetwork

var _neuronLayers : Array
var _stepSize

func _init(nLayer : Array, stepSize):
	self._stepSize = stepSize
	for i in nLayer.size() - 1:
		_neuronLayers.append([])
		for j in nLayer[i+1]:
			_neuronLayers[i].append(Neuron.new(nLayer[i]))
	to_string()
	
func _radomize_weights():
	for i in _neuronLayers.size():
		for j in _neuronLayers[i].size():
			_neuronLayers[i][j]._randomize_weights(_stepSize)

func calc(inputValues):
	var prefLayerValues = inputValues
	for nLayer in _neuronLayers.size():
		var layerValues = []
		for nNeuron in _neuronLayers[nLayer].size():
			layerValues.append(_neuronLayers[nLayer][nNeuron].calc(prefLayerValues))
		prefLayerValues = layerValues
	return prefLayerValues

func backProp(inputValues, costValues):
	for i in _neuronLayers.size():
		var curLayer = _neuronLayers.size() - 1 - i
		print(curLayer)
		var connectedDeltas := []
		for j in _neuronLayers[curLayer].size():
			if curLayer == _neuronLayers.size() - 1:
				connectedDeltas.append(costValues[j])
			else:
				connectedDeltas.append(_neuronLayers[curLayer][j].getDelta())
		
		if curLayer == _neuronLayers.size() - 1:
			for j in _neuronLayers[curLayer].size():
				connectedDeltas.append(1.0)
		else:
			for j in _neuronLayers[curLayer+1].size():
				connectedDeltas.append(_neuronLayers[curLayer+1][j].getDelta())
		print(connectedDeltas)
		
		print(connectedDeltas)
		for nNeuron in _neuronLayers[curLayer].size():
			var connectedWeights := []
			if curLayer == _neuronLayers.size() - 1:
				for j in _neuronLayers[curLayer].size():
					connectedWeights.append(1.0)
			else:
				for j in _neuronLayers[curLayer+1].size():
					connectedWeights.append(_neuronLayers[curLayer+1][j].getWeight(nNeuron))
			print(connectedWeights)
			_neuronLayers[curLayer][nNeuron].calcDelta(connectedDeltas, connectedWeights)
	

	for i in _neuronLayers.size():
		var neuronInputs = []
		if i == 0:
			neuronInputs = inputValues
		else:
			for j in _neuronLayers[i-1].size():
				neuronInputs.append(_neuronLayers[i-1][j].getOutput())
		if neuronInputs.size() == 1:
			breakpoint
		for j in _neuronLayers[i].size():
			_neuronLayers[i][j].applyDelta(neuronInputs, _stepSize)

func getVariables():
	var res = []
	for nLayer in _neuronLayers.size():
		var layerValues = []
		for neuron in _neuronLayers[nLayer]:
			layerValues = [neuron._weights, neuron._bias]
			res.append(layerValues)
	return res

func resetVariables(bestVars):
	var idx = 0
	for nLayer in _neuronLayers.size():
		var layerValues = []
		for neuron in _neuronLayers[nLayer]:
			neuron._weights = []
			neuron._weights.append_array(bestVars[idx][0])
			neuron._bias = bestVars[idx][1]
			idx += 1

func to_string():
	for i in _neuronLayers.size():
		var printStr = ""
		for j in _neuronLayers[i].size():
			printStr += String(_neuronLayers[i][j].getWeights())
		print(printStr)
