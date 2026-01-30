class_name Kink
extends Line2D


var chunk: Chunk

var start: Vector2
var medium: Vector2
var end: Vector2

var aspect: State.Aspect:
	set(value_):
		aspect = value_
		default_color = Catalog.aspect_to_color[aspect]


func recalc_points() -> void:
	clear_points()
	
	var curve_2d = Curve2D.new()
	curve_2d.add_point(start)
	curve_2d.add_point(end, medium - end)
	
	var curve_points = curve_2d.get_baked_points()
	
	for point in curve_points:
		add_point(point)
