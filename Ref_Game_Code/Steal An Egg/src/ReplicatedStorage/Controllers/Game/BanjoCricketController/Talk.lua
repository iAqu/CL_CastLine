-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local BanjoCricket = require(ReplicatedStorage.Data.BanjoCricket)
local BanjoCricketFlags = require(ReplicatedStorage.Shared.Flags.BanjoCricketFlags)
local MessageTyper = require(ReplicatedStorage.Client.UI.MessageTyper)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local Trove = require(ReplicatedStorage.Packages.Trove)
local v1 = Color3.fromRGB(255, 85, 85)
local LocalPlayer = Players.LocalPlayer
local Talk_UI = ReplicatedStorage.Assets.UI.Npcs.Talk_UI
local t1 = {}
local t2
local v2 = false
local v3 = false
local v4 = false
local t3 = {}

local function isAvailable() -- line: 56
    -- upvalues: BanjoCricketFlags (copy), v2 (ref)
    return BanjoCricketFlags.Enabled:Get() and v2
end

local function close() -- line: 60
    -- upvalues: t2 (ref)
    local t4 = t2

    if t4 ~= nil then
        t2 = nil
        t4.Trove:Destroy()
    end
end

local function show(p1) -- line: 69
    -- upvalues: Talk_UI (copy)
    local v5 = p1.Lines[p1.Index]
    local Size = Talk_UI.Size
    local v6 = #v5 > 45 and 2 or 1

    p1.Bubble.Size = UDim2.new(Size.X.Scale, Size.X.Offset, Size.Y.Scale * v6, Size.Y.Offset)
    p1.NextAt = os.clock() + (utf8.len(v5) or #v5) * 0.06 + math.max(2.6, #v5 * 0.05)
    p1.Typer:Type(v5, p1.Label.TextColor3)
end

local function claim() -- line: 85
    -- upvalues: Remotes (copy), Toast (copy), v1 (copy), v4 (ref)
    if v4 then
        return
    end

    v4 = true

    local function v9() -- line: 90
        -- upvalues: Remotes (copy)
        return Remotes.BanjoCricket.AskClaim:InvokeServer()
    end

    local v10, v11, v12 = pcall(v9)

    v4 = false

    if v10 and v11 == true then
        return
    end

    Toast.Show({
        Seconds = 3,
        Text = if not v10 or typeof(v12) ~= "string" then "Something went wrong, try again." else v12,
        Color = v1
    })
end

local function advance() -- line: 106
    -- upvalues: Workspace (copy), LocalPlayer (copy), t2 (ref), show (copy)
    local t6 = t2

    if t6 == nil then
        return
    end

    local Character = LocalPlayer.Character
    local v13 = Character

    if Character then
        v13 = Character:FindFirstChild("HumanoidRootPart")
        Character = Character:FindFirstChildOfClass("Humanoid")
    end

    if v13 ~= nil and v13:IsA("BasePart") and Character ~= nil and not (Character.Health <= 0) and t6.Npc:IsDescendantOf(Workspace) and not ((v13.Position - t6.Anchor.WorldPosition).Magnitude > t6.Prompt.MaxActivationDistance + 8) then
        if not (os.clock() < t6.NextAt) then
            if t6.Index < #t6.Lines then
                t6.Index += 1
                show(t6)
            else
                local Finished = t6.Finished
                local t7 = t2

                if t7 ~= nil then
                    t2 = nil
                    t7.Trove:Destroy()
                end

                task.spawn(Finished)
            end
        end
    else
        local t8 = t2

        if t8 ~= nil then
            t2 = nil
            t8.Trove:Destroy()
        end
    end
end

local function converse(p2, p3) -- line: 139
    -- upvalues: RunService (copy), BanjoCricket (copy), BanjoCricketFlags (copy), MessageTyper (copy), Trove (copy), LocalPlayer (copy), Talk_UI (copy), t2 (ref), v2 (ref), v3 (ref), show (copy), claim (copy), advance (copy)
    local t9 = t2

    if t9 ~= nil then
        t2 = nil
        t9.Trove:Destroy()
    end

    local PrimaryPart = p2.PrimaryPart
    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")

    if PrimaryPart ~= nil and PlayerGui ~= nil then
        local v14 = Trove.new()
        local BoundingBox, BoundingBox2 = p2:GetBoundingBox()
        local v15 = v14:Add(Instance.new("Attachment"))

        v15.Name = "BanjoCricketSpeech"
        v15.Position = PrimaryPart.CFrame:PointToObjectSpace(BoundingBox.Position + Vector3.new(0, BoundingBox2.Y / 2, 0))
        v15.Parent = PrimaryPart

        local v17 = v14:Add(Talk_UI:Clone())

        v17.Name = "BanjoCricketSpeech"
        v17.Adornee = v15
        v17.MaxDistance = 45
        v17.Enabled = true
        v17.Parent = PlayerGui

        local TextLabel = v17:FindFirstChildOfClass("TextLabel")

        assert(TextLabel, "Talk_UI needs a TextLabel")
        TextLabel.Text = ""

        local v18 = MessageTyper.new(TextLabel, nil, 0.06, false)

        p3.Enabled = false
        v14:Add(function() -- line: 165
            -- upvalues: p3 (copy), v18 (copy), BanjoCricketFlags (copy), v2 (ref)
            v18:Halt()

            if p3.Parent ~= nil then
                p3.Enabled = BanjoCricketFlags.Enabled:Get() and v2
            end
        end)

        local t10 = {
            Index = 1,
            NextAt = 0,
            Npc = p2,
            Prompt = p3,
            Lines = if v3 then BanjoCricket.Lines.Encore else BanjoCricket.Lines.Reward,
            Anchor = v15,
            Bubble = v17,
            Label = TextLabel,
            Typer = v18,
            Finished = if v3 then function() -- line: 183
            end else claim,
            Trove = v14
        }

        t2 = t10
        v14:Connect(RunService.Heartbeat, advance)
        show(t10)
    end
end

local function promptParent(p4) -- line: 191
    -- upvalues: BanjoCricket (copy)
    local v20 = p4:FindFirstChild(BanjoCricket.InteractionPoint, true)

    if not (v20 and v20:IsA("Attachment")) then
        return p4.PrimaryPart
    end

    return v20
end

local function refreshPrompts() -- line: 199
    -- upvalues: BanjoCricketFlags (copy), t1 (copy), t2 (ref), v2 (ref)
    local v21 = BanjoCricketFlags.Enabled:Get() and v2

    for _, v22 in t1 do
        local t11 = t2

        if t11 == nil or t11.Prompt ~= v22 then
            v22.Enabled = v21
        end
    end
end

local function bind(p5) -- line: 209
    -- upvalues: Workspace (copy), BanjoCricket (copy), BanjoCricketFlags (copy), t1 (copy), t2 (ref), v2 (ref), converse (copy)
    local v23, v24

    if t1[p5] then
        v24 = true
    elseif p5:IsA("Model") and p5:IsDescendantOf(Workspace) then
        v23 = p5:FindFirstChild(BanjoCricket.InteractionPoint, true)

        if not v23 or not v23:IsA("Attachment") then
            v23 = p5.PrimaryPart
        end

        v24 = false
    else
        v24 = true
    end

    if not v24 and v23 ~= nil then
        local ProximityPrompt = Instance.new("ProximityPrompt")

        ProximityPrompt.Name = "BanjoCricketTalk"
        ProximityPrompt.ActionText = "Talk"
        ProximityPrompt.ObjectText = BanjoCricket.NpcDisplayName
        ProximityPrompt.HoldDuration = 0
        ProximityPrompt.MaxActivationDistance = BanjoCricket.TalkDistance
        ProximityPrompt.RequiresLineOfSight = false
        ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom
        ProximityPrompt.Enabled = BanjoCricketFlags.Enabled:Get() and v2
        ProximityPrompt.Parent = v23
        t1[p5] = ProximityPrompt
        ProximityPrompt.Triggered:Connect(function() -- line: 233
            -- upvalues: p5 (copy), ProximityPrompt (copy), t2 (ref), converse (copy)
            if t2 == nil then
                converse(p5, ProximityPrompt)
            end
        end)
    end
end

local function unbind(p6) -- line: 240
    -- upvalues: t1 (copy), t2 (ref)
    local v26 = t1[p6]

    if v26 == nil then
        return
    end

    t1[p6] = nil

    local t12 = t2

    if t12 and t12.Npc == p6 then
        local t13 = t2

        if t13 ~= nil then
            t2 = nil
            t13.Trove:Destroy()
        end
    end

    v26:Destroy()
end

function t3.Start() -- line: 253
    -- upvalues: CollectionService (copy), BanjoCricket (copy), BanjoCricketFlags (copy), Tabs (copy), close (copy), refreshPrompts (copy), bind (copy), unbind (copy)
    local Npc = BanjoCricket.Tags.Npc

    CollectionService:GetInstanceAddedSignal(Npc):Connect(bind)
    CollectionService:GetInstanceRemovedSignal(Npc):Connect(unbind)

    for _, v27 in CollectionService:GetTagged(Npc) do
        bind(v27)
    end

    BanjoCricketFlags.Enabled.Changed:Connect(refreshPrompts)
    Tabs.Activated:Connect(close)
end

function t3.Sync(p7, p8) -- line: 264
    -- upvalues: BanjoCricketFlags (copy), t1 (copy), t2 (ref), v2 (ref), v3 (ref)
    v2 = p7
    v3 = p8

    local v28 = BanjoCricketFlags.Enabled:Get() and v2

    for _, v29 in t1 do
        local t14 = t2

        if t14 == nil or t14.Prompt ~= v29 then
            v29.Enabled = v28
        end
    end
end

return table.freeze(t3)
