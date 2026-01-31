class_name Cloth
extends Node2D


@export var notch_scene: PackedScene
@export var chunk_scene: PackedScene

@onready var notchs: TileMapLayer = %Notchs
@onready var chunks: Node2D = %Chunks
@onready var showcase_chunk: Chunk = %ShowcaseChunk

var resource: ClothResource = ClothResource.new()

var resource_to_scene: Dictionary


func _ready() -> void:
	#await get_tree().create_timer(0.1).timeout
	showcase_chunk.resource = resource.showcase_chunk
	showcase_chunk.init_kinks()
	
	init_chucks()
	init_notchs()
	
	#var chunk = chunks.get_child(0)
	
	
func init_notchs() -> void:
	for notch_resource in resource.notchs:
		add_notch(notch_resource)
		
func add_notch(notch_resource_: NotchResource) -> void:
	%Notchs.set_cell(notch_resource_.coord, 10, Vector2.ZERO)
	var notch: Notch = notch_scene.instantiate()
	notch.resource = notch_resource_
	notchs.add_child(notch)
	resource_to_scene[notch_resource_] = notch
	
func init_chucks() -> void:
	for chunk_resource in resource.chunks:
		add_chunck(chunk_resource)
	
func add_chunck(chunk_resource_: ChunkResource) -> void:
	if resource.coord_to_resource.has(chunk_resource_.coord):
		var notch_resource = resource.coord_to_resource[chunk_resource_.coord]
		
		if resource_to_scene.has(notch_resource):
			var notch = resource_to_scene[notch_resource]
			notchs.remove_child(notch)
			notch.queue_free()
	
	%Notchs.set_cell(chunk_resource_.coord, 10, Vector2(1, 0), -1)
	#%Notchs.set_cell(coord_, 10, Vector2(1, 0))
	var chunk: Chunk = chunk_scene.instantiate()
	chunk.cloth = self
	chunk.resource = chunk_resource_
	chunks.add_child(chunk)
	resource_to_scene[chunk_resource_] = chunk


func _input(event) -> void:
	if event is InputEventKey:
		var just_pressed = event.is_pressed() and not event.is_echo()
		
		if just_pressed:
			match event.keycode:
				KEY_Q:
					showcase_chunk.custom_rotate(-1)
				KEY_E:
					showcase_chunk.custom_rotate(1)
				KEY_SPACE:
					pass
