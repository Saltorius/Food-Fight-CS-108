extends Node2D

onready var isSelected

onready var attackDamage

onready var maxMove
onready var currentMove

onready var maxSize
onready var currentSize

onready var childList

onready var unit_id

func _ready():
	currentSize = 1
	childList = []
	isSelected = false

func init(unitID, aDamage, mMove, cMove, mSize, x, y):
	unit_id = unitID
	attackDamage = aDamage
	maxMove = mMove
	currentMove = cMove
	maxSize = mSize
	position.x = x * 32
	position.y = y * 32
	
	var headBlock = preload("res://Unit/UnitBlock.tscn").instance()
	headBlock.init((int(round(position.x / 32))), (int(round(position.y / 32))), 0, 0, true, 4)
	headBlock.show()
	headBlock.connect("is_selected", self, "setSelection")
	headBlock.connect("move_unit", self, "createUnit")
	add_child(headBlock)
	
func setSelection(selected):
	
	for N in get_children():
		N.isSelected = selected
		
func createUnit(newX, newY):
	print(currentSize)
	
	if(currentSize == maxSize):
		deleteUnit(1)
		currentSize -= 1
	
	var headBlock = preload("res://Unit/UnitBlock.tscn").instance()
	
	headBlock.init((int(round(position.x / 32))), (int(round(position.y / 32))), newX, newY, true, 3)
	headBlock.show()
	headBlock.connect("is_selected", self, "setSelection")
	headBlock.connect("move_unit", self, "createUnit")
	add_child(headBlock)
	currentSize += 1

func deleteUnit(numUnits):
	for i in range(numUnits):
		for N in get_children():
			if(N.emptyNeighbors == 3):
				N.queue_free()
				break
	pass
	
func _process(delta):
	if(Input.is_action_just_released("left_click")):
		var gridX = (int(round(get_global_mouse_position().x / 32))) - (int(round(position.x / 32)))
		var gridY = (int(round(get_global_mouse_position().y / 32))) - (int(round(position.y / 32)))
		var posX = gridX * 32
		var posY = gridY * 32	
		
		for N in get_children():
			if N.unitGridX == gridX and N.unitGridY == gridY:
				isSelected = true
				setSelection(true)
				