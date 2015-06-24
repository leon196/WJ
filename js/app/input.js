
define( ["three", "container"], function ( THREE, container ) 
{
	var key = function () 
	{
		this.fired = false;
		this.pressed = false;
		this.down = function ()
		{
			this.fired = !this.pressed;
			this.pressed = true;
		}
		this.up = function ()
		{
			this.fired = false;
			this.pressed = false;
		}
	};

	var input = 
	{
		mouse:
		{
			position: vec2(0, 0),
			ratio: vec2(0, 0),
			lastRatio: vec2(0, 0),
			pressed: false,
			dragging: false,
			update: function (x, y)
			{
				input.mouse.position = vec2(x, y);

				var ratio = vec2(x / window.innerWidth, y / window.innerHeight);

				if (input.mouse.pressed && input.mouse.dragging)
				{
					input.mouse.ratio.x += ratio.x - input.mouse.lastRatio.x;
					input.mouse.ratio.y += ratio.y - input.mouse.lastRatio.y;
				}

				input.mouse.lastRatio = vec2(ratio.x, ratio.y);
			},
			down: function ()
			{
				input.mouse.pressed = true;
			},
			up: function ()
			{
				input.mouse.pressed = false;
			}
		},

		keyboard:
		{
			left: new key(),
			up: new key(),
			right: new key(),
			down: new key(),
			r: new key()
		},

		init: function ()
		{
			container.addEventListener( 'mousedown', input.mousedown, false );
			container.addEventListener( 'mousemove', input.mousemove, false );
			container.addEventListener( 'mouseup', input.mouseup, false );
			window.addEventListener( 'keydown', input.keydown, false);
			window.addEventListener( 'keyup', input.keyup, false);
		},

		mousedown: function ( event ) 
		{
			input.mouse.down();
		},

		mousemove: function ( event ) 
		{
			input.mouse.update(event.clientX, event.clientY);
		},

		mouseup: function ( event ) 
		{
			input.mouse.up();
		},

		keydown: function (event)
		{
			console.log(event.keyCode);
			switch (event.keyCode)
			{
				case 37: input.keyboard.left.down(); break;
				case 38: input.keyboard.up.down(); break;
				case 39: input.keyboard.right.down(); break;
				case 40: input.keyboard.down.down(); break;
				case 82: input.keyboard.r.down(); break;
			}
		},

		keyup: function (event)
		{
			switch (event.keyCode)
			{
				case 37: input.keyboard.left.up(); break;
				case 38: input.keyboard.up.up(); break;
				case 39: input.keyboard.right.up(); break;
				case 40: input.keyboard.down.up(); break;
				case 82: input.keyboard.r.up(); break;
			}
		}
	};

	input.init();

	return input;

});