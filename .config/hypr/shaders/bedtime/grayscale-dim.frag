#version 300 es
// Bedtime level 3: grayscale, dimmed
precision highp float;

in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

const float BRIGHTNESS = 0.6;

void main() {
    vec4 color = texture(tex, v_texcoord);
    float luminance = dot(color.rgb, vec3(0.2126, 0.7152, 0.0722));
    fragColor = vec4(vec3(luminance * BRIGHTNESS), color.a);
}
