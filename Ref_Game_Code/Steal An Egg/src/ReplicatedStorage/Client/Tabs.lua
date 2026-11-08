-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local BossEventFlags = require(ReplicatedStorage.Shared.Flags.BossEventFlags)
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local GUI = require(ReplicatedStorage.Client.GUI)
local GamepadBindings = require(ReplicatedStorage.Client.GamepadBindings)
local PlatformController = require(ReplicatedStorage.Client.PlatformController)
local Signal = require(ReplicatedStorage.Packages.Signal)
local v1 = UDim2.fromScale(0.5, 0.5)
local v2 = NumberRange.new(24, 160)
local v3 = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local v4 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
local t1 = {
    BossMastery = true,
    BossShop = true
}
local t2 = {
    Activated = Signal.new(),
    Deactivated = Signal.new()
}
local v5
local t3 = {}

local function animate(p1, p2, p3, p4) -- line: 75
    -- upvalues: TweenService (copy)
    if p4 then
        for v6, v7 in p3 do
            p1[v6] = v7
        end

        return nil
    end

    local tween = TweenService:Create(p1, p2, p3)

    tween:Play()

    return tween
end

local v8 = assert(Workspace.CurrentCamera, "Tabs requires Workspace.CurrentCamera")
local v9 = v8
local BlurEffect = Instance.new("BlurEffect")

BlurEffect.Enabled = false
BlurEffect.Name = "MenuBackdropBlur"
BlurEffect.Size = 0
BlurEffect.Parent = v8

local v10
local v11 = false
local n1 = 0
local t4 = {}

local function drive(p5, p6, p7, p8, p9) -- line: 102
    -- upvalues: TweenService (copy), t4 (copy)
    local v12 = t4[p5]

    if v12 ~= nil then
        t4[p5] = nil
        v12:Cancel()
    end

    local v13

    if p9 then
        for v14, v15 in p8 do
            p6[v14] = v15
        end

        v13 = nil
    else
        v13 = TweenService:Create(p6, p7, p8)
        v13:Play()
    end

    if v13 ~= nil then
        t4[p5] = v13
    end

    return v13
end

local function tabletLayout() -- line: 121
    -- upvalues: PlatformController (copy), v9 (ref)
    return PlatformController.IsMobile() and v9.ViewportSize.Y >= 600
end

local function parkPlayerList() -- line: 126
    -- upvalues: StarterGui (copy), PlatformController (copy), v9 (ref), v11 (ref)
    if not v11 and PlatformController.IsMobile() and v9.ViewportSize.Y >= 600 and StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.PlayerList) then
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
        v11 = true
    end
end

local function unparkPlayerList() -- line: 136
    -- upvalues: StarterGui (copy), v11 (ref)
    if v11 then
        v11 = false
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
    end
end

local function blurIn(p10) -- line: 144
    -- upvalues: TweenService (copy), v4 (copy), BlurEffect (copy), t4 (copy)
    BlurEffect.Enabled = true

    local t5 = {
        Size = 14
    }
    local blur = t4.blur

    if blur ~= nil then
        t4.blur = nil
        blur:Cancel()
    end

    local v16

    if p10 then
        for v17, v18 in t5 do
            BlurEffect[v17] = v18
        end

        v16 = nil
    else
        v16 = TweenService:Create(BlurEffect, v4, t5)
        v16:Play()
    end

    if v16 ~= nil then
        t4.blur = v16
    end
end

local function blurOut(p11) -- line: 149
    -- upvalues: TweenService (copy), v4 (copy), BlurEffect (copy), t4 (copy)
    local t6 = {
        Size = 0
    }
    local blur = t4.blur

    if blur ~= nil then
        t4.blur = nil
        blur:Cancel()
    end

    local v19

    if p11 then
        for v20, v21 in t6 do
            BlurEffect[v20] = v21
        end

        v19 = nil
    else
        v19 = TweenService:Create(BlurEffect, v4, t6)
        v19:Play()
    end

    if v19 ~= nil then
        t4.blur = v19
    end

    return v19
end

local function pushFieldOfView(p12) -- line: 156
    -- upvalues: TweenService (copy), v4 (copy), v9 (ref), v10 (ref), t4 (copy)
    local v22 = v10 or v9.FieldOfView

    v10 = v22

    local v23 = v9
    local t7 = {
        FieldOfView = v22 + 5
    }
    local fieldOfView = t4.fieldOfView

    if fieldOfView ~= nil then
        t4.fieldOfView = nil
        fieldOfView:Cancel()
    end

    local v24

    if p12 then
        for v25, v26 in t7 do
            v23[v25] = v26
        end

        v24 = nil
    else
        v24 = TweenService:Create(v23, v4, t7)
        v24:Play()
    end

    if v24 ~= nil then
        t4.fieldOfView = v24
    end
end

local function restoreFieldOfView(p13) -- line: 162
    -- upvalues: TweenService (copy), v4 (copy), v9 (ref), v10 (ref), t4 (copy)
    local v27 = v10

    if v27 == nil then
        return
    end

    local v28 = v9
    local t8 = {
        FieldOfView = v27
    }
    local fieldOfView = t4.fieldOfView

    if fieldOfView ~= nil then
        t4.fieldOfView = nil
        fieldOfView:Cancel()
    end

    local v29

    if p13 then
        for v30, v31 in t8 do
            v28[v30] = v31
        end

        v29 = nil
    else
        v29 = TweenService:Create(v28, v4, t8)
        v29:Play()
    end

    if v29 ~= nil then
        t4.fieldOfView = v29
    end
end

local function lowerBackdrop(p14) -- line: 179
    -- upvalues: StarterGui (copy), TweenService (copy), v4 (copy), v9 (ref), BlurEffect (copy), v10 (ref), v11 (ref), n1 (ref), t4 (copy)
    n1 += 1

    local v32 = n1

    local function forget() -- line: 183
        -- upvalues: v32 (copy), BlurEffect (copy), v10 (ref), n1 (ref)
        if n1 == v32 then
            BlurEffect.Enabled = false
            v10 = nil
        end
    end

    local v33 = v10

    if v33 ~= nil then
        local v34 = v9
        local t9 = {
            FieldOfView = v33
        }
        local fieldOfView = t4.fieldOfView

        if fieldOfView ~= nil then
            t4.fieldOfView = nil
            fieldOfView:Cancel()
        end

        local v35

        if p14 then
            for v36, v37 in t9 do
                v34[v36] = v37
            end

            v35 = nil
        else
            v35 = TweenService:Create(v34, v4, t9)
            v35:Play()
        end

        if v35 ~= nil then
            t4.fieldOfView = v35
        end
    end

    local t10 = {
        Size = 0
    }
    local blur = t4.blur

    if blur ~= nil then
        t4.blur = nil
        blur:Cancel()
    end

    local v38

    if p14 then
        for v39, v40 in t10 do
            BlurEffect[v39] = v40
        end

        v38 = nil
    else
        v38 = TweenService:Create(BlurEffect, v4, t10)
        v38:Play()
    end

    if v38 ~= nil then
        t4.blur = v38
    end

    if v38 then
        v38.Completed:Once(forget)
    elseif n1 == v32 then
        BlurEffect.Enabled = false
        v10 = nil
    end

    if v11 then
        v11 = false
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
    end
end

Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- line: 200
    -- upvalues: Workspace (copy), v9 (ref), BlurEffect (copy)
    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera ~= nil and CurrentCamera ~= v9 then
        v9 = CurrentCamera
        BlurEffect.Parent = CurrentCamera
    end
end)

local t11 = {
    function(p15) -- line: 211
        return p15:FindFirstChild("Frame")
    end,
    function(p16) -- line: 214
        return p16:FindFirstChildOfClass("Frame")
    end,
    function(p17) -- line: 217
        return p17:FindFirstChildWhichIsA("ImageLabel")
    end
}

local function stageFor(p18) -- line: 222
    -- upvalues: t3 (copy)
    local v41 = t3[p18]

    if v41 then
        return v41
    end

    local t12 = {
        generation = 0,
        wired = false
    }

    t3[p18] = t12

    return t12
end

local function dropCloser(p19) -- line: 232
    local closer = p19.closer

    if closer then
        closer:Disconnect()
        p19.closer = nil
    end
end

local function screenNamed(p20) -- line: 240
    -- upvalues: GUI (copy)
    local v42 = GUI.Get(p20)

    assert(v42:IsA("ScreenGui"), (("tab %* must resolve to a ScreenGui"):format(p20)))

    return v42
end

local function bodyOf(p21) -- line: 246
    -- upvalues: t11 (copy)
    for _, v44 in t11 do
        local v45 = v44(p21)

        if v45 and v45:IsA("GuiObject") then
            return v45
        end
    end

    error((("tab %* has no GuiObject body"):format(p21.Name)))
end

local function scaleOf(p22) -- line: 257
    local MenuScale = p22:FindFirstChild("MenuScale")

    if MenuScale and MenuScale:IsA("UIScale") then
        return MenuScale
    end

    local UIScale = p22:FindFirstChildOfClass("UIScale")

    if UIScale then
        return UIScale
    end

    local UIScale2 = Instance.new("UIScale")

    UIScale2.Name = "MenuScale"
    UIScale2.Parent = p22

    return UIScale2
end

local function specOf(p23) -- line: 272
    return {
        holdCamera = p23:GetAttribute("ModalDialog") == true,
        selfAnimated = p23:GetAttribute("AuthoredOpenAnimation") == true,
        snapClose = p23:GetAttribute("ImmediateClose") == true
    }
end

local function entryTravel(p24) -- line: 280
    -- upvalues: v2 (copy), v9 (ref)
    local Y = p24.AbsoluteSize.Y

    if Y <= 0 then
        Y = v9.ViewportSize.Y / 2
    end

    return (math.clamp(Y * 0.18, v2.Min, v2.Max))
end

local function loweredPose(p25) -- line: 288
    -- upvalues: v1 (copy), v2 (copy), v9 (ref)
    local fromOffset = UDim2.fromOffset
    local Y = p25.AbsoluteSize.Y

    if Y <= 0 then
        Y = v9.ViewportSize.Y / 2
    end

    return v1 + fromOffset(0, (math.clamp(Y * 0.18, v2.Min, v2.Max)))
end

local function closeButtonOf(p26) -- line: 292
    local Close = p26:FindFirstChild("Close")

    if Close == nil then
        local Frame = p26:FindFirstChildWhichIsA("Frame")

        Close = if Frame then Frame:FindFirstChild("Close") else nil
    end

    if Close == nil then
        return nil
    end

    assert(Close:IsA("GuiButton"), (("%* must be a GuiButton"):format((Close:GetFullName()))))

    return Close
end

local function wireCloseButton(p27, p28) -- line: 306
    -- upvalues: ButtonFX (copy), GUI (copy), GamepadBindings (copy), t2 (copy), closeButtonOf (copy)
    if p27.wired then
        return
    end

    local v49 = closeButtonOf(p28)

    if v49 then
        ButtonFX(v49, 1.08)
        GUI.OnActivated(v49, function() -- line: 313
            -- upvalues: t2 (copy)
            t2.Deactivate()
        end)
        GamepadBindings.Inspect(v49)
    end

    p27.wired = true
end

local function releaseFocus(p29) -- line: 322
    -- upvalues: GuiService (copy)
    local SelectedObject = GuiService.SelectedObject

    if SelectedObject ~= nil and SelectedObject:IsDescendantOf(p29) then
        GuiService.SelectedObject = nil
        GuiService.GuiNavigationEnabled = false
    end
end

local function admitted(p30) -- line: 330
    -- upvalues: BossEventFlags (copy), t1 (copy)
    if t1[p30] == true then
        return BossEventFlags.ContentEnabled:Get() == true
    end

    return true
end

local function exit(p31, p32) -- line: 336
    -- upvalues: GuiService (copy), TweenService (copy), GUI (copy), v1 (copy), v2 (copy), v3 (copy), t2 (copy), v5 (ref), t3 (copy), v9 (ref), lowerBackdrop (copy), bodyOf (copy), specOf (copy)
    local v50 = t3[p31]

    if not v50 then
        v50 = {
            generation = 0,
            wired = false
        }
        t3[p31] = v50
    end

    local v51 = GUI.Get(p31)

    assert(v51:IsA("ScreenGui"), (("tab %* must resolve to a ScreenGui"):format(p31)))

    local v53 = specOf(v51)
    local v54 = bodyOf(v51)
    local MenuScale = v54:FindFirstChild("MenuScale")

    if not (MenuScale and MenuScale:IsA("UIScale")) then
        MenuScale = v54:FindFirstChildOfClass("UIScale")

        if not MenuScale then
            MenuScale = Instance.new("UIScale")
            MenuScale.Name = "MenuScale"
            MenuScale.Parent = v54
        end
    end

    local v55 = p32.instant == true or v53.snapClose
    local replacedBy = p32.replacedBy

    v50.generation += 1

    local generation, closer = v50.generation, v50.closer

    if closer then
        closer:Disconnect()
        v50.closer = nil
    end

    v5 = nil

    local SelectedObject = GuiService.SelectedObject

    if SelectedObject ~= nil and SelectedObject:IsDescendantOf(v51) then
        GuiService.SelectedObject = nil
        GuiService.GuiNavigationEnabled = false
    end

    local function settle() -- line: 351
        -- upvalues: v50 (ref), v51 (copy), generation (copy)
        if v50.generation ~= generation then
            return
        end

        local closer = v50.closer

        if closer then
            closer:Disconnect()
            v50.closer = nil
        end

        v51.Enabled = false
    end

    if v53.selfAnimated then
        v51:SetAttribute("Open", false)

        local Visible = if not v55 then v54.Visible else nil

        if v55 or not Visible then
            if v50.generation == generation then
                local closer = v50.closer

                if closer then
                    closer:Disconnect()
                    v50.closer = nil
                end

                v51.Enabled = false
            end
        else
            local Visible = v54:GetPropertyChangedSignal("Visible")
            local v56 = v50

            v50.closer = Visible:Connect(function() -- line: 364
                -- upvalues: v51 (copy), v54 (copy), generation (copy), v56 (copy)
                if v54.Visible or v56.generation ~= generation then
                    return
                end

                local closer = v56.closer

                if closer then
                    closer:Disconnect()
                    v56.closer = nil
                end

                v51.Enabled = false
            end)
            task.delay(1.2, settle)
        end
    elseif v55 then
        MenuScale.Scale = 0.9

        if v50.generation == generation then
            local closer = v50.closer

            if closer then
                closer:Disconnect()
                v50.closer = nil
            end

            v51.Enabled = false
        end
    else
        TweenService:Create(MenuScale, v3, {
            Scale = 0.9
        }):Play()

        local fromOffset = UDim2.fromOffset
        local Y = v54.AbsoluteSize.Y

        if Y <= 0 then
            Y = v9.ViewportSize.Y / 2
        end

        local tween = TweenService:Create(v54, v3, {
            Position = v1 + fromOffset(0, (math.clamp(Y * 0.18, v2.Min, v2.Max)))
        })

        tween:Play()

        if tween then
            tween.Completed:Once(settle)
        end
    end

    if replacedBy == nil then
        lowerBackdrop(v55)
    end

    t2.Deactivated:Fire(p31, {
        instant = v55,
        replacedBy = replacedBy
    })
end

local function enter(p33, p34) -- line: 388
    -- upvalues: StarterGui (copy), TweenService (copy), GUI (copy), PlatformController (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), t2 (copy), v5 (ref), t3 (copy), v9 (ref), BlurEffect (copy), v10 (ref), v11 (ref), n1 (ref), t4 (copy), bodyOf (copy), specOf (copy), wireCloseButton (copy)
    local v58 = t3[p33]

    if not v58 then
        v58 = {
            generation = 0,
            wired = false
        }
        t3[p33] = v58
    end

    local v59 = GUI.Get(p33)

    assert(v59:IsA("ScreenGui"), (("tab %* must resolve to a ScreenGui"):format(p33)))

    local v61 = specOf(v59)
    local v62 = bodyOf(v59)
    local MenuScale = v62:FindFirstChild("MenuScale")

    if not (MenuScale and MenuScale:IsA("UIScale")) then
        MenuScale = v62:FindFirstChildOfClass("UIScale")

        if not MenuScale then
            MenuScale = Instance.new("UIScale")
            MenuScale.Name = "MenuScale"
            MenuScale.Parent = v62
        end
    end

    v58.generation += 1

    local closer = v58.closer

    if closer then
        closer:Disconnect()
        v58.closer = nil
    end

    wireCloseButton(v58, v62)
    v5 = p33
    v59.Enabled = true
    n1 += 1
    v10 = v10 or v9.FieldOfView
    BlurEffect.Enabled = true

    local t15 = {
        Size = 14
    }
    local blur = t4.blur

    if blur ~= nil then
        t4.blur = nil
        blur:Cancel()
    end

    local v63

    if p34 then
        for v64, v65 in t15 do
            BlurEffect[v64] = v65
        end

        v63 = nil
    else
        v63 = TweenService:Create(BlurEffect, v4, t15)
        v63:Play()
    end

    if v63 ~= nil then
        t4.blur = v63
    end

    if not v61.holdCamera then
        local v66 = v10 or v9.FieldOfView

        v10 = v66

        local v67 = v9
        local t16 = {
            FieldOfView = v66 + 5
        }
        local fieldOfView = t4.fieldOfView

        if fieldOfView ~= nil then
            t4.fieldOfView = nil
            fieldOfView:Cancel()
        end

        local v68

        if p34 then
            for v69, v70 in t16 do
                v67[v69] = v70
            end

            v68 = nil
        else
            v68 = TweenService:Create(v67, v4, t16)
            v68:Play()
        end

        if v68 ~= nil then
            t4.fieldOfView = v68
        end
    end

    if not v11 and PlatformController.IsMobile() and v9.ViewportSize.Y >= 600 and StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.PlayerList) then
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
        v11 = true
    end

    if v61.selfAnimated then
        v62.Position = v1
        v59:SetAttribute("Open", true)
    elseif p34 then
        v62.Position = v1
        MenuScale.Scale = 1
    else
        local fromOffset = UDim2.fromOffset
        local Y = v62.AbsoluteSize.Y

        if Y <= 0 then
            Y = v9.ViewportSize.Y / 2
        end

        v62.Position = v1 + fromOffset(0, (math.clamp(Y * 0.18, v2.Min, v2.Max)))
        MenuScale.Scale = 0.96
        TweenService:Create(v62, v3, {
            Position = v1
        }):Play()
        TweenService:Create(MenuScale, v3, {
            Scale = 1
        }):Play()
    end

    t2.Activated:Fire(p33, {
        instant = p34
    })
end

function t2.Active() -- line: 421
    -- upvalues: v5 (ref)
    return v5
end

function t2.IsActive(p35) -- line: 425
    -- upvalues: v5 (ref)
    if v5 == nil then
        return false
    end

    if p35 == nil then
        return true
    end

    return v5 == p35
end

function t2.Activate(p36, p37) -- line: 430
    -- upvalues: BossEventFlags (copy), t1 (copy), v5 (ref), exit (copy), enter (copy)
    if v5 == p36 or t1[p36] == true and BossEventFlags.ContentEnabled:Get() ~= true then
        return false
    end

    local v72 = v5

    if v72 ~= nil then
        exit(v72, {
            instant = true,
            replacedBy = p36
        })
    end

    enter(p36, p37 ~= nil and p37.instant == true)

    return true
end

function t2.Deactivate(p38) -- line: 442
    -- upvalues: v5 (ref), exit (copy)
    local v74 = v5

    if v74 == nil then
        return
    end

    exit(v74, {
        instant = p38 ~= nil and p38.instant == true
    })
end

function t2.Toggle(p39, p40) -- line: 449
    -- upvalues: t2 (copy), v5 (ref)
    if not t2.Activate(p39, p40) and v5 == p39 then
        t2.Deactivate(p40)
    end
end

BossEventFlags.ContentEnabled.Changed:Connect(function() -- line: 455
    -- upvalues: BossEventFlags (copy), t1 (copy), t2 (copy), v5 (ref)
    local v75 = v5

    if v75 ~= nil and t1[v75] == true and BossEventFlags.ContentEnabled:Get() ~= true then
        t2.Deactivate({
            instant = true
        })
    end
end)

return table.freeze(t2)
