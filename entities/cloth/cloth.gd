class_name Cloth
extends Node2D


@export var notch_scene: PackedScene
@export var chunk_scene: PackedScene

@onready var notchs: TileMapLayer = %Notchs
@onready var chunks: Node2D = %Chunks
@onready var showcase_chunk: Chunk = %ShowcaseChunk

var internal_coords: Array[Vector2i]
var external_coords: Array[Vector2i]
var legal_coords: Array[Vector2i]
var ilegal_coords: Array[Vector2i]
var legal_seams: Array[Seam]
var ilegal_seams: Array[Seam]

var coord_to_scene: Dictionary


func _ready() -> void:
	showcase_chunk.roll_kinks()
	add_chunck(Vector2i.ZERO)
	update_ilegal_seams()
	
	#var chunk = chunks.get_child(0)
	#chunk.direction_index_to_seam[0].visible = true
	
func add_notch(coord_: Vector2i) -> void:
	if coord_to_scene.has(coord_): return
	%Notchs.set_cell(coord_, 10, Vector2.ZERO)
	var notch: Notch = notch_scene.instantiate()
	notchs.add_child(notch)
	notch.cloth = self
	notch.coord = coord_
	coord_to_scene[coord_] = notch
	
	if !internal_coords.has(coord_):
		external_coords.append(coord_)
	
func add_chunck(coord_: Vector2i) -> void:
	if coord_to_scene.has(coord_):
		var notch_ = coord_to_scene[coord_]
		notchs.remove_child(notch_)
		notch_.queue_free()
	
	%Notchs.set_cell(coord_, 10, Vector2(1, 0), -1)
	#%Notchs.set_cell(coord_, 10, Vector2(1, 0))
	var chunk: Chunk = chunk_scene.instantiate()
	chunks.add_child(chunk)
	chunk.cloth = self
	chunk.coord = coord_
	chunk.pattern = showcase_chunk.pattern
	chunk.palette = showcase_chunk.palette
	chunk.custom_rotate(showcase_chunk.turns, true)
	chunk.init_kinks()
	coord_to_scene[coord_] = chunk
	
	if external_coords.has(coord_):
		external_coords.erase(coord_)
	
	internal_coords.append(coord_)
	update_external_coords(coord_)
	chunk.init_neighbors()
	#remove_connected_seams(chunk)
	reroll_showcase_chunk()
	
func update_external_coords(coord_: Vector2i) -> void:
	for _i in Catalog.CHUNK_N:
		var coord = Catalog.get_neighbor_coord(coord_, _i)
		add_notch(coord)
	
func reroll_showcase_chunk() -> void:
	showcase_chunk.roll_kinks()
	
func reset_legal_coords() -> void:
	#ilegal_coords.clear()
	#legal_coords.clear()
	#legal_coords.append_array(external_coords)
	while !ilegal_coords.is_empty():
		var coord = ilegal_coords.back()
		set_coord_as_legal(coord)
	
func reset_legal_seams() -> void:
	while !legal_seams.is_empty():
		var seam = legal_seams.back()
		set_seam_as_ilegal(seam)
	#ilegal_seams.append_array(legal_seams)
	#legal_seams.clear()
	
func find_legal_seams() -> void:
	for _i in range(ilegal_seams.size()-1,-1,-1):
		var seam = ilegal_seams[_i]
		
		if showcase_chunk.kink_aspects.has(seam.kink.aspect):
			set_seam_as_legal(seam)
	
func set_seam_as_legal(seam_: Seam) -> void:
	ilegal_seams.erase(seam_)
	legal_seams.append(seam_)
	seam_.visible = true
	
func set_seam_as_ilegal(seam_: Seam) -> void:
	legal_seams.erase(seam_)
	ilegal_seams.append(seam_)
	seam_.visible = false
	
func enumeration_of_external_coords() -> void:
	for coord in external_coords:
		update_seams_based_on_coord(coord)
	
func update_seams_based_on_coord(coord_: Vector2i) -> void:
	var is_legal = true
	
	for index in Catalog.direction_indexs:
		if !is_legal: return
		is_legal = check_seam_legal_based_on_coord_and_direction_index(coord_, index)
	
func check_seam_legal_based_on_coord_and_direction_index(coord_: Vector2i, direction_index_: int) -> bool:
	var neighbor_coord = Catalog.get_neighbor_coord(coord_, direction_index_)
	
	if internal_coords.has(neighbor_coord):
		var origin_seam = showcase_chunk.direction_index_to_seam[direction_index_]
		var neighbor_chunk = coord_to_scene[neighbor_coord]
		var reverse_direction_index = Catalog.get_reverse_direction_index(direction_index_)
		var neighbor_seam = neighbor_chunk.direction_index_to_seam[reverse_direction_index]
		#print([direction_index_, Catalog.aspect_to_string[origin_seam.kink.aspect]])
		#print([reverse_direction_index,  Catalog.aspect_to_string[neighbor_seam.kink.aspect], direction_index_, Catalog.aspect_to_string[origin_seam.kink.aspect]])
		if neighbor_seam.kink.aspect != origin_seam.kink.aspect:
			set_seam_as_ilegal(neighbor_seam)
			set_coord_as_ilegal(coord_)
			return false
	
	return true
	
func set_coord_as_ilegal(coord_: Vector2i) -> void:
	legal_coords.erase(coord_)
	ilegal_coords.append(coord_)
	%Notchs.set_cell(coord_, 10, Vector2(1, 0))
	
func set_coord_as_legal(coord_: Vector2i) -> void:
	ilegal_coords.erase(coord_)
	legal_coords.append(coord_)
	%Notchs.set_cell(coord_, 10, Vector2.ZERO)
	
func update_ilegal_seams() -> void:
	reset_legal_coords()
	reset_legal_seams()
	find_legal_seams()
	enumeration_of_external_coords()
	#fill_legal_coords()
	
#func fill_legal_coords() -> void:
	#legal_coords.clear()
	#
	#for coord in external_coords:
		#detect_legal_coord(coord)
	#
#func detect_legal_coord(coord_: Vector2i) -> void:
	#var is_legal = true
	#
	#for index in Catalog.direction_indexs:
		#if !is_legal: return
		#is_legal = try_on_direction(coord_, index)
	
func remove_connected_seams(chuck_: Chunk) -> void:
		pass





func print_chunk_seams(chunk_: Chunk) -> void:
	for direction_index in chunk_.direction_index_to_seam:
		var seam = chunk_.direction_index_to_seam[direction_index]
		print([direction_index,  Catalog.aspect_to_string[seam.kink.aspect]])
	
func _input(event) -> void:
	if event is InputEventKey:
		var just_pressed = event.is_pressed() and not event.is_echo()
		
		if just_pressed:
			match event.keycode:
				KEY_Q:
					showcase_chunk.custom_rotate(-1)
					update_ilegal_seams()
				KEY_E:
					showcase_chunk.custom_rotate(1)
					update_ilegal_seams()
				KEY_SPACE:
					reset_legal_seams()
