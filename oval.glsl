precision highp float;

uniform float u_time;
uniform vec2 u_sprite_size;
//uniform float u_scale;
uniform sampler2D u_texture;
//uniform vec4 u_tint_color;
//uniform vec4 u_fill_color;
varying vec2 v_tex_coord;


void main(){
  // 時間取り込み、`time` で呼び出せるようになる
  float time = u_time;
  // `texcoord` や
  vec2 uv = v_tex_coord;
  
  // 正規化
  uv = (uv - vec2(0.5)) *2.0;
  
  vec3 destColor = vec3(0.0);
  
  // `sin`と`cos` で分岐してるところ
  vec2 sine_cosine = uv + vec2(cos(u_time), sin(u_time)) * 0.8;
  
  // time ノードから真っ直ぐ出てるやつ
  destColor += (abs(sin(u_time)) * 0.8) / length(sine_cosine);
  
  
  // ノードでいうと下のところ
  float f = 0.8 / abs(length(uv) - 0.8);
  
  
  // ここは無視
  uv = uv / 2.0 + vec2(0.5);
  
  
  // ue の`cropping` 直前
  vec3 rslt = (destColor + f) * 0.1;
  
  gl_FragColor = vec4(rslt, 1.0);
  
}



