extends Node


#region chunck
const CUNCK_SIZE: Vector2 = Vector2(190, 164)

const CHUNK_N: int = 6
const CHUNK_L: int = 90
const CHUNK_ANGLE: float = PI / 3

const MEDIUM_INSIDE_SCALE: float = 0.5
const MEDIUM_OUTSIDE_SCALE: float = 1

var inside_mediums: Array[Vector2]
var outside_mediums: Array[Vector2]

var chunk_patterns: Array[ChunkPatternResource] = [
	load("res://entities/cloth/chunk/patterns/aabbcc.tres"),
	load("res://entities/cloth/chunk/patterns/aabcbc.tres"),
	load("res://entities/cloth/chunk/patterns/aabccb.tres"),
	load("res://entities/cloth/chunk/patterns/abcabc.tres"),
	load("res://entities/cloth/chunk/patterns/abcacb.tres"),
]
#endregion

#region kink
const kink_orders: = [
	State.Order.I,
	State.Order.II,
	State.Order.III,
]

const kink_aspects = [
	State.Aspect.STRENGTH,
	State.Aspect.AGILITY,
	State.Aspect.OBSERVATION,
	State.Aspect.ENDURANCE
]
#endregion

#region directon
const direction_indexs = [0, 1, 2, 3, 4, 5]

const direction_differences = [
	[
		Vector2i(+1, 0),
		Vector2i( 0,+1),
		Vector2i(-1, 0),
		Vector2i(-1,-1),
		Vector2i( 0,-1),
		Vector2i(+1,-1),
	],
	[
		Vector2i(+1,+1),
		Vector2i( 0,+1),
		Vector2i(-1,+1),
		Vector2i(-1, 0),
		Vector2i( 0,-1),
		Vector2i(+1, 0),
	],
]
#endregion

const aspect_to_color = {
	State.Aspect.STRENGTH: Color.CRIMSON,
	State.Aspect.AGILITY: Color.WEB_GREEN,
	State.Aspect.OBSERVATION: Color.ROYAL_BLUE,
	State.Aspect.ENDURANCE: Color.GOLD
}

const aspect_to_string = {
	State.Aspect.STRENGTH: "strength",
	State.Aspect.AGILITY: "agility",
	State.Aspect.OBSERVATION: "observation",
	State.Aspect.ENDURANCE: "endurance"
}



func _init() -> void:
	init_mediums()
	init_chunk_patterns()
	
func init_mediums() -> void:
	var vertexs = []
	
	for _i in CHUNK_N:
		var vertex = Vector2.from_angle(PI * 2 / CHUNK_N * _i) * CHUNK_L
		vertexs.append(vertex)
		
		var medium = vertex * MEDIUM_INSIDE_SCALE
		inside_mediums.append(medium)
	
	for _i in CHUNK_N:
		var _j = (_i + 1) % CHUNK_N
		var vertex = (vertexs[_i] + vertexs[_j]) / 2
		vertexs.append(vertex)
		
		var medium = vertex * MEDIUM_OUTSIDE_SCALE
		outside_mediums.append(medium)
	
func init_chunk_patterns() -> void:
	for pattern in chunk_patterns:
		pattern.init_order_to_indexs()
	
func get_neighbor_coord(coord_: Vector2i, direction_index_: int) -> Vector2i:
	var parity = coord_.x % 2
	var direction = direction_differences[parity][direction_index_]
	return coord_ + direction
	
func get_reverse_direction_index(direction_index_: int) -> int:
	var result = (direction_index_ + int(CHUNK_N * 0.5)) % CHUNK_N
	return result
	
func get_direction_index_based_on_direction(coord_: Vector2i, direction_: Vector2i) -> int:
	var parity = coord_.x % 2
	var direction_index = direction_differences[parity].find(direction_)
	return direction_index
