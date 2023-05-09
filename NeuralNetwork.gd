class_name NeuralNetwork

var _neuronLayers : Array

func _init(nLayer : Array, stepSize):
	for i in nLayer.size():
		var nPrefNeurons = 1
		if i != 0:
			nPrefNeurons = nLayer[i-1]
		_neuronLayers.append([])
		for j in nLayer[i]:
			_neuronLayers[i].append(Neuron.new(nPrefNeurons, stepSize))

func _radomize_weights():
	for i in _neuronLayers.size():
		for j in _neuronLayers[i].size():
			_neuronLayers[i][j]._randomize_weights()

func calc(inputValues):
	var prefLayerValues = inputValues
	for nLayer in _neuronLayers.size():
		var layerValues = []
		for nNeuron in _neuronLayers[nLayer].size():
			layerValues.append(_neuronLayers[nLayer][nNeuron].calc(prefLayerValues))
		prefLayerValues = layerValues
	return prefLayerValues
