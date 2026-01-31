class_name NotchResource
extends Resource



var cloth: ClothResource
var restriction: RestrictionResource = RestrictionResource.new(self)
var coord: Vector2i



func _init(cloth_: ClothResource, coord_: Vector2i) -> void:
	cloth = cloth_
	coord = coord_
