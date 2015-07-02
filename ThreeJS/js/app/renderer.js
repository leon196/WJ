define( ["three", "container", "gui"], function ( THREE, container, gui ) {

  container.innerHTML = "";
  var renderer = new THREE.WebGLRenderer( { clearColor: 0x000000 } );

  renderer.setPixelRatio(1 / gui.options.pixelSize);

  renderer.sortObjects = false;
  renderer.autoClear = false;
  container.appendChild( renderer.domElement );

  var updateSize = function () {
    renderer.setSize( container.offsetWidth, container.offsetHeight );
  };
  window.addEventListener( 'resize', updateSize, false );
  updateSize();

  return renderer;
} );
