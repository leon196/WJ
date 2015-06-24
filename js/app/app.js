define( ["three", "container", "camera", "controls", "geometry", "light", "material", "renderer", "scene", "video", "time", "input", "gui"],
  function ( THREE, container, camera, controls, geometry, light, material, renderer, scene, video, time, input, gui ) 
  {
    var app = 
    {

      materials: 
      [
        material.shaderRaymarching,
        material.shaderPlanet
      ],

      currentMaterial: 0,

      init: function () 
      {
        var plane = new THREE.PlaneBufferGeometry( window.innerWidth, window.innerHeight );
        quad = new THREE.Mesh( plane, app.materials[app.currentMaterial] );
        // quad.position.z = -1;
        scene.add( quad );
        
        camera.position.z = 700;

        controls.enabled = false;
        input.mouse.dragging = true;
      },

      animate: function () 
      {
        window.requestAnimationFrame( app.animate );

        // Trackball Controls
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

        app.materials[app.currentMaterial].uniforms.mouse.value = new THREE.Vector2(input.mouse.ratio.x, input.mouse.ratio.y);

        renderer.render( scene, camera );
      }
    };
    return app;
  } );
