{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nstruct Ray {\n\tvec3 pos;\n\tvec3 dir;\n};\n\t\nfloat distanceFunction(vec3 pos)\n{\n\treturn length(pos) - 5.0;\n}\n\nvoid main( void ) {\n\n\tvec2 pos = (gl_FragCoord.xy - resolution * 0.5)  / resolution.y + mouse - 0.5;\n\tRay ray;\n\tray.pos = vec3(0.0, 0.0, -10.0);\n\tray.dir = normalize(vec3(pos * 3.0, 1.0));\n\tfloat d;\n\tfor(int i = 0; i < 6; ++i)\n\t{\n\t\td = distanceFunction(ray.pos);\n\t\tray.pos += d * ray.dir;\n\t\tif (abs(d) < 0.001) break;\n\t}\n\tgl_FragColor = vec4(vec3(d), 1.0);\n}", "user": "aac0a0f", "parent": "/e#23261.0", "id": 47186}