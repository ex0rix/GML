extends KinematicBody

var maxSpeed = 50.1
var rotIncrem = 1.5
var curSpeed = 0.0
var speedIncrem = 15.8

var startPos : Vector3
var startRot : Vector3

export var nRays := 1
export var maxAngle := 45.0

export var driveCurve : Curve

func _ready():
	startPos = self.translation
	startRot = self.rotation
	
	for n in nRays:
		var newRay = RayCast.new()
		newRay.enabled = true
		newRay.cast_to = Vector3(-25, 0, 0)
		var degRot = float(-(2 * maxAngle * n) / nRays + maxAngle)
		print(degRot, "==>", (2 * PI) / (360 / (degRot)))
		newRay.rotation.y = (2 * PI) / (360 / (degRot))
		$RayContainer.add_child(newRay)

func _physics_process(delta):
#	if Input.is_action_pressed("ui_right"):
#		self.rotation -= Vector3(0, rotIncrem * delta, 0)
#	if Input.is_action_pressed("ui_left"):
#		self.rotation += Vector3(0, rotIncrem * delta, 0)
#	if Input.is_action_pressed("ui_up"):
#		curSpeed += speedIncrem * delta
#		#self.apply_central_impulse(Vector3(-1, 0, 0) * speed * delta)
#	else:
#		curSpeed -= speedIncrem * delta
	curSpeed = clamp(curSpeed, 0, maxSpeed)
	self.move_and_slide(Vector3(-1, 0, 0).rotated(Vector3(0, 1, 0), self.rotation.y) * curSpeed)
	self.move_and_collide(Vector3(0, -1, 0) * 0.0981)

func failed(reason, punish):
	print("Failed reason : ", reason, " with a punish of", punish)
	self.translation = startPos
	curSpeed = 0.0
	self.rotation = startRot

func _on_Area_body_entered(body):
	print(body.name)
	if body.name == "Barrier":
		failed("Conntact with Barrier", -50)
