class_name Cloth
extends Node2D


@export var notch_scene: PackedScene
@export var chunk_scene: PackedScene

@onready var notchs: TileMapLayer = %Notchs
@onready var chunks: Node2D = %Chunks

var internal_coords: Array[Vector2i]
var external_coords: Array[Vector2i]

var coord_to_scene: Dictionary


func _ready() -> void:
	add_chunck(Vector2i.ZERO)
	
func add_notch(coord_: Vector2i) -> void:
	if coord_to_scene.has(coord_): return
	%Notchs.set_cell(coord_, 10, Vector2.ZERO)
	var notch: Notch = notch_scene.instantiate()
	notchs.add_child(notch)
	notch.cloch = self
	notch.coord = coord_
	coord_to_scene[coord_] = notch
	
	if !internal_coords.has(coord_):
		external_coords.append(coord_)
	
func add_chunck(coord_: Vector2i) -> void:
	if coord_to_scene.has(coord_):
		var notch_ = coord_to_scene[coord_]
		notchs.remove_child(notch_)
		notch_.queue_free()
	
	%Notchs.set_cell(coord_, 10, Vector2(1, 0))
	var chunk: Chunk = chunk_scene.instantiate()
	chunks.add_child(chunk)
	chunk.cloch = self
	chunk.coord = coord_
	chunk.roll_kinks()
	coord_to_scene[coord_] = chunk
	
	if external_coords.has(coord_):
		external_coords.erase(coord_)
	
	internal_coords.append(coord_)
	update_external_coords(coord_)
	
func update_external_coords(coord_: Vector2i) -> void:
	for _i in Catalog.CHUNK_N:
		var coord = Catalog.get_neighbor(coord_, _i)
		add_notch(coord)
