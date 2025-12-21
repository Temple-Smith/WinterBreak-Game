extends Area2D

const SHOP_UI_RES = preload("uid://bv4tyih8540kx")

var shop_ui: Control = null

@export var item_1: String = "placeholder item 1"
@export var item_2: String = "placeholder item 2"
@export var item_3: String = "placeholder item 3"

#this shop guy should only instantiate the ui under the global canvas_layer
#the shop ui itself can handle the rest of the shop
func interact(caller: Node2D) -> void:
	if caller.has_method("set_disable_input"): caller.set_disable_input(true)
	assert(shop_ui == null, "Attempting to open shop ui when its already open (player control should be disabled)")
	assert(Autoload.canvas_layer != null, "Autoload.canvas_layer was null")
	shop_ui = SHOP_UI_RES.instantiate()
	shop_ui.player = caller
	shop_ui.items = [ item_1, item_2, item_3 ]
	Autoload.canvas_layer.add_child(shop_ui)
