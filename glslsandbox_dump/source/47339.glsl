{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#extension GL_OES_standard_derivatives : enable\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nvoid main( void ) {\n\t\n//\tvec2 s = sin(gl_FragCoord.xy*mouse);\n\tvec2 p = gl_FragCoord.xy;\n\tp *= .2;\n\tfloat s = sin(p.x*0.07+time*3.0)*sin(p.y*0.09+time*1.2);\n\tfloat t = sin(p.x*0.13-time*1.1-s)*cos(p.y*0.053-time*1.3+s);\n\tfloat f = (s+t);\n\t//gl_FragColor = vec4(f,f-t,t-f,1)/2.0;\n\t//gl_FragColor = vec4(t,f,s,1)/2.0;\n\tgl_FragColor = vec4(f,t,s,1)/2.0;\n}", "user": "ca45534", "parent": "/e#47148.0", "id": 47339}