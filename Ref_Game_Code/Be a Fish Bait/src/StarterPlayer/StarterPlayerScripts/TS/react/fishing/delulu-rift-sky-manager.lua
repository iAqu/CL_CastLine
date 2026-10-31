-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Lighting, ReplicatedStorage = services.Lighting, services.ReplicatedStorage
local deluluRiftSkyAtom = RuntimeLib.import(script, script.Parent.Parent.Parent, "delulu-rift-sky-atom").deluluRiftSkyAtom

local function getDeluluRiftSky() -- line: 11
    -- upvalues: ReplicatedStorage (copy)
    local Weathers = ReplicatedStorage:FindFirstChild("Weathers")

    if Weathers ~= nil then
        Weathers = Weathers:FindFirstChild("Delulu")
    end

    if Weathers ~= nil then
        Weathers = Weathers:FindFirstChild("DeluluDimensionSky")
    end

    return if if Weathers == nil then Weathers else Weathers:IsA("Sky") then Weathers else nil
end

return {
    default = function() -- DeluluRiftSkyManager | line: 29
        -- upvalues: useEffect (copy), useState (copy), subscribe (copy), Lighting (copy), deluluRiftSkyAtom (copy), getDeluluRiftSky (copy)
        local v1, v2 = useState(deluluRiftSkyAtom())

        useEffect(function() -- line: 31
            -- upvalues: v2 (copy), subscribe (copy), deluluRiftSkyAtom (copy)
            return subscribe(deluluRiftSkyAtom, function(p1) -- line: 32
                -- upvalues: v2 (copy)
                return v2(p1)
            end)
        end, {})
        useEffect(function() -- line: 36
            -- upvalues: v1 (copy), Lighting (copy), getDeluluRiftSky (copy)
            if not v1 then
                return nil
            end

            local v3 = getDeluluRiftSky()

            if v3 == nil then
                warn("[DeluluRiftSkyManager] ReplicatedStorage.Weathers.Delulu.DeluluDimensionSky not found or not a Sky")

                return nil
            end

            local Children = Lighting:GetChildren()
            local t1 = {}
            local n1 = 0

            for v4, v5 in Children do
                local _ = v4 - 1

                if (v5:IsA("Sky") and v5 ~= v3) == true then
                    n1 += 1
                    t1[n1] = v5
                end
            end

            for _, v6 in t1 do
                v6.Parent = nil
            end

            local clone = v3:Clone()

            if clone then
                clone.Parent = Lighting
            else
                warn("[DeluluRiftSkyManager] DeluluDimensionSky.Clone() returned undefined — Archivable is likely false")
            end

            return function() -- line: 74
                -- upvalues: t1 (copy), clone (copy), Lighting (copy)
                if clone ~= nil then
                    clone:Destroy()
                end

                for _, v7 in t1 do
                    local function v8() -- line: 83
                        -- upvalues: v7 (copy), Lighting (copy)
                        v7.Parent = Lighting

                        return v7.Parent
                    end

                    pcall(v8)
                end
            end
        end, { v1 })

        return nil
    end
}
