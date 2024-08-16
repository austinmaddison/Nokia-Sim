shader_type spatial;

uniform sampler2D bitmap_texture : hint_default_black, filter_nearest_mipmap, repeat_disable;

uniform sampler2D backlight_diffuser_normals : hint_normal;
uniform float backlight_diffuser_normals_strength = 1.0;

uniform sampler2D top_coat_roughness_map : hint_default_black;
uniform vec2 top_coat_roughness_map_remap = vec2(0.0, 0.0);
uniform float top_coat_roughness_strength = 1.0;

uniform vec4 shadow_color: source_color = vec4(0.0);
uniform vec4 substrate_color: source_color = vec4(0.0);
uniform vec4 backlight_color: source_color = vec4(0.0);
uniform float backlight_color_emmission_strength = 0.0;

uniform float depth : hint_range(0.0, 1.0) = 0.1;
uniform float normal_depth = 1.0;
uniform float roughness : hint_range(0.0, 1.0) = 0.3;
uniform float metallic : hint_range(0.0, 1.0) = 0.7;
uniform float refractive_index : hint_range(0.0, 2.0) = 0.1;

uniform float pixels_x = 108.0;
uniform float pixels_y = 77.0;

uniform vec2 bias = vec2(0.0, 0.0);

varying vec3 ro;
varying vec3 p;
varying vec3 vertex_normal_ws;
void vertex()
{
	ro = (INV_VIEW_MATRIX * vec4(0.0, 0.0, 0.0, 1.0)).xyz;// Get camera position in World space coordinates
	p = ((MODEL_MATRIX)*vec4(VERTEX,1.0)).xyz;// Get fragment position in world space coordinates
	vertex_normal_ws = ((MODEL_MATRIX)*vec4(NORMAL,1.0)).xyz;
}

float grid(vec2 st)
{
	float v_line = abs((fract(st.x * pixels_x) - 0.5) * 2.0);
	float h_line = abs((fract(st.y * pixels_y) - 0.5) * 2.0);

	float grid = max(v_line, h_line);
	grid = smoothstep(0.85, 0.95, grid);
	return 1.0 - clamp(grid, 0., 1.);
}

void fragment(){
	//vec3 normal = texture(surface_normalmap, UV).xyz * 2.0 - 1.0;
	
	//NORMAL_MAP = texture(surface_normalmap, UV).xyz;
	//NORMAL_MAP_DEPTH = normal_depth;
	
	float opaque = texture(bitmap_texture, UV).r * grid(UV);
	
	vec3 ior_offset = NORMAL * refractive_index;
	ior_offset = vec3(0);
	vec3 rd = normalize(p - ro) * depth * 0.1;
	//vec3 rd = normalize(p - ro) - ( (p - ro) * refractive_index) * depth;
	vec2 offset = rd.xz + bias;
	float shadow = texture(bitmap_texture, UV + offset).r * grid(UV + offset);
		
	ALBEDO = vec3(opaque + shadow * 0.1);		
	// ALBEDO = vec3();		
	
	//ALBEDO = rd;
	//ALBEDO = blendOverlay(opaque, shadow);
	
	 ROUGHNESS = smoothstep(roughness, 1.0, max(opaque * 0.5, shadow * 0.2));
	METALLIC = metallic;
}

