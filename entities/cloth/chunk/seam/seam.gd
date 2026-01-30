class_name Seam
extends Sprite2D


var kink: Kink

var direction_index: int:
	set(value_):
		direction_index = value_
		
		position = Catalog.outside_mediums[direction_index] * 0.9
		#var angle = PI * 2 / Catalog.CHUNK_N * index + PI * 11 / 12
		var angle = PI * 2 / Catalog.CHUNK_N * (direction_index - 1)
		rotate(angle)
		kink.chunk.direction_index_to_seam[direction_index] = self
		#print([direction_index, Catalog.aspect_to_string[kink.aspect]])


func custom_rotate(turns_: int) -> void:
	direction_index = (direction_index + turns_ + Catalog.CHUNK_N) % Catalog.CHUNK_N
	kink.chunk.direction_index_to_seam[direction_index] = self
