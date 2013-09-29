# Class.lua

Another class library for lua. This one has getters and setters.

### Syntax:

##### To add to your project, at the top of main.lua, put this:
```lua
require 'class' -- or whatever directory you put it in
```

##### This will (start to) implement a basic rectangle class:

```lua
rect = class()

rect.init = function(self, ...)
	local arg = {...}
	self.x = arg[1] or 0
	self.y = arg[2] or 0
	self.w = arg[3] or 0
	self.h = arg[4] or 0
end

rect.left = {
	get = function(self)
		return self.x - self.w / 2
	end,
	set = function(self, val)
		self.x = val + self.w / 2
		return self
	end
}

rect.right = {
	get = function(self)
		return self.x + self.w / 2
	end,
	set = function(self, val)
		self.x = val - self.w / 2
		return self
	end
}
```

##### Class methods are handled the same way as most other class libraries:

```lua
rect.move = function(dx, dy)
	self.x = self.x + dx
	self.y = self.y + dy
	return self
end
```

##### Inheritance (including multiple inheritance) is also supported:

```lua
quad = class()
... -- quad methods/properties here

aabb = class(rect, quad) -- make it inherit from rect and quad
                         -- rect comes before quad, so it gets more priority
... -- aabb methods/properties here
```

### About the Samples:

##### They show off features of the library. At the top of your program, put:

```lua
require 'class'
require <insert filename here>
...
```

### Licence:

Do whatever with it. There is no warranty. Just don't sue me if it doesn't work the way you expected.
