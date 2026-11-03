-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui
local Net = require(ReplicatedStorage.Packages.Net)
local spr = require(ReplicatedStorage.Packages.spr)
local Signal = require(ReplicatedStorage.Packages.Signal)
require(ReplicatedStorage.Packages.Trove)
local StringLibrary = require(ReplicatedStorage.Shared.StringLibrary)
local ItemStringUtility = require(ReplicatedStorage.Modules.ItemStringUtility)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local CurrencyUtility = require(ReplicatedStorage.Modules.CurrencyUtility)
require(ReplicatedStorage.Types.Modifiers)
require(ReplicatedStorage.Shared.EventUtility)
local v1 = Net:RemoteEvent("TextNotification")
local v2 = PlayerGui:WaitForChild("Text Notifications")
local Frame = v2.Frame
local Tile = Frame.Tile
Tile.Parent = nil
local LocationTile = Frame.LocationTile
LocationTile.Parent = nil
local EventTile = Frame.EventTile
EventTile.Parent = nil
local IndexTile = Frame.IndexTile
IndexTile.Parent = nil
local TextTile = Frame.TextTile
TextTile.Parent = nil
local AdminTile = Frame.AdminTile
AdminTile.Parent = nil
local v3 = nil
local v4 = 0
local t = {}
local t2 = {}
local t3 = {
	NewlyIndexed = Signal.new()
}
local function formatChanceText(p1) --[[ formatChanceText | Line: 94 ]]
	if typeof(p1) ~= "number" then
		return nil
	end
	local v1 = math.round(p1 * 10) / 10
	if v1 == math.floor(v1) then
		return ("%*%%"):format(v1)
	else
		return string.format("%.1f%%", v1)
	end
end
local function getItemNotificationKey(p1, p2) --[[ getItemNotificationKey | Line: 107 ]]
	if p1.Currency then
		return ("Currency:%*"):format(p1.Currency)
	end
	if p1.ItemType and p1.ItemId then
		return ("Item:%*:%*"):format(p1.ItemType, p1.ItemId)
	else
		return nil
	end
end
local function setItemNotificationQuantity(p1, p2) --[[ setItemNotificationQuantity | Line: 119 | Upvalues: StringLibrary (copy) ]]
	local TextFrame = p1:FindFirstChild("TextFrame")
	local v1 = if TextFrame then TextFrame:FindFirstChild("VectorFrame") else TextFrame
	local v2 = if v1 then v1:FindFirstChild("Quantity") else v1
	if not (v2 and v2:IsA("TextLabel")) then
		return
	end
	if p2 > 1 then
		v2.Text = "x" .. StringLibrary:Shorten(p2)
		v2.Visible = true
	else
		v2.Visible = false
	end
end
local function setTextNotificationAmount(p1, p2, p3) --[[ setTextNotificationAmount | Line: 135 ]]
	local Header = p1:FindFirstChild("Header")
	if not (Header and Header:IsA("TextLabel")) then
		return
	end
	Header.Text = if p3 > 1 then ("%* [%*x]"):format(p2, p3) else p2
end
function t3.Init(p1) --[[ Init | Line: 144 | Upvalues: v1 (copy), v2 (copy) ]]
	v1.OnClientEvent:Connect(function(...) --[[ Line: 145 | Upvalues: p1 (copy) ]]
		p1:DeliverNotification(...)
	end)
	v2.Enabled = true
end
function t3.DeliverNotification(p1, p2) --[[ DeliverNotification | Line: 153 | Upvalues: v4 (ref), ItemUtility (copy), TierUtility (copy), ItemStringUtility (copy), CurrencyUtility (copy), t (copy), Frame (copy), setItemNotificationQuantity (copy), Tile (copy), AdminTile (copy), Soundbook (copy), t2 (copy), TextTile (copy), v3 (ref), ReplicatedStorage (copy), LocationTile (copy), EventTile (copy), IndexTile (copy), t3 (copy) ]]
	local v1 = v4 + 1
	v4 = v1
	local v2 = if p2.TextColor then Color3.fromRGB(p2.TextColor.R, p2.TextColor.G, p2.TextColor.B) else Color3.fromRGB(255, 255, 255)
	local v5 = 3
	local v6 = nil
	local v7 = p2.Quantity or 1
	local v8 = nil
	local v9 = nil
	local v10 = nil
	if p2.Type == "Item" then
		local v11 = nil
		local v12 = nil
		local v13 = nil
		local v14 = nil
		if p2.ItemId then
			local v15 = ItemUtility.GetItemDataFromItemType(p2.ItemType, p2.ItemId)
			if v15 then
				local v16 = nil
				if v15.Probability then
					v16 = TierUtility:GetTierFromRarity(v15.Probability.Chance)
				elseif v15.Data.Tier then
					v16 = TierUtility:GetTier(v15.Data.Tier)
				end
				if v16 then
					v12 = v16.TierColor
					if v16.Tier == 90 or (v16.Tier == 95 or (v16.Tier == 100 or v16.Tier == 100)) then
						v5 = v5 * 2.5
					end
				end
				v11 = if p2.InventoryItem then ItemStringUtility.GetItemName(p2.InventoryItem, v15) else v15.Data.Name
				local CrateChance = p2.CrateChance
				local v20
				if typeof(CrateChance) == "number" then
					local v21 = math.round(CrateChance * 10) / 10
					v20 = if v21 == math.floor(v21) then ("%*%%"):format(v21) else string.format("%.1f%%", v21)
				else
					v20 = nil
				end
				if v11 and v20 then
					v11 = ("%* (%*)"):format(v11, v20)
				end
				v14 = v15.Data.Type
				v13 = v15.Data.Icon or p2.Icon
			end
		elseif p2.Currency then
			local v26 = CurrencyUtility:GetCurrency(p2.Currency)
			if v26 then
				v11 = if math.floor(p2.Quantity) == 1 then v26.Singular else v26.Prefix
				v13 = v26.Icon
				v12 = v26.TextColor
				v14 = "Currency"
			end
		end
		local v27 = if p2.Currency then ("Currency:%*"):format(p2.Currency) elseif p2.ItemType and p2.ItemId then ("Item:%*:%*"):format(p2.ItemType, p2.ItemId) else nil
		local v30 = p2.Quantity or 1
		v6 = v27
		local v31 = if v27 then t[v27] else v27
		if v31 and v31.Tile:IsDescendantOf(Frame) then
			v31.Quantity = v31.Quantity + v30
			setItemNotificationQuantity(v31.Tile, v31.Quantity)
		elseif v31 then
			t[v27] = nil
		end
		local v32 = Tile:Clone()
		local v33 = if v12 then v12 else ColorSequence.new(v2)
		v32.TextFrame.Label.UIGradient.Color = v33
		v32.UIGradient.Color = v33
		if v14 == "Fishing Rods" then
			v32.TextFrame.VectorFrame.Vector.Size = UDim2.fromScale(2, 2)
		end
		v32.TextFrame.VectorFrame.Vector.Image = v13 or ""
		local v35
		if typeof(p2.Text) == "string" and #p2.Text > 0 then
			v35 = p2.Text
			v7 = v30
		else
			v7 = v30
			v35 = ""
		end
		v32.TextFrame.Label.Text = ("%* %*"):format(v35, v11 or "???")
		setItemNotificationQuantity(v32, v30)
		v10 = v32
	elseif p2.Type == "AdminText" then
		local v40 = ("rbxthumb://type=AvatarHeadShot&id=%*&w=100&h=100"):format(p2.AdminId or -1)
		local v41 = AdminTile:Clone()
		v41.VectorFrame.Vector.Image = v40
		v41.Header.Text = p2.Text or ""
		v41.Admin.Text = p2.AdminName or "ADMIN"
		local v42 = if p2.CustomSFX and Soundbook:HasSound(p2.CustomSFX) then Soundbook.Sounds[p2.CustomSFX]:Play() else Soundbook.Sounds.Notify
		if v42 then
			v42:Play()
		end
		v10 = v41
	elseif p2.Type == "Text" then
		local v44 = p2.Text or ""
		local v45 = t2[v44]
		if v45 and v45.Tile:IsDescendantOf(Frame) then
			v45.Amount = v45.Amount + 1
			local Text = v45.Text
			local Amount = v45.Amount
			local Header = v45.Tile:FindFirstChild("Header")
			if Header and Header:IsA("TextLabel") then
				Header.Text = if Amount > 1 then ("%* [%*x]"):format(Text, Amount) else Text
			end
		elseif v45 then
			t2[v44] = nil
		end
		v8 = v44
		local v48 = TextTile:Clone()
		v48.Header.TextColor3 = v2
		if v44:find("</b>") or v44:find("</font>") then
			local v49 = v44
			local v50 = v48.Header:FindFirstChildWhichIsA("UIStroke")
			if v50 then
				v50:Destroy()
			end
			if v49:find("</stroke>") == nil then
				v48.Header.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
				v48.Header.TextStrokeTransparency = 0
			end
			v48.Header.RichText = true
			v48.Header.Text = v49
		else
			local Header = v48:FindFirstChild("Header")
			if Header and Header:IsA("TextLabel") then
				Header.Text = v44
			end
		end
		v9 = v44
		local v51 = if p2.CustomSFX and Soundbook:HasSound(p2.CustomSFX) then Soundbook.Sounds[p2.CustomSFX]:Play() else Soundbook.Sounds.Notify
		if v51 then
			v51:Play()
		end
		v10 = v48
	elseif p2.Type == "Location" then
		local v53 = v3
		if v53 and v53:IsDescendantOf(Frame) then
			v53.Parent = ReplicatedStorage
		end
		local v55 = LocationTile:Clone()
		v55.Bottom.Header.TextColor3 = v2
		v55.Bottom.Header.Text = p2.Text or "???"
		v3 = v55
		v10 = v55
		v5 = 4
	elseif p2.Type == "Event" then
		local v56 = p2.Text or "???"
		local _, _2, _3 = v2:ToHSV()
		local v57 = v56:find("Admin -")
		local v58 = if v57 then v56:sub(8, #v56) else v56
		local v60 = EventTile:Clone()
		local v61 = v60.Frame:GetChildren()
		table.insert(v61, v60)
		for i, v in ipairs(v61) do
			v.BackgroundColor3 = v2
		end
		v60.TextFrame.Label.TextColor3 = v2
		v60.TextFrame.Label.Text = v58
		local v62 = if v57 then "WeatherAdmin" else "WeatherChime"
		local v63 = if v57 then 0.1 else 0.15
		if Soundbook:HasSound(v62) then
			Soundbook.Sounds[v62]:Play().PlaybackSpeed = 1 + math.random() * v63
		end
		v10 = v60
		v5 = 5
	elseif p2.Type == "Index" then
		local v64 = ColorSequence.new(Color3.fromRGB(112, 176, 255))
		local v65 = IndexTile:Clone()
		v65.TextFrame.Label.UIGradient.Color = v64
		v65.TextFrame.Label.Text = "New species found!"
		v10 = v65
	end
	if p2.CustomDuration then
		v5 = p2.CustomDuration
	end
	if v10 then
		t3:Tween(v10, v5, {
			autoPlay = true,
			destroyTile = true,
			waitForEnded = false,
			fadeIn = true
		})
		v10.LayoutOrder = -v1
		v10.Parent = Frame
		if p2.Type == "Item" and v6 then
			t[v6] = {
				Tile = v10,
				Quantity = v7
			}
			task.delay(v5 + 0.5, function() --[[ Line: 420 | Upvalues: t (ref), v6 (ref), v10 (ref) ]]
				local v1 = t[v6]
				if not v1 or v1.Tile ~= v10 then
					return
				end
				t[v6] = nil
			end)
		elseif p2.Type == "Text" and (v8 and v9) then
			t2[v8] = {
				Amount = 1,
				Tile = v10,
				Text = v9
			}
			task.delay(v5 + 0.5, function() --[[ Line: 433 | Upvalues: t2 (ref), v8 (ref), v10 (ref) ]]
				local v1 = t2[v8]
				if not v1 or v1.Tile ~= v10 then
					return
				end
				t2[v8] = nil
			end)
		end
	end
	if p2.Type == "Item" and p2._newlyIndexed then
		task.defer(t3.DeliverNotification, t3, {
			Type = "Index",
			ItemId = p2.ItemId,
			InventoryItem = p2.InventoryItem,
			Icon = p2.Icon,
			TextColor = p2.TextColor
		})
		t3.NewlyIndexed:Fire()
	end
end
function t3.FadeIn(p1, p2) --[[ FadeIn | Line: 459 | Upvalues: spr (copy) ]]
	local t = {
		BackgroundTransparency = {},
		TextStrokeTransparency = {},
		TextTransparency = {},
		ImageTransparency = {},
		Transparency = {}
	}
	local t2 = {}
	for i, v in ipairs(p2:GetDescendants()) do
		if v:IsA("Frame") and v.BackgroundTransparency < 1 then
			table.insert(t.BackgroundTransparency, v)
			continue
		end
		if v:IsA("TextLabel") and v.TextTransparency < 1 then
			table.insert(t.TextStrokeTransparency, v)
			table.insert(t.TextTransparency, v)
			continue
		end
		if v:IsA("UIStroke") and v.Transparency < 1 then
			table.insert(t.Transparency, v)
			continue
		end
		if v:IsA("ImageLabel") and v.ImageTransparency < 1 then
			table.insert(t.ImageTransparency, v)
		end
	end
	for v1, v2 in t do
		for i, v in ipairs(v2) do
			local v3 = v[v1]
			v[v1] = 1
			local function f4() --[[ Line: 497 | Upvalues: spr (ref), v (copy), v1 (copy), v3 (copy) ]]
				spr.target(v, 1, 3, {
					[v1] = v3
				})
			end
			table.insert(t2, f4)
		end
	end
	return function() --[[ Line: 505 | Upvalues: t2 (copy) ]]
		for i, v in ipairs(t2) do
			v()
		end
	end
end
function t3.Tween(p1, p2, p3, p4) --[[ Tween | Line: 512 | Upvalues: Signal (copy), spr (copy) ]]
	local v1 = p2:GetDescendants()
	table.insert(v1, p2)
	local t = {
		BackgroundTransparency = {},
		TextStrokeTransparency = {},
		TextTransparency = {},
		ImageTransparency = {},
		Transparency = {}
	}
	local tbl = {
		BackgroundTransparency = {},
		TextStrokeTransparency = {},
		TextTransparency = {},
		ImageTransparency = {},
		Transparency = {}
	}
	for i, v in ipairs(v1) do
		if v:IsA("Frame") and v.BackgroundTransparency < 1 then
			table.insert(t.BackgroundTransparency, v)
			tbl.BackgroundTransparency[v] = v.BackgroundTransparency
			continue
		end
		if v:IsA("TextLabel") and v.TextTransparency < 1 then
			table.insert(t.TextStrokeTransparency, v)
			tbl.TextStrokeTransparency[v] = v.TextStrokeTransparency
			table.insert(t.TextTransparency, v)
			tbl.TextTransparency[v] = v.TextTransparency
			continue
		end
		if v:IsA("UIStroke") and v.Transparency < 1 then
			table.insert(t.Transparency, v)
			tbl.Transparency[v] = v.Transparency
			continue
		end
		if v:IsA("ImageLabel") and v.ImageTransparency < 1 then
			table.insert(t.ImageTransparency, v)
			tbl.ImageTransparency[v] = v.ImageTransparency
		end
	end
	local v2 = Signal.new()
	if p4.fadeIn then
		for k, v in pairs(tbl) do
			for k2, v3 in pairs(v) do
				k2[k] = 1
				spr.target(k2, 1, 3, {
					[k] = v3
				})
			end
		end
	end
	local function autoPlay() --[[ autoPlay | Line: 577 | Upvalues: p3 (copy), t (copy), spr (ref), p4 (copy), p2 (copy), tbl (copy), v2 (copy) ]]
		task.delay(p3, function() --[[ Line: 578 | Upvalues: t (ref), spr (ref) ]]
			for v1, v2 in t do
				for i, v in ipairs(v2) do
					spr.target(v, 1, 3, {
						[v1] = 1
					})
				end
			end
		end)
		task.delay(p3 + 0.4, function() --[[ Line: 589 | Upvalues: t (ref), spr (ref), p4 (ref), p2 (ref), tbl (ref), v2 (ref) ]]
			for v1, v22 in t do
				for i, v in ipairs(v22) do
					spr.stop(v)
				end
			end
			if p4.destroyTile then
				p2:Destroy()
			end
			table.clear(t)
			table.clear(tbl)
			v2:Fire()
		end)
		if not p4.waitForEnded then
			return
		end
		v2:Wait()
	end
	if p4.autoPlay then
		autoPlay()
	end
	return autoPlay, v2
end
return t3