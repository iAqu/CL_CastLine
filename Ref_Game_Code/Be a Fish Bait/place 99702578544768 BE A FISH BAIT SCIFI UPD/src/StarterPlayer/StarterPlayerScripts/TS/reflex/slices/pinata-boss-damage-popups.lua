-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local HttpService, Workspace = services.HttpService, services.Workspace
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils")
local push, filterOriginal, produceWrapper = v1.push, v1.filterOriginal, v1.produceWrapper

return {
    pinataBossDamagePopupsSlice = createProducer({
        pending = {}
    }, {
        pinataBossDamagePopupAdded = produceWrapper(function(p1, p2) -- line: 15
            -- upvalues: HttpService (copy), Workspace (copy), push (copy)
            push(p1.pending, {
                damage = p2.damage,
                position = p2.position,
                id = HttpService:GenerateGUID(false),
                timestamp = Workspace:GetServerTimeNow()
            })
        end),
        pinataBossDamagePopupRemoved = produceWrapper(function(p3, p4) -- line: 23
            -- upvalues: filterOriginal (copy)
            p3.pending = filterOriginal(p3.pending, function(p5) -- line: 24
                -- upvalues: p4 (copy)
                return p5.id ~= p4.id
            end)
        end)
    })
}
