class_name KinkResource
extends Resource


var chunk: ChunkResource
var direction_indexs: Array[int]:
	set(value_):
		direction_indexs = value_
		update_chuck_data()
var aspect: State.Aspect


func _init(chunk_: ChunkResource, direction_indexs_: Array, aspect_: State.Aspect) -> void:
	chunk = chunk_
	direction_indexs = direction_indexs_
	aspect = aspect_
	
func get_seams_positions() -> Array[Vector2]:
	var positions: Array[Vector2]
	
	for direction_index in direction_indexs:
		var position = Catalog.outside_mediums[direction_index]
		positions.append(position)
	
	return positions
	
func update_chuck_data() -> void:
	for direction_index in direction_indexs:
		chunk.direction_index_to_kink[direction_index] = self
