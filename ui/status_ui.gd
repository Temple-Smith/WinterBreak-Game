extends Control

@onready var money_label: Label = $MoneyLabel
@onready var hp_bar: TextureProgressBar = $HPBar
@onready var player: Node = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	assert(Autoload.has_method("get_player_money"), "Autoload should have function get_player_money")	
	# Initialize HP bar once
	if player:
		hp_bar.min_value = 0
		hp_bar.max_value = player.max_health
		hp_bar.value = player.current_health

func _process(delta: float) -> void:
	money_label.text = str(Autoload.get_player_money()) + " $"
	

func update_hp_bar() -> void:
	if player:
		hp_bar.value = player.current_health
