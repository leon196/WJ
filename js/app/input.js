
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
		keyboard:
		{
			left: new key(),
			up: new key(),
			right: new key(),
			down: new key(),
			space: new key(),
			r: new key(),
		},

		mouse:
		{
			position: vec2(0, 0),
			ratio: vec2(0, 0),
			wheel: 1,
			lastRatio: vec2(0, 0),
			pressed: false,
			dragging: false,
			velocity: vec3(0, 0, 0),
			offset: vec2(0, 0),
			button: 0,
			move: function (x, y)
			{
				input.mouse.position = vec2(x, y);
			},
			down: function ()
			{
				input.mouse.pressed = true;
				input.mouse.button = event.button;
				console.log('down')
			},
			up: function ()
			{
				input.mouse.pressed = false;
				input.mouse.velocity.x = input.mouse.position.x / container.offsetWidth - input.mouse.lastRatio.x;
				input.mouse.velocity.y = input.mouse.position.y / container.offsetHeight - input.mouse.lastRatio.y;
				input.mouse.velocity.z = input.mouse.velocity.y;
				input.mouse.button = -1;
				console.log('up')
			},
			out: function ()
			{
				if (input.mouse.pressed)
				{
					input.mouse.velocity.x = input.mouse.position.x / container.offsetWidth - input.mouse.lastRatio.x;
					input.mouse.velocity.y = input.mouse.position.y / container.offsetHeight - input.mouse.lastRatio.y;
					input.mouse.velocity.z = input.mouse.velocity.y;
					input.mouse.pressed = false;
					input.mouse.button = -1;
				}
				console.log('out')
			},
			update: function ()
			{
				var ratio = vec2(input.mouse.position.x / container.offsetWidth, input.mouse.position.y / container.offsetHeight);

				if (input.mouse.dragging || input.mouse.button == -1)
				{
					if (input.mouse.pressed)
					{
						console.log(input.mouse.button)
						if (input.mouse.button === 0)
						{
							input.mouse.ratio.x += (ratio.x - input.mouse.lastRatio.x) / input.mouse.wheel;
							input.mouse.ratio.y += (ratio.y - input.mouse.lastRatio.y) / input.mouse.wheel;
						}
						else if (input.mouse.button == 1)
						{
							input.mouse.wheel += ratio.y - input.mouse.lastRatio.y;
							input.mouse.wheel = clamp(input.mouse.wheel, -8, 8);
						}
						else
						{
							input.mouse.offset.x += (ratio.x - input.mouse.lastRatio.x) / input.mouse.wheel;
							input.mouse.offset.y += (ratio.y - input.mouse.lastRatio.y) / input.mouse.wheel;
						}
					}
					else
					{
						if (input.mouse.button == -1)
						{
							input.mouse.ratio.x += input.mouse.velocity.x;
							input.mouse.ratio.y += input.mouse.velocity.y;
							input.mouse.velocity.x *= 0.99;
							input.mouse.velocity.y *= 0.99;
							input.mouse.wheel += input.mouse.velocity.z;
							input.mouse.wheel = clamp(input.mouse.wheel, -8, 8);
							input.mouse.velocity.z *= 0.9;
						}
						else if (input.mouse.button == 1)
						{
							input.mouse.wheel += input.mouse.velocity.z;
							input.mouse.wheel = clamp(input.mouse.wheel, -8, 8);
							input.mouse.velocity.z *= 0.9;
						}
						else if (input.mouse.button == 0)
						{
							input.mouse.ratio.x += input.mouse.velocity.x;
							input.mouse.ratio.y += input.mouse.velocity.y;
							input.mouse.velocity.x *= 0.99;
							input.mouse.velocity.y *= 0.99;
						}
					}
				}

				input.mouse.lastRatio = vec2(ratio.x, ratio.y);

				if (input.keyboard.space.fired)
				{
					input.keyboard.space.fired = false;
					input.mouse.button = -1;
					input.mouse.velocity.x = 0.01 * (Math.random() * 2.0 - 1.0);
					input.mouse.velocity.y = 0.001 * (Math.random() * 2.0 - 1.0);
					input.mouse.velocity.z = 0.01 * (Math.random() * 2.0 - 1.0);
				}
			}
		},

		init: function ()
		{
			container.addEventListener( 'mousedown', input.mousedown, false );
			container.addEventListener( 'mousemove', input.mousemove, false );
			container.addEventListener( 'mouseup', input.mouseup, false );
			container.addEventListener( 'mouseout', input.mouseout, false );

			container.addEventListener( 'mousewheel', input.mousewheel, false );
			container.addEventListener( 'DOMMouseScroll', input.mousewheel, false ); // firefox

			window.addEventListener( 'keydown', input.keydown, false);
			window.addEventListener( 'keyup', input.keyup, false);
		},

		mousedown: function ( event ) 
		{
			input.mouse.down();
		},

		mousemove: function ( event ) 
		{
			input.mouse.move(event.clientX, event.clientY);
		},

		mouseup: function ( event ) 
		{
			input.mouse.up();
		},

		mouseout: function ( event ) 
		{
			input.mouse.out();
		},

		mousewheel: function ( event )
		{
			var delta = 0;
			if ( event.wheelDelta ) { // WebKit / Opera / Explorer 9
				delta = event.wheelDelta / 40;
			} else if ( event.detail ) { // Firefox
				delta = - event.detail / 3;
			}

			input.mouse.wheel += delta * 0.01;
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
				case 32: input.keyboard.space.down(); break;
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
				case 32: input.keyboard.space.up(); break;
				case 82: input.keyboard.r.up(); break;
			}
		}
	};

	input.init();

	return input;

});