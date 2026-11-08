-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local EggActionMovement = require(script.Parent.EggActionMovement)
local EggRenderer = require(script.Parent.EggRenderer)
local t = require(ReplicatedStorage.Packages.t)
local SkipEggEffect = ReplicatedStorage.Assets.Particles["Egg Open"].SkipEggEffect

return {
    Play = function(p1) -- Play | line: 24
        -- upvalues: Debris (copy), RunService (copy), TweenService (copy), EggActionMovement (copy), EggRenderer (copy), t (copy), SkipEggEffect (copy)
        t.strict(t.instanceIsA("Model"))(p1)
        EggRenderer.DisableCollisions(p1)

        local Pivot = p1:GetPivot()
        local clone = SkipEggEffect.Attachment:Clone()

        clone.Parent = workspace.Terrain

        for _, descendant in clone:GetDescendants() do
            descendant.Enabled = true
        end

        clone.WorldCFrame = Pivot * CFrame.Angles(0, 0, 3.141592653589793)

        local n1 = 0

        while n1 < 1.2 do
            n1 += RunService.Heartbeat:Wait()

            local Value = TweenService:GetValue(n1 / 1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

            EggActionMovement.SetPivot(p1, Pivot * CFrame.Angles(0, math.rad(Value * 1080), 0) * CFrame.Angles(0, 0, (math.rad(math.sin(1080 * Value) * 35 * (1 - Value)))))
        end

        for _, descendant in clone:GetDescendants() do
            descendant.Enabled = false
        end

        Debris:AddItem(clone, 5)
    end
}
