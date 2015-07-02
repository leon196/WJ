
define( ["three", "container", "renderer", "controls", "input", "screen", "material"], function ( THREE, container, renderer, controls, input, screen, material ) {

  var gui =
  {
    dat: new dat.GUI(),

    options:
    {
      pixelSize: 1,
      uDisplacementScale: 0.1,
      uPlanetRadius: 0.9,
      uRatioMagma: 0,
      uRatioSky: 1,
      rayCount: 64,
      rayEpsilon: 0.0001,
      rayMax: 10.1,
      uOffsetUV: 0,
      texture: '',
      uScaleUV: 1,
      uRepeat: 0
    },

    settings: {},

    folders: {},

    init: function ()
    {
      gui.settings.pixelSize = gui.dat.add(gui.options, 'pixelSize', 1, 4).name('Pixel size').step(1);

      gui.folders.transformation = gui.dat.addFolder('Transformation');
      gui.settings.uPlanetRadius = gui.folders.transformation.add(
        gui.options, 'uPlanetRadius', 0.1, 1).name('Planet radius');
      gui.settings.uDisplacementScale = gui.folders.transformation.add(
        gui.options, 'uDisplacementScale', -0.5, 0.5).name('Displacement scale');
      gui.settings.uScaleUV = gui.folders.transformation.add(
        gui.options, 'uScaleUV', 1, 8).name('UV scale');
      gui.settings.uOffsetUV = gui.folders.transformation.add(
        gui.options, 'uOffsetUV', 0, 2).name('UV offset');
      gui.folders.transformation.open();

      gui.folders.color = gui.dat.addFolder('Color');
      gui.settings.texture = gui.folders.color.add(
        gui.options, 'texture', [ 'Earth', 'Video', 'Fulldome' ]).name('Texture');
      gui.settings.uRatioMagma = gui.folders.color.add(
        gui.options, 'uRatioMagma', 0, 1).name('Invert');
      gui.settings.uRatioSky = gui.folders.color.add(
        gui.options, 'uRatioSky', 0, 1).name('Sky');
      gui.folders.color.open();

      gui.folders.raymarching = gui.dat.addFolder('Raymarching');
      // gui.settings.rayMax = gui.folders.raymarching.add(
      //   gui.options, 'rayMax', 0.1, 99.9).name('Ray far clip');
      gui.settings.rayEpsilon = gui.folders.raymarching.add(
        gui.options, 'rayEpsilon', 0.0000001, 0.001).name('Ray epsilon');
      gui.settings.rayCount = gui.folders.raymarching.add(
        gui.options, 'rayCount', 2, 100).step(1).name('Ray count');
      gui.settings.uRepeat = gui.folders.raymarching.add(
        gui.options, 'uRepeat', 0, 1).name('Repeat');
      gui.folders.raymarching.open();
      // gui.dat.add(controls, 'enabled').name('Trackball controls').listen();
      // gui.dat.add(input.mouse, 'dragging').name('Mouse dragging').listen();

      gui.dat.close();

      gui.settings.rayCount.onChange(function(value)
      {
        material.updateRaymarching(value, gui.options.rayEpsilon, gui.options.rayMax);
        screen.material = material.getRaymarchingShaderMaterial();
      });

      gui.settings.rayEpsilon.onChange(function(value)
      {
        material.updateRaymarching(gui.options.rayCount, value, gui.options.rayMax);
        screen.material = material.getRaymarchingShaderMaterial();
      });
    }
  }

  gui.init();

  return gui;
} );
