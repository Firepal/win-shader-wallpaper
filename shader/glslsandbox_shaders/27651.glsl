{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\n// Weather. By David Hoskins, May 2014.\n// @ https://www.shadertoy.com/view/4dsXWn\n// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.\n\n// Who needs mathematically correct simulations?! :)\n// It ray-casts to the bottom layer then steps through to the top layer.\n// It uses the same number of steps for all positions.\n// The larger steps at the horizon don't cause problems as they are far away.\n// So the detail is where it matters.\n// Unfortunately this can't be used to go through the cloud layer,\n// but it's fast and has a massive draw distance.\n\nvec3 sunLight  = normalize( vec3(  0.35, 0.14,  0.3 ) );\nconst vec3 sunColour = vec3(1.0, .7, .55);\nfloat gTime, cloudy;\nvec3 flash;\n\n#define CLOUD_LOWER 2000.0\n#define CLOUD_UPPER 3800.0\n\n//#define TEXTURE_NOISE\n\n// Shadows sort of work, but it's too slow and I don't see the point. :)\n//#define REAL_SHADOW\n#define MOD2 vec2(.16632,.17369)\n#define MOD3 vec3(.16532,.17369,.15787)\n\n\n//--------------------------------------------------------------------------\n\n//--------------------------------------------------------------------------\nfloat Hash( float p )\n{\n\tvec2 p2 = fract(vec2(p) * MOD2);\n    p2 += dot(p2.yx, p2.xy+19.19);\n\treturn fract(p2.x * p2.y);\n}\nfloat Hash(vec3 p)\n{\n\tp  = fract(p * MOD3);\n    p += dot(p.xyz, p.yzx + 19.19);\n    return fract(p.x * p.y * p.z);\n}\n\n//--------------------------------------------------------------------------\n#ifdef TEXTURE_NOISE\n\n//--------------------------------------------------------------------------\nfloat Noise( in vec2 f )\n{\n    vec2 p = floor(f);\n    f = fract(f);\n    f = f*f*(3.0-2.0*f);\n    float res = texture2D(iChannel0, (p+f+.5)/256.0).x;\n    return res;\n}\nfloat Noise( in vec3 x )\n{\n    vec3 p = floor(x);\n    vec3 f = fract(x);\n\tf = f*f*(3.0-2.0*f);\n\t\n\tvec2 uv = (p.xy+vec2(37.0,17.0)*p.z) + f.xy;\n\tvec2 rg = texture2D( iChannel0, (uv+ 0.5)/256.0, -100.0 ).yx;\n\treturn mix( rg.x, rg.y, f.z );\n}\n#else\n\n//--------------------------------------------------------------------------\n\n\nfloat Noise( in vec2 x )\n{\n    vec2 p = floor(x);\n    vec2 f = fract(x);\n    f = f*f*(3.0-2.0*f);\n    float n = p.x + p.y*57.0;\n    float res = mix(mix( Hash(n+  0.0), Hash(n+  1.0),f.x),\n                    mix( Hash(n+ 57.0), Hash(n+ 58.0),f.x),f.y);\n    return res;\n}\nfloat Noise(in vec3 p)\n{\n    vec3 i = floor(p);\n\tvec3 f = fract(p); \n\tf *= f * (3.0-2.0*f);\n\n    return mix(\n\t\tmix(mix(Hash(i + vec3(0.,0.,0.)), Hash(i + vec3(1.,0.,0.)),f.x),\n\t\t\tmix(Hash(i + vec3(0.,1.,0.)), Hash(i + vec3(1.,1.,0.)),f.x),\n\t\t\tf.y),\n\t\tmix(mix(Hash(i + vec3(0.,0.,1.)), Hash(i + vec3(1.,0.,1.)),f.x),\n\t\t\tmix(Hash(i + vec3(0.,1.,1.)), Hash(i + vec3(1.,1.,1.)),f.x),\n\t\t\tf.y),\n\t\tf.z);\n}\n#endif\n\n//--------------------------------------------------------------------------\nfloat FBM( vec3 p )\n{\n\tp *= .25;\n    float f;\n\t\n\tf = 0.5000 * Noise(p); p = p * 3.02; //p.y -= gTime*.2;\n\tf += 0.2500 * Noise(p); p = p * 3.03; //p.y += gTime*.06;\n\tf += 0.1250 * Noise(p); p = p * 3.01;\n\tf += 0.0625   * Noise(p); p =  p * 3.03;\n\tf += 0.03125  * Noise(p); p =  p * 3.02;\n\tf += 0.015625 * Noise(p);\n    return f;\n}\n\n//--------------------------------------------------------------------------\nfloat SeaFBM( vec2 p )\n{\n    float f;\n\tf = (sin(sin(p.x *1.22+gTime) + cos(p.y *.14)+p.x*.15+p.y*1.33-gTime)) * 1.0;\n    \n\tf += (sin(p.x *.9+gTime + p.y *.3-gTime)) * 1.0;\n    f += (cos(p.x *.7-gTime - p.y *.4-gTime)) * .5;\n    f += 1.5000 * (.5-abs(Noise(p)-.5)); p =  p * 2.05;\n    f += .75000 * (.5-abs(Noise(p)-.5)); p =  p * 2.02;\n    f += 0.2500 * Noise(p); p =  p * 2.07;\n    f += 0.1250 * Noise(p); p =  p * 2.13;\n    f += 0.0625 * Noise(p);\n\n\treturn f;\n}\n\n//--------------------------------------------------------------------------\nfloat Map(vec3 p)\n{\n\tp *= .002;\n\tfloat h = FBM(p);\n\treturn h-cloudy-.5;\n}\n\n//--------------------------------------------------------------------------\nfloat SeaMap(in vec2 pos)\n{\n\tpos *= .0025;\n\treturn SeaFBM(pos) * (20.0 + cloudy*70.0);\n}\n\n//--------------------------------------------------------------------------\nvec3 SeaNormal( in vec3 pos, in float d, out float height)\n{\n\tfloat p = .005 * d * d / resolution.x;\n\tvec3 nor  \t= vec3(0.0,\t\t    SeaMap(pos.xz), 0.0);\n\tvec3 v2\t\t= nor-vec3(p,\t\tSeaMap(pos.xz+vec2(p,0.0)), 0.0);\n\tvec3 v3\t\t= nor-vec3(0.0,\t\tSeaMap(pos.xz+vec2(0.0,-p)), -p);\n    height = nor.y;\n\tnor = cross(v2, v3);\n\treturn normalize(nor);\n}\n\n#ifdef REAL_SHADOW\n// Real shadow...\nfloat Shadow(vec3 pos, vec3 rd)\n{\n\tpos += rd * 400.0;\n\tfloat s = .0;\n\tfor (int i= 0; i < 5; i++)\n\t{\n\t\ts += max(Map(pos), 0.0)*5.0;\n\t\t//s = clamp(s, 0.0, 1.0);\n\t\tpos += rd * 400.0;\n\t}\n\treturn clamp(s, 0.1, 1.0);\n}\n#endif\n\n//--------------------------------------------------------------------------\n// Grab all sky information for a given ray from camera\nvec3 GetSky(in vec3 pos,in vec3 rd, out vec2 outPos)\n{\n\tfloat sunAmount = max( dot( rd, sunLight), 0.0 );\n\t// Do the blue and sun...\t\n\tvec3  sky = mix(vec3(.0, .1, .4), vec3(.3, .6, .8), 1.0-rd.y);\n\tsky = sky + sunColour * min(pow(sunAmount, 1500.0) * 5.0, 1.0);\n\tsky = sky + sunColour * min(pow(sunAmount, 10.0) * .6, 1.0);\n\t\n\t// Find the start and end of the cloud layer...\n\tfloat beg = ((CLOUD_LOWER-pos.y) / rd.y);\n\tfloat end = ((CLOUD_UPPER-pos.y) / rd.y);\n\t\n\t// Start position...\n\tvec3 p = vec3(pos.x + rd.x * beg, 0.0, pos.z + rd.z * beg);\n\toutPos = p.xz;\n    beg +=  Hash(p)*150.0;\n\n\t// Trace clouds through that layer...\n\tfloat d = 0.0;\n\tvec3 add = rd * ((end-beg) / 45.0);\n\tvec2 shade;\n\tvec2 shadeSum = vec2(0.0, .0);\n\tfloat difference = CLOUD_UPPER-CLOUD_LOWER;\n\tshade.x = .01;\n\t// I think this is as small as the loop can be\n\t// for an reasonable cloud density illusion.\n\tfor (int i = 0; i < 55; i++)\n\t{\n\t\tif (shadeSum.y >= 1.0) break;\n\t\tfloat h = Map(p);\n\t\tshade.y = max(-h, 0.0); \n#ifdef REAL_SHADOW\n\t\tshade.x = Shadow(p, sunLight);\n#else\n        //\tshade.x = clamp(1.*(-Map(p-sunLight*.0)  -Map(p)) / .01, 0.0,1.0)*p.y/difference;\n\t\tshade.x = p.y / difference;  // Grade according to height\n#endif\n\t\tshadeSum += shade * (1.0 - shadeSum.y);\n\n\t\tp += add;\n\t}\n\tshadeSum.x /= 10.0;\n\tshadeSum = min(shadeSum, 1.0);\n\t\n\tvec3 clouds = mix(vec3(pow(shadeSum.x, .4)), sunColour, (1.0-shadeSum.y)*.4);\n\t\n\tclouds += min((1.0-sqrt(shadeSum.y)) * pow(sunAmount, 4.0), 1.0) * 2.0;\n   \n    clouds += flash * (shadeSum.y+shadeSum.x+.2) * .5;\n\n\tsky = mix(sky, min(clouds, 1.0), shadeSum.y);\n\t\n\treturn clamp(sky, 0.0, 1.0);\n}\n\n//--------------------------------------------------------------------------\nvec3 GetSea(in vec3 pos,in vec3 rd, out vec2 outPos)\n{\n\tvec3 sea;\n\tfloat d = -pos.y/rd.y;\n\tvec3 p = vec3(pos.x + rd.x * d, 0.0, pos.z + rd.z * d);\n\toutPos = p.xz;\n\t\n\tfloat dis = length(p-pos);\n    float h = 0.0;\n\tvec3 nor = SeaNormal(p, dis, h);\n\n\tvec3 ref = reflect(rd, nor);\n\tref.y = max(ref.y, 0.0015);\n\tsea = GetSky(p, ref, p.xz);\n\th = h*.005 / (1.0+max(dis*.02-300.0, 0.0));\n   \tfloat fresnel = max(dot(nor, -rd),0.0);\n    fresnel = pow(fresnel, .3)*1.1;\n    \n\tsea = mix(sea*.6, (vec3(.3, .4, .45)+h*h) * max(dot(nor, sunLight), 0.0), min(fresnel, 1.0));\n\t\n\tfloat glit = max(dot(ref, sunLight), 0.0);\n\tsea += sunColour * pow(glit, 220.0) * max(-cloudy*100.0, 0.0);\n\t\n\treturn sea;\n}\n\n//--------------------------------------------------------------------------\nvec3 CameraPath( float t )\n{\n    return vec3(4000.0 * sin(.16*t)+12290.0, 0.0, 8800.0 * cos(.145*t+.3));\n} \n\n//--------------------------------------------------------------------------\nvoid main(void)\n{\n\tfloat m = 0.0;//(iMouse.x/iResolution.x)*30.0;\n\tgTime = time*.5 + m + 75.5;\n\tcloudy = cos(gTime * .25+.4) * .26;\n    float lightning = 0.0;\n    \n    if (cloudy >= .2)\n    {\n        float f = mod(gTime+1.5, 2.5);\n        if (f < .8)\n        {\n            f = smoothstep(.8, .0, f)* 1.5;\n        \tlightning = mod(-gTime*(1.5-Hash(gTime*.3)*.002), 1.0) * f;\n        }\n    }\n    \n    flash = clamp(vec3(1., 1.0, 1.2) * lightning, 0.0, 1.0);\n       \n\n\tvec2 xy = ( gl_FragCoord.xy / resolution.xy );\n    \n\tvec2 uv = (-1.0 + 2.0 * xy) * vec2(resolution.x/resolution.y,1.0);\n\t\n\tvec3 cameraPos = CameraPath(gTime - 2.0);\n\tvec3 camTar\t   = CameraPath(gTime - .0);\n\tcamTar.y = cameraPos.y = sin(gTime) * 200.0 + 300.0;\n\tcamTar.y += 370.0;\n\t\n\tfloat roll = .1 * sin(gTime * .25);\n\tvec3 cw = normalize(camTar-cameraPos);\n\tvec3 cp = vec3(sin(roll), cos(roll),0.0);\n\tvec3 cu = cross(cw,cp);\n\tvec3 cv = cross(cu,cw);\n\tvec3 dir = normalize(uv.x*cu + uv.y*cv + 1.3*cw);\n\tmat3 camMat = mat3(cu, cv, cw);\n\n\tvec3 col;\n\tvec2 pos;\n\tif (dir.y > 0.0)\n\t{\n\t\tcol = GetSky(cameraPos, dir, pos);\n\t}else\n\t{\n\t\tcol = GetSea(cameraPos, dir, pos);\n\t}\n\tfloat l = exp(-length(pos) * .00002);\n\tcol = mix(vec3(.6-cloudy*1.2)+flash*.3, col, max(l, .2));\n\t\n\t// Do the lens flares...\n\tfloat bri = dot(cw, sunLight) * 2.7 * clamp(-cloudy+.2, 0.0, .2);\n\tif (bri > 0.0)\n\t{\n\t\tvec2 sunPos = vec2( dot( sunLight, cu ), dot( sunLight, cv ) );\n\t\tvec2 uvT = uv-sunPos;\n\t\tuvT = uvT*(length(uvT));\n\t\tbri = pow(bri, 6.0)*.6;\n\n\t\tfloat glare1 = max(1.2-length(uvT+sunPos*2.)*2.0, 0.0);\n\t\tfloat glare2 = max(1.2-length(uvT+sunPos*.5)*4.0, 0.0);\n\t\tuvT = mix (uvT, uv, -2.3);\n\t\tfloat glare3 = max(1.2-length(uvT+sunPos*5.0)*1.2, 0.0);\n\n\t\tcol += bri * sunColour * vec3(1.0, .5, .2)  * pow(glare1, 10.0)*25.0;\n\t\tcol += bri * vec3(.8, .8, 1.0) * pow(glare2, 8.0)*9.0;\n\t\tcol += bri * sunColour * pow(glare3, 4.0)*10.0;\n\t}\n\t\n\tvec2 st =  uv * vec2(.5+(xy.y+1.0)*.3, .02)+vec2(gTime*.5+xy.y*.2, gTime*.2);\n\t// Rain...\n\tfloat f = Noise( st*200.5 ) * Noise( st*120.5 ) * 1.3;\n\t\n\tfloat rain = clamp(cloudy-.15, 0.0, 1.0);\n\tf = clamp(pow(abs(f), 15.0) * 5.0 * (rain*rain*125.0), 0.0, (xy.y+.1)*.6);\n\tcol = mix(col, vec3(0.15, .15, .15)+flash, f);\n\tcol = clamp(col, 0.0,1.0);\n\n\t// Stretch RGB upwards... \n\t//col = (1.0 - exp(-col * 2.0)) * 1.1565;\n\t//col = (1.0 - exp(-col * 3.0)) * 1.052;\n\tcol = pow(col, vec3(.7));\n\t//col = (col*col*(3.0-2.0*col));\n\n\t// Vignette...\n\tcol *= .55+0.45*pow(70.0*xy.x*xy.y*(1.0-xy.x)*(1.0-xy.y), 0.15 );\t\n\t\n\tgl_FragColor = vec4(col, 1.0);\n}\n\n//--------------------------------------------------------------------------\n", "user": "b25406", "parent": null, "id": "27651.0"}