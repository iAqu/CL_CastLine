-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameConfig = require(ReplicatedStorage.Config.GameConfig)
local POVTest = GameConfig.POVTest
local t1 = {}

local function byKey(p1) -- line: 25
    -- upvalues: POVTest (copy)
    if type(p1) ~= "string" then
        return nil
    end

    for _, v1 in ipairs(POVTest.Variants) do
        if v1.Key == p1 then
            return v1
        end
    end

    return nil
end

function t1.Pick() -- line: 33
    -- upvalues: RunService (copy), POVTest (copy)
    if POVTest.Enabled then
        local v2 = RunService:IsStudio()
        local v3

        if v2 then
            local StudioForce = POVTest.StudioForce

            if type(StudioForce) == "string" then
                local v4 = false

                for _, v5 in ipairs(POVTest.Variants) do
                    if v5.Key == StudioForce then
                        v3 = v5
                        v4 = true
                        break
                    end
                end

                if not v4 then
                    v3 = nil
                end
            end
        end

        if not v2 or not v3 then
            v3 = nil
        end

        if not v3 then
            local n1 = 0

            for _, v6 in ipairs(POVTest.Variants) do
                n1 += v6.Weight
            end

            local v7 = Random.new():NextNumber() * n1

            for _, v8 in ipairs(POVTest.Variants) do
                v7 -= v8.Weight

                if v7 < 0 then
                    v3 = v8
                    break
                end
            end

            v3 = v3 or POVTest.Variants[1]
        end

        workspace:SetAttribute("POVTest", v3.Key)

        return v3
    end

    workspace:SetAttribute("POVTest", nil)

    return nil
end

function t1.Current() -- line: 56
    -- upvalues: POVTest (copy)
    if not POVTest.Enabled then
        return nil
    end

    local POVTest2 = workspace:GetAttribute("POVTest")

    if type(POVTest2) == "string" then
        for _, v9 in ipairs(POVTest.Variants) do
            if v9.Key == POVTest2 then
                return v9
            end
        end
    end

    return nil
end

function t1.Duration() -- line: 61
    -- upvalues: GameConfig (copy), t1 (copy)
    local v10 = t1.Current()

    return v10 and v10.Duration or GameConfig.Sequence.POVDuration
end

function t1.GroupName() -- line: 66
    -- upvalues: t1 (copy)
    local v11 = t1.Current()

    return v11 and v11.Name or nil
end

return t1
