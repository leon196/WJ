define( ["renderer", "container"], function ( renderer, container ) 
{
  var screen =
  {
    getWidth: function()
    {
      return container.offsetWidth * renderer.getPixelRatio();
    },
    getHeight: function()
    {
      return container.offsetHeight * renderer.getPixelRatio();
    }
  };
  return screen;
} );
