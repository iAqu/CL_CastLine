-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)
local Fishing = require(ReplicatedStorage.Shared.Util.Fishing)
local FishingFlags = require(ReplicatedStorage.Shared.Flags.FishingFlags)
local HiddenUIHandler = require(ReplicatedStorage.Client.HiddenUIHandler)
local Line = require(script.Line)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Spots = require(script.Spots)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Ui = require(script.Ui)
local LocalPlayer = Players.LocalPlayer
local v1 = Color3.fromRGB(255, 85, 85)
local v2 = Color3.fromRGB(180, 230, 255)
local t1 = {
    DynamicThumbstickFrame = true,
    ThumbstickFrame = true
}
local ButtonR2 = Enum.KeyCode.ButtonR2
local t2 = {
    [Enum.KeyCode.One] = true,
    [Enum.KeyCode.Two] = true,
    [Enum.KeyCode.Three] = true,
    [Enum.KeyCode.Four] = true,
    [Enum.KeyCode.Five] = true,
    [Enum.KeyCode.Six] = true,
    [Enum.KeyCode.Seven] = true,
    [Enum.KeyCode.Eight] = true,
    [Enum.KeyCode.Nine] = true,
    [Enum.KeyCode.Backspace] = true,
    [Enum.KeyCode.ButtonB] = true
}
local t3 = {
    Mouse = {
        Cast = "Hold to Cast",
        Reel = "Click Fast!"
    },
    Touch = {
        Cast = "Hold to Cast",
        Reel = "Tap Fast!"
    },
    Gamepad = {
        Cast = "Hold R2 to Cast",
        Reel = "Mash R2!"
    }
}
local t4 = nil
local v3
local n1 = 0
local result, result2, result3
local n2 = 0
local v4 = false
local t5 = {}

local function quest() -- line: 108
    -- upvalues: result (ref)
    if result ~= nil then
        return result
    end

    local GhostDogQuestController = script.Parent:FindFirstChild("GhostDogQuestController")

    if GhostDogQuestController and GhostDogQuestController:IsA("ModuleScript") then
        local _require = require
        local ok, result2 = pcall(_require, GhostDogQuestController)

        if ok then
            result = result2
        end
    end

    return result
end

local function fx() -- line: 121
    -- upvalues: result2 (ref)
    if result2 ~= nil then
        return result2
    end

    local GhostDogQuestController = script.Parent:FindFirstChild("GhostDogQuestController")
    local Fx = GhostDogQuestController and GhostDogQuestController:FindFirstChild("Fx")

    if Fx and Fx:IsA("ModuleScript") then
        local _require = require
        local ok, result = pcall(_require, Fx)

        if ok then
            result2 = result
        end
    end

    return result2
end

local function keyCatch() -- line: 135
    -- upvalues: result3 (ref)
    if result3 ~= nil then
        return result3
    end

    local KeyCatch = script:FindFirstChild("KeyCatch")

    if KeyCatch and KeyCatch:IsA("ModuleScript") then
        local _require = require
        local ok, result = pcall(_require, KeyCatch)

        if ok and type(result) == "table" then
            result3 = result
        end
    end

    return result3
end

local function splash(p1, p2) -- line: 148
    -- upvalues: fx (copy)
    local v5 = fx()

    if v5 and type(v5.Splash) == "function" then
        local Splash = v5.Splash
        local v6 = p1 + Vector3.new(0, 0.3, 0)

        pcall(Splash, v6, p2)
    end
end

local function ripple(p3, p4) -- line: 155
    -- upvalues: fx (copy)
    local v7 = fx()

    if v7 and type(v7.Ripple) == "function" then
        local Ripple = v7.Ripple
        local v8 = p3 + Vector3.new(0, 0.3, 0)

        pcall(Ripple, v8, p4)
    end
end

local function inputKind() -- line: 162
    -- upvalues: UserInputService (copy)
    local LastInputType = UserInputService:GetLastInputType()

    if LastInputType ~= Enum.UserInputType.Touch then
        if string.find(LastInputType.Name, "Gamepad", 1, true) then
            return "Gamepad"
        end

        if not UserInputService.TouchEnabled or UserInputService.MouseEnabled then
            return "Mouse"
        end
    end

    return "Touch"
end

local function play(p5, p6, p7) -- line: 176
    -- upvalues: ReplicatedStorage (copy), SoundService (copy), Audio (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local Fishing = Assets and Assets:FindFirstChild("Fishing")
    local Sounds = Fishing and Fishing:FindFirstChild("Sounds")
    local v9 = Sounds and Sounds:FindFirstChild(p5)
    local clone, v10, v11

    if v9 ~= nil then
        if v9:IsA("Sound") then
            clone = table.clone
            v10 = p7 or {}
            v11 = false
        else
            v11 = true
        end
    else
        v11 = true
    end

    if v11 then
        return nil
    end

    local v12 = clone(v10)

    if v12.SoundGroup == nil then
        v12.SoundGroup = "SFX"
    end

    if p6 ~= nil and v12.MaxDistance == nil then
        v12.MaxDistance = 250
    end

    return Audio.Play(v9, p6 or SoundService, v12)
end

local function toast(p8, p9) -- line: 194
    -- upvalues: Toast (copy), v2 (copy)
    Toast.Show({
        Seconds = 2.5,
        Text = p8,
        Color = p9 or v2
    })
end

local function characterParts() -- line: 198
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local v13, v14

    if Character then
        v13 = Character:FindFirstChild("HumanoidRootPart")
        v14 = Character:FindFirstChildOfClass("Humanoid")
    else
        v14 = Character
        v13 = Character
    end

    if Character ~= nil and v13 ~= nil and v13:IsA("BasePart") and v14 ~= nil then
        return Character, v13, v14
    end

    return nil, nil, nil
end

local function walking() -- line: 208
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local v15, v16

    if Character then
        v16 = Character:FindFirstChild("HumanoidRootPart")
        v15 = Character:FindFirstChildOfClass("Humanoid")
    else
        v15 = Character
        v16 = Character
    end

    if Character == nil or v16 == nil or not v16:IsA("BasePart") or v15 == nil then
        v15 = nil
    end

    return v15 ~= nil and v15.MoveDirection.Magnitude > 0.1
end

local function inGuiRect(p10, p11) -- line: 213
    if p10:IsA("GuiObject") then
        local AbsoluteSize = p10.AbsoluteSize

        if not (AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0) then
            local AbsolutePosition = p10.AbsolutePosition

            return true, p11.X >= AbsolutePosition.X and p11.Y >= AbsolutePosition.Y and p11.X <= AbsolutePosition.X + AbsoluteSize.X and p11.Y <= AbsolutePosition.Y + AbsoluteSize.Y
        end
    end

    return false, false
end

local function inStickZone(p12) -- line: 229
    -- upvalues: Workspace (copy), LocalPlayer (copy), t1 (copy), inGuiRect (copy)
    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local TouchGui = PlayerGui and PlayerGui:FindFirstChild("TouchGui")
    local TouchControlFrame = TouchGui and TouchGui:FindFirstChild("TouchControlFrame")
    local v17 = false

    if TouchControlFrame then
        for _, child in TouchControlFrame:GetChildren() do
            if t1[child.Name] or child.Name == "JumpButton" then
                local v19, v20 = inGuiRect(child, p12)

                if v20 then
                    return true
                end

                if v19 and t1[child.Name] then
                    v17 = true
                end
            end
        end
    end

    if v17 then
        return false
    end

    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera == nil then
        return false
    end

    local ViewportSize = CurrentCamera.ViewportSize

    if p12.X < ViewportSize.X * 0.5 then
        return p12.Y > ViewportSize.Y * 0.4
    end

    return false
end

local function rodTip(p13) -- line: 258
    local v21 = p13:FindFirstChild("RodTip", true)

    return if v21 and v21:IsA("Attachment") then v21 else nil
end

local function screenPoint(p14) -- line: 263
    -- upvalues: Workspace (copy)
    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera ~= nil then
        local v22, v23 = CurrentCamera:WorldToViewportPoint(p14)
        local ViewportSize = CurrentCamera.ViewportSize

        if v23 and not (ViewportSize.X <= 0) and not (ViewportSize.Y <= 0) then
            return Vector2.new(v22.X / ViewportSize.X, v22.Y / ViewportSize.Y)
        end
    end

    return nil
end

local function cursorPoint() -- line: 276
    -- upvalues: UserInputService (copy), Workspace (copy)
    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera == nil then
        return nil
    end

    local ViewportSize = CurrentCamera.ViewportSize
    local MouseLocation = UserInputService:GetMouseLocation()

    if ViewportSize.X <= 0 or ViewportSize.Y <= 0 then
        return nil
    end

    return Vector2.new(MouseLocation.X / ViewportSize.X, MouseLocation.Y / ViewportSize.Y)
end

local function besideCharacter(p15) -- line: 289
    -- upvalues: Workspace (copy), screenPoint (copy)
    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera == nil then
        return nil
    end

    return screenPoint(p15.Position + CurrentCamera.CFrame.RightVector * 1.6 + Vector3.new(0, 0.6, 0))
end

local function aimLook(p16, p17) -- line: 297
    -- upvalues: UserInputService (copy), Workspace (copy)
    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera == nil then
        return p17.CFrame.LookVector
    end

    local LookVector = CurrentCamera.CFrame.LookVector
    local LastInputType = UserInputService:GetLastInputType()

    if (if LastInputType == Enum.UserInputType.Touch then "Touch"
        elseif string.find(LastInputType.Name, "Gamepad", 1, true) then "Gamepad"
        elseif not UserInputService.TouchEnabled or UserInputService.MouseEnabled then "Mouse"
        else "Touch") ~= "Mouse" then
        return LookVector
    end

    local MouseLocation = UserInputService:GetMouseLocation()
    local v24 = CurrentCamera:ViewportPointToRay(MouseLocation.X, MouseLocation.Y)
    local v25 = RaycastParams.new()

    v25.FilterType = Enum.RaycastFilterType.Exclude
    v25.FilterDescendantsInstances = { p16 or p17 }

    local v26 = Workspace:Raycast(v24.Origin, v24.Direction * 500, v25)
    local v27

    if v26 then
        v27 = v26.Position - p17.Position
    else
        local v28 = p17.Position.Y - 3
        local v29 = if v24.Direction.Y < -0.01 then (v28 - v24.Origin.Y) / v24.Direction.Y else -1

        v27 = if v29 > 0 then v24.Origin + v24.Direction * v29 - p17.Position else v24.Direction * 3
    end

    local v30 = Vector3.new(v27.X, 0, v27.Z)

    if v30.Magnitude < 2 then
        return LookVector
    end

    return v30.Unit
end

local function lockControls(p18) -- line: 336
    -- upvalues: LocalPlayer (copy)
    local PlayerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
    local PlayerModule = PlayerScripts and PlayerScripts:FindFirstChild("PlayerModule")

    if PlayerModule == nil then
        return
    end

    local _require = require
    local ok, result = pcall(_require, PlayerModule)

    if ok then
        local Controls = result:GetControls()

        if Controls then
            Controls:Disable()
            p18:Add(function() -- line: 349
                -- upvalues: Controls (copy)
                Controls:Enable()
            end)
        end
    end
end

local function hideBackpack(p19) -- line: 355
    -- upvalues: StarterGui (copy), HiddenUIHandler (copy), LocalPlayer (copy)
    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local BackpackGui = PlayerGui and PlayerGui:FindFirstChild("BackpackGui")
    local v31 = false

    if BackpackGui and BackpackGui:IsA("ScreenGui") then
        v31 = BackpackGui.Enabled
        BackpackGui.Enabled = false
    end

    local function v32() -- line: 363
        -- upvalues: StarterGui (copy)
        return StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack)
    end

    local ok, result = pcall(v32)

    local function v33() -- line: 366
        -- upvalues: StarterGui (copy)
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
    end

    pcall(v33)
    p19:Add(function() -- line: 369
        -- upvalues: v31 (ref), BackpackGui (copy), ok (copy), result (copy), StarterGui (copy), HiddenUIHandler (copy)
        if BackpackGui and BackpackGui:IsA("ScreenGui") and v31 and not HiddenUIHandler.IsHidden() then
            BackpackGui.Enabled = true
        end

        if ok and result == true then
            local function v34() -- line: 379
                -- upvalues: StarterGui (copy)
                StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
            end

            pcall(v34)
        end
    end)
end

local function hideRodLine(p20, p21) -- line: 386
    for _, descendant in p21:GetDescendants() do
        if descendant:IsA("Beam") and descendant.Enabled then
            descendant.Enabled = false
            p20:Add(function() -- line: 390
                -- upvalues: descendant (copy)
                if descendant.Parent ~= nil then
                    descendant.Enabled = true
                end
            end)
        end
    end
end

local function steerFacing(p22, p23) -- line: 399
    -- upvalues: RunService (copy), LocalPlayer (copy)
    local AutoRotate = p23.AutoRotate

    p23.AutoRotate = false
    p22:Add(function() -- line: 402
        -- upvalues: p23 (copy), AutoRotate (copy)
        if p23.Parent ~= nil then
            p23.AutoRotate = AutoRotate
        end
    end)

    local v35

    p22:Connect(RunService.RenderStepped, function(p24) -- line: 408
        -- upvalues: v35 (ref), LocalPlayer (copy)
        local Character = LocalPlayer.Character
        local v36, v37

        if Character then
            v36 = Character:FindFirstChild("HumanoidRootPart")
            v37 = Character:FindFirstChildOfClass("Humanoid")
        else
            v37 = Character
            v36 = Character
        end

        if Character == nil or v36 == nil or not v36:IsA("BasePart") or v37 == nil then
            v36 = nil
        end

        if v35 ~= nil and v36 ~= nil then
            local _, v38 = v36.CFrame:ToEulerAnglesYXZ()
            local v39 = (v35 - v38 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793

            if math.abs(v39) < 0.002 then
                return
            end

            local v41 = v38 + v39 * (1 - math.exp(p24 * -14))

            v36.CFrame = CFrame.new(v36.Position) * CFrame.fromEulerAnglesYXZ(0, v41, 0)
        end
    end)

    return function(p25) -- line: 421
        -- upvalues: v35 (ref)
        local v42 = Vector3.new(p25.X, 0, p25.Z)

        if v42.Magnitude < 0.01 then
            return
        end

        v35 = math.atan2(-v42.X, -v42.Z)
    end
end

local function waterInReach(p26, p27) -- line: 430
    -- upvalues: Fishing (copy), aimLook (copy)
    local v45 = aimLook(p26, p27)

    for i = 0, 7 do
        local v46 = i / 7

        if Fishing.Probe(Fishing.Aim(p27.Position, v45, v46), { p26 }).Water then
            return true
        end
    end

    return false
end

local function finish(p28) -- line: 442
    -- upvalues: FishingFlags (copy), t4 (ref), n1 (ref)
    if p28.Ended then
        return
    end

    p28.Ended = true

    if t4 == p28 then
        t4 = nil
    end

    local Bobber = p28.Bobber

    if Bobber and not p28.HandedOff then
        Bobber:Destroy()
    end

    p28.Trove:Destroy()
    n1 = os.clock() + FishingFlags.CastCooldown:Get()
end

local function reelBack(p29) -- line: 464
    -- upvalues: Line (copy), finish (copy)
    local Bobber = p29.Bobber
    local Return, v47

    if Bobber and Bobber.Parent ~= nil and not p29.Ended then
        Return = Line.Return
        v47 = p29.Tool:FindFirstChild("RodTip", true)

        if not v47 or not v47:IsA("Attachment") then
            v47 = nil
        end

        Return(Bobber, v47, 0.4)
    end

    finish(p29)
end

local function cancelServer(p30) -- line: 472
    -- upvalues: Remotes (copy)
    if p30.Id ~= 0 then
        Remotes.Fishing.Cancel:FireServer(p30.Id)
    end
end

local function biteMark(p31) -- line: 478
    -- upvalues: ReplicatedStorage (copy), TweenService (copy), LocalPlayer (copy)
    local Bobber = p31.Bobber
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local Fishing = Assets and Assets:FindFirstChild("Fishing")
    local Bite = Fishing and Fishing:FindFirstChild("Bite")
    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local v48, v49, v50

    if Bobber == nil or Bite == nil then
        v50 = true
    elseif not Bite:IsA("BillboardGui") or PlayerGui == nil then
        v50 = true
    else
        v48 = p31.Trove:Add(Bite:Clone())
        v49 = Bobber.PrimaryPart or Bobber:FindFirstChildWhichIsA("BasePart", true)
        v50 = false
    end

    if v50 then
        return
    end

    v48.Adornee = v49
    v48.Parent = PlayerGui

    local v51 = v48:FindFirstChildWhichIsA("TextLabel", true)
    local UIScale = v51 and v51:FindFirstChildOfClass("UIScale")

    if not UIScale then
        return
    end

    UIScale.Scale = 2.2
    TweenService:Create(UIScale, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1
    }):Play()
end

local function revealReward(p32, p33) -- line: 499
    -- upvalues: Ui (copy), play (copy), finish (copy)
    play("Catch")
    Ui.Reveal(p33, 2.6)
    finish(p32)
end

local function catchKey(p34, p35) -- line: 505
    -- upvalues: Ui (copy), result3 (ref), fx (copy), finish (copy)
    if result3 == nil then
        local KeyCatch = script:FindFirstChild("KeyCatch")

        if KeyCatch and KeyCatch:IsA("ModuleScript") then
            local _require = require
            local ok, result = pcall(_require, KeyCatch)

            if ok and type(result) == "table" then
                result3 = result
            end
        end
    end

    local result = result3
    local Surface = p34.Surface
    local Play, t7, v53, v54

    if result ~= nil then
        if type(result.Play) ~= "function" or Surface == nil then
            v54 = true
        else
            Ui.ShowReel(false)

            local Bobber = p34.Bobber

            Play = result.Play
            t7 = {
                Reward = p35,
                Landing = Surface,
                Bobber = Bobber
            }
            v53 = p34.Tool:FindFirstChild("RodTip", true)

            if not v53 or not v53:IsA("Attachment") then
                v53 = nil
            end

            v54 = false
        end
    else
        v54 = true
    end

    if v54 then
        return false
    end

    t7.Tip = v53
    t7.Fx = fx()

    local ok, result2 = pcall(Play, t7)

    if ok then
        local v55 = true

        if result2 == true then
            p34.Bobber = nil
            finish(p34)

            if type(result.Stow) == "function" then
                local Stow = result.Stow
                local Icon = p35.Icon

                pcall(Stow, Icon)
            end

            v55 = false
        end

        return not v55
    end

    warn((("[Fishing] manor key catch failed: %*"):format(result2)))

    return false
end

local function resolveCatch(p36) -- line: 535
    -- upvalues: Fishing (copy), Remotes (copy), Toast (copy), Ui (copy), v1 (copy), v2 (copy), play (copy), finish (copy), catchKey (copy)
    p36.Phase = "Resolving"

    local function v56() -- line: 537
        -- upvalues: p36 (copy), Remotes (copy)
        return Remotes.Fishing.Reel:InvokeServer(p36.Id, "Caught", p36.Clicks)
    end

    local v57, v58, v59 = pcall(v56)

    if p36.Ended or v57 and v58 == true and type(v59) == "table" and v59.Kind == "ManorKey" and catchKey(p36, v59) then
        return
    end

    local Bobber = p36.Bobber

    if Bobber then
        Bobber:Destroy()
        p36.Bobber = nil
    end

    Ui.ShowReel(false)

    local v60, Show, t8, v61

    if v57 then
        if v58 == true and type(v59) == "table" then
            play("Catch")
            Ui.Reveal(v59, 2.6)
            finish(p36)

            return
        end

        if v58 == true then
            v61 = true
        else
            play("Escape")

            local Escaped = Fishing.Messages.Escaped

            Show = Toast.Show
            t8 = {
                Seconds = 2.5,
                Text = Escaped
            }
            v60 = v1 or v2
            v61 = false
        end
    else
        play("Escape")

        local Escaped = Fishing.Messages.Escaped

        Show = Toast.Show
        t8 = {
            Seconds = 2.5,
            Text = Escaped
        }
        v60 = v1 or v2
        v61 = false
    end

    if v61 then
        local Nothing = Fishing.Messages.Nothing

        Toast.Show({
            Seconds = 2.5,
            Text = Nothing,
            Color = v2
        })
    else
        t8.Color = v60
        Show(t8)
    end

    finish(p36)
end

local function escape(p37) -- line: 571
    -- upvalues: Fishing (copy), Line (copy), Remotes (copy), Toast (copy), Ui (copy), v1 (copy), v2 (copy), play (copy), finish (copy)
    if p37.Phase == "Reeling" then
        p37.Phase = "Resolving"

        local Id = p37.Id

        task.spawn(function() -- line: 577
            -- upvalues: Id (copy), Remotes (copy)
            local function v62() -- line: 578
                -- upvalues: Id (copy), Remotes (copy)
                Remotes.Fishing.Reel:InvokeServer(Id, "Escaped", 0)
            end

            pcall(v62)
        end)
        Ui.ShowReel(false)
        play("Escape")

        local Escaped = Fishing.Messages.Escaped

        Toast.Show({
            Seconds = 2.5,
            Text = Escaped,
            Color = v1 or v2
        })

        local Bobber = p37.Bobber
        local Return, v63

        if Bobber and Bobber.Parent ~= nil and not p37.Ended then
            Return = Line.Return
            v63 = p37.Tool:FindFirstChild("RodTip", true)

            if not v63 or not v63:IsA("Attachment") then
                v63 = nil
            end

            Return(Bobber, v63, 0.4)
        end

        finish(p37)
    end
end

local function click(p38) -- line: 588
    -- upvalues: FishingFlags (copy), Ui (copy), resolveCatch (copy)
    if p38.Phase == "Reeling" then
        p38.Clicks += 1
        p38.Fill = math.min(p38.Fill + FishingFlags.ReelClickGain:Get(), 1)
        Ui.PunchReel()

        if p38.Fill >= 1 then
            task.spawn(resolveCatch, p38)
        end
    end
end

local function startReel(p39) -- line: 600
    -- upvalues: RunService (copy), UserInputService (copy), FishingFlags (copy), Line (copy), Ui (copy), t3 (copy), play (copy), escape (copy)
    p39.Phase = "Reeling"
    p39.Fill = FishingFlags.ReelStart:Get()
    p39.Clicks = 0

    local LastInputType = UserInputService:GetLastInputType()
    local Reel = t3[if LastInputType == Enum.UserInputType.Touch then "Touch"
        elseif string.find(LastInputType.Name, "Gamepad", 1, true) then "Gamepad"
        elseif not UserInputService.TouchEnabled or UserInputService.MouseEnabled then "Mouse"
        else "Touch"].Reel

    Ui.Tooltip(false)
    Ui.SetReel(p39.Fill, 0, Reel)
    Ui.ShowReel(true, nil)

    local v66 = play("Reel", nil, {
        Looped = true
    })

    if v66 then
        p39.Trove:Add(v66)
    end

    local v67 = Ui.StopButton()

    if v67 then
        p39.Trove:Connect(v67.Activated, function() -- line: 614
            -- upvalues: p39 (copy), escape (copy)
            escape(p39)
        end)
    end

    local n3 = 0
    local n4 = 0

    p39.Trove:Connect(RunService.RenderStepped, function(p40) -- line: 620
        -- upvalues: p39 (copy), Reel (copy), v66 (copy), n3 (ref), n4 (ref), FishingFlags (copy), Line (copy), Ui (copy), escape (copy)
        if p39.Phase == "Reeling" then
            p39.Fill -= FishingFlags.ReelDrainPerSecond:Get() * p40

            local v68 = p39.Clicks - n3

            n3 = p39.Clicks
            n4 += (v68 / math.max(p40, 0.004166666666666667) - n4) * math.min(p40 * 4, 1)

            if v66 then
                v66.PlaybackSpeed = math.clamp(n4 / 12, 0, 0.6) + 0.85
            end

            local Surface, Bobber = p39.Surface, p39.Bobber

            if Bobber and Surface then
                Line.Thrash(Bobber, Surface, p39.Fill + 0.6)
            end

            Ui.SetReel(p39.Fill, p39.Clicks, Reel)

            if p39.Fill <= 0 then
                escape(p39)
            end
        end
    end)
end

local function handOff(p41, p42) -- line: 643
    -- upvalues: Line (copy), Remotes (copy), Ui (copy), result (ref), finish (copy)
    p41.Phase = "Quest"

    if p41.Id ~= 0 then
        Remotes.Fishing.Cancel:FireServer(p41.Id)
    end

    local Bobber = p41.Bobber

    if result == nil then
        local GhostDogQuestController = script.Parent:FindFirstChild("GhostDogQuestController")

        if GhostDogQuestController and GhostDogQuestController:IsA("ModuleScript") then
            local _require = require
            local ok, result2 = pcall(_require, GhostDogQuestController)

            if ok then
                result = result2
            end
        end
    end

    local result2 = result
    local v73 = true

    if Bobber == nil or result2 == nil then
    elseif type(result2.Hooked) == "function" then
        p41.HandedOff = true
        p41.Lock:Destroy()
        Ui.Tooltip(false)

        local Hooked = result2.Hooked
        local t10 = {
            Bobber = Bobber,
            Target = p42
        }
        local ok, result = pcall(Hooked, t10)

        if not ok then
            warn((("[Fishing] quest hand-off failed: %*"):format(result)))
        end

        v73 = false
    end

    if not v73 then
        if Bobber.Parent ~= nil then
            Bobber:Destroy()
        end
    else
        local Bobber = p41.Bobber
        local Return, v74

        if Bobber and Bobber.Parent ~= nil and not p41.Ended then
            Return = Line.Return
            v74 = p41.Tool:FindFirstChild("RodTip", true)

            if not v74 or not v74:IsA("Attachment") then
                v74 = nil
            end

            Return(Bobber, v74, 0.4)
        end
    end

    finish(p41)
end

local function handOffGhostFish(p43, p44) -- line: 665
    -- upvalues: Fishing (copy), Line (copy), Remotes (copy), Toast (copy), Ui (copy), v1 (copy), v2 (copy), result (ref), play (copy), finish (copy)
    p43.Phase = "Quest"

    local Bobber = p43.Bobber

    if result == nil then
        local GhostDogQuestController = script.Parent:FindFirstChild("GhostDogQuestController")

        if GhostDogQuestController and GhostDogQuestController:IsA("ModuleScript") then
            local _require = require
            local ok, result2 = pcall(_require, GhostDogQuestController)

            if ok then
                result = result2
            end
        end
    end

    local result2 = result
    local ok, result3, v75

    if Bobber == nil or result2 == nil then
        v75 = true
    elseif type(result2.GhostFish) == "function" then
        p43.HandedOff = true
        p43.Lock:Destroy()
        Ui.Tooltip(false)

        local GhostFish = result2.GhostFish
        local t11 = {
            Bobber = Bobber,
            Target = p44,
            Id = p43.Id
        }

        ok, result3 = pcall(GhostFish, t11)

        if not ok then
            warn((("[Fishing] ghost fish hand-off failed: %*"):format(result3)))
        end

        v75 = false
    else
        v75 = true
    end

    if not v75 then
        if Bobber.Parent ~= nil then
            Bobber:Destroy()
        end

        if ok and type(result3) == "table" then
            local v76 = Ui.Acquire()

            play("Catch")
            Ui.Reveal(result3, 2.6)
            v76()
        else
            play("Escape")

            local Escaped = Fishing.Messages.Escaped

            Toast.Show({
                Seconds = 2.5,
                Text = Escaped,
                Color = v1 or v2
            })
        end
    else
        if p43.Id ~= 0 then
            Remotes.Fishing.Cancel:FireServer(p43.Id)
        end

        local Bobber = p43.Bobber
        local Return, v77

        if Bobber and Bobber.Parent ~= nil and not p43.Ended then
            Return = Line.Return
            v77 = p43.Tool:FindFirstChild("RodTip", true)

            if not v77 or not v77:IsA("Attachment") then
                v77 = nil
            end

            Return(Bobber, v77, 0.4)
        end
    end

    finish(p43)
end

local function waitForBite(p45, p46, p47) -- line: 697
    -- upvalues: Fishing (copy), Line (copy), Remotes (copy), Toast (copy), v2 (copy), t4 (ref), fx (copy), play (copy), finish (copy), biteMark (copy), startReel (copy), handOff (copy), handOffGhostFish (copy)
    p45.Phase = "Waiting"

    local elapsed = os.clock()
    local v78 = elapsed + p46.Wait
    local t13 = {}

    if p46.Mode ~= "Nothing" then
        for _ = 1, math.random(1, 3) do
            table.insert(t13, elapsed + math.random() * math.max(p46.Wait - 0.8, 0.2))
        end

        table.sort(t13)
    end

    local function v82() -- line: 459
        -- upvalues: p45 (copy), t4 (ref)
        return not p45.Ended and t4 == p45
    end

    local n5 = 1
    local n6 = 0

    while v82() and p45.Phase == "Waiting" do
        local elapsed2 = os.clock()
        local Surface, Bobber = p45.Surface, p45.Bobber
        local v83, v84

        if t13[n5] and t13[n5] <= elapsed2 then
            v83 = n5 + 1
            v84 = elapsed2 + 0.25
            play("Nibble", Surface, {
                PlaybackSpeed = 0.9 + math.random() * 0.3
            })

            local v85 = fx()

            if v85 and type(v85.Ripple) == "function" then
                local Ripple = v85.Ripple
                local v86 = Surface + Vector3.new(0, 0.3, 0)

                pcall(Ripple, v86, 0.5)
            end
        else
            v84 = n6
            v83 = n5
        end

        if Bobber then
            Line.Float(Bobber, Surface, elapsed2 - elapsed, elapsed2 < v84 and 0.45 or 0)
        end

        if v78 <= elapsed2 then
            break
        end

        n6 = v84
        task.wait()
        n5 = v83
    end

    if v82() and p45.Phase == "Waiting" then
        if p46.Mode == "Nothing" then
            if p45.Id ~= 0 then
                Remotes.Fishing.Cancel:FireServer(p45.Id)
            end

            local Nothing = Fishing.Messages.Nothing

            Toast.Show({
                Seconds = 2.5,
                Text = Nothing,
                Color = v2
            })

            local Bobber = p45.Bobber
            local Return, v87

            if Bobber and Bobber.Parent ~= nil and not p45.Ended then
                Return = Line.Return
                v87 = p45.Tool:FindFirstChild("RodTip", true)

                if not v87 or not v87:IsA("Attachment") then
                    v87 = nil
                end

                Return(Bobber, v87, 0.4)
            end

            finish(p45)
        else
            play("Bite", p47)
            biteMark(p45)

            local v88 = fx()

            if v88 and type(v88.Splash) == "function" then
                local Splash = v88.Splash
                local v89 = p47 + Vector3.new(0, 0.3, 0)

                pcall(Splash, v89, 0.6)
            end

            local Bobber = p45.Bobber

            if Bobber then
                Line.Float(Bobber, p47, 0, 0.6)
            end

            if p46.Mode == "Quest" then
                p45.Phase = "Resolving"
                task.wait(0.45)

                if v82() then
                    handOff(p45, p47)
                end
            elseif p46.Mode == "GhostFish" then
                p45.Phase = "Resolving"
                task.wait(0.45)

                if v82() then
                    handOffGhostFish(p45, p47)
                end
            else
                startReel(p45)
            end
        end
    end
end

local function release(p48) -- line: 766
    -- upvalues: Fishing (copy), Line (copy), Remotes (copy), Toast (copy), Ui (copy), LocalPlayer (copy), v1 (copy), v2 (copy), t4 (ref), fx (copy), play (copy), screenPoint (copy), aimLook (copy), finish (copy), waitForBite (copy)
    if p48.Phase == "Charging" then
        local Character = LocalPlayer.Character
        local v90, v91

        if Character then
            v90 = Character:FindFirstChild("HumanoidRootPart")
            v91 = Character:FindFirstChildOfClass("Humanoid")
        else
            v91 = Character
            v90 = Character
        end

        if Character == nil or v90 == nil or not v90:IsA("BasePart") or v91 == nil then
            Character = nil
            v90 = nil
        end

        if Character == nil or v90 == nil then
            finish(p48)

            return
        end

        local v92 = os.clock() - p48.HoldStart
        local v93 = Fishing.ChargeAt(v92)
        local v94 = Fishing.IsPerfect(v93)

        p48.Phase = "Casting"
        Ui.ShowCharge(false)

        if v94 then
            local Head = Character:FindFirstChild("Head")
            local v95 = if Head and Head:IsA("BasePart") then screenPoint(Head.Position + Vector3.new(0, 2.6, 0)) else nil

            Ui.Perfect(v95)
            play("Perfect", nil, {
                PlaybackSpeed = 1.25
            })
        end

        local v96 = aimLook(Character, v90)

        p48.Face(v96)

        local v97 = Fishing.Aim(v90.Position, v96, v93)
        local v98 = Fishing.Probe(v97, { Character })
        local v99 = p48.Tool:FindFirstChild("RodTip", true)

        if not (v99 and v99:IsA("Attachment")) then
            v99 = nil
        end

        local v100 = if v99 then v99.WorldPosition else v90.Position + Vector3.new(0, 4, 0)

        p48.Bobber = Line.Spawn(v99, v100)
        p48.Surface = v98.Point
        play("Release", nil, {
            PlaybackSpeed = 0.85 + v93 * 0.3
        })
        play("LineOut", nil, {
            PlaybackSpeed = 0.9 + v93 * 0.3
        })

        local v101, v102
        local v103 = false

        if v98.Water then
            task.spawn(function() -- line: 802
                -- upvalues: v92 (copy), v98 (copy), v101 (ref), v102 (ref), v103 (ref), Remotes (copy)
                local function v104() -- line: 803
                    -- upvalues: v92 (copy), v98 (copy), Remotes (copy)
                    return Remotes.Fishing.Cast:InvokeServer(v92, v98.Point)
                end

                local v105, v106, v107 = pcall(v104)

                if not v105 or type(v106) ~= "table" then
                    if v105 and type(v107) == "string" then
                        v102 = v107
                    end
                else
                    v101 = v106
                end

                v103 = true
            end)
        end

        local function v108() -- line: 459
            -- upvalues: p48 (copy), t4 (ref)
            return not p48.Ended and t4 == p48
        end

        local Bobber = p48.Bobber

        if Bobber then
            Line.Fly(Bobber, v100, v98.Point, Fishing.FlightSeconds, v108)
        end

        if v108() then
            if v98.Water then
                play("Splash", v98.Point)

                local Point = v98.Point
                local v109 = fx()

                if v109 and type(v109.Splash) == "function" then
                    local Splash = v109.Splash
                    local v110 = Point + Vector3.new(0, 0.3, 0)

                    pcall(Splash, v110, 0.45)
                end

                local elapsed = os.clock()

                while v108() do
                    local v111 = true

                    if v103 then
                    elseif os.clock() - elapsed < 10 then
                        local Surface = p48.Surface

                        if Bobber then
                            Line.Float(Bobber, Surface, os.clock() - elapsed, 0)
                        end

                        v111 = false
                    end

                    if v111 then
                        break
                    end

                    task.wait()
                end

                if v108() then
                    local v112 = v101

                    if v112 ~= nil then
                        p48.Id = v112.Id

                        if v112.Mode == "Hint" then
                            local Hint = Fishing.Messages.Hint

                            Toast.Show({
                                Seconds = 2.5,
                                Text = Hint,
                                Color = v2
                            })
                            task.wait(0.35)

                            local Bobber = p48.Bobber

                            if Bobber and Bobber.Parent ~= nil and not p48.Ended then
                                local Return = Line.Return
                                local v115 = p48.Tool:FindFirstChild("RodTip", true)

                                if not v115 or not v115:IsA("Attachment") then
                                    v115 = nil
                                end

                                Return(Bobber, v115, 0.4)
                            end

                            finish(p48)
                        else
                            Ui.Tooltip(false)
                            waitForBite(p48, v112, v98.Point)
                        end
                    else
                        if v102 then
                            local v113 = v102

                            Toast.Show({
                                Seconds = 2.5,
                                Text = v113,
                                Color = v1 or v2
                            })
                        end

                        local Bobber = p48.Bobber
                        local Return, v114

                        if Bobber and Bobber.Parent ~= nil and not p48.Ended then
                            Return = Line.Return
                            v114 = p48.Tool:FindFirstChild("RodTip", true)

                            if not v114 or not v114:IsA("Attachment") then
                                v114 = nil
                            end

                            Return(Bobber, v114, 0.4)
                        end

                        finish(p48)
                    end
                end
            else
                local Miss = Fishing.Messages.Miss

                Toast.Show({
                    Seconds = 2.5,
                    Text = Miss,
                    Color = v1 or v2
                })
                task.wait(0.35)

                local Bobber = p48.Bobber
                local Return, v116

                if Bobber and Bobber.Parent ~= nil and not p48.Ended then
                    Return = Line.Return
                    v116 = p48.Tool:FindFirstChild("RodTip", true)

                    if not v116 or not v116:IsA("Attachment") then
                        v116 = nil
                    end

                    Return(Bobber, v116, 0.4)
                end

                finish(p48)
            end
        end
    end
end

local function press(p49) -- line: 860
    -- upvalues: RunService (copy), UserInputService (copy), Fishing (copy), FishingFlags (copy), Remotes (copy), Toast (copy), Ui (copy), LocalPlayer (copy), v2 (copy), t2 (copy), t4 (ref), v3 (ref), n1 (ref), result (ref), play (copy), besideCharacter (copy), aimLook (copy), lockControls (copy), hideBackpack (copy), hideRodLine (copy), steerFacing (copy), reelBack (copy), click (copy)
    local t16 = t4

    if t16 then
        if t16.Phase == "Reeling" then
            click(t16)
        elseif t16.Phase == "Waiting" then
            t16.Phase = "Resolving"

            if t16.Id ~= 0 then
                Remotes.Fishing.Cancel:FireServer(t16.Id)
            end

            task.spawn(reelBack, t16)
        end
    else
        local Character, HumanoidRootPart

        if not (os.clock() < n1) and FishingFlags.Enabled:Get() and Ui.Ready() then
            Character = LocalPlayer.Character
            HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

            local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

            if Character == nil or HumanoidRootPart == nil or not HumanoidRootPart:IsA("BasePart") or Humanoid == nil then
                Character = nil
                HumanoidRootPart = nil
                Humanoid = nil
            end

            if Character ~= nil and HumanoidRootPart ~= nil and Humanoid ~= nil and p49.Parent == Character then
                if FishingFlags.DimensionOnly:Get() and LocalPlayer:GetAttribute("InHalloweenDimension") ~= true and LocalPlayer:GetAttribute("InSewerCave") ~= true then
                    local Dimension = Fishing.Messages.Dimension

                    Toast.Show({
                        Seconds = 2.5,
                        Text = Dimension,
                        Color = v2
                    })
                else
                    if result == nil then
                        local GhostDogQuestController = script.Parent:FindFirstChild("GhostDogQuestController")

                        if GhostDogQuestController and GhostDogQuestController:IsA("ModuleScript") then
                            local _require = require
                            local ok, result2 = pcall(_require, GhostDogQuestController)

                            if ok then
                                result = result2
                            end
                        end
                    end

                    local result2 = result

                    if result2 and type(result2.PrepareCast) == "function" then
                        local PrepareCast = result2.PrepareCast
                        local ok, result = pcall(PrepareCast)

                        if ok and result == false then
                            return
                        end
                    end

                    local v117 = v3

                    if v117 ~= nil then
                        local v118 = v117:Extend()
                        local v119 = v118:Extend()
                        local t17 = {
                            Phase = "Charging",
                            Id = 0,
                            Bobber = nil,
                            Surface = nil,
                            Fill = 0,
                            Clicks = 0,
                            HandedOff = false,
                            Ended = false,
                            Trove = v118,
                            Lock = v119,
                            Tool = p49,
                            Face = function() -- Face | line: 905
                            end,
                            HoldStart = os.clock()
                        }

                        t4 = t17
                        v118:Add(function() -- line: 916
                            -- upvalues: t17 (copy), Remotes (copy), Ui (copy), t4 (ref)
                            if not t17.Ended then
                                t17.Ended = true

                                if t4 == t17 then
                                    t4 = nil
                                end

                                if t17.Id ~= 0 then
                                    Remotes.Fishing.Cancel:FireServer(t17.Id)
                                end

                                local Bobber = t17.Bobber

                                if Bobber and not t17.HandedOff then
                                    Bobber:Destroy()
                                end
                            end

                            Ui.ShowCharge(false)
                            Ui.ShowReel(false)
                        end)
                        Remotes.Fishing.Hold:FireServer()
                        lockControls(v119)
                        t17.Face = steerFacing(v119, Humanoid)
                        hideBackpack(v118)
                        hideRodLine(v118, p49)
                        Ui.Tooltip(false)
                        Ui.ShowCharge(true, FishingFlags.PerfectMin:Get(), FishingFlags.PerfectMax:Get())

                        local v120 = play("Charge", nil, {
                            Looped = true
                        })

                        if v120 then
                            v118:Add(v120)
                        end

                        v118:Connect(UserInputService.InputBegan, function(p50) -- line: 942
                            -- upvalues: t17 (copy), LocalPlayer (copy), t2 (copy), click (copy)
                            local Character, HumanoidRootPart

                            if not t2[p50.KeyCode] or t17.Phase == "Quest" then
                                if p50.KeyCode == Enum.KeyCode.ButtonA and t17.Phase == "Reeling" then
                                    click(t17)
                                end
                            else
                                Character = LocalPlayer.Character
                                HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

                                local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

                                if Character == nil or HumanoidRootPart == nil or not HumanoidRootPart:IsA("BasePart") or Humanoid == nil then
                                    Humanoid = nil
                                end

                                if Humanoid then
                                    Humanoid:UnequipTools()
                                end
                            end
                        end)
                        v118:Connect(RunService.RenderStepped, function() -- line: 952
                            -- upvalues: t17 (copy), v120 (copy), Fishing (copy), Ui (copy), LocalPlayer (copy), besideCharacter (copy), aimLook (copy)
                            if t17.Phase == "Charging" then
                                local Character = LocalPlayer.Character
                                local v122, v123

                                if Character then
                                    v122 = Character:FindFirstChild("HumanoidRootPart")
                                    v123 = Character:FindFirstChildOfClass("Humanoid")
                                else
                                    v123 = Character
                                    v122 = Character
                                end

                                if Character == nil or v122 == nil or not v122:IsA("BasePart") or v123 == nil then
                                    Character = nil
                                    v122 = nil
                                end

                                if v122 ~= nil then
                                    local v124 = Fishing.ChargeAt(os.clock() - t17.HoldStart)

                                    t17.Face((aimLook(Character, v122)))
                                    Ui.SetCharge(v124, Fishing.LuckText(Fishing.LuckFor(v124)), Fishing.IsPerfect(v124), besideCharacter(v122))

                                    if v120 then
                                        v120.PlaybackSpeed = 0.8 + v124 * 0.7
                                    end
                                end
                            elseif v120 and v120.Parent ~= nil then
                                v120:Destroy()
                            end
                        end)
                    end
                end
            end
        end
    end
end

local function updateTooltip(p51) -- line: 977
    -- upvalues: UserInputService (copy), Workspace (copy), FishingFlags (copy), Ui (copy), LocalPlayer (copy), t3 (copy), t4 (ref), n1 (ref), n2 (ref), v4 (ref), screenPoint (copy), waterInReach (copy)
    local t18 = t4

    if t18 and t18.Phase ~= "Waiting" then
        return
    end

    local Character = LocalPlayer.Character
    local v125, v126

    if Character then
        v125 = Character:FindFirstChild("HumanoidRootPart")
        v126 = Character:FindFirstChildOfClass("Humanoid")
    else
        v126 = Character
        v125 = Character
    end

    if Character == nil or v125 == nil or not v125:IsA("BasePart") or v126 == nil then
        Character = nil
        v125 = nil
    end

    local LastInputType = UserInputService:GetLastInputType()
    local v127 = if LastInputType == Enum.UserInputType.Touch then "Touch"
        elseif string.find(LastInputType.Name, "Gamepad", 1, true) then "Gamepad"
        elseif not UserInputService.TouchEnabled or UserInputService.MouseEnabled then "Mouse"
        else "Touch"
    local Cast = t3[v127].Cast
    local v128

    if v127 == "Mouse" then
        local CurrentCamera = Workspace.CurrentCamera

        if CurrentCamera ~= nil then
            local ViewportSize = CurrentCamera.ViewportSize
            local MouseLocation = UserInputService:GetMouseLocation()

            if not (ViewportSize.X <= 0) and not (ViewportSize.Y <= 0) then
                v128 = Vector2.new(MouseLocation.X / ViewportSize.X, MouseLocation.Y / ViewportSize.Y)
            end
        end
    elseif v125 then
        local CurrentCamera = Workspace.CurrentCamera

        v128 = (if CurrentCamera == nil then nil else screenPoint(v125.Position + CurrentCamera.CFrame.RightVector * 1.6 + Vector3.new(0, 0.6, 0))) or Ui.TouchAnchor()
    else
        v128 = Ui.TouchAnchor()
    end

    local v129, v130

    if t18 == nil and os.clock() >= n1 then
        local v131 = FishingFlags.Enabled:Get()

        if v131 then
            if Character == nil or v125 == nil then
                v130 = false
            elseif p51.Parent == Character then
                v129 = FishingFlags.DimensionOnly:Get()

                if v129 then
                    v129 = LocalPlayer:GetAttribute("InHalloweenDimension") ~= true and LocalPlayer:GetAttribute("InSewerCave") ~= true
                end

                v130 = not v129
            else
                v130 = false
            end
        else
            v130 = v131
        end
    else
        v130 = false
    end

    if v130 then
        if os.clock() >= n2 and Character and v125 then
            n2 = os.clock() + 0.1
            v4 = waterInReach(Character, v125)
        end

        v130 = v4
    else
        v4 = false
        n2 = 0
    end

    Ui.Tooltip(v130 and v128 ~= nil, Cast, v128)
end

local function onEquipped(p52) -- line: 1015
    -- upvalues: RunService (copy), UserInputService (copy), Trove (copy), Ui (copy), LocalPlayer (copy), ButtonR2 (copy), t4 (ref), v3 (ref), n2 (ref), v4 (ref), inStickZone (copy), finish (copy), release (copy), press (copy), updateTooltip (copy)
    local v132 = v3

    if v132 then
        v132:Destroy()
    end

    local v133 = Trove.new()

    v3 = v133
    n2 = 0
    v4 = false
    v133:Add(Ui.Acquire())
    v133:Add(function() -- line: 1025
        -- upvalues: Ui (copy), t4 (ref), finish (copy)
        local t19 = t4

        if t19 and not t19.HandedOff then
            finish(t19)
        end

        Ui.Tooltip(false)
    end)

    local t20 = {}
    local v134, t21
    local n7 = (-1e999)
    local v135
    local v136 = Vector2.zero
    local n8 = 0

    local function touchOwned() -- line: 1041
        -- upvalues: t20 (copy), n7 (ref)
        if next(t20) == nil then
            return os.clock() - n7 < 0.35
        end

        return true
    end

    local v137, t22
    local n9 = (-1e999)

    local function padDown() -- line: 1049
        -- upvalues: v137 (ref)
        local v138 = v137

        if v138 == nil then
            return false
        end

        local UserInputState = v138.UserInputState

        if UserInputState == Enum.UserInputState.End then
            return false
        end

        return UserInputState ~= Enum.UserInputState.Cancel
    end

    local function promoteTouch() -- line: 1081
        -- upvalues: p52 (copy), v134 (ref), t21 (ref), v135 (ref), v136 (ref), n8 (ref), LocalPlayer (copy), t4 (ref), press (copy)
        local v139 = v135

        if v139 ~= nil then
            local UserInputState = v139.UserInputState

            if UserInputState == Enum.UserInputState.End or UserInputState == Enum.UserInputState.Cancel or (Vector2.new(v139.Position.X, v139.Position.Y) - v136).Magnitude > 12 then
                v135 = nil
            elseif not (os.clock() - n8 < 0.13) then
                v135 = nil

                if t4 == nil then
                    local Character = LocalPlayer.Character
                    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
                    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

                    if Character == nil or HumanoidRootPart == nil or not HumanoidRootPart:IsA("BasePart") or Humanoid == nil then
                        Humanoid = nil
                    end

                    if Humanoid == nil or not (Humanoid.MoveDirection.Magnitude > 0.1) then
                        press(p52)

                        local t23 = t4

                        if t23 and t23.Phase == "Charging" then
                            v134 = v139
                            t21 = t23
                        end
                    end
                end
            end
        end
    end

    local function endTouch(p53) -- line: 1111
        -- upvalues: t20 (copy), v134 (ref), t21 (ref), n7 (ref), v135 (ref), t4 (ref), release (copy)
        if t20[p53] then
            t20[p53] = nil
            n7 = os.clock()
        end

        if p53 == v135 then
            v135 = nil
        end

        if p53 ~= v134 then
            return
        end

        local t24 = t21

        v134 = nil
        t21 = nil

        if t24 and t4 == t24 and t24.Phase == "Charging" then
            task.spawn(release, t24)
        end
    end

    v133:Connect(p52.Activated, function() -- line: 1130
        -- upvalues: p52 (copy), t20 (copy), n7 (ref), v137 (ref), t22 (ref), n9 (ref), t4 (ref), press (copy)
        if next(t20) == nil and not (os.clock() - n7 < 0.35) and (t4 == nil or not (os.clock() - n9 < 0.35)) then
            press(p52)

            local t25 = t4

            if t22 ~= nil then
                return
            end

            local v140 = v137

            if v140 ~= nil then
                local UserInputState = v140.UserInputState

                if UserInputState ~= Enum.UserInputState.End and UserInputState ~= Enum.UserInputState.Cancel and t25 and t25.Phase == "Charging" and os.clock() - t25.HoldStart < 0.25 then
                    t22 = t25
                end
            end
        end
    end)
    v133:Connect(p52.Deactivated, function() -- line: 1140
        -- upvalues: t20 (copy), n7 (ref), t22 (ref), t4 (ref), release (copy)
        if next(t20) == nil and not (os.clock() - n7 < 0.35) and t22 == nil then
            local t26 = t4

            if t26 and t26.Phase == "Charging" then
                task.spawn(release, t26)
            end
        end
    end)
    v133:Connect(UserInputService.InputBegan, function(p54, p55) -- line: 1149
        -- upvalues: p52 (copy), t20 (copy), n7 (ref), v135 (ref), v136 (ref), n8 (ref), v137 (ref), t22 (ref), n9 (ref), LocalPlayer (copy), ButtonR2 (copy), t4 (ref), inStickZone (copy), press (copy)
        if p54.KeyCode == ButtonR2 then
            v137 = p54
            n9 = os.clock()

            local t27 = t4

            if t27 and (t27.Phase == "Reeling" or t27.Phase == "Waiting") then
                press(p52)
            else
                local t28 = t4

                if t22 == nil then
                    local v141 = v137

                    if v141 ~= nil then
                        local UserInputState = v141.UserInputState

                        if UserInputState ~= Enum.UserInputState.End and UserInputState ~= Enum.UserInputState.Cancel and t28 and t28.Phase == "Charging" and os.clock() - t28.HoldStart < 0.25 then
                            t22 = t28
                        end
                    end
                end
            end
        elseif p54.UserInputType == Enum.UserInputType.Touch and not p55 then
            t20[p54] = true
            n7 = os.clock()

            local t29 = t4

            if not t29 or t29.Phase ~= "Charging" then
                local v142 = Vector2.new(p54.Position.X, p54.Position.Y)

                if not inStickZone(v142) then
                    if t29 then
                        press(p52)
                    elseif v135 == nil then
                        local Character = LocalPlayer.Character
                        local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
                        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

                        if Character == nil or HumanoidRootPart == nil or not HumanoidRootPart:IsA("BasePart") or Humanoid == nil then
                            Humanoid = nil
                        end

                        if Humanoid == nil or not (Humanoid.MoveDirection.Magnitude > 0.1) then
                            v135 = p54
                            v136 = v142
                            n8 = os.clock()
                        end
                    end
                end
            end
        end
    end)
    v133:Connect(UserInputService.InputEnded, function(p56) -- line: 1185
        -- upvalues: v137 (ref), t22 (ref), n9 (ref), endTouch (copy), ButtonR2 (copy), t4 (ref), release (copy)
        if p56.UserInputType == Enum.UserInputType.Touch then
            endTouch(p56)
        elseif p56.KeyCode == ButtonR2 then
            v137 = nil
            n9 = os.clock()

            local t30 = t22

            t22 = nil

            if t30 and t4 == t30 and t30.Phase == "Charging" then
                task.spawn(release, t30)
            end
        end
    end)
    v133:Connect(RunService.RenderStepped, function() -- line: 1192
        -- upvalues: p52 (copy), t20 (copy), v137 (ref), t22 (ref), n9 (ref), promoteTouch (copy), endTouch (copy), t4 (ref), release (copy), updateTooltip (copy)
        if v137 then
            local v143 = v137
            local v144 = false

            if v143 ~= nil then
                local UserInputState = v143.UserInputState

                v144 = UserInputState ~= Enum.UserInputState.End and UserInputState ~= Enum.UserInputState.Cancel
            end

            if not v144 then
                v137 = nil
                n9 = os.clock()

                local t31 = t22

                t22 = nil

                if t31 and t4 == t31 and t31.Phase == "Charging" then
                    task.spawn(release, t31)
                end
            end
        end

        for v145 in t20 do
            local UserInputState = v145.UserInputState

            if UserInputState == Enum.UserInputState.End or UserInputState == Enum.UserInputState.Cancel then
                endTouch(v145)
            end
        end

        promoteTouch()
        updateTooltip(p52)
    end)
end

local function watchCharacter(p57, p58) -- line: 1223
    -- upvalues: Fishing (copy), t4 (ref), v3 (ref), onEquipped (copy)
    local v146 = p58:Extend()

    v146:Connect(p57.ChildAdded, function(p59) -- line: 1225
        -- upvalues: Fishing (copy), onEquipped (copy)
        if Fishing.IsRod(p59) then
            onEquipped(p59)
        end
    end)
    v146:Connect(p57.ChildRemoved, function(p60) -- line: 1230
        -- upvalues: Fishing (copy), t4 (ref), v3 (ref)
        if not Fishing.IsRod(p60) then
            return
        end

        local v147 = v3

        if v147 == nil then
            return
        end

        local t32 = t4

        if t32 and t32.Tool ~= p60 or t32 and t32.HandedOff then
            return
        end

        v3 = nil
        v147:Destroy()
    end)
    v146:Connect(p57.AncestryChanged, function() -- line: 1235
        -- upvalues: p57 (copy), v146 (copy)
        if p57.Parent == nil then
            v146:Destroy()
        end
    end)
    v146:Add(function() -- line: 1240
        -- upvalues: t4 (ref), v3 (ref)
        local v148 = v3
        local t33 = t4

        if not (not v148 or t33 and t33.HandedOff) then
            v3 = nil
            v148:Destroy()
        end
    end)

    local v149 = Fishing.EquippedRod(p57)

    if v149 then
        onEquipped(v149)
    end
end

function t5.Start() -- line: 1254
    -- upvalues: Spots (copy), Trove (copy), LocalPlayer (copy), t4 (ref), v3 (ref), watchCharacter (copy)
    local v150 = Trove.new()

    v150:Connect(LocalPlayer.CharacterAdded, function(p61) -- line: 1256
        -- upvalues: v150 (copy), watchCharacter (copy)
        watchCharacter(p61, v150)
    end)

    if LocalPlayer.Character then
        watchCharacter(LocalPlayer.Character, v150)
    end

    Spots.Start(v150, function() -- line: 1262
        -- upvalues: t4 (ref)
        return t4 ~= nil
    end)
    v150:Add(function() -- line: 1265
        -- upvalues: v3 (ref)
        local v151 = v3

        v3 = nil

        if v151 then
            v151:Destroy()
        end
    end)

    return v150
end

return t5
