-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Toast = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Toast"))
local InputMode = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("InputMode"))
local PromptLook = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("PromptLook"))
local Loc = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Loc"))
local TitanConfig = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("TitanConfig"))
local _ = {
    RANGE = 100,
    CHECK = 0.2,
    TEXT = "PLACE IN AQUARIUM"
}
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local AquariumAction = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("AquariumAction")

local function myAquarium() -- line: 38
    -- upvalues: LocalPlayer (copy)
    local Plots = workspace:FindFirstChild("Plots")
    local v1 = Plots and Plots:FindFirstChild(LocalPlayer:GetAttribute("Plot") or "")

    return v1 and v1:FindFirstChild("Aquarium")
end

local TelemetryReport = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("TelemetryReport")

local function glassDist() -- line: 45
    -- upvalues: LocalPlayer (copy)
    local Plots = workspace:FindFirstChild("Plots")
    local v2 = Plots and Plots:FindFirstChild(LocalPlayer:GetAttribute("Plot") or "")
    local v3 = v2 and v2:FindFirstChild("Aquarium")

    v3 = v3 and (v3:FindFirstChild("GlassFront") or v3:FindFirstChildWhichIsA("BasePart", true))

    local v4 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local Magnitude, v5

    if v3 and v4 then
        local Magnitude2 = (v3.Position - v4.Position).Magnitude

        if Magnitude2 then
            Magnitude = Magnitude2
            v5 = true
        else
            v5 = false
        end
    else
        v5 = false
    end

    if not v5 then
        Magnitude = nil
    end

    return Magnitude
end

local function log(p1, p2) -- line: 51
    -- upvalues: TelemetryReport (copy), glassDist (copy)
    TelemetryReport:FireServer("placing", p1, p2, (glassDist()))
end

local function place(p3, p4) -- line: 55
    -- upvalues: Toast (copy), TitanConfig (copy), LocalPlayer (copy), AquariumAction (copy), TelemetryReport (copy), glassDist (copy)
    if not TitanConfig.IsTitan(p3:GetAttribute("Species")) and (LocalPlayer:GetAttribute("PenCount") or 0) >= (LocalPlayer:GetAttribute("PenCap") or 0) then
        TelemetryReport:FireServer("placing", "full", p4, (glassDist()))
        Toast.Show("Aquarium Full!", "", nil, Toast.RED, "deny")

        return
    end

    TelemetryReport:FireServer("placing", "press", p4, (glassDist()))
    AquariumAction:FireServer("Equip", p3:GetAttribute("BagId"))
    LocalPlayer:SetAttribute("TutorialSent", "FishPlaced@" .. os.clock())
end

local t1 = {}

local function wireTool(p5) -- line: 68
    -- upvalues: InputMode (copy), LocalPlayer (copy), Mouse (copy), TelemetryReport (copy), glassDist (copy), place (copy), t1 (copy)
    if not p5:IsA("Tool") or t1[p5] or not p5:GetAttribute("BagId") then
        return
    end

    t1[p5] = true
    p5.Destroying:Connect(function() -- line: 71
        -- upvalues: p5 (copy), t1 (copy)
        t1[p5] = nil
    end)
    p5.Activated:Connect(function() -- line: 72
        -- upvalues: p5 (copy), InputMode (copy), LocalPlayer (copy), Mouse (copy), TelemetryReport (copy), glassDist (copy), place (copy)
        if InputMode.Pad() then
            return
        end

        local Target = Mouse.Target
        local Plots = workspace:FindFirstChild("Plots")
        local v6 = Plots and Plots:FindFirstChild(LocalPlayer:GetAttribute("Plot") or "")
        local Aquarium = v6 and v6:FindFirstChild("Aquarium")
        local v7 = Target and Target:FindFirstAncestorOfClass("Model")
        local v8 = v7 ~= nil and v7:GetAttribute("PenOwner") == LocalPlayer.UserId

        if Target and Aquarium and (Target:IsDescendantOf(Aquarium) or v8) then
            place(p5, "tank")
        else
            TelemetryReport:FireServer("placing", "miss", Target and Target.Name or "sky", (glassDist()))
        end
    end)
end

local function watch(p6) -- line: 90
    -- upvalues: wireTool (copy)
    for _, child in ipairs(p6:GetChildren()) do
        wireTool(child)
    end

    p6.ChildAdded:Connect(wireTool)
end

watch(LocalPlayer:WaitForChild("Backpack"))
LocalPlayer.ChildAdded:Connect(function(p7) -- line: 96
    -- upvalues: watch (copy)
    if p7:IsA("Backpack") then
        watch(p7)
    end
end)

if LocalPlayer.Character then
    watch(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(watch)

local ProximityPromptService = game:GetService("ProximityPromptService")

local function heldFish() -- line: 103
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local Tool = Character and Character:FindFirstChildOfClass("Tool")
    local Tool2 = if not Tool or Tool:GetAttribute("BagId") == nil then nil else Tool

    return Tool2
end

local v10, Attachment, ProximityPrompt, v11
local n1 = 0

local function press(p8) -- line: 110
    -- upvalues: LocalPlayer (copy), place (copy), ProximityPrompt (ref)
    local Character = LocalPlayer.Character
    local Tool = Character and Character:FindFirstChildOfClass("Tool")
    local Tool2 = if not Tool or Tool:GetAttribute("BagId") == nil then nil else Tool

    if Tool2 and ProximityPrompt and ProximityPrompt.Enabled then
        place(Tool2, p8)
    end
end

local function build(p9) -- line: 116
    -- upvalues: PromptLook (copy), LocalPlayer (copy), place (copy), v10 (ref), Attachment (ref), ProximityPrompt (ref), v11 (ref), n1 (ref)
    v10 = p9

    if Attachment then
        Attachment:Destroy()
    end

    if v11 then
        PromptLook.Hide(v11)
    end

    Attachment = Instance.new("Attachment")
    Attachment.Name = "PlaceSpot"
    ProximityPrompt = Instance.new("ProximityPrompt")
    ProximityPrompt.Name = "PlaceFishPrompt"

    local ProximityPrompt2 = ProximityPrompt

    ProximityPrompt2.Style = Enum.ProximityPromptStyle.Custom
    ProximityPrompt.ActionText = "PLACE IN AQUARIUM"
    ProximityPrompt.HoldDuration = 0
    ProximityPrompt.MaxActivationDistance = 100
    ProximityPrompt.RequiresLineOfSight = false
    ProximityPrompt.ClickablePrompt = false

    local ProximityPrompt3 = ProximityPrompt

    ProximityPrompt3.KeyboardKeyCode = Enum.KeyCode.E

    local ProximityPrompt4 = ProximityPrompt

    ProximityPrompt4.GamepadKeyCode = Enum.KeyCode.ButtonR2
    ProximityPrompt.Enabled = false
    ProximityPrompt.Triggered:Connect(function() -- line: 133
        -- upvalues: LocalPlayer (copy), place (copy), ProximityPrompt (ref), n1 (ref)
        if os.clock() - n1 < 0.5 then
            return
        end

        local Character = LocalPlayer.Character
        local Tool = Character and Character:FindFirstChildOfClass("Tool")
        local Tool2 = if not Tool or Tool:GetAttribute("BagId") == nil then nil else Tool

        if Tool2 and ProximityPrompt and ProximityPrompt.Enabled then
            place(Tool2, "key")
        end
    end)
    ProximityPrompt.Parent = Attachment
    Attachment.Parent = p9
end

ProximityPromptService.PromptShown:Connect(function(p10) -- line: 140
    -- upvalues: PromptLook (copy), Loc (copy), LocalPlayer (copy), TelemetryReport (copy), glassDist (copy), place (copy), Attachment (ref), ProximityPrompt (ref), v11 (ref)
    if p10 ~= ProximityPrompt then
        return
    end

    v11 = v11 or PromptLook.Build(Attachment, "PlaceFishPromptUI", function() -- line: 142
        -- upvalues: LocalPlayer (copy), place (copy), ProximityPrompt (ref)
        local Character = LocalPlayer.Character
        local Tool = Character and Character:FindFirstChildOfClass("Tool")
        local Tool2 = if not Tool or Tool:GetAttribute("BagId") == nil then nil else Tool

        if Tool2 and ProximityPrompt and ProximityPrompt.Enabled then
            place(Tool2, "tap")
        end
    end, {
        pc = "E",
        touch = "TAP",
        pad = Enum.KeyCode.ButtonR2
    })
    TelemetryReport:FireServer("placing", "shown", nil, (glassDist()))
    v11.bb.Adornee = Attachment
    PromptLook.Show(v11, Loc.T("PLACE IN AQUARIUM"))
end)
ProximityPromptService.PromptHidden:Connect(function(p11) -- line: 147
    -- upvalues: PromptLook (copy), ProximityPrompt (ref), v11 (ref)
    if p11 == ProximityPrompt and v11 then
        PromptLook.Hide(v11)
    end
end)

local ContextActionService = game:GetService("ContextActionService")
local v15 = false

local function padPlace(_, p13) -- line: 158
    -- upvalues: LocalPlayer (copy), place (copy), n1 (ref)
    if p13 ~= Enum.UserInputState.Begin then
        return Enum.ContextActionResult.Pass
    end

    local Character = LocalPlayer.Character
    local Tool = Character and Character:FindFirstChildOfClass("Tool")
    local Tool2 = if not Tool or Tool:GetAttribute("BagId") == nil then nil else Tool

    if not Tool2 or os.clock() - n1 < 0.5 then
        return Enum.ContextActionResult.Pass
    end

    n1 = os.clock()
    place(Tool2, "key")

    return Enum.ContextActionResult.Sink
end

local function bindPad(p14) -- line: 166
    -- upvalues: ContextActionService (copy), v15 (ref), padPlace (copy)
    if p14 ~= v15 then
        v15 = p14

        if p14 then
            ContextActionService:BindActionAtPriority("PlaceFishR2", padPlace, false, 3000, Enum.KeyCode.ButtonR2)
        else
            ContextActionService:UnbindAction("PlaceFishR2")
        end
    end
end

local n2 = 0
local v17 = false

game:GetService("RunService").Heartbeat:Connect(function(p15) -- line: 177
    -- upvalues: LocalPlayer (copy), TelemetryReport (copy), glassDist (copy), v10 (ref), Attachment (ref), ProximityPrompt (ref), build (copy), ContextActionService (copy), v15 (ref), padPlace (copy), n2 (ref), v17 (ref)
    n2 += p15

    if n2 < 0.2 then
        return
    end

    n2 = 0

    local Plots = workspace:FindFirstChild("Plots")
    local v18 = Plots and Plots:FindFirstChild(LocalPlayer:GetAttribute("Plot") or "")
    local v19 = v18 and v18:FindFirstChild("Aquarium")

    v19 = v19 and (v19:FindFirstChild("GlassFront") or v19:FindFirstChildWhichIsA("BasePart", true))

    if v19 and (v19 ~= v10 or not Attachment.Parent) then
        build(v19)
    end

    local v20 = false

    if v19 ~= nil then
        local Character = LocalPlayer.Character
        local Tool = Character and Character:FindFirstChildOfClass("Tool")
        local Tool2 = if not Tool or Tool:GetAttribute("BagId") == nil then nil else Tool

        v20 = Tool2 ~= nil
    end

    if ProximityPrompt and ProximityPrompt.Enabled ~= v20 then
        ProximityPrompt.Enabled = v20
    end

    local v22 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    if v20 then
        v20 = Attachment ~= nil and v22 ~= nil and (v22.Position - Attachment.WorldPosition).Magnitude <= 100
    end

    if v20 ~= v15 then
        v15 = v20

        if v20 then
            ContextActionService:BindActionAtPriority("PlaceFishR2", padPlace, false, 3000, Enum.KeyCode.ButtonR2)
        else
            ContextActionService:UnbindAction("PlaceFishR2")
        end
    end

    local Character = LocalPlayer.Character
    local Tool = Character and Character:FindFirstChildOfClass("Tool")
    local Tool2 = if not Tool or Tool:GetAttribute("BagId") == nil then nil else Tool
    local v24 = Tool2 ~= nil

    if v24 == v17 then
        return
    end

    v17 = v24
    TelemetryReport:FireServer("placing", v24 and "hold" or "unhold", nil, (glassDist()))
end)
