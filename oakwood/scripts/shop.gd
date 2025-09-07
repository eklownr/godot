extends Node

@onready var shop = $ShopAnim/anim

func _ready() -> void:
	shop.play("default")
