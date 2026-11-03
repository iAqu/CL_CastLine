-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local spr = require(ReplicatedStorage.Packages.spr)
local TableUtil = require(ReplicatedStorage.Modules.Util.TableUtil)
local t = {}
local function GetAllObjects(p1) --[[ GetAllObjects | Line: 18 | Upvalues: TableUtil (copy) ]]
	return TableUtil.Filter(TableUtil.Extend({ p1 }, p1:GetDescendants()), function(p1) --[[ Line: 19 ]]
		return p1:IsA("GuiButton") or (p1:IsA("Frame") or (p1:IsA("ImageLabel") or (p1:IsA("TextLabel") or p1:IsA("UIStroke"))))
	end)
end
function t.TweenAll(p1, p2, p3, p4) --[[ TweenAll | Line: 24 | Upvalues: GetAllObjects (copy), TweenService (copy) ]]
	local t = {}
	for v2, v3 in GetAllObjects(p1) do
		if (v3:IsA("GuiBase") or v3:IsA("UIStroke")) and not v3:HasTag("TweenIgnore") then
			local t2 = {}
			local v4 = v3:GetAttribute("ITransparency") or 0
			if p2 < v4 and p2 ~= 1 then
				p2 = v4
			end
			if v3:IsA("TextLabel") and v3.TextTransparency ~= p2 then
				t2.TextTransparency = p2
			end
			if v3:IsA("ImageLabel") and v3.ImageTransparency ~= p2 then
				t2.ImageTransparency = p2
			end
			if v3:IsA("UIStroke") and v3.Transparency ~= p2 then
				t2.Transparency = p2
			end
			table.insert(t, TweenService:Create(v3, p3, t2))
		end
	end
	for v6, v7 in t do
		v7:Play()
	end
	return t
end
function t.GetMap(p1) --[[ GetMap | Line: 63 | Upvalues: GetAllObjects (copy) ]]
	local t = {}
	for v1, v2 in GetAllObjects(p1) do
		local t2 = {}
		t2.TextTransparency = (v2:IsA("TextBox") or (v2:IsA("TextLabel") or v2:IsA("TextButton"))) and v2.TextTransparency or nil
		t2.ImageTransparency = (v2:IsA("ImageLabel") or v2:IsA("ImageButton")) and v2.ImageTransparency or nil
		t2.BackgroundTransparency = v2:IsA("GuiBase") and v2.BackgroundTransparency or nil
		t2.Transparency = v2:IsA("UIStroke") and v2.Transparency or nil
		t[v2] = t2
	end
	return t
end
function t.TweenAllToMap(p1, p2, p3, p4) --[[ TweenAllToMap | Line: 79 | Upvalues: GetAllObjects (copy), TweenService (copy) ]]
	local t = {}
	for v2, v3 in GetAllObjects(p1) do
		local t2 = {}
		local v4 = p2[v3]
		if v4 then
			t2.Transparency = v4.Transparency or nil
			t2.TextTransparency = v4.TextTransparency or nil
			t2.ImageTransparency = v4.ImageTransparency or nil
			t2.BackgroundTransparency = v4.BackgroundTransparency or nil
			table.insert(t, TweenService:Create(v3, p3, t2))
		end
	end
	for v6, v7 in t do
		v7:Play()
	end
	return t
end
function t.TweenOverFrames(p1, p2, p3) --[[ TweenOverFrames | Line: 107 | Upvalues: RunService (copy) ]]
	local v1 = tick()
	local t = {}
	local v2 = nil
	for v3, v4 in p3 do
		t[v3] = p1[v3]
	end
	local _ = RunService.PreRender:Connect(function() --[[ Line: 116 | Upvalues: v1 (copy), p2 (copy), p3 (copy), t (copy), v2 (ref), p1 (copy) ]]
		local v22 = math.ceil((tick() - v1) * 60)
		local v3 = (v22 - 1) / (p2 - 1)
		for v5, v6 in p3 do
			local v4
			local v7 = typeof(v6)
			local v8 = t[v5]
			if v7 == "number" then
				v4 = v8 + (v6 - v8) * v3
			else
				if v7 ~= "Vector3" and (v7 ~= "CFrame" and v7 ~= "Color3") then
					warn(("Unsupported type %q for %s"):format(v3, v5))
					v2:Disconnect()
					return
				end
				v4 = v8:Lerp(v6, v3)
			end
			p1[v5] = v4
		end
		if not (p2 <= v22) then
			return
		end
		v2:Disconnect()
	end)
end
function t.TweenNumber(p1, p2, p3, p4, p5, p6, p7) --[[ TweenNumber | Line: 148 | Upvalues: TweenService (copy) ]]
	local v2 = if p5 then p5 else TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local v3 = (p6 or true) and Instance.new("IntValue") or Instance.new("NumberValue")
	local function onChanged(p12) --[[ onChanged | Line: 154 | Upvalues: p1 (copy), p2 (copy) ]]
		p1.Text = string.format(p2, p12)
	end
	v3.Value = p3
	v3.Changed:Connect(onChanged)
	local v5 = TweenService:Create(v3, v2, {
		Value = p4
	})
	v5:Play()
	v5.Completed:Wait()
	if p7 then
		p7()
	end
	v5:Destroy()
	v3:Destroy()
end
function t.TweenModelSize(p1, p2, p3, p4, p5) --[[ TweenModelSize | Line: 173 | Upvalues: spr (copy), TweenService (copy) ]]
	if not p1:IsA("Model") then
		return
	end
	local v1 = Instance.new("NumberValue")
	local function onChanged(p12) --[[ onChanged | Line: 178 | Upvalues: p1 (copy) ]]
		p1:ScaleTo(p12)
	end
	v1.Value = p1:GetScale()
	v1.Changed:Connect(onChanged)
	if p3 then
		spr.target(v1, p4.ratio, p4.frequency, {
			Value = p2
		})
		spr.completed(v1, function() --[[ Line: 189 | Upvalues: p5 (copy), p1 (copy), v1 (copy) ]]
			if not p5 then
				v1:Destroy()
				return
			end
			p5(p1)
			v1:Destroy()
		end)
		return
	end
	local v2 = TweenService:Create(v1, p4, {
		Value = p2
	})
	v2:Play()
	v2.Completed:Wait()
	if p5 then
		p5(p1)
	end
	v2:Destroy()
	v1:Destroy()
end
function t.TweenModelCFrame(p1, p2, p3, p4, p5) --[[ TweenModelCFrame | Line: 213 | Upvalues: spr (copy), TweenService (copy) ]]
	local CFrameValue = Instance.new("CFrameValue")
	local function onChanged(p12) --[[ onChanged | Line: 216 | Upvalues: p1 (copy) ]]
		p1:PivotTo(p12)
	end
	CFrameValue.Value = p1:GetPivot()
	CFrameValue.Changed:Connect(onChanged)
	if p3 then
		spr.target(CFrameValue, p4.ratio, p4.frequency, {
			Value = p2
		})
		spr.completed(CFrameValue, function() --[[ Line: 227 | Upvalues: p5 (copy), p1 (copy), CFrameValue (copy) ]]
			if not p5 then
				CFrameValue:Destroy()
				return
			end
			p5(p1)
			CFrameValue:Destroy()
		end)
		return
	end
	local v1 = TweenService:Create(CFrameValue, p4, {
		Value = p2
	})
	v1:Play()
	v1.Completed:Wait()
	if p5 then
		p5(p1)
	end
	v1:Destroy()
	CFrameValue:Destroy()
end
function t.TweenModelTransparency(p1, p2, p3, p4) --[[ TweenModelTransparency | Line: 251 | Upvalues: TweenService (copy) ]]
	local v1 = Instance.new("NumberValue")
	if p1:IsA("Model") then
		for v2, v3 in p1:GetDescendants() do
			if v3:IsA("BasePart") or v3:IsA("Texture") then
				v1.Changed:Connect(function(p1) --[[ Line: 256 | Upvalues: v3 (copy) ]]
					v3.Transparency = p1
				end)
			end
		end
		v1.Value = p1.PrimaryPart.Transparency
	else
		v1.Value = p1.Transparency
		v1.Changed:Connect(function(p12) --[[ Line: 264 | Upvalues: p1 (copy) ]]
			p1.Transparency = p12
		end)
	end
	local v4 = TweenService:Create(v1, p3, {
		Value = p2
	})
	v4:Play()
	v4.Completed:Wait()
	v1:Destroy()
	if not p4 then
		return
	end
	p4()
end
function t.TweenPadding(p1, p2, p3, p4, p5) --[[ TweenPadding | Line: 279 | Upvalues: TweenService (copy) ]]
	local v1 = Instance.new("NumberValue")
	v1.Changed:Connect(function(p12) --[[ Line: 281 | Upvalues: p3 (copy), p1 (copy) ]]
		p1[("Padding%*"):format(p3)] = UDim.new(0, p12)
		p1[("Padding%*"):format(if p3 == "Left" then "Right" elseif p3 == "Right" then "Left" elseif p3 == "Top" then "Bottom" else "Top")] = UDim.new(0, -p12)
	end)
	local v2 = TweenService:Create(v1, p4, {
		Value = p2
	})
	v2:Play()
	v2.Completed:Wait()
	v1:Destroy()
	if not p5 then
		return
	end
	p5()
end
function t.MoveAlongCurve(p1, p2, p3, p4) --[[ MoveAlongCurve | Line: 302 | Upvalues: RunService (copy) ]]
	local v1 = tick()
	local v2 = nil
	v2 = RunService.Heartbeat:Connect(function() --[[ Line: 306 | Upvalues: v1 (copy), p3 (copy), p2 (copy), p1 (copy), v2 (ref), p4 (copy) ]]
		local v22 = math.min((tick() - v1) / p3, 1)
		local v3 = v22 * (#p2 - 1) + 1
		local v4 = math.floor(v3)
		local v7 = p2[v4]:Lerp(p2[math.min(v4 + 1, #p2)], v3 - v4)
		if p1:IsA("Model") then
			p1:PivotTo(v7)
		else
			p1.CFrame = v7
		end
		if not (v22 >= 1) then
			return
		end
		v2:Disconnect()
		if not p4 then
			return
		end
		p4(p1)
	end)
	return v2
end
return t