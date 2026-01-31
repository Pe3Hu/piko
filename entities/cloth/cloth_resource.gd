class_name ClothResource
extends Resource


var showcase_chunk: ChunkResource = ChunkResource.new(self, Catalog.CHUNK_SHOWCASE)


var notchs: Array[NotchResource]
var chunks: Array[ChunkResource]

var internal_coords: Array[Vector2i]
var external_coords: Array[Vector2i]
var legal_coords: Array[Vector2i]

var coord_to_resource: Dictionary


func _init() -> void:
	showcase_chunk.roll_kinks()
	add_chunck(Vector2i.ZERO)
	update_legal_coords()
	
func add_notch(coord_: Vector2i) -> NotchResource:
	if coord_to_resource.has(coord_): return
	var notch: NotchResource = NotchResource.new(self, coord_)
	notchs.append(notch)
	coord_to_resource[coord_] = notch
	
	if !internal_coords.has(coord_):
		external_coords.append(coord_)
		
	return notch
	
func add_chunck(coord_: Vector2i) -> ChunkResource:
	if coord_to_resource.has(coord_):
		var notch_ = coord_to_resource[coord_]
		notchs.erase(notch_)
	
	var chunk: ChunkResource = ChunkResource.new(self, coord_)
	chunks.append(chunk)
	chunk.pattern = showcase_chunk.pattern
	chunk.palette = showcase_chunk.palette
	chunk.custom_rotate(showcase_chunk.turns, true)
	chunk.init_kinks()
	coord_to_resource[coord_] = chunk
	
	if external_coords.has(coord_):
		external_coords.erase(coord_)
	
	internal_coords.append(coord_)
	update_external_coords(coord_)
	chunk.init_neighbors()
	reroll_showcase_chunk()
	return chunk
	
func update_external_coords(coord_: Vector2i) -> void:
	for _i in Catalog.CHUNK_N:
		var coord = Catalog.get_neighbor_coord(coord_, _i)
		add_notch(coord)
	
func reroll_showcase_chunk() -> void:
	var notch = coord_to_resource[Vector2i(1, 0)]
	showcase_chunk.roll_kinks_based_on_notch(notch)
	
func reset_legal_coords() -> void:
	while !legal_coords.is_empty():
		var coord: Vector2i = legal_coords.back()
		set_coord_as_ilegal(coord)
	
func update_legal_coords() -> void:
	for coord in external_coords:
		var notch: NotchResource = coord_to_resource[coord]
		
		if notch.restriction.check_for_compliance(showcase_chunk):
			set_coord_as_legal(coord)
		else:
			set_coord_as_ilegal(coord)
	
func set_coord_as_ilegal(coord_: Vector2i) -> void:
	if legal_coords.has(coord_):
		legal_coords.erase(coord_)
		
func set_coord_as_legal(coord_: Vector2i) -> void:
	legal_coords.append(coord_)
