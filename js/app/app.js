define( ["three", "container", "screen", "camera", "controls", "helper", "geometry", "light", "material", "texture", "renderer", "scene", "video", "time", "input", "gui"],
  function ( THREE, container, screen, camera, controls, helper, geometry, light, material, texture, renderer, scene, video, time, input, gui )
  {
    var app =
    {
      sceneRender: new THREE.Scene(),
      screenRender: new THREE.Mesh( new THREE.PlaneBufferGeometry( container.offsetWidth, container.offsetHeight ), material.effect ),

      init: function ()
      {
        scene.add( screen );
        app.sceneRender.add ( app.screenRender );
        camera.position.z = 10;
        helper.position.z = -4.5;

        gui.settings.pixelSize.onChange(function(value)
        {
          renderer.setPixelRatio(1 / value);
          renderer.setSize( container.offsetWidth, container.offsetHeight );
        });
      },

      animate: function ()
      {
        window.requestAnimationFrame( app.animate );

        controls.update();
        input.mouse.update();

        var uniforms = screen.material.uniforms;

        screen.material.uniforms.uResolution.value.x = container.offsetWidth * renderer.getPixelRatio();
        screen.material.uniforms.uResolution.value.y = container.offsetHeight * renderer.getPixelRatio();
        screen.material.uniforms.uMouse.value.x = input.mouse.ratio.x;
        screen.material.uniforms.uMouse.value.y = input.mouse.ratio.y;
        screen.material.uniforms.uMouse.value.z = input.mouse.wheel;
        screen.material.uniforms.uTime.value = time.now();

        app.screenRender.material.uniforms.uResolution.value.x = container.offsetWidth * renderer.getPixelRatio();
        app.screenRender.material.uniforms.uResolution.value.y = container.offsetHeight * renderer.getPixelRatio();
        app.screenRender.material.uniforms.uMouse.value.x = input.mouse.ratio.x;
        app.screenRender.material.uniforms.uMouse.value.y = input.mouse.ratio.y;
        app.screenRender.material.uniforms.uMouse.value.z = input.mouse.wheel;
        app.screenRender.material.uniforms.uTime.value = time.now();

        var renderTargetBind = texture.getCurrentTarget();
        app.screenRender.material.uniforms.uRenderTarget.value = renderTargetBind;

        texture.nextTarget();
        var renderTargetDraw = texture.getCurrentTarget();
        renderer.render( app.sceneRender, camera, renderTargetDraw, true );
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

				// renderer.clear();

        screen.material.uniforms.uRenderTarget.value = texture.getCurrentTarget();
        renderer.render( scene, camera );
      }
    };
    return app;
  } );
