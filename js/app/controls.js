define( ["three", "camera", "helper", "container"], function( THREE, camera, helper, container ) { 
  var controls = new THREE.TrackballControls( helper, container );
  return controls;
} );
