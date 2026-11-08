-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ToolGameplayGuard = require(ReplicatedStorage.Client.ToolGameplayGuard)
local LocalPlayer = Players.LocalPlayer

LocalPlayer:GetMouse()

local Parent = script.Parent
local n1 = 0
local BeeLauncherRemote = script.Parent:WaitForChild("BeeLauncherRemote")
local connection
local t1 = {}

local function removePlayerHighlights(p1) -- line: 21
    -- upvalues: t1 (ref)
    if t1[p1] then
        for _, v1 in pairs(t1[p1]) do
            if v1 and v1.Parent then
                v1:Destroy()
            end
        end

        local t2 = t1

        t2[p1] = nil
    end
end

local function addPlayerHighlights(p2) -- line: 32
    -- upvalues: t1 (ref), removePlayerHighlights (copy)
    local Character = p2.Character

    if not Character then
        return
    end

    removePlayerHighlights(p2)

    local t3 = {}
    local Highlight = Instance.new("Highlight")

    Highlight.OutlineColor = Color3.new(1, 0.933333, 0)
    Highlight.Parent = Character
    table.insert(t3, Highlight)

    local t4 = t1

    t4[p2] = t3
end

local function onUnequipped() -- line: 50
    -- upvalues: connection (ref), t1 (ref)
    if connection then
        connection:Disconnect()
        connection = nil
    end

    for _, v2 in pairs(t1) do
        for _, v3 in pairs(v2) do
            if v3 and v3.Parent then
                v3:Destroy()
            end
        end
    end

    t1 = {}
end

local function onEquipped() -- line: 66
    -- upvalues: Players (copy), RunService (copy), LocalPlayer (copy), connection (ref), t1 (ref), removePlayerHighlights (copy), addPlayerHighlights (copy), onUnequipped (copy)
    if connection then
        connection:Disconnect()
    end

    connection = RunService.Heartbeat:Connect(function() -- line: 71
        -- upvalues: Players (copy), LocalPlayer (copy), t1 (ref), removePlayerHighlights (copy), addPlayerHighlights (copy), onUnequipped (copy)
        if not (LocalPlayer.Character and LocalPlayer.Character.PrimaryPart) then
            onUnequipped()
        else
            local PrimaryPartPosition = LocalPlayer.Character.PrimaryPart.Position
            local t5 = {}

            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character.PrimaryPart then
                    if (player.Character.PrimaryPart.Position - PrimaryPartPosition).Magnitude <= 30 then
                        table.insert(t5, player)

                        if not t1[player] then
                            addPlayerHighlights(player)
                        end
                    else
                        removePlayerHighlights(player)
                    end
                end
            end

            for v4, _ in pairs(t1) do
                if not table.find(t5, v4) and v4 ~= LocalPlayer then
                    removePlayerHighlights(v4)
                end
            end
        end
    end)
end

local function onActivated() -- line: 103
    -- upvalues: Players (copy), ToolGameplayGuard (copy), LocalPlayer (copy), Parent (copy), n1 (ref), BeeLauncherRemote (copy)
    if not (ToolGameplayGuard.AllowsLocalUse(Parent) and LocalPlayer.Character and LocalPlayer.Character.PrimaryPart) then
        return
    end

    local PrimaryPartPosition = LocalPlayer.Character.PrimaryPart.Position
    local v5 = tick()

    if v5 - n1 < 60 then
        return
    end

    n1 = v5

    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer or player.Character and player.Character.PrimaryPart and (player.Character.PrimaryPart.Position - PrimaryPartPosition).Magnitude <= 30 then
        end
    end

    BeeLauncherRemote:FireServer(PrimaryPartPosition)
end

Parent.Equipped:Connect(onEquipped)
Parent.Unequipped:Connect(onUnequipped)
Parent.Activated:Connect(onActivated)
LocalPlayer.CharacterRemoving:Connect(function() -- line: 137
    -- upvalues: onUnequipped (copy)
    onUnequipped()
end)
