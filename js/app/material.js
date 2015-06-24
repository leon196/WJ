define( ["three", "shader!simple.vert", "shader!simple.frag", "texture", "video"], function ( THREE, simpleVert, simpleFrag, texture, video ) {
  // Shader objects support redefining of #defines.
  // See `simple.frag` file, where `faceColor` is already defined to be white, and we are overriding it to red here
  simpleFrag.define( "faceColor", "vec3(1.0, 0, 0)" );
  return {
    bump: new THREE.MeshPhongMaterial( { bumpMap: video.texture } ),
    grass: new THREE.MeshBasicMaterial( { map: video.texture } ),
    shader: new THREE.ShaderMaterial( {
      uniforms: {
        // uColor: { type: "c", value: new THREE.Color( "#ff0000" ) }
        bufferSize : { type: "v2", value: new THREE.Vector2( window.innerWidth, window.innerHeight ) },
        screenSize : { type: "v2", value: new THREE.Vector2( window.innerWidth, window.innerHeight ) },
        picture: { type: "t", value: texture },
        video: { type: "t", value: video.texture },
        fbo: { type: "t", value: video.texture }
      },
      vertexShader: simpleVert.value,
      fragmentShader: simpleFrag.value,
      side: THREE.DoubleSide
    }),
    solid: new THREE.MeshLambertMaterial( {
      color: 0x00dcdc,
      shading: THREE.FlatShading
    }),
    wire: new THREE.MeshBasicMaterial( { wireframe: true } )
  };
} );
