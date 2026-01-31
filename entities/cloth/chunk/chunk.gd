class_name Chunk
extends Node2D


@export var kink_scene: PackedScene

@export var is_selected: bool = false
@export var cloth: Cloth

var resource: ChunkResource:
	set(value_):
		resource = value_
		
		if Catalog.CHUNK_SHOWCASE != resource.coord:
			position = cloth.notchs.map_to_local(resource.coord)
		#init_kinks()

@onready var kinks: Node2D = %Kinks


func _ready() -> void:
	init_kinks()
	
func init_kinks() -> void:
	if !resource: return
	for kink_resource in resource.kinks:
		add_kink(kink_resource)
	
func add_kink(kink_resource_: KinkResource) -> void:
	var kink: Kink = kink_scene.instantiate()
	kinks.add_child(kink)
	kink.chunk = self
	kink.resource = kink_resource_
	
func custom_rotate(turns_: int = 1, is_admin_: bool = false) -> void:
	if turns_ == 0: return
	if !is_selected and !is_admin_: return
	resource.custom_rotate(turns_, is_admin_)
	rotation = Catalog.CHUNK_ANGLE * resource.turns
	
