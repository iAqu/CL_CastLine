-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {}
t.__index = t
function t.new(p1) --[[ new | Line: 4 | Upvalues: t (copy) ]]
	local v2 = setmetatable({}, t)
	v2.Gui = script.Transition:Clone()
	v2.Gui.Parent = p1
	v2.Tweens = {
		In = game.TweenService:Create(v2.Gui.Fade, TweenInfo.new(0.4, Enum.EasingStyle.Linear), {
			BackgroundTransparency = 0
		}),
		Out = game.TweenService:Create(v2.Gui.Fade, TweenInfo.new(0.4, Enum.EasingStyle.Linear), {
			BackgroundTransparency = 1
		})
	}
	return v2
end
function t.Play(p1, p2, p3) --[[ Play | Line: 18 ]]
	local v1 = p1.Tweens[p2]
	if not v1 then
		return
	end
	v1:Play()
	if not p3 then
		return
	end
	v1.Completed:Wait()
end
function t.Destroy(p1) --[[ Destroy | Line: 31 ]]
	for v1, v2 in p1.Tweens do
		v2:Destroy()
	end
	p1.Gui:Destroy()
	table.clear(p1.Tweens)
end
return t