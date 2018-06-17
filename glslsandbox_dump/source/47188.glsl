{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n#extension GL_OES_standard_derivatives : enable\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\nvoid main(void){\n\tvec2 p=gl_FragCoord.xy,r=resolution;\n\tvec2 uv=vec2(\n\t\tr.y<r.x?(p.x/r.y)-(((r.x/r.y)-1.)/2.):p.x/r.x\n\t\t,\n\t\tr.y<r.x?p.y/r.y:(p.y/r.x)-(((r.y/r.x)-1.)/2.)\n\t);\n\tgl_FragColor=vec4(fract(uv),(uv.x>=0.&&uv.x<1.)&&(uv.y>=0.&&uv.y<1.),1.);\n}", "user": "c821d6f", "parent": null, "id": 47188}