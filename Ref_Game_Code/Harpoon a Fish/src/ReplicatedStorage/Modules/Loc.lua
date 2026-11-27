-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalizationService = game:GetService("LocalizationService")
local BindableEvent = Instance.new("BindableEvent")
local t1 = {}

t1.Changed = BindableEvent.Event

local result
local t2 = {}
local n1 = 0

local function fill(p1, p2) -- line: 29
    return (p1:gsub("{([%w_]+)}", function(p3) -- line: 30
        -- upvalues: p2 (copy)
        local v1 = p2 and p2[p3]

        return v1 ~= nil and tostring(v1) or nil
    end))
end

local function strings(p4) -- line: 37
    if not p4 then
        return {}
    end

    local v2

    for v3, v4 in pairs(p4) do
        if type(v4) ~= "string" then
            v2 = v2 or table.clone(p4)
            v2[v3] = tostring(v4)
        end
    end

    return v2 or p4
end

function t1.T(p5) -- line: 49
    -- upvalues: result (ref), t2 (copy), n1 (ref)
    if not result or type(p5) ~= "string" or p5 == "" then
        return p5
    end

    local v5 = t2[p5]

    if v5 then
        return v5
    end

    local Translate = result.Translate
    local result2 = result
    local _game = game
    local ok, result3 = pcall(Translate, result2, _game, p5)

    if not ok or type(result3) ~= "string" or result3 == "" then
        result3 = p5
    end

    if n1 >= 2000 then
        table.clear(t2)
        n1 = 0
    end

    t2[p5] = result3
    n1 += 1

    return result3
end

function t1.F(p6, p7, p8) -- line: 64
    -- upvalues: result (ref), strings (copy)
    if not result then
        return (p7:gsub("{([%w_]+)}", function(p10) -- line: 30
            -- upvalues: p8 (copy)
            local v6 = p8 and p8[p10]

            return v6 ~= nil and tostring(v6) or nil
        end))
    end

    local FormatByKey = result.FormatByKey
    local result2 = result
    local v7 = strings(p8)
    local ok, result3 = pcall(FormatByKey, result2, p6, v7)

    if ok and type(result3) == "string" and result3 ~= "" then
        return result3
    end

    return (p7:gsub("{([%w_]+)}", function(p10) -- line: 30
        -- upvalues: p8 (copy)
        local v6 = p8 and p8[p10]

        return v6 ~= nil and tostring(v6) or nil
    end))
end

function t1.Fish(p11, p12) -- line: 72
    -- upvalues: t1 (copy)
    if p11 then
        return t1.F("fish.mutated", "{mutation} {fish}", {
            mutation = t1.T(p11),
            fish = t1.T(p12)
        })
    end

    return t1.T(p12)
end

function t1.Letters(p13) -- line: 79
    for _, v8 in utf8.codes(p13) do
        if v8 >= 1536 and v8 <= 1791 or v8 >= 2304 and v8 <= 2431 or v8 >= 3584 and v8 <= 3711 then
            return nil
        end
    end

    local t3 = {}

    for v9, v10 in utf8.graphemes(p13) do
        t3[#t3 + 1] = p13:sub(v9, v10)
    end

    return t3
end

function t1.TFor(p14, p15) -- line: 88
    -- upvalues: LocalizationService (copy)
    local GetTranslatorForPlayerAsync = LocalizationService.GetTranslatorForPlayerAsync
    local ok, result = pcall(GetTranslatorForPlayerAsync, LocalizationService, p14)

    if ok and result then
        local Translate = result.Translate
        local _game = game
        local ok2, result2 = pcall(Translate, result, _game, p15)

        return ok2 and type(result2) == "string" and result2 ~= "" and result2 or p15
    end

    return p15
end

if RunService:IsClient() then
    task.spawn(function() -- line: 96
        -- upvalues: Players (copy), LocalizationService (copy), BindableEvent (copy), result (ref), t2 (copy), n1 (ref)
        local LocalPlayer = Players.LocalPlayer

        for _ = 1, 5 do
            local GetTranslatorForPlayerAsync = LocalizationService.GetTranslatorForPlayerAsync
            local ok, result2 = pcall(GetTranslatorForPlayerAsync, LocalizationService, LocalPlayer)

            if ok and result2 then
                result = result2
                result2:GetPropertyChangedSignal("LocaleId"):Connect(function() -- line: 103
                    -- upvalues: BindableEvent (copy), t2 (copy), n1 (ref)
                    table.clear(t2)
                    n1 = 0
                    BindableEvent:Fire()
                end)
                BindableEvent:Fire()

                return
            end

            task.wait(3)
        end
    end)
end

return t1
