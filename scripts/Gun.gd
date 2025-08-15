extends Faller
class_name Gun
## Pickup. When popped, the defender gains multi-shot = barrel_count.

@export var barrel_count: int = 0 # if 0, randomize 1..3 in _ready

func _ready() -> void:
        fall_speed = 240.0
        hp_range = Vector2i(1, 2)
        super._ready()
        if barrel_count <= 0:
                barrel_count = _rng.randi_range(1, 3)
        barrel_count = clampi(barrel_count, 1, 3)
        _apply_shape()
        # Show barrel_count on the label instead of HP? Keep HP visible for consistency.
        # If you'd rather show the bonus value, uncomment:
        # if hp_label: hp_label.text = str(barrel_count)

func _regular_polygon(sides: int, radius: float, start_angle: float = 0.0) -> PackedVector2Array:
        var pts: PackedVector2Array = PackedVector2Array()
        for i in range(sides):
                var ang: float = start_angle + TAU * float(i) / float(sides)
                pts.append(Vector2(cos(ang), sin(ang)) * radius)
        return pts

func _apply_shape() -> void:
        if not has_node("Polygon2D"):
                return
        var poly: Polygon2D = $Polygon2D
        match barrel_count:
                1:
                        color = Color(1.0, 0.5, 0.0, 1.0)
                        poly.polygon = _regular_polygon(3, 30.0, -PI / 2)
                2:
                        color = Color(0.0, 1.0, 0.0, 1.0)
                        poly.polygon = _regular_polygon(24, 30.0)
                3:
                        color = Color(0.5, 0.0, 0.5, 1.0)
                        poly.polygon = _regular_polygon(6, 30.0, PI / 6)
        poly.color = color
