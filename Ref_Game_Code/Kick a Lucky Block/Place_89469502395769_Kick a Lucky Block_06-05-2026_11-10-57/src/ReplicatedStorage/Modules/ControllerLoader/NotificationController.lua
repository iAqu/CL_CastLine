-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local NotificationStyles = require(ReplicatedStorage.Shared.Data.NotificationStyles)
local NotificationsUI = require(ReplicatedStorage.Modules.UILoader.NotificationsUI)
local t = {}
local v1 = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v2 = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 3)
function t.Create(p1, p2, p3) --[[ Create | Line: 18 | Upvalues: NotificationStyles (copy), NotificationsUI (copy), TweenService (copy), v1 (copy), v2 (copy) ]]
	local v12 = NotificationStyles.Styles[p2]
	if v12 then
		local Image = v12.Image
		if typeof(Image) == "function" then
			Image = Image(p3)
		end
		local Format = v12.Format
		local Sound = v12.Sound
		local v6 = NotificationsUI:Create(Image, if Format then Format(p3) else tostring(p3))
		v6:WaitForChild("UIScale").Scale = 0
		local WaveFrame = v6:WaitForChild("WaveFrame")
		WaveFrame.UIStroke.Transparency = 0.2
		WaveFrame.UIScale.Scale = 1
		WaveFrame.Visible = false
		local v7 = TweenService:Create(v6.UIScale, v1, {
			Scale = 1
		})
		local v8 = TweenService:Create(v6.UIScale, v1, {
			Scale = 0
		})
		local v9 = TweenService:Create(WaveFrame.UIStroke, v2, {
			Transparency = 1
		})
		local v10 = TweenService:Create(WaveFrame.UIScale, v2, {
			Scale = 1.5
		})
		v10:GetPropertyChangedSignal("PlaybackState"):Connect(function() --[[ Line: 52 | Upvalues: v10 (copy), WaveFrame (copy) ]]
			if v10.PlaybackState == Enum.PlaybackState.Playing then
				WaveFrame.Visible = true
			else
				WaveFrame.Visible = false
				v10:Destroy()
			end
		end)
		local t = {
			v7,
			{ v10, v9 },
			v8
		}
		local v11 = 0
		local function v122() --[[ UpdateSequence | Line: 64 | Upvalues: v11 (ref), t (copy), v122 (copy), v6 (copy) ]]
			v11 = v11 + 1
			if t[v11] then
				if typeof(t[v11]) == "table" then
					local v2 = t[v11][1]
					if v2 then
						v2.Completed:Once(function() --[[ Line: 74 | Upvalues: v122 (ref) ]]
							v122()
						end)
						for i, v in ipairs(t[v11]) do
							v:Play()
						end
					else
						v122()
					end
				elseif t[v11]:IsA("Tween") then
					t[v11].Completed:Once(function() --[[ Line: 83 | Upvalues: v122 (ref) ]]
						v122()
					end)
					t[v11]:Play()
				end
			else
				v6:Destroy()
			end
		end
		v122()
		if Sound then
			Sound:Play()
		end
	end
end
return t