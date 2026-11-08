-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local CashPacks = require(ReplicatedStorage.Data.CashPacks)
local SpeedPacks = require(ReplicatedStorage.Data.SpeedPacks)
local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)
local GUI = require(ReplicatedStorage.Client.GUI)
local GameFlags = require(ReplicatedStorage.Shared.Flags.GameFlags)
local GamepadBindings = require(ReplicatedStorage.Client.GamepadBindings)
local Gamepasses = require(ReplicatedStorage.Data.Gamepasses)
local GiftProductsMapping = require(ReplicatedStorage.Data.GiftProductsMapping)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local PlatformController = require(ReplicatedStorage.Client.PlatformController)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local Trove = require(ReplicatedStorage.Packages.Trove)
local LocalPlayer = Players.LocalPlayer
local v1 = GUI.Shop()
local Frame = v1:WaitForChild("Frame")
local GiftingPopUp = v1:WaitForChild("GiftingPopUp")
local ScrollingFrame = GiftingPopUp:WaitForChild("ScrollingFrame")
local PlayerTemplate = ScrollingFrame:WaitForChild("PlayerTemplate")
local PendingPurchase = LocalPlayer.PlayerGui:WaitForChild("PendingPurchase")
local PendingPurchaseHandler = require(PendingPurchase:WaitForChild("PendingPurchaseHandler"))
local MenuNavigation = require(ReplicatedStorage.Client.MenuNavigation)
local t1 = {}
local t2 = nil
local t3 = nil
local t4 = {}
local clone = GiftingPopUp.Header.Title:Clone()

clone.Name = "CashPackNotice"
clone.Text = "Cash gifts use the receiver's pack value.\nIt may differ from yours."
clone.AnchorPoint = Vector2.new(0.5, 0)
clone.Size = UDim2.fromScale(0.92, 0.12)
clone.BackgroundTransparency = 1
clone.TextWrapped = true
clone.TextScaled = true
clone.TextXAlignment = Enum.TextXAlignment.Center
clone.TextYAlignment = Enum.TextYAlignment.Center

local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

UITextSizeConstraint.MinTextSize = 1
UITextSizeConstraint.MaxTextSize = 28
UITextSizeConstraint.Parent = clone

local UIStroke = clone:FindFirstChildOfClass("UIStroke")

if UIStroke then
    UIStroke.Thickness = 0.06
end

clone.Visible = false
clone.Parent = GiftingPopUp

local ScrollingFramePosition, Size = ScrollingFrame.Position, ScrollingFrame.Size
local v2 = UDim2.new(Size.X.Scale, Size.X.Offset, Size.Y.Scale - 0.15, Size.Y.Offset)

clone.Position = UDim2.fromScale(0.5, ScrollingFramePosition.Y.Scale - Size.Y.Scale * ScrollingFrame.AnchorPoint.Y + 0.01)

local Text = GiftingPopUp.Header.Title.Text

GiftingPopUp.Visible = false

for _, child in ScrollingFrame:GetChildren() do
    if child.Name == "PlayerTemplate" and child:IsA("GuiObject") then
        child.Visible = false
    end
end

local function notify(p1) -- line: 68
    -- upvalues: Toast (copy)
    Toast.Show({
        Seconds = 5,
        Text = p1
    })
end

local function closePicker(p2) -- line: 72
    -- upvalues: GuiService (copy), Tabs (copy), Frame (copy), GiftingPopUp (copy), ScrollingFrame (copy), MenuNavigation (copy), t2 (ref), clone (copy), ScrollingFramePosition (copy), Size (copy), Text (copy)
    local t5 = t2

    t2 = nil
    MenuNavigation.SetOverride("Gifting", nil)
    GiftingPopUp.Visible = false
    clone.Visible = false
    ScrollingFrame.Position = ScrollingFramePosition
    ScrollingFrame.Size = Size
    GiftingPopUp.Header.Title.Text = Text
    Frame.Visible = true

    if t5 then
        t5.trove:Destroy()
    end

    if GuiService.SelectedObject and GuiService.SelectedObject:IsDescendantOf(GiftingPopUp) then
        GuiService.SelectedObject = nil
    end

    if p2 ~= false and t5 and t5.sourceTab and t5.sourceTab ~= "Shop" and Tabs.IsActive("Shop") then
        Tabs.Activate(t5.sourceTab)
    end
end

local function stopOverlay(p3) -- line: 99
    if p3.cleanup then
        p3.cleanup()
        p3.cleanup = nil
    end
end

local function selectPlayer(p4, p5) -- line: 113
    -- upvalues: HttpService (copy), Players (copy), CashPacks (copy), SpeedPacks (copy), GameFlags (copy), Toast (copy), Remotes (copy), PendingPurchaseHandler (copy), t2 (ref), t3 (ref), closePicker (copy)
    if t2 ~= p4 or t3 then
        return
    end

    if p5.Parent ~= Players then
        Toast.Show({
            Text = "That player has left the server.",
            Seconds = 5
        })

        return
    end

    if not GameFlags.StorefrontOpen:Get() then
        Toast.Show({
            Text = "Purchases are temporarily disabled.",
            Seconds = 5
        })

        return
    end

    if p4.cashSlot and CashPacks.GetShownAmount(p5, p4.cashSlot) == nil then
        Toast.Show({
            Text = "That player's cash packs are still loading. Please try again.",
            Seconds = 5
        })
    elseif not p4.speedSlot or SpeedPacks.GetShownAmount(p5, p4.speedSlot) ~= nil then
        local t6 = {
            productId = p4.productId,
            token = HttpService:GenerateGUID(false),
            cleanup = PendingPurchaseHandler.observePendingPurchase()
        }

        t3 = t6
        task.delay(60, function() -- line: 140
            -- upvalues: t6 (copy), Toast (copy), t3 (ref)
            if t3 ~= t6 then
                return
            end

            if t6.cleanup then
                t6.cleanup()
                t6.cleanup = nil
            end

            if t3 == t6 then
                t3 = nil
            end

            Toast.Show({
                Text = "Your gift is still awaiting confirmation. Delivery may be delayed; please check before trying again.",
                Seconds = 5
            })
        end)

        local function v3() -- line: 150
            -- upvalues: p4 (copy), p5 (copy), t6 (copy), SpeedPacks (copy), Remotes (copy)
            return Remotes.Gifting.AskGift:InvokeServer(p5.UserId, p4.kind, p4.itemId, t6.token, if p4.speedSlot then p5:GetAttribute(SpeedPacks.RevisionAttribute) else nil)
        end

        local v4, v5, v6 = pcall(v3)

        if t3 == t6 then
            if not v4 or not v5 then
                if t6.cleanup then
                    t6.cleanup()
                    t6.cleanup = nil
                end

                if t3 == t6 then
                    t3 = nil
                end

                local v7 = if v4 then type(v6) == "string" else nil

                if not v4 or not v7 then
                    v6 = "Could not start this gift. Please try again."
                end

                Toast.Show({
                    Seconds = 5,
                    Text = v6
                })
            else
                closePicker()
            end
        end
    else
        Toast.Show({
            Text = "That player's speed packs are still loading. Please try again.",
            Seconds = 5
        })
    end
end

function t1.Open(p6, p7) -- line: 171
    -- upvalues: GuiService (copy), Players (copy), ButtonFX (copy), CashPacks (copy), SpeedPacks (copy), Simple (copy), Gamepasses (copy), GiftProductsMapping (copy), Toast (copy), PlatformController (copy), Tabs (copy), Trove (copy), LocalPlayer (copy), Frame (copy), GiftingPopUp (copy), ScrollingFrame (copy), PlayerTemplate (copy), MenuNavigation (copy), t2 (ref), t3 (ref), clone (copy), ScrollingFramePosition (copy), Size (copy), v2 (copy), Text (copy), closePicker (copy), selectPlayer (copy)
    if t3 then
        Toast.Show({
            Text = "Finish your current gift purchase first.",
            Seconds = 5
        })
    else
        local v8 = p7

        if p6 == "Gamepass" then
            local v9 = Gamepasses.FromProductId(p7)

            v8 = v9 and GiftProductsMapping[v9.Name] or 0
        end

        if v8 <= 0 then
            Toast.Show({
                Text = "Gifting is not available for this item yet.",
                Seconds = 5
            })
        else
            local v10 = if t2 then t2.sourceTab else Tabs.Active()
            local t7 = t2

            t2 = nil
            MenuNavigation.SetOverride("Gifting", nil)
            GiftingPopUp.Visible = false
            clone.Visible = false
            ScrollingFrame.Position = ScrollingFramePosition
            ScrollingFrame.Size = Size
            GiftingPopUp.Header.Title.Text = Text
            Frame.Visible = true

            if t7 then
                t7.trove:Destroy()
            end

            if GuiService.SelectedObject and GuiService.SelectedObject:IsDescendantOf(GiftingPopUp) then
                GuiService.SelectedObject = nil
            end

            Tabs.Activate("Shop")

            local t8 = {
                sourceTab = v10,
                trove = Trove.new(),
                rows = {},
                kind = p6,
                itemId = p7,
                productId = v8,
                speedSlot = if p6 == "Product" then SpeedPacks.FindSlot(v8) else nil,
                cashSlot = if p6 == "Product" then CashPacks.FindSlot(v8) else nil
            }

            t2 = t8

            if t8.cashSlot or t8.speedSlot then
                GiftingPopUp.Header.Title.Text = "Gift " .. (if t8.speedSlot then SpeedPacks.Names[t8.speedSlot] else CashPacks.Offers[t8.cashSlot].DisplayName)
                clone.Text = t8.speedSlot and "Speed gifts use the receiver's pack value.\nTheir amount is shown below." or "Cash gifts use the receiver's pack value.\nIt may differ from yours."
                clone.Visible = true
                ScrollingFrame.Size = v2
            end

            Frame.Visible = false
            GiftingPopUp.Visible = true
            MenuNavigation.SetOverride("Gifting", GiftingPopUp, GiftingPopUp.Close, function() -- line: 215
                -- upvalues: closePicker (copy)
                closePicker()
            end, 1000, true)
            ScrollingFrame.CanvasPosition = Vector2.zero

            local function sortRows() -- line: 219
                -- upvalues: t8 (copy), GuiService (copy), PlatformController (copy), GiftingPopUp (copy), MenuNavigation (copy)
                local t9 = {}

                for v13 in t8.rows do
                    table.insert(t9, v13)
                end

                table.sort(t9, function(p8, p9) -- line: 224
                    local v14 = string.lower(p8.DisplayName)
                    local v15 = string.lower(p9.DisplayName)

                    if v14 == v15 then
                        return p8.UserId < p9.UserId
                    end

                    return v14 < v15
                end)

                for v16, v17 in t9 do
                    t8.rows[v17].card.LayoutOrder = v16
                end

                if not PlatformController.IsConsole() or MenuNavigation.IsCursorActive() or GuiService.SelectedObject and GuiService.SelectedObject:IsDescendantOf(GiftingPopUp) then
                    return
                end

                GuiService.GuiNavigationEnabled = true
                GuiService.SelectedObject = if t9[1] then t8.rows[t9[1]].card.Select else GiftingPopUp.Close
            end

            local function addPlayer(p10) -- line: 240
                -- upvalues: t8 (copy), sortRows (copy), ButtonFX (copy), CashPacks (copy), SpeedPacks (copy), Simple (copy), Trove (copy), LocalPlayer (copy), ScrollingFrame (copy), PlayerTemplate (copy), t2 (ref), Size (copy), v2 (copy), selectPlayer (copy)
                local v19, clone, v20

                if p10 == LocalPlayer or t8.rows[p10] then
                    v20 = true
                elseif t2 == t8 then
                    v19 = Trove.new()
                    clone = PlayerTemplate:Clone()
                    clone.Name = tostring(p10.UserId)
                    clone.PlayerNickName.Text = p10.DisplayName
                    clone.PlayerName.Text = "@" .. p10.Name
                    clone.PlayerIcon.Image = ("rbxthumb://type=AvatarHeadShot&id=%*&w=150&h=150"):format(p10.UserId)

                    local Gift = clone:FindFirstChild("Gift")

                    if Gift and Gift:IsA("GuiObject") then
                        Gift.Visible = false
                    end

                    v20 = false
                else
                    v20 = true
                end

                if v20 then
                    return
                end

                clone.Visible = true
                clone.Parent = ScrollingFrame
                v19:Add(clone)

                if t8.cashSlot or t8.speedSlot then
                    clone.Size = UDim2.new(clone.Size.X.Scale, clone.Size.X.Offset, clone.Size.Y.Scale * Size.Y.Scale / v2.Y.Scale, clone.Size.Y.Offset)

                    local clone2 = clone

                    local function refreshGiftAmount() -- line: 264
                        -- upvalues: p10 (copy), clone2 (copy), t8 (copy), CashPacks (copy), SpeedPacks (copy), Simple (copy)
                        local v21 = if t8.speedSlot then SpeedPacks.GetShownAmount(p10, t8.speedSlot) else CashPacks.GetShownAmount(p10, t8.cashSlot)

                        if t8.speedSlot then
                            local Title = clone2.Select.Title

                            if v21 then
                                Title.Text = p10.DisplayName .. " gets +" .. Simple.FormatCompact(v21, ".#") .. " Speed"
                            else
                                Title.Text = "Loading..."
                            end

                            clone2.Select.Title.TextScaled = true
                            clone2.Select.Title.TextWrapped = true
                        else
                            local Title = clone2.Select.Title

                            if v21 then
                                Title.Text = "Gift $" .. Simple.FormatCompact(v21, ".#")
                            else
                                Title.Text = "Loading..."
                            end
                        end
                    end

                    if t8.speedSlot then
                        v19:Add(SpeedPacks.ObserveShownAmount(p10, t8.speedSlot, refreshGiftAmount))
                    else
                        v19:Connect(p10:GetAttributeChangedSignal(CashPacks.RevisionAttribute), refreshGiftAmount)
                        refreshGiftAmount()
                    end
                end

                v19:Add(ButtonFX(clone.Select, nil, function() -- line: 287
                    -- upvalues: p10 (copy), t8 (copy), selectPlayer (copy)
                    selectPlayer(t8, p10)
                end))
                t8.rows[p10] = {
                    card = clone,
                    trove = v19
                }
                sortRows()
            end

            t8.trove:Add(function() -- line: 293
                -- upvalues: t8 (copy)
                for _, v22 in t8.rows do
                    v22.trove:Destroy()
                end

                table.clear(t8.rows)
            end)
            t8.trove:Connect(Players.PlayerAdded, addPlayer)
            t8.trove:Connect(Players.PlayerRemoving, function(p11) -- line: 300
                -- upvalues: t8 (copy), sortRows (copy), GuiService (copy)
                local v23 = t8.rows[p11]

                if not v23 then
                    return
                end

                if GuiService.SelectedObject and GuiService.SelectedObject:IsDescendantOf(v23.card) then
                    GuiService.SelectedObject = nil
                end

                v23.trove:Destroy()
                t8.rows[p11] = nil
                sortRows()
            end)

            for _, player in Players:GetPlayers() do
                addPlayer(player)
            end

            sortRows()

            if next(t8.rows) == nil then
                Toast.Show({
                    Text = "There are no other players in this server yet.",
                    Seconds = 5
                })
            end
        end
    end
end

function t1.Bind(p12, p13, p14) -- line: 321
    -- upvalues: ButtonFX (copy), t1 (copy)
    return ButtonFX(p12, nil, function() -- line: 322
        -- upvalues: p13 (copy), p14 (copy), t1 (copy)
        t1.Open(p13, p14)
    end)
end

ButtonFX(GiftingPopUp.Close)
GamepadBindings.Inspect(GiftingPopUp.Close)
GUI.OnActivated(GiftingPopUp.Close, function() -- line: 330
    -- upvalues: closePicker (copy)
    closePicker()
end)
Tabs.Deactivated:Connect(function(p15) -- line: 333
    -- upvalues: GuiService (copy), Frame (copy), GiftingPopUp (copy), ScrollingFrame (copy), MenuNavigation (copy), t2 (ref), t3 (ref), clone (copy), ScrollingFramePosition (copy), Size (copy), Text (copy)
    if p15 ~= "Shop" then
        return
    end

    local t10 = t2

    t2 = nil
    MenuNavigation.SetOverride("Gifting", nil)
    GiftingPopUp.Visible = false
    clone.Visible = false
    ScrollingFrame.Position = ScrollingFramePosition
    ScrollingFrame.Size = Size
    GiftingPopUp.Header.Title.Text = Text
    Frame.Visible = true

    if t10 then
        t10.trove:Destroy()
    end

    if GuiService.SelectedObject and GuiService.SelectedObject:IsDescendantOf(GiftingPopUp) then
        GuiService.SelectedObject = nil
    end

    if t3 then
        local t11 = t3

        if t11.cleanup then
            t11.cleanup()
            t11.cleanup = nil
        end
    end
end)
v1:GetPropertyChangedSignal("Enabled"):Connect(function() -- line: 341
    -- upvalues: GuiService (copy), v1 (copy), Frame (copy), GiftingPopUp (copy), ScrollingFrame (copy), MenuNavigation (copy), t2 (ref), t3 (ref), clone (copy), ScrollingFramePosition (copy), Size (copy), Text (copy)
    if v1.Enabled then
        return
    end

    local t12 = t2

    t2 = nil
    MenuNavigation.SetOverride("Gifting", nil)
    GiftingPopUp.Visible = false
    clone.Visible = false
    ScrollingFrame.Position = ScrollingFramePosition
    ScrollingFrame.Size = Size
    GiftingPopUp.Header.Title.Text = Text
    Frame.Visible = true

    if t12 then
        t12.trove:Destroy()
    end

    if GuiService.SelectedObject and GuiService.SelectedObject:IsDescendantOf(GiftingPopUp) then
        GuiService.SelectedObject = nil
    end

    if t3 then
        local t13 = t3

        if t13.cleanup then
            t13.cleanup()
            t13.cleanup = nil
        end
    end
end)
Remotes.Gifting.PromptFinished.OnClientEvent:Connect(function(p16, p17) -- line: 350
    -- upvalues: t3 (ref), closePicker (copy)
    local t14 = t3

    if t14 and t14.productId == p16 and t14.token == p17 then
        if t14.cleanup then
            t14.cleanup()
            t14.cleanup = nil
        end

        if t3 == t14 then
            t3 = nil
        end

        closePicker()
    end
end)
Remotes.Gifting.Completed.OnClientEvent:Connect(function(p18, _, p20, p21) -- line: 359
    -- upvalues: t3 (ref), t4 (copy), closePicker (copy)
    if t4[p20] then
        return
    end

    t4[p20] = true

    local t15 = t3

    if t15 and t15.productId == p18 and t15.token == p21 then
        if t15.cleanup then
            t15.cleanup()
            t15.cleanup = nil
        end

        if t3 == t15 then
            t3 = nil
        end

        closePicker()
    end
end)

return t1
