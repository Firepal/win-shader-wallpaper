{"code": "precision highp float;\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nfloat hash(float n) { \n\treturn fract(sin(n)*43758.5453123); \n}\n\nfloat noise3(vec3 x) {\n    vec3 p = floor(x);\n    vec3 f = fract(x);\n    f = f*f*(3.0-2.0*f);\n    float n = p.x + p.y*57.0 + p.z*113.0;\n    float res = mix(mix(mix( hash(n+  0.0), hash(n+  1.0),f.x),\n                        mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y),\n                    mix(mix( hash(n+113.0), hash(n+114.0),f.x),\n                        mix( hash(n+170.0), hash(n+171.0),f.x),f.y),f.z);\n    return res;\n}\n\nfloat sdPlane( vec3 p ) {\n  return -p.y;\n}\nfloat sdSphere( vec3 p, float r ) {\n  return length(p)-r;\n}\n\nfloat sdCylinder( vec3 p, vec3 c ) {\n  return length(p.xy-c.xy)-c.z;\n}\n\nvec2 rot(vec2 k, float t) {\n    return vec2(cos(t)*k.x-sin(t)*k.y,sin(t)*k.x+cos(t)*k.y);\n}\n\nfloat DE(vec3 p) {\n    //p.z+=time*2.0;\n   // p.x+=sin(p.z*0.5)*2.0;\n    //return sdCylinder(p, vec3(0.0,0.0,1.5));  \n      //return sdSphere(p, 5.5); \n      return sdPlane(p*3.5);\n}\n\nvec4 DEc4(vec3 p) {\n    float t=DE(p);\n        p.z-=time*0.5;\n        t+=noise3(p*3.5-(time*0.2))*0.8;\n\n    vec4 res = vec4(  clamp( t, 0.0, 1.0 ) );\n    \t res.xyz = mix( vec3(1.0,1.0,1.0), vec3(0.0,0.0,0.55), res.x );\n\treturn res;\n}\n\nvoid main()\n{\n\t\n\tvec3 rd=normalize( vec3( (-1.0+2.0*gl_FragCoord.xy/resolution.xy)*vec2(resolution.x/resolution.y,1.0), -1.0));\n\tvec3 lig=normalize(vec3(0.0, 1.0, 0.0));\n\tvec3 ro=vec3(0.0, -0.1, 0.0);\n      \n\tro.x = mouse.x * 4.0;\n\tro.y += mouse.y;\n\t\n\tfloat d=0.0;\n\t//vec4 col=vec4(0.01,2.1,1.55,1.0);\n\tvec4 col=vec4(.0);\n\tvec3 pos = vec3(ro+rd*1.0);\n\tvec4 res; \n\tfor(int i=0; i<60; i++) {\t\n\t\tres=DEc4(ro+rd*d);\n    \t\tres.xyz *= res.w;\n    \t    \tcol = col + res*(1.0 - col.w);  \n       \t\td+=0.08;\n\t}\n\n    \tcol = sqrt( col );\n\tcol = mix(col,vec4(0.0,0.0,0.1,0.5),pos.y);\n\t\n\tgl_FragColor = vec4( col.xyz,1.0);\n}\n", "user": "3024d08", "parent": "/e#25734.0", "id": "26675.2"}