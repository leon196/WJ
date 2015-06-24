
define( ["three", "container"], function ( THREE, container ) 
{
	var input = 
	{
		mouse:
		{
			position: vec2(0, 0),
			pressed: false
		},

		init: function ()
		{
			document.addEventListener( 'mousemove', input.mousemove, false );
		},

		mousemove: function ( event ) 
		{
			event.preventDefault();
			event.stopPropagation();

			input.mouse.position = vec2(event.clientX, event.clientY);
		}
	};

	input.init();

	return input;

});