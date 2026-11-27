-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local LevelRewards = require(script.Parent:WaitForChild("LevelRewards"))
local t1 = {}

function t1.LevelLuck(p1) -- line: 17
    -- upvalues: LevelRewards (copy)
    return 1 + LevelRewards.Luck(if type(p1) ~= "number" or not p1 then 1 else p1) / 100
end

function t1.Chances(p2, p3, p4) -- line: 22
    -- upvalues: t1 (copy)
    local v1 = t1.LevelLuck(p3)

    local function weight(p5) -- line: 24
        -- upvalues: v1 (copy)
        return p5.n == "None" and p5.w or p5.w * v1
    end

    local n1 = 0

    for _, v2 in ipairs(p2) do
        n1 += v2.n == "None" and v2.w or v2.w * v1
    end

    local t2 = {}

    if not (n1 <= 0) then
        local n2 = 0

        for _, v3 in ipairs(p2) do
            t2[v3.n] = (v3.n == "None" and v3.w or v3.w * v1) / n1

            if v3.n ~= "None" then
                n2 += t2[v3.n]
            end
        end

        local v4 = p4 or 1

        if v4 ~= 1 and n2 > 0 then
            local v6 = math.min(1, n2 * v4)

            for v7, v8 in pairs(t2) do
                if v7 ~= "None" then
                    t2[v7] = v8 * v6 / n2
                end
            end

            t2.None = 1 - v6
        end
    end

    return t2
end

function t1.Rows() -- line: 46
    local MutationWeights = game:GetService("ReplicatedStorage"):GetAttribute("MutationWeights")

    local function v9() -- line: 48
        -- upvalues: MutationWeights (copy)
        return game:GetService("HttpService"):JSONDecode(MutationWeights)
    end

    local ok, result = pcall(v9)

    if ok and type(result) == "table" and result then
        return result
    end

    return {}
end

function t1.Upgrade(p6, p7, p8) -- line: 57
    local n3 = 0

    for _, v10 in ipairs(p6) do
        if v10.n == (p7 or "None") then
            n3 = v10.w
        end
    end

    local t3 = {}
    local n4 = 0

    for _, v11 in ipairs(p6) do
        if v11.n ~= "None" and v11.w < n3 then
            local v12 = p8 and p8[v11.n] or v11.w

            if v12 > 0 then
                t3[#t3 + 1] = {
                    n = v11.n,
                    w = v12,
                    rank = v11.w
                }
                n4 += v12
            end
        end
    end

    table.sort(t3, function(p9, p10) -- line: 72
        return p9.rank > p10.rank
    end)

    local t4 = {}

    for v13, v14 in ipairs(t3) do
        t4[v13] = {
            n = v14.n,
            p = v14.w / n4
        }
    end

    return t4
end

function t1.Pick(p11, p12) -- line: 79
    local n5 = 0

    for _, v15 in ipairs(p11) do
        n5 += v15.p

        if p12 < n5 then
            return v15.n
        end
    end

    return p11[#p11] and p11[#p11].n or nil
end

return t1
