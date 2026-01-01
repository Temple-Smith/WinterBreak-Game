class_name StatChangeItem extends BaseItem
## Simple item that changes the players stats in some way

@export var health_change: int
@export var attack_change: int

func apply_stat_item(player: Node2D, item: StatChangeItem) -> void:
	if item.attack_change != 0:
		player.attack_damage += item.attack_change
	if item.health_change != 0:
		player.max_health += item.health_change
		player.current_health += item.health_change  # if you want to heal too
