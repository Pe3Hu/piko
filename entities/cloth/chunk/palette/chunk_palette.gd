class_name ChunkPaletteResource
extends Resource


var order_to_aspect: Dictionary


func _init(pattern_: ChunkPatternResource, notch_: Variant) -> void:
	if notch_ is NotchResource:
		refill_aspects(pattern_, notch_)
	else:
		roll_aspects()
	
func roll_aspects() -> void:
	order_to_aspect.clear()
	var free_aspects: Array[State.Aspect]
	free_aspects.append_array(Catalog.kink_aspects)
	free_aspects.shuffle()
	
	for order in Catalog.kink_orders:
		order_to_aspect[order] = free_aspects.pop_back()
	
func refill_aspects(pattern_: ChunkPatternResource, notch_: NotchResource) -> void:
	if notch_.restriction.consecution.orders.size() == 1:
		roll_aspects()
		return
	
	order_to_aspect.clear()
	var b = notch_.restriction.consecution
	var a = notch_.restriction
	
	#for notch_.restriction
	
	var free_aspects: Array[State.Aspect]
	free_aspects.append_array(Catalog.kink_aspects)
	free_aspects.shuffle()
	
	for order in Catalog.kink_orders:
		order_to_aspect[order] = free_aspects.pop_back()
