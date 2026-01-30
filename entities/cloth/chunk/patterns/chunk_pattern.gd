class_name ChunkPatternResource
extends Resource


@export var orders: Array[State.Order]

var order_to_indexs: Dictionary


func init_order_to_indexs() -> void:
	for _i in orders.size():
		var order = orders[_i]
		if !order_to_indexs.has(order):
			order_to_indexs[order] = []
		
		order_to_indexs[order].append(_i)
