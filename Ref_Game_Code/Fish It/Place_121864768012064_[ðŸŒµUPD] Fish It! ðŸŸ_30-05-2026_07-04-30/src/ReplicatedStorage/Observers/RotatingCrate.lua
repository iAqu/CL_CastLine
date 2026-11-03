-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Observers = require(ReplicatedStorage.Packages.Observers)
local function getOrderedGuiObjects(p1, p2) --[[ getOrderedGuiObjects | Line: 6 ]]
	local t = {}
	for v1, v2 in p1:GetChildren() do
		if p2(v2) then
			table.insert(t, v2)
		end
	end
	table.sort(t, function(p1, p2) --[[ Line: 13 ]]
		local LayoutOrder = p1.LayoutOrder
		local LayoutOrder_2 = p2.LayoutOrder
		if LayoutOrder == LayoutOrder_2 then
			local v2 = tonumber(p1.Name)
			local v4 = tonumber(p2.Name)
			if v2 and (v4 and v2 ~= v4) then
				return v2 < v4
			else
				return p1.Name < p2.Name
			end
		else
			return LayoutOrder < LayoutOrder_2
		end
	end)
	return t
end
local function updateDots(p1, p2, p3) --[[ updateDots | Line: 29 | Upvalues: getOrderedGuiObjects (copy) ]]
	local v1 = getOrderedGuiObjects(p2, function(p1) --[[ Line: 30 ]]
		return p1:IsA("GuiObject")
	end)
	local v2 = getOrderedGuiObjects(p1, function(p1) --[[ Line: 33 ]]
		return p1:IsA("GuiButton")
	end)
	local v3 = nil
	for v4, v5 in v1 do
		if v5 == p3 then
			v3 = v4
			break
		end
	end
	for v6, v7 in v2 do
		local v8 = 0.5
		if v3 and v6 == v3 or not v3 and v7.Name == p3.Name then
			v8 = 0
		end
		v7.BackgroundTransparency = v8
	end
end
Observers.observeTag("RotatingCrate", function(p1) --[[ Line: 56 | Upvalues: updateDots (copy), getOrderedGuiObjects (copy) ]]
	local Gui = p1:FindFirstChild("Gui")
	if not Gui then
		return
	end
	local Dots = Gui:FindFirstChild("Dots")
	local Options = Gui:FindFirstChild("Options")
	if not (Dots and Options) then
		return
	end
	local v1 = Options:FindFirstChildWhichIsA("UIPageLayout")
	if not v1 then
		return
	end
	v1.ScrollWheelInputEnabled = false
	v1.TouchInputEnabled = false
	local v2 = true
	local t = {}
	local v3 = os.clock()
	local function f4(p1) --[[ Line: 74 | Upvalues: updateDots (ref), Dots (copy), Options (copy), v3 (ref) ]]
		if p1 then
			updateDots(Dots, Options, p1)
			v3 = os.clock()
		end
	end
	table.insert(t, v1.Stopped:Connect(f4))
	for v5, v6 in Dots:GetChildren() do
		if v6:IsA("GuiButton") then
			local function f7() --[[ Line: 83 | Upvalues: getOrderedGuiObjects (ref), Dots (copy), v6 (copy), v3 (ref), v1 (copy) ]]
				for v12, v2 in getOrderedGuiObjects(Dots, function(p1) --[[ Line: 84 ]]
					return p1:IsA("GuiButton")
				end) do
					if v2 == v6 then
						v3 = os.clock()
						v1:JumpToIndex(v12 - 1)
						return
					end
				end
			end
			table.insert(t, v6.Activated:Connect(f7))
		end
	end
	task.spawn(function() --[[ Line: 97 | Upvalues: v2 (ref), v3 (ref), v1 (copy) ]]
		while v2 do
			local v12 = os.clock() - v3
			if v12 < 8 then
				task.wait((math.min(8 - v12, 0.2)))
				continue
			end
			v3 = os.clock()
			v1:Next()
		end
	end)
	return function() --[[ Line: 109 | Upvalues: v2 (ref), t (copy) ]]
		v2 = false
		for v1, v22 in t do
			v22:Disconnect()
		end
	end
end, { workspace })
return {}