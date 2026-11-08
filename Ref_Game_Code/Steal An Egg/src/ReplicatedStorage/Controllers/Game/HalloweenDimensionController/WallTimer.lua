-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local AreaEggResetWall = require(ReplicatedStorage.Client.AreaEggResetWall)
local Audio = require(ReplicatedStorage.Shared.Audio)
local GUI = require(ReplicatedStorage.Client.GUI)
local HalloweenDimension = require(ReplicatedStorage.Shared.Util.HalloweenDimension)

require(ReplicatedStorage.Packages.Trove)

local LocalPlayer = Players.LocalPlayer
local Inside = HalloweenDimension.PlayerAttributes.Inside
local t1 = {}

local function isInside() -- line: 56
    -- upvalues: LocalPlayer (copy), Inside (copy)
    return LocalPlayer:GetAttribute(Inside) == true
end

local function faceOf(p1) -- line: 60
    local TextLabel = p1.Frame.TextLabel

    return {
        Gui = p1,
        NightTimer = p1.Frame.NightTimer,
        Stroke = p1.Frame.NightTimer.UIStroke,
        SleepIcon = p1.Frame.SleepIcon,
        Count = TextLabel,
        Scale = TextLabel:FindFirstChildOfClass("UIScale")
    }
end

local function newAnchor(p2) -- line: 72
    -- upvalues: Workspace (copy)
    local v1 = p2:Add(Instance.new("Part"))

    v1.Name = "HalloweenNightWallTimer"
    v1.Anchored = true
    v1.CanCollide = false
    v1.CanQuery = false
    v1.CanTouch = false
    v1.CastShadow = false
    v1.Transparency = 1
    v1.Parent = Workspace

    return v1
end

local function faceCenter(p3) -- line: 85
    return p3.Position + p3.CFrame.LookVector * (p3.Size.Z * 0.5)
end

local function mirror(p4, p5) -- line: 89
    p5.NightTimer.Text = p4.NightTimer.Text
    p5.NightTimer.TextTransparency = p4.NightTimer.TextTransparency
    p5.Stroke.Transparency = p4.Stroke.Transparency
    p5.SleepIcon.Image = p4.SleepIcon.Image
    p5.SleepIcon.ImageTransparency = p4.SleepIcon.ImageTransparency
    p5.Count.Text = p4.Count.Text
    p5.Count.Visible = p4.Count.Visible
    p5.Scale.Scale = p4.Scale.Scale
end

local function bindFace(p6, p7) -- line: 100
    -- upvalues: RunService (copy), Workspace (copy), AreaEggResetWall (copy), Audio (copy), GUI (copy), LocalPlayer (copy), Inside (copy), faceOf (copy), mirror (copy)
    local v2 = GUI.ResetStartTimer()

    GUI.ResetStartTimerLabelScale()

    local v3 = faceOf(v2)
    local v4 = AreaEggResetWall.ResolveWallPart()
    local v5 = p6:Add(Instance.new("Part"))

    v5.Name = "HalloweenNightWallTimer"
    v5.Anchored = true
    v5.CanCollide = false
    v5.CanQuery = false
    v5.CanTouch = false
    v5.CastShadow = false
    v5.Transparency = 1
    v5.Parent = Workspace

    local clone = p6:Clone(v2)

    clone.Name = "HalloweenResetStartTimer"
    clone.Enabled = false
    clone.Adornee = v5
    clone.Parent = v2.Parent

    local v6 = faceOf(clone)
    local v7 = p6:Extend()
    local Text

    local function place(p8) -- line: 117
        -- upvalues: v4 (copy), v5 (copy)
        v5.Size = Vector3.new(v4.Size.X, p8.Size.Y, p8.Size.Z + 0.1)
        v5.CFrame = p8.CFrame
    end

    local function tickIfCounted(p9) -- line: 122
        -- upvalues: v3 (copy), Text (ref), Audio (copy)
        if v3.Count.Visible then
            if v3.Count.Text ~= Text then
                Text = v3.Count.Text
                Audio.Play(117751546358455, p9.Position + p9.CFrame.LookVector * (p9.Size.Z * 0.5), {
                    Volume = 2,
                    MaxDistance = 220
                })
            end
        else
            Text = nil
        end
    end

    local function step() -- line: 137
        -- upvalues: p7 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), clone (copy), v6 (copy), tickIfCounted (copy), mirror (copy)
        local v9 = p7()
        local Enabled = v2.Enabled and v9 ~= nil and v9.Size.Y > 0.05

        clone.Enabled = Enabled

        if v9 == nil or not Enabled then
            return
        end

        v5.Size = Vector3.new(v4.Size.X, v9.Size.Y, v9.Size.Z + 0.1)
        v5.CFrame = v9.CFrame
        mirror(v3, v6)
        tickIfCounted(v9)
    end

    local function sync() -- line: 149
        -- upvalues: v3 (copy), clone (copy), v7 (copy), Text (ref), step (copy), RunService (copy), LocalPlayer (copy), Inside (copy)
        v7:Clean()

        if LocalPlayer:GetAttribute(Inside) ~= true then
            clone.Enabled = false

            return
        end

        Text = if v3.Count.Visible then v3.Count.Text else nil
        v7:Connect(RunService.PreRender, step)
        step()
    end

    p6:Connect(LocalPlayer:GetAttributeChangedSignal(Inside), sync)
    p6:Connect(AreaEggResetWall.Changed, function(p10) -- line: 161
        -- upvalues: p7 (copy), Audio (copy), LocalPlayer (copy), Inside (copy)
        local v11 = p7()

        if not p10 and v11 ~= nil and LocalPlayer:GetAttribute(Inside) == true then
            Audio.Play(136029417452204, v11.Position + v11.CFrame.LookVector * (v11.Size.Z * 0.5), {
                Volume = 1.5,
                MaxDistance = 220
            })
        end
    end)
    v7:Clean()

    if LocalPlayer:GetAttribute(Inside) ~= true then
        clone.Enabled = false

        return
    end

    Text = if v3.Count.Visible then v3.Count.Text else nil
    v7:Connect(RunService.PreRender, step)
    step()
end

function t1.Bind(p11, p12) -- line: 178
    -- upvalues: bindFace (copy)
    p11:Add(task.spawn(bindFace, p11, p12))
end

return t1
