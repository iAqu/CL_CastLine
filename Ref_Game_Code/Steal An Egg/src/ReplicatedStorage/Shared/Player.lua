-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local t1 = {}

local function resolvePlayer(p1) -- line: 11
    -- upvalues: Players (copy)
    p1 = p1 or Players.LocalPlayer
    assert(p1 ~= nil, "Rig lookups need an explicit Player when there is no LocalPlayer")

    return p1
end

local function pickPart(p2) -- line: 17
    return function(p3) -- line: 18
        -- upvalues: p2 (copy)
        local v3 = p3:FindFirstChild(p2)

        return if v3 and v3:IsA("BasePart") then v3 else nil
    end
end

local function pickHumanoid(p4) -- line: 24
    return (p4:FindFirstChildOfClass("Humanoid"))
end

local v4 = "HumanoidRootPart"

local function v5(p5) -- line: 18
    -- upvalues: v4 (copy)
    local v6 = p5:FindFirstChild(v4)

    return if v6 and v6:IsA("BasePart") then v6 else nil
end

local v7 = "Head"

local function v8(p6) -- line: 18
    -- upvalues: v7 (copy)
    local v9 = p6:FindFirstChild(v7)

    return if v9 and v9:IsA("BasePart") then v9 else nil
end

local function awaitPiece(p7, p8) -- line: 31
    local v10 = p8(p7)

    while v10 == nil do
        p7.ChildAdded:Wait()
        v10 = p8(p7)
    end

    return v10
end

function t1.FindCharacter(p9) -- line: 40
    -- upvalues: Players (copy)
    p9 = p9 or Players.LocalPlayer
    assert(p9 ~= nil, "Rig lookups need an explicit Player when there is no LocalPlayer")

    return p9.Character
end

function t1.WaitForCharacter(p10) -- line: 44
    -- upvalues: Players (copy)
    p10 = p10 or Players.LocalPlayer
    assert(p10 ~= nil, "Rig lookups need an explicit Player when there is no LocalPlayer")

    return p10.Character or p10.CharacterAdded:Wait()
end

function t1.FindHumanoid(p11) -- line: 49
    -- upvalues: t1 (copy)
    local v15 = t1.FindCharacter(p11)

    return if v15 then v15:FindFirstChildOfClass("Humanoid") else nil
end

function t1.WaitForHumanoid(p12) -- line: 54
    -- upvalues: t1 (copy), pickHumanoid (copy), awaitPiece (copy)
    return (awaitPiece(t1.WaitForCharacter(p12), pickHumanoid))
end

function t1.FindRootPart(p13) -- line: 58
    -- upvalues: t1 (copy), v5 (copy)
    local v16 = t1.FindCharacter(p13)

    return if v16 then v5(v16) else nil
end

function t1.WaitForRootPart(p14) -- line: 63
    -- upvalues: t1 (copy), v5 (copy), awaitPiece (copy)
    return (awaitPiece(t1.WaitForCharacter(p14), v5))
end

function t1.FindPrimaryPart(p15) -- line: 67
    -- upvalues: t1 (copy)
    local v17 = t1.FindCharacter(p15)

    return if v17 then v17.PrimaryPart else nil
end

function t1.FindHead(p16) -- line: 72
    -- upvalues: t1 (copy), v8 (copy)
    local v18 = t1.FindCharacter(p16)

    return if v18 then v8(v18) else nil
end

function t1.FindAnimator(p17) -- line: 77
    -- upvalues: t1 (copy)
    local v19 = t1.FindHumanoid(p17)

    return if v19 then v19:FindFirstChildOfClass("Animator") else nil
end

function t1.FindFeetCFrame(p18) -- line: 83
    -- upvalues: t1 (copy)
    local v20 = t1.FindCharacter(p18)
    local PrimaryPart, Humanoid

    if v20 then
        PrimaryPart = v20.PrimaryPart
        Humanoid = v20:FindFirstChildOfClass("Humanoid")
    end

    return if PrimaryPart ~= nil and Humanoid ~= nil then PrimaryPart.CFrame * CFrame.new(0, -(Humanoid.HipHeight + PrimaryPart.Size.Y / 2), 0) else nil
end

return t1
