-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Replion = require(ReplicatedStorage.Packages.Replion)
local Observers = require(ReplicatedStorage.Packages.Observers)
local NumberSpinner = require(ReplicatedStorage.Packages.NumberSpinner)
local spr = require(ReplicatedStorage.Packages.spr)
local StringLibrary = require(ReplicatedStorage.Shared.StringLibrary)
local CurrencyUtility = require(ReplicatedStorage.Modules.CurrencyUtility)
local Currency = require(ReplicatedStorage.Modules.CurrencyUtility.Currency)
local t = {}
local t2 = {}
local t3 = {}
local function RenderChange(p1, p2) --[[ RenderChange | Line: 22 | Upvalues: spr (copy) ]]
	local FadeLabel = p1:FindFirstChild("FadeLabel")
	if FadeLabel then
		local Position = FadeLabel.Position
		local v1 = Position + UDim2.fromOffset(0, 10)
		local RBX_TEXT_EFFECT = FadeLabel:Clone()
		RBX_TEXT_EFFECT.Name = "RBX_TEXT_EFFECT"
		RBX_TEXT_EFFECT.Position = v1
		RBX_TEXT_EFFECT.Text = ("+%*"):format(p2)
		RBX_TEXT_EFFECT.Visible = true
		RBX_TEXT_EFFECT.Parent = p1
		spr.target(RBX_TEXT_EFFECT, 1, 1.5, {
			Position = Position
		})
		task.delay(0.4, function() --[[ Line: 44 | Upvalues: spr (ref), RBX_TEXT_EFFECT (copy) ]]
			spr.target(RBX_TEXT_EFFECT, 1, 3, {
				TextTransparency = 1,
				TextStrokeTransparency = 1
			})
			local UIStroke = RBX_TEXT_EFFECT:FindFirstChild("UIStroke")
			if UIStroke then
				spr.target(UIStroke, 1, 3, {
					Transparency = 1
				})
			end
			task.wait(0.6)
			if UIStroke then
				spr.stop(UIStroke)
			end
			spr.stop(RBX_TEXT_EFFECT)
			RBX_TEXT_EFFECT:Destroy()
		end)
	end
end
local function OnCurrencyChanged(p1, p2, p3) --[[ OnCurrencyChanged | Line: 67 | Upvalues: t (copy), t3 (copy), StringLibrary (copy), RenderChange (copy), t2 (copy) ]]
	t[p1] = p2
	local v1 = t3[p1]
	if v1 then
		local v2 = p2 - p3
		local v3, v4
		if p1 == "Tokens" then
			local v5 = StringLibrary:AddCommas(p2)
			v3, v4 = StringLibrary:AddCommas(v2), v5
		else
			local v7 = StringLibrary:Shorten(p2)
			v3, v4 = StringLibrary:Shorten(v2), v7
		end
		for i, v in ipairs(v1) do
			if v2 > 0 then
				task.spawn(RenderChange, v, v3)
			end
			v.Text = v4
		end
	end
	local v9 = t2[p1]
	if not v9 then
		return
	end
	for i, v in ipairs(v9) do
		v.Counter.Value = p2
	end
end
Observers.observeTag("CurrencyCounter", function(p1) --[[ Line: 101 | Upvalues: CurrencyUtility (copy), t (copy), t2 (copy), t3 (copy), NumberSpinner (copy), StringLibrary (copy) ]]
	local v1 = p1:GetAttribute("CurrencyType") or "Coins"
	if not CurrencyUtility:GetCurrency(v1) then
		return
	end
	local v2 = t[v1]
	if not v2 then
		t[v1] = 0
		v2 = t[v1]
	end
	local v3 = t2[v1]
	if not v3 then
		t2[v1] = {}
		v3 = t2[v1]
	end
	local v4 = t3[v1]
	if not v4 then
		t3[v1] = {}
		v4 = t3[v1]
	end
	if p1:HasTag("LiveUpdateCounter") then
		local v5 = p1:FindFirstChildWhichIsA("UIGradient")
		if v5 then
			p1.TextColor3 = v5.Color.Keypoints[1].Value
			v5:Destroy()
		end
		local v6 = NumberSpinner.fromGuiObject(p1)
		v6.Prefix = ""
		v6.Suffix = ""
		v6.Commas = true
		v6.Decimals = 0
		v6.Duration = 0.4
		v6.ZeroPadding = 0
		v6.Value = v2
		table.insert(v3, {
			Instance = p1,
			Counter = v6
		})
	else
		p1.Text = StringLibrary:Shorten(v2)
		table.insert(v4, p1)
	end
	return function() --[[ Line: 155 | Upvalues: p1 (copy), v3 (ref), v4 (ref) ]]
		if p1:HasTag("LiveUpdateCounter") then
			local v1 = nil
			for i, v in ipairs(v3) do
				if v.Instance == p1 then
					v1 = i
					break
				end
			end
			if v1 then
				table.remove(v3, v1)
			end
		else
			local v2 = table.find(v4, p1)
			if not v2 then
				return
			end
			table.remove(v4, v2)
		end
	end
end)
Replion.Client:AwaitReplion("Data", function(p1) --[[ Line: 177 | Upvalues: Currency (copy), OnCurrencyChanged (copy) ]]
	for v1, v2 in Currency do
		local v3 = p1:Get(v2.Path)
		if v3 then
			OnCurrencyChanged(v1, v3, 0)
		end
		p1:OnChange(v2.Path, function(p1, p2) --[[ Line: 184 | Upvalues: OnCurrencyChanged (ref), v1 (copy) ]]
			OnCurrencyChanged(v1, p1, p2)
		end)
	end
end)
return {}