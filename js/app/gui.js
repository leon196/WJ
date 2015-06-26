
define( ["three", "container", "renderer", "controls", "input"], function ( THREE, container, renderer, controls, input ) {

  var gui = 
  {
    dat: new dat.GUI(),

    options:  
    {
      resolution: 2,
      terrainHeight: 0.1,
      sphereRadius: 0.9,
      ratioMagma: 0,
      ratioSky: 1,
      rayCount: 64,
      rayEpsilon: 0.0001,
      rayMax: 10,
      texture: '',
      uvScale: 1
    },

    settings: {},

    folders: {},

    init: function ()
    {
      gui.settings.resolution = gui.dat.add(gui.options, 'resolution', 1, 4).name('Pixel size').step(1);

      gui.folders.transformation = gui.dat.addFolder('Transformation');
      gui.settings.sphereRadius = gui.folders.transformation.add(
        gui.options, 'sphereRadius', 0.1, 1).name('Planet raduis');
      gui.settings.terrainHeight = gui.folders.transformation.add(
        gui.options, 'terrainHeight', -0.5, 0.5).name('Height scale');
      gui.settings.uvScale = gui.folders.transformation.add(
        gui.options, 'uvScale', 1, 8).name('UV scale');
      gui.folders.transformation.open();

      gui.folders.color = gui.dat.addFolder('Color');
      gui.settings.texture = gui.folders.color.add(
        gui.options, 'texture', [ 'Earth', 'Video' ]).name('Texture');
      gui.settings.ratioMagma = gui.folders.color.add(
        gui.options, 'ratioMagma', 0, 1).name('Invert');
      gui.settings.ratioSky = gui.folders.color.add(
        gui.options, 'ratioSky', 0, 1).name('Sky');
      gui.folders.color.open();

      gui.folders.raymarching = gui.dat.addFolder('Raymarching');
      // gui.settings.rayMax = gui.folders.raymarching.add(
      //   gui.options, 'rayMax', 0.1, 99.9).name('Ray far clip');
      gui.settings.rayEpsilon = gui.folders.raymarching.add(
        gui.options, 'rayEpsilon', 0.0000001, 0.001).name('Ray epsilon');
      gui.settings.rayCount = gui.folders.raymarching.add(
        gui.options, 'rayCount', 2, 100).step(1).name('Ray count');
      gui.folders.raymarching.open();
      // gui.dat.add(controls, 'enabled').name('Trackball controls').listen();
      // gui.dat.add(input.mouse, 'dragging').name('Mouse dragging').listen();
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
