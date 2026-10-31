-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TweenService = game:GetService("TweenService")
local CollectionService = game:GetService("CollectionService")

for _, v1 in ipairs(CollectionService:GetTagged("AnimatedWater")) do
    local v3 = math.clamp(30 - v1.WaterSpeed.Value, 0.9, 30)
    local t1 = {}

    if v1.MoveDirectionX.Value then
        t1.OffsetStudsU = 100
    end

    if v1.MoveDirectionZ.Value then
        t1.OffsetStudsV = 100
    end

    TweenService:Create(v1, TweenInfo.new(v3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), t1):Play()
end
