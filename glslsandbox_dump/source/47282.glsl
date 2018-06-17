{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#extension GL_OES_standard_derivatives : enable\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nvoid main( void ) {\n\n  vec2 xy = gl_FragCoord.xy / resolution;\n  gl_FragColor = vec4(abs(sin(time / 5.0) / 2.0 + xy.x),\n\t\t      abs(sin(time) / 2.0 + xy.y),\n\t\t      abs(sin(time * 5.0) / 2.0 + 0.3), 1.0);\n\n}", "user": "af1a198", "parent": null, "id": 47282}