-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    tags = {},
    rootInit = {
        name = "Shoot-01",
        id = 1,
        class = "Part",
        ghosted = false,
        children = {
            {
                name = "Main",
                id = 2,
                class = "Attachment",
                ghosted = false,
                children = {
                    {
                        name = "Shockwave1",
                        id = 3,
                        class = "ParticleEmitter",
                        ghosted = false,
                        children = {}
                    },
                    {
                        name = "Glow",
                        id = 4,
                        class = "ParticleEmitter",
                        ghosted = false,
                        children = {}
                    },
                    {
                        name = "HitEffect",
                        id = 5,
                        class = "ParticleEmitter",
                        ghosted = false,
                        children = {}
                    },
                    {
                        name = "Sparks",
                        id = 6,
                        class = "ParticleEmitter",
                        ghosted = false,
                        children = {}
                    }
                }
            },
            {
                name = "Stars",
                id = 7,
                class = "ParticleEmitter",
                ghosted = false,
                children = {}
            }
        }
    },
    properties = {
        [1] = {
            BottomSurface = {
                ghosted = false,
                data = {
                    {
                        value = Enum.SurfaceType.Smooth,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            CanCollide = {
                ghosted = false,
                data = {
                    {
                        value = false,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Color = {
                ghosted = false,
                data = {
                    {
                        value = Color3.fromRGB(248, 248, 248),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Anchored = {
                ghosted = false,
                data = {
                    {
                        value = true,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Transparency = {
                ghosted = false,
                data = {
                    {
                        value = 1,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Size = {
                ghosted = false,
                data = {
                    {
                        value = Vector3.new(2.50524, 2.855139, 4.080368),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            CFrame = {
                ghosted = false,
                data = {
                    {
                        value = CFrame.new(0, 0.702597, 0.14325, -1, 0, -8.742277657347586E-08, 0, 1, 0, 8.742277657347586E-08, 0, -1),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            CastShadow = {
                ghosted = false,
                data = {
                    {
                        value = false,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            TopSurface = {
                ghosted = false,
                data = {
                    {
                        value = Enum.SurfaceType.Smooth,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            }
        },
        [3] = {
            Enabled = {
                ghosted = false,
                data = {
                    {
                        value = false,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            FlipbookMode = {
                ghosted = false,
                data = {
                    {
                        value = Enum.ParticleFlipbookMode.OneShot,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            LockedToPart = {
                ghosted = false,
                data = {
                    {
                        value = true,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Rate = {
                ghosted = false,
                data = {
                    {
                        value = 0.75,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Size = {
                ghosted = false,
                data = {
                    {
                        value = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0.43749988079071045, 0),
                            NumberSequenceKeypoint.new(0.49747899174690247, 3.75, 0),
                            NumberSequenceKeypoint.new(1, 5.125, 0)
                        }),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Rotation = {
                ghosted = false,
                data = {
                    {
                        value = NumberRange.new(-360, 360),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            ZOffset = {
                ghosted = false,
                data = {
                    {
                        value = 1,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            LightEmission = {
                ghosted = false,
                data = {
                    {
                        value = 1,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Lifetime = {
                ghosted = false,
                data = {
                    {
                        value = NumberRange.new(0.5, 0.5),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Speed = {
                ghosted = false,
                data = {
                    {
                        value = NumberRange.new(0.009999999776482582, 0.009999999776482582),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Brightness = {
                ghosted = false,
                data = {
                    {
                        value = 5,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            FlipbookLayout = {
                ghosted = false,
                data = {
                    {
                        value = Enum.ParticleFlipbookLayout.Grid4x4,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Texture = {
                ghosted = false,
                data = {
                    {
                        value = "rbxassetid://16477162837",
                        ease = "OutLinear",
                        time = 0
                    }
                }
            }
        },
        [4] = {
            Enabled = {
                ghosted = false,
                data = {
                    {
                        value = false,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            RotSpeed = {
                ghosted = false,
                data = {
                    {
                        value = NumberRange.new(-200, 200),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            LockedToPart = {
                ghosted = false,
                data = {
                    {
                        value = true,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Rate = {
                ghosted = false,
                data = {
                    {
                        value = 0.5,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Size = {
                ghosted = false,
                data = {
                    {
                        value = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 5, 0),
                            NumberSequenceKeypoint.new(1, 5, 0)
                        }),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Transparency = {
                ghosted = false,
                data = {
                    {
                        value = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0.6875, 0),
                            NumberSequenceKeypoint.new(0.6034913063049316, 0.48750001192092896, 0),
                            NumberSequenceKeypoint.new(1, 1, 0)
                        }),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            LightEmission = {
                ghosted = false,
                data = {
                    {
                        value = 1,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Lifetime = {
                ghosted = false,
                data = {
                    {
                        value = NumberRange.new(0.20000000298023224, 0.20000000298023224),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Speed = {
                ghosted = false,
                data = {
                    {
                        value = NumberRange.new(0, 0),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Brightness = {
                ghosted = false,
                data = {
                    {
                        value = 5,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            ZOffset = {
                ghosted = false,
                data = {
                    {
                        value = 1,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Texture = {
                ghosted = false,
                data = {
                    {
                        value = "http://www.roblox.com/asset/?id=243664672",
                        ease = "OutLinear",
                        time = 0
                    }
                }
            }
        },
        [5] = {
            Enabled = {
                ghosted = false,
                data = {
                    {
                        value = false,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            LockedToPart = {
                ghosted = false,
                data = {
                    {
                        value = true,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Rate = {
                ghosted = false,
                data = {
                    {
                        value = 1,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Rotation = {
                ghosted = false,
                data = {
                    {
                        value = NumberRange.new(-360, 360),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Size = {
                ghosted = false,
                data = {
                    {
                        value = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 5.450000286102295, 0),
                            NumberSequenceKeypoint.new(1, 0, 0)
                        }),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            LightEmission = {
                ghosted = false,
                data = {
                    {
                        value = 0.3,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Lifetime = {
                ghosted = false,
                data = {
                    {
                        value = NumberRange.new(0.05000000074505806, 0.05000000074505806),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Speed = {
                ghosted = false,
                data = {
                    {
                        value = NumberRange.new(0.0014003249816596508, 0.0014003249816596508),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Brightness = {
                ghosted = false,
                data = {
                    {
                        value = 2,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            SpreadAngle = {
                ghosted = false,
                data = {
                    {
                        value = Vector2.new(-360, 360),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Texture = {
                ghosted = false,
                data = {
                    {
                        value = "http://www.roblox.com/asset/?id=7919757890",
                        ease = "OutLinear",
                        time = 0
                    }
                }
            }
        },
        [6] = {
            Color = {
                ghosted = false,
                data = {
                    {
                        value = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
                            ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
                        }),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Drag = {
                ghosted = false,
                data = {
                    {
                        value = 5,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            ZOffset = {
                ghosted = false,
                data = {
                    {
                        value = 2,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Lifetime = {
                ghosted = false,
                data = {
                    {
                        value = NumberRange.new(0.20000000298023224, 0.4000000059604645),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Speed = {
                ghosted = false,
                data = {
                    {
                        value = NumberRange.new(15, 15),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Brightness = {
                ghosted = false,
                data = {
                    {
                        value = 100,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Size = {
                ghosted = false,
                data = {
                    {
                        value = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 1.0500001907348633, 0),
                            NumberSequenceKeypoint.new(1, 0.5500000715255737, 0)
                        }),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Enabled = {
                ghosted = false,
                data = {
                    {
                        value = false,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Acceleration = {
                ghosted = false,
                data = {
                    {
                        value = Vector3.new(0, -5, 0),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            LockedToPart = {
                ghosted = false,
                data = {
                    {
                        value = true,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Rate = {
                ghosted = false,
                data = {
                    {
                        value = 70,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Rotation = {
                ghosted = false,
                data = {
                    {
                        value = NumberRange.new(-90, -90),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Transparency = {
                ghosted = false,
                data = {
                    {
                        value = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 1, 0),
                            NumberSequenceKeypoint.new(0.2605985105037689, 1, 0),
                            NumberSequenceKeypoint.new(0.5536159873008728, 0.46875, 0),
                            NumberSequenceKeypoint.new(1, 1, 0)
                        }),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Orientation = {
                ghosted = false,
                data = {
                    {
                        value = Enum.ParticleOrientation.VelocityParallel,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            LightEmission = {
                ghosted = false,
                data = {
                    {
                        value = 1,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            SpreadAngle = {
                ghosted = false,
                data = {
                    {
                        value = Vector2.new(-180, 180),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Squash = {
                ghosted = false,
                data = {
                    {
                        value = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0.41250014305114746, 0),
                            NumberSequenceKeypoint.new(1, -0.07499980926513672, 0)
                        }),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Texture = {
                ghosted = false,
                data = {
                    {
                        value = "rbxassetid://6763809313",
                        ease = "OutLinear",
                        time = 0
                    }
                }
            }
        },
        [7] = {
            Enabled = {
                ghosted = false,
                data = {
                    {
                        value = false,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            FlipbookMode = {
                ghosted = false,
                data = {
                    {
                        value = Enum.ParticleFlipbookMode.OneShot,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Size = {
                ghosted = false,
                data = {
                    {
                        value = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0, 0),
                            NumberSequenceKeypoint.new(0.19754600524902344, 1.4000004529953003, 0),
                            NumberSequenceKeypoint.new(0.5055214762687683, 0, 0),
                            NumberSequenceKeypoint.new(1, 0, 0)
                        }),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            LockedToPart = {
                ghosted = false,
                data = {
                    {
                        value = true,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            ZOffset = {
                ghosted = false,
                data = {
                    {
                        value = 2,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            SpreadAngle = {
                ghosted = false,
                data = {
                    {
                        value = Vector2.new(-360, 360),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Rotation = {
                ghosted = false,
                data = {
                    {
                        value = NumberRange.new(-360, 360),
                        ease = "OutLinear",
                        time = 0
                    },
                    {
                        value = NumberRange.new(0, 0),
                        ease = "OutLinear",
                        time = 0.15
                    }
                }
            },
            Transparency = {
                ghosted = false,
                data = {
                    {
                        value = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 1, 0),
                            NumberSequenceKeypoint.new(0.2930200397968292, 0, 0),
                            NumberSequenceKeypoint.new(0.496890127658844, 0, 0),
                            NumberSequenceKeypoint.new(0.7007601857185364, 0, 0),
                            NumberSequenceKeypoint.new(1, 1, 0)
                        }),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Speed = {
                ghosted = false,
                data = {
                    {
                        value = NumberRange.new(15, 15),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Lifetime = {
                ghosted = false,
                data = {
                    {
                        value = NumberRange.new(0.5, 0.5),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            LightEmission = {
                ghosted = false,
                data = {
                    {
                        value = 1,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Brightness = {
                ghosted = false,
                data = {
                    {
                        value = 5,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Rate = {
                ghosted = false,
                data = {
                    {
                        value = 20,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Texture = {
                ghosted = false,
                data = {
                    {
                        value = "rbxassetid://17087151546",
                        ease = "OutLinear",
                        time = 0
                    }
                }
            }
        }
    },
    events = {},
    loadType = "Atomic",
    attributes = {
        [3] = {
            EmitCount = {
                ghosted = false,
                data = {
                    {
                        value = 1,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            }
        },
        [5] = {
            EmitCount = {
                ghosted = false,
                data = {
                    {
                        value = 5,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            }
        },
        [6] = {
            EmitCount = {
                ghosted = false,
                data = {
                    {
                        value = 25,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            }
        }
    },
    length = 0.5,
    _version = 6,
    methods = {
        [3] = {
            Emit = {
                ghosted = false,
                data = {
                    {
                        time = 0.066666,
                        args = {
                            1
                        }
                    }
                }
            }
        },
        [4] = {
            Emit = {
                ghosted = false,
                data = {
                    {
                        time = 0.033333,
                        args = {
                            1
                        }
                    }
                }
            }
        },
        [5] = {
            Emit = {
                ghosted = false,
                data = {
                    {
                        time = 0,
                        args = {
                            1
                        }
                    }
                }
            }
        },
        [6] = {
            Emit = {
                ghosted = false,
                data = {
                    {
                        time = 0.066666,
                        args = {
                            10
                        }
                    }
                }
            }
        },
        [7] = {
            Emit = {
                ghosted = false,
                data = {
                    {
                        time = 0.083333,
                        args = {
                            10
                        }
                    }
                }
            }
        }
    }
}
