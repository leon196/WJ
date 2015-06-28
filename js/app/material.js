define( [
  "three", 
  "shader!simple.vert", 
  "shader!planet.frag", 
  "shader!raymarching.frag", 
  "shader!raymarching2.frag", 
  "shader!effect.frag", 
  "texture", 
  "video",
  "renderer",
  "container"], 
  function ( THREE, simpleVert, planetFrag, raymarchingFrag, raymarching2Frag, effectFrag, texture, video, renderer, container ) 
  {
  // Shader objects support redefining of #defines.
  // See `simple.frag` file, where `faceColor` is already defined to be white, and we are overriding it to red here
  // simpleFrag.define( "faceColor", "vec3(1.0, 0, 0)" );

  var commonUniforms = {
    // uColor: { type: "c", value: new THREE.Color( "#ff0000" ) }
    bufferSize : { type: "v2", value: new THREE.Vector2( container.offsetWidth, container.offsetHeight ) },
    screenSize : { type: "v2", value: new THREE.Vector2( container.offsetWidth, container.offsetHeight ) },
    mouse : { type: "v2", value: new THREE.Vector2( 0, 0 ) },
    picture1: { type: "t", value: texture.earth },
    picture2: { type: "t", value: texture.background },
    video: { type: "t", value: video.texture },
    fbo: { type: "t", value: video.texture },
    mouseWheel: { type: "f", value: 0 },
    terrainHeight: { type: "f", value: 0.1 },
    sphereRadius: { type: "f", value: 0.9 },
    time: { type: "f", value: 0 },
    ratioMagma: { type: "f", value: 0 },
    ratioSky: { type: "f", value: 0 },
    uvScale: { type: "f", value: 1 },
    uvOffset: { type: "v2", value: new THREE.Vector2( 0, 0 ) },
    eye: { type: "v3", value: new THREE.Vector3( 0, 0, -1.5 ) },
    front: { type: "v3", value: new THREE.Vector3( 0, 0, 1 ) },
    up: { type: "v3", value: new THREE.Vector3( 0, 1, 0 ) },
    right: { type: "v3", value: new THREE.Vector3( 1, 0, 0 ) },
    repeat: { type: "f", value: 0 }
  };

  var material = {

    bump: new THREE.MeshPhongMaterial( { bumpMap: video.texture } ),
    grass: new THREE.MeshBasicMaterial( { map: video.texture } ),
    solid: new THREE.MeshLambertMaterial( {
      color: 0x00dcdc,
      shading: THREE.FlatShading
    }),
    wire: new THREE.MeshBasicMaterial( { wireframe: true } ),

    setRayCount: function (rayCount)
    {
      raymarching2Frag.define( "rayCount", "" + rayCount );
    },

    setRayEpsilon: function (rayEpsilon)
    {
      raymarching2Frag.define( "rayEpsilon", "" + rayEpsilon );
    },

    setRayMax: function (rayMax)
    {
      raymarching2Frag.define( "rayMax", "" + rayMax );
    },

    getShaderMaterial: function ()
    {
      return new THREE.ShaderMaterial( {
        uniforms: commonUniforms,
        vertexShader: simpleVert.value,
        fragmentShader: raymarching2Frag.value,
        side: THREE.DoubleSide
      });
    },

    effect: new THREE.ShaderMaterial( {
      uniforms: commonUniforms,
      vertexShader: simpleVert.value,
      fragmentShader: effectFrag.value,
      side: THREE.DoubleSide
    })
  };

  return material;
} );
