-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local VFX = require(ReplicatedStorage.Shared.Utils.VFX)

return {
    Start = function() -- Start | line: 12
        -- upvalues: ReplicatedStorage (copy), Remotes (copy), VFX (copy)
        local GravityDisruptorVFX = ReplicatedStorage.Assets.Particles.GravityDisruptorVFX

        local function collectEmitters(p1) -- line: 17
            local t2 = {}

            for _, descendant in p1:GetDescendants() do
                if descendant:IsA("ParticleEmitter") then
                    table.insert(t2, descendant)
                end
            end

            return t2
        end

        local function onBurst(p2, p3) -- line: 27
            -- upvalues: GravityDisruptorVFX (copy), collectEmitters (copy), VFX (copy)
            if p3 == "FadeIn" or p3 == "FadeOut" then
                local v1 = GravityDisruptorVFX:FindFirstChild(p3)

                if v1 then
                    VFX.EmitAt(CFrame.new(p2), (collectEmitters(v1)))
                end
            end
        end

        Remotes.GravityDisruptor.Burst.OnClientEvent:Connect(onBurst)
    end
}
