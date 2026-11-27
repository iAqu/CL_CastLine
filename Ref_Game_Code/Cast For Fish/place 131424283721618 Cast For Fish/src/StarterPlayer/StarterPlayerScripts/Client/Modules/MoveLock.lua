-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local StarterPlayer = game:GetService("StarterPlayer")
local t1 = {}
local t2 = {}
local t3

local function humanoid() -- line: 14
    -- upvalues: Players (copy)
    local Character = Players.LocalPlayer.Character

    return Character and Character:FindFirstChildOfClass("Humanoid")
end

function t1.Hold(p1) -- line: 19
    -- upvalues: Players (copy), StarterPlayer (copy), t2 (copy), t3 (ref)
    local Character = Players.LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    if not Humanoid then
        return
    end

    if not t3 or t3.hum ~= Humanoid then
        t3 = {
            hum = Humanoid,
            walk = if Humanoid.WalkSpeed > 0 then Humanoid.WalkSpeed else StarterPlayer.CharacterWalkSpeed,
            jumpPower = if Humanoid.JumpPower > 0 then Humanoid.JumpPower else StarterPlayer.CharacterJumpPower,
            jumpHeight = if Humanoid.JumpHeight > 0 then Humanoid.JumpHeight else StarterPlayer.CharacterJumpHeight
        }
    end

    t2[p1] = true
    Humanoid.WalkSpeed = 0
    Humanoid.JumpPower = 0
    Humanoid.JumpHeight = 0
end

function t1.Free(p2) -- line: 38
    -- upvalues: t2 (copy), t3 (ref)
    t2[p2] = nil

    if next(t2) == nil and t3 then
        local t5 = t3

        t3 = nil

        if t5.hum.Parent then
            t5.hum.WalkSpeed = t5.walk
            t5.hum.JumpPower = t5.jumpPower
            t5.hum.JumpHeight = t5.jumpHeight
        end
    end
end

function t1.IsHeld(p3) -- line: 52
    -- upvalues: t2 (copy)
    if p3 then
        return t2[p3] == true
    end

    return next(t2) ~= nil
end

function t1.Holders() -- line: 58
    -- upvalues: t2 (copy)
    local t6 = {}

    for v1 in pairs(t2) do
        table.insert(t6, v1)
    end

    table.sort(t6)

    return table.concat(t6, ",")
end

local LocalPlayer = Players.LocalPlayer

local function applyAdmin() -- line: 70
    -- upvalues: Players (copy), StarterPlayer (copy), t3 (ref), LocalPlayer (copy)
    local AdminWalk = LocalPlayer:GetAttribute("AdminWalk")
    local AdminJump = LocalPlayer:GetAttribute("AdminJump")

    if type(AdminWalk) ~= "number" then
        AdminWalk = StarterPlayer.CharacterWalkSpeed
    end

    local v2 = if type(AdminJump) == "number" then AdminJump else StarterPlayer.CharacterJumpHeight
    local v3 = if type(AdminJump) == "number" then math.sqrt(2 * workspace.Gravity * AdminJump) else StarterPlayer.CharacterJumpPower

    if t3 then
        local t7 = t3
        local t8 = t3
        local t9 = t3

        t7.walk = AdminWalk
        t8.jumpHeight = v2
        t9.jumpPower = v3
    else
        local Character = Players.LocalPlayer.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

        if Humanoid then
            Humanoid.WalkSpeed = AdminWalk
            Humanoid.JumpHeight = v2
            Humanoid.JumpPower = v3
        end
    end
end

LocalPlayer:GetAttributeChangedSignal("AdminWalk"):Connect(applyAdmin)
LocalPlayer:GetAttributeChangedSignal("AdminJump"):Connect(applyAdmin)
LocalPlayer.CharacterAdded:Connect(function(p4) -- line: 89
    -- upvalues: t2 (copy), t3 (ref), LocalPlayer (copy), applyAdmin (copy)
    table.clear(t2)
    t3 = nil

    if LocalPlayer:GetAttribute("AdminWalk") or LocalPlayer:GetAttribute("AdminJump") then
        task.spawn(function() -- line: 93
            -- upvalues: p4 (copy), t3 (ref), applyAdmin (copy)
            if p4:WaitForChild("Humanoid", 10) and not t3 then
                applyAdmin()
            end
        end)
    end
end)

return t1
