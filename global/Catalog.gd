extends Node


#region chunck
const CUNCK_SIZE: Vector2 = Vector2(190, 164)
const CHUNK_SHOWCASE: Vector2i =  Vector2i(-999, -999)

const CHUNK_N: int = 6
const CHUNK_L: int = 95#90
const CHUNK_ANGLE: float = PI / 3

const MEDIUM_INSIDE_SCALE: float = 0.5
const MEDIUM_OUTSIDE_SCALE: float = 1

var inside_mediums: Array[Vector2]
var outside_mediums: Array[Vector2]

var chunk_patterns: Array[ChunkPatternResource] = [
	load("res://entities/cloth/chunk/pattern/aabbcc.tres"),
	load("res://entities/cloth/chunk/pattern/aabcbc.tres"),
	load("res://entities/cloth/chunk/pattern/aabccb.tres"),
	load("res://entities/cloth/chunk/pattern/abcabc.tres"),
	load("res://entities/cloth/chunk/pattern/abcacb.tres"),
]
#endregion

#region kink
const KINK_MEDIUM_POSITION: Vector2 = Vector2.ZERO

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

#region restriction
const orders_to_path = {
	[State.Order.I]: "res://entities/cloth/notch/consecution/consecution_00.tres",
	[State.Order.I, State.Order.I]: "res://entities/cloth/notch/consecution/consecution_10.tres",
	[State.Order.I, State.Order.II]: "res://entities/cloth/notch/consecution/consecution_10.tres",
	[State.Order.I, State.Order.I, State.Order.II]: "res://entities/cloth/notch/consecution/consecution_20.tres",
	[State.Order.I, State.Order.II, State.Order.I]: "res://entities/cloth/notch/consecution/consecution_21.tres",
	[State.Order.I, State.Order.II, State.Order.III]: "res://entities/cloth/notch/consecution/consecution_22.tres",
	}

var consecution_to_patterns = {
	load("res://entities/cloth/notch/consecution/consecution_00.tres"): [
		load("res://entities/cloth/chunk/pattern/aabbcc.tres"),
		load("res://entities/cloth/chunk/pattern/aabcbc.tres"),
		load("res://entities/cloth/chunk/pattern/aabccb.tres"),
		load("res://entities/cloth/chunk/pattern/abcabc.tres"),
		load("res://entities/cloth/chunk/pattern/abcacb.tres"),
	],
	load("res://entities/cloth/notch/consecution/consecution_10.tres"): [
		load("res://entities/cloth/chunk/pattern/aabbcc.tres"),
		load("res://entities/cloth/chunk/pattern/aabcbc.tres"),
		load("res://entities/cloth/chunk/pattern/aabccb.tres"),
	],
	load("res://entities/cloth/notch/consecution/consecution_11.tres"): [
		load("res://entities/cloth/chunk/pattern/aabbcc.tres"),
		load("res://entities/cloth/chunk/pattern/aabcbc.tres"),
		load("res://entities/cloth/chunk/pattern/aabccb.tres"),
		load("res://entities/cloth/chunk/pattern/abcabc.tres"),
		load("res://entities/cloth/chunk/pattern/abcacb.tres"),
	],
	load("res://entities/cloth/notch/consecution/consecution_20.tres"): [
		load("res://entities/cloth/chunk/pattern/aabbcc.tres"),
		load("res://entities/cloth/chunk/pattern/aabcbc.tres"),
		load("res://entities/cloth/chunk/pattern/aabccb.tres"),
	],
	load("res://entities/cloth/notch/consecution/consecution_21.tres"): [
		load("res://entities/cloth/chunk/pattern/aabcbc.tres"),
		load("res://entities/cloth/chunk/pattern/abcacb.tres"),
	],
	load("res://entities/cloth/notch/consecution/consecution_22.tres"): [
		load("res://entities/cloth/chunk/pattern/aabcbc.tres"),
		load("res://entities/cloth/chunk/pattern/aabccb.tres"),
		load("res://entities/cloth/chunk/pattern/abcabc.tres"),
		load("res://entities/cloth/chunk/pattern/abcacb.tres"),
	],
}

func get_first_direction_index(direction_indexs_: Array[int]) -> int:
	for direction_index in direction_indexs_:
		var flag: bool = true
		
		for _i in direction_indexs_.size():
			var _j: int = (direction_index + _i) % CHUNK_N
			
			if !direction_indexs_.has(_j):
				flag = false
				break
		
		if flag:
			return direction_index
	
	return -1
	
func get_next_order(order_: State.Order) -> State.Order:
	var index: int = (kink_orders.find(order_) + 1) % kink_orders.size()
	return kink_orders[index]
	
func get_consecution_based_on_orders(orders_: Array[State.Order]) -> ConsecutionResource:
	var path: String = orders_to_path[orders_]
	var consecution = load(path)
	return consecution
#endregion

#region aspect
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
#endregion

#region init
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
	
#endregion

#region get
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
#endregion
