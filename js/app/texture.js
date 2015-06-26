define( ["three"], function ( THREE ) {
  var texturePath = "../img/";
  return {
    texture1: THREE.ImageUtils.loadTexture( texturePath + "texture1.jpg" ),
    texture2: THREE.ImageUtils.loadTexture( texturePath + "texture2.jpg" ),
    earth: THREE.ImageUtils.loadTexture( texturePath + "earth2.png" ),
    earth3: THREE.ImageUtils.loadTexture( texturePath + "earth3.jpg" ),
    background: THREE.ImageUtils.loadTexture( texturePath + "background.png" ),
    fulldome: THREE.ImageUtils.loadTexture( texturePath + "fulldome.jpg" )
  };
} );
