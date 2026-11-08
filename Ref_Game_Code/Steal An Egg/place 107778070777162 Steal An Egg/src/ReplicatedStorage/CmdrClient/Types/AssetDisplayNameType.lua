-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = require(ReplicatedStorage.Data.Assets)
local t1 = {}

for v1 in Assets.Directory do
    table.insert(t1, v1)
end

table.sort(t1)

local t2 = {}
local t3 = {}

for _, v2 in t1 do
    local DisplayName = Assets.Directory[v2].DisplayName

    if type(DisplayName) == "string" and DisplayName ~= "" and t3[DisplayName] == nil then
        t3[DisplayName] = v2
        table.insert(t2, DisplayName)
    end
end

for _, _ in t1 do
end

table.sort(t2)

return function(p1) -- line: 37
    -- upvalues: t2 (copy), t3 (copy)
    local v3 = p1.Cmdr.Util.MakeEnumType("AssetDisplayName", t2)

    p1:RegisterType("assetDisplayName", {
        Validate = v3.Validate,
        Autocomplete = v3.Autocomplete,
        Parse = function(p2) -- Parse | line: 42
            -- upvalues: v3 (copy), t3 (copy)
            return t3[v3.Parse(p2)]
        end
    })
end
