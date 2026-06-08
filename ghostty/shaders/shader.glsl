#version 330

uniform sampler2D screenTexture;
in vec2 v_texCoord;
out vec4 fragColor;

void main() {
    vec4 color = texture(screenTexture, v_texCoord);

    // visible color shift: warm tint + slight vignette
    float vignette = 1.0 - 0.15 * length(v_texCoord - 0.5);
    color.rgb *= vignette;
    color.r *= 1.1;
    color.g *= 0.95;

    fragColor = color;
}
