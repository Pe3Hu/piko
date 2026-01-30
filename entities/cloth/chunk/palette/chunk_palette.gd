class_name ChunkPaletteResource
extends Resource


var  order_to_aspect: Dictionary


func _init() -> void:
	roll_aspects()
	
func roll_aspects() -> void:
	order_to_aspect.clear()
	var free_aspects = []
	free_aspects.append_array(Catalog.kink_aspects)
	free_aspects.shuffle()
	
	for order in Catalog.kink_orders:
		order_to_aspect[order] = free_aspects.pop_back()
