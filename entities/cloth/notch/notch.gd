class_name Notch
extends Node2D


var cloth: Cloth
var chunck: Chunk:
	set(value_):
		chunck = value_
		#$Area2D.visible = false

var coord: Vector2i:
	set(value_):
		coord = value_
		position = cloth.notchs.map_to_local(coord)

var is_selected: bool = false


func _input(event_: InputEvent) -> void:
	if event_.is_action("click") and is_selected:
		if cloth.legal_coords.has(coord):
			cloth.add_chunck(coord)
	
func _on_area_2d_mouse_entered() -> void:
	if chunck != null: return
	is_selected = true
	
func _on_area_2d_mouse_exited() -> void:
	if chunck != null: return
	is_selected = false
