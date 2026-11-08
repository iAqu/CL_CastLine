-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = require(ReplicatedStorage.Data.Assets)
local AssetEarnings = require(ReplicatedStorage.Shared.Util.AssetEarnings)
local AssetItems = require(ReplicatedStorage.Shared.Util.AssetItems)
local AssetRoster = require(ReplicatedStorage.Client.AssetRoster)
local BaseUpgrade = require(ReplicatedStorage.Client.BaseUpgrade)
local Bases = require(ReplicatedStorage.Data.Bases)
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)

require(ReplicatedStorage.Shared.Globals.Constants)

local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)
local GUI = require(ReplicatedStorage.Client.GUI)
local SwapGradient = require(ReplicatedStorage.Shared.Utils.SwapGradient)
local Hud = require(ReplicatedStorage.Client.Hud)
local GamepadBindings = require(ReplicatedStorage.Client.GamepadBindings)
local MenuNavigation = require(ReplicatedStorage.Client.MenuNavigation)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local PetPenCapacityGuidanceController = require(script.PetPenCapacityGuidanceController)
local PetMountFlags = require(ReplicatedStorage.Shared.Flags.PetMountFlags)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Save = require(ReplicatedStorage.Shared.Save)
local SlideDock = require(ReplicatedStorage.Client.UI.SlideDock)
local Trove = require(ReplicatedStorage.Packages.Trove)
local v1 = Color3.fromRGB(255, 70, 70)
local v2 = Color3.fromRGB(85, 255, 85)
local v3 = ColorSequence.new(Color3.fromRGB(214, 17, 17), Color3.fromRGB(253, 20, 20))
local v4 = Color3.fromRGB(72, 0, 0)
local v5 = Color3.fromRGB(255, 103, 103)

return {
    Start = function() -- Start | line: 101
        -- upvalues: Players (copy), GuiService (copy), Assets (copy), AssetEarnings (copy), AssetItems (copy), AssetRoster (copy), BaseUpgrade (copy), Bases (copy), ButtonFX (copy), Simple (copy), GUI (copy), SwapGradient (copy), Hud (copy), GamepadBindings (copy), MenuNavigation (copy), Toast (copy), PetPenCapacityGuidanceController (copy), PetMountFlags (copy), Remotes (copy), Save (copy), SlideDock (copy), Trove (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy)
        local function claimRowTemplate(p1) -- line: 104
            local child

            for _, child2 in p1:GetChildren() do
                if child2.Name == "Template" and child2:IsA("GuiObject") then
                    if child ~= nil then
                        child2:Destroy()
                    else
                        child = child2
                    end
                end
            end

            assert(child ~= nil, "ActivePets.Frame.ScrollingFrame has no Template row")

            return child
        end

        local function shadowFor(p2) -- line: 121
            local TextLabel = p2:FindFirstChild("TextLabel")

            if TextLabel == nil or not TextLabel:IsA("TextLabel") then
                return p2
            end

            return TextLabel
        end

        local LocalPlayer = Players.LocalPlayer
        local v7 = GUI.ActivePets()
        local Frame = v7.Frame
        local Title = Frame.Header.Title
        local TextLabel = Title:FindFirstChild("TextLabel")

        if TextLabel == nil or not TextLabel:IsA("TextLabel") then
            TextLabel = Title
        end

        local PlusEquip = Frame.Header.PlusEquip
        local TextLabel2 = PlusEquip:FindFirstChild("TextLabel")
        local ScrollingFrame = Frame.ScrollingFrame
        local EmptyLast = ScrollingFrame:FindFirstChild("EmptyLast")
        local v8 = claimRowTemplate(ScrollingFrame)
        local Close, EquipBest = Frame.Close, Frame.EquipBest
        local PetsButton = Hud.Every("PetsButton")
        local UIGradient = PlusEquip:FindFirstChildOfClass("UIGradient")
        local UIStroke = PlusEquip:FindFirstChild("UIStroke")
        local UIStrokeClr = PlusEquip:FindFirstChild("UIStrokeClr")
        local Color = if UIGradient == nil then nil else UIGradient.Color
        local Color2 = if UIStroke == nil then nil else UIStroke.Color
        local Color4 = if UIStrokeClr == nil then nil else UIStrokeClr.Color
        local t2 = {}
        local t3 = {}
        local n1 = 0
        local v9 = false
        local n2 = 0
        local v10 = false
        local ButtonsHolder = v8.Spacer.ButtonsHolder
        local UIListLayout = ButtonsHolder:FindFirstChildOfClass("UIListLayout")
        local Size = ButtonsHolder.Unequip.Size
        local Size2 = ButtonsHolder.Ride.Size
        local TextLabel3 = ButtonsHolder.Ride:FindFirstChild("TextLabel")
        local Label = ButtonsHolder.Unequip:FindFirstChild("Label")
        local Size3 = if TextLabel3 == nil or not TextLabel3:IsA("GuiObject") then nil else TextLabel3.Size

        TextLabel3 = if Label == nil or not Label:IsA("GuiObject") then Size3 else Label.Size
        Label = if UIListLayout ~= nil then UIListLayout.Padding else UDim.new(0, 0)

        local v11 = UDim2.new(UDim.new(Size.X.Scale * 0.87, Size.X.Offset * 0.87), UDim.new((Size.Y.Scale + Label.Scale + Size2.Y.Scale) * 0.65, (Size.Y.Offset + Label.Offset + Size2.Y.Offset) * 0.65))

        assert(v7:IsA("ScreenGui"), "PlayerGui.ActivePets must be a ScreenGui")
        assert(Frame:IsA("GuiObject"), "ActivePets.Frame must be a GuiObject")
        assert(Title:IsA("TextLabel"), "ActivePets.Frame.Header.Title must be a TextLabel")
        assert(PlusEquip:IsA("GuiButton"), "ActivePets.Frame.Header.PlusEquip must be a GuiButton")

        local ScreenGui = TextLabel2 ~= nil and TextLabel2:IsA("TextLabel")

        assert(ScreenGui, "ActivePets.Frame.Header.PlusEquip.TextLabel must be a TextLabel")
        assert(ScrollingFrame:IsA("ScrollingFrame"), "ActivePets.Frame.ScrollingFrame must be a ScrollingFrame")
        assert(Close:IsA("GuiButton"), "ActivePets.Frame.Close must be a GuiButton")
        assert(EquipBest:IsA("GuiButton"), "ActivePets.Frame.EquipBest must be a GuiButton")
        assert(#PetsButton > 0, "the HUD has no PetsButton to open ActivePets with")
        assert(ButtonsHolder.Ride:IsA("GuiButton"), "ActivePets row ButtonsHolder.Ride must be a GuiButton")
        assert(ButtonsHolder.Unequip:IsA("GuiButton"), "ActivePets row ButtonsHolder.Unequip must be a GuiButton")

        local TextLabel4 = TextLabel2:FindFirstChild("TextLabel")

        if TextLabel4 == nil or not TextLabel4:IsA("TextLabel") then
            TextLabel4 = TextLabel2
        end

        v7.ResetOnSpawn = false
        PlusEquip.AutoButtonColor = false
        GamepadBindings.TrackCloseButton(Close)

        local v12 = SlideDock.new(v7, Frame, SlideDock.EscortFramesOf(PetsButton))

        local function setOpen(p3, p4) -- line: 204
            -- upvalues: v12 (copy)
            v12:SetOpen(p3, p4)
        end

        local function getCapacity(p5) -- line: 208
            -- upvalues: Bases (copy)
            return Bases.GetAssetEquipCapacity(if p5 == nil then nil else p5.BaseUpgradeLevel)
        end

        local function setTextWithShadow(p6, p7, p8) -- line: 212
            p6.Text = p8
            p7.Text = p8
        end

        local function formatDisplayNameWithRate(p9) -- line: 217
            -- upvalues: Simple (copy)
            return p9.DisplayName .. " ($" .. Simple.FormatCompact(p9.Rate, ".#") .. "/s)"
        end

        local function ownsButtonSelection() -- line: 221
            -- upvalues: v7 (copy), Frame (copy), MenuNavigation (copy)
            return v7.Enabled and Frame.Visible and not MenuNavigation.IsSuspended() and not MenuNavigation.IsCursorActive()
        end

        local function keepRowVisible(p10) -- line: 226
            -- upvalues: v7 (copy), Frame (copy), ScrollingFrame (copy), GuiService (copy), MenuNavigation (copy)
            if not v7.Enabled or not Frame.Visible or MenuNavigation.IsSuspended() or MenuNavigation.IsCursorActive() or GuiService.SelectedObject ~= p10 then
                return
            end

            local v13 = p10.AbsolutePosition.Y - ScrollingFrame.AbsolutePosition.Y
            local v14 = v13 + p10.AbsoluteSize.Y
            local Y = ScrollingFrame.AbsoluteWindowSize.Y

            if not (v13 < 0) then
                v13 = if Y < v14 then v14 - Y else 0
            end

            if v13 == 0 then
                return
            end

            local CanvasPosition = ScrollingFrame.CanvasPosition
            local v16 = math.max(0, ScrollingFrame.AbsoluteCanvasSize.Y - Y)

            ScrollingFrame.CanvasPosition = Vector2.new(CanvasPosition.X, (math.clamp(CanvasPosition.Y + v13, 0, v16)))
        end

        local function ridingUID() -- line: 239
            -- upvalues: LocalPlayer (copy)
            local Character = LocalPlayer.Character
            local PetMountSession = if Character == nil then nil else Character:FindFirstChild("PetMountSession")
            local UID = if PetMountSession == nil then nil else PetMountSession:GetAttribute("UID")

            return if typeof(UID) == "string" then UID else nil
        end

        local function orderedButtons() -- line: 246
            -- upvalues: t3 (ref)
            local t4 = {}

            for _, v18 in t3 do
                if v18.CanRide then
                    table.insert(t4, v18.Ride)
                end

                table.insert(t4, v18.Unequip)
            end

            return t4
        end

        local function updateNavigation() -- line: 257
            -- upvalues: PlusEquip (copy), Close (copy), EquipBest (copy), orderedButtons (copy)
            local v19 = if PlusEquip.Active then PlusEquip else Close
            local v20 = orderedButtons()
            local v21 = if #v20 > 0 then v20[1] else EquipBest
            local v22 = if #v20 > 0 then v20[#v20] else v19

            PlusEquip.NextSelectionUp = Close
            PlusEquip.NextSelectionDown = v21
            PlusEquip.NextSelectionLeft = PlusEquip
            PlusEquip.NextSelectionRight = Close
            Close.NextSelectionUp = Close
            Close.NextSelectionDown = v21
            Close.NextSelectionLeft = v19
            Close.NextSelectionRight = Close
            EquipBest.NextSelectionUp = v22
            EquipBest.NextSelectionDown = Close
            EquipBest.NextSelectionLeft = EquipBest
            EquipBest.NextSelectionRight = Close

            for v23, v24 in v20 do
                v24:SetAttribute("DefaultFocus", v23 == 1)

                if v23 == 1 then
                    v24.NextSelectionUp = v19
                else
                    v24.NextSelectionUp = v20[v23 - 1]
                end

                if v23 == #v20 then
                    v24.NextSelectionDown = EquipBest
                else
                    v24.NextSelectionDown = v20[v23 + 1]
                end

                v24.NextSelectionLeft = v24
                v24.NextSelectionRight = Close
            end

            EquipBest:SetAttribute("DefaultFocus", #v20 == 0)
        end

        local function updateHeader(p11, p12) -- line: 285
            -- upvalues: v7 (copy), Frame (copy), Title (copy), TextLabel (ref), PlusEquip (copy), TextLabel2 (copy), EquipBest (copy), UIGradient (copy), UIStroke (copy), UIStrokeClr (copy), t3 (ref), TextLabel4 (ref), updateNavigation (copy), Color (copy), Color2 (copy), Color4 (copy), GuiService (copy), BaseUpgrade (copy), Bases (copy), Simple (copy), MenuNavigation (copy), v3 (copy), v4 (copy), v5 (copy)
            local v25 = ("%*/%* Active"):format(p12, (Bases.GetAssetEquipCapacity(if p11 == nil then nil else p11.BaseUpgradeLevel)))

            Title.Text = v25
            TextLabel.Text = v25

            local Cost

            if p11 ~= nil then
                local _, v26 = BaseUpgrade.ResolveNextTier(p11)

                if v26 ~= nil then
                    Cost = v26.Cost
                end
            end

            local v27 = if Cost == nil then "MAX EQUIP" else ("+1 EQUIP [$%*]"):format((Simple.FormatCompact(math.floor(Cost), ".#")))

            TextLabel2.Text = v27
            TextLabel4.Text = v27

            if Cost == nil and GuiService.SelectedObject == PlusEquip and v7.Enabled and Frame.Visible and not MenuNavigation.IsSuspended() and not MenuNavigation.IsCursorActive() then
                GuiService.SelectedObject = if #t3 > 0 then t3[1].Button else EquipBest
            end

            PlusEquip.Active = Cost ~= nil

            local v29 = Cost ~= nil and p11 ~= nil and Cost <= p11.Money
            local v30 = Cost ~= nil and not v29

            if UIGradient ~= nil then
                UIGradient.Color = if v30 then v3 else Color
            end

            if UIStroke ~= nil then
                UIStroke.Color = if v30 then v4 else Color2
            end

            if UIStrokeClr ~= nil then
                UIStrokeClr.Color = if v30 then v5 else Color4
            end

            updateNavigation()
        end

        local function compareEntries(p13, p14) -- line: 325
            if p13.Rank ~= p14.Rank then
                return p13.Rank > p14.Rank
            end

            if p13.Rate == p14.Rate then
                return p13.UID < p14.UID
            end

            return p13.Rate > p14.Rate
        end

        local function buildEntries(p15) -- line: 335
            -- upvalues: compareEntries (copy), Players (copy), Assets (copy), AssetEarnings (copy), AssetItems (copy)
            if p15 == nil then
                return {}
            end

            local t5 = {}

            for _, v34 in ipairs(p15.EquippedAssets) do
                local v35 = p15.Inventory[v34]

                if v35 ~= nil then
                    local v36 = AssetItems.Decode(v35)
                    local v37 = Assets.Directory[v36.Category]
                    local Rarity = v37.Rarity

                    table.insert(t5, {
                        UID = v34,
                        DisplayName = if v37.DisplayName == "" then v36.Category else v37.DisplayName,
                        Icon = v37.Icon,
                        Rate = AssetEarnings.LiveRatePerSecond(v36, p15.Gamepasses, p15.Products, Players.LocalPlayer),
                        Rank = Rarity.Rank,
                        RarityGradient = Rarity.RarityGradient,
                        Rideable = v36.Rideable == true
                    })
                end
            end

            table.sort(t5, compareEntries)

            return t5
        end

        local function requestUnequip(p16) -- line: 370
            -- upvalues: AssetRoster (copy), Toast (copy), v1 (copy)
            local v38, v39 = AssetRoster.DoffAsset(p16)

            if not v38 and v39 ~= nil then
                Toast.Show({
                    Seconds = 2,
                    Text = v39,
                    Color = v1
                })
            end
        end

        local function requestRide(p17) -- line: 381
            -- upvalues: LocalPlayer (copy), v10 (ref), v12 (copy), Toast (copy), Remotes (copy), v1 (copy)
            if v10 then
                return
            end

            v10 = true

            local Character = LocalPlayer.Character
            local PetMountSession = if Character == nil then nil else Character:FindFirstChild("PetMountSession")
            local UID = if PetMountSession == nil then nil else PetMountSession:GetAttribute("UID")

            if typeof(UID) ~= "string" then
                UID = nil
            end

            local v40 = UID == p17

            local function v41() -- line: 387
                -- upvalues: p17 (copy), v40 (copy), Remotes (copy)
                if v40 then
                    return Remotes.PetMount.Request:InvokeServer("dismount")
                end

                return Remotes.PetMount.Request:InvokeServer("mount", p17)
            end

            local v42, v43, v44 = pcall(v41)

            v10 = false

            if v42 and v43 == true then
                if not v40 then
                    v12:SetOpen(false, nil)
                end
            else
                local Show = Toast.Show
                local t7 = {
                    Seconds = 2
                }

                if not v42 or typeof(v44) ~= "string" then
                    v44 = "Couldn't ride this pet. Try again."
                end

                t7.Text = v44
                t7.Color = v1
                Show(t7)
            end
        end

        local function updateRow(p18, p19, p20) -- line: 407
            -- upvalues: LocalPlayer (copy), v7 (copy), Frame (copy), Size (copy), v11 (copy), Size3 (copy), TextLabel3 (ref), GuiService (copy), Simple (copy), SwapGradient (copy), MenuNavigation (copy), PetMountFlags (copy)
            p18.Root.LayoutOrder = p20

            if p18.Gradient ~= p19.RarityGradient then
                SwapGradient(p18.Label, p19.RarityGradient)

                if p18.Shadow ~= p18.Label then
                    SwapGradient(p18.Shadow, p19.RarityGradient)
                end

                p18.Gradient = p19.RarityGradient
            end

            local Label, Shadow = p18.Label, p18.Shadow
            local v45 = p19.DisplayName .. " ($" .. Simple.FormatCompact(p19.Rate, ".#") .. "/s)"

            Label.Text = v45
            Shadow.Text = v45
            p18.Icon.Image = p19.Icon or ""

            local v46 = p19.Rideable and PetMountFlags.Enabled:Get()

            if not v46 and GuiService.SelectedObject == p18.Ride then
                local Enabled = v7.Enabled and Frame.Visible and not MenuNavigation.IsSuspended() and not MenuNavigation.IsCursorActive()

                if Enabled then
                    GuiService.SelectedObject = p18.Unequip
                end
            end

            p18.CanRide = v46
            p18.Ride.Visible = v46

            local Unequip = p18.Unequip

            if v46 then
                Unequip.Size = Size
                p18.Button = p18.Ride
            else
                Unequip.Size = v11
                p18.Button = p18.Unequip
                p18.Ride:SetAttribute("DefaultFocus", false)
            end

            if p18.RideLabel == nil or p18.RideShadow == nil then
                return
            end

            local Character = LocalPlayer.Character
            local PetMountSession = if Character == nil then nil else Character:FindFirstChild("PetMountSession")
            local UID = if PetMountSession == nil then nil else PetMountSession:GetAttribute("UID")

            if typeof(UID) ~= "string" then
                UID = nil
            end

            local v47 = UID == p19.UID
            local RideLabel, RideShadow = p18.RideLabel, p18.RideShadow
            local v48 = if v47 then "Dismount" else "Ride"

            RideLabel.Text = v48
            RideShadow.Text = v48

            if Size3 ~= nil and TextLabel3 ~= nil then
                local RideLabel = p18.RideLabel

                if v47 then
                    RideLabel.Size = TextLabel3
                else
                    RideLabel.Size = Size3
                end
            end
        end

        local function mountRow(p21, p22) -- line: 436
            -- upvalues: ScrollingFrame (copy), v8 (copy), keepRowVisible (copy), requestRide (copy), updateRow (copy), AssetRoster (copy), ButtonFX (copy), SwapGradient (copy), Toast (copy), Trove (copy), v1 (copy)
            local v49 = Trove.new()
            local clone = v8:Clone()

            clone.Name = ("Pet_%*"):format(p21.UID)
            clone.LayoutOrder = p22
            clone.Visible = true
            clone:SetAttribute("PetListRowClone", true)
            v49:Add(clone)

            local Spacer = clone.Spacer
            local TextLabel = Spacer.TextLabel
            local TextLabel2 = TextLabel:FindFirstChild("TextLabel")

            if TextLabel2 == nil or not TextLabel2:IsA("TextLabel") then
                TextLabel2 = TextLabel
            end

            local Icon, ButtonsHolder = Spacer.Icon, Spacer.ButtonsHolder
            local Ride, Unequip = ButtonsHolder.Ride, ButtonsHolder.Unequip
            local TextLabel3 = Ride:FindFirstChild("TextLabel")

            if TextLabel3 == nil or not TextLabel3:IsA("TextLabel") then
                TextLabel3 = nil
            end

            Ride.LayoutOrder = 1
            Unequip.LayoutOrder = 2
            Ride.Selectable = true
            Unequip.Selectable = true
            SwapGradient(TextLabel, nil)

            if TextLabel2 ~= TextLabel then
                SwapGradient(TextLabel2, nil)
            end

            v49:Connect(Unequip.Activated, function() -- line: 463
                -- upvalues: p21 (copy), AssetRoster (copy), Toast (copy), v1 (copy)
                local UID = p21.UID
                local v50, v51 = AssetRoster.DoffAsset(UID)

                if not v50 and v51 ~= nil then
                    Toast.Show({
                        Seconds = 2,
                        Text = v51,
                        Color = v1
                    })
                end
            end)
            v49:Connect(Unequip.SelectionGained, function() -- line: 464
                -- upvalues: Unequip (copy), keepRowVisible (copy)
                keepRowVisible(Unequip)
            end)
            v49:Add(ButtonFX(Unequip, 1.08))
            v49:Connect(Ride.Activated, function() -- line: 466
                -- upvalues: p21 (copy), requestRide (copy)
                requestRide(p21.UID)
            end)
            v49:Connect(Ride.SelectionGained, function() -- line: 467
                -- upvalues: Ride (copy), keepRowVisible (copy)
                keepRowVisible(Ride)
            end)
            v49:Add(ButtonFX(Ride, 1.08))

            local t8 = {
                CanRide = false,
                Gradient = nil,
                Root = clone,
                Button = Unequip,
                Ride = Ride,
                Unequip = Unequip,
                RideLabel = TextLabel3
            }

            if TextLabel3 ~= nil then
                local TextLabel = TextLabel3:FindFirstChild("TextLabel")

                if TextLabel ~= nil and TextLabel:IsA("TextLabel") then
                    TextLabel3 = TextLabel
                end
            end

            t8.RideShadow = TextLabel3
            t8.Label = TextLabel
            t8.Shadow = TextLabel2
            t8.Icon = Icon
            t8.Trove = v49
            updateRow(t8, p21, p22)
            clone.Parent = ScrollingFrame

            return t8
        end

        local function pinEmptyLast() -- line: 480
            -- upvalues: EmptyLast (copy)
            if EmptyLast ~= nil then
                EmptyLast.LayoutOrder = 1E+06
            end
        end

        local function refresh() -- line: 486
            -- upvalues: LocalPlayer (copy), v7 (copy), Frame (copy), ScrollingFrame (copy), EmptyLast (copy), EquipBest (copy), t2 (copy), t3 (ref), n2 (ref), keepRowVisible (copy), updateHeader (copy), buildEntries (copy), updateRow (copy), mountRow (copy), GuiService (copy), MenuNavigation (copy), Save (copy)
            local SelectedObject = GuiService.SelectedObject
            local t9 = t3
            local v52, v53

            for v54, v55 in t9 do
                if SelectedObject == v55.Ride or SelectedObject == v55.Unequip then
                    v52 = v54
                    v53 = v55
                    break
                end

                v52 = nil
                v53 = nil
            end

            local v56 = Save.Await(LocalPlayer)
            local v57 = buildEntries(v56)
            local t10 = {}
            local t11 = {}
            local v58 = false

            for v59, v60 in ipairs(v57) do
                if not t10[v60.UID] then
                    t10[v60.UID] = true

                    local v61 = t2[v60.UID]

                    if v61 ~= nil then
                        updateRow(v61, v60, #t11 + 1)
                    else
                        v61 = mountRow(v60, #t11 + 1)
                        t2[v60.UID] = v61
                    end

                    table.insert(t11, v61)

                    if t3[v59] ~= v61 then
                        v58 = true
                    end
                end
            end

            local v62 = v58 or #t11 ~= #t3

            t3 = t11
            n2 = #t11

            if EmptyLast ~= nil then
                EmptyLast.LayoutOrder = 1E+06
            end

            updateHeader(v56, n2)

            if v52 ~= nil and v53 ~= nil and not table.find(t11, v53) and v7.Enabled and Frame.Visible and not MenuNavigation.IsSuspended() and not MenuNavigation.IsCursorActive() and GuiService.SelectedObject == SelectedObject then
                GuiService.SelectedObject = if #t11 > 0 then t11[math.min(v52, #t11)].Button else EquipBest
            end

            for v65, v66 in t2 do
                if not t10[v65] then
                    t2[v65] = nil
                    v66.Trove:Destroy()
                end
            end

            if v62 and v52 ~= nil then
                local SelectedObject = GuiService.SelectedObject

                if SelectedObject ~= nil and SelectedObject:IsDescendantOf(ScrollingFrame) then
                    task.defer(function() -- line: 534
                        -- upvalues: SelectedObject (copy), keepRowVisible (copy)
                        if SelectedObject.Parent ~= nil then
                            keepRowVisible(SelectedObject)
                        end
                    end)
                end
            end
        end

        local function refreshUpgradeHeader() -- line: 541
            -- upvalues: LocalPlayer (copy), n2 (ref), updateHeader (copy), Save (copy)
            updateHeader(Save.Await(LocalPlayer), n2)
        end

        local function showEquipBestDebounceNotification() -- line: 543
            -- upvalues: Toast (copy)
            Toast.Show({
                Text = "Please wait a bit before equipping bests again!",
                Seconds = 2,
                Color = Color3.fromRGB(255, 170, 0)
            })
        end

        local function requestEquipBest() -- line: 551
            -- upvalues: n1 (ref), v9 (ref), refresh (copy), Toast (copy), Remotes (copy), v1 (copy)
            local ServerTimeNow = workspace:GetServerTimeNow()

            if v9 or ServerTimeNow - n1 < 5 then
                Toast.Show({
                    Text = "Please wait a bit before equipping bests again!",
                    Seconds = 2,
                    Color = Color3.fromRGB(255, 170, 0)
                })
            else
                n1 = ServerTimeNow
                v9 = true

                local v67, v68 = Remotes.Haul.WearBest:InvokeServer()

                v9 = false

                if v67 == true then
                    refresh()
                else
                    local Show = Toast.Show
                    local t12 = {
                        Seconds = 2
                    }

                    if typeof(v68) ~= "string" then
                        v68 = "Please wait a bit before equipping bests again!"
                    end

                    t12.Text = v68
                    t12.Color = v1
                    Show(t12)
                end
            end
        end

        local function requestBaseUpgrade() -- line: 574
            -- upvalues: BaseUpgrade (copy)
            BaseUpgrade.PurchaseNextTier()
        end

        v8.Visible = false
        v12:SetOpen(false, true)
        refresh()
        PetPenCapacityGuidanceController.Initialize()

        for _, v69 in PetsButton do
            GUI.OnActivated(v69, function() -- line: 586
                -- upvalues: v12 (copy), refresh (copy), PetPenCapacityGuidanceController (copy)
                PetPenCapacityGuidanceController.AcknowledgePetsBadge()
                v12:SetOpen(true, nil)
                refresh()
            end)
            ButtonFX(v69, 1.08)
        end

        GUI.OnActivated(Close, function() -- line: 593
            -- upvalues: v12 (copy)
            v12:SetOpen(false, nil)
        end)
        ButtonFX(Close, 1.08)
        GUI.OnActivated(PlusEquip, requestBaseUpgrade)
        ButtonFX(PlusEquip, 1.08)
        GUI.OnActivated(EquipBest, function() -- line: 597
            -- upvalues: requestEquipBest (copy), PetPenCapacityGuidanceController (copy)
            PetPenCapacityGuidanceController.AcknowledgeEquipBestBadge()
            requestEquipBest()
        end)
        ButtonFX(EquipBest, 1.08)
        Save.WatchFields({ "Inventory", "EquippedAssets", "BaseUpgradeLevel", "Gamepasses", "Products" }, refresh)
        Save.Watch("Money"):Connect(refreshUpgradeHeader)
        AssetRoster.SnapshotRefreshed:Connect(refresh)
        PetMountFlags.Enabled.Changed:Connect(function() -- line: 609
            -- upvalues: refresh (copy)
            task.defer(refresh)
        end)

        local function watchMount(p23) -- line: 610
            -- upvalues: refresh (copy)
            if p23 ~= nil then
                p23.ChildAdded:Connect(function(p24) -- line: 614
                    -- upvalues: refresh (copy)
                    if p24.Name == "PetMountSession" then
                        task.defer(refresh)
                    end
                end)
                p23.ChildRemoved:Connect(function(p25) -- line: 617
                    -- upvalues: refresh (copy)
                    if p25.Name == "PetMountSession" then
                        task.defer(refresh)
                    end
                end)
            end
        end

        LocalPlayer.CharacterAdded:Connect(watchMount)
        watchMount(LocalPlayer.Character)
        AssetRoster.OwnerRefreshed:Connect(function(p26) -- line: 623
            -- upvalues: LocalPlayer (copy), refresh (copy)
            if p26 == LocalPlayer.UserId then
                refresh()
            end
        end)
        AssetRoster.OwnerCleared:Connect(function(p27) -- line: 628
            -- upvalues: LocalPlayer (copy), refresh (copy)
            if p27 == LocalPlayer.UserId then
                refresh()
            end
        end)
        Remotes.Homestead.BaseTierRaised.OnClientEvent:Connect(function() -- line: 633
            -- upvalues: refresh (copy), Toast (copy), v2 (copy)
            Toast.Show({
                Text = "Successfully upgraded your base!",
                Seconds = 0.7,
                Color = v2
            })
            refresh()
        end)
    end
}
