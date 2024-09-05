shader_type spatial;

uniform vec3 color: source_color = vec3(0);
uniform float pixels_x = 108.0;
uniform float pixels_y = 77.0;
uniform vec4 cut = vec4(1000.0);
uniform vec2 cut_offset = vec2(0);

uniform bool is_grid = true;
uniform bool is_cut = true;

varying vec3 p;
void vertex()
{
	p = VERTEX;// Get fragment position in world space coordinates
}

float grid(vec2 st)
{
	float v_line = abs((fract(st.x * pixels_x) - 0.5) * 2.0);
	float h_line = abs((fract(st.y * pixels_y) - 0.5) * 2.0);

	float grid = max(v_line, h_line);
	grid = smoothstep(0.90, 0.95, grid);
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

	ALBEDO = color;

	float alpha = 1.0;
	//vec3 pm = (VERTEX * vec4(p, 1.0)).xyz;
	vec2 uv = p.xz;

	if(is_grid)
		alpha *= grid(uv);
	if(is_cut)
	{
		if(uv.x < floor(cut.x + cut_offset.x) / 10.0)
			alpha *= 0.0;
		if(uv.x > floor(cut.y + cut_offset.x) / 10.0)
			alpha *= 0.0;
		if(uv.y > floor(cut.w + cut_offset.y) / 10.0)
			alpha *= 0.0;
		if(uv.y < floor(cut.z + cut_offset.y) / 10.0)
			alpha *= 0.0;
	}
	ALPHA = alpha;



	//ALBEDO = blendOverlay(opaque, shadow);

	//ROUGHNESS = smoothstep(roughness, 1.0, max(opaque * 0.5, shadow * 0.2));
	//METALLIC = metallic;
}
