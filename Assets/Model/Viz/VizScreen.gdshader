shader_type spatial;

uniform float pixels_x = 108.0;
uniform float pixels_y = 77.0;

varying vec3 p;
void vertex()
{
	p = ((MODEL_MATRIX)*vec4(VERTEX,1.0)).xyz;// Get fragment position in world space coordinates
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
	
	
	//float opaque = texture(bitmap_texture, p.xz).r * grid(p.xz);
	
	//vec3 ior_offset = NORMAL * refractive_index;
	//ior_offset = vec3(0);
	//vec3 rd = normalize(p - ro) * depth * 0.1;
	//vec3 rd = normalize(p - ro) - ( (p - ro) * refractive_index) * depth;
	
	
	//vec2 offset = rd.xz + bias;
	//float shadow = texture(bitmap_texture, UV + offset).r * grid(UV + offset);
		
	ALBEDO = vec3(grid(p.xz));
	ALPHA = grid(p.xz);
	//ALBEDO = vec3(p.xz, 0);		
	
	//ALBEDO = rd;
	//ALBEDO = blendOverlay(opaque, shadow);
	
	//ROUGHNESS = smoothstep(roughness, 1.0, max(opaque * 0.5, shadow * 0.2));
	//METALLIC = metallic;
}

