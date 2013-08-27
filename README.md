# Class.lua

Another class library for lua. This one has getters and setters.

### Syntax:

This will (start) implement a basic rectangle class:

```lua
rect = class()

rect.init = function(...)
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

Class methods are handled the same way as most other class libraries:

```lua
rect.move = function(dx, dy)
	self.x = self.x + dx
	self.y = self.y + dy
	return self
end
```

Inheritance (including multiple inheritance) is also supported:

```lua
quad = class()
... -- quad methods/properties here

aabb = class(rect, quad) -- make it inherit from rect and quad, rect gets a higher priority
... -- aabb methods/properties here
```

### Licence:

Do whatever with it.
