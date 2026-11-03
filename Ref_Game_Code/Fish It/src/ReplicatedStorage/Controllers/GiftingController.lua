-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Net = require(ReplicatedStorage.Packages.Net)
require(ReplicatedStorage.Packages.Replion)
local Trove = require(ReplicatedStorage.Packages.Trove)
local MarketplaceService = require(ReplicatedStorage.Packages.MarketplaceService)
require(ReplicatedStorage.Shared.GiftProducts)
local GamePassUtility = require(ReplicatedStorage.Shared.GamePassUtility)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local LocalPlayer = Players.LocalPlayer
local v1 = LocalPlayer.PlayerGui:WaitForChild("!!! Gifting")
local Background = v1.Main.Background
local v2 = Background.Content
local SearchBar = Background.Top.SearchBar
local ScrollingFrame = v2.ScrollingFrame
local Disclaimer = v2.Disclaimer
local Template = ScrollingFrame:WaitForChild("Template")
Template.Parent = nil
local v3 = Net:RemoteFunction("SetGiftReceiver")
local v4 = Net:RemoteFunction("RemoveGiftReceiver")
Net:RemoteFunction("CheckEligible")
local t = {}
local v5 = Trove.new()
local t2 = {
	SelectedUserId = nil,
	SelectedProductName = nil
}
function t2.Init(p1) --[[ Init | Line: 55 | Upvalues: GuiControl (copy), v1 (copy), t2 (copy), Background (copy) ]]
	GuiControl.GuiUnfocusedSignal:Connect(function(p1) --[[ Line: 56 | Upvalues: v1 (ref), t2 (ref) ]]
		if p1 ~= v1 then
			return
		end
		t2:Close()
	end)
	GuiControl:Hook("Hold Button", Background.Close).Clicked:Connect(function() --[[ Line: 62 | Upvalues: t2 (ref) ]]
		t2:Close()
	end)
end
function t2.Start(p1) --[[ Start | Line: 67 | Upvalues: SearchBar (copy), t2 (copy), Players (copy) ]]
	SearchBar.Label:GetPropertyChangedSignal("Text"):Connect(function() --[[ Line: 68 | Upvalues: SearchBar (ref), t2 (ref) ]]
		local Text = SearchBar.Label.Text
		if string.len(Text) > 0 then
			t2:RefreshSearch(Text)
		else
			t2:ClearSearch()
		end
	end)
	Players.PlayerAdded:Connect(t2._refreshPage)
	Players.PlayerRemoving:Connect(t2._refreshPage)
	t2._refreshPage()
end
function t2.RefreshSearch(p1, p2) --[[ RefreshSearch | Line: 82 | Upvalues: t (copy) ]]
	local v2 = p2:lower()
	for v3, v4 in t do
		local Key = v4.Key
		local v5 = if Key == v2 then true elseif Key:find(v2) == nil then false else true
		if v4.Tile then
			v4.Tile.Visible = v5
		end
	end
end
function t2.ClearSearch(p1) --[[ ClearSearch | Line: 95 | Upvalues: t (copy) ]]
	for v1, v2 in t do
		if v2.Tile then
			v2.Tile.Visible = true
		end
	end
end
function t2._refreshPage() --[[ _refreshPage | Line: 103 | Upvalues: Players (copy), ScrollingFrame (copy), Disclaimer (copy) ]]
	task.wait(0.1)
	local v1 = #Players:GetPlayers() - 1
	ScrollingFrame.Visible = v1 > 0
	Disclaimer.Visible = v1 == 0
end
function t2._destroyTile(p1) --[[ _destroyTile | Line: 111 | Upvalues: t (copy), v5 (copy) ]]
	local v1 = t[p1]
	if not v1 then
		return
	end
	v5:Remove(v1.Connection)
	v1.Tile:Destroy()
	t[p1] = nil
end
function t2._renderTile(p1) --[[ _renderTile | Line: 125 | Upvalues: LocalPlayer (copy), Template (copy), ScrollingFrame (copy), GuiControl (copy), t2 (copy), v5 (copy), t (copy) ]]
	if p1 ~= LocalPlayer then
		local v1 = Template:Clone()
		v1.PlayerName1.Text = p1.DisplayName
		v1.PlayerName2.Text = ("@%*"):format(p1.Name)
		v1.Pfp.Pfp.Image = ("rbxthumb://type=AvatarHeadShot&id=%*&w=100&h=100"):format(p1.UserId)
		v1.LayoutOrder = utf8.len(p1.DisplayName)
		v1.Parent = ScrollingFrame
		local v2 = GuiControl:Hook("Hold Button", v1.Gift).Clicked:Connect(function() --[[ Line: 137 | Upvalues: t2 (ref), p1 (copy) ]]
			t2:SetTarget(p1.UserId, t2.SelectedProductName)
		end)
		local v3 = GuiControl:Hook("Hold Button", v1).Clicked:Connect(function() --[[ Line: 141 | Upvalues: t2 (ref), p1 (copy) ]]
			t2:SetTarget(p1.UserId, t2.SelectedProductName)
		end)
		local v4 = v5:Add(function() --[[ Line: 145 | Upvalues: v3 (copy), v2 (copy), v1 (copy), t (ref), p1 (copy) ]]
			v3:Destroy()
			v2:Destroy()
			v1:Destroy()
			t[p1] = nil
		end)
		t[p1] = {
			Key = p1.DisplayName:lower(),
			Tile = v1,
			Connection = v4
		}
	end
end
function t2.DestroyTiles(p1) --[[ DestroyTiles | Line: 160 | Upvalues: t (copy), t2 (copy), v5 (copy) ]]
	for v1 in t do
		t2._destroyTile(v1)
	end
	v5:Clean()
end
function t2.RenderTiles(p1) --[[ RenderTiles | Line: 168 | Upvalues: t (copy), t2 (copy), v5 (copy), Players (copy) ]]
	if next(t) then
		t2:DestroyTiles()
	end
	v5:Add(Players.PlayerAdded:Connect(t2._renderTile))
	v5:Add(Players.PlayerRemoving:Connect(t2._destroyTile))
	for i, v in ipairs(Players:GetPlayers()) do
		t2._renderTile(v)
	end
end
function t2.Close(p1) --[[ Close | Line: 181 | Upvalues: t2 (copy), SearchBar (copy), v1 (copy) ]]
	t2:DestroyTiles()
	SearchBar.Label.Text = ""
	v1.Enabled = false
end
function t2.Open(p1, p2) --[[ Open | Line: 188 | Upvalues: t2 (copy), Background (copy), v1 (copy) ]]
	t2:RenderTiles()
	t2.SelectedProductName = p2
	Background.Display.Text = ("Gifting: %s"):format(p2)
	v1.Enabled = true
end
function t2.SetTarget(p1, p2, p3) --[[ SetTarget | Line: 197 | Upvalues: Players (copy), GamePassUtility (copy), v3 (copy), t2 (copy), MarketplaceService (copy), LocalPlayer (copy), TextNotificationController (copy) ]]
	if not p3 then
		return
	end
	if not Players:GetPlayerByUserId(p2) then
		return
	end
	local v1, v2 = GamePassUtility:GetGiftDataFromName(p3)
	if not v1 then
		return
	end
	local v32
	if v3:InvokeServer(p2, p3) then
		t2.SelectedUserId = p2
		t2.SelectedProductName = p3
		v32 = true
	else
		v32 = false
	end
	if v32 then
		xpcall(function() --[[ Line: 239 | Upvalues: MarketplaceService (ref), LocalPlayer (ref), v2 (copy) ]]
			MarketplaceService:PromptProductPurchase(LocalPlayer, v2)
		end, function(p1) --[[ Line: 241 ]]
			warn((("%*\n%*"):format(p1, (debug.traceback()))))
		end)
	else
		TextNotificationController:DeliverNotification({
			Type = "Text",
			Text = "Player already owns this!",
			CustomDuration = 5,
			TextColor = {
				R = 255,
				G = 0,
				B = 0
			}
		})
	end
end
function t2.RemoveTarget(p1) --[[ RemoveTarget | Line: 254 | Upvalues: v4 (copy), t2 (copy) ]]
	v4:InvokeServer()
	t2.SelectedUserId = nil
	t2.SelectedProductName = nil
end
return t2