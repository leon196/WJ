define( ["three", "container", "screen", "camera", "controls", "helper", "geometry", "light", "material", "texture", "renderer", "scene", "video", "time", "input", "gui"],
  function ( THREE, container, screen, camera, controls, helper, geometry, light, material, texture, renderer, scene, video, time, input, gui )
  {
    var app =
    {
      init: function ()
      {
        var plane = new THREE.PlaneBufferGeometry( screen.getWidth(), screen.getHeight() );
        // var plane = new THREE.BoxGeometry( 10, 10, 10 );
        quad = new THREE.Mesh( plane, material.getRaymarchingShaderMaterial() );
        scene.add( quad );

        camera.position.z = 10;
        helper.position.z = -4.5;

        gui.settings.resolution.onChange(function(value)
        {
          renderer.setPixelRatio(1 / value);
          renderer.setSize( container.offsetWidth, container.offsetHeight );
        });

        gui.settings.rayCount.onChange(function(value)
        {
          material.updateRaymarching(value, gui.options.rayEpsilon, gui.options.rayMax);
          quad.material = material.getRaymarchingShaderMaterial();
        });

        gui.settings.rayEpsilon.onChange(function(value)
        {
          material.updateRaymarching(gui.options.rayCount, value, gui.options.rayMax);
          quad.material = material.getRaymarchingShaderMaterial();
        });

      },

      animate: function ()
      {
        window.requestAnimationFrame( app.animate );

        controls.update();
        input.mouse.update();

        var uniforms = quad.material.uniforms;

        uniforms.uResolution.value.x = screen.getWidth();
        uniforms.uResolution.value.y = screen.getHeight();
        uniforms.uMouse.value.x = input.mouse.ratio.x;
        uniforms.uMouse.value.y = input.mouse.ratio.y;
        uniforms.uMouse.value.z = input.mouse.wheel;
        uniforms.uTime.value = time.now();

        uniforms.uDisplacementScale.value = gui.options.uDisplacementScale;
        uniforms.uPlanetRadius.value = gui.options.uPlanetRadius;
        uniforms.uRatioMagma.value = gui.options.uRatioMagma;
        uniforms.uRatioSky.value = gui.options.uRatioSky;
        uniforms.uScaleUV.value = gui.options.uScaleUV;
        uniforms.uOffsetUV.value.y = gui.options.uOffsetUV;
        uniforms.uRepeat.value = gui.options.uRepeat;

        uniforms.uEye.value = helper.position;
        uniforms.uFront.value = helper.getFront();
        uniforms.uUp.value = helper.getUp();
        uniforms.uRight.value = helper.getRight();

        renderer.render( scene, camera );
      }
    };
    return app;
  } );
