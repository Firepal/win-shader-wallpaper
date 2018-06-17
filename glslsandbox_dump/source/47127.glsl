{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#extension GL_OES_standard_derivatives : enable\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nconst vec3 blue = vec3(ivec3(255, 255, 0)) / 255.;\nconst vec3 white = vec3(1, 0, 0);\nconst vec3 red = vec3(0.0, 0.0, 0.0);\nconst vec3 pole_color = vec3(0.4, 0.4, 0.4);\nconst vec3 sky = vec3(0.8, 0.9, 1.0);\n\nbool box(vec2 pos, vec4 bounds) {\n\treturn  ((pos.x >= bounds.x) && (pos.x < bounds.z) && (pos.y >= bounds.y) && (pos.y <= bounds.w));\t\n}\n\nvec3 scene(vec2 pos) {\n\tvec3 color = sky;\n\t\n\tcolor = mix(color, pole_color, float(box(pos, vec4(-12., -20., -12., 10.))));\n\tcolor = mix(color, pole_color, float(box(pos, vec4(-13., 8., -11., 9.))));\n\t\n\tpos.y += sin(-pos.x / 3. + floor(time * 7.0)) * 1.01;\n\t\n\tcolor = mix(color, red, float(box(pos, vec4(-10., -6, 10., 6))));\n    \tcolor = mix(color, white, float(box(pos, vec4(-10, -6, 10., 1.66))));\t\n    \tcolor = mix(color, blue, float(box(pos, vec4(-10., -6, 10., -1.66))));\t\n\treturn color;\n}\n\nvoid main() {\n\tvec2 uv = (gl_FragCoord.xy) / resolution.xy;\n\tuv = (uv - 0.5) * 2.0;\n\t\n\tvec2 aspect_uv = uv * (resolution.xy / resolution.y);\n\tvec3 pole = vec3(0.);\n\tvec2 pixel_uv = floor(aspect_uv * 12.);\n\tgl_FragColor = vec4(scene(pixel_uv) + pole, 1.0);\n}", "user": "9218ece", "parent": null, "id": 47127}