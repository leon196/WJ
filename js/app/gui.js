
define( ["three", "container", "renderer", "controls", "input"], function ( THREE, container, renderer, controls, input ) {

  var gui = 
  {
    dat: new dat.GUI(),

    options:  
    {
      resolution: 2,
      terrainHeight: 0.1,
      sphereRadius: 0.9,
      explode: function() { }
      // Define render logic ...
    },

    init: function ()
    {
      // gui.dat.add(gui.options, 'message');
      gui.dat.add(gui.options, 'resolution', 1, 4).name('Pixel size').step(1).onChange(function(value)
      {
        renderer.setPixelRatio(1 / value);
        renderer.setSize( container.offsetWidth, container.offsetHeight );
      });
      gui.dat.add(gui.options, 'terrainHeight', 0, 0.5).name('Height Scale');
      gui.dat.add(gui.options, 'sphereRadius', 0.1, 1).name('Planet Raduis');
      // gui.dat.add(controls, 'enabled').name('Trackball controls').listen();
      // gui.dat.add(input.mouse, 'dragging').name('Mouse dragging').listen();
      // gui.dat.add(gui.options, 'explode');
    },

    update: function ()
    {
        for (var i in gui.dat.__controllers) 
        {
          gui.dat.__controllers[i].updateDisplay();
        }
    }
  }

  gui.init();

  return gui;
} );
