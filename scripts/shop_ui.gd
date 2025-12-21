extends PanelContainer

var player: CharacterBody2D = null

@onready var item_1: Button = $MainVBox/Items/Item1
@onready var item_2: Button = $MainVBox/Items/Item2
@onready var item_3: Button = $MainVBox/Items/Item3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var item_button_group := ButtonGroup.new()
	item_1.button_group = item_button_group
	item_2.button_group = item_button_group
	item_3.button_group = item_button_group
	item_button_group.pressed.connect(selection_changed)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func selection_changed(selected_button: Button) -> void:
	print("selected_button")
