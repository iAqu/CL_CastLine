-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local Config = require(ReplicatedStorage.Shared.Config)
local Economy = require(ReplicatedStorage.Shared.Economy)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local SubArena = require(ReplicatedStorage.Shared.SubArena)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Hud = require(script.Parent.Parent.UI.Hud)
local Backpack = require(script.Parent.Parent.UI.Backpack)
local Controller = require(script.Parent.Parent.Fishing.Controller)
local Poses = require(script.Parent.Parent.Character.Poses)
local BossHud = require(script.Parent.Parent.Boss.BossHud)
local BossJuice = require(script.Parent.Parent.Boss.BossJuice)
local SubFleet = require(script.Parent.SubFleet)
local SubPilot = require(script.Parent.SubPilot)
local SubIntro = require(script.Parent.SubIntro)
local SubHarpoon = require(script.Parent.SubHarpoon)
local SubAttackFx = require(script.Parent.SubAttackFx)
local t1 = {}
local LocalPlayer = Players.LocalPlayer
local SubBoss = Economy.SubBoss
local v1 = SubBoss.IntroTime - 2
local v2
local v3 = false
local v4 = false

local function now() -- line: 43
    return workspace:GetServerTimeNow()
end

local function state() -- line: 47
    return workspace:GetAttribute("SubBossState") or ""
end

local function canAct() -- line: 51
    -- upvalues: SubPilot (copy), LocalPlayer (copy), v3 (ref)
    return v3 and SubPilot.isOn() and LocalPlayer:GetAttribute("SubBossIn") == true and (workspace:GetAttribute("SubBossState") or "") == "Fight" and workspace:GetServerTimeNow() >= (workspace:GetAttribute("SubBossFightAt") or 0) - 0.5
end

function t1.isActive() -- line: 55
    -- upvalues: v3 (ref)
    return v3
end

function t1.holdsDock() -- line: 60
    -- upvalues: LocalPlayer (copy)
    if LocalPlayer:GetAttribute("SubBossJoined") ~= true or LocalPlayer:GetAttribute("SubBossIn") ~= nil then
        return false
    end

    local v6 = workspace:GetAttribute("SubBossState") or ""

    if v6 == "Fight" then
        return true
    end

    if v6 == "Join" then
        return workspace:GetServerTimeNow() >= (workspace:GetAttribute("SubBossStartAt") or 1e999) - 6
    end

    return false
end

local function onHit() -- line: 70
    -- upvalues: UIUtil (copy), BossJuice (copy), SubFleet (copy), SubPilot (copy), LocalPlayer (copy), v2 (ref)
    v2.hitFlash()
    BossJuice.hitStop(0.08)
    BossJuice.impactFrame(Color3.fromRGB(255, 40, 40), 0.5, 0.3)
    BossJuice.fovPunch(-6, 0.4)
    UIUtil.sound("MetalClang", 0.9, 0.6)
    UIUtil.sound("SubBoom", 0.6, 0.6)
    UIUtil.sound("BubbleSwell", 0.5, 1.5)

    local v7 = SubFleet.monsterPivot()

    SubPilot.knock(v7 and v7.Position)

    local v8 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

    if v8 then
        task.spawn(function() -- line: 82
            -- upvalues: v8 (copy)
            for i = 1, 8 do
                v8.CameraOffset = Vector3.new(math.random() - 0.5, math.random() - 0.5, 0) * (1.4 - i * 0.15)
                task.wait(0.03)
            end

            v8.CameraOffset = Vector3.new(0, 0, 0)
        end)
    end
end

local function begin(p1) -- line: 94
    -- upvalues: SubPilot (copy), v3 (ref)
    if v3 then
        SubPilot.start(p1)
    end
end

local function setFight(p2) -- line: 101
    -- upvalues: SubArena (copy), Hud (copy), Backpack (copy), Poses (copy), BossJuice (copy), SubFleet (copy), SubPilot (copy), SubIntro (copy), SubHarpoon (copy), SubAttackFx (copy), LocalPlayer (copy), v1 (copy), v2 (ref), v3 (ref), v4 (ref), begin (copy)
    if p2 == v3 then
        return
    end

    v3 = p2
    Hud.setVisible(not p2)
    Backpack.setVisible(not p2)

    if p2 then
        v4 = false
        SubFleet.start()
        SubAttackFx.start(v2.announce)
        SubHarpoon.claimReel(true)

        local v11 = LocalPlayer:GetAttribute("SubBossSlot") or 1
        local v12 = LocalPlayer:GetAttribute("SubBossCount") or 1
        local SubBossIntroAt = workspace:GetAttribute("SubBossIntroAt")

        if not (SubBossIntroAt and workspace:GetServerTimeNow() - SubBossIntroAt < v1) then
            local v13 = SubFleet.rootFrame(LocalPlayer, SubArena.start(v11, v12)) or CFrame.new()

            if v3 then
                SubPilot.start(v13)
            end
        else
            task.spawn(SubIntro.play, v11, v12, begin)
        end
    else
        SubIntro.stop()
        SubPilot.stop()
        SubHarpoon.setActive(false)
        SubHarpoon.claimReel(false)
        SubAttackFx.clear()
        SubFleet.stop()
        Poses.clear()

        local Character = LocalPlayer.Character
        local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

        if HumanoidRootPart then
            HumanoidRootPart.Anchored = false
        end

        local CurrentCamera = workspace.CurrentCamera

        if CurrentCamera.CameraType == Enum.CameraType.Scriptable and not BossJuice.isKillCam() then
            CurrentCamera.CameraType = Enum.CameraType.Custom
        end
    end
end

local function playDeath() -- line: 142
    -- upvalues: UIUtil (copy), BossJuice (copy), SubFleet (copy), SubAttackFx (copy), v2 (ref), v4 (ref)
    local v14 = SubFleet.monsterModel()

    if v4 or not v14 then
        return
    end

    v4 = true
    SubAttackFx.clear()
    SubAttackFx.start(v2.announce)
    UIUtil.sound("BossRoar", 1, 0.6, 10)
    BossJuice.finalBlow(v14, 3.4, workspace:GetAttribute("SubBossFinalBlow"))
    task.delay(0.9, function() -- line: 152
        -- upvalues: v14 (copy), BossJuice (copy)
        if v14.Parent then
            BossJuice.deathChain(v14)
        end
    end)
end

local function join() -- line: 159
    -- upvalues: Remotes (copy), UIUtil (copy)
    Remotes.SubBoss:FireServer("Join")
    UIUtil.sound("Click", 0.6)
end

function t1.init() -- line: 164
    -- upvalues: RunService (copy), UserInputService (copy), ContextActionService (copy), Config (copy), Remotes (copy), UIUtil (copy), Controller (copy), BossHud (copy), BossJuice (copy), SubFleet (copy), SubPilot (copy), SubIntro (copy), SubHarpoon (copy), SubAttackFx (copy), t1 (copy), LocalPlayer (copy), SubBoss (copy), v2 (ref), v3 (ref), canAct (copy), onHit (copy), setFight (copy), playDeath (copy), join (copy)
    v2 = BossHud.new({
        prefix = "SubBoss",
        title = "Hullbreaker",
        icon = "🦀",
        guiName = "SubBossHud",
        name = function() -- name | line: 167
            return "HULLBREAKER"
        end,
        short = function() -- short | line: 170
            return "The Hullbreaker"
        end,
        seats = SubBoss.MaxFighters,
        hearts = SubBoss.Hearts,
        power = Config.subBossPower,
        offered = function() -- offered | line: 178
            -- upvalues: LocalPlayer (copy)
            return LocalPlayer:GetAttribute("World2Unlocked") == true
        end,
        controls = function(p3) -- controls | line: 181
            if p3 then
                return "Tap it to harpoon · tap fast to reel · ▲▼ up/down · BOOST to dodge"
            end

            return "Click it to harpoon · click fast to reel · Space/C up/down · Shift to boost"
        end
    })
    v2.init(join)
    SubAttackFx.init()
    SubPilot.init()
    SubHarpoon.init(v2.announce)
    SubPilot.bind(SubAttackFx.pull, function() -- line: 192
        -- upvalues: SubFleet (copy)
        local v15 = SubFleet.monsterPivot()

        return v15 and v15.Position
    end)
    Remotes.SubBoss.OnClientEvent:Connect(function(p4, p5) -- line: 197
        -- upvalues: UIUtil (copy), BossJuice (copy), SubPilot (copy), SubHarpoon (copy), SubAttackFx (copy), LocalPlayer (copy), v2 (ref), onHit (copy)
        if p4 == "Warn" then
            SubAttackFx.warn(p5)
        elseif p4 == "Hit" then
            onHit()
        elseif p4 == "Out" then
            v2.showOut()
            SubPilot.stop()
        elseif p4 == "BigHit" then
            if type(p5) == "table" and p5.By ~= LocalPlayer.UserId then
                SubHarpoon.othersBigHit()
            end
        elseif p4 == "Enraged" then
            v2.enraged(type(p5) == "table" and p5.Phase or 2)
            UIUtil.sound("LevelUp", 0.5, 0.5)
            UIUtil.sound("BossRoar", 0.8, 0.8, 8)
            BossJuice.fovPunch(-4, 0.5)
        elseif p4 == "End" then
            SubHarpoon.setActive(false)
            v2.showEnd(p5)
        elseif p4 == "Hooked" or p4 == "Missed" or p4 == "Unhooked" then
            SubHarpoon.onServer(p4, p5)
        end
    end)
    UserInputService.InputBegan:Connect(function(p6, p7) -- line: 222
        -- upvalues: UserInputService (copy), SubPilot (copy), SubHarpoon (copy), v3 (ref), canAct (copy)
        if not p7 and v3 then
            if p6.UserInputType == Enum.UserInputType.MouseButton1 then
                if canAct() then
                    SubHarpoon.press(UserInputService:GetMouseLocation())
                end
            elseif p6.KeyCode == Enum.KeyCode.Q or p6.KeyCode == Enum.KeyCode.LeftShift then
                SubPilot.boost()
            end
        end
    end)
    UserInputService.TouchTapInWorld:Connect(function(p8, p9) -- line: 234
        -- upvalues: SubHarpoon (copy), canAct (copy)
        if not p9 and canAct() then
            local GuiInset = game:GetService("GuiService"):GetGuiInset()

            SubHarpoon.press(Vector2.new(p8.X, p8.Y) + GuiInset)
        end
    end)
    ContextActionService:BindActionAtPriority("SubBossPad", function(_, p11, p12) -- line: 240
        -- upvalues: SubPilot (copy), SubHarpoon (copy), v3 (ref), canAct (copy)
        if p11 ~= Enum.UserInputState.Begin or not v3 then
            return Enum.ContextActionResult.Pass
        end

        if p12.KeyCode == Enum.KeyCode.ButtonX then
            SubPilot.boost()
        elseif canAct() then
            SubHarpoon.press(workspace.CurrentCamera.ViewportSize / 2)
        end

        return Enum.ContextActionResult.Sink
    end, false, Enum.ContextActionPriority.High.Value + 3, Enum.KeyCode.ButtonR2, Enum.KeyCode.ButtonX)
    RunService.RenderStepped:Connect(function(p13) -- line: 252
        -- upvalues: Controller (copy), SubFleet (copy), SubPilot (copy), SubIntro (copy), SubHarpoon (copy), t1 (copy), LocalPlayer (copy), v2 (ref), v3 (ref), canAct (copy), setFight (copy), playDeath (copy)
        local v16 = workspace:GetAttribute("SubBossState") or ""
        local v17 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local v18 = v17 ~= nil and v17.Health > 0

        if LocalPlayer:GetAttribute("SubBossIn") == nil or v16 == "" then
            v18 = false
        end

        setFight(v18)
        v2.setHidden(SubIntro.isPlaying())

        if v3 then
            SubFleet.update(p13)
            SubPilot.update(p13)
            SubHarpoon.setActive((canAct()))

            if v16 == "Won" then
                playDeath()
            end
        end

        if t1.holdsDock() and Controller.isAiming() then
            Controller.leaveDock()
        end
    end)
end

return t1
