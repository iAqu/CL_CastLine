-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local useEffect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react").useEffect
local Workspace = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace
local startAutoRotatingMeshParts = RuntimeLib.import(script, script.Parent, "auto-rotate-meshparts").startAutoRotatingMeshParts

return {
    default = function() -- AutoRotateMeshPartsManager | line: 7
        -- upvalues: useEffect (copy), Workspace (copy), startAutoRotatingMeshParts (copy)
        useEffect(function() -- line: 8
            -- upvalues: Workspace (copy), startAutoRotatingMeshParts (copy)
            return startAutoRotatingMeshParts(Workspace)
        end, {})

        return nil
    end
}
