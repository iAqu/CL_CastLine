-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local t = require(ReplicatedStorage.Packages.t)
local AssetGender = require(ReplicatedStorage.Shared.Util.AssetGender)
local AssetItems = require(ReplicatedStorage.Shared.Util.AssetItems)
local AssetRuntime = require(ReplicatedStorage.Shared.Types.AssetRuntime)
local GUI = require(ReplicatedStorage.Client.GUI)
local HoverHighlight = require(ReplicatedStorage.Client.WorldFX.HoverHighlight)
local ModelHover = require(ReplicatedStorage.Client.UI.ModelHover)
local v1 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local t1 = {}
local t2 = {}
local t3
local Key = nil
local v2
local n1 = 0
local t4 = {}

local function getKey(p1) -- line: 54
    return (("%*:%*"):format(p1.OwnerUserId, p1.UID))
end

local function bindGui() -- line: 58
    -- upvalues: GUI (copy), t3 (ref)
    local t5 = t3

    if t5 ~= nil then
        return t5
    end

    local v3 = GUI.AssetHoverData()

    assert(v3:IsA("ScreenGui"), "PlayerGui.AssetHoverData must be a ScreenGui")

    local Frame = v3.Frame

    assert(Frame:IsA("GuiObject"), "AssetHoverData.Frame must be a GuiObject")

    local CanvasGroup = Frame.CanvasGroup

    assert(CanvasGroup:IsA("CanvasGroup"), "AssetHoverData.Frame.CanvasGroup must be a CanvasGroup")

    local Weight = CanvasGroup.Weight

    assert(Weight:IsA("TextLabel"), "AssetHoverData.Frame.CanvasGroup.Weight must be a TextLabel")

    local Gender = CanvasGroup.Gender

    assert(Gender:IsA("ImageLabel"), "AssetHoverData.Frame.CanvasGroup.Gender must be an ImageLabel")

    local t6 = {
        Root = v3,
        Frame = Frame,
        CanvasGroup = CanvasGroup,
        Weight = Weight,
        Gender = Gender
    }

    t3 = t6
    v3.Enabled = false
    Frame.Visible = false
    CanvasGroup.GroupTransparency = 1

    return t6
end

local function clearActiveHighlight() -- line: 89
    -- upvalues: HoverHighlight (copy), v2 (ref)
    local v4 = v2

    v2 = nil

    if v4 ~= nil then
        HoverHighlight.FadeOut(v4, 0.2)
    end
end

local function updateFramePosition(p2, p3) -- line: 97
    p2.Frame.Position = UDim2.fromOffset(p3.X, p3.Y)
end

local function updateStaticContent(p4, p5) -- line: 101
    -- upvalues: AssetGender (copy), AssetItems (copy)
    p4.Weight.Text = AssetItems.WeightLabel(p5.Record.ItemData)
    p4.Gender.Image = AssetGender.BadgeImage(AssetGender.Settle(p5.Record.ItemData.Category, p5.Record.ItemData.Gender))
end

local function setActiveEntry(p6, p7) -- line: 108
    -- upvalues: TweenService (copy), AssetGender (copy), AssetItems (copy), HoverHighlight (copy), v1 (copy), Key (ref), v2 (ref), n1 (ref), bindGui (copy)
    if p6 ~= nil then
        local v8 = bindGui()

        v8.Frame.Position = UDim2.fromOffset(p7.X, p7.Y)
        n1 += 1
        v8.Root.Enabled = true
        v8.Frame.Visible = true

        local Key2 = Key

        if Key2 ~= p6.Key then
            Key = p6.Key

            local v9 = v2

            v2 = nil

            if v9 ~= nil then
                HoverHighlight.FadeOut(v9, 0.2)
            end

            v2 = HoverHighlight.FadeIn(p6.Model, "AssetHoverHighlight", 0.2)
            v8.Weight.Text = AssetItems.WeightLabel(p6.Record.ItemData)
            v8.Gender.Image = AssetGender.BadgeImage(AssetGender.Settle(p6.Record.ItemData.Category, p6.Record.ItemData.Gender))
            v8.CanvasGroup.GroupTransparency = 1
            TweenService:Create(v8.CanvasGroup, v1, {
                GroupTransparency = 0
            }):Play()
        end
    elseif Key ~= nil then
        local v5 = bindGui()

        v5.Frame.Position = UDim2.fromOffset(p7.X, p7.Y)
        Key = nil
        n1 += 1

        local v6 = n1
        local v7 = v2

        v2 = nil

        if v7 ~= nil then
            HoverHighlight.FadeOut(v7, 0.2)
        end

        local tween = TweenService:Create(v5.CanvasGroup, v1, {
            GroupTransparency = 1
        })

        tween.Completed:Once(function(p8) -- line: 121
            -- upvalues: v5 (copy), v6 (copy), Key (ref), n1 (ref)
            if p8 == Enum.PlaybackState.Completed and Key == nil and n1 == v6 then
                v5.Frame.Visible = false
                v5.Root.Enabled = false
            end
        end)
        tween:Play()
    end
end

local function updateHover() -- line: 151
    -- upvalues: UserInputService (copy), ModelHover (copy), t1 (copy), t2 (copy), setActiveEntry (copy)
    local MouseLocation = UserInputService:GetMouseLocation()
    local v10 = ModelHover.KeyUnderCursor(t2, MouseLocation, 200)

    setActiveEntry(if v10 == nil then nil else t1[v10], MouseLocation)
end

function t4.SetEntry(p9) -- line: 158
    -- upvalues: t (copy), AssetRuntime (copy), t1 (copy), t2 (copy)
    assert(AssetRuntime.SchemaValidation.RuntimeAssetRecord(p9.Record), "Invalid runtime asset record")
    t.strict(t.instanceIsA("Model"))(p9.Model)

    local Record = p9.Record
    local v13 = ("%*:%*"):format(Record.OwnerUserId, Record.UID)

    t1[v13] = {
        Key = v13,
        Record = p9.Record,
        Model = p9.Model
    }
    t2[v13] = p9.Model
end

function t4.RemoveEntry(p10, p11) -- line: 174
    -- upvalues: TweenService (copy), UserInputService (copy), t (copy), HoverHighlight (copy), v1 (copy), t1 (copy), t2 (copy), Key (ref), v2 (ref), n1 (ref), bindGui (copy)
    t.strict(t.number)(p10)
    t.strict(t.string)(p11)

    local v14 = ("%*:%*"):format(p10, p11)

    t1[v14] = nil
    t2[v14] = nil

    if Key ~= v14 then
        return
    end

    local MouseLocation = UserInputService:GetMouseLocation()

    if Key == nil then
        return
    end

    local v15 = bindGui()

    v15.Frame.Position = UDim2.fromOffset(MouseLocation.X, MouseLocation.Y)
    Key = nil
    n1 += 1

    local v16 = n1
    local v17 = v2

    v2 = nil

    if v17 ~= nil then
        HoverHighlight.FadeOut(v17, 0.2)
    end

    local tween = TweenService:Create(v15.CanvasGroup, v1, {
        GroupTransparency = 1
    })

    tween.Completed:Once(function(p12) -- line: 121
        -- upvalues: v15 (copy), v16 (copy), Key (ref), n1 (ref)
        if p12 == Enum.PlaybackState.Completed and Key == nil and n1 == v16 then
            v15.Frame.Visible = false
            v15.Root.Enabled = false
        end
    end)
    tween:Play()
end

function t4.DestroyOwner(p13) -- line: 186
    -- upvalues: TweenService (copy), UserInputService (copy), t (copy), HoverHighlight (copy), v1 (copy), t1 (copy), t2 (copy), Key (ref), v2 (ref), n1 (ref), bindGui (copy)
    t.strict(t.number)(p13)

    for v18, v19 in pairs(t1) do
        if v19.Record.OwnerUserId == p13 then
            t1[v18] = nil
            t2[v18] = nil

            if Key == v18 then
                local MouseLocation = UserInputService:GetMouseLocation()

                if Key ~= nil then
                    local v20 = bindGui()

                    v20.Frame.Position = UDim2.fromOffset(MouseLocation.X, MouseLocation.Y)
                    Key = nil
                    n1 += 1

                    local v21 = n1
                    local v22 = v2

                    v2 = nil

                    if v22 ~= nil then
                        HoverHighlight.FadeOut(v22, 0.2)
                    end

                    local tween = TweenService:Create(v20.CanvasGroup, v1, {
                        GroupTransparency = 1
                    })

                    tween.Completed:Once(function(p14) -- line: 121
                        -- upvalues: v20 (copy), v21 (copy), Key (ref), n1 (ref)
                        if p14 == Enum.PlaybackState.Completed and Key == nil and n1 == v21 then
                            v20.Frame.Visible = false
                            v20.Root.Enabled = false
                        end
                    end)
                    tween:Play()
                end
            end
        end
    end
end

RunService.RenderStepped:Connect(updateHover)

return table.freeze(t4)
