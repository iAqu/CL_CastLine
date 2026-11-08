-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

require(script.Parent.Parent.MountController)

local MountRace = require(ReplicatedStorage.Data.MountRace)
local PowerUpVisuals = require(script.Parent.Parent.PowerUpVisuals)

require(script.Parent.Parent.RaceCamera)

local RacePowerUps = require(ReplicatedStorage.Data.RacePowerUps)
local Remotes = require(ReplicatedStorage.Shared.Remotes)

require(ReplicatedStorage.Packages.Trove)

local LocalPlayer = Players.LocalPlayer
local Attributes = RacePowerUps.Attributes

return {
    Bind = function(p1, p2, p3, p4) -- Bind | line: 29
        -- upvalues: RunService (copy), TweenService (copy), Workspace (copy), MountRace (copy), PowerUpVisuals (copy), RacePowerUps (copy), Remotes (copy), LocalPlayer (copy), Attributes (copy)
        local Pad = p2:FindFirstChild("Pad")

        assert(Pad ~= nil and Pad:IsA("BasePart"), (("%* needs a Pad part"):format((p2:GetFullName()))))

        local Folder = p2:FindFirstAncestorWhichIsA("Folder")

        while Folder ~= nil and Folder.Parent ~= Workspace do
            Folder = Folder:FindFirstAncestorWhichIsA("Folder")
        end

        local v3 = MountRace.HeatOf(LocalPlayer)
        local v4 = Folder == nil
        local t2 = {}

        t2[1] = if v4 or v3 ~= nil then nil else Folder

        local v5 = RacePowerUps.BoxAttribute(v3)

        if Folder ~= nil and v3 ~= nil then
            p1:Add(task.spawn(function() -- line: 45
                -- upvalues: Folder (ref), v3 (copy), t2 (copy), MountRace (copy)
                t2[1] = MountRace.StateOf(Folder, v3)
            end))
        end

        local v6 = p1:Add(RacePowerUps.Assets.Models.Cube:Clone())
        local PrimaryPart = v6.PrimaryPart
        local Inner = v6:FindFirstChild("Inner")
        local PointLight = PrimaryPart:FindFirstChildOfClass("PointLight")
        local t3 = {}

        for _, child in PrimaryPart:GetChildren() do
            if child:IsA("Decal") then
                table.insert(t3, child)
            end
        end

        local Scale = v6:GetScale()

        v6.Parent = Workspace

        local v7 = (Pad.Position.X + Pad.Position.Z) * 0.05
        local n1 = 0
        local n2 = (-1e999)
        local v8 = false
        local v9 = true
        local HitboxPosition

        local function crossed(p5) -- line: 68
            -- upvalues: Pad (copy), HitboxPosition (ref), MountRace (copy)
            if MountRace.IsInsidePart(Pad, p5, (Vector3.new(4.5, 4, 4.5))) then
                return true
            end

            local HitboxPosition2 = HitboxPosition

            if HitboxPosition2 ~= nil then
                local Magnitude = (p5 - HitboxPosition2).Magnitude

                if not (Magnitude <= 2 or Magnitude > 60) then
                    local v11 = math.ceil(Magnitude / 2)

                    for i = 1, v11 - 1 do
                        if MountRace.IsInsidePart(Pad, HitboxPosition2:Lerp(p5, i / v11), (Vector3.new(4.5, 4, 4.5))) then
                            return true
                        end
                    end
                end
            end

            return false
        end

        local function setVisible(p6) -- line: 89
            -- upvalues: PrimaryPart (copy), Inner (copy), PointLight (copy), t3 (copy), n1 (ref), v9 (ref)
            if p6 == v9 then
                return
            end

            v9 = p6
            PrimaryPart.Transparency = p6 and 0.3 or 1
            Inner.Transparency = p6 and 0.35 or 1
            PointLight.Enabled = p6

            for _, v13 in t3 do
                v13.Transparency = p6 and 0 or 1
            end

            for _, child in PrimaryPart:GetChildren() do
                if child:IsA("ParticleEmitter") then
                    child.Enabled = p6
                end
            end

            if p6 then
                n1 = os.clock()
            end
        end

        p1:Connect(RunService.RenderStepped, function() -- line: 111
            -- upvalues: p2 (copy), p3 (copy), p4 (copy), Pad (copy), t2 (copy), v5 (copy), v6 (copy), PrimaryPart (copy), Inner (copy), PointLight (copy), t3 (copy), Scale (copy), v7 (copy), n1 (ref), n2 (ref), v8 (ref), v9 (ref), HitboxPosition (ref), crossed (copy), setVisible (copy), TweenService (copy), Workspace (copy), MountRace (copy), PowerUpVisuals (copy), Remotes (copy), LocalPlayer (copy), Attributes (copy)
            local v14 = t2[1] ~= nil and t2[1]:GetAttribute(Attributes.Enabled) == true
            local Attribute = p2:GetAttribute(v5)
            local v15 = v14 and (type(Attribute) ~= "number" or Attribute <= Workspace:GetServerTimeNow()) and os.clock() - n2 > 0.6
            local HitboxPosition2 = p3.Rig.Mount.Hitbox.Position
            local v17 = (HitboxPosition2 - Pad.Position).Magnitude < 320

            setVisible(v15 and v17)

            if not v9 then
                v8 = false
                HitboxPosition = HitboxPosition2

                return
            end

            local elapsed = os.clock()
            local v18 = (elapsed * 0.18 + v7) % 1

            PrimaryPart.Color = Color3.fromHSV(v18, 0.7, 1)
            Inner.Color = Color3.fromHSV((v18 + 0.5) % 1, 0.25, 1)
            PointLight.Color = PrimaryPart.Color

            for _, v19 in t3 do
                v19.Color3 = Color3.fromHSV((v18 + 0.08) % 1, 0.15, 1)
            end

            v6:ScaleTo((math.max(Scale * TweenService:GetValue(math.min((elapsed - n1) / 0.45, 1), Enum.EasingStyle.Back, Enum.EasingDirection.Out) * (math.sin(elapsed * 5 + v7) * 0.04 + 1), 0.01)))

            local UpVector = Pad.CFrame.UpVector

            v6:PivotTo(CFrame.new(Pad.Position + UpVector * (math.sin(elapsed * 2.6 + v7) * 0.5 + 4.2)) * CFrame.Angles(0.35, elapsed * 1.4 + v7, 0.35))

            local v26 = crossed(HitboxPosition2)

            HitboxPosition = HitboxPosition2

            if v26 and not v8 and LocalPlayer:GetAttribute(MountRace.PlayerAttributes.RaceId) ~= nil then
                n2 = os.clock()
                setVisible(false)
                PowerUpVisuals.Emit(Workspace, "Shatter", PrimaryPart.CFrame, 0.8)
                PowerUpVisuals.Sound("Pickup", nil)
                p4:PunchFov(8)
                p4:Shake(0.8)
                Remotes.MountRace.PowerUp:FireServer("Pickup", p2)
            end

            v8 = v26
        end)
    end
}
