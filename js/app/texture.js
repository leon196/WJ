define( ["three"], function ( THREE ) {
  var texturePath = "../img/";
  return {
    texture1: THREE.ImageUtils.loadTexture( texturePath + "texture1.jpg" ),
    texture2: THREE.ImageUtils.loadTexture( texturePath + "texture2.jpg" ),
    earth: THREE.ImageUtils.loadTexture( texturePath + "earth2.png" )
  };
} );
