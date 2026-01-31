class_name Notch
extends Node2D


var cloth: Cloth
var resource: NotchResource

var is_selected: bool = false



func _input(event_: InputEvent) -> void:
	if event_.is_action("click") and is_selected:
		#print(cloth.legal_coords)
		if resource.cloth.legal_coords.has(resource.coord):
			var chunck_resource = resource.cloth.add_chunck(resource.coord)
			cloth.add_chunck(chunck_resource)
	
func _on_area_2d_mouse_entered() -> void:
	#if chunck != null: return
	is_selected = true
	
func _on_area_2d_mouse_exited() -> void:
	#if chunck != null: return
	is_selected = false
