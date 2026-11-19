local function read(path)
	local f = assert(io.open(path))
	local s = f:read("*a")
	f:close()
	return s
end
local config = assert(loadstring(read("src/ReplicatedStorage/Modules/FishingConfig.lua")))()
local function object(class)
	local o = {
		ClassName = class,
		children = {},
		Parent = {},
		BackgroundTransparency = 0.2,
		TextTransparency = 0,
		TextStrokeTransparency = 1,
		ImageTransparency = 0,
		Transparency = 0,
		Scale = 1,
		Enabled = true,
		Visible = true,
	}
	function o:IsA(name)
		return name == class
			or (name == "GuiObject" and (class == "Frame" or class == "TextLabel" or class == "ImageLabel"))
	end
	function o:GetDescendants()
		local out = {}
		local function visit(p)
			for _, c in ipairs(p.children) do
				table.insert(out, c)
				visit(c)
			end
		end
		visit(self)
		return out
	end
	function o:FindFirstChildOfClass(name)
		for _, c in ipairs(self.children) do
			if c.ClassName == name then
				return c
			end
		end
		return nil
	end
	function o:Destroy()
		self.Parent = nil
	end
	return o
end
local workspace = { CurrentCamera = { ViewportSize = { X = 1920, Y = 1080 } } }
local enum = { EasingStyle = { Quad = "Quad", Back = "Back" }, EasingDirection = { Out = "Out" } }
local env = setmetatable({
	script = { Parent = { FishingConfig = config } },
	require = function(v)
		return v
	end,
	game = {
		GetService = function(_, name)
			if name == "Workspace" then
				return workspace
			end
			return {
				GetValue = function(_, v, style)
					if style == "Back" then
						local t = v - 1
						return 1 + 2.70158 * t * t * t + 1.70158 * t * t
					end
					return 1 - (1 - v) ^ 2
				end,
			}
		end,
	},
	Enum = enum,
	Instance = { new = object },
	Color3 = {
		fromRGB = function(r, g, b)
			return { r, g, b }
		end,
	},
	ColorSequence = {
		new = function(keys)
			return keys
		end,
	},
	ColorSequenceKeypoint = {
		new = function(time, color)
			return { Time = time, Value = color }
		end,
	},
	Vector2 = {
		new = function(x, y)
			return { X = x, Y = y }
		end,
	},
	UDim2 = {
		fromOffset = function(x, y)
			return { X = x, Y = y }
		end,
	},
}, { __index = getfenv() })
local feedback =
	assert(load(read("src/ReplicatedStorage/Modules/FishingCastFeedback.lua"), "FishingCastFeedback", "t", env))()
local H = { feedback = feedback, config = config, workspace = workspace }
function H.attach(owner, width, height, markerY)
	if owner.feedbackHarnessAttached then
		return owner
	end
	owner.feedbackHarnessAttached = true
	workspace.CurrentCamera.ViewportSize = { X = width or 1920, Y = height or 1080 }
	local w, h = workspace.CurrentCamera.ViewportSize.X, workspace.CurrentCamera.ViewportSize.Y
	local holder = object("Frame")
	holder.Visible = false
	local bar, marker, label, prompt = object("Frame"), object("Frame"), object("TextLabel"), object("TextLabel")
	bar.Visible, marker.Visible, prompt.Visible = false, false, false
	marker.AbsolutePosition = { X = w * 0.9, Y = markerY or h / 2 }
	marker.AbsoluteSize = { X = 32, Y = 12 }
	marker.Position = { X = 0.5, Y = 1 }
	holder.children = { bar, prompt }
	bar.children = { marker }
	marker.children = { label }
	local scale = object("UIScale")
	table.insert(holder.children, scale)
	local popup, stroke, popupScale = object("TextLabel"), object("UIStroke"), object("UIScale")
	popup.AbsoluteSize = { X = w * 0.2, Y = h * 0.07 }
	popup.Text = ""
	popup.children = { stroke, popupScale }
	popup.Visible = false
	owner.originals = owner.originals or {}
	owner.createdScales = owner.createdScales or {}
	owner.meter =
		{ holder = holder, gui = object("ScreenGui"), bar = bar, marker = marker, label = label, prompt = prompt }
	owner.popup, owner.popupStroke, owner.popupScale = popup, stroke, popupScale
	owner.folder = owner.folder or { SetAttribute = function() end }
	owner.castFeedback = feedback
	owner._save = owner._save
		or function(self, instance, props)
			for _, p in ipairs(props) do
				table.insert(self.originals, { instance = instance, property = p, value = instance[p] })
			end
		end
	owner._scale = owner._scale
		or function(self, target)
			local found = target:FindFirstChildOfClass("UIScale")
			if found then
				self:_save(found, { "Scale" })
				return found
			end
			found = object("UIScale")
			table.insert(target.children, found)
			table.insert(self.createdScales, found)
			return found
		end
	return owner
end
return H
