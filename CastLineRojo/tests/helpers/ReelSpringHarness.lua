local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local Harness = {}

function Harness.new()
	local vector = {}
	local function vec(x, y, z)
		return setmetatable({ X = x, Y = y, Z = z }, vector)
	end
	vector.__index = function(value, key)
		if key == "Magnitude" then
			return math.sqrt(value.X ^ 2 + value.Y ^ 2 + value.Z ^ 2)
		end
		return vector[key]
	end
	vector.__add = function(a, b)
		return vec(a.X + b.X, a.Y + b.Y, a.Z + b.Z)
	end
	vector.__sub = function(a, b)
		return vec(a.X - b.X, a.Y - b.Y, a.Z - b.Z)
	end
	vector.__unm = function(a)
		return vec(-a.X, -a.Y, -a.Z)
	end
	vector.__mul = function(a, b)
		if type(a) == "number" then
			return b * a
		end
		if type(b) == "number" then
			return vec(a.X * b, a.Y * b, a.Z * b)
		end
		return vec(a.X * b.X, a.Y * b.Y, a.Z * b.Z)
	end
	vector.__div = function(a, b)
		return vec(a.X / b, a.Y / b, a.Z / b)
	end
	function vector:Lerp(other, alpha)
		return self + (other - self) * alpha
	end
	local function signal()
		local callbacks = {}
		return {
			Connect = function(_, callback)
				table.insert(callbacks, callback)
			end,
			Fire = function(_, dt)
				for _, callback in ipairs(callbacks) do
					callback(dt)
				end
			end,
		}
	end
	local runService = { PreSimulation = signal(), PostSimulation = signal() }
	local instances = {}
	local env = setmetatable({
		Vector3 = { new = vec, zero = vec(0, 0, 0), one = vec(1, 1, 1), yAxis = vec(0, 1, 0) },
		game = {
			GetService = function(_, name)
				return if name == "RunService" then runService else {}
			end,
		},
		typeof = function(value)
			if type(value) == "table" and value.isInstance then
				return "Instance"
			end
			if getmetatable(value) == vector then
				return "Vector3"
			end
			return typeof(value)
		end,
		Instance = {
			new = function(class)
				assert(class == "Vector3Value")
				local instance = { isInstance = true, Value = vec(0, 0, 0), writesAfterDestroy = 0 }
				function instance:IsA(name)
					return name == class
				end
				function instance:Destroy()
					self.destroyed = true
					-- Force later property writes through __newindex to detect leaked springs.
					self.lastValue, self.Value = self.Value, nil
				end
				setmetatable(instance, {
					__newindex = function(self, key, value)
						if self.destroyed and key == "Value" then
							self.writesAfterDestroy += 1
						end
						rawset(self, key, value)
					end,
				})
				table.insert(instances, instance)
				return instance
			end,
		},
	}, { __index = getfenv() })
	local config = assert(loadstring(read("src/ReplicatedStorage/Modules/FishingConfig.lua")))()
	local spr = assert(load(read("src/ReplicatedStorage/Libs/spr.lua"), "real spr", "t", env))()
	local modules = { FishingConfig = "config" }
	env.script = { Parent = modules }
	env.require = function(name)
		if name == "config" then
			return config
		end
		assert(name == "spr")
		return spr
	end
	local storage = { Libs = { spr = "spr" } }
	local originalService = env.game.GetService
	env.game.GetService = function(self, name)
		return if name == "ReplicatedStorage" then storage else originalService(self, name)
	end
	local Reel = assert(load(read("src/ReplicatedStorage/Modules/FishingReelSpring.lua"), "ReelSpring", "t", env))()
	return {
		Reel = Reel,
		config = config,
		env = env,
		vec = vec,
		instances = instances,
		step = function(dt)
			runService.PreSimulation:Fire(dt)
			runService.PostSimulation:Fire(dt)
		end,
		read = read,
	}
end

return Harness
