-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local produceWrapper = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils").produceWrapper

return {
    pinataBossSlice = createProducer({
        currentPosition = Vector3.new(0, 0, 0),
        despawnTimestamp = 0,
        difficulty = "Basic",
        hp = 0,
        isActive = false,
        maxHp = 0,
        moveSpeed = 0,
        moveStartTime = 0,
        spawnOrigin = Vector3.new(0, 0, 0),
        targetPosition = Vector3.new(0, 0, 0),
        damageContributions = {}
    }, {
        pinataBossSpawned = produceWrapper(function(p1, p2) -- line: 19
            p1.isActive = true
            p1.hp = p2.maxHp
            p1.maxHp = p2.maxHp
            p1.currentPosition = p2.position
            p1.targetPosition = p2.position
            p1.spawnOrigin = p2.position
            p1.moveStartTime = p2.timestamp
            p1.moveSpeed = p2.moveSpeed
            p1.despawnTimestamp = p2.despawnTimestamp
            p1.difficulty = p2.difficulty
            p1.damageContributions = {}
        end),
        pinataBossMoveTargetUpdated = produceWrapper(function(p3, p4) -- line: 32
            p3.currentPosition = p4.currentPosition
            p3.targetPosition = p4.targetPosition
            p3.moveStartTime = p4.timestamp
            p3.moveSpeed = p4.moveSpeed
        end),
        pinataBossHpChanged = produceWrapper(function(p5, p6) -- line: 38
            p5.hp = p6.hp

            local v1 = p5.damageContributions[p6.userId]

            if v1 == nil then
                v1 = 0
            end

            p5.damageContributions[p6.userId] = v1 + p6.damageDealt
        end),
        pinataBossDespawned = produceWrapper(function(p7, _) -- line: 52
            p7.isActive = false
        end)
    })
}
