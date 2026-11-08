-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local NpcDialogue = require(ReplicatedStorage.Client.UI.NpcDialogue)
local EggHolders = require(script.EggHolders)
local Shop = require(script.Shop)
local Save = require(ReplicatedStorage.Shared.Save)
local Trove = require(ReplicatedStorage.Packages.Trove)
local t1 = {
    "BillboardGui",
    "SurfaceGui",
    "ParticleEmitter",
    "Beam",
    "Trail",
    "Light",
    "Highlight"
}
local t2 = {
    "Oh! Hello there, little egg-snatcher!",
    "I'm the Star Handler. I look after the stars that fall from the night sky.",
    "Feed one of my stars to a pet and it grows into a powerful mount!",
    "What can I do for you?"
}
local t3 = {
    "Welcome back, starlight! What can I do for you?"
}
local t4 = {
    "Ooh, good eye! Every one of these was caught by hand~"
}
local t5 = {
    "Every night there's a rare chance of a Star Drop!",
    "When it happens, a little star falls for every player in the server.",
    "Find yours, hold on tight to catch it, and it's yours for free!",
    "Keep your eyes on the sky after dark~"
}
local t6 = {
    "Stars are little pieces of the night sky!",
    "Hold one near a pet in your base and feed it to them.",
    "Your pet grows into a mount, so you can hop on and ride it!"
}
local t7 = {
    "Anything else, starlight?"
}
local t8 = {
    "Come back anytime! The stars will be waiting~"
}
local t9 = {
    {
        Text = "View Stars",
        Echo = "Can I see your stars?",
        Key = "Stars"
    },
    {
        Text = "What is a Star?",
        Echo = "What are Stars?",
        Key = "Star"
    },
    {
        Text = "Star Drop Event?",
        Echo = "What's a Star Drop?",
        Key = "Event"
    },
    {
        Text = "Bye!",
        Echo = "Bye!",
        Key = "Bye"
    }
}
local LocalPlayer = Players.LocalPlayer
local v1 = nil
local v2 = false
local v3 = true
local t10 = {}
local self = setmetatable({}, {
    __mode = "k"
})
local t13 = {}

local function idleTrack(p1) -- line: 73
    local AnimationController = p1:FindFirstChildOfClass("AnimationController")
    local Animator = AnimationController and AnimationController:FindFirstChildOfClass("Animator")
    local Animations = p1:FindFirstChild("Animations")
    local Idle = Animations and Animations:FindFirstChild("Idle")

    if Animator == nil or Idle == nil or not Idle:IsA("Animation") then
        return nil
    end

    local function v5() -- line: 81
        -- upvalues: Animator (copy), Idle (copy)
        return Animator:LoadAnimation(Idle)
    end

    local ok, result = pcall(v5)

    if not ok or result == nil then
        return nil
    end

    result.Looped = true
    result:Play(0)

    return result
end

local function chatter(p2, p3) -- line: 92
    -- upvalues: ReplicatedStorage (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local ShootingStar = Assets and Assets:FindFirstChild("ShootingStar")
    local Sounds = ShootingStar and ShootingStar:FindFirstChild("Sounds")
    local BuddyChatter1 = Sounds and Sounds:FindFirstChild("BuddyChatter1")

    if BuddyChatter1 ~= nil and BuddyChatter1:IsA("Sound") and p2.PrimaryPart ~= nil then
        local clone = BuddyChatter1:Clone()

        clone.PlaybackSpeed = p3
        clone.Parent = p2.PrimaryPart
        clone:Play()
        clone.Ended:Once(function() -- line: 104
            -- upvalues: clone (copy)
            clone:Destroy()
        end)
    end
end

local function attend(p4, p5) -- line: 109
    -- upvalues: RunService (copy), LocalPlayer (copy)
    local Pivot = p4:GetPivot()
    local elapsed = os.clock()
    local n1 = 0

    p5:Add(function() -- line: 113
        -- upvalues: p4 (copy), Pivot (copy)
        p4:PivotTo(Pivot)
    end)
    p5:Connect(RunService.RenderStepped, function(p6) -- line: 116
        -- upvalues: p4 (copy), Pivot (copy), elapsed (copy), n1 (ref), LocalPlayer (copy)
        local Character = LocalPlayer.Character
        local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

        if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
            local v6 = (HumanoidRootPart.Position - Pivot.Position) * Vector3.new(1, 0, 1)

            if v6.Magnitude > 0.1 then
                local v12 = (math.atan2(-v6.X, -v6.Z) - (math.atan2(-Pivot.LookVector.X, -Pivot.LookVector.Z) + n1) + 3.141592653589793) % 6.283185307179586 - 3.141592653589793

                n1 += v12 * (1 - math.exp(p6 * -8))
            end
        end

        local v16 = math.clamp((os.clock() - elapsed) / 0.32, 0, 1)
        local v17 = v16 * 4 * (1 - v16) * 0.9

        p4:PivotTo(CFrame.new(Pivot.Position + Vector3.new(0, v17, 0)) * CFrame.Angles(0, n1, 0) * Pivot.Rotation)
    end)
end

local function converse(p7, p8) -- line: 139
    -- upvalues: NpcDialogue (copy), Shop (copy), Trove (copy), t2 (copy), t3 (copy), t4 (copy), t5 (copy), t6 (copy), t7 (copy), t8 (copy), t9 (copy), v1 (ref), v2 (ref), chatter (copy), attend (copy)
    if v1 then
        v1:Close()
    end

    local v18 = Trove.new()
    local v19 = NpcDialogue.new(p7, p8, function() -- line: 144
        -- upvalues: v18 (copy)
        v18:Destroy()
    end, {
        Voiced = true,
        KeepOpenTab = "StarBundles"
    })

    v1 = v19
    v18:Add(function() -- line: 148
        -- upvalues: v19 (copy), v1 (ref)
        if v1 == v19 then
            v1 = nil
        end
    end)
    attend(p7, v18)
    chatter(p7, 0.95)
    task.spawn(function() -- line: 156
        -- upvalues: p7 (copy), v19 (copy), Shop (copy), t2 (copy), t3 (copy), t4 (copy), t5 (copy), t6 (copy), t7 (copy), t8 (copy), t9 (copy), v2 (ref), chatter (copy)
        local v20 = if v2 then t3 else t2

        v2 = true

        if v19:Say(v20) then
            while not v19.Closed do
                local v21 = v19:Ask(t9)

                if v21 == "Stars" then
                    v19:Say(t4)
                    v19:Close()
                    Shop.Open()

                    return
                end

                if v21 == "Star" then
                    chatter(p7, 1)

                    if not (v19:Say(t6) and v19:Say(t7)) then
                        return
                    end
                else
                    if v21 ~= "Event" then
                        if v21 == "Bye" then
                            chatter(p7, 1.1)
                            v19:Say(t8)
                        end

                        v19:Close()

                        return
                    end

                    chatter(p7, 1.05)

                    if not (v19:Say(t5) and v19:Say(t7)) then
                        return
                    end
                end
            end
        end
    end)
end

local function concealed() -- line: 191
    -- upvalues: EggHolders (copy), v3 (ref)
    return v3 or EggHolders.IsActive()
end

local function concealedFor(p9) -- line: 195
    -- upvalues: EggHolders (copy), v3 (ref)
    local v22

    if p9:HasTag("StarHandlerProp") then
        v22 = v3

        if v22 then
            return not EggHolders.IsActive()
        end
    else
        v22 = v3 or EggHolders.IsActive()
    end

    return v22
end

local function concealNode(p10, p11) -- line: 199
    -- upvalues: t1 (copy), self (copy)
    local v23 = self[p10]

    if not p11 or v23 ~= nil then
        if not p11 and v23 ~= nil then
            self[p10] = nil

            if p10:IsA("BasePart") then
                p10.CanCollide = v23.CanCollide
                p10.LocalTransparencyModifier = 0
            elseif p10:IsA("Decal") then
                p10.LocalTransparencyModifier = 0
            elseif v23.Enabled ~= nil then
                p10.Enabled = v23.Enabled
            end
        end
    elseif p10:IsA("BasePart") then
        self[p10] = {
            CanCollide = p10.CanCollide
        }
        p10.CanCollide = false
        p10.LocalTransparencyModifier = 1
    elseif p10:IsA("Decal") then
        self[p10] = {}
        p10.LocalTransparencyModifier = 1
    else
        for _, v24 in t1 do
            if p10:IsA(v24) then
                self[p10] = {
                    Enabled = p10.Enabled
                }
                p10.Enabled = false

                return
            end
        end
    end
end

local function conceal(p12) -- line: 231
    -- upvalues: EggHolders (copy), v3 (ref), t10 (copy), concealNode (copy)
    local v25 = if p12:HasTag("StarHandlerProp") then v3 and not EggHolders.IsActive() else v3 or EggHolders.IsActive()

    p12:SetAttribute("StarHandlerLocallyHidden", if v25 then true else nil)
    concealNode(p12, v25)

    for _, descendant in p12:GetDescendants() do
        concealNode(descendant, v25)
    end

    local v26 = if p12:IsA("Model") then t10[p12] else nil

    if v26 then
        v26.Enabled = not v25
    end
end

local function concealAll() -- line: 244
    -- upvalues: CollectionService (copy), conceal (copy)
    for _, v27 in CollectionService:GetTagged("StarHandlerNpc") do
        if v27:IsA("Model") then
            conceal(v27)
        end
    end

    for _, v28 in CollectionService:GetTagged("StarHandlerProp") do
        conceal(v28)
    end
end

local function bind(p13) -- line: 255
    -- upvalues: Workspace (copy), EggHolders (copy), v3 (ref), t10 (copy), idleTrack (copy), converse (copy), conceal (copy)
    local PrimaryPart, InteractionPoint, ProximityPrompt, v29

    if not p13:IsA("Model") or p13.PrimaryPart == nil then
        return
    else
        conceal(p13)
        idleTrack(p13)
        PrimaryPart = p13.PrimaryPart
        InteractionPoint = PrimaryPart:FindFirstChild("InteractionPoint")
        ProximityPrompt = Instance.new("ProximityPrompt")
        ProximityPrompt.Name = "StarHandlerPrompt"
        ProximityPrompt.ActionText = "Talk"
        ProximityPrompt.ObjectText = "Star Handler"
        ProximityPrompt.HoldDuration = 0
        ProximityPrompt.MaxActivationDistance = 10
        ProximityPrompt.RequiresLineOfSight = false
        ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom
        v29 = v3 or EggHolders.IsActive()
    end

    ProximityPrompt.Enabled = not v29

    if InteractionPoint and InteractionPoint:IsA("Attachment") then
        PrimaryPart = InteractionPoint
    end

    ProximityPrompt.Parent = PrimaryPart
    t10[p13] = ProximityPrompt
    ProximityPrompt.Triggered:Connect(function() -- line: 274
        -- upvalues: p13 (copy), ProximityPrompt (ref), converse (copy)
        converse(p13, ProximityPrompt)
    end)
    p13.AncestryChanged:Connect(function() -- line: 277
        -- upvalues: p13 (copy), ProximityPrompt (ref), Workspace (copy), t10 (copy)
        if not p13:IsDescendantOf(Workspace) then
            if t10[p13] == ProximityPrompt then
                t10[p13] = nil
            end

            ProximityPrompt:Destroy()
        end
    end)
end

function t13.Start() -- line: 291
    -- upvalues: CollectionService (copy), EggHolders (copy), Shop (copy), Save (copy), v1 (ref), v3 (ref), conceal (copy), concealAll (copy), bind (copy)
    Shop.Initialize()
    CollectionService:GetInstanceAddedSignal("StarHandlerNpc"):Connect(bind)

    for _, v31 in CollectionService:GetTagged("StarHandlerNpc") do
        task.spawn(bind, v31)
    end

    CollectionService:GetInstanceAddedSignal("StarHandlerProp"):Connect(conceal)

    for _, v32 in CollectionService:GetTagged("StarHandlerProp") do
        conceal(v32)
    end

    task.spawn(function() -- line: 301
        -- upvalues: Save (copy), v3 (ref), concealAll (copy)
        local v33 = Save.Await()

        v3 = v33 ~= nil and v33.LastLogout == 0
        concealAll()
    end)
    EggHolders.Changed(function(p14) -- line: 306
        -- upvalues: v1 (ref), concealAll (copy)
        if p14 and v1 then
            v1:Close()
        end

        concealAll()
    end)
    EggHolders.Start()
end

function t13.CloseShop() -- line: 315
    -- upvalues: Shop (copy)
    Shop.Close()
end

return t13
