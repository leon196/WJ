define( [
  "three", 
  "shader!simple.vert", 
  "shader!planet.frag", 
  "shader!raymarching.frag", 
  "shader!raymarching2.frag", 
  "texture", 
  "video",
  "renderer",
  "container"], 
  function ( THREE, simpleVert, planetFrag, raymarchingFrag, raymarching2Frag, texture, video, renderer, container ) 
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
    picture2: { type: "t", value: texture.texture2 },
    video: { type: "t", value: video.texture },
    fbo: { type: "t", value: video.texture },
    mouseWheel: { type: "f", value: 0 },
    time: { type: "f", value: 0 }
  };

  return {
    bump: new THREE.MeshPhongMaterial( { bumpMap: video.texture } ),
    grass: new THREE.MeshBasicMaterial( { map: video.texture } ),

    shaderPlanet: new THREE.ShaderMaterial( {
      uniforms: commonUniforms,
      vertexShader: simpleVert.value,
      fragmentShader: planetFrag.value,
      side: THREE.DoubleSide
    }),

    shaderRaymarching: new THREE.ShaderMaterial( {
      uniforms: commonUniforms,
      vertexShader: simpleVert.value,
      fragmentShader: raymarchingFrag.value,
      side: THREE.DoubleSide
    }),

    shaderRaymarching2: new THREE.ShaderMaterial( {
      uniforms: commonUniforms,
      vertexShader: simpleVert.value,
      fragmentShader: raymarching2Frag.value,
      side: THREE.DoubleSide
    }),

    solid: new THREE.MeshLambertMaterial( {
      color: 0x00dcdc,
      shading: THREE.FlatShading
    }),
    wire: new THREE.MeshBasicMaterial( { wireframe: true } )
  };
} );
