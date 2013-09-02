local m = {}
m.__index = m
function m:isinstance(obj)
	if getmetatable(obj) == self then
		return true
	else
		for _, child in ipairs(self.__children) do
			if child:isinstance(obj) then
				return true
			end
		end
	end
	return false
end
function m:__call(...)
	local obj = setmetatable({}, self)
	if obj.init then obj:init(...) end
	return obj
end
function class(...)
	local c = setmetatable({}, m)
	rawset(c, '__bases', {...})
	rawset(c, '__children', {})
	for _, base in ipairs(c.__bases) do
		if type(base) == 'table' then
			for tag, val in pairs(base) do
				if tag ~= '__bases' and tag ~= '__children' then
					local newtag = tag
					while rawget(c, newtag) do
						newtag = newtag .. '_'
					end
					rawset(c, newtag, val)
				end
			end
			if type(rawget(base, '__children')) == 'table' then
				rawset(rawget(base, '__children'), #rawget(base, '__children') + 1, self)
			end
		end
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
		return rawget(rawset(obj, key, val), key)
	end
	return c
end
