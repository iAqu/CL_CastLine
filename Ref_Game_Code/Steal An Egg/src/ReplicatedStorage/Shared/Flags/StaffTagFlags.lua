-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags)
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts)

local function assertRoles(p1) -- line: 8
    assert(type(p1) == "table")

    for v2, v3 in p1 do
        assert(type(v2) == "string" and tonumber(v2) and tonumber(v2) % 1 == 0)
        assert(v3 == "Owner" or v3 == "Admin" or v3 == "Developer")
    end

    return p1
end

local t1 = {
    Enabled = FastFlags.Replicated("Game.Staff.TagsEnabled", Asserts.Boolean, true),
    Roles = FastFlags.Replicated("Game.Staff.TagRoles", assertRoles, {
        ["3889785873"] = "Admin",
        ["10751598093"] = "Owner",
        ["2735356267"] = "Owner",
        ["4613024122"] = "Owner",
        ["1927880506"] = "Owner",
        ["2790707588"] = "Owner",
        ["89659291"] = "Developer",
        ["82806501"] = "Developer",
        ["14277028"] = "Developer",
        ["37474696"] = "Developer",
        ["23370881"] = "Developer",
        ["23522478"] = "Developer",
        ["25451922"] = "Developer"
    })
}
local BindableEvent = Instance.new("BindableEvent")

t1.Enabled.Changed:Connect(function() -- line: 40
    -- upvalues: BindableEvent (copy)
    BindableEvent:Fire()
end)
t1.Roles.Changed:Connect(function() -- line: 44
    -- upvalues: BindableEvent (copy)
    BindableEvent:Fire()
end)
t1.Changed = BindableEvent.Event

return table.freeze(t1)
