-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Promise = require(ReplicatedStorage.Packages.Promise)
local Rarity = require(ReplicatedStorage.Data.Rarity)
local Translations = require(script.Translations)
local en = Translations.en
local v1 = Promise.try(function() -- line: 20
    -- upvalues: LocalizationService (copy), Players (copy)
    return LocalizationService:GetTranslatorForPlayerAsync(Players.LocalPlayer)
end):catch(function() -- line: 22
    return nil
end)
local t1 = {}

local function Escape(p1) -- line: 28
    local v2 = string.gsub(p1, "&", "&amp;")
    local v3 = string.gsub(v2, "<", "&lt;")

    return (string.gsub(v3, ">", "&gt;"))
end

local function TranslateName(p2, p3) -- line: 35
    -- upvalues: Rarity (copy)
    local v4 = p3(p2)

    if v4 ~= p2 then
        return v4
    end

    for _, v5 in Rarity.Rarities do
        local v6 = v5.DisplayName .. " "

        if string.sub(p2, 1, #v6) == v6 then
            return p3(v5.DisplayName) .. " " .. p3((string.sub(p2, #v6 + 1)))
        end
    end

    return p2
end

local function TranslateSpan(p4, p5) -- line: 51
    -- upvalues: TranslateName (copy)
    return (string.gsub(p4, "(<font color=\"#%x+\">.-</font>)", function(p6) -- line: 55
        -- upvalues: p5 (copy), TranslateName (copy)
        local v10, v11 = string.match(p6, "^(<font color=\"#%x+\">)(.-)</font>$")

        assert(v10 and v11)

        local v13 = TranslateName(v11, p5)
        local v14 = string.gsub(v13, "&", "&amp;")
        local v15 = string.gsub(v14, "<", "&lt;")

        return v10 .. string.gsub(v15, ">", "&gt;") .. "</font>"
    end))
end

function t1.Parse(p7) -- line: 67
    local v16, v17, v18 = string.match(p7, "^A (.+) spawned in (<font color=\"#%x+\">.-</font>)(.-)!$")

    return if v16 ~= nil and v17 ~= nil and v18 ~= nil then {
        Egg = v16,
        Area = v17,
        Emoji = v18
    } else nil
end

function t1.Render(p8, p9, p10) -- line: 78
    -- upvalues: Translations (copy), en (copy), TranslateName (copy)
    local v19 = p10(en)
    local v20, v21

    if v19 == en then
        v21 = false
    elseif string.find(v19, "{Egg}", 1, true) and string.find(v19, "{Area}", 1, true) and string.find(v19, "{Emoji}", 1, true) then
        v20 = v19
        v21 = true
    else
        v21 = false
    end

    if not v21 then
        local v22 = string.lower(p9)
        local v23 = string.match(v22, "^[^-]+")
        local v24 = Translations[v22]
        local v25, v26

        if v24 then
            v25 = v24
            v26 = true
        elseif v23 then
            local v27 = Translations[v23]

            if v27 then
                v25 = v27
                v26 = true
            else
                v26 = false
            end
        else
            v26 = false
        end

        if not v26 then
            v25 = en
        end

        v20 = v25
    end

    local Egg = p8.Egg
    local t2 = {}

    t2.Egg = string.gsub(Egg, "(<font color=\"#%x+\">.-</font>)", function(p11) -- line: 55
        -- upvalues: p10 (copy), TranslateName (copy)
        local v28, v29 = string.match(p11, "^(<font color=\"#%x+\">)(.-)</font>$")

        assert(v28 and v29)

        local v31 = TranslateName(v29, p10)
        local v32 = string.gsub(v31, "&", "&amp;")
        local v33 = string.gsub(v32, "<", "&lt;")

        return v28 .. string.gsub(v33, ">", "&gt;") .. "</font>"
    end)

    local Area = p8.Area

    t2.Area = string.gsub(Area, "(<font color=\"#%x+\">.-</font>)", function(p12) -- line: 55
        -- upvalues: p10 (copy), TranslateName (copy)
        local v34, v35 = string.match(p12, "^(<font color=\"#%x+\">)(.-)</font>$")

        assert(v34 and v35)

        local v37 = TranslateName(v35, p10)
        local v38 = string.gsub(v37, "&", "&amp;")
        local v39 = string.gsub(v38, "<", "&lt;")

        return v34 .. string.gsub(v39, ">", "&gt;") .. "</font>"
    end)

    local Emoji = p8.Emoji
    local v40 = string.gsub(Emoji, "&", "&amp;")
    local v41 = string.gsub(v40, "<", "&lt;")

    t2.Emoji = string.gsub(v41, ">", "&gt;")

    return (string.gsub(v20, "{(%w+)}", t2))
end

function t1.Localize(p13, p14, p15) -- line: 104
    -- upvalues: LocalizationService (copy), v1 (copy), t1 (copy)
    local v42 = true

    v1:andThen(function(p16) -- line: 110
        -- upvalues: p13 (copy), p14 (copy), p15 (copy), v42 (ref), LocalizationService (copy), t1 (copy)
        if not v42 then
            return
        end

        local v43 = if p16 then p16.LocaleId else LocalizationService.RobloxLocaleId

        local function translate(p17) -- line: 117
            -- upvalues: p16 (copy), p14 (copy)
            if p16 == nil then
                return p17
            end

            local Translate = p16.Translate
            local ok, result = pcall(Translate, p16, p14, p17)

            if ok then
                return result
            end

            return p17
        end

        p15(t1.Render(p13, v43, translate))
    end)

    return function() -- line: 127
        -- upvalues: v42 (ref)
        v42 = false
    end
end

return table.freeze(t1)
