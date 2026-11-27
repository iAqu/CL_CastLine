-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Economy = require(ReplicatedStorage.Shared.Economy)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local BossReel = require(script.Parent.Parent.Boss.BossReel)
local BossJuice = require(script.Parent.Parent.Boss.BossJuice)
local SubFleet = require(script.Parent.SubFleet)
local t1 = {}
local LocalPlayer = Players.LocalPlayer
local SubBoss = Economy.SubBoss
local v1 = Color3.fromRGB(120, 255, 90)
local v2 = Color3.new(1, 1, 1)
local v3 = Color3.fromRGB(255, 80, 80)
local v4 = "idle"
local v5 = false
local n1 = -100
local ScreenGui, ScreenGui2, v6, t2, v7

local function touch() -- line: 40
    -- upvalues: UserInputService (copy)
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

local function nose() -- line: 44
    -- upvalues: SubFleet (copy), LocalPlayer (copy)
    return SubFleet.nose(LocalPlayer)
end

local function anchorPart(p1) -- line: 48
    -- upvalues: SubFleet (copy)
    local Part = Instance.new("Part")

    Part.Name = p1
    Part.Size = Vector3.new(0.4, 0.4, 0.4)
    Part.Transparency = 1
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Parent = SubFleet.folder() or workspace
    Instance.new("Attachment").Parent = Part

    return Part
end

local function dropRope() -- line: 60
    -- upvalues: t2 (ref)
    if t2 then
        for _, v8 in {
                t2.a,
                t2.b,
                t2.spear
            } do
            if v8 then
                v8:Destroy()
            end
        end
    end

    t2 = nil
end

local function aim(p2) -- line: 73
    -- upvalues: SubFleet (copy), LocalPlayer (copy), SubBoss (copy)
    local v9 = SubFleet.nose(LocalPlayer)
    local v10 = SubFleet.middle()

    if not (v9 and v10) then
        return nil, false, false
    end

    local v11 = workspace.CurrentCamera:ViewportPointToRay(p2.X, p2.Y)
    local v13 = math.max(0, (v10 - v11.Origin):Dot(v11.Direction))
    local v14 = v11.Origin + v11.Direction * v13
    local v15 = (v14 - v10).Magnitude <= SubBoss.LatchRadius
    local v16 = (v14 - v9).Magnitude <= SubBoss.HarpoonRange

    if not v16 then
        v14 = v9 + (v14 - v9).Unit * SubBoss.HarpoonRange
    end

    return v14, v15 and v16, v16
end

local function floatText(p3, p4) -- line: 90
    -- upvalues: v7 (ref)
    if v7 then
        v7({ { p3, p4, 56 } }, 0.9)
    end
end

local function fire(p5) -- line: 97
    -- upvalues: Remotes (copy), UIUtil (copy), BossJuice (copy), SubFleet (copy), LocalPlayer (copy), SubBoss (copy), v4 (ref), n1 (ref), t2 (ref), dropRope (copy), aim (copy)
    local v17 = SubFleet.nose(LocalPlayer)
    local v18 = aim(p5)
    local Part, v19

    if not v17 or not v18 or os.clock() - n1 < SubBoss.HarpoonGap then
        return
    else
        n1 = os.clock()
        v4 = "flying"
        Remotes.SubBoss:FireServer("Harpoon", v18)
        UIUtil.sound("CastLine", 0.8, 1.3)
        UIUtil.sound("Whoosh", 0.5, 1.4)
        BossJuice.fovPunch(1.5, 0.15)
        dropRope()
        Part = Instance.new("Part")
        Part.Name = "RopeA"
        Part.Size = Vector3.new(0.4, 0.4, 0.4)
        Part.Transparency = 1
        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false
        v19 = SubFleet.folder() or workspace
    end

    Part.Parent = v19
    Instance.new("Attachment").Parent = Part

    local Part2 = Instance.new("Part")

    Part2.Name = "RopeB"
    Part2.Size = Vector3.new(0.4, 0.4, 0.4)
    Part2.Transparency = 1
    Part2.Anchored = true
    Part2.CanCollide = false
    Part2.CanQuery = false
    Part2.CanTouch = false
    Part2.Parent = SubFleet.folder() or workspace
    Instance.new("Attachment").Parent = Part2

    local Part3 = Instance.new("Part")

    Part3.Name = "Harpoon"
    Part3.Size = Vector3.new(0.6, 0.6, 7)
    Part3.Color = Color3.fromRGB(200, 205, 215)
    Part3.Material = Enum.Material.Metal
    Part3.Anchored = true
    Part3.CanCollide = false
    Part3.CanQuery = false
    Part3.CanTouch = false
    Part3.Parent = SubFleet.folder() or workspace

    local Beam = Instance.new("Beam")

    Beam.Attachment0 = Part:FindFirstChildOfClass("Attachment")
    Beam.Attachment1 = Part2:FindFirstChildOfClass("Attachment")
    Beam.Width0 = 0.35
    Beam.Width1 = 0.35
    Beam.Color = ColorSequence.new(Color3.fromRGB(230, 220, 190))
    Beam.FaceCamera = true
    Beam.LightInfluence = 0.3
    Beam.Segments = 1
    Beam.Parent = Part
    t2 = {
        a = Part,
        b = Part2,
        spear = Part3,
        from = v17,
        to = v18,
        firedAt = os.clock(),
        flight = (v18 - v17).Magnitude / 420
    }
end

function t1.onServer(p6, _) -- line: 131
    -- upvalues: Debris (copy), UIUtil (copy), BossReel (copy), SubFleet (copy), v2 (copy), v3 (copy), v4 (ref), t2 (ref), dropRope (copy), floatText (copy)
    if p6 == "Hooked" then
        v4 = "hooked"

        if t2 then
            local v21 = SubFleet.monsterPivot()

            if v21 then
                t2.stuck = v21:ToObjectSpace(CFrame.new(t2.to))
            end
        end

        BossReel.start()
        SubFleet.flash(v2, 0.8)
        UIUtil.sound("MetalClang", 0.8, 1.1)
    elseif p6 == "Missed" then
        if v4 ~= "hooked" then
            v4 = "idle"
        end

        floatText("MISSED!", v3)

        if t2 and t2.spear then
            local spear = t2.spear

            t2.spear = nil
            UIUtil.tween(spear, 0.8, {
                Transparency = 1,
                CFrame = spear.CFrame - Vector3.new(0, 8, 0)
            })
            Debris:AddItem(spear, 0.9)
        end

        task.delay(0.3, function() -- line: 154
            -- upvalues: v4 (ref), dropRope (copy)
            if v4 ~= "hooked" then
                dropRope()
            end
        end)
    elseif p6 == "Unhooked" then
        if v4 == "hooked" then
            BossReel.hide()
        end

        v4 = "idle"
        dropRope()
    end
end

function t1.press(p8) -- line: 169
    -- upvalues: BossReel (copy), v4 (ref), v5 (ref), fire (copy)
    if v5 then
        if v4 == "hooked" then
            BossReel.tap()
        elseif v4 == "idle" then
            fire(p8)
        end
    end
end

function t1.isHooked() -- line: 180
    -- upvalues: v4 (ref)
    return v4 == "hooked"
end

function t1.setActive(p9) -- line: 184
    -- upvalues: UserInputService (copy), BossReel (copy), v4 (ref), v5 (ref), ScreenGui (ref), dropRope (copy)
    if p9 == v5 then
        return
    end

    v5 = p9
    ScreenGui.Enabled = p9 and not (UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled)

    if p9 then
        return
    end

    if v4 == "hooked" then
        BossReel.hide()
    end

    v4 = "idle"
    dropRope()
end

function t1.update(p10) -- line: 200
    -- upvalues: UserInputService (copy), BossReel (copy), SubFleet (copy), LocalPlayer (copy), SubBoss (copy), v1 (copy), v2 (copy), v3 (copy), v4 (ref), v5 (ref), n1 (ref), ScreenGui (ref), v6 (ref), t2 (ref), dropRope (copy), aim (copy)
    if not v5 then
        return
    end

    local v22 = SubFleet.nose(LocalPlayer)

    if t2 and v22 then
        t2.a.CFrame = CFrame.new(v22)

        local v23

        if v4 == "hooked" and t2.stuck then
            local v24 = SubFleet.monsterPivot()

            v23 = if v24 then (v24 * t2.stuck).Position else t2.to
        else
            local v25 = os.clock() - t2.firedAt
            local t5 = t2
            local v27 = math.clamp(v25 / math.max(t5.flight, 0.05), 0, 1)

            v23 = t2.from:Lerp(t2.to, v27)
        end

        t2.b.CFrame = CFrame.new(v23)

        if t2.spear then
            local v28 = v23 - v22

            t2.spear.CFrame = CFrame.lookAt(v23, v23 + (if v28.Magnitude > 0.1 then v28.Unit else Vector3.new(0, 0, 1))) * CFrame.new(0, 0, 3)
        end
    end

    if v4 == "hooked" then
        v6.Visible = false

        if BossReel.update(p10) then
            v4 = "idle"
            dropRope()
        end
    elseif ScreenGui.Enabled then
        local v29 = if UserInputService:GetLastInputType() == Enum.UserInputType.Gamepad1 then workspace.CurrentCamera.ViewportSize / 2 else UserInputService:GetMouseLocation()
        local _, v30, v31 = aim(v29)
        local GuiInset = game:GetService("GuiService"):GetGuiInset()

        v6.Position = UDim2.fromOffset(v29.X - GuiInset.X, v29.Y - GuiInset.Y)
        v6.Visible = true

        local UIStroke = v6:FindFirstChildOfClass("UIStroke")
        local v33 = if v30 then v1 elseif v31 then v2 else v3

        if UIStroke then
            UIStroke.Color = v33
        end

        local v34 = if v30 then math.sin(os.clock() * 10) * 4 + 46 else 36

        v6.Size = UDim2.fromOffset(v34, v34)

        local v37 = os.clock() - n1 >= SubBoss.HarpoonGap and v4 == "idle"

        v6.BackgroundTransparency = v37 and 1 or 0.7
    end
end

local function adapter() -- line: 251
    -- upvalues: ReplicatedStorage (copy), Remotes (copy), UIUtil (copy), BossJuice (copy), SubFleet (copy), v2 (copy), v7 (ref)
    return {
        again = "Knocked it off: harpoon it again!",
        pose = "Steer",
        send = function(p11) -- send | line: 253
            -- upvalues: Remotes (copy)
            Remotes.SubBoss:FireServer(p11)
        end,
        monster = SubFleet.monsterModel,
        template = function() -- template | line: 257
            -- upvalues: ReplicatedStorage (copy)
            local Bosses = ReplicatedStorage.Assets:FindFirstChild("Bosses")
            local Hullbreaker = Bosses and Bosses:FindFirstChild("Hullbreaker")

            return if Hullbreaker then Hullbreaker:Clone() else nil
        end,
        announce = function(p12, p13) -- announce | line: 262
            -- upvalues: v7 (ref)
            if v7 then
                v7(p12, p13)
            end
        end,
        phase = function() -- phase | line: 267
            return workspace:GetAttribute("SubBossPhase") or 1
        end,
        reelHit = function(_, p15) -- reelHit | line: 270
            -- upvalues: UIUtil (copy), SubFleet (copy), v2 (copy)
            SubFleet.flash(v2, 0.55)

            if SubFleet.headPosition() and p15 % 6 == 0 then
                UIUtil.sound(p15 % 12 == 0 and "BossRoar" or "BossGrowl", 0.4, 0.8 + math.random() * 0.1)
            end
        end,
        surge = function() -- surge | line: 277
            -- upvalues: UIUtil (copy), SubFleet (copy)
            SubFleet.flash(Color3.fromRGB(255, 120, 60), 0.5)
            UIUtil.sound("BossGrowl", 0.6, 0.7)
        end,
        bigHit = function(_, p17) -- bigHit | line: 281
            -- upvalues: UIUtil (copy), BossJuice (copy), SubFleet (copy), v2 (copy)
            local v39 = SubFleet.headPosition()

            if p17 ~= false then
                BossJuice.hitStop(0.12)
                BossJuice.impactFrame(v2, 0.8, 0.3)
                BossJuice.fovPunch(9, 0.45)
            end

            if v39 then
                BossJuice.explosion(v39 + (workspace.CurrentCamera.CFrame.Position - v39).Unit * 6, 1.4)
            end

            SubFleet.flash(Color3.fromRGB(255, 60, 60), 1)
            UIUtil.sound("BossScreech", 0.4, 0.8, 8)
            task.delay(0.45, UIUtil.sound, "BossHitRoar", 0.5, 0.8)
        end
    }
end

function t1.claimReel(p18) -- line: 301
    -- upvalues: BossReel (copy), ScreenGui2 (ref), adapter (copy)
    if p18 then
        BossReel.use(adapter(), ScreenGui2)
    else
        BossReel.use(nil)
    end
end

function t1.othersBigHit() -- line: 310
    -- upvalues: adapter (copy)
    adapter().bigHit(nil, false)
end

function t1.init(p19) -- line: 314
    -- upvalues: RunService (copy), Kit (copy), t1 (copy), LocalPlayer (copy), v2 (copy), ScreenGui (ref), ScreenGui2 (ref), v6 (ref), v7 (ref)
    v7 = p19
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SubHarpoonAim"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Enabled = false
    ScreenGui.DisplayOrder = 3
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    v6 = Kit.frame(ScreenGui, {
        Name = "Reticle",
        BackgroundTransparency = 1,
        Visible = false,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromOffset(36, 36),
        BackgroundColor3 = v2
    })
    v6.Interactable = false

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0.5, 0)
    UICorner.Parent = v6
    Kit.stroke(v6, 3, v2)

    local v40 = Kit.frame(v6, {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(6, 6),
        BackgroundColor3 = v2
    })
    local UICorner2 = Instance.new("UICorner")

    UICorner2.CornerRadius = UDim.new(0.5, 0)
    UICorner2.Parent = v40
    ScreenGui2 = Instance.new("ScreenGui")
    ScreenGui2.Name = "SubBossReel"
    ScreenGui2.ResetOnSpawn = false
    ScreenGui2.IgnoreGuiInset = true
    ScreenGui2.Enabled = false
    ScreenGui2.DisplayOrder = 5
    ScreenGui2.Parent = LocalPlayer:WaitForChild("PlayerGui")
    RunService.RenderStepped:Connect(t1.update)
end

return t1
