-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Trove = require(ReplicatedStorage.Packages.Trove)
local Loader = require(ReplicatedStorage.Packages.Loader)
require(ReplicatedStorage.Modules.Util.TweenUtil)
local TableUtil = require(ReplicatedStorage.Modules.Util.TableUtil)
require(script.Internal.Types)
local LocalPlayer = game:GetService("Players").LocalPlayer
local CurrentCamera = workspace.CurrentCamera
local PlayerGui = LocalPlayer.PlayerGui
local ToolTip = PlayerGui:WaitForChild("ToolTip")
local v1 = Loader.LoadChildren(script.Styles)
local t = {}
local t2 = {}
t2.__index = t2
local function DestroyAll() --[[ DestroyAll | Line: 36 | Upvalues: t (copy) ]]
	for v1, v2 in t do
		v2:Destroy()
	end
	table.clear(t)
end
local function IsButtonAtTouchPosition(p1, p2) --[[ IsButtonAtTouchPosition | Line: 44 | Upvalues: UserInputService (copy), TableUtil (copy), PlayerGui (copy) ]]
	local v1 = if p2 then p2 else UserInputService:GetMouseLocation()
	local v2 = TableUtil.Filter(PlayerGui:GetGuiObjectsAtPosition(v1.X, v1.Y), function(p1) --[[ Line: 47 ]]
		return p1:IsA("GuiButton") or p1:IsA("ImageLabel")
	end)
	return if v2 then table.find(v2, p1) ~= nil else v2
end
t2.destroyAll = DestroyAll
function t2.observe(p1, p2, p3) --[[ observe | Line: 56 | Upvalues: t2 (copy) ]]
	local v1 = p1.InputBegan:Once(function() --[[ Line: 57 | Upvalues: p3 (copy), t2 (ref), p1 (copy), p2 (copy) ]]
		local v1 = p3()
		if v1 then
			t2._start(p1, v1, p2)
		end
	end)
	if p2 then
		p2:Add(function() --[[ Line: 67 | Upvalues: v1 (ref) ]]
			if v1 then
				v1:Disconnect()
			end
			v1 = nil
		end)
	else
		return function() --[[ Line: 75 | Upvalues: v1 (ref) ]]
			if v1 then
				v1:Disconnect()
			end
			v1 = nil
		end
	end
end
function t2.new(p1, p2, p3) --[[ new | Line: 85 | Upvalues: v1 (copy), t (copy), Trove (copy), t2 (copy), TableUtil (copy) ]]
	assert(p1:IsA("GuiObject"), "You must pass a GuiObject!")
	assert(p2.Style and v1[p2.Style], "You must select a valid Style!")
	for v3, v4 in t do
		v4:Destroy()
	end
	table.clear(t)
	local v5 = p3 and p3:Extend() or Trove.new()
	local v7 = setmetatable({
		RenderConn = nil,
		Adornee = p1,
		Style = p2.Style,
		CleanUp = v5,
		Instance = v1[p2.Style]:Create(p2, v5)
	}, t2)
	v7._ogTransparencyValues = {}
	for v8, v9 in TableUtil.Filter(TableUtil.Extend({ v7.Instance }, v7.Instance:GetDescendants()), function(p1) --[[ Line: 105 ]]
		return p1:IsA("GuiButton") or (p1:IsA("Frame") or (p1:IsA("ImageLabel") or (p1:IsA("TextSource") or p1:IsA("UIStroke"))))
	end) do
		local t4 = {}
		if v9:IsA("GuiObject") and v9.BackgroundTransparency < 1 then
			t4.BackgroundTransparency = v9.BackgroundTransparency
		end
		if v9:IsA("TextSource") and v9.TextTransparency < 1 then
			t4.TextTransparency = v9.TextTransparency
		end
		if v9:IsA("UIStroke") and v9.Transparency < 1 then
			t4.Transparency = v9.Transparency
		end
		if next(t4) then
			v7._ogTransparencyValues[v9] = t4
		end
	end
	table.insert(t, v7)
	return v7
end
function t2._start(p1, p2, p3) --[[ _start | Line: 188 | Upvalues: Trove (copy), t2 (copy), UserInputService (copy), IsButtonAtTouchPosition (copy), PlayerGui (copy) ]]
	local v2 = p3 and p3 or Trove.new()
	local v3 = true
	local v4 = nil
	local function New() --[[ New | Line: 194 | Upvalues: v3 (ref), v4 (ref), t2 (ref), p1 (copy), p2 (copy) ]]
		if not v3 then
			return
		end
		if not v4 then
			v4 = t2.new(p1, p2)
		end
		v4:Open()
	end
	local function Destroy() --[[ Destroy | Line: 208 | Upvalues: v4 (ref) ]]
		if not v4 then
			return
		end
		v4:Destroy()
		v4 = nil
	end
	task.defer(New)
	local v5 = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
	if v5 then
		local v6 = v2:Extend()
		local function mapToWorld(p12) --[[ mapToWorld | Line: 223 | Upvalues: v6 (copy), p1 (copy), v3 (ref), v4 (ref), t2 (ref), p2 (copy), IsButtonAtTouchPosition (ref), PlayerGui (ref), UserInputService (ref) ]]
			v6:Clean()
			if p12 then
				v6:Add(p1.InputBegan:Connect(function(p12) --[[ Line: 227 | Upvalues: v3 (ref), v4 (ref), t2 (ref), p1 (ref), p2 (ref) ]]
					if p12.UserInputState ~= Enum.UserInputState.Begin or p12.UserInputType ~= Enum.UserInputType.Touch then
						return
					end
					if not v3 then
						return
					end
					if not v4 then
						v4 = t2.new(p1, p2)
					end
					v4:Open()
				end))
				v6:Add(p1.InputChanged:Connect(function(p12) --[[ Line: 233 | Upvalues: IsButtonAtTouchPosition (ref), p1 (ref), v4 (ref), PlayerGui (ref), v3 (ref), t2 (ref), p2 (ref) ]]
					if p12.UserInputState ~= Enum.UserInputState.Change or p12.UserInputType ~= Enum.UserInputType.Touch then
						return
					end
					local v1 = IsButtonAtTouchPosition(p1, p12.Position)
					local v2 = v4 and v4.Instance and v4.Instance:IsDescendantOf(PlayerGui)
					if v1 or not v2 then
						if not v1 or v2 then
							return
						end
						if not v3 then
							return
						end
						if not v4 then
							v4 = t2.new(p1, p2)
						end
						v4:Open()
					elseif v4 then
						v4:Destroy()
						v4 = nil
					end
				end))
				v6:Add(UserInputService.InputEnded:Connect(function(p1, p2) --[[ Line: 246 | Upvalues: v4 (ref), PlayerGui (ref) ]]
					if p1.UserInputState ~= Enum.UserInputState.End or p1.UserInputType ~= Enum.UserInputType.Touch then
						return
					end
					if not (v4 and (v4.Instance and (v4.Instance:IsDescendantOf(PlayerGui) and v4))) then
						return
					end
					v4:Destroy()
					v4 = nil
				end))
			else
				v6:Add(UserInputService.InputBegan:Connect(function(p12, p22) --[[ Line: 254 | Upvalues: IsButtonAtTouchPosition (ref), p1 (ref), v3 (ref), v4 (ref), t2 (ref), p2 (ref) ]]
					if p12.UserInputState ~= Enum.UserInputState.Begin or p12.UserInputType ~= Enum.UserInputType.Touch then
						return
					end
					if not IsButtonAtTouchPosition(p1, p12.Position) then
						return
					end
					if not v3 then
						return
					end
					if not v4 then
						v4 = t2.new(p1, p2)
					end
					v4:Open()
				end))
				v6:Add(UserInputService.InputChanged:Connect(function(p12, p22) --[[ Line: 262 | Upvalues: IsButtonAtTouchPosition (ref), p1 (ref), v4 (ref), PlayerGui (ref), v3 (ref), t2 (ref), p2 (ref) ]]
					if p12.UserInputState ~= Enum.UserInputState.Change or p12.UserInputType ~= Enum.UserInputType.Touch then
						return
					end
					local v1 = IsButtonAtTouchPosition(p1, p12.Position)
					local v2 = v4 and v4.Instance and v4.Instance:IsDescendantOf(PlayerGui)
					if v1 or not v2 then
						if not v1 or v2 then
							return
						end
						if not v3 then
							return
						end
						if not v4 then
							v4 = t2.new(p1, p2)
						end
						v4:Open()
					elseif v4 then
						v4:Destroy()
						v4 = nil
					end
				end))
				v6:Add(UserInputService.InputEnded:Connect(function(p1, p2) --[[ Line: 275 | Upvalues: v4 (ref), PlayerGui (ref) ]]
					if p1.UserInputState ~= Enum.UserInputState.End or p1.UserInputType ~= Enum.UserInputType.Touch then
						return
					end
					if not (v4 and (v4.Instance and (v4.Instance:IsDescendantOf(PlayerGui) and v4))) then
						return
					end
					v4:Destroy()
					v4 = nil
				end))
			end
		end
		local v7 = p1:IsDescendantOf(workspace)
		mapToWorld(v7)
		if not v7 then
			local v8 = nil
			v8 = p1.AncestryChanged:Connect(function() --[[ Line: 290 | Upvalues: p1 (copy), v8 (ref), mapToWorld (copy) ]]
				if not p1:IsA(workspace) then
					return
				end
				v8:Disconnect()
				mapToWorld(true)
			end)
			v2:Add(function() --[[ Line: 297 | Upvalues: v8 (ref) ]]
				v8:Disconnect()
			end)
		end
	else
		v2:Add(p1.MouseEnter:Connect(New))
		v2:Add(p1.MouseLeave:Connect(Destroy))
	end
	return function() --[[ Line: 311 | Upvalues: v3 (ref), v2 (ref), v4 (ref) ]]
		v3 = false
		v2:Clean()
		if not v4 then
			return
		end
		v4:Destroy()
		v4 = nil
	end
end
function t2.Update(p1) --[[ Update | Line: 319 | Upvalues: CurrentCamera (copy), UserInputService (copy), GuiService (copy) ]]
	local v1 = UserInputService:GetMouseLocation()
	local v2 = GuiService:GetGuiInset()
	local AbsoluteSize = p1.Instance.AbsoluteSize
	local v6 = math.max(v1.Y - (AbsoluteSize.Y / 2 + v2.Y / 2 - 5), AbsoluteSize.Y / 2)
	local v7 = AbsoluteSize.X / 2
	p1.Instance.Position = UDim2.fromOffset(math.clamp(v1.X, v7, CurrentCamera.ViewportSize.X - v7), v6)
end
function t2.Open(p1) --[[ Open | Line: 334 | Upvalues: RunService (copy), ToolTip (copy) ]]
	if not p1.RenderConn or p1.RenderConn.Connected then
		p1.RenderConn = RunService.RenderStepped:Connect(function() --[[ Line: 336 | Upvalues: p1 (copy) ]]
			p1:Update()
		end)
		p1:Update()
	end
	if p1.Dead then
		return
	end
	p1.Instance.Parent = ToolTip
end
function t2.Close(p1) --[[ Close | Line: 352 ]]
	if not p1.RenderConn then
		return
	end
	p1.RenderConn:Disconnect()
end
function t2.Destroy(p1) --[[ Destroy | Line: 376 | Upvalues: t (copy) ]]
	p1.Dead = true
	local v1 = table.find(t, p1.CleanUp)
	if v1 then
		table.remove(t, v1)
	end
	if p1.RenderConn then
		p1.RenderConn:Disconnect()
	end
	pcall(function() --[[ Line: 388 | Upvalues: p1 (copy) ]]
		if not p1.Instance then
			return
		end
		p1.Instance:Destroy()
	end)
	p1.CleanUp:Clean()
end
return t2