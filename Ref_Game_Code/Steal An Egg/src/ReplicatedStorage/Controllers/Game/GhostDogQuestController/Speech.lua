-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Fx = require(script.Parent.Fx)
local MessageTyper = require(ReplicatedStorage.Client.UI.MessageTyper)
local Trove = require(ReplicatedStorage.Packages.Trove)
local LocalPlayer = Players.LocalPlayer
local t1 = {
    [Enum.KeyCode.E] = true,
    [Enum.KeyCode.ButtonX] = true,
    [Enum.KeyCode.Return] = true,
    [Enum.KeyCode.Space] = true
}
local BuddyChatter1 = ReplicatedStorage.Assets.ShootingStar.Sounds.BuddyChatter1
local v1
local t2 = {}

local function template() -- line: 44
    -- upvalues: ReplicatedStorage (copy)
    local Talk_UI = ReplicatedStorage.Assets.UI.Npcs:FindFirstChild("Talk_UI")

    return if Talk_UI ~= nil and Talk_UI:IsA("BillboardGui") then Talk_UI else nil
end

local function topOf(p1) -- line: 49
    local v2 = p1.Position.Y + p1.Size.Y * 0.5

    for _, descendant in p1:GetDescendants() do
        if descendant:IsA("BasePart") then
            v2 = math.max(v2, descendant.Position.Y + descendant.Size.Y * 0.5)
        end
    end

    return v2
end

function t2.Stop() -- line: 59
    -- upvalues: v1 (ref)
    local v4 = v1

    v1 = nil

    if v4 then
        v4:Destroy()
    end
end

function t2.IsTalking() -- line: 67
    -- upvalues: v1 (ref)
    return v1 ~= nil
end

function t2.Say(p2, p3, p4, p5) -- line: 71
    -- upvalues: ReplicatedStorage (copy), RunService (copy), UserInputService (copy), Fx (copy), MessageTyper (copy), Trove (copy), LocalPlayer (copy), t1 (copy), BuddyChatter1 (copy), v1 (ref), t2 (copy), topOf (copy)
    t2.Stop()

    local v5 = p5 or {}
    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local Talk_UI = ReplicatedStorage.Assets.UI.Npcs:FindFirstChild("Talk_UI")

    if Talk_UI == nil or not Talk_UI:IsA("BillboardGui") then
        Talk_UI = nil
    end

    if PlayerGui == nil or Talk_UI == nil or #p4 == 0 then
        return false
    end

    local v6 = Trove.new()

    v1 = v6

    local Position = p2:GetPivot().Position
    local v7 = v6:Add(Instance.new("Attachment"))

    v7.Name = "GhostDogSpeech"
    v7.Parent = p3
    v7.WorldPosition = Vector3.new(Position.X, topOf(p3) + 0.6, Position.Z)

    local v9 = v6:Add(Talk_UI:Clone())

    v9.Name = "GhostDogSpeech"
    v9.Adornee = v7
    v9.MaxDistance = 80
    v9.Enabled = true
    v9.Parent = PlayerGui

    local TextLabel = v9:FindFirstChildOfClass("TextLabel")
    local UIScale = v9:FindFirstChildOfClass("UIScale")

    if TextLabel == nil then
        v6:Destroy()
        v1 = nil

        return false
    end

    TextLabel.Text = ""

    local v10 = v5.Tint or TextLabel.TextColor3
    local v11 = MessageTyper.new(TextLabel, nil, 0.035, v5.Clicks ~= false)

    v6:Add(function() -- line: 107
        -- upvalues: v11 (copy)
        v11:Halt()
    end)

    local TextLabel2 = Instance.new("TextLabel")

    TextLabel2.Name = "Next"
    TextLabel2.BackgroundTransparency = 1
    TextLabel2.AnchorPoint = Vector2.new(1, 1)
    TextLabel2.Position = UDim2.fromScale(0.98, 1.05)
    TextLabel2.Size = UDim2.fromScale(0.08, 0.35)
    TextLabel2.TextScaled = true
    TextLabel2.Text = "▶"
    TextLabel2.TextColor3 = v10
    TextLabel2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy)
    TextLabel2.Visible = false
    TextLabel2.ZIndex = TextLabel.ZIndex + 1
    TextLabel2.Parent = TextLabel

    local Size = Talk_UI.Size
    local n1 = 0
    local n2 = 0
    local n3 = 0
    local v12 = false
    local v13 = false
    local v14 = v5.Voice or { BuddyChatter1 }
    local n4 = 0

    local function show() -- line: 132
        -- upvalues: p3 (copy), p4 (copy), v9 (copy), UIScale (copy), v11 (copy), Size (copy), n1 (ref), n2 (ref), n3 (ref), n4 (ref), v14 (copy), v5 (copy), v10 (copy), Fx (copy)
        local v15 = p4[n1]
        local v16 = if #v15 > 84 then 3 elseif #v15 > 42 then 2 else 1

        v9.Size = UDim2.new(Size.X.Scale, Size.X.Offset, Size.Y.Scale * v16, Size.Y.Offset)
        n3 = os.clock() + (utf8.len(v15) or #v15) * 0.035

        local v17 = n3

        n2 = v17 + math.max(2.5, #v15 * 0.06)
        v11:Type(v15, v10)

        if UIScale then
            Fx.Punch(UIScale, 1.15, 0.25)
        end

        local v19 = math.random(1, #v14)

        if #v14 > 1 and v19 == n4 then
            v19 = v19 % #v14 + 1
        end

        n4 = v19
        Fx.PlayAt(v14[v19], p3, {
            Looped = false,
            PlaybackSpeed = 0.95 + math.random() * 0.15
        })

        if v5.OnLine then
            task.spawn(v5.OnLine, n1)
        end
    end

    local function advance() -- line: 161
        -- upvalues: p4 (copy), v11 (copy), n1 (ref), n2 (ref), n3 (ref), v12 (ref), v13 (ref), show (copy), v10 (copy)
        if os.clock() < n3 then
            n3 = os.clock()
            v11:ShowAll(p4[n1], v10)
            n2 = os.clock() + 1.2
        else
            local v21 = n1

            if v21 >= #p4 then
                v12 = true
                v13 = true
            else
                n1 += 1
                show()
            end
        end
    end

    local t3 = {}

    v6:Connect(UserInputService.InputBegan, function(p6, p7) -- line: 178
        -- upvalues: advance (copy), t3 (copy), t1 (copy)
        if not p7 then
            if t1[p6.KeyCode] then
                advance()
            elseif p6.UserInputType == Enum.UserInputType.Touch then
                t3[p6] = {
                    At = os.clock(),
                    Position = p6.Position
                }
            end
        end
    end)
    v6:Connect(UserInputService.InputEnded, function(p8) -- line: 188
        -- upvalues: advance (copy), t3 (copy)
        local v22 = t3[p8]

        if v22 ~= nil then
            t3[p8] = nil

            if os.clock() - v22.At <= 0.25 and (p8.Position - v22.Position).Magnitude <= 12 then
                advance()
            end
        end
    end)
    v6:Connect(RunService.Heartbeat, function() -- line: 201
        -- upvalues: v7 (copy), TextLabel2 (copy), n2 (ref), n3 (ref), v12 (ref), advance (copy), v5 (copy), LocalPlayer (copy)
        if v12 then
            return
        end

        local WalkAway = v5.WalkAway

        if WalkAway then
            local Character = LocalPlayer.Character
            local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

            if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") and WalkAway < (HumanoidRootPart.Position - v7.WorldPosition).Magnitude then
                v12 = true

                return
            end
        end

        TextLabel2.Visible = os.clock() >= n3
        TextLabel2.Position = UDim2.fromScale(0.98, math.abs((math.sin(os.clock() * 6))) * 0.08 + 1.05)

        if os.clock() >= n2 then
            advance()
        end
    end)
    n1 = 1
    show()

    while not v12 and v1 == v6 do
        task.wait()
    end

    if v1 == v6 then
        v1 = nil
        v6:Destroy()
    end

    return v13
end

return table.freeze(t2)
