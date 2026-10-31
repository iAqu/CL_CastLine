-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    tags = {},
    rootInit = {
        name = "Splash-01-Clone",
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
                        name = "Splash",
                        id = 3,
                        class = "ParticleEmitter",
                        ghosted = false,
                        children = {}
                    },
                    {
                        name = "Wind1",
                        id = 4,
                        class = "ParticleEmitter",
                        ghosted = false,
                        children = {}
                    },
                    {
                        name = "Droplets",
                        id = 5,
                        class = "ParticleEmitter",
                        ghosted = false,
                        children = {}
                    },
                    {
                        name = "Cresc",
                        id = 6,
                        class = "ParticleEmitter",
                        ghosted = false,
                        children = {}
                    }
                }
            },
            {
                name = "Attachment",
                id = 7,
                class = "Attachment",
                ghosted = false,
                children = {
                    {
                        name = "SplashUp",
                        id = 8,
                        class = "ParticleEmitter",
                        ghosted = false,
                        children = {}
                    }
                }
            }
        }
    },
    properties = {
        [1] = {
            Transparency = {
                ghosted = false,
                data = {
                    {
                        value = 0.75,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
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
            TopSurface = {
                ghosted = false,
                data = {
                    {
                        value = Enum.SurfaceType.Smooth,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Material = {
                ghosted = false,
                data = {
                    {
                        value = Enum.Material.SmoothPlastic,
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
            CFrame = {
                ghosted = false,
                data = {
                    {
                        value = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Size = {
                ghosted = false,
                data = {
                    {
                        value = Vector3.new(1, 1, 1),
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
            Color = {
                ghosted = false,
                data = {
                    {
                        value = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.new(0.286275, 0.607843, 1)),
                            ColorSequenceKeypoint.new(1, Color3.new(0.286275, 0.607843, 1))
                        }),
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
            Texture = {
                ghosted = false,
                data = {
                    {
                        value = "rbxassetid://17063077953",
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Speed = {
                ghosted = false,
                data = {
                    {
                        value = NumberRange.new(0.0010000000474974513, 0.0010000000474974513),
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
            Orientation = {
                ghosted = false,
                data = {
                    {
                        value = Enum.ParticleOrientation.VelocityPerpendicular,
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
            Size = {
                ghosted = false,
                data = {
                    {
                        value = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 1, 0),
                            NumberSequenceKeypoint.new(1, 8.75, 0)
                        }),
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
            Color = {
                ghosted = false,
                data = {
                    {
                        value = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.new(0.541176, 0.92549, 1)),
                            ColorSequenceKeypoint.new(1, Color3.new(0.541176, 0.92549, 1))
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
                        value = 3,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Rate = {
                ghosted = false,
                data = {
                    {
                        value = 10,
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
                            NumberSequenceKeypoint.new(0, 0.5687500238418579, 0),
                            NumberSequenceKeypoint.new(0.19950124621391296, 0.31874996423721313, 0),
                            NumberSequenceKeypoint.new(1, 1, 0)
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
                        value = "rbxassetid://16950679789",
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Lifetime = {
                ghosted = false,
                data = {
                    {
                        value = NumberRange.new(0.4000000059604645, 0.800000011920929),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Orientation = {
                ghosted = false,
                data = {
                    {
                        value = Enum.ParticleOrientation.VelocityPerpendicular,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Speed = {
                ghosted = false,
                data = {
                    {
                        value = NumberRange.new(0.0010000000474974513, 0.0010000000474974513),
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
            Size = {
                ghosted = false,
                data = {
                    {
                        value = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0, 0),
                            NumberSequenceKeypoint.new(0.10000000149011612, 2.285670757293701, 0),
                            NumberSequenceKeypoint.new(0.20000000298023224, 3.942034959793091, 0),
                            NumberSequenceKeypoint.new(0.30000001192092896, 5.225607872009277, 0),
                            NumberSequenceKeypoint.new(0.4000000059604645, 6.249936580657959, 0),
                            NumberSequenceKeypoint.new(0.5, 7.0758843421936035, 0),
                            NumberSequenceKeypoint.new(0.6000000238418579, 7.738998889923096, 0),
                            NumberSequenceKeypoint.new(0.699999988079071, 8.259981155395508, 0),
                            NumberSequenceKeypoint.new(0.800000011920929, 8.648538589477539, 0),
                            NumberSequenceKeypoint.new(0.8999999761581421, 8.90274715423584, 0),
                            NumberSequenceKeypoint.new(1, 9, 0)
                        }),
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
            Acceleration = {
                ghosted = false,
                data = {
                    {
                        value = Vector3.new(0, -100, 0),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Color = {
                ghosted = false,
                data = {
                    {
                        value = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.new(0.254902, 0.517647, 1)),
                            ColorSequenceKeypoint.new(1, Color3.new(0.254902, 0.517647, 1))
                        }),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Rate = {
                ghosted = false,
                data = {
                    {
                        value = 200,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Texture = {
                ghosted = false,
                data = {
                    {
                        value = "rbxassetid://1215684307",
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Lifetime = {
                ghosted = false,
                data = {
                    {
                        value = NumberRange.new(0.800000011920929, 0.800000011920929),
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
                        value = Vector2.new(80, 80),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Speed = {
                ghosted = false,
                data = {
                    {
                        value = NumberRange.new(50, 50),
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
                            NumberSequenceKeypoint.new(0, 0.30000001192092896, 0),
                            NumberSequenceKeypoint.new(1, 0.30000001192092896, 0)
                        }),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            }
        },
        [6] = {
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
            Color = {
                ghosted = false,
                data = {
                    {
                        value = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.new(0.768627, 0.960784, 1)),
                            ColorSequenceKeypoint.new(1, Color3.new(0.768627, 0.960784, 1))
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
                        value = 6,
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
                            NumberSequenceKeypoint.new(0, 0.9937499761581421, 0),
                            NumberSequenceKeypoint.new(0.022443899884819984, 0.40625, 0.02500000037252903),
                            NumberSequenceKeypoint.new(1, 1, 0)
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
                        value = "rbxassetid://15893708166",
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Lifetime = {
                ghosted = false,
                data = {
                    {
                        value = NumberRange.new(0.5, 1),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Orientation = {
                ghosted = false,
                data = {
                    {
                        value = Enum.ParticleOrientation.VelocityPerpendicular,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Speed = {
                ghosted = false,
                data = {
                    {
                        value = NumberRange.new(0.019999999552965164, 0.019999999552965164),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            LightEmission = {
                ghosted = false,
                data = {
                    {
                        value = 0.8,
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
                            NumberSequenceKeypoint.new(0, 6, 4),
                            NumberSequenceKeypoint.new(0.10000000149011612, 9.004890441894531, 4),
                            NumberSequenceKeypoint.new(0.20000000298023224, 12.09119987487793, 4),
                            NumberSequenceKeypoint.new(0.30000001192092896, 14.263199806213379, 4),
                            NumberSequenceKeypoint.new(0.4000000059604645, 15.642600059509277, 4),
                            NumberSequenceKeypoint.new(0.5, 16.54129981994629, 4),
                            NumberSequenceKeypoint.new(0.6000000238418579, 17.139999389648438, 4),
                            NumberSequenceKeypoint.new(0.699999988079071, 17.537399291992188, 4),
                            NumberSequenceKeypoint.new(0.800000011920929, 17.791099548339844, 4),
                            NumberSequenceKeypoint.new(0.8999999761581421, 17.937299728393555, 4),
                            NumberSequenceKeypoint.new(1, 18, 4),
                            NumberSequenceKeypoint.new(1, 18, 4)
                        }),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            }
        },
        [7] = {
            CFrame = {
                ghosted = false,
                data = {
                    {
                        value = CFrame.new(0, 5.512836, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            }
        },
        [8] = {
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
            Texture = {
                ghosted = false,
                data = {
                    {
                        value = "rbxassetid://14431663347",
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Color = {
                ghosted = false,
                data = {
                    {
                        value = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.new(0.835294, 1, 0.984314)),
                            ColorSequenceKeypoint.new(1, Color3.new(0.835294, 1, 0.984314))
                        }),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            FlipbookFramerate = {
                ghosted = false,
                data = {
                    {
                        value = NumberRange.new(5, 5),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Drag = {
                ghosted = false,
                data = {
                    {
                        value = 1,
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
            Squash = {
                ghosted = false,
                data = {
                    {
                        value = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0.800000011920929, 0),
                            NumberSequenceKeypoint.new(1, 0.800000011920929, 0)
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
                            NumberSequenceKeypoint.new(0, 0, 0),
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
                        value = NumberRange.new(0.0010000000474974513, 0.0010000000474974513),
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
            Size = {
                ghosted = false,
                data = {
                    {
                        value = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 4, 0),
                            NumberSequenceKeypoint.new(1, 4, 0)
                        }),
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
        [6] = {
            EmitDelay = {
                ghosted = false,
                data = {
                    {
                        value = 0,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            EmitCount = {
                ghosted = false,
                data = {
                    {
                        value = 4,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            }
        },
        [4] = {
            EmitDuration = {
                ghosted = false,
                data = {
                    {
                        value = 0,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
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
        }
    },
    length = 1,
    _version = 6,
    methods = {
        [3] = {
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
        [4] = {
            Emit = {
                ghosted = false,
                data = {
                    {
                        time = 0,
                        args = {
                            1
                        }
                    },
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
                            20
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
                        time = 0,
                        args = {
                            1
                        }
                    }
                }
            }
        },
        [8] = {
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
        }
    }
}
