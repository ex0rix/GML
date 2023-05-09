extends Node


var neuralNetwork : NeuralNetwork

func _ready():
	neuralNetwork = NeuralNetwork.new([2, 2, 1], 0.4)
	neuralNetwork._radomize_weights()

var nMax = 100
var step = 0
func _process(delta):
	if nMax > step:
		neuralNetwork._radomize_weights()
		print(step, ": ",neuralNetwork.calc([0.0, 0.0]))
	step += 1
