extends Control

@onready var item_list: ItemList = $ItemList

func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var items: Array[BaseItem] = Autoload.get_player_items()
	
	for i in range(0, clamp(items.size(), 0, 10)):
		var item: BaseItem = items[i]
		item_list.set_item_text(i, item.item_name)
		item_list.set_item_icon(i, item.icon)
