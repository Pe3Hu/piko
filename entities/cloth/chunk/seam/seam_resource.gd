class_name SeamResource
extends Resource


var cloth: ClothResource
var notch: NotchResource
var chunks: Array[ChunkResource]


func _init(cloth_: ClothResource, chunk_: ChunkResource, notch_: NotchResource) -> void:
	cloth = cloth_
	notch = notch_
	chunks.append(chunk_)
