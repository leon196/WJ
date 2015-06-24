
define( ["three", "container", "controls", "input"], function ( THREE, container, controls, input ) {

  var gui = 
  {
    dat: new dat.GUI(),

    options:  
    {
      message: 'dat.gui',
      speed: 0.8,
      explode: function() { }
      // Define render logic ...
    },

    init: function ()
    {
      // gui.dat.add(gui.options, 'message');
      // gui.dat.add(gui.options, 'speed', -5, 5);
      gui.dat.add(controls, 'enabled').name('Trackball Controls').listen();
      gui.dat.add(input.mouse, 'dragging').name('Mouse Dragging').listen();
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
