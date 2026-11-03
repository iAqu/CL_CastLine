-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local spr = require(ReplicatedStorage.Packages.spr)
local Replion = require(ReplicatedStorage.Packages.Replion)
local EventUtility = require(ReplicatedStorage.Shared.EventUtility)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local v1 = Replion.Client:WaitReplion("Events")
local Frame = Players.LocalPlayer.PlayerGui:WaitForChild("HUD"):WaitForChild("Frame"):WaitForChild("Frame")
local Inside = Frame:WaitForChild("Inside")
local ScrollingFrame = Inside:WaitForChild("ScrollingFrame")
local Template = script.Template
Template.Parent = nil
local t = {}
local v2 = false
local t2 = {}
local function destroyTile(p1) --[[ destroyTile | Line: 47 | Upvalues: t (copy) ]]
	if not p1.EventId then
		return
	end
	local v1 = t[p1.EventId]
	if not v1 then
		return
	end
	v1:Destroy()
	t[p1.EventId] = nil
end
local function toggle(p1) --[[ toggle | Line: 59 | Upvalues: spr (copy), Inside (copy) ]]
	local v1 = if p1 then {
	AnchorPoint = Vector2.new(1, 0)
} else {
	AnchorPoint = Vector2.new(0, 0)
}
	spr.stop(Inside)
	spr.target(Inside, 20, 200, v1)
end
function t2.Init(p1) --[[ Init | Line: 71 | Upvalues: GuiControl (copy), Inside (copy), v2 (ref), toggle (copy), EventUtility (copy), t (copy), Template (copy), ScrollingFrame (copy), Frame (copy), v1 (copy) ]]
	GuiControl:Hook("Hold Button", Inside.Toggle).Clicked:Connect(function() --[[ Line: 72 | Upvalues: v2 (ref), toggle (ref) ]]
		local v1 = not v2
		v2 = v1
		toggle(v1)
	end)
	local function renderTile(p1) --[[ renderTile | Line: 79 | Upvalues: EventUtility (ref), t (ref), Template (ref), ScrollingFrame (ref) ]]
		if not p1.EventId then
			return
		end
		local v1 = EventUtility:GetEvent(p1.EventId)
		if not v1 then
			return
		end
		if t[p1.EventId] then
			return
		end
		local v2 = Template:Clone()
		local Inside = v2.Inside
		Inside.Content.Bottom.Display.Header.Text = if v1.Name:find("Admin") then v1.Name:sub(9, #v1.Name) else v1.Name
		Inside.Content.Bottom.Description.Text = v1.GlobalDescription or v1.Description or "???"
		if v1.UseBirthdayColor then
			for v6, v7 in v2:GetDescendants() do
				if v7:IsA("UIGradient") then
					v7.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 85, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 170, 255)) })
				end
			end
			v2.Inside.Content.Top.Vector.ImageColor3 = Color3.fromRGB(255, 182, 193)
			v2.Inside.Content.Top.TextLabel.TextColor3 = Color3.fromRGB(255, 182, 193)
		end
		v2.Visible = true
		v2.LayoutOrder = -1000000 - string.len(v1.Name)
		v2.Parent = ScrollingFrame
		t[p1.EventId] = v2
	end
	local function update(p1, p2) --[[ update | Line: 126 | Upvalues: renderTile (copy), t (ref), Frame (ref) ]]
		for v1, v2 in p1 do
			renderTile(v2)
		end
		for v3, v4 in p2 do
			if p1[v3] == nil and v4.EventId then
				local v5 = t[v4.EventId]
				if v5 then
					v5:Destroy()
					t[v4.EventId] = nil
				end
			end
		end
		Frame.Visible = next(p1) ~= nil
	end
	v1:OnChange("AdminEvents", update)
	local v12 = v1:Get("AdminEvents")
	if not v12 then
		return
	end
	update(v12, {})
end
return t2