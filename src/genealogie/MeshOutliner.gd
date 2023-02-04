extends MeshInstance

export var outline_color: Color = Color.aliceblue;
export var border_width: float = 0.1
var surface_shader: ShaderMaterial
export var enable = false



# Called when the node enters the scene tree for the first time.
func _ready():
	if enable : 
		surface_shader = self.get_active_material(0).next_pass
		print(surface_shader.resource_name)
		print(surface_shader)
		surface_shader.set_shader_param("color", outline_color)
		outline()


func outline() : 
	surface_shader.set_shader_param("border_width", border_width)
	print(surface_shader.get_shader_param("border_width"))

func stop_outline() : 
	surface_shader.set_shader_param("border_width", 0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
