extends PanelContainer

@onready var item_1: Button = $MainVBox/Items/Item1
@onready var item_2: Button = $MainVBox/Items/Item2
@onready var item_3: Button = $MainVBox/Items/Item3
@onready var item_description: Label = $MainVBox/ItemDescription

var player: CharacterBody2D = null
var shop_guy: Node2D = null

var selected_index: int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(shop_guy.items.size() == 3, "Shop ui must have 3 items")
	assert(player, "Shop ui needs to have a player")
	assert(shop_guy, "Shop ui needs to have a shop guy")
	
	var item_button_group := ButtonGroup.new()
	item_1.button_group = item_button_group
	item_2.button_group = item_button_group
	item_3.button_group = item_button_group
	
	if shop_guy.items[0] != null:
		item_1.text = "%s\nPrice: %d" % [ shop_guy.items[0].item_name, shop_guy.items[0].price ]
	else:
		item_1.text = "Sold out"
	
	if shop_guy.items[1] != null:
		item_2.text = "%s\nPrice: %d" % [ shop_guy.items[1].item_name, shop_guy.items[1].price ]
	else:
		item_2.text = "Sold out"
	
	if shop_guy.items[2] != null:
		item_3.text = "%s\nPrice: %d" % [ shop_guy.items[2].item_name, shop_guy.items[2].price ]
	else:
		item_3.text = "Sold out"
	
	item_button_group.pressed.connect(_on_selection_changed)
	
func _on_selection_changed(selected_button: Button) -> void:
	selected_index = selected_button.get_meta("item_index")
	var selected_item: BaseItem = shop_guy.items[selected_index]
	item_description.text = selected_item.description if selected_item != null else "That item is sold out"

func _on_confirm_button_pressed() -> void:
	assert(Autoload.has_method("get_player_money"))
	assert(Autoload.has_method("set_player_money"))
	var selected_item: BaseItem = shop_guy.items[selected_index]
	
	if selected_index == -1: 
		item_description.text = "No item selected to buy"
		return
		
	if !selected_item:
		item_description.text = "That item is sold out"
		return
		
	var new_money: int = Autoload.get_player_money() - selected_item.price
	if new_money < 0:
		item_description.text = "Youre too broke for that item"
		return
		
	item_description.text = "Bought item" + selected_item.item_name
	Autoload.add_player_item(shop_guy.items[selected_index].duplicate(true))
	shop_guy.items[selected_index] = null
	Autoload.set_player_money(new_money)
	
	_on_cancel_button_pressed()

func _on_cancel_button_pressed() -> void:
	assert(shop_guy.has_method("close_shop"), "Shop guy needs to have a close_shop method")
	shop_guy.close_shop()
