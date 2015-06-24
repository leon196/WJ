define( ["three", "container", "camera", "controls", "geometry", "light", "material", "renderer", "scene", "video", "time", "input"],
  function ( THREE, container, camera, controls, geometry, light, material, renderer, scene, video, time, input ) 
  {
    var app = 
    {
      init: function () 
      {
        var plane = new THREE.PlaneBufferGeometry( window.innerWidth, window.innerHeight );
        quad = new THREE.Mesh( plane, material.shader );
        quad.position.z = -100;
        scene.add( quad );
      },

      animate: function () 
      {
        window.requestAnimationFrame( app.animate );

        // Trackball Controls
        //controls.update();

        // material.shader.uniforms.uTimeElapsed.value = time.now();

        renderer.render( scene, camera );
      }
    };
    return app;
  } );
