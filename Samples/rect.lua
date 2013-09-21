rect = class()

rect.init = function(self, x, y, w, h)
	self.x = x or 0
	self.y = y or 0
	w = w or 32
	self.w = w/2
	h = h or w
	self.h = h/2
end

rect.left = {
	get = function(self)
		return self.x - self.w
	end,
	set = function(self, val)
		self.x = val + self.w
	end
}

rect.right = {
	get = function(self)
		return self.x + self.w
	end,
	set = function(self, val)
		self.x = val - self.w
	end
}

rect.top = {
	get = function(self)
		return self.y - self.h
	end,
	set = function(self, val)
		self.y = val + self.h
	end
}

rect.bottom = {
	get = function(self)
		return self.y + self.h
	end,
	set = function(self, val)
		self.y = val - self.h
	end
}

rect.width = {
	get = function(self)
		return self.w*2
	end,
	set = function(self, val)
		self.w = val/2
	end
}

rect.height = {
	get = function(self)
		return self.h*2
	end,
	set = function(self, val)
		self.h = val/2
	end
}

rect.resize = function(self, w, h)
	w = w or self.w
	h = h or self.h
	self.width = w
	self.height = h
end
