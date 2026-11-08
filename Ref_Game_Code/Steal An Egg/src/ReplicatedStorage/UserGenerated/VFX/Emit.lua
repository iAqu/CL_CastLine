-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local EmitOnce = require(game.ReplicatedStorage.UserGenerated.VFX.EmitOnce)

local function Emit(p1) -- line: 22
    -- upvalues: EmitOnce (copy), Emit (copy)
    local v1 = if p1:IsA("ParticleEmitter") then math.max(0, EmitOnce(p1)) else 0

    for _, child in ipairs(p1:GetChildren()) do
        v1 = math.max(v1, Emit(child))
    end

    return v1
end

return Emit
