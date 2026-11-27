-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local FishDisplay = require(Modules:WaitForChild("FishDisplay"))
local RarityDisplay = require(Modules:WaitForChild("RarityDisplay"))
local MutationDisplay = require(Modules:WaitForChild("MutationDisplay"))
local Format = require(Modules:WaitForChild("Format"))
local Zones = require(Modules:WaitForChild("Zones"))
local Loc = require(Modules:WaitForChild("Loc"))
local WeatherConfig = require(Modules:WaitForChild("WeatherConfig"))
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local t1 = {
    Legendary = true,
    Mythic = true,
    Exotic = true,
    Unknown = true
}
local t2 = {
    Mythic = true,
    Exotic = true,
    Secret = true,
    Celestial = true,
    Apex = true
}
local t3 = {
    Shadow = Color3.fromRGB(170, 110, 230)
}
local v1 = Color3.fromRGB(255, 90, 200)
local v2 = Color3.fromRGB(110, 235, 110)
local v3 = Color3.fromRGB(235, 235, 255)

local function escape(p1) -- line: 65
    return (tostring(p1):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

local function hex(p2) -- line: 69
    return string.format("#%02X%02X%02X", math.round(p2.R * 255), math.round(p2.G * 255), (math.round(p2.B * 255)))
end

local function dark(p3) -- line: 73
    return 0.299 * p3.R + 0.587 * p3.G + 0.114 * p3.B < 0.18
end

local function paint(p4, p5, p6) -- line: 79
    -- upvalues: v3 (copy)
    local v9 = "<b>" .. tostring(p4):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;") .. "</b>"

    if not p5 then
        return v9
    end

    local v15 = "<font color=\"" .. string.format("#%02X%02X%02X", math.round(p5.R * 255), math.round(p5.G * 255), (math.round(p5.B * 255))) .. "\">" .. v9 .. "</font>"
    local v16, v17, v18

    if 0.299 * p5.R + 0.587 * p5.G + 0.114 * p5.B < 0.18 then
        v16 = p6 or v3
        v18 = false
    elseif p6 then
        v16 = p6
        v18 = false
    else
        v17 = v15
        v18 = true
    end

    if not v18 then
        v17 = "<stroke color=\"" .. string.format("#%02X%02X%02X", math.round(v16.R * 255), math.round(v16.G * 255), (math.round(v16.B * 255))) .. "\" thickness=\"1\">" .. v15 .. "</stroke>"
    end

    return v17
end

local function rainbow(p7) -- line: 88
    -- upvalues: Loc (copy), paint (copy)
    local v24 = Loc.Letters(p7)

    if not v24 then
        return (paint(p7, Color3.fromHSV(0.42, 0.75, 1)))
    end

    local t4 = {}
    local v25 = #v24

    for v26, v27 in ipairs(v24) do
        if v27:match("^%s+$") then
            t4[v26] = v27
        else
            local v28 = Color3.fromHSV((v26 - 1) / math.max(v25, 1) * 0.85, 0.75, 1)

            t4[v26] = "<font color=\"" .. string.format("#%02X%02X%02X", math.round(v28.R * 255), math.round(v28.G * 255), (math.round(v28.B * 255))) .. "\">" .. tostring(v27):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;") .. "</font>"
        end
    end

    return "<b>" .. table.concat(t4) .. "</b>"
end

local function vowel(p8) -- line: 102
    return p8:match("^[AEIOUaeiou]") ~= nil
end

local function withRarity(p9, p10) -- line: 107
    -- upvalues: Loc (copy)
    if p9 then
        return Loc.F("fish.with_rarity", "{rarity} {fish}", {
            rarity = Loc.T(p9.display),
            fish = Loc.T(p10)
        })
    end

    return Loc.T(p10)
end

local v34

local function say(p11) -- line: 113
    -- upvalues: TextChatService (copy), v34 (ref)
    local function v35() -- line: 114
        -- upvalues: p11 (copy), TextChatService (copy), v34 (ref)
        v34 = v34 or TextChatService:WaitForChild("TextChannels", 10):WaitForChild("RBXGeneral", 10)
        v34:DisplaySystemMessage(p11)
    end

    if not pcall(v35) then
        print((p11:gsub("<[^>]+>", "")))
    end
end

Remotes:WaitForChild("FishDrop").OnClientEvent:Connect(function(p12, p13, p14) -- line: 123
    -- upvalues: FishDisplay (copy), RarityDisplay (copy), Zones (copy), Loc (copy), t2 (copy), paint (copy), withRarity (copy), say (copy)
    local v36 = type(p13) == "number" and math.max(0, p13 - workspace:GetServerTimeNow()) or 0
    local n1 = 0

    for _, v38 in ipairs(p12) do
        local v39 = FishDisplay[v38.species]

        if v39 and t2[v39.rarity] and (not p14 or v39.rarity == "Secret") then
            n1 += 1

            local v44 = RarityDisplay[v39.shown or v39.rarity]
            local display = v39.display or v38.species
            local v45

            if Zones.NAMES[v38.zone] then
                v45 = Loc.T(Zones.NAMES[v38.zone])

                if not v45 then
                    v45 = Loc.F("zone.n", "Zone {n}", {
                        n = tostring(v38.zone)
                    })
                end
            else
                v45 = Loc.F("zone.n", "Zone {n}", {
                    n = tostring(v38.zone)
                })
            end

            local t10 = {
                what = paint(withRarity(v44, display), v44 and v44.color, v44 and v44.glow),
                zone = "<b>" .. tostring(v45):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;") .. "</b>"
            }

            if v44 then
                display = v44.display or display
            end

            local v47 = "🌊 " .. (display:match("^[AEIOUaeiou]") ~= nil and Loc.F("drop.spawned_an", "An {what} spawned in {zone}!", t10) or Loc.F("drop.spawned_a", "A {what} spawned in {zone}!", t10))

            task.delay(v36 + (n1 - 1) * 0.15, say, v47)
        end
    end
end)

local function catchLine(p15, p16, p17, p18) -- line: 144
    -- upvalues: FishDisplay (copy), RarityDisplay (copy), MutationDisplay (copy), Format (copy), Loc (copy), t3 (copy), paint (copy), rainbow (copy), withRarity (copy)
    local v48 = FishDisplay[p16]
    local v49 = v48 and v48.rarity
    local v50 = p17 and MutationDisplay[p17]

    v49 = v49 and RarityDisplay[v48 and v48.shown or v49]

    local display = v48 and v48.display or p16
    local v52 = withRarity(v49, display)
    local v53, v54

    if v49 then
        v54 = v49.color
        v53 = v49.glow
    else
        v53 = v49
        v54 = v49
    end

    local v55 = paint(v52, v54, v53)
    local display2 = if v49 then v49.display else nil

    if v49 and display2 then
        display = display2
    end

    local v56, v57

    if v50 then
        v57 = v50.prefix or p17

        local v59 = Loc.T(v57)
        local v60

        if v50.cycle then
            v60 = rainbow(v59)

            if not v60 then
                v60 = paint(v59, v50.textColor or v50.color, t3[p17])
            end
        else
            v60 = paint(v59, v50.textColor or v50.color, t3[p17])
        end

        v56 = Loc.F("fish.mutated", "{mutation} {fish}", {
            mutation = v60,
            fish = v55
        })
    else
        v57 = display
        v56 = v55
    end

    if type(p18) == "number" then
        v56 ..= " (" .. tostring((Format.kg(p18))):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;") .. ")"
    end

    local t11 = {
        player = "<b>" .. tostring(p15):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;") .. "</b>",
        what = v56
    }

    return "🎣 " .. (v57:match("^[AEIOUaeiou]") ~= nil and Loc.F("chat.caught_an", "{player} caught an {what}!", t11) or Loc.F("chat.caught_a", "{player} caught a {what}!", t11))
end

Remotes:WaitForChild("CatchAnnounce").OnClientEvent:Connect(function(p19, p20, p21, p22) -- line: 165
    -- upvalues: Players (copy), TextChatService (copy), FishDisplay (copy), WeatherConfig (copy), t1 (copy), v34 (ref), catchLine (copy)
    local v62 = FishDisplay[p20]
    local v63 = v62 and v62.rarity

    if v63 == "Secret"
        or v63 == "Celestial"
        or v63 == "Apex"
        or WeatherConfig.HALLOWEEN.fish[p20] and p21 == "Hallowed"
        or not t1[v63] and p21 ~= "Rainbow"
        or (v63 == "Legendary" or v63 == "Mythic") and p21 ~= "Rainbow" and require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("AdminAbuseConfig")).Finale() then
        return
    end

    local v64 = Players:FindFirstChild(p19)
    local v65 = catchLine(v64 and v64.DisplayName or p19, p20, p21, p22)

    local function v66() -- line: 114
        -- upvalues: v65 (copy), TextChatService (copy), v34 (ref)
        v34 = v34 or TextChatService:WaitForChild("TextChannels", 10):WaitForChild("RBXGeneral", 10)
        v34:DisplaySystemMessage(v65)
    end

    if not pcall(v66) then
        print((v65:gsub("<[^>]+>", "")))
    end
end)

local function tag(p23) -- line: 182
    return "<font color=\"" .. "#FF2828" .. "\" size=\"" .. 18 .. "\"><b>" .. tostring(p23):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;") .. "</b></font>"
end

Remotes:WaitForChild("GlobalAnnounce").OnClientEvent:Connect(function(p24) -- line: 185
    -- upvalues: Players (copy), TextChatService (copy), FishDisplay (copy), RarityDisplay (copy), MutationDisplay (copy), Loc (copy), t3 (copy), paint (copy), rainbow (copy), v34 (ref), catchLine (copy)
    local v67 = type(p24) == "table"
    local v68 = if v67 then type(p24.f) == "string" else nil

    if v67 and v68 and Players.LocalPlayer:GetAttribute("SetGlobalMessages") ~= false then
        local v70 = tostring(p24.p or "?")

        if p24.k == "secret" then
            local v72 = ("<font color=\"" .. "#FF2828" .. "\" size=\"" .. 18 .. "\"><b>" .. tostring((Loc.T("[GLOBAL]"))):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;") .. "</b></font>") .. " " .. catchLine(v70, p24.f, p24.m, p24.w)

            local function v73() -- line: 114
                -- upvalues: v72 (copy), TextChatService (copy), v34 (ref)
                v34 = v34 or TextChatService:WaitForChild("TextChannels", 10):WaitForChild("RBXGeneral", 10)
                v34:DisplaySystemMessage(v72)
            end

            if not pcall(v73) then
                print((v72:gsub("<[^>]+>", "")))
            end
        elseif p24.k == "record" then
            local v74 = FishDisplay[p24.f]
            local v75 = v74 and RarityDisplay[v74.shown or v74.rarity]
            local v76 = Loc.T(v74 and v74.display or p24.f)
            local v77 = v75

            if v75 then
                v77 = v75.color
                v75 = v75.glow
            end

            local v78 = paint(v76, v77, v75)
            local v80 = ("<font color=\"" .. "#FF2828" .. "\" size=\"" .. 18 .. "\"><b>" .. tostring((Loc.T("[WORLD RECORD]"))):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;") .. "</b></font>") .. " " .. Loc.F("chat.world_record", "{player} caught the BIGGEST {fish} in the world!", {
                player = "<b>" .. tostring(v70):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;") .. "</b>",
                fish = v78
            })

            local function v81() -- line: 114
                -- upvalues: v80 (copy), TextChatService (copy), v34 (ref)
                v34 = v34 or TextChatService:WaitForChild("TextChannels", 10):WaitForChild("RBXGeneral", 10)
                v34:DisplaySystemMessage(v80)
            end

            if not pcall(v81) then
                print((v80:gsub("<[^>]+>", "")))
            end
        elseif p24.k == "upgrade" then
            local v82 = FishDisplay[p24.f]
            local v83 = v82 and RarityDisplay[v82.shown or v82.rarity]
            local v84 = Loc.T(v82 and v82.display or p24.f)
            local v85 = v83

            if v83 then
                v85 = v83.color
                v83 = v83.glow
            end

            local v86 = paint(v84, v85, v83)
            local v87 = MutationDisplay[p24.m]
            local T = Loc.T
            local display = if v87 then v87.display else nil

            if not v87 or not display then
                display = tostring(p24.m)
            end

            local v88 = T(display)
            local v89, v90

            if v87 and v87.cycle then
                local v91 = rainbow(v88)

                if v91 then
                    v89 = v91
                    v90 = true
                else
                    v90 = false
                end
            else
                v90 = false
            end

            if not v90 then
                v87 = v87 and (v87.textColor or v87.color)
                v89 = paint(v88, v87, t3[p24.m])
            end

            local v92 = "✨ " .. Loc.F("chat.upgraded", "{player} upgraded their {fish} to {mutation}!", {
                player = "<b>" .. tostring(v70):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;") .. "</b>",
                fish = v86,
                mutation = v89
            })

            local function v93() -- line: 114
                -- upvalues: v92 (copy), TextChatService (copy), v34 (ref)
                v34 = v34 or TextChatService:WaitForChild("TextChannels", 10):WaitForChild("RBXGeneral", 10)
                v34:DisplaySystemMessage(v92)
            end

            if not pcall(v93) then
                print((v92:gsub("<[^>]+>", "")))
            end
        end
    end
end)
Remotes:WaitForChild("GiftNotice").OnClientEvent:Connect(function(p25, p26, p27, p28) -- line: 212
    -- upvalues: TextChatService (copy), Loc (copy), v1 (copy), paint (copy), v34 (ref)
    if p25 ~= "Announce" then
        return
    end

    local v96 = "🎁 " .. Loc.F("chat.gifted", "{from} gifted {to} {gift}!", {
        from = "<b>" .. tostring((tostring(p26))):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;") .. "</b>",
        to = "<b>" .. tostring((tostring(p27))):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;") .. "</b>",
        gift = paint(Loc.T((tostring(p28))), v1)
    })

    local function v97() -- line: 114
        -- upvalues: v96 (copy), TextChatService (copy), v34 (ref)
        v34 = v34 or TextChatService:WaitForChild("TextChannels", 10):WaitForChild("RBXGeneral", 10)
        v34:DisplaySystemMessage(v96)
    end

    if not pcall(v97) then
        print((v96:gsub("<[^>]+>", "")))
    end
end)
task.spawn(function() -- line: 219
    -- upvalues: TextChatService (copy), Zones (copy), Loc (copy), paint (copy), rainbow (copy), v34 (ref)
    local ZoneJackpots = workspace:WaitForChild("ZoneJackpots")

    local function watch(p29) -- line: 221
        -- upvalues: TextChatService (copy), Zones (copy), Loc (copy), paint (copy), rainbow (copy), v34 (ref)
        p29:GetAttributeChangedSignal("OpenAt"):Connect(function() -- line: 222
            -- upvalues: p29 (copy), TextChatService (copy), Zones (copy), Loc (copy), paint (copy), rainbow (copy), v34 (ref)
            local OpenAt = p29:GetAttribute("OpenAt")

            if type(OpenAt) ~= "number" then
                return
            end

            task.delay(math.max(0, OpenAt - workspace:GetServerTimeNow()), function() -- line: 225
                -- upvalues: OpenAt (copy), p29 (copy), TextChatService (copy), Zones (copy), Loc (copy), paint (copy), rainbow (copy), v34 (ref)
                if p29:GetAttribute("OpenAt") == OpenAt and p29:GetAttribute("Live") then
                    local Zone = p29:GetAttribute("Zone")
                    local v99 = Zones.COLORS[Zone]
                    local v100 = string.upper(Loc.T(Zones.NAMES[Zone] or "Zone " .. tostring(Zone)))
                    local F = Loc.F
                    local t13 = {
                        chest = rainbow(Loc.T("TREASURE CHEST"))
                    }
                    local v101 = v99

                    if v99 then
                        v101 = v99[1]
                        v99 = v99[2]
                    end

                    t13.zone = paint(v100, v101, v99)

                    local v102 = "💰 " .. F("jackpot.opened", "{chest} in {zone} has opened!", t13)

                    local function v103() -- line: 114
                        -- upvalues: v102 (copy), TextChatService (copy), v34 (ref)
                        v34 = v34 or TextChatService:WaitForChild("TextChannels", 10):WaitForChild("RBXGeneral", 10)
                        v34:DisplaySystemMessage(v102)
                    end

                    if not pcall(v103) then
                        print((v102:gsub("<[^>]+>", "")))
                    end
                end
            end)
        end)
    end

    for _, child in ipairs(ZoneJackpots:GetChildren()) do
        child:GetAttributeChangedSignal("OpenAt"):Connect(function() -- line: 222
            -- upvalues: child (copy), TextChatService (copy), Zones (copy), Loc (copy), paint (copy), rainbow (copy), v34 (ref)
            local OpenAt = child:GetAttribute("OpenAt")

            if type(OpenAt) ~= "number" then
                return
            end

            task.delay(math.max(0, OpenAt - workspace:GetServerTimeNow()), function() -- line: 225
                -- upvalues: child (copy), TextChatService (copy), Zones (copy), Loc (copy), paint (copy), rainbow (copy), v34 (ref), OpenAt (copy)
                if child:GetAttribute("OpenAt") == OpenAt and child:GetAttribute("Live") then
                    local Zone = child:GetAttribute("Zone")
                    local v106 = Zones.COLORS[Zone]
                    local v107 = string.upper(Loc.T(Zones.NAMES[Zone] or "Zone " .. tostring(Zone)))
                    local F = Loc.F
                    local t14 = {
                        chest = rainbow(Loc.T("TREASURE CHEST"))
                    }
                    local v108 = v106

                    if v106 then
                        v108 = v106[1]
                        v106 = v106[2]
                    end

                    t14.zone = paint(v107, v108, v106)

                    local v109 = "💰 " .. F("jackpot.opened", "{chest} in {zone} has opened!", t14)

                    local function v110() -- line: 114
                        -- upvalues: TextChatService (copy), v34 (ref), v109 (copy)
                        v34 = v34 or TextChatService:WaitForChild("TextChannels", 10):WaitForChild("RBXGeneral", 10)
                        v34:DisplaySystemMessage(v109)
                    end

                    if not pcall(v110) then
                        print((v109:gsub("<[^>]+>", "")))
                    end
                end
            end)
        end)
    end

    ZoneJackpots.ChildAdded:Connect(watch)
end)

local v112 = workspace:GetAttribute("ServerLuckEnd") or 0

workspace:GetAttributeChangedSignal("ServerLuckEnd"):Connect(function() -- line: 241
    -- upvalues: TextChatService (copy), Loc (copy), v2 (copy), paint (copy), v34 (ref), v112 (ref)
    local ServerTimeNow = workspace:GetServerTimeNow()
    local v113 = workspace:GetAttribute("ServerLuckEnd") or 0
    local v114 = ServerTimeNow < v112
    local v116 = v113 - math.max(v112, ServerTimeNow)

    v112 = v113

    if v116 < 30 then
        return
    end

    local ServerLuckBy = workspace:GetAttribute("ServerLuckBy")
    local t15 = {
        player = "<b>" .. tostring(ServerLuckBy and tostring(ServerLuckBy) or Loc.T("Someone")):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;") .. "</b>",
        luck = paint(Loc.T("X3 SERVER SPAWN LUCK"), v2),
        n = tostring((math.floor(v116 / 60 + 0.5)))
    }

    if v114 then
        local v120 = "🍀 " .. Loc.F("chat.luck_added", "{player} added {n} minutes of {luck}! Rarer fish keep spawning!", t15)

        local function v121() -- line: 114
            -- upvalues: v120 (copy), TextChatService (copy), v34 (ref)
            v34 = v34 or TextChatService:WaitForChild("TextChannels", 10):WaitForChild("RBXGeneral", 10)
            v34:DisplaySystemMessage(v120)
        end

        if not pcall(v121) then
            print((v120:gsub("<[^>]+>", "")))
        end
    else
        local v122 = "🍀 " .. Loc.F("chat.luck_started", "{player} activated {luck} for everyone! Rarer fish spawn for {n} minutes!", t15)

        local function v123() -- line: 114
            -- upvalues: v122 (copy), TextChatService (copy), v34 (ref)
            v34 = v34 or TextChatService:WaitForChild("TextChannels", 10):WaitForChild("RBXGeneral", 10)
            v34:DisplaySystemMessage(v122)
        end

        if not pcall(v123) then
            print((v122:gsub("<[^>]+>", "")))
        end
    end
end)
