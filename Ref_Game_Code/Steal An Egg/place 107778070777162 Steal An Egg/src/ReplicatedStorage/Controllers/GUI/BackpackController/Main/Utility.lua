-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local v1 = Color3.fromRGB(0, 162, 255)
local v2 = Color3.fromRGB(78, 84, 96)
local v3 = Color3.fromRGB(204, 204, 204)
local v4 = Color3.fromRGB(255, 255, 255)
local v5 = Color3.fromRGB(150, 150, 150)
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local PlayerGui = game.Players.LocalPlayer.PlayerGui

PlayerGui:WaitForChild("BackpackGui")

local ContextActionService = game:GetService("ContextActionService")
local VRService = game:GetService("VRService")

local function v6() -- line: 39
    return false
end

local ok, result = pcall(v6)
local v7 = ok and result
local t1 = {
    Create = function(p1) -- Create | line: 48
        return function(p2) -- line: 49
            -- upvalues: p1 (copy)
            local v8 = Instance.new(p1)
            local v9

            for v10, v11 in pairs(p2) do
                if type(v10) == "number" then
                    v11.Parent = v8
                elseif v10 == "Parent" then
                    v9 = v11
                else
                    v8[v10] = v11
                end
            end

            if v9 then
                v8.Parent = v9
            end

            return v8
        end
    end
}
local t2 = {}

setmetatable(t2, {
    __mode = "k"
})

local v12 = t1.Create("ImageLabel")({
    Image = "",
    BackgroundTransparency = 1
})

function clamp(p3, p4, p5) -- line: 79
    return (math.max(p3, (math.min(p4, p5))))
end

function ClampVector2(p6, p7, p8) -- line: 81
    return Vector2.new(clamp(p6.x, p7.x, p8.x), clamp(p6.y, p7.y, p8.y))
end

local function Linear(p9, p10, p11, p12) -- line: 86
    if p12 <= p9 then
        return p10 + p11
    end

    return p11 * p9 / p12 + p10
end

local function EaseOutQuad(p13, p14, p15, p16) -- line: 94
    if p16 <= p13 then
        return p14 + p15
    end

    local v14 = p13 / p16

    return p14 - p15 * v14 * (v14 - 2)
end

local function EaseInOutQuad(p17, p18, p19, p20) -- line: 103
    if p20 <= p17 then
        return p18 + p19
    end

    local v15 = p17 / p20

    if v15 < 0.5 then
        return 2 * p19 * v15 * v15 + p18
    end

    return p18 + p19 * (2 * (2 - v15) * v15 - 1)
end

function PropertyTweener(p21, p22, p23, p24, p25, p26, p27) -- line: 115
    -- upvalues: RunService (copy)
    local t4 = {
        StartTime = tick()
    }

    t4.EndTime = t4.StartTime + p25
    t4.Cancelled = false

    local v16 = false
    local n1 = 0

    local function finalize() -- line: 124
        -- upvalues: p21 (copy), p22 (copy), p23 (copy), p24 (copy), p26 (copy), p27 (copy), v16 (ref), n1 (ref)
        if p21 then
            p21[p22] = p26(1, p23, p24 - p23, 1)
        end

        v16 = true
        n1 = 1

        if p27 then
            p27()
        end
    end

    p21[p22] = p26(0, p23, p24 - p23, p25)
    coroutine.wrap(function() -- line: 137
        -- upvalues: p21 (copy), p22 (copy), p23 (copy), p24 (copy), p25 (copy), p26 (copy), p27 (copy), t4 (copy), v16 (ref), n1 (ref), RunService (copy)
        local v17 = tick()

        while v17 < t4.EndTime and p21 do
            if t4.Cancelled then
                return
            end

            p21[p22] = p26(v17 - t4.StartTime, p23, p24 - p23, p25)
            n1 = clamp(0, 1, (v17 - t4.StartTime) / p25)
            RunService.RenderStepped:wait()
            v17 = tick()
        end

        if t4.Cancelled ~= false or not p21 then
            return
        end

        if p21 then
            p21[p22] = p26(1, p23, p24 - p23, 1)
        end

        v16 = true
        n1 = 1

        if p27 then
            p27()
        end
    end)()

    function t4.GetFinal(_) -- line: 153
        -- upvalues: p24 (copy)
        return p24
    end

    function t4.GetPercentComplete(_) -- line: 155
        -- upvalues: n1 (ref)
        return n1
    end

    function t4.IsFinished(_) -- line: 157
        -- upvalues: v16 (ref)
        return v16
    end

    function t4.Finish(p31) -- line: 159
        -- upvalues: p21 (copy), p22 (copy), p23 (copy), p24 (copy), p26 (copy), p27 (copy), v16 (ref), n1 (ref)
        if v16 then
            return
        end

        p31:Cancel()

        if p21 then
            p21[p22] = p26(1, p23, p24 - p23, 1)
        end

        v16 = true
        n1 = 1

        if p27 then
            p27()
        end
    end

    function t4.Cancel(_) -- line: 166
        -- upvalues: t4 (copy)
        t4.Cancelled = true
    end

    return t4
end

local function CreateSignal() -- line: 173
    local BindableEvent = Instance.new("BindableEvent")
    local t6, v18

    return {
        fire = function(_, ...) -- fire | line: 181
            -- upvalues: BindableEvent (copy), t6 (ref), v18 (ref)
            t6 = { ... }
            v18 = select("#", ...)
            BindableEvent:Fire()
        end,
        connect = function(_, p35) -- connect | line: 187
            -- upvalues: BindableEvent (copy), t6 (ref), v18 (ref)
            if not p35 then
                error("connect(nil)", 2)
            end

            return BindableEvent.Event:Connect(function() -- line: 191
                -- upvalues: p35 (copy), t6 (ref), v18 (ref)
                p35(unpack(t6, 1, v18))
            end)
        end,
        wait = function(_) -- wait | line: 194
            -- upvalues: BindableEvent (copy), t6 (ref), v18 (ref)
            BindableEvent.Event:wait()

            if not t6 then
                error("Missing arg data, likely due to :TweenSize/Position corrupting threadrefs.")
            end

            return unpack(t6, 1, v18)
        end
    }
end

local function getViewportSize() -- line: 205
    while not workspace.CurrentCamera do
        workspace.Changed:wait()
    end

    while true do
        if workspace.CurrentCamera.ViewportSize == Vector2.new(0, 0) then
            workspace.CurrentCamera.Changed:wait()
            continue
        end

        if workspace.CurrentCamera.ViewportSize == Vector2.new(1, 1) then
            workspace.CurrentCamera.Changed:wait()
            continue
        end

        break
    end

    return workspace.CurrentCamera.ViewportSize
end

local function isSmallTouchScreen() -- line: 222
    -- upvalues: UserInputService (copy), getViewportSize (copy)
    local v21 = getViewportSize()

    return UserInputService.TouchEnabled and (v21.Y < 500 or v21.X < 700)
end

local function isPortrait() -- line: 227
    -- upvalues: getViewportSize (copy)
    local v22 = getViewportSize()

    return v22.Y > v22.X
end

local function isTenFootInterface() -- line: 232
    return false
end

local function usesSelectedObject() -- line: 234
    -- upvalues: UserInputService (copy), VRService (copy)
    if VRService.VREnabled then
        return false
    end

    return not not (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled)
end

local function isPosOverGui(p37, p38, _) -- line: 247
    local x, y = p38.AbsolutePosition.x, p38.AbsolutePosition.y
    local x2, y2 = p38.AbsoluteSize.x, p38.AbsoluteSize.y
    local v23 = x + x2
    local v24 = y + y2

    if x < p37.x and p37.x < v23 and y < p37.y then
        return p37.y < v24
    end

    return false
end

local function isPosOverGuiWithClipping(p40, p41) -- line: 255
    local x, y = p41.AbsolutePosition.x, p41.AbsolutePosition.y
    local x2, y2 = p41.AbsoluteSize.x, p41.AbsoluteSize.y
    local v25 = x + x2
    local v26 = y + y2

    if x < p40.x and p40.x < v25 and y < p40.y and p40.y < v26 then
        local v27 = p41
        local v28

        while true do
            if v27 ~= nil and (v27:IsA("GuiObject") or v27:IsA("LayerCollector")) then
                if not v27:IsA("GuiObject") or v27.Visible then
                    if v27:IsA("LayerCollector") or v27.ClipsDescendants then
                        local x, y = v27.AbsolutePosition.x, v27.AbsolutePosition.y
                        local x2, y2 = v27.AbsoluteSize.x, v27.AbsoluteSize.y
                        local v29 = x + x2
                        local v30 = y + y2

                        if x < p40.x and p40.x < v29 and y < p40.y and p40.y < v30 then
                            v27 = v27.Parent
                            continue
                        end

                        v28 = true
                        break
                    end

                    v27 = v27.Parent
                    continue
                end

                v28 = true
            else
                v28 = not v27 or not v27:IsA("CoreGui")
            end

            break
        end

        return not v28
    end

    return false
end

local function areGuisIntersecting(p42, p43) -- line: 288
    local x, y = p42.AbsolutePosition.x, p42.AbsolutePosition.y
    local x2, y2 = p42.AbsoluteSize.x, p42.AbsoluteSize.y
    local v31 = x + x2
    local v32 = y + y2
    local x3, y3 = p43.AbsolutePosition.x, p43.AbsolutePosition.y
    local x4, y4 = p43.AbsoluteSize.x, p43.AbsoluteSize.y
    local v33 = x3 + x4
    local v34 = y3 + y4
    local v35 = x < v33 and x3 < v31
    local v36 = y < v34 and y3 < v32

    return v35 and v36
end

local function isGuiVisible(p44, _) -- line: 303
    local v37 = p44
    local v38

    while true do
        if v37 ~= nil and (v37:IsA("GuiObject") or v37:IsA("LayerCollector")) then
            if not v37:IsA("GuiObject") or v37.Visible then
                if v37:IsA("LayerCollector") or v37.ClipsDescendants then
                    local x, y = v37.AbsolutePosition.x, v37.AbsolutePosition.y
                    local x2, y2 = v37.AbsoluteSize.x, v37.AbsoluteSize.y
                    local v39 = x + x2
                    local v40 = y + y2
                    local x3, y3 = p44.AbsolutePosition.x, p44.AbsolutePosition.y
                    local x4, y4 = p44.AbsoluteSize.x, p44.AbsoluteSize.y
                    local v41 = x3 + x4
                    local v42 = y3 + y4
                    local v43 = x < v41 and x3 < v39
                    local v44 = y < v42 and y3 < v40

                    if v43 and v44 then
                        v37 = v37.Parent
                        continue
                    end

                    v38 = true
                    break
                end

                v37 = v37.Parent
                continue
            end

            v38 = true
        else
            v38 = not v37 or not v37:IsA("CoreGui")
        end

        break
    end

    return not v38
end

local function addHoverState(p46, p47, p48, p49) -- line: 332
    local function onNormalButtonStateCallback() -- line: 333
        -- upvalues: p46 (copy), p47 (copy), p48 (copy)
        if p46.Active then
            p48(p47)
        end
    end

    local function onHoverButtonStateCallback() -- line: 338
        -- upvalues: p46 (copy), p47 (copy), p49 (copy)
        if p46.Active then
            p49(p47)
        end
    end

    p46.MouseEnter:Connect(onHoverButtonStateCallback)
    p46.SelectionGained:Connect(onHoverButtonStateCallback)
    p46.MouseLeave:Connect(onNormalButtonStateCallback)
    p46.SelectionLost:Connect(onNormalButtonStateCallback)
    p48(p47)
end

local function addOnResizedCallback(p50, p51) -- line: 352
    -- upvalues: t2 (copy), getViewportSize (copy)
    t2[p50] = p51

    local v45 = getViewportSize()
    local v46 = getViewportSize()

    p51(v45, v46.Y > v46.X)
end

local t9 = {
    [Enum.UserInputType.Gamepad1] = true,
    [Enum.UserInputType.Gamepad2] = true,
    [Enum.UserInputType.Gamepad3] = true,
    [Enum.UserInputType.Gamepad4] = true,
    [Enum.UserInputType.Gamepad5] = true,
    [Enum.UserInputType.Gamepad6] = true,
    [Enum.UserInputType.Gamepad7] = true,
    [Enum.UserInputType.Gamepad8] = true
}

local function MakeDefaultButton(p52, p53, p54, p55, p56) -- line: 368
    -- upvalues: GuiService (copy), UserInputService (copy), VRService (copy), t1 (copy), t9 (copy)
    local v47 = t1.Create("ImageLabel")({
        Image = "",
        BackgroundTransparency = 1
    })
    local v48 = t1.Create("ImageButton")({
        Image = "rbxasset://textures/ui/Settings/MenuBarAssets/MenuButton.png",
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        ZIndex = 2,
        Name = p52 .. "Button",
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(8, 6, 46, 44),
        Size = p53,
        SelectionImageObject = v47
    })

    t1.Create("BoolValue")({
        Name = "Enabled",
        Value = true,
        Parent = v48
    })

    if p54 then
        v48.MouseButton1Click:Connect(function() -- line: 394
            -- upvalues: p54 (copy), UserInputService (copy), t9 (copy)
            p54(t9[UserInputService:GetLastInputType()] or false)
        end)
    end

    local function isPointerInput(p57) -- line: 398
        if p57.UserInputType == Enum.UserInputType.MouseMovement then
            return true
        end

        return p57.UserInputType == Enum.UserInputType.Touch
    end

    local v49

    local function setRowRef(p58) -- line: 404
        -- upvalues: v49 (ref)
        v49 = p58
    end

    local function selectButton() -- line: 406
        -- upvalues: p55 (copy), p56 (copy), v48 (copy), v49 (ref)
        local v50 = p56

        if p56 == nil and p55 then
            v50 = p55.HubRef
        end

        if not (v50 and v50.Active) and v50 ~= nil then
            return
        end

        v48.Image = "rbxasset://textures/ui/Settings/MenuBarAssets/MenuButtonSelected.png"

        local v51 = v48

        if v49 then
            v51 = v49
        end

        if v50 then
            v50:ScrollToFrame(v51)
        end
    end

    local function deselectButton() -- line: 427
        -- upvalues: v48 (copy)
        v48.Image = "rbxasset://textures/ui/Settings/MenuBarAssets/MenuButton.png"
    end

    v48.InputBegan:Connect(function(p59) -- line: 431
        -- upvalues: p55 (copy), p56 (copy), v48 (copy), v49 (ref)
        if not (v48.Selectable and (p59.UserInputType == Enum.UserInputType.MouseMovement or p59.UserInputType == Enum.UserInputType.Touch)) then
            return
        end

        local v52 = p56

        if p56 == nil and p55 then
            v52 = p55.HubRef
        end

        if not (v52 and v52.Active) and v52 ~= nil then
            return
        end

        v48.Image = "rbxasset://textures/ui/Settings/MenuBarAssets/MenuButtonSelected.png"

        local v53 = v48

        if v49 then
            v53 = v49
        end

        if v52 then
            v52:ScrollToFrame(v53)
        end
    end)
    v48.InputEnded:Connect(function(p60) -- line: 436
        -- upvalues: v48 (copy), GuiService (copy)
        if v48.Selectable and GuiService.SelectedCoreObject ~= v48 and (p60.UserInputType == Enum.UserInputType.MouseMovement or p60.UserInputType == Enum.UserInputType.Touch) then
            v48.Image = "rbxasset://textures/ui/Settings/MenuBarAssets/MenuButton.png"
        end
    end)
    v48.SelectionGained:Connect(function() -- line: 446
        -- upvalues: p55 (copy), p56 (copy), v48 (copy), v49 (ref)
        local v55 = p56

        if p56 == nil and p55 then
            v55 = p55.HubRef
        end

        if not (v55 and v55.Active) and v55 ~= nil then
            return
        end

        v48.Image = "rbxasset://textures/ui/Settings/MenuBarAssets/MenuButtonSelected.png"

        local v56 = v48

        if v49 then
            v56 = v49
        end

        if v55 then
            v55:ScrollToFrame(v56)
        end
    end)
    v48.SelectionLost:Connect(function() -- line: 447
        -- upvalues: v48 (copy)
        v48.Image = "rbxasset://textures/ui/Settings/MenuBarAssets/MenuButton.png"
    end)
    GuiService.Changed:Connect(function(p61) -- line: 449
        -- upvalues: p55 (copy), p56 (copy), v48 (copy), v49 (ref), GuiService (copy), UserInputService (copy), VRService (copy)
        if p61 == "SelectedCoreObject" and not VRService.VREnabled and (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) then
            local v57 = false
            local v58 = false
            local v59 = false
            local v60 = false

            if GuiService.SelectedCoreObject ~= nil then
                v57 = true
            else
                v60 = true
            end

            if v57 then
                if GuiService.SelectedCoreObject == v48 then
                    v58 = true
                else
                    v60 = true
                end
            end

            v57 = false

            if v58 then
                if v48.Selectable then
                    v57 = true
                else
                    v60 = false
                end
            end

            v58 = false

            local v61, v62

            if v57 then
                v61 = p56

                if p56 ~= nil then
                    v62 = p56
                    v59 = true
                else
                    v58 = true
                end
            end

            v57 = false

            if v58 then
                if p55 then
                    v57 = true
                else
                    v62 = v61
                    v59 = true
                end
            end

            v58 = false

            if v57 then
                v62 = p55.HubRef
                v59 = true
            end

            v57 = false

            if v59 then
                if v62 then
                    v57 = true
                else
                    v58 = true
                end
            end

            v59 = false

            if v57 then
                if v62.Active then
                    v59 = true
                else
                    v58 = true
                end
            end

            v57 = false

            if v58 then
                if v62 ~= nil then
                    v60 = false
                else
                    v59 = true
                end
            end

            v58 = false

            local v63

            if v59 then
                v48.Image = "rbxasset://textures/ui/Settings/MenuBarAssets/MenuButtonSelected.png"

                if v49 then
                    v58 = true
                else
                    v63 = v48
                    v57 = true
                end
            end

            if v58 then
                v63 = v49
                v57 = true
            end

            v58 = false

            if v57 then
                if v62 then
                    v58 = true
                else
                    v60 = false
                end
            end

            if v58 then
                v60 = false
                v62:ScrollToFrame(v63)
            end

            if not v60 then
                return
            end

            v48.Image = "rbxasset://textures/ui/Settings/MenuBarAssets/MenuButton.png"
        end
    end)

    return v48, setRowRef
end

local function MakeButton(p62, p63, p64, p65, p66, p67) -- line: 470
    -- upvalues: UserInputService (copy), t1 (copy), getViewportSize (copy), MakeDefaultButton (copy)
    local v64, v65 = MakeDefaultButton(p62, p64, p65, p66, p67)
    local v66 = t1.Create("TextLabel")({
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        TextSize = 24,
        TextScaled = true,
        TextWrapped = true,
        ZIndex = 2,
        Name = p62 .. "TextLabel",
        Size = UDim2.new(1, 0, 1, -8),
        Position = UDim2.new(0, 0, 0, 0),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextYAlignment = Enum.TextYAlignment.Center,
        Font = Enum.Font.SourceSansBold,
        Text = p63,
        Parent = v64
    })
    local UITextSizeConstraint = Instance.new("UITextSizeConstraint", v66)
    local v67 = getViewportSize()
    local TouchEnabled = UserInputService.TouchEnabled and (v67.Y < 500 or v67.X < 700)

    if TouchEnabled then
        v66.TextSize = 18
    end

    UITextSizeConstraint.MaxTextSize = v66.TextSize

    return v64, v66, v65
end

local function MakeImageButton(p68, p69, p70, p71, p72, p73, p74) -- line: 501
    -- upvalues: t1 (copy), MakeDefaultButton (copy)
    local v68, v69 = MakeDefaultButton(p68, p70, p72, p73, p74)

    return v68, t1.Create("ImageLabel")({
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 2,
        Name = p68 .. "ImageLabel",
        Size = p71,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = p69,
        Parent = v68
    }), v69
end

local function AddButtonRow(p75, p76, p77, p78, p79, p80) -- line: 519
    -- upvalues: t1 (copy), MakeButton (copy)
    local v70, v71, v72 = MakeButton(p76, p77, p78, p79, p75, p80)
    local v73 = t1.Create("Frame")({
        BackgroundTransparency = 1,
        Name = p76 .. "Row",
        Size = UDim2.new(1, 0, p78.Y.Scale, p78.Y.Offset),
        Parent = p75.Page
    })

    v70.Parent = v73
    v70.AnchorPoint = Vector2.new(1, 0)
    v70.Position = UDim2.new(1, -20, 0, 0)

    return v73, v70, v71, v72
end

local function CreateDropDown(p81, p82, p83) -- line: 533
    -- upvalues: GuiService (copy), HttpService (copy), UserInputService (copy), PlayerGui (copy), ContextActionService (copy), VRService (copy), t1 (copy), MakeButton (copy)
    local v74 = Color3.fromRGB(178, 178, 178)
    local v75 = Color3.fromRGB(229, 229, 229)
    local v76 = Color3.fromRGB(255, 255, 255)
    local DropDownFrame
    local t10 = {
        CurrentIndex = nil
    }

    Instance.new("BindableEvent").Name = "IndexChanged"

    if type(p81) ~= "table" then
        error("CreateDropDown dropDownStringTable (first arg) is not a table", 2)

        return t10
    end

    local BindableEvent = Instance.new("BindableEvent")

    BindableEvent.Name = "IndexChanged"

    local v77 = true
    local v78 = HttpService:GenerateGUID(false)
    local Enabled
    local v79 = p81
    local v80 = t1.Create("ImageButton")({
        Name = "DropDownFullscreenFrame",
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        ZIndex = 10,
        Active = true,
        Visible = false,
        Selectable = false,
        AutoButtonColor = false,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        Parent = PlayerGui.RobloxGui
    })

    local function onVREnabled(p84) -- line: 579
        -- upvalues: t10 (copy), v79 (ref), v80 (copy), PlayerGui (copy), VRService (copy)
        if p84 ~= "VREnabled" then
            return
        end

        if VRService.VREnabled then
            v80.Parent = require(PlayerGui.RobloxGui.Modules.VR.Panel3D).Get("SettingsMenu"):GetGUI()
            v80.BackgroundTransparency = 1
        else
            v80.Parent = PlayerGui.RobloxGui
            v80.BackgroundTransparency = 0.2
        end

        if t10.UpdateDropDownList then
            t10:UpdateDropDownList(v79)
        end
    end

    VRService.Changed:Connect(onVREnabled)
    onVREnabled("VREnabled")

    local v82 = t1.Create("ImageLabel")({
        Name = "DropDownSelectionFrame",
        Image = "rbxasset://textures/ui/Settings/MenuBarAssets/MenuButton.png",
        BackgroundTransparency = 1,
        ZIndex = 10,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(8, 6, 46, 44),
        Size = UDim2.new(0.6, 0, 0.9, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = v80
    })
    local v83 = t1.Create("ScrollingFrame")({
        Name = "DropDownScrollingFrame",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 10,
        Size = UDim2.new(1, -20, 1, -25),
        Position = UDim2.new(0, 10, 0, 10),
        Parent = v82
    })
    local connection
    local v84 = false

    local function v85(p85, p86) -- line: 625
        -- upvalues: p83 (copy), DropDownFrame (ref), t10 (copy), v77 (ref), v78 (copy), Enabled (ref), v80 (copy), connection (ref), v84 (ref), GuiService (copy), UserInputService (copy), PlayerGui (copy), ContextActionService (copy), VRService (copy)
        if p85 ~= nil and p86 ~= Enum.UserInputState.Begin then
            return
        end

        t10.DropDownFrame.Selectable = v77
        p83:SetActive(true)

        if v80.Visible and not VRService.VREnabled and (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) then
            GuiService.SelectedCoreObject = DropDownFrame
        end

        v80.Visible = false

        if connection then
            connection:Disconnect()
        end

        ContextActionService:UnbindAction(v78 .. "Action")
        ContextActionService:UnbindAction(v78 .. "FreezeAction")
        Enabled.Value = v77
        v84 = false

        if VRService.VREnabled then
            require(PlayerGui.RobloxGui.Modules.VR.Panel3D).Get("SettingsMenu"):SetSubpanelDepth(v80, 0)
        end
    end

    local function v86() -- line: 653
    end

    local function v87() -- line: 655
        -- upvalues: p83 (copy), v74 (copy), v75 (copy), v76 (copy), DropDownFrame (ref), t10 (copy), v77 (ref), v78 (copy), Enabled (ref), v80 (copy), connection (ref), v84 (ref), v85 (copy), v86 (copy), GuiService (copy), PlayerGui (copy), ContextActionService (copy), VRService (copy)
        if not v77 then
            return
        end

        t10.DropDownFrame.Selectable = false
        v84 = true
        v80.Visible = true

        if VRService.VREnabled then
            require(PlayerGui.RobloxGui.Modules.VR.Panel3D).Get("SettingsMenu"):SetSubpanelDepth(v80, 0.5)
        end

        DropDownFrame = t10.DropDownFrame

        if t10.CurrentIndex and t10.CurrentIndex > 0 then
            GuiService.SelectedCoreObject = t10.Selections[t10.CurrentIndex]
        end

        connection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function() -- line: 675
            -- upvalues: v74 (copy), v75 (copy), v76 (copy), t10 (copy), GuiService (copy), VRService (copy)
            for i = 1, #t10.Selections do
                if GuiService.SelectedCoreObject == t10.Selections[i] then
                    t10.Selections[i].TextColor3 = v76
                else
                    t10.Selections[i].TextColor3 = VRService.VREnabled and v75 or v74
                end
            end
        end)
        ContextActionService:BindActionAtPriority(v78 .. "FreezeAction", v86, false, Enum.ContextActionPriority.High.Value, Enum.UserInputType.Keyboard, Enum.UserInputType.Gamepad1)
        ContextActionService:BindActionAtPriority(v78 .. "Action", v85, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.ButtonB, Enum.KeyCode.Escape)
        p83:SetActive(false)
        Enabled.Value = false
    end

    t10.DropDownFrame = MakeButton("DropDownFrame", "Choose One", UDim2.new(0.6, 0, 0, 50), v87, nil, p83)
    t10.DropDownFrame.Position = UDim2.new(1, 0, 0.5, 0)
    t10.DropDownFrame.AnchorPoint = Vector2.new(1, 0.5)
    Enabled = t10.DropDownFrame.Enabled

    local DropDownFrameTextLabel = t10.DropDownFrame.DropDownFrameTextLabel

    DropDownFrameTextLabel.Position = UDim2.new(0, 15, 0, 0)
    DropDownFrameTextLabel.Size = UDim2.new(1, -50, 1, -8)
    DropDownFrameTextLabel.ClipsDescendants = true
    DropDownFrameTextLabel.TextXAlignment = Enum.TextXAlignment.Left

    local v91 = t1.Create("ImageLabel")({
        Name = "DropDownImage",
        Image = "rbxasset://textures/ui/Settings/DropDown/DropDown.png",
        BackgroundTransparency = 1,
        ZIndex = 2,
        AnchorPoint = Vector2.new(1, 0.5),
        Size = UDim2.new(0, 15, 0, 10),
        Position = UDim2.new(1, -12, 0.5, 0),
        Parent = t10.DropDownFrame
    })

    t10.DropDownImage = v91

    local function setSelection(p87) -- line: 739
        -- upvalues: t10 (copy), BindableEvent (copy), DropDownFrameTextLabel (copy)
        local v92 = false

        for v93, v94 in pairs(t10.Selections) do
            if v93 == p87 then
                DropDownFrameTextLabel.Text = v94.Text
                v92 = true
                t10.CurrentIndex = v93
            end
        end

        if v92 then
            BindableEvent:Fire(p87)
        end
    end

    local function setSelectionByValue(p88) -- line: 755
        -- upvalues: t10 (copy), BindableEvent (copy), DropDownFrameTextLabel (copy)
        local v95 = false

        for v96, v97 in pairs(t10.Selections) do
            if v97.Text == p88 then
                DropDownFrameTextLabel.Text = v97.Text
                v95 = true
                t10.CurrentIndex = v96
            end
        end

        if v95 then
            BindableEvent:Fire(t10.CurrentIndex)
        end

        return v95
    end

    local v98 = false

    local function processInput(p89) -- line: 773
        -- upvalues: t10 (copy), v87 (copy), v98 (ref), GuiService (copy)
        if p89.UserInputState == Enum.UserInputState.Begin then
            if p89.KeyCode == Enum.KeyCode.Return and (GuiService.SelectedCoreObject == t10.DropDownFrame or t10.SelectionInfo and t10.SelectionInfo[GuiService.SelectedCoreObject]) then
                v98 = true
            end
        elseif p89.UserInputState == Enum.UserInputState.End and p89.KeyCode == Enum.KeyCode.Return and v98 then
            v98 = false

            if GuiService.SelectedCoreObject == t10.DropDownFrame then
                v87()
            elseif t10.SelectionInfo and t10.SelectionInfo[GuiService.SelectedCoreObject] then
                t10.SelectionInfo[GuiService.SelectedCoreObject].Clicked()
            end
        end
    end

    local function setIsFaded(p90) -- line: 796
        -- upvalues: t10 (copy)
        if p90 then
            t10.DropDownFrame.DropDownFrameTextLabel.TextTransparency = 0.5
            t10.DropDownFrame.ImageTransparency = 0.5
            t10.DropDownImage.ImageTransparency = 0.5
        else
            t10.DropDownFrame.DropDownFrameTextLabel.TextTransparency = 0
            t10.DropDownFrame.ImageTransparency = 0
            t10.DropDownImage.ImageTransparency = 0
        end
    end

    t10.IndexChanged = BindableEvent.Event

    function t10.SetSelectionIndex(_, p92) -- line: 811
        -- upvalues: setSelection (copy)
        setSelection(p92)
    end

    function t10.SetSelectionByValue(_, p94) -- line: 813
        -- upvalues: setSelectionByValue (copy)
        return (setSelectionByValue(p94))
    end

    function t10.ResetSelectionIndex(_) -- line: 815
        -- upvalues: t10 (copy), v85 (copy), DropDownFrameTextLabel (copy)
        t10.CurrentIndex = nil
        DropDownFrameTextLabel.Text = "Choose One"
        v85()
    end

    function t10.GetSelectedIndex(_) -- line: 821
        -- upvalues: t10 (copy)
        return t10.CurrentIndex
    end

    function t10.SetZIndex(_, p98) -- line: 823
        -- upvalues: t10 (copy), DropDownFrameTextLabel (copy), v91 (copy)
        t10.DropDownFrame.ZIndex = p98
        v91.ZIndex = p98
        DropDownFrameTextLabel.ZIndex = p98
    end

    function t10.SetInteractable(_, p100) -- line: 829
        -- upvalues: t10 (copy), v77 (ref), Enabled (ref), v84 (ref), v85 (copy), VRService (copy)
        v77 = p100
        t10.DropDownFrame.Selectable = v77

        if v77 then
            t10.DropDownFrame.DropDownFrameTextLabel.TextTransparency = 0
            t10.DropDownFrame.ImageTransparency = 0
            t10.DropDownImage.ImageTransparency = 0

            if not VRService.VREnabled then
                t10:SetZIndex(2)
            end
        else
            v85()

            if VRService.VREnabled then
                t10.DropDownFrame.DropDownFrameTextLabel.TextTransparency = 0.5
                t10.DropDownFrame.ImageTransparency = 0.5
                t10.DropDownImage.ImageTransparency = 0.5
            else
                t10.DropDownFrame.DropDownFrameTextLabel.TextTransparency = 0
                t10.DropDownFrame.ImageTransparency = 0
                t10.DropDownImage.ImageTransparency = 0
            end

            if not VRService.VREnabled then
                t10:SetZIndex(1)
            end
        end

        Enabled.Value = p100 and not v84
    end

    function t10.UpdateDropDownList(_, p102) -- line: 849
        -- upvalues: p82 (copy), v74 (copy), v75 (copy), v76 (copy), t10 (copy), BindableEvent (copy), v78 (copy), v79 (ref), v80 (copy), v82 (copy), v83 (copy), v85 (copy), DropDownFrameTextLabel (copy), GuiService (copy), UserInputService (copy), VRService (copy), t1 (copy)
        v79 = p102

        if t10.Selections then
            for i = 1, #t10.Selections do
                t10.Selections[i]:Destroy()
            end
        end

        t10.Selections = {}
        t10.SelectionInfo = {}

        local VREnabled = VRService.VREnabled
        local SourceSansBold = if VREnabled then Enum.Font.SourceSansBold or Enum.Font.SourceSans else Enum.Font.SourceSans
        local v100 = if VREnabled then 36 else 24
        local v99 = if VREnabled then 70 else 50
        local v101 = v99 + 1
        local v102 = if VREnabled then 600 else 400

        for v103, v104 in pairs(p102) do
            local v105 = t1.Create("Frame")({
                BackgroundTransparency = 0.7,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 1, 0)
            })
            local v106 = t1.Create("TextButton")({
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                AutoButtonColor = false,
                ZIndex = 10,
                Name = "Selection" .. tostring(v103),
                Size = UDim2.new(1, -28, 0, v99),
                Position = UDim2.new(0, 14, 0, (v103 - 1) * v101),
                TextColor3 = VRService.VREnabled and v75 or v74,
                Font = SourceSansBold,
                TextSize = v100,
                Text = v104,
                SelectionImageObject = v105,
                Parent = v83
            })

            if v103 == p82 then
                t10.CurrentIndex = v103
                DropDownFrameTextLabel.Text = v104
                v106.TextColor3 = v76
            elseif not p82 and v103 == 1 then
                v106.TextColor3 = v76
            end

            local function v107() -- line: 902
                -- upvalues: v103 (copy), v106 (copy), t10 (copy), BindableEvent (copy), v85 (copy), DropDownFrameTextLabel (copy)
                DropDownFrameTextLabel.Text = v106.Text
                v85()
                t10.CurrentIndex = v103
                BindableEvent:Fire(v103)
            end

            v106.MouseButton1Click:Connect(v107)
            v106.MouseEnter:Connect(function() -- line: 911
                -- upvalues: v106 (copy), GuiService (copy), UserInputService (copy), VRService (copy)
                if not VRService.VREnabled and (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) then
                    GuiService.SelectedCoreObject = v106
                end
            end)
            t10.Selections[v103] = v106
            t10.SelectionInfo[v106] = {
                Clicked = v107
            }
        end

        GuiService:RemoveSelectionGroup(v78)
        GuiService:AddSelectionTuple(v78, unpack(t10.Selections))
        v83.CanvasSize = UDim2.new(1, -20, 0, #p102 * v101)

        local function updateDropDownSize() -- line: 926
            -- upvalues: v102 (copy), v80 (copy), v82 (copy), v83 (copy)
            if v83.CanvasSize.Y.Offset < v80.AbsoluteSize.Y - 10 then
                v82.Size = UDim2.new(0, v102, 0, v83.CanvasSize.Y.Offset + 25)
            else
                v82.Size = UDim2.new(0, v102, 0.9, 0)
            end
        end

        v80.Changed:Connect(function(p103) -- line: 941
            -- upvalues: updateDropDownSize (copy)
            if p103 == "AbsoluteSize" then
                updateDropDownSize()
            end
        end)
        updateDropDownSize()
    end

    t10:UpdateDropDownList(p81)
    v80.MouseButton1Click:Connect(v85)
    p83.PoppedMenu:Connect(function(p104) -- line: 956
        -- upvalues: v80 (copy), v85 (copy)
        if p104 == v80 then
            v85()
        end
    end)

    return t10
end

local function CreateSelector(p105, p106) -- line: 965
    -- upvalues: v3 (copy), v4 (copy), v5 (copy), GuiService (copy), UserInputService (copy), VRService (copy), t1 (copy), t2 (copy), v12 (copy), EaseOutQuad (copy), getViewportSize (copy), addHoverState (copy)
    local n2 = 0
    local t12 = {
        HubRef = nil
    }

    if type(p105) ~= "table" then
        error("CreateSelector selectionStringTable (first arg) is not a table", 2)

        return t12
    end

    local BindableEvent = Instance.new("BindableEvent")

    BindableEvent.Name = "IndexChanged"

    local v108 = true

    t12.CurrentIndex = 0
    t12.SelectorFrame = t1.Create("ImageButton")({
        Name = "Selector",
        Image = "",
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        ZIndex = 2,
        NextSelectionLeft = t12.SelectorFrame,
        NextSelectionRight = t12.SelectorFrame,
        Size = UDim2.new(0.6, 0, 0, 50),
        Position = UDim2.new(1, 0, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        SelectionImageObject = v12
    })

    local v109 = t1.Create("ImageButton")({
        Name = "LeftButton",
        BackgroundTransparency = 1,
        Image = "",
        ZIndex = 3,
        Selectable = false,
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.new(0, 50, 0, 50),
        SelectionImageObject = v12,
        Parent = t12.SelectorFrame
    })
    local v110 = t1.Create("ImageButton")({
        Name = "RightButton",
        BackgroundTransparency = 1,
        Image = "",
        ZIndex = 3,
        Selectable = false,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.new(0, 50, 0, 50),
        SelectionImageObject = v12,
        Parent = t12.SelectorFrame
    })
    local v111 = t1.Create("ImageLabel")({
        Name = "LeftButton",
        BackgroundTransparency = 1,
        Image = "rbxasset://textures/ui/Settings/Slider/Left.png",
        ZIndex = 4,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 18, 0, 30),
        ImageColor3 = v3,
        Parent = v109
    })
    local v112 = t1.Create("ImageLabel")({
        Name = "RightButton",
        BackgroundTransparency = 1,
        Image = "rbxasset://textures/ui/Settings/Slider/Right.png",
        ZIndex = 4,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 18, 0, 30),
        ImageColor3 = v3,
        Parent = v110
    })

    if not UserInputService.TouchEnabled then
        local function v113(p107) -- line: 1050
            -- upvalues: v3 (copy)
            p107.ImageColor3 = v3
        end

        local function v114(p108) -- line: 1051
            -- upvalues: v4 (copy)
            p108.ImageColor3 = v4
        end

        addHoverState(v109, v111, v113, v114)
        addHoverState(v110, v112, v113, v114)
    end

    t12.Selections = {}

    local t13 = {}
    local t14 = {}
    local v115 = t1.Create("ImageButton")({
        Name = "AutoSelectButton",
        BackgroundTransparency = 1,
        Image = "",
        ZIndex = 2,
        Position = UDim2.new(0, v109.Size.X.Offset, 0, 0),
        Size = UDim2.new(1, v109.Size.X.Offset * -2, 1, 0),
        Parent = t12.SelectorFrame,
        SelectionImageObject = v12
    })

    v115.MouseButton1Click:Connect(function() -- line: 1070
        -- upvalues: t12 (copy), v108 (ref), GuiService (copy), UserInputService (copy), VRService (copy)
        if not v108 or #t12.Selections <= 1 then
            return
        end

        local v116 = t12.CurrentIndex + 1

        if #t12.Selections < v116 then
            v116 = 1
        end

        t12:SetSelectionIndex(v116)

        if not VRService.VREnabled and (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) then
            GuiService.SelectedCoreObject = t12.SelectorFrame
        end
    end)
    t14[v115] = true

    local function setSelection(p109, p110) -- line: 1089
        -- upvalues: t12 (copy), BindableEvent (copy), v109 (copy), t13 (ref), EaseOutQuad (copy)
        for v117, v118 in pairs(t12.Selections) do
            local v119 = v117 == p109
            local v120 = UDim2.new(0, v109.Size.X.Offset, 0, 0)
            local v121 = UDim2.new(0, v109.Size.X.Offset * p110 * 3, 0, 0)

            if t13[v118] then
                v121 = UDim2.new(0, v109.Size.X.Offset * -p110 * 3, 0, 0)
            end

            if v121.X.Offset < 0 then
                v121 = UDim2.new(0, v121.X.Offset + v118.AbsoluteSize.X / 4, 0, 0)
            end

            if v119 then
                local t15 = t13

                t15[v118] = true
                v118.Position = v121
                v118.Visible = true
                PropertyTweener(v118, "TextTransparency", 1, 0, 0.165, EaseOutQuad)

                if v118:IsDescendantOf(game) then
                    v118:TweenPosition(v120, Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.15, true)
                else
                    v118.Position = v120
                end

                t12.CurrentIndex = v117
                BindableEvent:Fire(p109)
            elseif t13[v118] then
                local t16 = t13

                t16[v118] = false
                PropertyTweener(v118, "TextTransparency", 0, 1, 0.165, EaseOutQuad)

                if v118:IsDescendantOf(game) then
                    v118:TweenPosition(v121, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.135, true)
                else
                    v118.Position = UDim2.new(v121)
                end
            end
        end
    end

    local function stepFunc(p111, p112) -- line: 1140
        -- upvalues: t12 (copy), v108 (ref), setSelection (copy), GuiService (copy), UserInputService (copy), VRService (copy)
        if not v108 or p111 ~= nil and p111.UserInputType ~= Enum.UserInputType.MouseButton1 and p111.UserInputType ~= Enum.UserInputType.Gamepad1 and p111.UserInputType ~= Enum.UserInputType.Gamepad2 and p111.UserInputType ~= Enum.UserInputType.Gamepad3 and p111.UserInputType ~= Enum.UserInputType.Gamepad4 and p111.UserInputType ~= Enum.UserInputType.Keyboard then
            return
        end

        if not VRService.VREnabled and (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) then
            GuiService.SelectedCoreObject = t12.SelectorFrame
        end

        local v122 = p112 + t12.CurrentIndex
        local v123 = if t12.CurrentIndex < v122 then 1 else -1

        if #t12.Selections < v122 then
            v122 = 1
        elseif v122 < 1 then
            v122 = #t12.Selections
        end

        setSelection(v122, v123)
    end

    local connection

    local function connectToGuiService() -- line: 1180
        -- upvalues: t12 (copy), t14 (copy), connection (ref), GuiService (copy), VRService (copy)
        connection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function() -- line: 1181
            -- upvalues: t12 (copy), t14 (copy), GuiService (copy), VRService (copy)
            if not (#t12.Selections <= 0) then
                if GuiService.SelectedCoreObject == t12.SelectorFrame then
                    t12.Selections[t12.CurrentIndex].TextTransparency = 0
                elseif GuiService.SelectedCoreObject == nil or not t14[GuiService.SelectedCoreObject] then
                    t12.Selections[t12.CurrentIndex].TextTransparency = 0.5
                elseif VRService.VREnabled then
                    t12.Selections[t12.CurrentIndex].TextTransparency = 0
                else
                    GuiService.SelectedCoreObject = t12.SelectorFrame
                end
            end
        end)
    end

    t12.IndexChanged = BindableEvent.Event

    function t12.SetSelectionIndex(_, p114) -- line: 1207
        -- upvalues: setSelection (copy)
        setSelection(p114, 1)
    end

    function t12.GetSelectedIndex(_) -- line: 1209
        -- upvalues: t12 (copy)
        return t12.CurrentIndex
    end

    function t12.SetZIndex(_, p117) -- line: 1211
        -- upvalues: t12 (copy), v109 (copy), v110 (copy), v111 (copy), v112 (copy)
        v109.ZIndex = p117
        v110.ZIndex = p117
        v111.ZIndex = p117
        v112.ZIndex = p117

        for i = 1, #t12.Selections do
            t12.Selections[i].ZIndex = p117
        end
    end

    function t12.SetInteractable(_, p119) -- line: 1222
        -- upvalues: t12 (copy), v108 (ref), v109 (copy), v110 (copy), v111 (copy), v112 (copy), v3 (copy), v5 (copy)
        v108 = p119
        t12.SelectorFrame.Selectable = v108
        v109.Active = v108
        v110.Active = v108

        if v108 then
            for _, v124 in pairs(t12.Selections) do
                v124.TextColor3 = Color3.fromRGB(255, 255, 255)
            end

            v111.ImageColor3 = v3
            v112.ImageColor3 = v3
        else
            for _, v125 in pairs(t12.Selections) do
                v125.TextColor3 = Color3.fromRGB(49, 49, 49)
            end

            v111.ImageColor3 = v5
            v112.ImageColor3 = v5
        end
    end

    function t12.UpdateOptions(_, p121) -- line: 1244
        -- upvalues: p106 (copy), t12 (copy), v109 (copy), v110 (copy), t13 (ref), t1 (copy)
        for _, v126 in pairs(t12.Selections) do
            v126:Destroy()
        end

        t13 = {}
        t12.Selections = {}

        for v127, v128 in pairs(p121) do
            local v129 = t1.Create("TextLabel")({
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                TextTransparency = 0.5,
                TextSize = 24,
                ZIndex = 2,
                Visible = false,
                Name = "Selection" .. tostring(v127),
                Size = UDim2.new(1, v109.Size.X.Offset * -2, 1, 0),
                Position = UDim2.new(1, 0, 0, 0),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextYAlignment = Enum.TextYAlignment.Center,
                Font = Enum.Font.SourceSans,
                Text = v128,
                Parent = t12.SelectorFrame
            })

            if v127 == p106 then
                t12.CurrentIndex = v127
                v129.Position = UDim2.new(0, v109.Size.X.Offset, 0, 0)
                v129.Visible = true
                t13[v129] = true
            else
                t13[v129] = false
            end

            t12.Selections[v127] = v129
        end

        local v130 = #t12.Selections > 1

        v109.Visible = v130
        v110.Visible = v130
    end

    local function onVREnabled(p122) -- line: 1292
        -- upvalues: v109 (copy), v110 (copy), v115 (copy), VRService (copy)
        if p122 ~= "VREnabled" then
            return
        end

        local VREnabled = VRService.VREnabled

        v109.Selectable = VREnabled
        v110.Selectable = VREnabled
        v115.Selectable = VREnabled
    end

    VRService.Changed:Connect(onVREnabled)

    local VREnabled = VRService.VREnabled

    v109.Selectable = VREnabled
    v110.Selectable = VREnabled
    v115.Selectable = VREnabled
    v109.InputBegan:Connect(function(p123) -- line: 1304
        -- upvalues: t12 (copy), v108 (ref), setSelection (copy), GuiService (copy), UserInputService (copy), VRService (copy)
        if p123.UserInputType ~= Enum.UserInputType.Touch or not v108 then
            return
        end

        if not VRService.VREnabled and (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) then
            GuiService.SelectedCoreObject = t12.SelectorFrame
        end

        local v131 = -1 + t12.CurrentIndex
        local v132 = if t12.CurrentIndex < v131 then 1 else -1

        if #t12.Selections < v131 then
            v131 = 1
        elseif v131 < 1 then
            v131 = #t12.Selections
        end

        setSelection(v131, v132)
    end)
    v109.MouseButton1Click:Connect(function() -- line: 1309
        -- upvalues: t12 (copy), v108 (ref), setSelection (copy), GuiService (copy), UserInputService (copy), VRService (copy)
        if UserInputService.TouchEnabled or not v108 then
            return
        end

        if not VRService.VREnabled and (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) then
            GuiService.SelectedCoreObject = t12.SelectorFrame
        end

        local v133 = -1 + t12.CurrentIndex
        local v134 = if t12.CurrentIndex < v133 then 1 else -1

        if #t12.Selections < v133 then
            v133 = 1
        elseif v133 < 1 then
            v133 = #t12.Selections
        end

        setSelection(v133, v134)
    end)
    v110.InputBegan:Connect(function(p124) -- line: 1314
        -- upvalues: t12 (copy), v108 (ref), setSelection (copy), GuiService (copy), UserInputService (copy), VRService (copy)
        if p124.UserInputType ~= Enum.UserInputType.Touch or not v108 then
            return
        end

        if not VRService.VREnabled and (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) then
            GuiService.SelectedCoreObject = t12.SelectorFrame
        end

        local v135 = 1 + t12.CurrentIndex
        local v136 = if t12.CurrentIndex < v135 then 1 else -1

        if #t12.Selections < v135 then
            v135 = 1
        elseif v135 < 1 then
            v135 = #t12.Selections
        end

        setSelection(v135, v136)
    end)
    v110.MouseButton1Click:Connect(function() -- line: 1319
        -- upvalues: t12 (copy), v108 (ref), setSelection (copy), GuiService (copy), UserInputService (copy), VRService (copy)
        if UserInputService.TouchEnabled or not v108 then
            return
        end

        if not VRService.VREnabled and (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) then
            GuiService.SelectedCoreObject = t12.SelectorFrame
        end

        local v137 = 1 + t12.CurrentIndex
        local v138 = if t12.CurrentIndex < v137 then 1 else -1

        if #t12.Selections < v137 then
            v137 = 1
        elseif v137 < 1 then
            v137 = #t12.Selections
        end

        setSelection(v137, v138)
    end)

    local v139 = true

    t12:UpdateOptions(p105)
    UserInputService.InputBegan:Connect(function(p125) -- line: 1328
        -- upvalues: t12 (copy), v108 (ref), setSelection (copy), v139 (ref), GuiService (copy), UserInputService (copy), VRService (copy)
        if not v108 or not v139 or p125.UserInputType ~= Enum.UserInputType.Gamepad1 and p125.UserInputType ~= Enum.UserInputType.Keyboard or GuiService.SelectedCoreObject ~= t12.SelectorFrame then
            return
        end

        if p125.KeyCode ~= Enum.KeyCode.DPadLeft and p125.KeyCode ~= Enum.KeyCode.Left and p125.KeyCode ~= Enum.KeyCode.A then
            if p125.KeyCode ~= Enum.KeyCode.DPadRight and p125.KeyCode ~= Enum.KeyCode.Right and p125.KeyCode ~= Enum.KeyCode.D then
                return
            end

            if v108 then
                if p125 ~= nil and p125.UserInputType ~= Enum.UserInputType.MouseButton1 and p125.UserInputType ~= Enum.UserInputType.Gamepad1 and p125.UserInputType ~= Enum.UserInputType.Gamepad2 and p125.UserInputType ~= Enum.UserInputType.Gamepad3 and p125.UserInputType ~= Enum.UserInputType.Gamepad4 and p125.UserInputType ~= Enum.UserInputType.Keyboard then
                    return
                end

                if not VRService.VREnabled and (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) then
                    GuiService.SelectedCoreObject = t12.SelectorFrame
                end

                local v140 = 1 + t12.CurrentIndex
                local v141 = if t12.CurrentIndex < v140 then 1 else -1

                if #t12.Selections < v140 then
                    v140 = 1
                elseif v140 < 1 then
                    v140 = #t12.Selections
                end

                setSelection(v140, v141)
            end
        elseif v108 then
            if p125 ~= nil and p125.UserInputType ~= Enum.UserInputType.MouseButton1 and p125.UserInputType ~= Enum.UserInputType.Gamepad1 and p125.UserInputType ~= Enum.UserInputType.Gamepad2 and p125.UserInputType ~= Enum.UserInputType.Gamepad3 and p125.UserInputType ~= Enum.UserInputType.Gamepad4 and p125.UserInputType ~= Enum.UserInputType.Keyboard then
                return
            end

            if not VRService.VREnabled and (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) then
                GuiService.SelectedCoreObject = t12.SelectorFrame
            end

            local v142 = -1 + t12.CurrentIndex
            local v143 = if t12.CurrentIndex < v142 then 1 else -1

            if #t12.Selections < v142 then
                v142 = 1
            elseif v142 < 1 then
                v142 = #t12.Selections
            end

            setSelection(v142, v143)
        end
    end)
    UserInputService.InputChanged:Connect(function(p126) -- line: 1361
        -- upvalues: n2 (ref), t12 (copy), v108 (ref), stepFunc (copy), v139 (ref), GuiService (copy)
        if v108 then
            if v139 then
                if p126.UserInputType == Enum.UserInputType.Gamepad1 then
                    local SelectedCoreObject = GuiService.SelectedCoreObject

                    if SelectedCoreObject and SelectedCoreObject:IsDescendantOf(t12.SelectorFrame.Parent) and p126.KeyCode == Enum.KeyCode.Thumbstick1 then
                        if p126.Position.X > 0.8 and p126.Delta.X > 0 and n2 ~= 1 then
                            n2 = 1
                            stepFunc(p126, n2)
                        elseif p126.Position.X < -0.8 and p126.Delta.X < 0 and n2 ~= -1 then
                            n2 = -1
                            stepFunc(p126, n2)
                        elseif math.abs(p126.Position.X) < 0.8 then
                            n2 = 0
                        end
                    end
                end
            else
                n2 = 0
            end
        end
    end)
    t12.SelectorFrame.AncestryChanged:Connect(function(_, p128) -- line: 1402
        -- upvalues: t12 (copy), t14 (copy), connection (ref), v139 (ref), GuiService (copy), VRService (copy)
        v139 = p128

        local v144 = v139
        local connection2

        if v144 then
            connection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function() -- line: 1181
                -- upvalues: t12 (copy), t14 (copy), GuiService (copy), VRService (copy)
                if not (#t12.Selections <= 0) then
                    if GuiService.SelectedCoreObject == t12.SelectorFrame then
                        t12.Selections[t12.CurrentIndex].TextTransparency = 0
                    elseif GuiService.SelectedCoreObject == nil or not t14[GuiService.SelectedCoreObject] then
                        t12.Selections[t12.CurrentIndex].TextTransparency = 0.5
                    elseif VRService.VREnabled then
                        t12.Selections[t12.CurrentIndex].TextTransparency = 0
                    else
                        GuiService.SelectedCoreObject = t12.SelectorFrame
                    end
                end
            end)
        else
            connection2 = connection
        end

        if (v144 or connection2) and not v144 then
            connection:Disconnect()
        end
    end)

    local function onResized(_, p130) -- line: 1413
        -- upvalues: t12 (copy)
        local v145 = if p130 then 16 else 24

        for _, v146 in pairs(t12.Selections) do
            v146.TextSize = v145
        end
    end

    t2[t12.SelectorFrame] = onResized
    getViewportSize()

    local v147 = getViewportSize()
    local v148 = if v147.Y > v147.X then 16 else 24

    for _, v149 in pairs(t12.Selections) do
        v149.TextSize = v148
    end

    connection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function() -- line: 1181
        -- upvalues: t12 (copy), t14 (copy), GuiService (copy), VRService (copy)
        if not (#t12.Selections <= 0) then
            if GuiService.SelectedCoreObject == t12.SelectorFrame then
                t12.Selections[t12.CurrentIndex].TextTransparency = 0
            elseif GuiService.SelectedCoreObject == nil or not t14[GuiService.SelectedCoreObject] then
                t12.Selections[t12.CurrentIndex].TextTransparency = 0.5
            elseif VRService.VREnabled then
                t12.Selections[t12.CurrentIndex].TextTransparency = 0
            else
                GuiService.SelectedCoreObject = t12.SelectorFrame
            end
        end
    end)

    return t12
end

local function ShowAlert(p131, p132, p133, p134, p135) -- line: 1432
    -- upvalues: GuiService (copy), HttpService (copy), UserInputService (copy), PlayerGui (copy), ContextActionService (copy), VRService (copy), t1 (copy), MakeButton (copy)
    local RobloxGui = PlayerGui.RobloxGui
    local v150 = RobloxGui

    if RobloxGui:FindFirstChild("AlertViewFullScreen") then
        return
    end

    local v151

    local function onVREnabled(p136) -- line: 1443
        -- upvalues: v150 (ref), v151 (ref), PlayerGui (copy), VRService (copy)
        if p136 ~= "VREnabled" then
            return
        end

        local SettingsMenu

        if VRService.VREnabled then
            SettingsMenu = require(PlayerGui.RobloxGui.Modules.VR.Panel3D).Get("SettingsMenu")
            v150 = SettingsMenu:GetGUI()
        else
            v150 = PlayerGui.RobloxGui
        end

        if v151 and v151.Parent ~= nil then
            v151.Parent = v150

            if VRService.VREnabled then
                SettingsMenu:SetSubpanelDepth(v151, 0.5)
            end
        end
    end

    local connection = VRService.Changed:Connect(onVREnabled)

    Color3.fromRGB(59, 166, 241)
    Color3.fromRGB(255, 255, 255)
    v151 = t1.Create("ImageLabel")({
        Name = "AlertViewBacking",
        Image = "rbxasset://textures/ui/Settings/MenuBarAssets/MenuButton.png",
        BackgroundTransparency = 1,
        ImageTransparency = 1,
        ZIndex = 9,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(8, 6, 46, 44),
        Size = UDim2.new(0, 400, 0, 350),
        Position = UDim2.new(0.5, -200, 0.5, -175),
        Parent = v150
    })
    onVREnabled("VREnabled")

    if p135 or VRService.VREnabled then
        v151.ImageTransparency = 0
    else
        local v153 = UDim2.new(0.8, 0, 0, 350)

        v151.Size = v153

        local v154 = UDim2.new(0.1, 0, 0.1, 0)

        v151.Position = v154
    end

    if PlayerGui.RobloxGui.AbsoluteSize.Y <= v151.Size.Y.Offset then
        local v155 = UDim2.new(v151.Size.X.Scale, v151.Size.X.Offset, v151.Size.Y.Scale, PlayerGui.RobloxGui.AbsoluteSize.Y)

        v151.Size = v155

        local v156 = UDim2.new(v151.Position.X.Scale, -v151.Size.X.Offset / 2, 0.5, -v151.Size.Y.Offset / 2)

        v151.Position = v156
    end

    t1.Create("TextLabel")({
        Name = "AlertViewText",
        BackgroundTransparency = 1,
        TextSize = 36,
        TextWrapped = true,
        ZIndex = 10,
        Size = UDim2.new(0.95, 0, 0.6, 0),
        Position = UDim2.new(0.025, 0, 0.05, 0),
        Font = Enum.Font.SourceSansBold,
        Text = p131,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
        Parent = v151
    })
    t1.Create("ImageLabel")({
        Image = "",
        BackgroundTransparency = 1
    })

    local v157 = HttpService:GenerateGUID(false)

    local function v158(_, p138) -- line: 1526
        -- upvalues: p133 (copy), p134 (copy), v151 (ref), connection (copy), v157 (copy), GuiService (copy), PlayerGui (copy), ContextActionService (copy), VRService (copy)
        if VRService.VREnabled and (p138 == Enum.UserInputState.Begin or p138 == Enum.UserInputState.Cancel) or not v151 then
            return
        end

        if VRService.VREnabled then
            local SettingsMenu = require(PlayerGui.RobloxGui.Modules.VR.Panel3D).Get("SettingsMenu")

            SettingsMenu:SetSubpanelDepth(v151, 0)
        end

        v151:Destroy()
        v151 = nil

        if p134 then
            p134()
        end

        ContextActionService:UnbindAction(v157)
        GuiService.SelectedCoreObject = nil

        if p133 then
            p133:ShowBar()
        end

        if connection then
            connection:Disconnect()
        end
    end

    local v160 = UDim2.new(1, -20, 0, 60)
    local v161 = UDim2.new(0, 10, 0.65, 0)

    if not p135 then
        v160 = UDim2.new(0, 200, 0, 50)
        v161 = UDim2.new(0.5, -100, 0.65, 0)
    end

    local v162, v163 = MakeButton("AlertViewButton", p132, v160, v158)

    v162.Position = v161
    v162.NextSelectionLeft = v162
    v162.NextSelectionRight = v162
    v162.NextSelectionUp = v162
    v162.NextSelectionDown = v162
    v162.ZIndex = 9
    v163.ZIndex = v162.ZIndex
    v162.Parent = v151

    if not VRService.VREnabled and (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) then
        GuiService.SelectedCoreObject = v162
    end

    GuiService.SelectedCoreObject = v162
    ContextActionService:BindActionAtPriority(v157, v158, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.Escape, Enum.KeyCode.ButtonB, Enum.KeyCode.ButtonA)

    if p133 and not VRService.VREnabled then
        p133:HideBar()
        p133.Pages.CurrentPage:Hide(1, 1)
    end
end

local function CreateNewSlider(p139, p140, p141) -- line: 1595
    -- upvalues: v1 (copy), v2 (copy), v3 (copy), v4 (copy), GuiService (copy), HttpService (copy), RunService (copy), UserInputService (copy), VRService (copy), t1 (copy), v12 (copy), getViewportSize (copy), addHoverState (copy)
    local t19 = {}
    local v164 = tonumber(p139)
    local v165 = p140
    local n3 = 0
    local v166
    local v167 = true
    local v168 = HttpService:GenerateGUID(false)

    if not (v164 <= 0) then
        local BindableEvent = Instance.new("BindableEvent")

        BindableEvent.Name = "ValueChanged"
        t19.SliderFrame = t1.Create("ImageButton")({
            Name = "Slider",
            Image = "",
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            ZIndex = 2,
            NextSelectionLeft = t19.SliderFrame,
            NextSelectionRight = t19.SliderFrame,
            Size = UDim2.new(0.6, 0, 0, 50),
            Position = UDim2.new(1, 0, 0.5, 0),
            AnchorPoint = Vector2.new(1, 0.5),
            SelectionImageObject = v12
        })
        t19.StepsContainer = t1.Create("Frame")({
            Name = "StepsContainer",
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(1, -100, 1, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Parent = t19.SliderFrame
        })

        local v169 = t1.Create("ImageButton")({
            Name = "LeftButton",
            BackgroundTransparency = 1,
            Image = "",
            ZIndex = 3,
            Selectable = false,
            Active = true,
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.new(0, 50, 0, 50),
            SelectionImageObject = v12,
            Parent = t19.SliderFrame
        })
        local v170 = t1.Create("ImageButton")({
            Name = "RightButton",
            BackgroundTransparency = 1,
            Image = "",
            ZIndex = 3,
            Selectable = false,
            Active = true,
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, 0, 0.5, 0),
            Size = UDim2.new(0, 50, 0, 50),
            SelectionImageObject = v12,
            Parent = t19.SliderFrame
        })
        local v171 = t1.Create("ImageLabel")({
            Name = "LeftButton",
            BackgroundTransparency = 1,
            Image = "rbxasset://textures/ui/Settings/Slider/Less.png",
            ZIndex = 4,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(0, 30, 0, 30),
            Parent = v169,
            ImageColor3 = UserInputService.TouchEnabled and v4 or v3
        })
        local v172 = t1.Create("ImageLabel")({
            Name = "RightButton",
            BackgroundTransparency = 1,
            Image = "rbxasset://textures/ui/Settings/Slider/More.png",
            ZIndex = 4,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(0, 30, 0, 30),
            Parent = v170,
            ImageColor3 = UserInputService.TouchEnabled and v4 or v3
        })

        if not UserInputService.TouchEnabled then
            local function v173(p142) -- line: 1701
                -- upvalues: v3 (copy)
                p142.ImageColor3 = v3
            end

            local function v174(p143) -- line: 1702
                -- upvalues: v4 (copy)
                p143.ImageColor3 = v4
            end

            addHoverState(v169, v171, v173, v174)
            addHoverState(v170, v172, v173, v174)
        end

        t19.Steps = {}

        local v175 = getViewportSize()

        if UserInputService.TouchEnabled and not (v175.Y < 500) then
            local _ = v175.X < 700
        end

        local v176 = 1 / v164

        for i = 1, v164 do
            local v177 = t1.Create("ImageButton")({
                BackgroundTransparency = 0.36,
                BorderSizePixel = 0,
                AutoButtonColor = false,
                Active = false,
                Image = "",
                ZIndex = 3,
                Selectable = false,
                ImageTransparency = 0.36,
                Name = "Step" .. tostring(i),
                BackgroundColor3 = v1,
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.new((i - 1) * v176, 2, 0.5, 0),
                Size = UDim2.new(v176, -4, 0.48, 0),
                Parent = t19.StepsContainer,
                SelectionImageObject = v12
            })

            if p140 < i then
                v177.BackgroundColor3 = v2
            end

            if i == 1 or i == v164 then
                v177.BackgroundTransparency = 1
                v177.ScaleType = Enum.ScaleType.Slice
                v177.SliceCenter = Rect.new(3, 3, 32, 21)

                if i <= p140 then
                    if i == 1 then
                        v177.Image = "rbxasset://textures/ui/Settings/Slider/SelectedBarLeft.png"
                    else
                        v177.Image = "rbxasset://textures/ui/Settings/Slider/SelectedBarRight.png"
                    end
                elseif i == 1 then
                    v177.Image = "rbxasset://textures/ui/Settings/Slider/BarLeft.png"
                else
                    v177.Image = "rbxasset://textures/ui/Settings/Slider/BarRight.png"
                end
            end

            t19.Steps[#t19.Steps + 1] = v177
        end

        local function hideSelection() -- line: 1764
            -- upvalues: t19 (copy), v164 (copy), v2 (copy)
            for i = 1, v164 do
                t19.Steps[i].BackgroundColor3 = v2

                if i == 1 then
                    t19.Steps[i].Image = "rbxasset://textures/ui/Settings/Slider/BarLeft.png"
                elseif i == v164 then
                    t19.Steps[i].Image = "rbxasset://textures/ui/Settings/Slider/BarRight.png"
                end
            end
        end

        local function showSelection() -- line: 1774
            -- upvalues: t19 (copy), v164 (copy), v165 (ref), v1 (copy)
            for i = 1, v164 do
                if v165 < i then
                    break
                end

                t19.Steps[i].BackgroundColor3 = v1

                if i == 1 then
                    t19.Steps[i].Image = "rbxasset://textures/ui/Settings/Slider/SelectedBarLeft.png"
                elseif i == v164 then
                    t19.Steps[i].Image = "rbxasset://textures/ui/Settings/Slider/SelectedBarRight.png"
                end
            end
        end

        local function modifySelection(p144) -- line: 1787
            -- upvalues: t19 (copy), v164 (copy)
            for i = 1, v164 do
                if i == 1 or i == v164 then
                    t19.Steps[i].ImageTransparency = p144
                else
                    t19.Steps[i].BackgroundTransparency = p144
                end
            end
        end

        local function setCurrentStep(p145) -- line: 1797
            -- upvalues: p141 (ref), v164 (copy), v165 (ref), v166 (ref), BindableEvent (copy), v169 (copy), v170 (copy), hideSelection (copy), showSelection (copy)
            p141 = p141 or 0
            v169.Visible = true
            v170.Visible = true

            local v178 = p145

            if p145 <= p141 then
                v178 = p141
                v169.Visible = false
            end

            if v164 <= v178 then
                v178 = v164
                v170.Visible = false
            end

            if v165 == v178 then
                return
            end

            v165 = v178
            hideSelection()
            showSelection()
            v166 = tick()
            BindableEvent:Fire(v165)
        end

        local function isActivateEvent(p146) -- line: 1827
            if not p146 then
                return false
            end

            if p146.UserInputType == Enum.UserInputType.MouseButton1 or p146.UserInputType == Enum.UserInputType.Touch then
                return true
            end

            if p146.UserInputType == Enum.UserInputType.Gamepad1 then
                return p146.KeyCode == Enum.KeyCode.ButtonA
            end

            return false
        end

        local function mouseDownFunc(p147, p148, p149) -- line: 1838
            -- upvalues: t19 (copy), v164 (copy), v165 (ref), n3 (ref), v167 (ref), setCurrentStep (copy), GuiService (copy), UserInputService (copy), VRService (copy)
            if not v167 or p147 == nil or not p147 or p147.UserInputType ~= Enum.UserInputType.MouseButton1 and p147.UserInputType ~= Enum.UserInputType.Touch and (p147.UserInputType ~= Enum.UserInputType.Gamepad1 or p147.KeyCode ~= Enum.KeyCode.ButtonA) then
                return
            end

            if not VRService.VREnabled and not not (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) and not VRService.VREnabled then
                GuiService.SelectedCoreObject = t19.SliderFrame
            end

            if VRService.VREnabled then
                n3 = 0
            elseif p149 then
                n3 = p148 - v165
            else
                n3 = 0

                local connection
                local connection2 = UserInputService.InputChanged:Connect(function(p150) -- line: 1864
                    -- upvalues: t19 (copy), v164 (copy), setCurrentStep (copy)
                    if p150.UserInputType ~= Enum.UserInputType.MouseMovement then
                        return
                    end

                    local X = p150.Position.X

                    for i = 1, v164 do
                        local X2 = t19.Steps[i].AbsolutePosition.X
                        local X3 = t19.Steps[i].AbsoluteSize.X

                        if X2 <= X and X <= X2 + X3 then
                            setCurrentStep(i)

                            return
                        end

                        if i == 1 and X < X2 then
                            setCurrentStep(0)

                            return
                        end

                        if i == v164 and X2 <= X then
                            setCurrentStep(i)

                            return
                        end
                    end
                end)

                connection = UserInputService.InputEnded:Connect(function(p151) -- line: 1885
                    -- upvalues: connection (ref), connection2 (copy), n3 (ref)
                    if not (p151 and (p151.UserInputType == Enum.UserInputType.MouseButton1 or p151.UserInputType == Enum.UserInputType.Touch or p151.UserInputType == Enum.UserInputType.Gamepad1 and p151.KeyCode == Enum.KeyCode.ButtonA)) then
                        return
                    end

                    n3 = 0
                    connection:Disconnect()
                    connection2:Disconnect()
                end)
            end

            setCurrentStep(p148)
        end

        local function mouseUpFunc(p152) -- line: 1902
            -- upvalues: n3 (ref), v167 (ref)
            if v167 and p152 and (p152.UserInputType == Enum.UserInputType.MouseButton1 or p152.UserInputType == Enum.UserInputType.Touch or p152.UserInputType == Enum.UserInputType.Gamepad1 and p152.KeyCode == Enum.KeyCode.ButtonA) then
                n3 = 0
            end
        end

        local function touchClickFunc(p153, p154, p155) -- line: 1913
            -- upvalues: mouseDownFunc (copy)
            mouseDownFunc(p153, p154, p155)
        end

        t19.ValueChanged = BindableEvent.Event

        function t19.SetValue(_, p157) -- line: 1920
            -- upvalues: setCurrentStep (copy)
            setCurrentStep(p157)
        end

        function t19.GetValue(_) -- line: 1922
            -- upvalues: v165 (ref)
            return v165
        end

        function t19.SetInteractable(_, p160) -- line: 1924
            -- upvalues: t19 (copy), n3 (ref), v167 (ref), hideSelection (copy), showSelection (copy)
            n3 = 0
            v167 = p160
            t19.SliderFrame.Selectable = p160

            if v167 then
                showSelection()
            else
                hideSelection()
            end
        end

        function t19.SetZIndex(_, p162) -- line: 1935
            -- upvalues: t19 (copy), v169 (copy), v170 (copy), v171 (copy), v172 (copy)
            v169.ZIndex = p162
            v170.ZIndex = p162
            v171.ZIndex = p162
            v172.ZIndex = p162

            for i = 1, #t19.Steps do
                t19.Steps[i].ZIndex = p162
            end
        end

        function t19.SetMinStep(_, p164) -- line: 1946
            -- upvalues: p141 (ref), v164 (copy), v165 (ref), v169 (copy), v170 (copy)
            if p164 >= 0 and p164 <= v164 then
                p141 = p164
            end

            if v165 <= p141 then
                v165 = p141
                v169.Visible = false
            end

            if v165 >= v164 then
                v165 = v164
                v170.Visible = false
            end
        end

        v169.InputBegan:Connect(function(p165) -- line: 1964
            -- upvalues: t19 (copy), v165 (ref), n3 (ref), v167 (ref), setCurrentStep (copy), GuiService (copy), UserInputService (copy), VRService (copy)
            local v180 = v165 - 1

            if v167 and p165 ~= nil and p165 and (p165.UserInputType == Enum.UserInputType.MouseButton1 or p165.UserInputType == Enum.UserInputType.Touch or p165.UserInputType == Enum.UserInputType.Gamepad1 and p165.KeyCode == Enum.KeyCode.ButtonA) then
                if not VRService.VREnabled and not not (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) and not VRService.VREnabled then
                    GuiService.SelectedCoreObject = t19.SliderFrame
                end

                n3 = if VRService.VREnabled then 0 else v180 - v165
                setCurrentStep(v180)
            end
        end)
        v169.InputEnded:Connect(function(p166) -- line: 1966
            -- upvalues: n3 (ref), v167 (ref)
            if v167 and p166 and (p166.UserInputType == Enum.UserInputType.MouseButton1 or p166.UserInputType == Enum.UserInputType.Touch or p166.UserInputType == Enum.UserInputType.Gamepad1 and p166.KeyCode == Enum.KeyCode.ButtonA) then
                n3 = 0
            end
        end)
        v170.InputBegan:Connect(function(p167) -- line: 1968
            -- upvalues: t19 (copy), v165 (ref), n3 (ref), v167 (ref), setCurrentStep (copy), GuiService (copy), UserInputService (copy), VRService (copy)
            local v181 = v165 + 1

            if v167 and p167 ~= nil and p167 and (p167.UserInputType == Enum.UserInputType.MouseButton1 or p167.UserInputType == Enum.UserInputType.Touch or p167.UserInputType == Enum.UserInputType.Gamepad1 and p167.KeyCode == Enum.KeyCode.ButtonA) then
                if not VRService.VREnabled and not not (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) and not VRService.VREnabled then
                    GuiService.SelectedCoreObject = t19.SliderFrame
                end

                n3 = if VRService.VREnabled then 0 else v181 - v165
                setCurrentStep(v181)
            end
        end)
        v170.InputEnded:Connect(function(p168) -- line: 1970
            -- upvalues: n3 (ref), v167 (ref)
            if v167 and p168 and (p168.UserInputType == Enum.UserInputType.MouseButton1 or p168.UserInputType == Enum.UserInputType.Touch or p168.UserInputType == Enum.UserInputType.Gamepad1 and p168.KeyCode == Enum.KeyCode.ButtonA) then
                n3 = 0
            end
        end)

        local function onVREnabled(p169) -- line: 1972
            -- upvalues: t19 (copy), v164 (copy), v167 (ref), v169 (copy), v170 (copy), VRService (copy)
            if p169 ~= "VREnabled" then
                return
            end

            if VRService.VREnabled then
                v169.Selectable = v167
                v170.Selectable = v167
                t19.SliderFrame.Selectable = v167

                for i = 1, v164 do
                    t19.Steps[i].Selectable = v167
                    t19.Steps[i].Active = v167
                end
            else
                v169.Selectable = false
                v170.Selectable = false
                t19.SliderFrame.Selectable = v167

                for i = 1, v164 do
                    t19.Steps[i].Selectable = false
                    t19.Steps[i].Active = false
                end
            end
        end

        VRService.Changed:Connect(onVREnabled)
        onVREnabled("VREnabled")

        for i = 1, v164 do
            t19.Steps[i].InputBegan:Connect(function(p170) -- line: 1999
                -- upvalues: mouseDownFunc (copy), i (copy)
                mouseDownFunc(p170, i)
            end)
            t19.Steps[i].InputEnded:Connect(function(p171) -- line: 2000
                -- upvalues: n3 (ref), v167 (ref)
                if v167 and p171 and (p171.UserInputType == Enum.UserInputType.MouseButton1 or p171.UserInputType == Enum.UserInputType.Touch or p171.UserInputType == Enum.UserInputType.Gamepad1 and p171.KeyCode == Enum.KeyCode.ButtonA) then
                    n3 = 0
                end
            end)
        end

        t19.SliderFrame.InputBegan:Connect(function(p172) -- line: 2003
            -- upvalues: t19 (copy), v165 (ref), mouseDownFunc (copy), GuiService (copy), VRService (copy)
            if VRService.VREnabled then
                local SelectedCoreObject = GuiService.SelectedCoreObject

                if not SelectedCoreObject or not SelectedCoreObject:IsDescendantOf(t19.SliderFrame.Parent) then
                    return
                end
            end

            mouseDownFunc(p172, v165)
        end)
        t19.SliderFrame.InputEnded:Connect(function(p173) -- line: 2012
            -- upvalues: t19 (copy), n3 (ref), v167 (ref), GuiService (copy), VRService (copy)
            if VRService.VREnabled then
                local SelectedCoreObject = GuiService.SelectedCoreObject

                if not SelectedCoreObject or not SelectedCoreObject:IsDescendantOf(t19.SliderFrame.Parent) then
                    return
                end
            end

            if v167 and p173 and (p173.UserInputType == Enum.UserInputType.MouseButton1 or p173.UserInputType == Enum.UserInputType.Touch or p173.UserInputType == Enum.UserInputType.Gamepad1 and p173.KeyCode == Enum.KeyCode.ButtonA) then
                n3 = 0
            end
        end)

        local function v182() -- line: 2022
            -- upvalues: v165 (ref), n3 (ref), v166 (ref), setCurrentStep (copy)
            if v166 ~= nil and tick() - v166 >= 0.2 then
                setCurrentStep(v165 + n3)
            end
        end

        local v183 = true
        local t22 = {
            [Enum.KeyCode.Thumbstick1] = true,
            [Enum.KeyCode.DPadLeft] = -1,
            [Enum.KeyCode.DPadRight] = 1,
            [Enum.KeyCode.Left] = -1,
            [Enum.KeyCode.Right] = 1,
            [Enum.KeyCode.A] = -1,
            [Enum.KeyCode.D] = 1,
            [Enum.KeyCode.ButtonA] = true
        }

        UserInputService.InputBegan:Connect(function(p174) -- line: 2048
            -- upvalues: t19 (copy), v165 (ref), n3 (ref), v167 (ref), setCurrentStep (copy), v183 (ref), t22 (copy), GuiService (copy)
            if v167 and v183 and (p174.UserInputType == Enum.UserInputType.Gamepad1 or p174.UserInputType == Enum.UserInputType.Keyboard) then
                local SelectedCoreObject = GuiService.SelectedCoreObject

                if SelectedCoreObject and SelectedCoreObject:IsDescendantOf(t19.SliderFrame.Parent) then
                    if t22[p174.KeyCode] == -1 then
                        n3 = -1
                        setCurrentStep(v165 - 1)
                    elseif t22[p174.KeyCode] == 1 then
                        n3 = 1
                        setCurrentStep(v165 + 1)
                    end
                end
            end
        end)
        UserInputService.InputEnded:Connect(function(p175) -- line: 2076
            -- upvalues: t19 (copy), n3 (ref), v167 (ref), t22 (copy), GuiService (copy)
            if v167 and (p175.UserInputType == Enum.UserInputType.Gamepad1 or p175.UserInputType == Enum.UserInputType.Keyboard) then
                local SelectedCoreObject = GuiService.SelectedCoreObject

                if SelectedCoreObject and SelectedCoreObject:IsDescendantOf(t19.SliderFrame.Parent) and t22[p175.KeyCode] then
                    n3 = 0
                end
            end
        end)
        UserInputService.InputChanged:Connect(function(p176) -- line: 2097
            -- upvalues: t19 (copy), v165 (ref), n3 (ref), v167 (ref), setCurrentStep (copy), v183 (ref), GuiService (copy)
            if v167 and v183 then
                if p176.UserInputType == Enum.UserInputType.Gamepad1 then
                    local SelectedCoreObject = GuiService.SelectedCoreObject

                    if SelectedCoreObject and SelectedCoreObject:IsDescendantOf(t19.SliderFrame.Parent) and p176.KeyCode == Enum.KeyCode.Thumbstick1 then
                        if p176.Position.X > 0.8 and p176.Delta.X > 0 and n3 ~= 1 then
                            n3 = 1
                            setCurrentStep(v165 + 1)
                        elseif p176.Position.X < -0.8 and p176.Delta.X < 0 and n3 ~= -1 then
                            n3 = -1
                            setCurrentStep(v165 - 1)
                        elseif math.abs(p176.Position.X) < 0.8 then
                            n3 = 0
                        end
                    end
                end
            else
                n3 = 0
            end
        end)

        local v184 = false

        GuiService.Changed:Connect(function(p177) -- line: 2138
            -- upvalues: t19 (copy), v166 (ref), v168 (copy), modifySelection (copy), v182 (copy), v184 (ref), GuiService (copy), RunService (copy)
            if p177 ~= "SelectedCoreObject" then
                return
            end

            local SelectedCoreObject = GuiService.SelectedCoreObject

            if SelectedCoreObject and SelectedCoreObject:IsDescendantOf(t19.SliderFrame.Parent) then
                modifySelection(0)

                if not v184 then
                    v184 = true
                    v166 = tick()
                    RunService:BindToRenderStep(v168, Enum.RenderPriority.Input.Value + 1, v182)
                end
            else
                modifySelection(0.36)

                if v184 then
                    v184 = false
                    RunService:UnbindFromRenderStep(v168)
                end
            end
        end)
        t19.SliderFrame.AncestryChanged:Connect(function(_, p179) -- line: 2165
            -- upvalues: v183 (ref)
            v183 = p179
        end)
        setCurrentStep(v165)

        return t19
    end

    error("CreateNewSlider failed because numOfSteps (first arg) is 0 or negative, please supply a positive integer", 2)
end

local n4 = 50
local t23 = {}

local function AddNewRow(p180, p181, p182, p183, p184, p185) -- line: 2178
    -- upvalues: GuiService (copy), UserInputService (copy), PlayerGui (copy), VRService (copy), v7 (copy), t1 (copy), t2 (copy), v12 (copy), getViewportSize (copy), CreateDropDown (copy), CreateSelector (copy), CreateNewSlider (copy), n4 (copy), t23 (copy)
    local v186 = p182 ~= "TextBox"
    local v187 = if t23[p180] then t23[p180] else 0
    local v188 = t1.Create("ImageButton")({
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Image = "rbxasset://textures/ui/VR/rectBackgroundWhite.png",
        ImageTransparency = 1,
        Active = false,
        AutoButtonColor = false,
        ZIndex = 2,
        Selectable = false,
        Name = p181 .. "Frame",
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(2, 2, 18, 18),
        Size = UDim2.new(1, 0, 0, n4),
        Position = UDim2.new(0, 0, 0, v187),
        SelectionImageObject = v12,
        Parent = p180.Page
    })

    v188.ImageColor3 = v188.BackgroundColor3

    if v188 and p185 then
        v188.Position = UDim2.new(v188.Position.X.Scale, v188.Position.X.Offset, v188.Position.Y.Scale, v188.Position.Y.Offset + p185)
    end

    local v189 = t1.Create("TextLabel")({
        TextSize = 16,
        BackgroundTransparency = 1,
        ZIndex = 2,
        Name = p181 .. "Label",
        Text = p181,
        Font = Enum.Font.SourceSansBold,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        Parent = v188
    })
    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

    if v7 then
        v189.Size = UDim2.new(0.35, 0, 1, 0)
        v189.TextScaled = true
        v189.TextWrapped = true
        UITextSizeConstraint.Parent = v189
        UITextSizeConstraint.MaxTextSize = 16
    end

    if not v186 then
        v189.Text = ""
    end

    local function onResized(_, p187) -- line: 2250
        -- upvalues: v189 (copy), UITextSizeConstraint (copy)
        if p187 then
            v189.TextSize = 16
        else
            v189.TextSize = 24
        end

        UITextSizeConstraint.MaxTextSize = v189.TextSize
    end

    getViewportSize()

    local v190 = getViewportSize()

    if v190.Y > v190.X then
        v189.TextSize = 16
    else
        v189.TextSize = 24
    end

    UITextSizeConstraint.MaxTextSize = v189.TextSize
    t2[v188] = onResized
    getViewportSize()

    local v191 = getViewportSize()

    if v191.Y > v191.X then
        v189.TextSize = 16
    else
        v189.TextSize = 24
    end

    UITextSizeConstraint.MaxTextSize = v189.TextSize

    local v192, v193

    if p182 == "Slider" then
        local v194 = CreateNewSlider(p183, p184)

        v193 = v194
        v194.SliderFrame.Parent = v188
        v192 = v194.SliderFrame
    elseif p182 == "Selector" then
        local v195 = CreateSelector(p183, p184)

        v193 = v195
        v195.SelectorFrame.Parent = v188
        v192 = v195.SelectorFrame
    elseif p182 == "DropDown" then
        local v196 = CreateDropDown(p183, p184, p180.HubRef)

        v193 = v196
        v196.DropDownFrame.Parent = v188
        v192 = v196.DropDownFrame
    elseif p182 == "TextBox" then
        local v197 = false
        local v198 = false
        local v199 = t1.Create("ImageLabel")({
            Image = "",
            BackgroundTransparency = 1
        })
        local t24 = {}

        v193 = t24
        t24.HubRef = nil

        local v200 = t1.Create("TextBox")({
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            TextWrapped = true,
            TextSize = 24,
            ZIndex = 2,
            ClearTextOnFocus = false,
            AnchorPoint = Vector2.new(1, 0.5),
            Size = UDim2.new(0.6, 0, 1, 0),
            Position = UDim2.new(1, 0, 0.5, 0),
            Text = p181,
            TextColor3 = Color3.fromRGB(49, 49, 49),
            TextYAlignment = Enum.TextYAlignment.Top,
            TextXAlignment = Enum.TextXAlignment.Left,
            Font = Enum.Font.SourceSans,
            SelectionImageObject = v199,
            Parent = v188
        })

        v192 = v200
        v200.Focused:Connect(function() -- line: 2306
            -- upvalues: p181 (copy), v200 (copy), GuiService (copy), UserInputService (copy), VRService (copy)
            if not VRService.VREnabled and (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) then
                GuiService.SelectedCoreObject = v200
            end

            if v200.Text == p181 then
                v200.Text = ""
            end
        end)
        v200.FocusLost:Connect(function(_, _) -- line: 2316
            -- upvalues: v198 (ref)
            v198 = false
        end)

        if p185 then
            v200.Position = UDim2.new(v200.Position.X.Scale, v200.Position.X.Offset, v200.Position.Y.Scale, v200.Position.Y.Offset + p185)
        end

        v200.SelectionGained:Connect(function() -- line: 2327
            -- upvalues: v192 (ref), v193 (ref), v200 (copy), UserInputService (copy), VRService (copy)
            if VRService.VREnabled or UserInputService.TouchEnabled and not UserInputService.GamepadEnabled then
                return
            end

            v200.BackgroundTransparency = 0.1

            if v193.HubRef then
                v193.HubRef:ScrollToFrame(v192)
            end
        end)
        v192.SelectionLost:Connect(function() -- line: 2336
            -- upvalues: v200 (copy), UserInputService (copy), VRService (copy)
            if not VRService.VREnabled and (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) then
                v200.BackgroundTransparency = 0.5
            end
        end)

        local function v202() -- line: 2342
            -- upvalues: p180 (copy), v192 (ref), v197 (ref), GuiService (copy), UserInputService (copy), PlayerGui (copy), VRService (copy)
            local DropDownFullscreenFrame = PlayerGui.RobloxGui:FindFirstChild("DropDownFullscreenFrame")

            if not (DropDownFullscreenFrame and DropDownFullscreenFrame.Visible) then
                local v203 = v192

                if v203 and v203.Visible and v203.ZIndex > 1 and not VRService.VREnabled and (not UserInputService.TouchEnabled or not not UserInputService.GamepadEnabled) and p180.Active then
                    GuiService.SelectedCoreObject = v203
                    v197 = true
                end
            end
        end

        local function processInput(p190) -- line: 2361
            -- upvalues: v192 (ref), v198 (ref), v200 (copy), GuiService (copy)
            if p190.UserInputState == Enum.UserInputState.Begin and p190.KeyCode == Enum.KeyCode.Return and GuiService.SelectedCoreObject == v192 then
                v198 = true
                v200:CaptureFocus()
            end
        end

        v200.MouseEnter:Connect(v202)
        UserInputService.InputBegan:Connect(processInput)
    elseif p182 == "TextEntry" then
        local v204 = false
        local v205 = false
        local v206 = t1.Create("ImageLabel")({
            Image = "",
            BackgroundTransparency = 1
        })
        local t25 = {}

        v193 = t25
        t25.HubRef = nil

        local v207 = t1.Create("TextBox")({
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            TextWrapped = false,
            TextSize = 24,
            ZIndex = 2,
            ClearTextOnFocus = false,
            AnchorPoint = Vector2.new(1, 0.5),
            Size = UDim2.new(0.4, -10, 0, 40),
            Position = UDim2.new(1, 0, 0.5, 0),
            Text = p181,
            TextColor3 = Color3.fromRGB(178, 178, 178),
            TextYAlignment = Enum.TextYAlignment.Center,
            TextXAlignment = Enum.TextXAlignment.Center,
            Font = Enum.Font.SourceSans,
            SelectionImageObject = v206,
            Parent = v188
        })

        v192 = v207
        v207.Focused:Connect(function() -- line: 2405
            -- upvalues: p181 (copy), v207 (copy), GuiService (copy), UserInputService (copy), VRService (copy)
            if not VRService.VREnabled and (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) then
                GuiService.SelectedCoreObject = v207
            end

            if v207.Text == p181 then
                v207.Text = ""
            end
        end)
        v207.FocusLost:Connect(function(_, _) -- line: 2415
            -- upvalues: v205 (ref)
            v205 = false
        end)

        if p185 then
            v207.Position = UDim2.new(v207.Position.X.Scale, v207.Position.X.Offset, v207.Position.Y.Scale, v207.Position.Y.Offset + p185)
        end

        v207.SelectionGained:Connect(function() -- line: 2426
            -- upvalues: v192 (ref), v193 (ref), v207 (copy), UserInputService (copy), VRService (copy)
            if VRService.VREnabled or UserInputService.TouchEnabled and not UserInputService.GamepadEnabled then
                return
            end

            v207.BackgroundTransparency = 0.8

            if v193.HubRef then
                v193.HubRef:ScrollToFrame(v192)
            end
        end)
        v192.SelectionLost:Connect(function() -- line: 2435
            -- upvalues: v207 (copy), UserInputService (copy), VRService (copy)
            if not VRService.VREnabled and (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) then
                v207.BackgroundTransparency = 1
            end
        end)

        local function v209() -- line: 2441
            -- upvalues: p180 (copy), v192 (ref), v204 (ref), GuiService (copy), UserInputService (copy), PlayerGui (copy), VRService (copy)
            local DropDownFullscreenFrame = PlayerGui.RobloxGui:FindFirstChild("DropDownFullscreenFrame")

            if not (DropDownFullscreenFrame and DropDownFullscreenFrame.Visible) then
                local v210 = v192

                if v210 and v210.Visible and v210.ZIndex > 1 and not VRService.VREnabled and (not UserInputService.TouchEnabled or not not UserInputService.GamepadEnabled) and p180.Active then
                    GuiService.SelectedCoreObject = v210
                    v204 = true
                end
            end
        end

        local function processInput(p193) -- line: 2460
            -- upvalues: v192 (ref), v205 (ref), v207 (copy), GuiService (copy)
            if p193.UserInputState == Enum.UserInputState.Begin and p193.KeyCode == Enum.KeyCode.Return and GuiService.SelectedCoreObject == v192 then
                v205 = true
                v207:CaptureFocus()
            end
        end

        v188.MouseEnter:Connect(v209)

        local function SetZIndex(_, p195) -- line: 2472
            -- upvalues: v207 (copy)
            v207.ZIndex = p195
        end

        local v211 = v193

        v211.SetZIndex = SetZIndex

        function v211.SetInteractable(_, p197) -- line: 2474
            -- upvalues: v207 (copy)
            v207.Selectable = p197

            if p197 then
                v207.TextColor3 = Color3.fromRGB(178, 178, 178)
                v207.ZIndex = 2
            else
                v207.TextColor3 = Color3.fromRGB(49, 49, 49)
                v207.ZIndex = 1
            end
        end

        function v211.SetValue(_, p199) -- line: 2485
            -- upvalues: v207 (copy)
            v207.Text = p199
        end

        local BindableEvent = Instance.new("BindableEvent")

        BindableEvent.Name = "ValueChanged"
        v207.FocusLost:Connect(function() -- line: 2492
            -- upvalues: v207 (copy), BindableEvent (copy)
            BindableEvent:Fire(v207.Text)
        end)
        v211.ValueChanged = BindableEvent.Event
        UserInputService.InputBegan:Connect(processInput)
    end

    local v212 = p181 .. "ValueChanger"

    v193.Name = v212

    local v213 = v187 + n4

    if p185 then
        v213 += p185
    end

    t23[p180] = v213

    if v186 then
        local function v214() -- line: 2509
            -- upvalues: p180 (copy), v193 (ref), GuiService (copy), UserInputService (copy), PlayerGui (copy), VRService (copy)
            local DropDownFullscreenFrame = PlayerGui.RobloxGui:FindFirstChild("DropDownFullscreenFrame")

            if not (DropDownFullscreenFrame and DropDownFullscreenFrame.Visible) then
                local v215 = v193.SliderFrame or v193.SliderFrame or v193.DropDownFrame or v193.SelectorFrame

                if v215 and v215.Visible and v215.ZIndex > 1 and not VRService.VREnabled and (not UserInputService.TouchEnabled or not not UserInputService.GamepadEnabled) and p180.Active then
                    GuiService.SelectedCoreObject = v215
                end
            end
        end

        v188.MouseEnter:Connect(v214)

        local function onVREnabled(p200) -- line: 2539
            -- upvalues: v188 (copy), v192 (ref), GuiService (copy), VRService (copy)
            if p200 ~= "VREnabled" then
                return
            end

            if not VRService.VREnabled then
                v188.Selectable = false
                v188.Active = false

                return
            end

            v188.Selectable = true
            v188.Active = true
            v192.Active = true
            GuiService.Changed:Connect(function(p201) -- line: 2545
                -- upvalues: v188 (copy), GuiService (copy)
                if p201 ~= "SelectedCoreObject" then
                    return
                end

                local SelectedCoreObject = GuiService.SelectedCoreObject

                if SelectedCoreObject and (SelectedCoreObject == v188 or SelectedCoreObject:IsDescendantOf(v188)) then
                    v188.ImageTransparency = 0.5
                else
                    v188.ImageTransparency = 1
                end

                v188.BackgroundTransparency = 1
            end)
        end

        VRService.Changed:Connect(onVREnabled)

        if VRService.VREnabled then
            v188.Selectable = true
            v188.Active = true
            v192.Active = true
            GuiService.Changed:Connect(function(p202) -- line: 2545
                -- upvalues: v188 (copy), GuiService (copy)
                if p202 ~= "SelectedCoreObject" then
                    return
                end

                local SelectedCoreObject = GuiService.SelectedCoreObject

                if SelectedCoreObject and (SelectedCoreObject == v188 or SelectedCoreObject:IsDescendantOf(v188)) then
                    v188.ImageTransparency = 0.5
                else
                    v188.ImageTransparency = 1
                end

                v188.BackgroundTransparency = 1
            end)
        else
            v188.Selectable = false
            v188.Active = false
        end

        v192.SelectionGained:Connect(function() -- line: 2566
            -- upvalues: v188 (copy), v193 (ref), UserInputService (copy), VRService (copy)
            if not VRService.VREnabled and (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) then
                if VRService.VREnabled then
                    v188.ImageTransparency = 0.5
                    v188.BackgroundTransparency = 1
                else
                    v188.ImageTransparency = 1
                    v188.BackgroundTransparency = 0.5
                end

                if v193.HubRef then
                    v193.HubRef:ScrollToFrame(v188)
                end
            end
        end)
        v192.SelectionLost:Connect(function() -- line: 2581
            -- upvalues: v188 (copy), UserInputService (copy), VRService (copy)
            if not VRService.VREnabled and (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled) then
                v188.ImageTransparency = 1
                v188.BackgroundTransparency = 1
            end
        end)
    end

    p180:AddRow(v188, v189, v193, p185, false)
    v193.Selection = v192

    return v188, v189, v193
end

local function AddNewRowObject(p203, p204, p205, p206) -- line: 2596
    -- upvalues: GuiService (copy), VRService (copy), t1 (copy), t2 (copy), v12 (copy), getViewportSize (copy), n4 (copy), t23 (copy)
    local v216 = if t23[p203] then t23[p203] else 0
    local v217 = t1.Create("ImageButton")({
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Image = "rbxasset://textures/ui/VR/rectBackgroundWhite.png",
        ImageTransparency = 1,
        Active = false,
        AutoButtonColor = false,
        ZIndex = 2,
        Selectable = false,
        Name = p204 .. "Frame",
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 10, 10),
        Size = UDim2.new(1, 0, 0, n4),
        Position = UDim2.new(0, 0, 0, v216),
        SelectionImageObject = v12,
        Parent = p203.Page
    })

    v217.ImageColor3 = v217.BackgroundColor3
    v217.SelectionGained:Connect(function() -- line: 2621
        -- upvalues: v217 (copy)
        v217.BackgroundTransparency = 0.5
    end)
    v217.SelectionLost:Connect(function() -- line: 2622
        -- upvalues: v217 (copy)
        v217.BackgroundTransparency = 1
    end)

    local v218 = t1.Create("TextLabel")({
        TextSize = 16,
        BackgroundTransparency = 1,
        ZIndex = 2,
        Name = p204 .. "Label",
        Text = p204,
        Font = Enum.Font.SourceSansBold,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        Parent = v217
    })

    local function onResized(_, p208) -- line: 2637
        -- upvalues: v218 (copy)
        if p208 then
            v218.TextSize = 16
        else
            v218.TextSize = 24
        end
    end

    t2[v217] = onResized
    getViewportSize()

    local v219 = getViewportSize()

    if v219.Y > v219.X then
        v218.TextSize = 16
    else
        v218.TextSize = 24
    end

    if p206 then
        v217.Position = UDim2.new(v217.Position.X.Scale, v217.Position.X.Offset, v217.Position.Y.Scale, v217.Position.Y.Offset + p206)
    end

    local v220 = v216 + n4

    if p206 then
        v220 += p206
    end

    t23[p203] = v220

    local function v221() -- line: 2662
        -- upvalues: v217 (copy), GuiService (copy)
        if v217.Visible then
            GuiService.SelectedCoreObject = v217
        end
    end

    v217.MouseEnter:Connect(v221)
    p205.SelectionImageObject = v12
    p205.SelectionGained:Connect(function() -- line: 2671
        -- upvalues: v217 (copy), VRService (copy)
        if VRService.VREnabled then
            v217.ImageTransparency = 0.5
            v217.BackgroundTransparency = 1
        else
            v217.ImageTransparency = 1
            v217.BackgroundTransparency = 0.5
        end
    end)
    p205.SelectionLost:Connect(function() -- line: 2680
        -- upvalues: v217 (copy)
        v217.ImageTransparency = 1
        v217.BackgroundTransparency = 1
    end)
    p205.Parent = v217
    p203:AddRow(v217, v218, p205, p206, true)

    return v217
end

local t26 = {
    Create = function(_, p210) -- Create | line: 2694
        return function(p211) -- line: 2695
            -- upvalues: p210 (copy)
            local v222 = Instance.new(p210)
            local v223

            for v224, v225 in pairs(p211) do
                if type(v224) == "number" then
                    v225.Parent = v222
                elseif v224 == "Parent" then
                    v223 = v225
                else
                    v222[v224] = v225
                end
            end

            if v223 then
                v222.Parent = v223
            end

            return v222
        end
    end,
    RayPlaneIntersection = function(_, p213, p214, p215) -- RayPlaneIntersection | line: 2716
        local unit = p214.unit
        local Unit = p213.Unit
        local v226 = unit:Dot(Unit.Direction)

        if v226 == 0 then
            return nil
        end

        local v227 = unit:Dot(p215 - Unit.Origin) / v226

        return if not (v227 < 0) then Unit.Origin + Unit.Direction * v227 else nil
    end,
    GetEaseLinear = function(_) -- GetEaseLinear | line: 2734
        -- upvalues: Linear (copy)
        return Linear
    end,
    GetEaseOutQuad = function(_) -- GetEaseOutQuad | line: 2735
        -- upvalues: EaseOutQuad (copy)
        return EaseOutQuad
    end,
    GetEaseInOutQuad = function(_) -- GetEaseInOutQuad | line: 2736
        -- upvalues: EaseInOutQuad (copy)
        return EaseInOutQuad
    end,
    CreateNewSlider = function(_, p220, p221, p222) -- CreateNewSlider | line: 2738
        -- upvalues: CreateNewSlider (copy)
        return CreateNewSlider(p220, p221, p222)
    end,
    CreateNewSelector = function(_, p224, p225) -- CreateNewSelector | line: 2742
        -- upvalues: CreateSelector (copy)
        return (CreateSelector(p224, p225))
    end,
    CreateNewDropDown = function(_, p227, p228) -- CreateNewDropDown | line: 2746
        -- upvalues: CreateDropDown (copy)
        return (CreateDropDown(p227, p228, nil))
    end,
    AddNewRow = function(_, p230, p231, p232, p233, p234, p235) -- AddNewRow | line: 2750
        -- upvalues: AddNewRow (copy)
        return AddNewRow(p230, p231, p232, p233, p234, p235)
    end,
    AddNewRowObject = function(_, p237, p238, p239, p240) -- AddNewRowObject | line: 2761
        -- upvalues: AddNewRowObject (copy)
        return (AddNewRowObject(p237, p238, p239, p240))
    end,
    ShowAlert = function(_, p242, p243, p244, p245, p246) -- ShowAlert | line: 2765
        -- upvalues: ShowAlert (copy)
        ShowAlert(p242, p243, p244, p245, p246)
    end,
    IsSmallTouchScreen = function(_) -- IsSmallTouchScreen | line: 2775
        -- upvalues: UserInputService (copy), getViewportSize (copy)
        local v228 = getViewportSize()

        return UserInputService.TouchEnabled and (v228.Y < 500 or v228.X < 700)
    end,
    IsPortrait = function(_) -- IsPortrait | line: 2777
        -- upvalues: getViewportSize (copy)
        local v229 = getViewportSize()

        return v229.Y > v229.X
    end,
    MakeStyledButton = function(_, p250, p251, p252, p253, p254, p255) -- MakeStyledButton | line: 2779
        -- upvalues: MakeButton (copy)
        return MakeButton(p250, p251, p252, p253, p254, p255)
    end,
    MakeStyledImageButton = function(_, p257, p258, p259, p260, p261, p262, p263) -- MakeStyledImageButton | line: 2783
        -- upvalues: MakeImageButton (copy)
        return MakeImageButton(p257, p258, p259, p260, p261, p262, p263)
    end,
    AddButtonRow = function(_, p265, p266, p267, p268, p269, p270) -- AddButtonRow | line: 2795
        -- upvalues: AddButtonRow (copy)
        return AddButtonRow(p265, p266, p267, p268, p269, p270)
    end,
    CreateSignal = function(_) -- CreateSignal | line: 2799
        -- upvalues: CreateSignal (copy)
        return (CreateSignal())
    end,
    UsesSelectedObject = function(_) -- UsesSelectedObject | line: 2801
        -- upvalues: UserInputService (copy), VRService (copy)
        if VRService.VREnabled then
            return false
        end

        return not not (not UserInputService.TouchEnabled or UserInputService.GamepadEnabled)
    end
}

function t26.TweenProperty(_, p274, p275, p276, p277, p278, p279, p280) -- line: 2803
    return PropertyTweener(p274, p275, p276, p277, p278, p279, p280)
end

function t26.OnResized(_, p282, p283) -- line: 2815
    -- upvalues: addOnResizedCallback (copy)
    return addOnResizedCallback(p282, p283)
end

function t26.FireOnResized(_) -- line: 2817
    -- upvalues: t2 (copy), getViewportSize (copy), t26 (copy)
    local v230 = getViewportSize()
    local v231 = t26:IsPortrait()

    for _, v232 in pairs(t2) do
        v232(v230, v231)
    end
end

function t26.Lerp(_, p286, p287, p288) -- line: 2828
    return (1 - p286) * p287 + p286 * p288
end

function t26.Round(_, p290) -- line: 2831
    return p290 % 1 >= 0.5 and math.ceil(p290) or math.floor(p290)
end

return t26
