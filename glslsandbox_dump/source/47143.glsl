{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nvoid main()\n{\n\tfloat t;\n\tt = time * 1.0;\n    vec2 r = resolution,\n    o = gl_FragCoord.xy - r/2.;\n    o = vec2(length(o) / r.y - .3, atan(o.y,o.x));    \n    vec4 s = 0.07*cos(1.5*vec4(0,1,2,3) + t + o.y + cos(o.y) * cos(t)),\n    e = s.yzwx, \n    f = max(o.x-s,e-o.x);\n    gl_FragColor = dot(clamp(f*r.y,0.,1.), 80.*(s-e)) * (s-.1) + f;\n}", "user": "8f825bc", "parent": null, "id": 47143}