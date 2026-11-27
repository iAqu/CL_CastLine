-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")
local VFXBurst = require(ReplicatedStorage.Modules:WaitForChild("VFXBurst"))
local WallHit = ReplicatedStorage:WaitForChild("VFX"):WaitForChild("WallHit")
local t1 = {}
local v1 = RaycastParams.new()

v1.FilterType = Enum.RaycastFilterType.Exclude
v1.IgnoreWater = true
task.spawn(function() -- line: 22
    -- upvalues: ContentProvider (copy), VFXBurst (copy), WallHit (copy)
    ContentProvider:PreloadAsync(VFXBurst.Emitters(WallHit))
end)

function t1.Play(p1, p2) -- line: 27
    -- upvalues: Players (copy), VFXBurst (copy), WallHit (copy), v1 (copy)
    local t2 = {}

    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            t2[#t2 + 1] = player.Character
        end
    end

    local Plots = workspace:FindFirstChild("Plots")

    if Plots then
        for _, child in ipairs(Plots:GetChildren()) do
            local Harpoon = child:FindFirstChild("Harpoon")
            local Floaty = child:FindFirstChild("Floaty")

            if Harpoon then
                t2[#t2 + 1] = Harpoon
            end

            if Floaty then
                t2[#t2 + 1] = Floaty
            end
        end
    end

    v1.FilterDescendantsInstances = t2

    local v2 = workspace:Raycast(p1 - p2 * 2, p2 * 4, v1)

    if v2 then
        local Fish = workspace:FindFirstChild("Fish")

        if not (Fish and v2.Instance:IsDescendantOf(Fish)) then
            local Normal = v2.Normal
            local v3 = Normal:Cross((Vector3.new(0, 0, 1)))

            if v3.Magnitude < 0.001 then
                v3 = Normal:Cross((Vector3.new(1, 0, 0)))
            end

            VFXBurst.Play(WallHit, CFrame.fromMatrix(v2.Position, v3.Unit, Normal))
        end
    end
end

return t1
