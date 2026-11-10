#version 300 es
// Bedtime level 4: grayscale, dimmed and low contrast, so everything is tiring to read
precision highp float;

in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

const float BRIGHTNESS = 0.5;
const float CONTRAST = 0.4;
const float MID_GRAY = 0.45;

void main() {
    vec4 color = texture(tex, v_texcoord);
    float luminance = dot(color.rgb, vec3(0.2126, 0.7152, 0.0722));
    float washed = mix(MID_GRAY, luminance, CONTRAST);
    fragColor = vec4(vec3(washed * BRIGHTNESS), color.a);
}
