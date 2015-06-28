define( ["three", "container", "screen", "camera", "controls", "helper", "geometry", "light", "material", "texture", "renderer", "scene", "video", "time", "input", "gui"],
  function ( THREE, container, screen, camera, controls, helper, geometry, light, material, texture, renderer, scene, video, time, input, gui ) 
  {
    var app = 
    {
      init: function () 
      {
        var plane = new THREE.PlaneBufferGeometry( screen.getWidth(), screen.getHeight() );
        // var plane = new THREE.BoxGeometry( 10, 10, 10 );
        quad = new THREE.Mesh( plane, material.getShaderMaterial() );
        scene.add( quad );

        camera.position.z = 10;
        helper.position.z = -4.5;

        // controls.minDistance = 1.0;
        // controls.enabled = false;
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

        gui.settings.rayEpsilon.onChange(function(value)
        {
          material.setRayEpsilon(value);
          quad.material = material.getShaderMaterial();
        });

        gui.settings.texture.onChange(function(value)
        {
          if (value == 'Earth')
          {
            quad.material.uniforms.picture1.value = texture.earth;
          }
          else if (value == 'Fulldome')
          {
            quad.material.uniforms.picture1.value = texture.fulldome;
          }
          else if (value == 'Video')
          {
            quad.material.uniforms.picture1.value = video.texture; 
          }
        });
      },

      animate: function () 
      {
        window.requestAnimationFrame( app.animate );

        controls.update();
        input.mouse.update();

        // console.log(helper)

        quad.material.uniforms.screenSize.value.x = screen.getWidth();
        quad.material.uniforms.screenSize.value.y = screen.getHeight();
        quad.material.uniforms.mouse.value.x = input.mouse.ratio.x;
        quad.material.uniforms.mouse.value.y = input.mouse.ratio.y;
        quad.material.uniforms.time.value = time.now();
        quad.material.uniforms.mouseWheel.value = input.mouse.wheel * input.mouse.wheel;
        quad.material.uniforms.terrainHeight.value = gui.options.terrainHeight;
        quad.material.uniforms.sphereRadius.value = gui.options.sphereRadius;
        quad.material.uniforms.ratioMagma.value = gui.options.ratioMagma;
        quad.material.uniforms.ratioSky.value = gui.options.ratioSky;
        quad.material.uniforms.uvScale.value = gui.options.uvScale;
        quad.material.uniforms.uvOffset.value.y = gui.options.uvOffset;

        quad.material.uniforms.eye.value = helper.position;
        quad.material.uniforms.front.value = helper.getFront();
        quad.material.uniforms.up.value = helper.getUp();
        quad.material.uniforms.right.value = helper.getRight();

        quad.material.uniforms.repeat.value = gui.options.repeat;

        // console.log(helper.up)

        renderer.render( scene, camera );
      }
    };
    return app;
  } );
