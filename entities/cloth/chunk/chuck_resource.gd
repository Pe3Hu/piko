class_name ChunkResource
extends Resource


var cloth: ClothResource
var palette: ChunkPaletteResource
var pattern: ChunkPatternResource

var seams: Array[SeamResource]
var kinks: Array[KinkResource]
var kink_aspects: Array[State.Aspect]

var is_selected: bool = false

var coord: Vector2i
var turns: int = 0

var direction_index_to_kink: Dictionary
var direction_index_to_chunk: Dictionary
var chunk_to_direcion_index: Dictionary


func _init(cloth_: ClothResource, coord_: Vector2i) -> void:
	cloth = cloth_
	coord = coord_
	
func roll_kinks() -> void:
	pattern = Catalog.chunk_patterns.pick_random()
	palette = ChunkPaletteResource.new(pattern, null)
	turns = 0
	init_kinks()
	
func roll_kinks_based_on_notch(notch_: NotchResource) -> void:
	var pattern_options = Catalog.consecution_to_patterns[notch_.restriction.consecution]
	pattern = pattern_options.pick_random()
	palette = ChunkPaletteResource.new(pattern, notch_)
	turns = 0
	init_kinks()
	
func init_kinks() -> void:
	reset_kinks()
	
	for order in pattern.order_to_indexs:
		add_kink(order)
	
func reset_kinks() -> void:
	kinks.clear()
	kink_aspects.clear()
	direction_index_to_kink.clear()
	
func add_kink(order_: State.Order) -> void:
	var direction_indexs: Array[int] = pattern.order_to_indexs[order_]
	var kink = KinkResource.new(self, direction_indexs, palette.order_to_aspect[order_])
	kinks.append(kink)
	kink_aspects.append(kink.aspect)
	
func custom_rotate(turns_: int = 1, is_admin_: bool = false) -> void:
	if turns_ == 0: return
	if !is_selected and !is_admin_: return
	
	turns += turns_
	
	if turns >= Catalog.CHUNK_N:
		turns = turns % Catalog.CHUNK_N
	
	if turns < 0:
		turns += Catalog.CHUNK_N
	
func init_neighbors() -> void:
	for direction_index in Catalog.direction_indexs:
		var neighbor_coord: Vector2i = Catalog.get_neighbor_coord(coord, direction_index)
		if cloth.internal_coords.has(neighbor_coord):
			var neighbor_chunk: ChunkResource = cloth.coord_to_resource[neighbor_coord]
			add_neighbor(neighbor_chunk)
		if cloth.external_coords.has(neighbor_coord):
			var neighbor_notch: NotchResource = cloth.coord_to_resource[neighbor_coord]
			neighbor_notch.restriction.update_based_on_chunk(self)
	
func add_neighbor(chunk_: ChunkResource) -> void:
	var origin_direction = chunk_.coord - coord
	var origin_direction_index = Catalog.get_direction_index_based_on_direction(coord, origin_direction)
	direction_index_to_chunk[origin_direction_index] = chunk_
	chunk_to_direcion_index[chunk_] = origin_direction_index
	var reverse_direction_index = Catalog.get_reverse_direction_index(origin_direction_index)
	chunk_.direcion_index_to_chunk[reverse_direction_index] = self
	chunk_.chunk_to_direcion_index[self] = reverse_direction_index
	
	
	
