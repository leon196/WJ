define( ["three", "container", "screen", "camera", "controls", "geometry", "light", "material", "renderer", "scene", "video", "time", "input", "gui"],
  function ( THREE, container, screen, camera, controls, geometry, light, material, renderer, scene, video, time, input, gui ) 
  {
    var app = 
    {

      materials: 
      [
        material.shaderRaymarching2,
        material.shaderRaymarching,
        material.shaderPlanet
      ],

      currentMaterial: 0,

      init: function () 
      {
        var plane = new THREE.PlaneBufferGeometry( screen.getWidth(), screen.getHeight() );
        quad = new THREE.Mesh( plane, app.materials[app.currentMaterial] );
        scene.add( quad );
        
        camera.position.z = 100;

        controls.enabled = false;
        input.mouse.dragging = true;
      },

      animate: function () 
      {
        window.requestAnimationFrame( app.animate );

        controls.update();

        if (input.keyboard.left.fired)
        {
          input.keyboard.left.fired = false;
          app.currentMaterial = (app.currentMaterial + app.materials.length - 1) % app.materials.length;
          quad.material = app.materials[app.currentMaterial];
        }
        else if (input.keyboard.right.fired)
        {
          input.keyboard.right.fired = false;
          app.currentMaterial = (app.currentMaterial + 1) % app.materials.length;
          quad.material = app.materials[app.currentMaterial];
        }

        app.materials[app.currentMaterial].uniforms.screenSize.value.x = screen.getWidth();
        app.materials[app.currentMaterial].uniforms.screenSize.value.y = screen.getHeight();
        app.materials[app.currentMaterial].uniforms.mouse.value.x = input.mouse.ratio.x;
        app.materials[app.currentMaterial].uniforms.mouse.value.y = input.mouse.ratio.y;
        app.materials[app.currentMaterial].uniforms.time.value = time.now();
        app.materials[app.currentMaterial].uniforms.mouseWheel.value = input.mouse.wheel;
        app.materials[app.currentMaterial].uniforms.terrainHeight.value = gui.options.terrainHeight;
        app.materials[app.currentMaterial].uniforms.sphereRadius.value = gui.options.sphereRadius;


        renderer.render( scene, camera );
      }
    };
    return app;
  } );
