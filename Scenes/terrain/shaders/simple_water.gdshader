shader_type spatial;

const float SMOOTHSTEP_AA = 0.01;

uniform sampler2D surfaceNoise;
uniform sampler2D distortNoise;

uniform vec2 surface_noise_tiling = vec2(1.0, 4.0);
uniform vec3 surface_noise_scroll = vec3(0.03, 0.03, 0.0);
uniform float surface_noise_cutoff: hint_range(0, 1) = 0.777;
uniform float surface_distortion_amount: hint_range(0, 1) = 0.27;

uniform vec4 BaseColor: source_color = vec4(0.086, 0.407, 1, 0.749);

varying vec2 noiseUV;
varying vec2 distortUV;

void vertex() {
	noiseUV = UV * surface_noise_tiling;
	distortUV = UV;
}

void fragment(){
	vec4 distortNoiseSample = texture(distortNoise, distortUV);
	vec2 distortAmount = (distortNoiseSample.xy * 2.0 -1.0) * surface_distortion_amount;
	
	vec2 noise_uv = vec2(
		(noiseUV.x + TIME * surface_noise_scroll.x) + distortAmount.x , 
		(noiseUV.y + TIME * surface_noise_scroll.y + distortAmount.y)
	);
	float surfaceNoiseSample = texture(surfaceNoise, noise_uv).r;
	
	vec4 color = BaseColor + smoothstep(surface_noise_cutoff - SMOOTHSTEP_AA, surface_noise_cutoff + SMOOTHSTEP_AA, surfaceNoiseSample);
	
	
	ALBEDO = color.rgb;
	ALPHA = color.a;
}