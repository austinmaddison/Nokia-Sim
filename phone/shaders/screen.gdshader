shader_type spatial;

uniform sampler2D viewport_texture : hint_default_black, filter_nearest_mipmap, repeat_disable;
uniform vec2 scale_texture = vec2(1.0, 1.0);
uniform vec2 translate_texture = vec2(0.0, 0.0);

uniform sampler2D backlight_diffuser_noise : hint_default_transparent;
uniform sampler2D backlight_diffuser_normal : hint_normal;
uniform float backlight_diffuser_noise_strength = 1.0;

uniform sampler2D top_coat_roughness_map : hint_default_black;
uniform vec2 top_coat_roughness_map_remap = vec2(0.0, 0.0);
uniform float top_coat_roughness_strength = 1.0;

uniform vec4 substrate_color: source_color = vec4(0.0);
uniform vec4 background_color: source_color = vec4(0.0);
uniform vec4 fade_color: source_color = vec4(0.0);
uniform float fade_falloff = 0.55;
uniform vec4 shadow_color: source_color = vec4(0.0);
uniform vec4 backlight_color: source_color = vec4(0.0);
uniform float backlight_color_emmission_strength = 0.0;

uniform float depth : hint_range(0.0, 1.0) = 0.1;
uniform float normal_depth = 1.0;
uniform float specular : hint_range(0.0, 1.0) = 1.0;
uniform float roughness : hint_range(0.0, 1.0) = 0.3;
uniform float clear_coat_specular : hint_range(0.0, 1.0) = 1.0;
uniform float clear_coat_roughness : hint_range(0.0, 1.0) = 0.3;
uniform float metallic : hint_range(0.0, 1.0) = 0.7;
uniform float refractive_index : hint_range(0.0, 2.0) = 0.1;

uniform float screen_width = 108.0;
uniform float screen_height = 77.0;

uniform vec2 bias = vec2(0.0, 0.0);

varying vec3 ro;
varying vec3 p;
varying vec3 vertex_normal_ws;
void vertex()
{
	
	p = ((MODEL_MATRIX)*vec4(VERTEX,1.0)).xyz;// Get fragment position in world space coordinates
	vertex_normal_ws = ((MODEL_MATRIX)*vec4(NORMAL,1.0)).xyz;
}

float grid(vec2 st)
{
	float v_line = abs((fract(st.x * screen_width) - 0.5) * 2.0);
	float h_line = abs((fract(st.y * screen_height) - 0.5) * 2.0);

	float grid = max(v_line, h_line);
	grid = smoothstep(0.80, 1, grid);
	return 1.0 - clamp(grid, 0., 1.);
}

float box(vec2 u, vec2 v)
{
	vec2 d = abs(u) - v;
	return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

void fragment(){
	//vec3 normal = texture(surface_normalmap, UV).xyz * 2.0 - 1.0;



	vec2 texture_uv = UV * scale_texture;
	texture_uv += vec2(0.5) - (scale_texture * 0.5) + translate_texture;
	
	float opaque = 0.0;
	float texture_mask = 1.0 - smoothstep(0.-0.001, 0.+0.001, box((texture_uv -0.5) * 2.0, vec2(1.0, 1.0)));
	
	opaque = texture(viewport_texture, texture_uv).r * grid(texture_uv) * texture_mask;

	vec3 ior_offset = NORMAL * refractive_index;
	ior_offset = vec3(0);
	vec3 rd = normalize(p - CAMERA_POSITION_WORLD) * depth * 0.1;
	vec2 offset = rd.xy + bias;
	offset.y *= -1.0;
	
	float shadow = 0.0;
	float shadow_mask = 1.0 - smoothstep(0.-0.001, 0.+0.001, box((texture_uv + offset -0.5) * 2.0, vec2(1.0, 1.0)));
	shadow = texture(viewport_texture, texture_uv + offset).r * grid(texture_uv + offset) * shadow_mask;
	
	

	
	float noise =  (1. - smoothstep(0.0, 0.6, texture(backlight_diffuser_noise, texture_uv * vec2(.1, .1) + offset*5.).r));
	noise *= (1. - smoothstep(0.0, 0.6, texture(backlight_diffuser_noise, texture_uv * vec2(.5, .5) + offset).r));
	
	vec3 color = vec3(0.0);
	color = mix(color, background_color.rgb, background_color.a);
	color = mix(color, background_color.rgb, background_color.a);
	color = mix(color, fade_color.rgb, (1.0 - dot(NORMAL, CAMERA_DIRECTION_WORLD)) * fade_falloff);
	color = mix(color, shadow_color.rgb, shadow * shadow_color.a);
	color = mix(color, substrate_color.rgb, texture_mask * grid(texture_uv) * 0.2);
	color = mix(color, substrate_color.rgb, opaque * substrate_color.a);
	
	
	ALBEDO = color;
	
	
	SPECULAR = max((1.0 - opaque), (1.0 - texture_mask * grid(texture_uv))) * specular;
	ROUGHNESS = roughness;
	
	CLEARCOAT = clear_coat_specular;
	CLEARCOAT_ROUGHNESS = clear_coat_roughness;
	
	NORMAL_MAP = texture(backlight_diffuser_normal, UV*2.0 + offset).xyz;
	NORMAL_MAP_DEPTH = backlight_diffuser_noise_strength;
}
