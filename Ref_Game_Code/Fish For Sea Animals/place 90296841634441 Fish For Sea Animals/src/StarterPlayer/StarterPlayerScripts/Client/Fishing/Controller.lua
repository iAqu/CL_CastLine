-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")
local Animals = require(ReplicatedStorage.Shared.Animals)
local Config = require(ReplicatedStorage.Shared.Config)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Hud = require(script.Parent.Parent.UI.Hud)
local RodShop = require(script.Parent.Parent.UI.RodShop)
local SellPanel = require(script.Parent.Parent.UI.SellPanel)
local Backpack = require(script.Parent.Parent.UI.Backpack)
local Menus = require(script.Parent.Parent.UI.Menus)
local Settings = require(script.Parent.Parent.UI.Settings)
local Offers = require(script.Parent.Parent.Shop.Offers)
local Poses = require(script.Parent.Parent.Character.Poses)
local Controls = require(script.Parent.Parent.Character.Controls)
local PowerMeter = require(script.Parent.PowerMeter)
local CastFlight = require(script.Parent.CastFlight)
local BestMarker = require(script.Parent.Parent.World.BestMarker)
local Reveal = require(script.Parent.Reveal)
local Reel = require(script.Parent.Reel)
local Approach = require(script.Parent.Approach)
local Skip = require(script.Parent.Skip)
local Effects = require(script.Parent.Effects)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local v1 = "Idle"
local v2 = false
local n1 = 0
local v3
local World1 = workspace:WaitForChild("Map"):WaitForChild("World1")
local CastZone = World1:WaitForChild("FishingDock"):WaitForChild("CastZone")
local v4 = CastZone

local function castZones() -- line: 53
    -- upvalues: CastZone (copy)
    local World2 = workspace.Map:FindFirstChild("World2")
    local FishingDock = World2 and World2:FindFirstChild("FishingDock")
    local CastZone2 = FishingDock and FishingDock:FindFirstChild("CastZone")

    if CastZone2 then
        return { CastZone, CastZone2 }
    end

    return { CastZone }
end

local function v5() -- line: 59
    return false
end

local function character() -- line: 63
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local v6, v7

    if Character then
        v6 = Character:FindFirstChildOfClass("Humanoid")
        v7 = Character:FindFirstChild("HumanoidRootPart")
    else
        v7 = Character
        v6 = Character
    end

    if v6 and v7 and v6.Health > 0 then
        return Character, v6, v7
    end

    return nil, nil, nil
end

local function inZone(p1, p2) -- line: 74
    -- upvalues: v4 (ref), castZones (copy)
    for _, v8 in castZones() do
        local v9 = v8.CFrame:PointToObjectSpace(p1)
        local v10 = v8.Size / 2

        if math.abs(v9.X) <= v10.X and math.abs(v9.Z) <= v10.Z and (p2 or math.abs(v9.Y) <= v10.Y + 4) then
            v4 = v8

            return true
        end
    end

    return false
end

local function rodTip() -- line: 86
    -- upvalues: LocalPlayer (copy)
    local v11 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("RodModel")

    return v11 and v11:FindFirstChild("RodTip", true)
end

local function cutsceneGui() -- line: 91
    -- upvalues: UIUtil (copy)
    return UIUtil.gui("Cutscene")
end

local function spotFor(p3) -- line: 100
    -- upvalues: Players (copy), LocalPlayer (copy), v4 (ref)
    local v12 = v4.Size / 2
    local t2 = {}

    for _, player in Players:GetPlayers() do
        local v13 = player ~= LocalPlayer and player.Character

        v13 = v13 and v13:GetAttribute("Fishing") and v13:FindFirstChild("HumanoidRootPart")

        if v13 then
            table.insert(t2, v4.CFrame:PointToObjectSpace(v13.Position).X)
        end
    end

    local v15 = math.floor((v12.X - 3) / 5) * 2
    local n2 = 0

    for i = 0, v15 do
        n2 = math.ceil(i / 2) * 5 * (if i % 2 == 1 then 1 else -1)

        local v17 = true

        for _, v18 in t2 do
            if math.abs(v18 - n2) < 4.5 then
                v17 = false
                break
            end
        end

        if v17 then
            break
        end

        n2 = 0
    end

    local v21 = v4.CFrame:PointToWorldSpace((Vector3.new(n2, 0, -v12.Z + 2.5)))
    local v22 = Vector3.new(v21.X, p3.Position.Y, v21.Z)

    return CFrame.lookAt(v22, v22 + Vector3.new(0, 0, -1))
end

local function fishingView() -- line: 131
    -- upvalues: v3 (ref)
    return CFrame.lookAt(v3.Position + Vector3.new(5, 5.5, 12), v3.Position + Vector3.new(0, -6, -70))
end

local function aimView() -- line: 135
    -- upvalues: v3 (ref)
    return CFrame.lookAt(v3.Position + Vector3.new(4, 4.5, 10), v3.Position + Vector3.new(0, -8, -70))
end

local function resetCamera() -- line: 139
    -- upvalues: LocalPlayer (copy)
    local CurrentCamera = workspace.CurrentCamera
    local Character = LocalPlayer.Character
    local v23 = Character

    if Character then
        v23 = Character:FindFirstChildOfClass("Humanoid")
        Character = Character:FindFirstChild("HumanoidRootPart")
    end

    if not (v23 and Character and v23.Health > 0) then
        v23 = nil
    end

    CurrentCamera.CameraType = Enum.CameraType.Custom
    CurrentCamera.FieldOfView = 70

    if v23 then
        CurrentCamera.CameraSubject = v23
    end
end

local v24, v25

local function setAmbience(p4) -- line: 154
    -- upvalues: SoundService (copy), UIUtil (copy)
    local Ambience = SoundService:FindFirstChild("Ambience")

    if not Ambience then
        return
    end

    UIUtil.tween(Ambience, if p4 then 1 else 0.6, {
        Volume = if p4 then Ambience:GetAttribute("FullVolume") or 0.35 else 0
    })
end

local function startDockSound() -- line: 161
    -- upvalues: SoundService (copy), UIUtil (copy), v25 (ref)
    local Ambience = SoundService:FindFirstChild("Ambience")

    if Ambience then
        UIUtil.tween(Ambience, 0.6, {
            Volume = 0
        })
    end

    if not v25 then
        v25 = UIUtil.sound("Dock", 0, 1, 1E+06)

        if v25 then
            v25.Looped = true
            UIUtil.tween(v25, 0.6, {
                Volume = 0.5
            })
        end
    end
end

local function stopDockSound() -- line: 173
    -- upvalues: SoundService (copy), UIUtil (copy), v25 (ref)
    local Ambience = SoundService:FindFirstChild("Ambience")

    if Ambience then
        UIUtil.tween(Ambience, 1, {
            Volume = Ambience:GetAttribute("FullVolume") or 0.35
        })
    end

    local v27 = v25

    v25 = nil

    if not v27 then
        return
    end

    UIUtil.tween(v27, 0.4, {
        Volume = 0
    })
    task.delay(0.4, function() -- line: 179
        -- upvalues: v27 (copy)
        v27:Destroy()
    end)
end

local function setDockVolume(p5) -- line: 185
    -- upvalues: UIUtil (copy), v25 (ref)
    if v25 then
        UIUtil.tween(v25, 0.5, {
            Volume = p5
        })
    end
end

local function swayCamera() -- line: 193
    -- upvalues: RunService (copy), v1 (ref), v3 (ref)
    local CurrentCamera = workspace.CurrentCamera
    local _CFrame = CurrentCamera.CFrame
    local v28 = CFrame.lookAt(v3.Position + Vector3.new(4, 4.5, 10), v3.Position + Vector3.new(0, -8, -70))
    local elapsed = os.clock()

    while v1 == "Aiming" do
        local v29 = os.clock() - elapsed
        local v31 = math.min(v29 / 0.45, 1)
        local v32 = _CFrame:Lerp(v28, v31 * v31 * (3 - v31 * 2))
        local v34 = math.min(v29 / 1.2, 1)
        local v39 = Vector3.new(math.sin(v29 * 0.7) * 0.18, math.sin(v29 * 1.1) * 0.12, 0) * v34
        local v48 = CFrame.Angles(math.rad(math.sin(v29 * 0.9) * 0.5), math.rad(math.sin(v29 * 0.55) * 0.7), (math.rad(math.sin(v29 * 0.8) * 0.9)))

        CurrentCamera.CFrame = v32 * CFrame.new(v39) * v48:Lerp(CFrame.identity, 1 - v34)
        RunService.RenderStepped:Wait()
    end
end

local function startAiming() -- line: 212
    -- upvalues: UIUtil (copy), Hud (copy), Poses (copy), PowerMeter (copy), v1 (ref), v24 (ref), v25 (ref), swayCamera (copy)
    v1 = "Aiming"

    if v25 then
        UIUtil.tween(v25, 0.5, {
            Volume = 0.5
        })
    end

    Hud.setVisible(false)
    Hud.setHint(nil)
    Hud.showExit(v24, true)
    task.spawn(swayCamera)
    PowerMeter.start()
    Poses.play("Aim")
end

local function enter(p6) -- line: 223
    -- upvalues: Remotes (copy), UIUtil (copy), Hud (copy), RodShop (copy), SellPanel (copy), Backpack (copy), Menus (copy), Controls (copy), Effects (copy), v1 (ref), v2 (ref), v3 (ref), spotFor (copy), startDockSound (copy), startAiming (copy)
    v1 = "Entering"
    v2 = false

    for _, v49 in { RodShop, SellPanel } do
        if v49.isOpen() then
            task.spawn(v49.close)
        end
    end

    Menus.closeAll()
    Hud.setVisible(false)
    Backpack.setVisible(false)
    Controls.lock("Fishing")

    local Cutscene = UIUtil.gui("Cutscene")

    Effects.fade(Cutscene, true, 0.35)

    local InvokeServer = Remotes.FishMode.InvokeServer
    local FishMode = Remotes.FishMode
    local ok, result = pcall(InvokeServer, FishMode, true)

    if ok and result and p6.Parent then
        v3 = spotFor(p6)
        startDockSound()
        Controls.lock("Fishing", v3)

        local CurrentCamera = workspace.CurrentCamera

        CurrentCamera.CameraType = Enum.CameraType.Scriptable
        CurrentCamera.FieldOfView = 70
        CurrentCamera.CFrame = CFrame.lookAt(v3.Position + Vector3.new(5, 5.5, 12), v3.Position + Vector3.new(0, -6, -70))
        Effects.fade(Cutscene, false, 0.45)

        if v1 == "Entering" then
            startAiming()
        end
    else
        Controls.unlock("Fishing")
        Hud.setVisible(true)
        Backpack.setVisible(true)
        v1 = "Idle"
        Effects.fade(Cutscene, false, 0.35)
    end
end

v24 = function() -- line: 259
    -- upvalues: Remotes (copy), UIUtil (copy), Hud (copy), Backpack (copy), Poses (copy), Controls (copy), PowerMeter (copy), Effects (copy), LocalPlayer (copy), v1 (ref), stopDockSound (copy)
    if v1 ~= "Aiming" then
        return
    end

    v1 = "Leaving"
    stopDockSound()
    PowerMeter.cancel()
    Poses.clear()
    Hud.setHint(nil)
    Hud.hideExit()

    local Cutscene = UIUtil.gui("Cutscene")

    Effects.fade(Cutscene, true, 0.3)

    local InvokeServer = Remotes.FishMode.InvokeServer
    local FishMode = Remotes.FishMode

    pcall(InvokeServer, FishMode, false)

    local CurrentCamera = workspace.CurrentCamera
    local Character = LocalPlayer.Character
    local v50 = Character

    if Character then
        v50 = Character:FindFirstChildOfClass("Humanoid")
        Character = Character:FindFirstChild("HumanoidRootPart")
    end

    if not (v50 and Character and v50.Health > 0) then
        v50 = nil
    end

    CurrentCamera.CameraType = Enum.CameraType.Custom
    CurrentCamera.FieldOfView = 70

    if v50 then
        CurrentCamera.CameraSubject = v50
    end

    Controls.unlock("Fishing")
    Hud.setVisible(true)
    Backpack.setVisible(true)
    v1 = "Idle"
    Effects.fade(Cutscene, false, 0.4)

    if v1 == "Idle" then
        Cutscene.Enabled = false
    end
end

local function abort() -- line: 284
    -- upvalues: UIUtil (copy), Hud (copy), Backpack (copy), Poses (copy), Controls (copy), PowerMeter (copy), Effects (copy), LocalPlayer (copy), v1 (ref), stopDockSound (copy)
    if v1 == "Idle" then
        return
    end

    stopDockSound()
    PowerMeter.cancel()
    Poses.clear()
    Hud.setHint(nil)
    Hud.hideExit()
    Hud.setVisible(true)

    local CurrentCamera = workspace.CurrentCamera
    local Character = LocalPlayer.Character
    local v51 = Character

    if Character then
        v51 = Character:FindFirstChildOfClass("Humanoid")
        Character = Character:FindFirstChild("HumanoidRootPart")
    end

    if not (v51 and Character and v51.Health > 0) then
        v51 = nil
    end

    CurrentCamera.CameraType = Enum.CameraType.Custom
    CurrentCamera.FieldOfView = 70

    if v51 then
        CurrentCamera.CameraSubject = v51
    end

    Controls.unlock("Fishing")
    Backpack.setVisible(true)

    local Cutscene = UIUtil.gui("Cutscene")

    Effects.letterbox(Cutscene, false)
    Cutscene.Fade.BackgroundTransparency = 1
    Cutscene.Enabled = false
    v1 = "Idle"
end

local function clearCutscene(p7) -- line: 304
    -- upvalues: Poses (copy), Effects (copy)
    Poses.clear()
    Effects.letterbox(p7, false)

    for _, v52 in { "CastInfo", "Banner", "Hooked", "Odds", "Continue", "LuckTitle", "Skip", "Reel" } do
        local v53 = p7:FindFirstChild(v52)

        if v53 then
            v53.Visible = false
        end
    end
end

local function backToDock() -- line: 316
    -- upvalues: Remotes (copy), v3 (ref), cutsceneGui (copy), startAiming (copy), clearCutscene (copy)
    clearCutscene(cutsceneGui())

    local CurrentCamera = workspace.CurrentCamera

    CurrentCamera.FieldOfView = 70
    CurrentCamera.CFrame = CFrame.lookAt(v3.Position + Vector3.new(5, 5.5, 12), v3.Position + Vector3.new(0, -6, -70))
    Remotes.CastDone:FireServer()
    startAiming()
end

local function myPlotSpawn() -- line: 326
    -- upvalues: Config (copy), LocalPlayer (copy)
    local v54 = Config.plotOf(LocalPlayer.UserId, Config.playerWorld(LocalPlayer))

    return v54 and v54:FindFirstChild("Spawn")
end

local function goHome(p8) -- line: 333
    -- upvalues: Config (copy), Remotes (copy), UIUtil (copy), Hud (copy), Backpack (copy), Settings (copy), Controls (copy), Effects (copy), LocalPlayer (copy), v1 (ref), v2 (ref), n1 (ref), World1 (copy), stopDockSound (copy), clearCutscene (copy)
    v1 = "Leaving"
    stopDockSound()

    local Cutscene = UIUtil.gui("Cutscene")

    Effects.fade(Cutscene, true, 0.35)
    clearCutscene(Cutscene)
    Remotes.CastDone:FireServer()

    local InvokeServer = Remotes.FishMode.InvokeServer
    local FishMode = Remotes.FishMode

    pcall(InvokeServer, FishMode, false)
    Controls.unlock("Fishing")

    local Character = LocalPlayer.Character
    local v55, v56

    if Character then
        v55 = Character:FindFirstChildOfClass("Humanoid")
        v56 = Character:FindFirstChild("HumanoidRootPart")
    else
        v56 = Character
        v55 = Character
    end

    if not (v55 and v56 and v55.Health > 0) then
        Character = nil
        v55 = nil
        v56 = nil
    end

    local v57 = Config.plotOf(LocalPlayer.UserId, Config.playerWorld(LocalPlayer))
    local Spawn = v57 and v57:FindFirstChild("Spawn")

    if Character and Spawn then
        v56.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

        local v59 = Spawn.CFrame + Vector3.new(0, Spawn.Size.Y / 2 + v55.HipHeight + v56.Size.Y / 2, 0)

        if LocalPlayer:GetAttribute("Tutorial") == 2 then
            local Deck = World1.FishingDock:FindFirstChild("Deck")
            local v60 = if Deck then Vector3.new(Deck.Position.X - Spawn.Position.X, 0, Deck.Position.Z - Spawn.Position.Z) else Vector3.new(0, 0, 0)
            local v63 = if v60.Magnitude > 1 then v60.Unit else Vector3.new(0, 0, -1)
            local v64 = v59.Position + v63 * 17

            v59 = CFrame.lookAt(v64, (Vector3.new(Spawn.Position.X, v64.Y, Spawn.Position.Z)))
            workspace.CurrentCamera.CFrame = CFrame.lookAt(v64 + v63 * 12 + Vector3.new(0, 7, 0), v64 - v63 * 10)
        end

        Character:PivotTo(v59)
    end

    local CurrentCamera = workspace.CurrentCamera
    local Character2 = LocalPlayer.Character
    local v65 = Character2

    if Character2 then
        v65 = Character2:FindFirstChildOfClass("Humanoid")
        Character2 = Character2:FindFirstChild("HumanoidRootPart")
    end

    if not (v65 and Character2 and v65.Health > 0) then
        v65 = nil
    end

    CurrentCamera.CameraType = Enum.CameraType.Custom
    CurrentCamera.FieldOfView = 70

    if v65 then
        CurrentCamera.CameraSubject = v65
    end

    Hud.setVisible(true)
    Backpack.setVisible(true)
    v2 = false
    v1 = "Idle"

    if p8 and Spawn then
        Remotes.HoldAnimal:FireServer(p8)

        if n1 < 3 and not Settings.get("KeepFishing") and (LocalPlayer:GetAttribute("Tutorial") or 0) >= Config.TutorialDone then
            n1 += 1
            task.delay(1.2, UIUtil.toast, "Tip: turn on KEEP FISHING on the dock to stay at the water after a catch!")
        end
    end

    Effects.fade(Cutscene, false, 0.45)

    if v1 == "Idle" then
        Cutscene.Enabled = false
    end
end

local function castScene() -- line: 379
    -- upvalues: RunService (copy), Animals (copy), Config (copy), Remotes (copy), UIUtil (copy), Hud (copy), Offers (copy), Poses (copy), PowerMeter (copy), CastFlight (copy), Reveal (copy), Reel (copy), Approach (copy), Skip (copy), Effects (copy), LocalPlayer (copy), v1 (ref), v3 (ref), cutsceneGui (copy), v25 (ref), startAiming (copy), clearCutscene (copy), goHome (copy)
    v1 = "Casting"
    Hud.hideExit()

    local v66, _, v67 = PowerMeter.stop()

    if v25 then
        UIUtil.tween(v25, 0.5, {
            Volume = 0
        })
    end

    local n3 = 0

    if v67 then
        UIUtil.sound("GoodCast", 0.9)
        n3 = 0.55
    end

    local Cutscene = UIUtil.gui("Cutscene")

    Cutscene.Enabled = true
    Effects.letterbox(Cutscene, true)

    local v68 = UIUtil.sound("CastSwing", 0.9)

    if v68 then
        v68.Ended:Once(function() -- line: 398
            -- upvalues: UIUtil (copy)
            UIUtil.sound("CastLine", 0.6)
        end)
    end

    Poses.play("Cast")

    local elapsed = os.clock()
    local CurrentCamera = workspace.CurrentCamera
    local _CFrame = CurrentCamera.CFrame
    local v69 = CFrame.lookAt(v3.Position + Vector3.new(-4, 2.2, -11), v3.Position + Vector3.new(0, 1.4, 0))

    task.spawn(function() -- line: 408
        -- upvalues: n3 (ref), elapsed (copy), CurrentCamera (copy), _CFrame (copy), v69 (copy), RunService (copy), Config (copy), Poses (copy), Effects (copy), v1 (ref)
        while v1 == "Casting" do
            local v70 = os.clock() - elapsed

            if Poses.RELEASE <= v70 then
                break
            end

            local v72 = math.min(v70 / (0.4 * Config.CastPace), 1)
            local v73 = _CFrame:Lerp(v69, 1 - (1 - v72) ^ 3)

            CurrentCamera.FieldOfView = 70 - v72 * 14
            CurrentCamera.CFrame = Effects.shake(v73, 0.03 + 0.2 * (v70 / Poses.RELEASE) ^ 2 + n3 * math.max(0, 1 - v70 / (0.45 * Config.CastPace)))
            RunService.RenderStepped:Wait()
        end
    end)

    local function v77() -- line: 422
        -- upvalues: v66 (copy), Remotes (copy)
        return Remotes.Cast:InvokeServer(v66)
    end

    local ok, result = pcall(v77)

    if ok and type(result) == "table" and result.ok then
        task.wait((math.max(0, Poses.RELEASE - (os.clock() - elapsed))))

        local v79 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("RodModel")
        local v80 = v79 and v79:FindFirstChild("RodTip", true)

        if v80 then
            Hud.setVisible(false)
            Effects.flash(Cutscene, Color3.new(1, 1, 1), 0.3, 0.55)
            Skip.start(Cutscene, false)

            local v81
            local v82 = false
            local result2

            local function land(p9) -- line: 448
                -- upvalues: result (copy), v81 (ref), v82 (ref), result2 (ref), Remotes (copy)
                v81 = p9

                local InvokeServer = Remotes.Land.InvokeServer
                local Land = Remotes.Land
                local ok, result3 = pcall(InvokeServer, Land, p9)

                if p9 and ok and type(result3) == "table" then
                    result.Uid = result3.Uid
                    result2 = if result3.Stay == true then result3 else nil
                end

                local v83 = not p9

                if v83 then
                    if ok then
                        ok = type(result3) == "table" and result3.Save == true
                    end
                else
                    ok = v83
                end

                v82 = ok
            end

            local function v84() -- line: 457
                -- upvalues: Cutscene (copy), result (copy), v80 (copy), land (copy), Remotes (copy), CastFlight (copy), Reveal (copy), Reel (copy), Approach (copy), Skip (copy), LocalPlayer (copy)
                local v85 = CastFlight.run(result, v80, Cutscene, true)

                Skip.start(Cutscene, not result.IsNew)
                Approach.run(v85, result, Cutscene)
                Skip.stop()

                if LocalPlayer:GetAttribute("Tutorial") == 1 then
                    Remotes.Tutorial:FireServer("Reeling")
                end

                local v86 = Reel.run(v85, result, Cutscene)

                land(v86)

                if v86 then
                    Reveal.show(v85, result, Cutscene)
                else
                    v85.bobber:Destroy()
                end
            end

            local ok, result3 = pcall(v84)

            Skip.stop()

            if not ok then
                warn("Cast cutscene error: " .. tostring(result3))
                Reel.cleanup()
                Reveal.cleanup()

                for _, v87 in { "Bobber", "FishPOV", "Reveal", "WaterCover" } do
                    local v88 = workspace:FindFirstChild(v87)

                    if v88 then
                        v88:Destroy()
                    end
                end

                if v81 == nil then
                    v81 = true

                    local InvokeServer = Remotes.Land.InvokeServer
                    local Land = Remotes.Land
                    local ok, result3 = pcall(InvokeServer, Land, true)

                    if ok and type(result3) == "table" then
                        result.Uid = result3.Uid
                        result2 = if result3.Stay == true then result3 else nil
                    end

                    v82 = false
                end
            end

            if v1 == "Casting" then
                if v81 == false then
                    Effects.fade(Cutscene, true, 0.3)
                    clearCutscene(cutsceneGui())

                    local CurrentCamera = workspace.CurrentCamera

                    CurrentCamera.FieldOfView = 70
                    CurrentCamera.CFrame = CFrame.lookAt(v3.Position + Vector3.new(5, 5.5, 12), v3.Position + Vector3.new(0, -6, -70))
                    Remotes.CastDone:FireServer()
                    startAiming()
                    Effects.fade(Cutscene, false, 0.35)

                    if v82 then
                        Offers.escapeSave(result)
                    elseif type(result.Fight) == "table" and (tonumber(result.Fight.Ratio) or 0) >= Config.TooStrongRatio then
                        Offers.needRod()
                    end
                else
                    local v89 = Animals.get(result.Id)

                    if v89 and Config.RarityByName[v89.Rarity].Index >= Config.RarityByName.Rare.Index then
                        Offers.luckMoment()
                    end

                    local result3 = result2

                    if result3 then
                        Effects.fade(Cutscene, true, 0.3)
                        clearCutscene(cutsceneGui())

                        local CurrentCamera = workspace.CurrentCamera

                        CurrentCamera.FieldOfView = 70
                        CurrentCamera.CFrame = CFrame.lookAt(v3.Position + Vector3.new(5, 5.5, 12), v3.Position + Vector3.new(0, -6, -70))
                        Remotes.CastDone:FireServer()
                        startAiming()
                        Effects.fade(Cutscene, false, 0.35)
                    else
                        goHome(result.Uid)
                    end
                end
            end
        else
            clearCutscene(cutsceneGui())

            local CurrentCamera = workspace.CurrentCamera

            CurrentCamera.FieldOfView = 70
            CurrentCamera.CFrame = CFrame.lookAt(v3.Position + Vector3.new(5, 5.5, 12), v3.Position + Vector3.new(0, -6, -70))
            Remotes.CastDone:FireServer()
            startAiming()
        end
    else
        UIUtil.toast(if not ok or type(result) ~= "table" then "Cast failed, try again!" else result.msg, "error")
        task.wait(0.4)
        clearCutscene(cutsceneGui())

        local CurrentCamera = workspace.CurrentCamera

        CurrentCamera.FieldOfView = 70
        CurrentCamera.CFrame = CFrame.lookAt(v3.Position + Vector3.new(5, 5.5, 12), v3.Position + Vector3.new(0, -6, -70))
        Remotes.CastDone:FireServer()
        startAiming()
    end
end

local function recover() -- line: 526
    -- upvalues: Remotes (copy), Reveal (copy), Reel (copy), v1 (ref), abort (copy), goHome (copy)
    local cleanup = Reel.cleanup

    pcall(cleanup)

    local cleanup2 = Reveal.cleanup

    pcall(cleanup2)

    for _, v93 in { "Bobber", "FishPOV", "Reveal", "WaterCover" } do
        local v94 = workspace:FindFirstChild(v93)

        if v94 then
            v94:Destroy()
        end
    end

    local ok, result = pcall(goHome, nil)

    if not ok then
        warn("Cast recovery error: " .. tostring(result))
        Remotes.CastDone:FireServer()
        task.spawn(pcall, Remotes.FishMode.InvokeServer, Remotes.FishMode, false)
        abort()
    end

    if v1 ~= "Idle" then
        abort()
    end
end

local function cast() -- line: 547
    -- upvalues: BestMarker (copy), castScene (copy), recover (copy)
    BestMarker.freeze()

    local ok, result = pcall(castScene)

    BestMarker.release()

    if not ok then
        warn("Cast error: " .. tostring(result))
        recover()
    end
end

function t1.isBusy() -- line: 557
    -- upvalues: v1 (ref)
    return v1 ~= "Idle"
end

function t1.leaveDock() -- line: 563
    -- upvalues: v1 (ref), v24 (ref)
    if v1 == "Aiming" then
        task.spawn(v24)
    end
end

function t1.stateName() -- line: 570
    -- upvalues: v1 (ref)
    return v1
end

function t1.isAiming() -- line: 575
    -- upvalues: v1 (ref)
    return v1 == "Aiming"
end

function t1.isCasting() -- line: 579
    -- upvalues: v1 (ref)
    return v1 == "Casting"
end

function t1.setBusyCheck(p10) -- line: 583
    -- upvalues: v5 (ref)
    v5 = p10
end

function t1.init() -- line: 587
    -- upvalues: ContextActionService (copy), GuiService (copy), RunService (copy), UserInputService (copy), Poses (copy), PowerMeter (copy), LocalPlayer (copy), v1 (ref), v2 (ref), v5 (ref), inZone (copy), v24 (ref), enter (copy), abort (copy), cast (copy)
    PowerMeter.init()
    Poses.setAimSource(PowerMeter.pull)

    local function watchCharacter(p11) -- line: 591
        -- upvalues: abort (copy)
        abort()
        p11:WaitForChild("Humanoid").Died:Connect(abort)
    end

    LocalPlayer.CharacterAdded:Connect(watchCharacter)

    if LocalPlayer.Character then
        task.spawn(watchCharacter, LocalPlayer.Character)
    end

    UserInputService.InputBegan:Connect(function(p12, p13) -- line: 601
        -- upvalues: v1 (ref), cast (copy)
        local UserInputType = p12.UserInputType

        if not (p13 or UserInputType ~= Enum.UserInputType.MouseButton1 and UserInputType ~= Enum.UserInputType.Touch) and v1 == "Aiming" then
            task.spawn(cast)
        end
    end)
    ContextActionService:BindActionAtPriority("FishCast", function(_, p15, p16) -- line: 613
        -- upvalues: GuiService (copy), v1 (ref), v24 (ref), cast (copy)
        local spawn, v95

        if p15 ~= Enum.UserInputState.Begin or v1 ~= "Aiming" or GuiService.SelectedObject then
            return Enum.ContextActionResult.Pass
        else
            spawn = task.spawn
            v95 = if p16.KeyCode == Enum.KeyCode.ButtonB then v24 else cast
        end

        spawn(v95)

        return Enum.ContextActionResult.Sink
    end, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.ButtonA, Enum.KeyCode.ButtonR2, Enum.KeyCode.ButtonB)
    RunService.Heartbeat:Connect(function() -- line: 622
        -- upvalues: LocalPlayer (copy), v1 (ref), v2 (ref), v5 (ref), inZone (copy), enter (copy)
        if v1 ~= "Idle" then
            return
        end

        local Character = LocalPlayer.Character
        local v97 = Character

        if Character then
            v97 = Character:FindFirstChildOfClass("Humanoid")
            Character = Character:FindFirstChild("HumanoidRootPart")
        end

        if not (v97 and Character and v97.Health > 0) then
            Character = nil
        end

        if Character and inZone(Character.Position, true) then
            if v2 and not v5() and inZone(Character.Position) then
                task.spawn(enter, Character)
            end
        else
            v2 = true
        end
    end)
end

return t1
