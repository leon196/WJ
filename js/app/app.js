define( ["three", "container", "screen", "camera", "controls", "geometry", "light", "material", "renderer", "scene", "video", "time", "input", "gui"],
  function ( THREE, container, screen, camera, controls, geometry, light, material, renderer, scene, video, time, input, gui ) 
  {
    var app = 
    {
      init: function () 
      {
        var plane = new THREE.PlaneBufferGeometry( screen.getWidth(), screen.getHeight() );
        quad = new THREE.Mesh( plane, material.getShaderMaterial() );
        scene.add( quad );
        
        camera.position.z = 100;

        controls.enabled = false;
        input.mouse.dragging = true;

        gui.settings.resolution.onChange(function(value)
        {
          renderer.setPixelRatio(1 / value);
          renderer.setSize( container.offsetWidth, container.offsetHeight );
        });

        gui.settings.rayCount.onChange(function(value)
        {
          material.setRayCount(value);
          quad.material = material.getShaderMaterial();
        });

        gui.settings.rayMax.onChange(function(value)
        {
          material.setRayMax(value);
          quad.material = material.getShaderMaterial();
        });

        gui.settings.rayEpsilon.onChange(function(value)
        {
          material.setRayEpsilon(value);
          quad.material = material.getShaderMaterial();
        });
      },

      animate: function () 
      {
        window.requestAnimationFrame( app.animate );

        controls.update();
        input.mouse.update();

        quad.material.uniforms.screenSize.value.x = screen.getWidth();
        quad.material.uniforms.screenSize.value.y = screen.getHeight();
        quad.material.uniforms.mouse.value.x = input.mouse.ratio.x;
        quad.material.uniforms.mouse.value.y = input.mouse.ratio.y;
        quad.material.uniforms.time.value = time.now();
        quad.material.uniforms.mouseWheel.value = input.mouse.wheel;
        quad.material.uniforms.terrainHeight.value = gui.options.terrainHeight;
        quad.material.uniforms.sphereRadius.value = gui.options.sphereRadius;
        quad.material.uniforms.ratioMagma.value = gui.options.ratioMagma;
        quad.material.uniforms.ratioSky.value = gui.options.ratioSky;

        renderer.render( scene, camera );
      }
    };
    return app;
  } );
