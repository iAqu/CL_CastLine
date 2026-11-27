-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CurrentCamera = workspace.CurrentCamera
local CameraShaker = require(script:WaitForChild("CameraShaker"))
local v1 = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(p1) -- line: 7
    -- upvalues: CurrentCamera (copy)
    if CurrentCamera.CameraType ~= Enum.CameraType.Scriptable then
        CurrentCamera.CFrame *= p1
    end
end)

v1:Start()

return function(p2) -- line: 13
    -- upvalues: CameraShaker (copy), v1 (copy)
    v1:Shake(CameraShaker.Presets[p2])
end
