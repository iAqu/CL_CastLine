return function(sources)
	local color = {}
	color.__index = color
	local function rgb(r, g, b)
		return setmetatable({ R = r, G = g, B = b }, color)
	end
	function color:Lerp(other, alpha)
		return rgb(self.R + (other.R - self.R) * alpha, self.G + (other.G - self.G) * alpha,
			self.B + (other.B - self.B) * alpha)
	end
	local colors = {
		new = rgb,
		fromRGB = function(r, g, b) return rgb(r / 255, g / 255, b / 255) end,
		fromHex = function(hex)
			return rgb(tonumber(hex:sub(1, 2), 16) / 255, tonumber(hex:sub(3, 4), 16) / 255,
				tonumber(hex:sub(5, 6), 16) / 255)
		end,
	}
	local function sequence(points)
		return { Keypoints = points }
	end
	local function newInstance(className)
		local values = { Name = className, Enabled = true, Rotation = 0 }
		local children = {}
		local methods = {}
		function methods:IsA(class)
			return class == className or (class == "BasePart" and className == "Part")
		end
		function methods:GetChildren() return table.clone(children) end
		function methods:FindFirstChild(name)
			for _, child in ipairs(children) do
				if child.Name == name then return child end
			end
			return nil
		end
		function methods:Destroy() self.Parent = nil end
		function methods:Clone()
			local clone = newInstance(className)
			for key, value in pairs(values) do
				if key ~= "Parent" then clone[key] = value end
			end
			return clone
		end
		local instance
		instance = setmetatable({}, {
			__index = function(_, key)
				if key == "_children" then return children end
				return methods[key] or values[key]
			end,
			__newindex = function(_, key, value)
				if key == "Parent" then
					if values.Parent then
						local siblings = values.Parent._children
						table.remove(siblings, assert(table.find(siblings, instance)))
					end
					if value then table.insert(value._children, instance) end
				end
				values[key] = value
			end,
		})
		return instance
	end
	local storage = newInstance("Folder")
	local services = {
		ReplicatedStorage = storage,
		RunService = { IsClient = function() return false end },
		Players = {},
		Workspace = {},
	}
	local modules, cache = {}, {}
	for name in pairs(sources) do modules[name] = name end
	local env = setmetatable({
		Color3 = colors,
		ColorSequence = { new = sequence },
		ColorSequenceKeypoint = { new = function(time, value) return { Time = time, Value = value } end },
		Instance = { new = newInstance },
		game = { GetService = function(_, name) return assert(services[name]) end },
		script = { Parent = modules },
		warn = function(message) error("Unexpected warning: " .. tostring(message)) end,
	}, { __index = getfenv() })
	local function loadModule(name)
		if cache[name] then return cache[name] end
		local chunk = assert(loadstring(assert(sources[name]), name))
		setfenv(chunk, env)
		cache[name] = chunk()
		return cache[name]
	end
	env.require = loadModule
	return { load = loadModule, storage = storage, newInstance = newInstance, colors = colors, sequence = sequence }
end
