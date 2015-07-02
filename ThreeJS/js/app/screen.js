define( ["renderer", "container", "material"], function ( renderer, container, material )
{
  var screen = new THREE.Mesh( new THREE.PlaneBufferGeometry( container.offsetWidth, container.offsetHeight ), material.simple );
  return screen;
} );
