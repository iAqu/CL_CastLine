-- Studio Client：使用正式模块与预置圆环，验证颜色、时序、重复绑定和清理。
local storage = game:GetService("ReplicatedStorage")
local player = game:GetService("Players").LocalPlayer
local deadline = os.clock() + 15
while player:GetAttribute("ClientControllersReady") ~= true and os.clock() < deadline do
	task.wait(0.1)
end
assert(player:GetAttribute("ClientControllersReady") == true, "Wait for controller initialization before validation")
local playerGui = player:WaitForChild("PlayerGui")
local gui = assert(playerGui:FindFirstChild("FishingVignetteGui"), "FishingVignetteGui did not clone from StarterGui")
local Module = require(storage.Modules.FishingVignette)
local RarityConfig = require(storage.Modules.RarityConfig)
local Settings = require(storage.Modules.FishingConfig).Vignette
assert(not workspace:FindFirstChild("FishingRig"), "Finish the active fishing session before validation")
assert(gui.DisplayOrder == 139 and gui.ScreenInsets == Enum.ScreenInsets.None and not gui.ClipToDeviceSafeArea,
	"Vignette must cover the full screen underneath the fishing HUD")
local descendantCount = #gui:GetDescendants()
local active, owner
local function cleanup()
	if active then
		active:Destroy()
		active:Destroy()
	end
	if owner then
		for _, original in ipairs(owner.originals) do
			if original.instance.Parent then
				original.instance[original.property] = original.value
			end
		end
	end
	active, owner = nil, nil
	gui.Enabled = false
end

local ok, result = xpcall(function()
	local colors = 0
	for _, rarity in ipairs(RarityConfig.List) do
		owner = { originals = {} }
		function owner:_save(instance, properties)
			for _, property in ipairs(properties) do
				table.insert(self.originals, { instance = instance, property = property, value = instance[property] })
			end
		end
		active = Module.new(playerGui, owner)
		local bite = { fishConfig = { Rarity = rarity.Name }, timeline = { phase = "Waiting" } }
		active:Update(1, bite)
		assert(not gui.Enabled, "Do not reveal rarity while waiting")
		bite.timeline.phase = "Approaching"
		active:Update(2, bite)
		active:Update(2 + Settings.FadeIn / 2, bite)
		local stroke = active.rings[26].stroke
		assert(gui.Enabled and stroke.Transparency > 0.46 and stroke.Transparency < 1, "Missing fade in")
		active:Update(2 + Settings.FadeIn + 0.01, bite)
		assert(math.abs(stroke.Transparency - (1 - Settings.Strength * 0.6)) < 1e-6, "Incorrect peak strength")
		for _, ring in ipairs(active.rings) do
			assert(ring.stroke.Color == rarity.Color, "Ring did not use RarityConfig.Color")
			assert(not ring.frame.Active and not ring.frame.Interactable, "Vignette must not intercept input")
			assert(ring.frame.Size.X.Offset == ring.frame.Size.Y.Offset, "Ring must remain circular")
		end
		for _, phase in ipairs({ "Holding", "Nibbling", "Bite", "Struggling", "Lifting", "Caught", "Reeling" }) do
			bite.timeline.phase = phase
			active:Update(3, bite)
			assert(gui.Enabled and active.startedAt == nil, "Phase change restarted or hid the vignette")
		end
		bite.timeline.phase = if colors % 2 == 0 then "Escaped" else "Reeled"
		active:Update(4, bite)
		active:Update(4 + Settings.FadeOut / 2, bite)
		assert(gui.Enabled and stroke.Transparency > 0.46 and stroke.Transparency < 1, "Missing fade out")
		active:Update(4 + Settings.FadeOut + 0.01, bite)
		assert(not gui.Enabled and stroke.Transparency == 1, "Failure left a visible ring")
		-- 成功展示或外部中断均使用同一销毁入口，不等待额外动画。
		local caught = { fishConfig = { Rarity = rarity.Name }, timeline = { phase = "Caught" } }
		active:Update(5, caught)
		active:Update(6, caught)
		assert(gui.Enabled, "Caught showcase should keep the vignette")
		cleanup()
		assert(not gui.Enabled and #gui:GetDescendants() == descendantCount, "Cleanup removed or duplicated the preset")
		colors += 1
	end
	return { rarities = colors, ringCount = 26, presetDescendants = descendantCount, passed = true }
end, debug.traceback)
cleanup()
assert(ok, result)
return result
