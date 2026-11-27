-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ConnectionUtil = require(script.Parent).get("ConnectionUtil")
local _ = {
    LOCAL_PLAYER = "LOCAL_PLAYER",
    ON_LOCAL_PLAYER = "ON_LOCAL_PLAYER",
    CHARACTER_ADDED = "CHARACTER_ADDED",
    ON_CHARACTER = "ON_CHARACTER",
    CHARACTER_CHILD_ADDED = "CHARACTER_CHILD_ADDED"
}
local t1 = {
    _connectionUtil = ConnectionUtil.new(),
    _boundEvents = {}
}

function t1.getLocalPlayer() -- line: 55
    -- upvalues: Players (copy)
    return Players.LocalPlayer
end

function t1.onLocalPlayer(p1) -- line: 59
    -- upvalues: Players (copy), t1 (copy)
    local v1 = t1.getLocalPlayer()

    if v1 then
        p1(v1)
    end

    t1._connectionUtil:trackConnection("LOCAL_PLAYER", Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function() -- line: 68
        -- upvalues: t1 (copy)
        local v2 = t1.getLocalPlayer()

        assert(v2)
        t1._getOrCreateBoundEvent("LOCAL_PLAYER"):Fire(v2)
    end))

    return t1._getOrCreateBoundEvent("LOCAL_PLAYER").Event:Connect(p1)
end

function t1.getCharacter() -- line: 79
    -- upvalues: t1 (copy)
    local v3 = t1.getLocalPlayer()

    return if v3 then v3.Character else nil
end

function t1.onCharacter(p2) -- line: 87
    -- upvalues: t1 (copy)
    t1._connectionUtil:trackConnection("ON_LOCAL_PLAYER", t1.onLocalPlayer(function(p3) -- line: 91
        -- upvalues: p2 (copy), t1 (copy)
        local v4 = t1.getCharacter()

        if v4 then
            p2(v4)
        end

        t1._connectionUtil:trackConnection("CHARACTER_ADDED", p3.CharacterAdded:Connect(function(p4) -- line: 100
            -- upvalues: t1 (copy)
            assert(p4)
            t1._getOrCreateBoundEvent("CHARACTER_ADDED"):Fire(p4)
        end))
    end))

    return t1._getOrCreateBoundEvent("CHARACTER_ADDED").Event:Connect(p2)
end

function t1.getChild(p5, p6) -- line: 112
    -- upvalues: t1 (copy)
    local v5 = t1.getCharacter()

    if not v5 then
        return nil
    end

    local v6 = v5:FindFirstChild(p5)

    return if v6 and v6:IsA(p6) then v6 else nil
end

function t1.onChild(p7, p8, p9) -- line: 124
    -- upvalues: t1 (copy)
    t1._connectionUtil:trackConnection("ON_CHARACTER", t1.onCharacter(function(p10) -- line: 128
        -- upvalues: p7 (copy), p8 (copy), p9 (copy), t1 (copy)
        local v7 = t1.getChild(p7, p8)

        if v7 then
            p9(v7)
        end

        t1._connectionUtil:trackConnection("CHARACTER_CHILD_ADDED", p10.ChildAdded:Connect(function(p11) -- line: 137
            -- upvalues: p7 (copy), p8 (copy), t1 (copy)
            if p11.Name == p7 and p11:IsA(p8) then
                t1._getOrCreateBoundEvent("CHARACTER_CHILD_ADDED" .. p7 .. p8):Fire(p11)
            end
        end))
    end))

    return t1._getOrCreateBoundEvent("CHARACTER_CHILD_ADDED" .. p7 .. p8).Event:Connect(p9)
end

function t1._getOrCreateBoundEvent(p12) -- line: 151
    -- upvalues: t1 (copy)
    if not t1._boundEvents[p12] then
        t1._boundEvents[p12] = Instance.new("BindableEvent")
    end

    return t1._boundEvents[p12]
end

return t1
