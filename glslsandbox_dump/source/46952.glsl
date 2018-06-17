{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\n#extension GL_OES_standard_derivatives : enable\n\nuniform float time;\nuniform vec2 resolution;\n\nvec3 colorFromTicks(float t){\n    float slice = 360.0; // why does this work\n    float r = (sin(t+slice*0.0)+1.0)/2.0;\n    float g = (sin(t+slice*1.0)+1.0)/2.0;\n    float b = (sin(t+slice*2.0)+1.0)/2.0;\n    return vec3(r,g,b);\n}\n\nvoid main( void ) {\n\n    vec2 position = ( gl_FragCoord.xy / resolution.xy );\n\n    float x = position.x;\n    float y = position.y;\n    const float zoom = 60.0;\n    float c2 = time / 1.0 * 3.0;\n    float x2 = x / zoom;\n    float y2 = y / zoom;\n    float k = (\n        128.0 + (32.0 * sin((x / 4.0 * zoom + 10.0 * sin(c2 / 128.0) * 8.0) / 8.0))\n        + 128.0 + (32.0 * cos((y / 5.0 * zoom + 10.0 * cos(c2 / 142.0) * 8.0) / 8.0))\n        + (128.0 + (128.0 * sin(c2 / 40.0 - sqrt(x * x + y * y) * sin(c2 / 64.0) / 8.0)) / 3.0\n        + 128.0 + (128.0 * sin(c2 / 80.0 + sqrt(2.0 * x * x + y * y) * sin(c2 / 256.0) / 8.0)) / 3.0)\n    ) / 4.0;\n\n    gl_FragColor = vec4( colorFromTicks(k+c2), 1.0 );\n\n}", "user": "3a41b3c", "parent": null, "id": 46952}