extends Node2D

@onready var canvas_layer: CanvasLayer = $CanvasLayer

func _ready() -> void:
	#set the canvas_layer as a global so that any other node can easily reference it
	Autoload.canvas_layer = canvas_layer

func _process(delta: float) -> void:
	pass
