{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#extension GL_OES_standard_derivatives : enable\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nvoid main( void ) {\n\n\tvec2 uv = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;\n\n\tfloat a=sin((uv.x+uv.y)*time)+cos((uv.x+uv.y)*time);\n\tfloat b=99.0*time;\n\n\tgl_FragColor = vec4(a,b,inversesqrt(a), 1.0 );\n\n}", "user": "84f32e3", "parent": "/e#47040.0", "id": 47070}