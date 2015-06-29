define( [
  "three",
  "shader!simple.vert",
  "shader!simple.frag",
  "shader!planet.frag",
  "shader!effect.frag",
  "texture",
  "video",
  "renderer",
  "container",
  "gui"],
  function ( THREE, simpleVert, simpleFrag, planetFrag, effectFrag, texture, video, renderer, container, gui )
  {
    var commonUniforms =
    {
      uResolution : { type: "v2", value: new THREE.Vector2( container.offsetWidth, container.offsetHeight ) },
      uMouse : { type: "v3", value: new THREE.Vector3( 0.5, 0.5, 0 ) },
      uTime: { type: "f", value: 0 },
      uRenderTarget: { type: "t", value: texture.renderTarget1 },
      uTexture: { type: "t", value: texture.background },
      uVideo: { type: "t", value: video.texture }
    }

    var raymarchingUniforms =
    {
      uResolution : { type: "v2", value: new THREE.Vector2( container.offsetWidth, container.offsetHeight ) },
      uMouse : { type: "v3", value: new THREE.Vector3( 0.5, 0.5, 0 ) },
      uTime: { type: "f", value: 0 },
      uRenderTarget: { type: "t", value: texture.renderTarget1 },
      uTexture: { type: "t", value: texture.background },
      uVideo: { type: "t", value: video.texture },

      uSamplerPlanet: { type: "t", value: texture.earth },
      uSamplerBackground: { type: "t", value: texture.background },
      uDisplacementScale: { type: "f", value: 0.1 },
      uPlanetRadius: { type: "f", value: 0.9 },
      uRatioMagma: { type: "f", value: 0 },
      uRatioSky: { type: "f", value: 0 },
      uScaleUV: { type: "f", value: 1 },
      uOffsetUV: { type: "v2", value: new THREE.Vector2( 0, 0 ) },
      uRepeat: { type: "f", value: 0 },
      uEye: { type: "v3", value: new THREE.Vector3( 0, 0, -1.5 ) },
      uFront: { type: "v3", value: new THREE.Vector3( 0, 0, 1 ) },
      uUp: { type: "v3", value: new THREE.Vector3( 0, 1, 0 ) },
      uRight: { type: "v3", value: new THREE.Vector3( 1, 0, 0 ) }
    }

    var material = {

      simple: new THREE.ShaderMaterial( {
        uniforms: commonUniforms,
        vertexShader: simpleVert.value,
        fragmentShader: simpleFrag.value,
        side: THREE.DoubleSide
      }),

      effect: new THREE.ShaderMaterial( {
        uniforms: commonUniforms,
        vertexShader: simpleVert.value,
        fragmentShader: effectFrag.value,
        side: THREE.DoubleSide
      }),

      updateRaymarching: function (rayCount, rayEpsilon, rayMax)
      {
        planetFrag.define( "rayCount", "" + rayCount );
        planetFrag.define( "rayEpsilon", "" + rayEpsilon );
        planetFrag.define( "rayMax", "" + rayMax );
      },

      getRaymarchingShaderMaterial: function ()
      {
        return new THREE.ShaderMaterial( {
          uniforms: raymarchingUniforms,
          vertexShader: simpleVert.value,
          fragmentShader: planetFrag.value,
          side: THREE.DoubleSide
        });
      }
  };

  return material;
} );
