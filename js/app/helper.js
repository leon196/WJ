define( ["three"], function( THREE ) { 
  var helper = new THREE.PerspectiveCamera( 70, 1, 1, 5000 );

  var front = new THREE.Vector3(0, 0, -1);
  var up = new THREE.Vector3(0, 1, 0);
  var right = new THREE.Vector3(1, 0, 0);

  helper.getFront = function ()
  {
  	return front.clone().applyQuaternion(helper.quaternion);
  }
  helper.getUp = function ()
  {
  	return up.clone().applyQuaternion(helper.quaternion);
  }
  helper.getRight = function ()
  {
  	return right.clone().applyQuaternion(helper.quaternion);
  }

  return helper;
} );
