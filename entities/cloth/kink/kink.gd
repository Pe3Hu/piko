class_name Kink
extends Line2D


var chunk: Chunk
var resource: KinkResource:
	set(value_):
		resource = value_
		
		recalc_points()
		default_color = Catalog.aspect_to_color[resource.aspect]


func recalc_points() -> void:
	clear_points()
	
	var positions: Array[Vector2] = resource.get_seams_positions()
	var start: Vector2 = positions[0]
	var end: Vector2 = positions[1]
	
	var curve_2d = Curve2D.new()
	curve_2d.add_point(start)
	curve_2d.add_point(end, Catalog.KINK_MEDIUM_POSITION - end)
	
	var curve_points = curve_2d.get_baked_points()
	
	for point in curve_points:
		add_point(point)
