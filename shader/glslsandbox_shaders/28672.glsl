{"code": "\n//-------------------------------------------------------------------\n// SixteenSegmentDisplayV4.glsl                   2015-11-05\n// 16 Segment Display Example v4.2\n// rearranged source code by I.G.P.\n// http://glslsandbox.com/e#28623\n// Do you know further optimizations ? \n// Question: Extremely high memory usage at startup - why?\n// hint: change neon colors by moving around with your mouse!\n//-------------------------------------------------------------------\n\n#ifdef GL_ES\nprecision highp float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nconst vec2 ch_size  = vec2(0.8, 0.8);              // character size\nconst vec2 ch_space = ch_size + vec2(0.4, 0.6);    // character distance  \nconst vec2 ch_start = vec2 (ch_space.x * -11.,4.); // start position\n      vec2 ch_pos   = vec2 (0.0, 0.0);             // character position\n      vec3 ch_color = vec3 (0.6, 1.7, 0.8);        // character color\nconst vec3 bg_color = vec3 (0.0, 0.0, 0.0);        // background color\n\nvec2 uv;    // current position\n\n/*========== 16 segment display ==============    bin. hex\n                                                  0000 0\nSegment bit positions:                            0001 1 \n                                                  0010 2\n  __2__ __1__         any bit adds one segment    0011 3\n |\\    |    /|                                    0100 4\n | \\   |   / |     bit:   15 12 11 8 7654 3210    0101 5          \n 3  11 10 9  0             |  | |  | |||| ||||    0110 6          \n |   \\ | /   |    binary:  0000 0000 0000 0000    0111 7      \n |    \\|/    |                                    1000 8     \n  _12__ __8__         example: letter A           1001 9     \n |           |                                    1010 A     \n |    /|\\    |            15 12 11 8 7654 3210    1011 B         \n 4   / | \\   7             |  | |  | |||| ||||    1100 C         \n | 13 14  15 |             0001 0001 1001 1111    1101 D         \n | /   |   \\ |                                    1110 E      \n  __5__|__6__          binary to hex -> 0x119F    1111 F       \n*/\n\n#define n0 ddigit(0x22FF);\n#define n1 ddigit(0x0281);\n#define n2 ddigit(0x1177);\n#define n3 ddigit(0x11E7);\n#define n4 ddigit(0x5508);\n#define n5 ddigit(0x11EE);\n#define n6 ddigit(0x11FE);\n#define n7 ddigit(0x2206);\n#define n8 ddigit(0x11FF);\n#define n9 ddigit(0x11EF);\n\n#define A ddigit(0x119F);\n#define B ddigit(0x927E);\n#define C ddigit(0x007E);\n#define D ddigit(0x44E7);\n#define E ddigit(0x107E);\n#define F ddigit(0x101E);\n#define G ddigit(0x807E);\n#define H ddigit(0x1199);\n#define I ddigit(0x4466);\n#define J ddigit(0x4436);\n#define K ddigit(0x9218);\n#define L ddigit(0x0078);\n#define M ddigit(0x0A99);\n#define N ddigit(0x8899);\n#define O ddigit(0x00FF);\n#define P ddigit(0x111F);\n#define Q ddigit(0x80FF);\n#define R ddigit(0x911F);\n#define S ddigit(0x8866);\n#define T ddigit(0x4406);\n#define U ddigit(0x00F9);\n#define V ddigit(0x2218);\n#define W ddigit(0xA099);\n#define X ddigit(0xAA00);\n#define Y ddigit(0x4A00);\n#define Z ddigit(0x2266);\n#define s_dot     ddots(0);\n#define s_ddot    ddots(1);\n#define s_minus   ddigit(0x1100);\n#define s_plus    ddigit(0x5500);\n#define s_mult    ddigit(0xBB00);\n#define s_div     ddigit(0x2200);\n#define s_greater ddigit(0x2800);\n#define s_less    ddigit(0x8200);\n#define s_open    ddigit(0x003C);\n#define s_close   ddigit(0x00C3);\n#define s_sqrt    ddigit(0x0C02);\n#define s_uline   ddigit(0x0060);\n#define _  ch_pos.x += ch_space.x;  // blanc\n#define nl ch_pos.x = ch_start.x;  ch_pos.y -= 3.0;\n\n//-------------------------------------------------------------------\nfloat dseg(vec2 p0, vec2 p1)    // draw segment\n{\n  p0 *= ch_size;\n  p1 *= ch_size;\n  vec2 dir = normalize(p1 - p0);\n  vec2 cp = (uv - ch_pos - p0) * mat2(dir.x, dir.y,-dir.y, dir.x);\n  return 2.0*distance(cp, clamp(cp, vec2(0), vec2(distance(p0, p1), 0)));   \n}\n\nbool bit(int n, int b)  // return true if bit b of n is set\n{\n  return mod(floor(float(n) / exp2(floor(float(b)))), 2.0) != 0.0;\n}\n\nfloat d = 1.0;\n\nvoid ddots(int n)\n{\n  float v = 1.0;\t\n  if      (n == 0)   v = min(v, dseg(vec2(-0.005, -1.000), vec2( 0.000, -1.000)));\n  else if (n == 1) { v = min(v, dseg(vec2( 0.005, -1.000), vec2( 0.000, -1.000))); \n\t\t     v = min(v, dseg(vec2( 0.005,  0.000), vec2( 0.000,  0.000))); \n\t\t   }\n  ch_pos.x += ch_space.x;\n  d = min(d, v);\n}\n\nvoid ddigit(int n)\n{\n  float v = 1.0;\t\n  if (bit(n,  0)) v = min(v, dseg(vec2( 0.500,  0.063), vec2( 0.500,  0.937)));\n  if (bit(n,  1)) v = min(v, dseg(vec2( 0.438,  1.000), vec2( 0.063,  1.000)));\n  if (bit(n,  2)) v = min(v, dseg(vec2(-0.063,  1.000), vec2(-0.438,  1.000)));\n  if (bit(n,  3)) v = min(v, dseg(vec2(-0.500,  0.937), vec2(-0.500,  0.062)));\n  if (bit(n,  4)) v = min(v, dseg(vec2(-0.500, -0.063), vec2(-0.500, -0.938)));\n  if (bit(n,  5)) v = min(v, dseg(vec2(-0.438, -1.000), vec2(-0.063, -1.000)));\n  if (bit(n,  6)) v = min(v, dseg(vec2( 0.063, -1.000), vec2( 0.438, -1.000)));\n  if (bit(n,  7)) v = min(v, dseg(vec2( 0.500, -0.938), vec2( 0.500, -0.063)));\n  if (bit(n,  8)) v = min(v, dseg(vec2( 0.063,  0.000), vec2( 0.438, -0.000)));\n  if (bit(n,  9)) v = min(v, dseg(vec2( 0.063,  0.063), vec2( 0.438,  0.938)));\n  if (bit(n, 10)) v = min(v, dseg(vec2( 0.000,  0.063), vec2( 0.000,  0.937)));\n  if (bit(n, 11)) v = min(v, dseg(vec2(-0.063,  0.063), vec2(-0.438,  0.938)));\n  if (bit(n, 12)) v = min(v, dseg(vec2(-0.438,  0.000), vec2(-0.063, -0.000)));\n  if (bit(n, 13)) v = min(v, dseg(vec2(-0.063, -0.063), vec2(-0.438, -0.938)));\n  if (bit(n, 14)) v = min(v, dseg(vec2( 0.000, -0.938), vec2( 0.000, -0.063)));\n  if (bit(n, 15)) v = min(v, dseg(vec2( 0.063, -0.063), vec2( 0.438, -0.938)));\n\n  ch_pos.x += ch_space.x;\n  d = min(d, v);\n}\n\n//-------------------------------------------------------------------\n// show one digit\nvoid showDigit (float dd)\n{\n    if      (dd < 0.5) n0\n    else if (dd < 1.5) n1\n    else if (dd < 2.5) n2\n    else if (dd < 3.5) n3\n    else if (dd < 4.5) n4\n    else if (dd < 5.5) n5 \n    else if (dd < 6.5) n6\n    else if (dd < 7.5) n7\n    else if (dd < 8.5) n8\n    else if (dd < 9.5) n9\n}\n\nvoid showFloat (float value)\n{\n  for(int ni = 4; ni > -3; ni--)\n  {\n    if (ni == -1) s_dot;   // add dot\n    float dd = (value / pow(10.0,float(ni)));\n    dd = mod(floor(dd), 10.0);\n    showDigit (dd);\n  }\n}\n\n// show integer value with 5 digits and leading zero digits\nvoid showInteger5 (int value)\n{\n  float fv = float(value);\n  for(int ni = 4; ni >= 0; ni--)\n  {\n    float dd = fv / pow(10.0,float(ni));\n    dd = mod(floor(dd), 10.0);\n    showDigit (dd);\n  }\n}\n\n// show integer value without leading zero digits\nvoid showInteger (int value)\n{\n  bool startDisplay = false;\n  float fv = float(value) / 10000.;\n  for(int ni = 5; ni > 0; ni--)\n  {\n    float dd = mod(floor(fv), 10.0);\n    if ((dd > 1.0)||(ni==1)) startDisplay = true;\n    if (startDisplay) \n      showDigit (dd);\n    fv = fv * 10.0;\n  }\n}\n//-------------------------------------------------------------------\nvoid main( void ) \n{\n  vec2 aspect = resolution.xy / resolution.y;\n  uv = ( gl_FragCoord.xy / resolution.y ) - aspect / 2.0;\n  uv *= 20.0 + sin(time);     //  set zoom size\n  vec2 mp = mouse * resolution.xy;\n  ch_pos = ch_start + vec2(sin(time),4.0);  // set start position\n       \n  ch_color = vec3 (2.6 - 4.*mouse.x, 1.2-mouse.x*mouse.y, 0.5+mouse.y);\n  n1 n6 s_minus S E G M E N T s_minus D I S P L A Y s_dot V n4 s_ddot  nl\n  A B C D E F G H I J K L M N O P Q R S T U V W X Y Z nl\n  s_plus s_minus n0 n1 n2 n3 n4 n5 n6 n7 n8 n9 s_dot s_ddot s_uline s_less s_greater s_open s_close s_sqrt nl\n  V I E W P O R T _ I S _ showInteger(int(resolution.x)); _ s_mult _ showInteger(int(resolution.y)); nl\n  R U N T I M E s_ddot showFloat(time);\t_ S E C O N D S nl\n  M O U S E _ P O S I T I O N _ showInteger(int(mp.x)); s_mult showInteger(int (mp.y));\n  \n  ch_color = mix(ch_color, bg_color, 1.0 - (0.08 / d));  // shading\n\t\n  gl_FragColor = vec4(ch_color, 1.0);\n}\n", "user": "fbdf760", "parent": "/e#28623.3", "id": "28672.0"}