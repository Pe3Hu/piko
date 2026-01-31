class_name RestrictionResource
extends Resource


var notch: NotchResource
var direction_index_to_aspect: Dictionary
var consecution: ConsecutionResource


func _init(notch_: NotchResource) -> void:
	notch = notch_
	
func check_for_compliance(chunk_: ChunkResource) -> bool:
	for direction_index in direction_index_to_aspect:
		var kink: KinkResource = chunk_.direction_index_to_kink[direction_index]
		
		if kink.aspect != direction_index_to_aspect[direction_index]:
			return false
	
	return true
	
func update_based_on_chunk(chunk_: ChunkResource) -> void:
	var direction: Vector2i = chunk_.coord - notch.coord
	var direction_index: int = Catalog.get_direction_index_based_on_direction(notch.coord, direction)
	var reverse_direction_index: int = Catalog.get_reverse_direction_index(direction_index)
	var kink: KinkResource = chunk_.direction_index_to_kink[reverse_direction_index]
	direction_index_to_aspect[direction_index] = kink.aspect
	update_consecution()
	
func update_consecution() -> void:
	var direction_indexs: Array[int]
	direction_indexs.append_array(direction_index_to_aspect.keys())
	var first_direction_index = Catalog.get_first_direction_index(direction_indexs)
	var aspects: Array[State.Aspect]
	var orders: Array[State.Order]
	var order: State.Order = State.Order.I
	
	for _i in direction_index_to_aspect.keys().size():
		var _j = (first_direction_index + _i) % Catalog.CHUNK_N
		var aspect: State.Aspect = direction_index_to_aspect[_j]
		
		if aspects.has(aspect):
			order = Catalog.get_next_order(order)
		
		aspects.append(aspect)
		orders.append(order)
	
	consecution = Catalog.get_consecution_based_on_orders(orders)
