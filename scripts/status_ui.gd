extends Control

@onready var money_label: Label = $MoneyLabel

func _ready() -> void:
	assert(Autoload.has_method("get_player_money"), "Autoload should have function get_player_money")

func _process(delta: float) -> void:
	money_label.text = str(Autoload.get_player_money())
