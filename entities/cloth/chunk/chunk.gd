class_name Chunk
extends Node2D


@export var kink_scene: PackedScene
@export var seam_scene: PackedScene

@export var is_selected: bool = false

var palette: ChunkPaletteResource
var pattern: ChunkPatternResource

@export var cloth: Cloth
var coord:  Vector2i:
	set(value_):
		coord = value_
		position = cloth.notchs.map_to_local(coord)
var turns: int = 0

@onready var kinks: Node2D = %Kinks
@onready var seams: Node2D = %Seams

var kink_aspects: Array[State.Aspect]

var direction_index_to_seam: Dictionary
var direcion_index_to_chunk: Dictionary
var chunk_to_direcion_index: Dictionary


func roll_kinks() -> void:
	pattern = Catalog.chunk_patterns.pick_random()
	palette = ChunkPaletteResource.new()
	turns = 0
	rotation = 0
	init_kinks()
	
func init_kinks() -> void:
	reset_kinks()
	
	#print(pattern.order_to_indexs)
	for order in pattern.order_to_indexs:
		add_kink(order)
	
func reset_kinks() -> void:
	kink_aspects.clear()
	direction_index_to_seam.clear()
	
	while kinks.get_child_count() > 0:
		var kink = kinks.get_child(0)
		kinks.remove_child(kink)
		kink.queue_free()
	
	while seams.get_child_count() > 0:
		var seam = seams.get_child(0)
		seams.remove_child(seam)
		seam.queue_free()
	
func add_kink(order_: State.Order) -> void:
	var indexs = pattern.order_to_indexs[order_]
	var kink = kink_scene.instantiate()
	kinks.add_child(kink)
	kink.chunk = self
	kink.start = Catalog.outside_mediums[indexs[0]]
	kink.medium = Vector2.ZERO
	kink.end = Catalog.outside_mediums[indexs[1]]
	kink.aspect = palette.order_to_aspect[order_]
	kink_aspects.append(kink.aspect)
	kink.recalc_points()
	
	for _i in indexs:
		add_seam(kink, _i)
	
func add_seam(kink_: Kink, direction_index_: int) -> void:
	var seam = seam_scene.instantiate()
	seams.add_child(seam)
	seam.kink = kink_
	seam.direction_index = direction_index_
	
	if !is_selected:
		cloth.ilegal_seams.append(seam)
	
func custom_rotate(turns_: int = 1, is_admin_: bool = false) -> void:
	if turns_ == 0: return
	if !is_selected and !is_admin_: return
	
	turns += turns_
	
	if turns >= Catalog.CHUNK_N:
		turns = turns % Catalog.CHUNK_N
	
	if turns < 0:
		turns += Catalog.CHUNK_N
	
	var angle = Catalog.CHUNK_ANGLE * turns
	rotation = angle
	rotate_seams(turns_)
	
func rotate_seams(turns_: int) -> void:
	direction_index_to_seam.clear()
	
	for seam in seams.get_children():
		seam.custom_rotate(turns_)
	
func init_neighbors() -> void:
	for direction_index in Catalog.direction_indexs:
		var neighbor_coord = Catalog.get_neighbor_coord(coord, direction_index)
		if cloth.internal_coords.has(neighbor_coord):
			var neighbor_chunk = cloth.coord_to_scene[neighbor_coord]
			add_neighbor(neighbor_chunk)
	
func add_neighbor(chunk_: Chunk) -> void:
	var origin_direction = chunk_.coord - coord
	var origin_direction_index = Catalog.get_direction_index_based_on_direction(coord, origin_direction)
	direcion_index_to_chunk[origin_direction_index] = chunk_
	chunk_to_direcion_index[chunk_] = origin_direction_index
	var reverse_direction_index = Catalog.get_reverse_direction_index(origin_direction_index)
	chunk_.direcion_index_to_chunk[reverse_direction_index] = self
	chunk_.chunk_to_direcion_index[self] = reverse_direction_index
	
	refuse_seam(origin_direction_index)
	chunk_.refuse_seam(reverse_direction_index)
	
func refuse_seam(direction_index_: int) -> void:
	var seam = direction_index_to_seam[direction_index_]
	direction_index_to_seam.erase(seam)
	
	if cloth.legal_seams.has(seam):
		cloth.legal_seams.erase(seam)
	if cloth.ilegal_seams.has(seam):
		cloth.ilegal_seams.erase(seam)
	
	seams.remove_child(seam)
	seam.queue_free()
	
