-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local Shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local GameConfig = require(Shared.GameConfig)
local Zones = require(Shared.Data.Zones)
local DataClient = require(script.Parent.DataClient)
local t1 = {}
local fromRGB, new, new2 = Color3.fromRGB, NumberSequence.new, NumberSequenceKeypoint.new

local function puff(p1) -- line: 21
    -- upvalues: new (copy), new2 (copy)
    return new({
        new2(0, 1),
        new2(0.2, p1),
        new2(0.75, p1),
        new2(1, 1)
    })
end

local function grow(p2, p3) -- line: 24
    -- upvalues: new (copy), new2 (copy)
    return new({
        new2(0, p2),
        new2(1, p3)
    })
end

local t2 = {
    shallows = {
        fx = {
            {
                Texture = "rbxasset://textures/particles/sparkles_main.dds",
                Rate = 10,
                dir = "drift",
                LightEmission = 1,
                Color = fromRGB(255, 255, 235),
                Lifetime = { 3, 5 },
                Speed = { 0.5, 1.5 },
                Size = new({
                    new2(0, 0.25),
                    new2(1, 0)
                }),
                Transparency = puff(0.3)
            }
        }
    },
    coral_reef = {
        fx = {
            {
                Texture = "rbxasset://textures/particles/sparkles_main.dds",
                Rate = 14,
                dir = "down",
                Acceleration = Vector3.new(1.5, 2.5, 0),
                Color = fromRGB(255, 170, 215),
                Lifetime = { 4, 6 },
                Speed = { 1, 2.5 },
                Size = new(0.3),
                Transparency = puff(0.25),
                RotSpeed = { -90, 90 }
            }
        }
    },
    deep_sea = {
        fog = {
            fromRGB(70, 110, 170),
            1500
        },
        fx = {
            {
                Texture = "rbxasset://textures/particles/smoke_main.dds",
                Rate = 5,
                dir = "drift",
                Color = fromRGB(190, 215, 240),
                Lifetime = { 6, 9 },
                Speed = { 1, 2 },
                Size = new({
                    new2(0, 7),
                    new2(1, 12)
                }),
                Transparency = puff(0.9)
            }
        }
    },
    kelp_forest = {
        fog = {
            fromRGB(110, 170, 120),
            1300
        },
        fx = {
            {
                Texture = "rbxasset://textures/particles/sparkles_main.dds",
                Rate = 14,
                dir = "down",
                Acceleration = Vector3.new(2, 3, 1),
                Color = fromRGB(120, 210, 90),
                Lifetime = { 4, 6 },
                Speed = { 1.5, 3 },
                Size = new(0.35),
                Transparency = puff(0.2),
                RotSpeed = { -120, 120 }
            }
        }
    },
    mangrove_swamp = {
        fog = {
            fromRGB(96, 122, 84),
            800
        },
        fx = {
            {
                Texture = "rbxasset://textures/particles/sparkles_main.dds",
                Rate = 16,
                dir = "drift",
                LightEmission = 1,
                Color = fromRGB(225, 255, 120),
                Lifetime = { 3, 5 },
                Speed = { 0.4, 1.4 },
                Size = new({
                    new2(0, 0),
                    new2(0.3, 0.4),
                    new2(0.6, 0.1),
                    new2(0.8, 0.4),
                    new2(1, 0)
                }),
                Transparency = new(0.1)
            },
            {
                Texture = "rbxasset://textures/particles/smoke_main.dds",
                Rate = 4,
                dir = "drift",
                Color = fromRGB(150, 175, 130),
                Lifetime = { 6, 9 },
                Speed = { 0.5, 1.5 },
                Size = new({
                    new2(0, 8),
                    new2(1, 13)
                }),
                Transparency = puff(0.9)
            }
        }
    },
    frozen_fjord = {
        fog = {
            fromRGB(215, 232, 248),
            900
        },
        fx = {
            {
                Texture = "rbxasset://textures/particles/sparkles_main.dds",
                Rate = 60,
                dir = "down",
                Acceleration = Vector3.new(3, 0, 1),
                LightEmission = 0.5,
                Color = fromRGB(255, 255, 255),
                Lifetime = { 4, 5.5 },
                Speed = { 6, 11 },
                Size = new(0.4),
                Transparency = puff(0.1),
                RotSpeed = { -60, 60 }
            }
        }
    },
    sunken_ruins = {
        fog = {
            fromRGB(214, 196, 150),
            1200
        },
        fx = {
            {
                Texture = "rbxasset://textures/particles/sparkles_main.dds",
                Rate = 14,
                dir = "drift",
                LightEmission = 0.6,
                Color = fromRGB(255, 232, 170),
                Lifetime = { 4, 7 },
                Speed = { 0.4, 1.2 },
                Size = new({
                    new2(0, 0.22),
                    new2(1, 0)
                }),
                Transparency = puff(0.35)
            }
        }
    },
    volcanic_vents = {
        fog = {
            fromRGB(92, 52, 44),
            800
        },
        fx = {
            {
                Texture = "rbxasset://textures/particles/sparkles_main.dds",
                Rate = 30,
                dir = "up",
                Acceleration = Vector3.new(1.5, 1, 0),
                LightEmission = 1,
                Color = fromRGB(255, 140, 50),
                Lifetime = { 3, 5 },
                Speed = { 3, 7 },
                Size = new({
                    new2(0, 0.45),
                    new2(1, 0.1)
                }),
                Transparency = puff(0.1),
                RotSpeed = { -100, 100 }
            },
            {
                Texture = "rbxasset://textures/particles/smoke_main.dds",
                Rate = 5,
                dir = "up",
                Color = fromRGB(60, 54, 56),
                Lifetime = { 5, 8 },
                Speed = { 1, 2.5 },
                Size = new({
                    new2(0, 6),
                    new2(1, 11)
                }),
                Transparency = puff(0.86)
            }
        }
    },
    crystal_caverns = {
        fog = {
            fromRGB(150, 120, 205),
            1000
        },
        fx = {
            {
                Texture = "rbxasset://textures/particles/sparkles_main.dds",
                Rate = 22,
                dir = "drift",
                LightEmission = 1,
                Color = fromRGB(215, 170, 255),
                Lifetime = { 3, 5 },
                Speed = { 0.5, 1.5 },
                Size = new({
                    new2(0, 0),
                    new2(0.4, 0.5),
                    new2(1, 0)
                }),
                Transparency = new(0.1),
                RotSpeed = { -60, 60 }
            }
        }
    },
    shipwreck_graveyard = {
        fog = {
            fromRGB(120, 130, 136),
            650
        },
        fx = {
            {
                Texture = "rbxasset://textures/particles/smoke_main.dds",
                Rate = 9,
                dir = "drift",
                Acceleration = Vector3.new(1.5, 0, 0),
                Color = fromRGB(190, 198, 204),
                Lifetime = { 6, 9 },
                Speed = { 1.5, 3 },
                Size = new({
                    new2(0, 9),
                    new2(1, 15)
                }),
                Transparency = puff(0.86)
            }
        }
    },
    abyssal_trench = {
        fog = {
            fromRGB(14, 20, 44),
            700
        },
        fx = {
            {
                Texture = "rbxasset://textures/particles/sparkles_main.dds",
                Rate = 14,
                dir = "drift",
                LightEmission = 1,
                Color = fromRGB(90, 170, 255),
                Lifetime = { 4, 7 },
                Speed = { 0.3, 1 },
                Size = new({
                    new2(0, 0),
                    new2(0.5, 0.35),
                    new2(1, 0)
                }),
                Transparency = new(0.15)
            }
        }
    },
    storm_sea = {
        fog = {
            fromRGB(96, 104, 122),
            750
        },
        fx = {
            {
                Texture = "rbxasset://textures/particles/smoke_main.dds",
                Rate = 260,
                dir = "down",
                Acceleration = Vector3.new(14, 0, 0),
                LightEmission = 0.3,
                Color = fromRGB(200, 220, 245),
                Lifetime = { 0.5, 0.7 },
                Speed = { 70, 90 },
                Size = new(1.5),
                Squash = new(2.4),
                Transparency = new(0.3)
            }
        }
    },
    celestial_ocean = {
        fog = {
            fromRGB(52, 46, 110),
            1100
        },
        fx = {
            {
                Texture = "rbxasset://textures/particles/sparkles_main.dds",
                Rate = 26,
                dir = "drift",
                LightEmission = 1,
                Color = fromRGB(255, 245, 200),
                Lifetime = { 3, 5 },
                Speed = { 0.2, 0.8 },
                Size = new({
                    new2(0, 0),
                    new2(0.3, 0.55),
                    new2(0.5, 0.2),
                    new2(0.7, 0.55),
                    new2(1, 0)
                }),
                Transparency = new(0.05),
                RotSpeed = { -30, 30 }
            }
        }
    },
    toxic_lagoon = {
        fog = {
            fromRGB(110, 150, 50),
            700
        },
        fx = {
            {
                Texture = "rbxasset://textures/particles/sparkles_main.dds",
                Rate = 22,
                dir = "up",
                LightEmission = 0.8,
                Color = fromRGB(170, 255, 60),
                Lifetime = { 3, 5 },
                Speed = { 1.5, 3.5 },
                Size = new({
                    new2(0, 0.2),
                    new2(1, 0.5)
                }),
                Transparency = puff(0.2)
            },
            {
                Texture = "rbxasset://textures/particles/smoke_main.dds",
                Rate = 4,
                dir = "drift",
                Color = fromRGB(150, 200, 70),
                Lifetime = { 5, 8 },
                Speed = { 0.5, 1.5 },
                Size = new({
                    new2(0, 7),
                    new2(1, 12)
                }),
                Transparency = puff(0.9)
            }
        }
    },
    clockwork_depths = {
        fog = {
            fromRGB(150, 124, 88),
            1000
        },
        fx = {
            {
                Texture = "rbxasset://textures/particles/smoke_main.dds",
                Rate = 6,
                dir = "up",
                Color = fromRGB(235, 228, 215),
                Lifetime = { 3, 5 },
                Speed = { 3, 5 },
                Size = new({
                    new2(0, 3),
                    new2(1, 8)
                }),
                Transparency = puff(0.82)
            },
            {
                Texture = "rbxasset://textures/particles/sparkles_main.dds",
                Rate = 10,
                dir = "down",
                LightEmission = 1,
                Color = fromRGB(255, 205, 110),
                Lifetime = { 1, 1.8 },
                Speed = { 4, 9 },
                Size = new({
                    new2(0, 0.3),
                    new2(1, 0)
                }),
                Transparency = new(0.1)
            }
        }
    },
    neon_reef = {
        fog = {
            fromRGB(70, 30, 110),
            1000
        },
        fx = {
            {
                Texture = "rbxasset://textures/particles/sparkles_main.dds",
                Rate = 26,
                dir = "up",
                LightEmission = 1,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, fromRGB(255, 60, 220)),
                    ColorSequenceKeypoint.new(0.5, fromRGB(60, 240, 255)),
                    ColorSequenceKeypoint.new(1, fromRGB(190, 255, 70))
                }),
                Lifetime = { 3, 5 },
                Speed = { 1, 2.5 },
                Size = new(0.35),
                Transparency = puff(0.05)
            }
        }
    },
    primeval_sea = {
        fog = {
            fromRGB(110, 150, 96),
            850
        },
        fx = {
            {
                Texture = "rbxasset://textures/particles/sparkles_main.dds",
                Rate = 16,
                dir = "drift",
                Color = fromRGB(240, 240, 170),
                Lifetime = { 4, 7 },
                Speed = { 0.4, 1.4 },
                Size = new({
                    new2(0, 0.3),
                    new2(1, 0.1)
                }),
                Transparency = puff(0.3)
            },
            {
                Texture = "rbxasset://textures/particles/smoke_main.dds",
                Rate = 5,
                dir = "drift",
                Color = fromRGB(190, 215, 180),
                Lifetime = { 6, 9 },
                Speed = { 0.5, 1.5 },
                Size = new({
                    new2(0, 8),
                    new2(1, 14)
                }),
                Transparency = puff(0.88)
            }
        }
    },
    nightmare_sea = {
        fog = {
            fromRGB(46, 10, 20),
            650
        },
        fx = {
            {
                Texture = "rbxasset://textures/particles/sparkles_main.dds",
                Rate = 20,
                dir = "up",
                LightEmission = 1,
                Color = fromRGB(255, 50, 70),
                Lifetime = { 3, 5 },
                Speed = { 1.5, 4 },
                Size = new({
                    new2(0, 0.4),
                    new2(1, 0.1)
                }),
                Transparency = puff(0.15),
                RotSpeed = { -80, 80 }
            },
            {
                Texture = "rbxasset://textures/particles/smoke_main.dds",
                Rate = 5,
                dir = "drift",
                Color = fromRGB(30, 14, 22),
                Lifetime = { 6, 9 },
                Speed = { 0.5, 2 },
                Size = new({
                    new2(0, 8),
                    new2(1, 13)
                }),
                Transparency = puff(0.84)
            }
        }
    },
    glitch_rift = {
        fog = {
            fromRGB(24, 30, 52),
            850
        },
        fx = {
            {
                Texture = "",
                Rate = 30,
                dir = "drift",
                LightEmission = 1,
                square = true,
                Color = ColorSequence.new(fromRGB(0, 255, 240), fromRGB(255, 0, 200)),
                Lifetime = { 0.4, 1.1 },
                Speed = { 0, 0.5 },
                Size = new(0.45),
                Transparency = new({
                    new2(0, 0),
                    new2(0.45, 0),
                    new2(0.5, 1),
                    new2(0.7, 1),
                    new2(0.75, 0),
                    new2(1, 1)
                })
            }
        }
    },
    divine_throne = {
        fog = {
            fromRGB(255, 244, 214),
            1500
        },
        fx = {
            {
                Texture = "rbxasset://textures/particles/sparkles_main.dds",
                Rate = 26,
                dir = "up",
                LightEmission = 1,
                Color = fromRGB(255, 226, 130),
                Lifetime = { 4, 6 },
                Speed = { 1, 2.5 },
                Size = new({
                    new2(0, 0),
                    new2(0.3, 0.5),
                    new2(1, 0)
                }),
                Transparency = new(0.05),
                RotSpeed = { -40, 40 }
            }
        }
    },
    candy_cove = {
        fog = {
            fromRGB(195, 232, 228),
            1300
        },
        fx = {
            {
                Texture = "rbxasset://textures/particles/sparkles_main.dds",
                Rate = 18,
                dir = "up",
                LightEmission = 0.4,
                Color = ColorSequence.new(fromRGB(255, 255, 255), fromRGB(255, 200, 230)),
                Lifetime = { 3, 5 },
                Speed = { 1.5, 3 },
                Size = new({
                    new2(0, 0.18),
                    new2(1, 0.4)
                }),
                Transparency = puff(0.2)
            }
        }
    }
}

t1.Looks = t2

local Part
local t5 = {}
local v2, t6

t1.Zone = nil
t1.Override = nil

local function range(p4) -- line: 112
    if type(p4) == "table" then
        return (NumberRange.new(p4[1], p4[2]))
    end

    return (NumberRange.new(p4))
end

local function build(p5) -- line: 116
    -- upvalues: t2 (copy), Part (ref), t5 (copy)
    local t7 = {}
    local v3 = t2[p5]

    for _, v4 in ipairs(v3 and v3.fx or {}) do
        local ParticleEmitter = Instance.new("ParticleEmitter")

        ParticleEmitter.Name = p5
        ParticleEmitter.Enabled = false
        ParticleEmitter.Shape = Enum.ParticleEmitterShape.Box
        ParticleEmitter.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
        ParticleEmitter.LockedToPart = false
        ParticleEmitter.Rotation = NumberRange.new(0, 360)

        if v4.dir == "up" then
            ParticleEmitter.EmissionDirection = Enum.NormalId.Top
        else
            ParticleEmitter.EmissionDirection = Enum.NormalId.Bottom
        end

        if v4.dir == "drift" then
            ParticleEmitter.SpreadAngle = Vector2.new(180, 180)
        end

        if v4.Texture ~= "" then
            ParticleEmitter.Texture = v4.Texture
        end

        if typeof(v4.Color) == "ColorSequence" then
            ParticleEmitter.Color = v4.Color
        else
            ParticleEmitter.Color = ColorSequence.new(v4.Color)
        end

        ParticleEmitter.Rate = v4.Rate

        local Lifetime = v4.Lifetime

        if type(Lifetime) == "table" then
            ParticleEmitter.Lifetime = NumberRange.new(Lifetime[1], Lifetime[2])
        else
            ParticleEmitter.Lifetime = NumberRange.new(Lifetime)
        end

        local Speed = v4.Speed

        if type(Speed) == "table" then
            ParticleEmitter.Speed = NumberRange.new(Speed[1], Speed[2])
        else
            ParticleEmitter.Speed = NumberRange.new(Speed)
        end

        ParticleEmitter.Size = v4.Size
        ParticleEmitter.Transparency = v4.Transparency
        ParticleEmitter.LightEmission = v4.LightEmission or 0

        if v4.Acceleration then
            ParticleEmitter.Acceleration = v4.Acceleration
        end

        if v4.RotSpeed then
            local RotSpeed = v4.RotSpeed

            if type(RotSpeed) == "table" then
                ParticleEmitter.RotSpeed = NumberRange.new(RotSpeed[1], RotSpeed[2])
            else
                ParticleEmitter.RotSpeed = NumberRange.new(RotSpeed)
            end
        end

        if v4.Squash then
            ParticleEmitter.Squash = v4.Squash
        end

        if v4.square then
            ParticleEmitter.Rotation = NumberRange.new(0)
        end

        ParticleEmitter.Parent = Part
        table.insert(t7, ParticleEmitter)
    end

    t5[p5] = t7

    return t7
end

local function setParticles(p6) -- line: 160
    -- upvalues: t5 (copy), v2 (ref), build (copy)
    if p6 == v2 then
        return
    end

    for _, v5 in ipairs(t5[v2 or ""] or {}) do
        v5.Enabled = false
    end

    v2 = p6

    if p6 then
        for _, v6 in ipairs(t5[p6] or build(p6)) do
            v6.Enabled = true
        end
    end
end

function t1.Init() -- line: 175
    -- upvalues: RunService (copy), Lighting (copy), Players (copy), GameConfig (copy), Zones (copy), DataClient (copy), t1 (copy), fromRGB (copy), t2 (copy), Part (ref), t5 (copy), v2 (ref), t6 (ref), setParticles (copy)
    t6 = {
        Lighting.FogStart,
        Lighting.FogEnd,
        Lighting.FogColor
    }
    Part = Instance.new("Part")
    Part.Name = "ZoneAir"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Transparency = 1
    Part.Size = Vector3.new(90, 40, 90)
    Part:SetAttribute("NoStuds", true)
    Part.Parent = workspace

    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    local v7

    RunService.RenderStepped:Connect(function(p7) -- line: 190
        -- upvalues: PlayerGui (copy), v7 (ref), Lighting (copy), Players (copy), GameConfig (copy), Zones (copy), DataClient (copy), t1 (copy), fromRGB (copy), t2 (copy), Part (ref), t5 (copy), v2 (ref), t6 (ref), setParticles (copy)
        local CurrentCamera = workspace.CurrentCamera
        local CFramePosition = CurrentCamera.CFrame.Position

        v7 = v7 or PlayerGui:FindFirstChild("Reveal")

        if v7 and v7.Enabled then
            if v2 ~= nil then
                for _, v8 in ipairs(t5[v2 or ""] or {}) do
                    v8.Enabled = false
                end

                v2 = nil
            end
        elseif Players.LocalPlayer:GetAttribute("InAquarium") then
            if v2 ~= nil then
                for _, v9 in ipairs(t5[v2 or ""] or {}) do
                    v9.Enabled = false
                end

                v2 = nil
            end

            local v11 = 1 - math.exp(-p7 * 3)

            Lighting.FogEnd += (820 - Lighting.FogEnd) * v11
            Lighting.FogStart = 110
            Lighting.FogColor = Lighting.FogColor:Lerp(fromRGB(30, 98, 160), v11)
        else
            local v12 = t1.Override and t1.Override(CFramePosition)

            if v12 then
                if v2 ~= nil then
                    for _, v13 in ipairs(t5[v2 or ""] or {}) do
                        v13.Enabled = false
                    end

                    v2 = nil
                end

                local v15 = 1 - math.exp(-p7 * 3)

                Lighting.FogEnd = math.exp(math.log((math.max(Lighting.FogEnd, 1))) + (math.log(v12[2]) - math.log((math.max(Lighting.FogEnd, 1)))) * v15)
                Lighting.FogStart += (v12[1] - Lighting.FogStart) * v15
                Lighting.FogColor = Lighting.FogColor:Lerp(v12[3], v15)
            else
                local v22 = (DataClient.Get("Settings") or {}).Weather ~= false
                local v26 = math.clamp(math.floor((GameConfig.DOCK_Z - CFramePosition.Z) / GameConfig.ZONE_LENGTH) + 1, 1, #Zones.List)
                local v27 = Zones.List[v26]
                local v28

                if v22 then
                    v28 = t2[v27.id]
                    v28 = v28 or nil
                end

                t1.Zone = v27.id

                local v29 = v28 and v28.fog
                local v30 = if v29 then v29[2] else t6[2]
                local v31 = if v29 then v29[1] else t6[3]
                local v33 = 1 - math.exp(-p7 * 2.2)

                Lighting.FogEnd = math.exp(math.log(Lighting.FogEnd) + (math.log(v30) - math.log(Lighting.FogEnd)) * v33)
                Lighting.FogStart = Lighting.FogStart + ((if v29 then v30 * 0.12 else t6[1]) - Lighting.FogStart) * v33
                Lighting.FogColor = Lighting.FogColor:Lerp(v31, v33)

                local v38 = (workspace:GetAttribute("EventId") or "") ~= ""
                local v39, v40

                if not v28 or v38 then
                    v40 = true
                elseif CFramePosition.Y > GameConfig.WATER_Y then
                    v39 = Vector3.new(CurrentCamera.CFrame.LookVector.X, 0, CurrentCamera.CFrame.LookVector.Z)

                    if v39.Magnitude > 0.01 then
                        v39 = v39.Unit
                    end

                    v40 = false
                else
                    v40 = true
                end

                if not v40 then
                    Part.CFrame = CFrame.new(CFramePosition + v39 * 30 + Vector3.new(0, 8, 0))
                    setParticles(v27.id)
                elseif v2 ~= nil then
                    for _, v41 in ipairs(t5[v2 or ""] or {}) do
                        v41.Enabled = false
                    end

                    v2 = nil
                end
            end
        end
    end)
end

return t1
