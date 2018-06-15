{"code": "// Playing with symmetries - Torus\n//\n// by @paulofalcao\n// gty\n\n#ifdef GL_ES\nprecision highp float;\n#endif\n\nuniform vec2 resolution;\nuniform float time;\nuniform vec2 mouse;\n\n//Util Start\nfloat PI=3.14159265;\n\nvec2 ObjUnion(in vec2 obj0,in vec2 obj1){\n  if (obj0.x<obj1.x)\n    return obj0;\n  else\n    return obj1;\n}\nvec3 sim(vec3 p,float s){\n   vec3 ret=p;\n   ret=p+s/2.0;\n   ret=fract(ret/s)*s-s/2.0;\n   return ret;\n}\n\nvec2 rot(vec2 p,float r){\n   vec2 ret;\n   ret.x=p.x*cos(r)-p.y*sin(r);\n   ret.y=p.x*sin(r)+p.y*cos(r);\n   return ret;\n}\n\nvec2 rotsim(vec2 p,float s){\n   vec2 ret=p;\n   ret=rot(p,-PI/(s*2.0));\n   ret=rot(p,floor(atan(ret.x,ret.y)/PI*s)*(PI/s));\n   return ret;\n}\n\n//Util End\n\n//Scene Start\n\n//Floor\nvec2 obj0(in vec3 p){\n  p.y=p.y-1.5;\n  p.xz=rotsim(p.xz,8.0);\n  p.z=p.z-8.0;\n  p.yz=rotsim(p.yz,8.0); \n  p.z=p.z-3.0;\n  p.xy=rotsim(p.xy,2.0);\n  float c1=length(max(abs(p)-vec3(0.2,0.2,0.2),0.0));\n  float c3=length(max(abs(p)-vec3(0.1,4.0,0.1),0.0));\n  return vec2(min(c1,c3),0);\n}\n//Floor Color (checkerboard)\nvec3 obj0_c(in vec3 p){\n  return vec3(1.0,0.5,0.2);\n}\n\nvec2 obj1(vec3 p){\n  p.y=p.y-1.5;\n  p.xz=rotsim(p.xz,16.0);\n  p.z=p.z-8.0;\n  p.yz=rotsim(p.yz,16.0); \n  p.z=p.z-4.0;\n  p.xy=rotsim(p.xy,2.0);\n  float c1=length(max(abs(p)-vec3(0.2,0.2,0.2),0.0));\n  float c3=length(max(abs(p)-vec3(0.1,2.0,0.1),0.0));\n  return vec2(min(c1,c3),1);\n}\n\n//RoundBox with simple solid color\nvec3 obj1_c(in vec3 p){\n  return vec3(0.2,0.5,1.0);\n}\n\n//Objects union\nvec2 inObj(in vec3 p){\n  return ObjUnion(obj0(p),obj1(p));\n}\n\n//Scene End\n\nvoid main(void){\n  vec2 vPos=-1.0+2.0*gl_FragCoord.xy/resolution.xy;\n \n  //Camera animation\n  vec3 vuv=vec3(0,1,0);//Change camere up vector here\n  vec3 vrp=vec3(0,0,0); //Change camere view here\n  vec3 prp=vec3(cos(time*0.2),0.1,sin(time*0.2))*11.0; //Trackball style camera pos\n  float vpd=1.5;  \n \n  //Camera setup\n  vec3 vpn=normalize(vrp-prp);\n  vec3 u=normalize(cross(vuv,vpn));\n  vec3 v=cross(vpn,u);\n  vec3 scrCoord=prp+vpn*vpd+vPos.x*u*resolution.x/resolution.y+vPos.y*v;\n  vec3 scp=normalize(scrCoord-prp);\n\n  //Raymarching\n  const vec3 e=vec3(0.1,0,0);\n  const float maxd=60.0; //Max depth\n\n  vec2 s=vec2(0.1,0.0);\n  vec3 c,p,n;\n\n  float f=1.0;\n  for(int i=0;i<256;i++){\n    if (abs(s.x)<.001||f>maxd) break;\n    f+=s.x;\n    p=prp+scp*f;\n    s=inObj(p);\n  }\n  \n  if (f<maxd){\n    if (s.y==0.0)\n      c=obj0_c(p);\n    else\n      c=obj1_c(p);\n \n    //tetrahedron normal\n    const float n_er=0.01;\n    float v1=inObj(vec3(p.x+n_er,p.y-n_er,p.z-n_er)).x;\n    float v2=inObj(vec3(p.x-n_er,p.y-n_er,p.z+n_er)).x;\n    float v3=inObj(vec3(p.x-n_er,p.y+n_er,p.z-n_er)).x;\n    float v4=inObj(vec3(p.x+n_er,p.y+n_er,p.z+n_er)).x;\n    n=normalize(vec3(v4+v1-v3-v2,v3+v4-v1-v2,v2+v4-v3-v1));\n    \n    float b=dot(n,normalize(prp-p));\n    gl_FragColor=vec4((b*c+pow(b,8.0))*(1.0-f*.01),1.0);//simple phong LightPosition=CameraPosition\n  }\n  else gl_FragColor=vec4(0,0,0,1); //background color\n}", "user": "f901a76", "parent": "/e#793.0", "id": "6451.0"}