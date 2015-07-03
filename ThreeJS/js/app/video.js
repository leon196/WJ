define( ["three"], function ( THREE ) {

  var container = document.getElementById( 'video' );
  console.log(container);
  var texture = new THREE.VideoTexture( container );
  texture.minFilter = THREE.LinearFilter;
  texture.magFilter = THREE.LinearFilter;
  texture.format = THREE.RGBFormat;

  var video = {
    container: container,
    texture: texture
  };

  // container.pause();
  // container.currentTime = Math.random() * container.duration;
  // console.log(container);

  return video;

});