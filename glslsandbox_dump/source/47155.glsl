{"code": "#ifdef GL_ES\nprecision highp float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\n\nfloat sdSphere( vec3 p, float s )\n{\n  return length(p)-s;\n}\n\n\nvoid main( void ) {\n\t\n\tint i;\n\tvec2 position = ( gl_FragCoord.xy / resolution.xy * 4.0);\n\t\n\tposition.xy -= vec2(2.0,2.0);\n\n\tfloat color = 0.0;\n\n\tfor (int i = 0 ; i < 100; i++) {\n\t\tif (sdSphere(vec3(position.xy, float(i)), 1.0) < 0.0) {\n\t\t\tcolor = 1.0;\n\t\t}\n\t}\n      \n       \n\n\tgl_FragColor = vec4( vec3( color, color , color), 1.0 );\n\n}", "user": "874436e", "parent": "/e#41.0", "id": 47155}