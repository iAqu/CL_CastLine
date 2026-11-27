-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local t1 = {
    "glow",
    "lightning"
}
local t2 = {}
local t3 = {}
local v1 = LocalPlayer:GetAttribute("Potato") == true

local function isOff(p1) -- line: 25
    -- upvalues: t1 (copy)
    local v2 = p1.Name:lower()

    for _, v3 in ipairs(t1) do
        if v2:find(v3, 1, true) then
            return true
        end
    end

    return false
end

local function fainter(p2) -- line: 31
    local t4 = {}

    for _, v4 in ipairs(p2.Keypoints) do
        t4[#t4 + 1] = NumberSequenceKeypoint.new(v4.Time, math.min(1, v4.Value + 0.4), v4.Envelope)
    end

    return NumberSequence.new(t4)
end

local function isAura(p3) -- line: 39
    return p3:IsA("ParticleEmitter") and p3:GetAttribute("Aura") == true
end

local function apply(p4) -- line: 44
    -- upvalues: t2 (copy), t3 (copy), v1 (ref), isOff (copy), fainter (copy)
    local v7 = t2[p4]

    if not v7 then
        v7 = {
            p4.Enabled,
            p4.Rate,
            p4.Transparency
        }
        t2[p4] = v7
    end

    if v1 then
        local v8 = v7[2]
        local v9 = v7[3]

        p4.Enabled = false
        p4.Rate = v8
        p4.Transparency = v9
        p4:Clear()
    elseif t3[p4] then
        if isOff(p4) then
            p4.Enabled = false
            p4:Clear()
        else
            local v10 = v7[1]
            local v11 = v7[2] * 0.35
            local v12 = fainter(v7[3])

            p4.Enabled = v10
            p4.Rate = v11
            p4.Transparency = v12
        end
    else
        local v13 = v7[1]
        local v14 = v7[2]
        local v15 = v7[3]

        p4.Enabled = v13
        p4.Rate = v14
        p4.Transparency = v15
    end
end

local function prune() -- line: 66
    -- upvalues: t2 (copy), t3 (copy)
    for v16 in pairs(t2) do
        if not v16:IsDescendantOf(game) then
            t2[v16] = nil
            t3[v16] = nil
        end
    end
end

local function dim(p5, p6) -- line: 74
    -- upvalues: t3 (copy), apply (copy), prune (copy)
    prune()

    local Spear = p5:FindFirstChild("Spear")

    if Spear then
        for _, descendant in ipairs(Spear:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") and descendant:GetAttribute("Aura") == true then
                t3[descendant] = p6 or nil
                apply(descendant)
            end
        end
    end
end

local function watch(p7) -- line: 86
    -- upvalues: LocalPlayer (copy), t3 (copy), apply (copy), dim (copy)
    local function check() -- line: 87
        -- upvalues: p7 (copy), LocalPlayer (copy), dim (copy)
        dim(p7, p7:GetAttribute("OccupantUserId") == LocalPlayer.UserId)
    end

    p7:GetAttributeChangedSignal("OccupantUserId"):Connect(check)
    p7.DescendantAdded:Connect(function(p8) -- line: 92
        -- upvalues: p7 (copy), LocalPlayer (copy), t3 (copy), apply (copy)
        if not p8:IsA("ParticleEmitter") or p8:GetAttribute("Aura") ~= true then
            return
        end

        t3[p8] = p7:GetAttribute("OccupantUserId") == LocalPlayer.UserId or nil
        apply(p8)
    end)
    dim(p7, p7:GetAttribute("OccupantUserId") == LocalPlayer.UserId)
end

local Plots = workspace:WaitForChild("Plots")

local function onPlot(p9) -- line: 102
    -- upvalues: watch (copy)
    task.spawn(function() -- line: 103
        -- upvalues: p9 (copy), watch (copy)
        local v18 = p9:WaitForChild("Harpoon", 30)

        if v18 then
            watch(v18)
        end
    end)
end

for _, child in ipairs(Plots:GetChildren()) do
    task.spawn(function() -- line: 103
        -- upvalues: watch (copy), child (copy)
        local v19 = child:WaitForChild("Harpoon", 30)

        if v19 then
            watch(v19)
        end
    end)
end

Plots.ChildAdded:Connect(onPlot)

local function onCharacter(p10) -- line: 112
    -- upvalues: t2 (copy), v1 (ref), apply (copy)
    for _, descendant in ipairs(p10:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") and descendant:GetAttribute("Aura") == true and (v1 or t2[descendant]) then
            apply(descendant)
        end
    end

    p10.DescendantAdded:Connect(function(p11) -- line: 116
        -- upvalues: t2 (copy), v1 (ref), apply (copy)
        if p11:IsA("ParticleEmitter") and p11:GetAttribute("Aura") == true and (v1 or t2[p11]) then
            apply(p11)
        end
    end)
end

local function onPlayer(p12) -- line: 120
    -- upvalues: onCharacter (copy)
    if p12.Character then
        onCharacter(p12.Character)
    end

    p12.CharacterAdded:Connect(onCharacter)
end

for _, player in ipairs(Players:GetPlayers()) do
    if player.Character then
        onCharacter(player.Character)
    end

    player.CharacterAdded:Connect(onCharacter)
end

Players.PlayerAdded:Connect(onPlayer)
LocalPlayer:GetAttributeChangedSignal("Potato"):Connect(function() -- line: 128
    -- upvalues: Players (copy), LocalPlayer (copy), t2 (copy), v1 (ref), apply (copy), prune (copy), Plots (copy)
    v1 = LocalPlayer:GetAttribute("Potato") == true
    prune()

    for _, child in ipairs(Plots:GetChildren()) do
        local v20 = child:FindFirstChild("Harpoon") and child.Harpoon:FindFirstChild("Spear")

        if v20 then
            for _, descendant in ipairs(v20:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") and descendant:GetAttribute("Aura") == true then
                    apply(descendant)
                end
            end
        end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            for _, descendant in ipairs(player.Character:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") and descendant:GetAttribute("Aura") == true then
                    apply(descendant)
                end
            end
        end
    end

    local Backpack = LocalPlayer:FindFirstChildOfClass("Backpack")

    if Backpack then
        for _, descendant in ipairs(Backpack:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") and descendant:GetAttribute("Aura") == true and (v1 or t2[descendant]) then
                apply(descendant)
            end
        end
    end
end)
