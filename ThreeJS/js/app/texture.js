define( ["three", "container"], function ( THREE, container ) {
  var texturePath = "../img/";
  var texture = {
    texture1: THREE.ImageUtils.loadTexture( texturePath + "texture1.jpg" ),
    texture2: THREE.ImageUtils.loadTexture( texturePath + "texture2.jpg" ),
    earth: THREE.ImageUtils.loadTexture( texturePath + "earth2.png" ),
    earth3: THREE.ImageUtils.loadTexture( texturePath + "earth3.jpg" ),
    background: THREE.ImageUtils.loadTexture( texturePath + "background.png" ),
    fulldome: THREE.ImageUtils.loadTexture( texturePath + "fulldome.jpg" ),
    currentTarget: 0,
    renderTargets:
    [
      new THREE.WebGLRenderTarget( container.offsetWidth, container.offsetHeight, { minFilter: THREE.LinearFilter, magFilter: THREE.NearestFilter } ),
      new THREE.WebGLRenderTarget( container.offsetWidth, container.offsetHeight, { minFilter: THREE.LinearFilter, magFilter: THREE.NearestFilter } )
    ],

    nextTarget: function ()
    {
      texture.currentTarget = (texture.currentTarget + 1) % 2;
    },

    getCurrentTarget: function ()
    {
      return texture.renderTargets[texture.currentTarget];
    }
  };
  return texture;
} );
