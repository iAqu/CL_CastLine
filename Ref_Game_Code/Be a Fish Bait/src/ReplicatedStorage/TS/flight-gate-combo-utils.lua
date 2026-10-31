-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local flightGateFXConfig = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "TS", "flight-gate-fx-config").flightGateFXConfig

local function getFlightGateComboTier(p1) -- line: 4
    -- upvalues: flightGateFXConfig (copy)
    if flightGateFXConfig.combo.tierThreeCombo <= p1 then
        return 3
    end

    if flightGateFXConfig.combo.tierTwoCombo <= p1 then
        return 2
    end

    return 1
end

local function sampleFlightGateGradient(p2, p3) -- line: 13
    local Keypoints = p2.Keypoints

    if #Keypoints == 0 then
        return Color3.fromRGB(255, 255, 255)
    end

    if p3 <= Keypoints[1].Time then
        return Keypoints[1].Value
    end

    for i = 1, #Keypoints - 1 do
        local v1 = Keypoints[i]
        local v2 = Keypoints[i + 1]

        if p3 <= v2.Time then
            local v3 = v2.Time - v1.Time

            return v1.Value:Lerp(v2.Value, if v3 > 0 then (p3 - v1.Time) / v3 else 1)
        end
    end

    return Keypoints[#Keypoints].Value
end

return {
    getFlightGateComboTier = getFlightGateComboTier,
    sampleFlightGateGradient = sampleFlightGateGradient,
    lerpFlightGateGradient = function(p4, p5, p6) -- lerpFlightGateGradient | line: 32
        -- upvalues: sampleFlightGateGradient (copy)
        local v4 = math.clamp(p6, 0, 1)
        local t1 = {}

        for i = 0, 8 do
            local v5 = i / 8

            table.insert(t1, (ColorSequenceKeypoint.new(v5, sampleFlightGateGradient(p4, v5):Lerp(sampleFlightGateGradient(p5, v5), v4))))
        end

        return ColorSequence.new(t1)
    end
}
