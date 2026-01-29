class_name Chunk
extends Node2D


@export var kink_scene: PackedScene

var cloch: Cloth
var coord:  Vector2i:
	set(value_):
		coord = value_
		position = cloch.notchs.map_to_local(coord)

@onready var kinks: Node2D = %Kinks

var free_colors: Array[Color]
var free_indexs: Array[int]


func roll_kinks() -> void:
	free_indexs.append_array(Catalog.DIRECTION_INDEXS)
	free_colors.append_array(Catalog.KINK_COLORS)
	free_indexs.shuffle()
	free_colors.shuffle()
	
	while !free_indexs.is_empty():
		var pair = []
		
		for _i in 2:
			var index = free_indexs.pop_back()
			pair.append(index)
		
		add_kink(pair[0], pair[1])
	
func add_kink(start_index_: int, end_index_: int) -> void:
	var kink = kink_scene.instantiate()
	kinks.add_child(kink)
	kink.start = Catalog.outside_mediums[start_index_]
	kink.medium = Vector2.ZERO
	kink.end = Catalog.outside_mediums[end_index_]
	kink.color = free_colors.pop_back()
	kink.recalc_points()
	
func _input(event) -> void:
	if event is InputEventKey:
		var just_pressed = event.is_pressed() and not event.is_echo()
		
		if just_pressed:
			match event.keycode:
				KEY_Q:
					custom_rotate()
				KEY_E:
					custom_rotate(false)
	
func custom_rotate(is_clockwise_: bool = true) -> void:
	var angle = -Catalog.CHUNK_ANGLE
	if !is_clockwise_:
		angle *= -1
	
	rotate(angle)
