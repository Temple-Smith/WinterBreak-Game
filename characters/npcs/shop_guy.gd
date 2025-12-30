extends Area2D

const SHOP_UI_RES = preload("uid://bv4tyih8540kx")

var shop_ui: Control = null
var player: CharacterBody2D = null

@export var items: Array[BaseItem] = [ null, null, null ]

func _ready() -> void:
	assert(items.size() == 3, "A shop guy needs to have exactly 3 items")

## This shop guy should only instantiate the ui under the global canvas_layer. The shop ui itself can handle the rest of the shop
func interact(calling_node: CharacterBody2D) -> void:
	player = calling_node
	assert(player.has_method("set_disable_input"), "Calling_node needs to have a set_disable_input method")
	assert(Autoload.canvas_layer != null, "Autoload.canvas_layer was null")
	assert(shop_ui == null, "Attempting to open shop ui when its already open (player control should be disabled)")

	player.set_disable_input(true)
	shop_ui = SHOP_UI_RES.instantiate()
	shop_ui.player = player
	shop_ui.shop_guy = self
	Autoload.canvas_layer.add_child(shop_ui)
	
func close_shop() -> void:
	shop_ui.queue_free()
	shop_ui = null
	player.set_disable_input(false)
