-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local TweenService = game:GetService("TweenService")
local t = {}
t.__index = t
function t.new(p1, p2) --[[ new | Line: 9 | Upvalues: t (copy) ]]
	if not p1.Parent then
		return
	end
	local v1 = script.Spinner:Clone()
	if p2 then
		v1.BackgroundTransparency = 1
	end
	v1.Position = p1.Position
	v1.AnchorPoint = p1.AnchorPoint
	v1.Size = p1.Size
	v1.Parent = p1.Parent
	return setmetatable({
		Source = p1,
		Spinner = v1,
		_start = os.clock(),
		_tweens = {}
	}, t)
end
function t.Init(p1) --[[ Init | Line: 34 | Upvalues: TweenService (copy) ]]
	local v1 = TweenService:Create(p1.Spinner.Vector, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1, false, 0), {
		Rotation = 360
	})
	table.insert(p1._tweens, v1)
	v1:Play()
end
function t.Destroy(p1) --[[ Destroy | Line: 43 | Upvalues: TweenService (copy) ]]
	local v1 = os.clock() - p1._start
	if v1 < 0.2 then
		task.wait(0.2 - v1)
	end
	local v2 = TweenService:Create(p1.Spinner.Vector, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
		ImageTransparency = 1
	})
	table.insert(p1._tweens, v2)
	v2:Play()
	v2.Completed:Wait()
	for i, v in ipairs(p1._tweens) do
		v:Cancel()
		v:Destroy()
	end
	table.clear(p1._tweens)
	p1.Spinner:Destroy()
	p1.Spinner = nil
end
return t