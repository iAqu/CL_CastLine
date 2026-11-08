-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local HttpService = game:GetService("HttpService")
local ScrambleMotion = require(script.Parent.ScrambleMotion)
local t1 = {
    DeathFadeSeconds = 0.6
}

function t1.Pose(p1, p2, p3) -- line: 8
    -- upvalues: ScrambleMotion (copy)
    if not p1 then
        return ScrambleMotion.Pose(p2, p3)
    end

    if p1.Name == "Death" then
        return p1.From
    end

    local v3 = math.clamp((p3 - p1.At) / math.max(p1.Duration, 0.001), 0, 1)

    if p1.Name == "Knockback" then
        v3 = v3 * v3 * (3 - v3 * 2)
    end

    local v4 = p1.From:Lerp(p1.To, v3)

    if p1.Name ~= "Death" then
        v4 += Vector3.new(0, math.sin((p3 - p2.StartedAt) * 2.1 + p2.Phase) * p2.Bob, 0)
    end

    return v4
end

function t1.Encode(p4) -- line: 25
    -- upvalues: HttpService (copy)
    return HttpService:JSONEncode({
        p4.Name,
        p4.At,
        p4.Duration,
        { p4.From:GetComponents() },
        { p4.To:GetComponents() },
        p4.AnimationAt
    })
end

function t1.Decode(p5) -- line: 35
    -- upvalues: HttpService (copy)
    if type(p5) ~= "string" then
        return nil
    end

    local JSONDecode = HttpService.JSONDecode
    local ok, result = pcall(JSONDecode, HttpService, p5)

    return if ok and type(result) == "table" and #result == 6 then {
        Name = result[1],
        At = result[2],
        Duration = result[3],
        From = CFrame.new(table.unpack(result[4])),
        To = CFrame.new(table.unpack(result[5])),
        AnimationAt = result[6]
    } else nil
end

function t1.Read(p6) -- line: 52
    -- upvalues: t1 (copy)
    return t1.Decode(p6:GetAttribute("DroneMotion"))
end

return table.freeze(t1)
