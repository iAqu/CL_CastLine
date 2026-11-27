-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local Economy = require(ReplicatedStorage.Shared.Economy)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Hud = require(script.Parent.Parent.UI.Hud)
local Backpack = require(script.Parent.Parent.UI.Backpack)
local Settings = require(script.Parent.Parent.UI.Settings)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local Style = require(script.Parent.Parent.Shop.Style)
local Controller = require(script.Parent.Parent.Fishing.Controller)
local BossFx = require(script.Parent.BossFx)
local BossHud = require(script.Parent.BossHud)
local BossRod = require(script.Parent.BossRod)
local BossIntro = require(script.Parent.BossIntro)
local BossAttackFx = require(script.Parent.BossAttackFx)
local BossMonsterFx = require(script.Parent.BossMonsterFx)
local BossSkin = require(script.Parent.BossSkin)
local BossJuice = require(script.Parent.BossJuice)
local BossVictory = require(script.Parent.BossVictory)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local Boss = Economy.Boss
local t2 = {
    Color3.fromRGB(255, 70, 70),
    Color3.fromRGB(255, 230, 90)
}
local v1 = Boss.IntroTime - 2
local v2 = false
local n1 = 0
local t3 = {}
local ScreenGui

local function now() -- line: 49
    return workspace:GetServerTimeNow()
end

local function boss() -- line: 53
    -- upvalues: BossSkin (copy)
    return if workspace:FindFirstChild("BossArena") then BossSkin.monster() else nil
end

local function root() -- line: 59
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character

    return Character and Character:FindFirstChild("HumanoidRootPart")
end

local function canAct() -- line: 64
    -- upvalues: BossIntro (copy), LocalPlayer (copy), v2 (ref)
    return v2 and LocalPlayer:GetAttribute("BossIn") == true and workspace:GetAttribute("BossState") == "Fight" and not BossIntro.isPlaying() and workspace:GetServerTimeNow() >= (workspace:GetAttribute("BossFightAt") or 0) - 0.5
end

function t1.isActive() -- line: 72
    -- upvalues: v2 (ref)
    return v2
end

function t1.holdsDock() -- line: 78
    -- upvalues: LocalPlayer (copy)
    if LocalPlayer:GetAttribute("BossJoined") ~= true or LocalPlayer:GetAttribute("BossIn") ~= nil then
        return false
    end

    local BossState = workspace:GetAttribute("BossState")

    if BossState == "Fight" then
        return true
    end

    if BossState == "Join" then
        return workspace:GetServerTimeNow() >= (workspace:GetAttribute("BossStartAt") or 1e999) - 6
    end

    return false
end

local function dodge() -- line: 88
    -- upvalues: Remotes (copy), UIUtil (copy), LocalPlayer (copy), Boss (copy), n1 (ref), canAct (copy)
    local HumanoidRootPart

    if not canAct() or os.clock() - n1 < Boss.DodgeCooldown then
        return
    else
        local Character = LocalPlayer.Character

        HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    end

    local v4 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

    if not (HumanoidRootPart and v4) then
        return
    end

    n1 = os.clock()

    local MoveDirection = v4.MoveDirection

    if MoveDirection.Magnitude < 0.1 then
        local LookVector = workspace.CurrentCamera.CFrame.LookVector

        MoveDirection = Vector3.new(LookVector.X, 0, LookVector.Z)
    end

    HumanoidRootPart.AssemblyLinearVelocity = (if MoveDirection.Magnitude > 0.01 then MoveDirection.Unit else Vector3.new(0, 0, -1)) * 85 + Vector3.new(0, 18, 0)
    Remotes.Boss:FireServer("Dodge")
    UIUtil.sound("Click", 0.4, 0.7)
end

local function onHit() -- line: 111
    -- upvalues: UIUtil (copy), Settings (copy), BossHud (copy), BossJuice (copy), LocalPlayer (copy)
    BossHud.hitFlash()
    BossJuice.hitStop(0.08)
    BossJuice.impactFrame(Color3.fromRGB(255, 40, 40), 0.5, 0.3)
    BossJuice.fovPunch(-5, 0.4)
    UIUtil.sound("Splash", 0.8, 0.8)
    UIUtil.sound("SubBoom", 0.6, 0.6)

    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    if HumanoidRootPart then
        local v7 = Vector3.new(math.random() - 0.5, 0, math.random() - 0.5)

        HumanoidRootPart.AssemblyLinearVelocity = (if v7.Magnitude > 0.01 then v7.Unit else Vector3.new(1, 0, 0)) * 40 + Vector3.new(0, 45, 0)
    end

    local v8 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

    if v8 and Settings.get("Shake") then
        task.spawn(function() -- line: 126
            -- upvalues: v8 (copy)
            for i = 1, 8 do
                v8.CameraOffset = Vector3.new(math.random() - 0.5, math.random() - 0.5, 0) * (1.2 - i * 0.13)
                task.wait(0.03)
            end

            v8.CameraOffset = Vector3.new(0, 0, 0)
        end)
    end
end

local function glow() -- line: 138
    -- upvalues: BossSkin (copy), t2 (copy), t3 (copy)
    local v11 = if workspace:FindFirstChild("BossArena") then BossSkin.monster() else nil

    if not v11 then
        table.clear(t3)

        return
    end

    local v12 = (workspace:GetAttribute("BossWeakUntil") or 0) > workspace:GetServerTimeNow()

    for _, descendant in v11:GetDescendants() do
        if descendant:IsA("BasePart") and string.find(descendant.Name, "Glow") then
            if not t3[descendant] then
                t3[descendant] = {
                    Color = descendant.Color,
                    Material = descendant.Material
                }
            end

            if v12 then
                descendant.Material = Enum.Material.Neon
                descendant.Color = t2[1]:Lerp(t2[2], (math.sin(os.clock() * 16) + 1) / 2)
            else
                descendant.Material = t3[descendant].Material
                descendant.Color = t3[descendant].Color
            end
        end
    end
end

local function setFight(p1) -- line: 163
    -- upvalues: UserInputService (copy), Hud (copy), Backpack (copy), BossFx (copy), BossRod (copy), BossIntro (copy), BossAttackFx (copy), BossMonsterFx (copy), v1 (copy), v2 (ref), t3 (copy), ScreenGui (ref)
    if p1 == v2 then
        return
    end

    v2 = p1
    Hud.setVisible(not p1)
    Backpack.setVisible(not p1)

    local ScreenGui2 = ScreenGui

    ScreenGui2.Enabled = p1 and UserInputService.TouchEnabled

    if p1 then
        local BossIntroAt = workspace:GetAttribute("BossIntroAt")

        if BossIntroAt and workspace:GetServerTimeNow() - BossIntroAt < v1 then
            BossIntro.play()
        end
    else
        BossFx.clear()
        BossAttackFx.clear()
        BossMonsterFx.clear()
        BossRod.setActive(false)
        table.clear(t3)
    end
end

local function join() -- line: 186
    -- upvalues: Remotes (copy), UIUtil (copy)
    Remotes.Boss:FireServer("Join")
    UIUtil.sound("Click", 0.6)
end

function t1.init() -- line: 191
    -- upvalues: RunService (copy), UserInputService (copy), ContextActionService (copy), Remotes (copy), UIUtil (copy), Kit (copy), Style (copy), Controller (copy), BossFx (copy), BossHud (copy), BossRod (copy), BossIntro (copy), BossAttackFx (copy), BossMonsterFx (copy), BossSkin (copy), BossJuice (copy), BossVictory (copy), LocalPlayer (copy), t1 (copy), v2 (ref), ScreenGui (ref), canAct (copy), dodge (copy), onHit (copy), glow (copy), setFight (copy), join (copy)
    BossSkin.init()
    BossFx.init()
    BossJuice.init()
    BossVictory.init()
    BossAttackFx.init()
    BossMonsterFx.init()
    BossHud.init(join)
    BossRod.init()
    BossIntro.init()
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BossDodge"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Enabled = false
    ScreenGui.DisplayOrder = 5
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local v16 = Kit.frame(ScreenGui, {
        Name = "Holder",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -24, 1, -170),
        Size = UDim2.fromOffset(170, 90)
    })
    local UIScale = Instance.new("UIScale")

    UIScale.Parent = v16
    UIUtil.onScale(function(p2) -- line: 212
        -- upvalues: UIScale (copy)
        UIScale.Scale = p2 * 1.4
    end)
    Kit.button(v16, "DODGE", Style.OCEAN, {
        Size = UDim2.fromScale(1, 1)
    }, dodge)
    Remotes.Boss.OnClientEvent:Connect(function(p3, p4) -- line: 217
        -- upvalues: UIUtil (copy), BossFx (copy), BossHud (copy), BossRod (copy), BossAttackFx (copy), BossMonsterFx (copy), BossSkin (copy), BossJuice (copy), LocalPlayer (copy), onHit (copy)
        if p3 == "Attack" then
            BossAttackFx.attack(p4)
        elseif p3 == "Warn" then
            BossFx.warn(p4)
            BossAttackFx.warn(p4)
        elseif p3 == "Hit" then
            onHit()
        elseif p3 == "Out" then
            BossHud.showOut()
        elseif p3 == "BigHit" then
            local bigHit, v17

            if type(p4) == "table" and p4.By ~= LocalPlayer.UserId then
                bigHit = BossMonsterFx.bigHit

                if workspace:FindFirstChild("BossArena") then
                    v17 = BossSkin.monster()
                end

                bigHit(v17, false)
            end
        elseif p3 == "Enraged" then
            BossHud.enraged(type(p4) == "table" and p4.Phase or 2)
            UIUtil.sound("LevelUp", 0.5, 0.5)
            UIUtil.sound("BossRoar", 0.8, 1, 8)
            BossJuice.fovPunch(-4, 0.5)
        elseif p3 == "End" then
            BossRod.setActive(false)
            BossHud.showEnd(p4)
        elseif p3 == "Hooked" or p3 == "Missed" or p3 == "Unhooked" then
            BossRod.onServer(p3, p4)
        end
    end)
    UserInputService.InputBegan:Connect(function(p5, p6) -- line: 246
        -- upvalues: UserInputService (copy), BossRod (copy), canAct (copy), dodge (copy)
        if not p6 and canAct() then
            if p5.UserInputType == Enum.UserInputType.MouseButton1 then
                BossRod.press(UserInputService:GetMouseLocation())
            elseif p5.KeyCode == Enum.KeyCode.Q or p5.KeyCode == Enum.KeyCode.LeftShift then
                dodge()
            end
        end
    end)
    UserInputService.TouchTapInWorld:Connect(function(p7, p8) -- line: 256
        -- upvalues: BossRod (copy), canAct (copy)
        if not p8 and canAct() then
            local GuiInset = game:GetService("GuiService"):GetGuiInset()

            BossRod.press(Vector2.new(p7.X, p7.Y) + GuiInset)
        end
    end)
    ContextActionService:BindActionAtPriority("BossPad", function(_, p10, p11) -- line: 263
        -- upvalues: BossRod (copy), canAct (copy), dodge (copy)
        if p10 ~= Enum.UserInputState.Begin or not canAct() then
            return Enum.ContextActionResult.Pass
        end

        if p11.KeyCode == Enum.KeyCode.ButtonX then
            dodge()
        else
            BossRod.press(workspace.CurrentCamera.ViewportSize / 2)
        end

        return Enum.ContextActionResult.Sink
    end, false, Enum.ContextActionPriority.High.Value + 2, Enum.KeyCode.ButtonR2, Enum.KeyCode.ButtonX)
    RunService.Heartbeat:Connect(function(p12) -- line: 275
        -- upvalues: Controller (copy), BossFx (copy), BossHud (copy), BossRod (copy), BossIntro (copy), BossMonsterFx (copy), BossSkin (copy), LocalPlayer (copy), t1 (copy), v2 (ref), canAct (copy), glow (copy), setFight (copy)
        local v18 = workspace:GetAttribute("BossState") or ""

        setFight(LocalPlayer:GetAttribute("BossIn") ~= nil and v18 ~= "")
        BossRod.setActive((canAct()))
        BossHud.setHidden(BossIntro.isPlaying())
        BossFx.update(if v2 and workspace:FindFirstChild("BossArena") then BossSkin.monster() else nil, p12)
        BossMonsterFx.update(if v2 and workspace:FindFirstChild("BossArena") then BossSkin.monster() else nil, p12)

        if t1.holdsDock() and Controller.isAiming() then
            Controller.leaveDock()
        end

        if v2 then
            glow()
        end
    end)
end

return t1
