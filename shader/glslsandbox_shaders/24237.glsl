{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nfloat length2(vec2 p) { return dot(p, p); }\n\nfloat noise(vec2 p){\n\treturn fract(sin(fract(sin(p.x) * (43.13311)) + p.y) * 31.0011);\n}\n\nfloat worley(vec2 p) {\n\tfloat d = 1e30;\n\tfor (int xo = -1; xo <= 1; ++xo) {\n\t\tfor (int yo = -1; yo <= 1; ++yo) {\n\t\t\tvec2 tp = floor(p) + vec2(xo, yo);\n\t\t\td = min(d, length2(p - tp - vec2(noise(tp))));\n\t\t}\n\t}\n\treturn 3.0*exp(-4.0*abs(2.0*d - 1.0));\n}\n\nfloat fworley(vec2 p) {\n\treturn sqrt(sqrt(sqrt(\n\t\t1.1 * // light\n\t\tworley(p*5. + .3 + time*.0525) *\n\t\tsqrt(worley(p * 50. + 0.3 + time * -0.15)) *\n\t\tsqrt(sqrt(worley(p * -10. + 9.3))))));\n}\n\nvoid main() {\n\n\tvec2 uv = gl_FragCoord.xy / resolution.xy;\n\tfloat t = fworley(uv * resolution.xy / 1500.0);\n\tt *= exp(-length2(abs(0.7*uv - 1.0)));\n\tgl_FragColor = vec4(t * vec3(0.1, 1.5*t, 1.2*t + pow(t, 0.5-t)), 1.0);\n\n\tvec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;\n}", "user": "3134cfa", "parent": "/e#20193.0", "id": "24237.2"}