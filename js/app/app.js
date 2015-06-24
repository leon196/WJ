define( ["three", "container", "camera", "controls", "geometry", "light", "material", "renderer", "scene", "video", "time", "input"],
  function ( THREE, container, camera, controls, geometry, light, material, renderer, scene, video, time, input ) 
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
        quad = new THREE.Mesh( plane, material.shaderPlanet );
        quad.position.z = -100;
        scene.add( quad );
      },

      animate: function () 
      {
        window.requestAnimationFrame( app.animate );

        // Trackball Controls
        //controls.update();

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

        // material.shader.uniforms.uTimeElapsed.value = time.now();

        renderer.render( scene, camera );
      }
    };
    return app;
  } );
