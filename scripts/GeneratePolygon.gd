extends CollisionPolygon2D

export (Texture) var my_texture = null

func _ready():
	var p = Polygon2D.new()
	p.polygon = self.polygon
	p.texture = my_texture
	add_child(p)
