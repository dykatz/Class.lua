-- Setup of local values and security features, caches global functions in case of a setfenv
local meta, none = {}, {__metatable = true, __newindex = function() return false end}
local _G, assert, setmetatable, getmetatable = _G, assert, setmetatable, getmetatable
local type, rawget, rawset, ipairs, pairs = type, rawget, rawset, ipairs, pairs
setmetatable(none, none)

-- Main function for creating classes: class name (optional, parents)
function class(name)
	-- Setup for the new class
	assert(type(name) == 'string', "Invalid arg to 'class': <string> expected")
	local class = {__children = {}, __name = name, static = {}}

	-- Allows for calling methods and getters
	function class:__index(key)
		if type(rawget(class, key)) == 'function' then
			return rawget(class, key)
		elseif type(rawget(class, key)) == 'table' and key ~= 'static' and key ~= '__children' and
			type(rawget(rawget(class, key), 'get')) == 'function' then
			return rawget(rawget(class, key), 'get')(self, key)
		else
			return rawget(self, key)
		end
	end

	-- Allows for calling setters
	function class:__newindex(key, val)
		if type(rawget(class, key)) == 'table' and key ~= 'static' and key ~= '__children' and
			type(rawget(rawget(class, key), 'set')) == 'function' then
			return rawget(rawget(class, key), 'set')(self, key, val)
		else
			return rawset(self, key, val)
		end
	end

	-- Adds the new class to the global table
	rawset(_G, name, setmetatable(class, meta))

	-- Returned function allows for the addition of parents
	return function(...)
		rawset(class, '__bases', {...})
		for _, base in ipairs(rawget(class, '__bases')) do
			if type(base) == 'table' then
				for key, val in pairs(base) do
					if tag ~= '__children' then
						local newkey = key

						while rawget(class, newkey) do
							newkey = newkey .. '_'
						end

						rawset(class, newkey, val)
					end
				end

				if type(rawget(base, '__children')) == 'table' then
					rawset(rawget(base, '__children'), #rawget(base, '__children') + 1, class)
				end
			end
		end
	end
end

-- Allows for creation of objects based on classes
function meta:__call(...)
	local obj = setmetatable({}, self)
	if obj.init then obj:init(...) end
	return obj
end

-- Allows for static methods and getters, as well as use of interclass static methods (stored in 'meta')
function meta:__index(key)
	if type(rawget(rawget(self, static), key)) == 'function' then
		return rawget(rawget(self, static), key)
	elseif type(rawget(rawget(self, static), key)) == 'table' and
		type(rawget(rawget(rawget(self, static), key), 'get')) == 'function' then
		return rawget(rawget(self, static), key)(self, key)
	else
		return rawget(meta, key)
	end
end

-- Allows for static setters, as well as protection for class-related tables
function meta:__newindex(key, val)
	if type(rawget(rawget(self, static), key)) == 'table' and type(val) ~= 'function' and
		type(val) ~= 'table' and type(rawget(rawget(rawget(self, static), key), 'set')) == 'function' then
		return rawget(rawget(rawget(self, static), key), 'set')(self, key, val)
	else
		if val ~= '__bases' and val ~= '__children' and val ~= 'static' then
			return rawset(self, key, val)
		end
	end
end

-- Can detect if an object is derived from a certain classes in a way that takes inheritance into account
function meta:isClassOf(obj)
	if getmetatable(obj) == self then
		return true
	else
		for _, child in ipairs(self.__children) do
			if child:isClassOf(obj) then
				return true
			end
		end
		return false
	end
end

-- Security features
setmetatable(meta, none)
rawset(meta, '__metatable', true)

-- Class commons support allows libraries that weren't designed to use this class system to function as classes
if class_commons ~= false then
	common = {}

	function common.class(name, t, par)
		class(name)(t, par)
		return _G[name]
	end

	function common.instance(klass, ...)
		return klass(...)
	end
end
