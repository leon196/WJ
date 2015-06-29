define( ["three", "container", "screen", "camera", "controls", "helper", "geometry", "light", "material", "texture", "renderer", "scene", "video", "time", "input", "gui"],
  function ( THREE, container, screen, camera, controls, helper, geometry, light, material, texture, renderer, scene, video, time, input, gui )
  {
    var app =
    {
      init: function ()
      {
        scene.add( screen );
        camera.position.z = 10;
        helper.position.z = -4.5;
      },

      animate: function ()
      {
        window.requestAnimationFrame( app.animate );

        controls.update();
        input.mouse.update();

        var uniforms = screen.material.uniforms;

        uniforms.uResolution.value.x = container.offsetWidth * renderer.getPixelRatio();
        uniforms.uResolution.value.y = container.offsetHeight * renderer.getPixelRatio();
        uniforms.uMouse.value.x = input.mouse.ratio.x;
        uniforms.uMouse.value.y = input.mouse.ratio.y;
        uniforms.uMouse.value.z = input.mouse.wheel;
        uniforms.uTime.value = time.now();
/*
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
*/
        renderer.render( scene, camera );
      }
    };
    return app;
  } );
