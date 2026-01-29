extends Node


const CUNCK_SIZE: Vector2 = Vector2(190, 164)

const CHUNK_N: int = 6
const CHUNK_L: int = 90
const CHUNK_ANGLE: float = PI / 3

const MEDIUM_INSIDE_SCALE: float = 0.5
const MEDIUM_OUTSIDE_SCALE: float = 1

var inside_mediums: Array[Vector2]
var outside_mediums: Array[Vector2]


const KINK_COLORS = [
	Color.ROYAL_BLUE,
	Color.CRIMSON,
	Color.WEB_GREEN,
	Color.GOLD
]

const DIRECTION_INDEXS = [0, 1, 2, 3, 4, 5]

const DIRECTION_DIFFERENCES = [
	[
		Vector2i( 0,-1),
		Vector2i(+1,-1),
		Vector2i(+1, 0),
		Vector2i( 0,+1),
		Vector2i(-1, 0),
		Vector2i(-1,-1),
	],
	[
		Vector2i( 0,-1),
		Vector2i(+1, 0),
		Vector2i(+1,+1),
		Vector2i( 0,+1),
		Vector2i(-1,+1),
		Vector2i(-1, 0),
	],
]

func _init() -> void:
	init_mediums()
	
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
	
func get_neighbor(coord_: Vector2i, direction_index_: int) -> Vector2i:
	var parity = coord_.x % 2
	var diff = DIRECTION_DIFFERENCES[parity][direction_index_]
	return coord_ + diff
