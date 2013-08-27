function class(...)
	local m = {}
	local c = setmetatable({}, m)
	m.__index = m
	c.bases = {...}
	for _, base in ipairs(c.bases) do
		if type(base) == 'table' then
			for tag, val in pairs(base) do
				local newtag = tag
				while c[newtag] do
					newtag = newtag .. '_'
				end
				c[newtag] = val
			end
		end
	end
	function m:isinstance(obj)
		return getmetatable(obj) == self
	end
	function m:__call(...)
		local obj = setmetatable({}, c)
		if obj.init then obj:init(...) end
		return obj
	end
	function c.__index(obj, key)
		if type(rawget(c, key)) == 'function' then
			return rawget(c, key)
		elseif type(rawget(c, key)) == 'table' then
			if type(rawget(rawget(c, key), 'get')) == 'function' then
				return rawget(rawget(c, key), 'get')(obj)
			end
		end
		return rawget(obj, key)
	end
	function c.__newindex(obj, key, val)
		if type(rawget(c, key)) == 'table' then
			if type(rawget(rawget(c, key), 'set')) == 'function' then
				return rawget(rawget(c, key), 'set')(obj, val)
			end
		end
		return rawset(obj, key, val)
	end
	return c
end
