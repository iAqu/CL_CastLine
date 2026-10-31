-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    tags = {},
    rootInit = {
        name = "Part",
        id = 1,
        class = "Part",
        ghosted = false,
        children = {
            {
                name = "PerfectVFX",
                id = 2,
                class = "Attachment",
                ghosted = false,
                children = {
                    {
                        name = "Dots 1",
                        id = 3,
                        class = "ParticleEmitter",
                        ghosted = false,
                        children = {}
                    },
                    {
                        name = "Dots 2",
                        id = 4,
                        class = "ParticleEmitter",
                        ghosted = false,
                        children = {}
                    },
                    {
                        name = "Purple Expanding",
                        id = 5,
                        class = "ParticleEmitter",
                        ghosted = false,
                        children = {}
                    },
                    {
                        name = "Star6",
                        id = 6,
                        class = "ParticleEmitter",
                        ghosted = false,
                        children = {}
                    },
                    {
                        name = "Star5",
                        id = 7,
                        class = "ParticleEmitter",
                        ghosted = false,
                        children = {}
                    }
                }
            }
        }
    },
    properties = {
        {
            CanQuery = {
                ghosted = false,
                data = {
                    {
                        value = false,
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
            CanTouch = {
                ghosted = false,
                data = {
                    {
                        value = false,
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
            AudioCanCollide = {
                ghosted = false,
                data = {
                    {
                        value = false,
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
        {
            CFrame = {
                ghosted = false,
                data = {
                    {
                        value = CFrame.new(0, 0, 0, 1, -4.87890977618477E-19, 0, 4.87890977618477E-19, 1, -0, 0, 0, 1),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            }
        },
        {
            Enabled = {
                ghosted = false,
                data = {
                    {
                        value = true,
                        ease = "OutLinear",
                        time = 0
                    },
                    {
                        value = false,
                        ease = "OutLinear",
                        time = 0.616667
                    }
                }
            },
            Color = {
                ghosted = false,
                data = {
                    {
                        value = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.new(1, 0, 0)),
                            ColorSequenceKeypoint.new(0.15716752409934998, Color3.new(1, 0.415686, 0)),
                            ColorSequenceKeypoint.new(0.3108808398246765, Color3.new(0.984314, 1, 0.00392157)),
                            ColorSequenceKeypoint.new(0.47668394446372986, Color3.new(0, 0.988235, 0.0313724)),
                            ColorSequenceKeypoint.new(0.6355785727500916, Color3.new(0.00392155, 0.756863, 0.796078)),
                            ColorSequenceKeypoint.new(0.803108811378479, Color3.new(0.168627, 0, 0.717647)),
                            ColorSequenceKeypoint.new(1, Color3.new(0.784314, 0, 1))
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
                            NumberSequenceKeypoint.new(0, 0.10000000149011612, 0),
                            NumberSequenceKeypoint.new(1, 0.18750011920928955, 0)
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
                            NumberSequenceKeypoint.new(0, 0, 0),
                            NumberSequenceKeypoint.new(1, 0.6633333563804626, 0)
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
                        value = NumberRange.new(1, 30),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Lifetime = {
                ghosted = false,
                data = {
                    {
                        value = NumberRange.new(0.10000000149011612, 0.800000011920929),
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
                        value = 50,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            SpreadAngle = {
                ghosted = false,
                data = {
                    {
                        value = Vector2.new(360, -360),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Texture = {
                ghosted = false,
                data = {
                    {
                        value = "rbxassetid://14582794847",
                        ease = "OutLinear",
                        time = 0
                    }
                }
            }
        },
        {
            Enabled = {
                ghosted = false,
                data = {
                    {
                        value = true,
                        ease = "OutLinear",
                        time = 0
                    },
                    {
                        value = false,
                        ease = "OutLinear",
                        time = 0.616667
                    }
                }
            },
            Color = {
                ghosted = false,
                data = {
                    {
                        value = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.new(1, 0, 0.015686)),
                            ColorSequenceKeypoint.new(0.1623488813638687, Color3.new(1, 0.584314, 0.00392157)),
                            ColorSequenceKeypoint.new(0.3212435245513916, Color3.new(1, 0.917647, 0.00392157)),
                            ColorSequenceKeypoint.new(0.46286702156066895, Color3.new(0.00392157, 1, 0.121569)),
                            ColorSequenceKeypoint.new(0.6010362505912781, Color3.new(0, 0.815686, 0.760784)),
                            ColorSequenceKeypoint.new(0.7547495365142822, Color3.new(0.0588236, 0, 0.705882)),
                            ColorSequenceKeypoint.new(1, Color3.new(0.666667, 0, 1))
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
            Rate = {
                ghosted = false,
                data = {
                    {
                        value = 40,
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
                            NumberSequenceKeypoint.new(0, 0.10000000149011612, 0),
                            NumberSequenceKeypoint.new(1, 0.20000000298023224, 0)
                        }),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            SpreadAngle = {
                ghosted = false,
                data = {
                    {
                        value = Vector2.new(360, -360),
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
                            NumberSequenceKeypoint.new(1, 0.6633333563804626, 0)
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
                        value = NumberRange.new(1, 8),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Lifetime = {
                ghosted = false,
                data = {
                    {
                        value = NumberRange.new(0.10000000149011612, 0.800000011920929),
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
                        value = 50,
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
                        value = "rbxassetid://14582794847",
                        ease = "OutLinear",
                        time = 0
                    }
                }
            }
        },
        {
            Enabled = {
                ghosted = false,
                data = {
                    {
                        value = true,
                        ease = "OutLinear",
                        time = 0
                    },
                    {
                        value = false,
                        ease = "OutLinear",
                        time = 0.616667
                    }
                }
            },
            RotSpeed = {
                ghosted = false,
                data = {
                    {
                        value = NumberRange.new(100, 100),
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
                            ColorSequenceKeypoint.new(0, Color3.new(1, 0, 0)),
                            ColorSequenceKeypoint.new(0.18134714663028717, Color3.new(0.941176, 0.54902, 0)),
                            ColorSequenceKeypoint.new(0.3471502661705017, Color3.new(0.87451, 0.890196, 0)),
                            ColorSequenceKeypoint.new(0.48704662919044495, Color3.new(0, 0.835294, 0.054902)),
                            ColorSequenceKeypoint.new(0.6321243643760681, Color3.new(0, 0.584314, 0.701961)),
                            ColorSequenceKeypoint.new(0.8134714961051941, Color3.new(0.0666667, 0, 0.815686)),
                            ColorSequenceKeypoint.new(1, Color3.new(0.831373, 0, 1))
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
            Rate = {
                ghosted = false,
                data = {
                    {
                        value = 2,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Rotation = {
                ghosted = false,
                data = {
                    {
                        value = NumberRange.new(-10, 10),
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
                            NumberSequenceKeypoint.new(0, 0.71875, 0),
                            NumberSequenceKeypoint.new(1, 1, 0)
                        }),
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
                            NumberSequenceKeypoint.new(0, 2.437499761581421, 0),
                            NumberSequenceKeypoint.new(1, 5, 0)
                        }),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Lifetime = {
                ghosted = false,
                data = {
                    {
                        value = NumberRange.new(0.699999988079071, 0.699999988079071),
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
                        value = "rbxassetid://14435065552",
                        ease = "OutLinear",
                        time = 0
                    }
                }
            }
        },
        {
            Enabled = {
                ghosted = false,
                data = {
                    {
                        value = true,
                        ease = "OutLinear",
                        time = 0
                    },
                    {
                        value = false,
                        ease = "OutLinear",
                        time = 0.616667
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
                            ColorSequenceKeypoint.new(0, Color3.new(1, 0, 0.015686)),
                            ColorSequenceKeypoint.new(0.1623488813638687, Color3.new(1, 0.584314, 0.00392157)),
                            ColorSequenceKeypoint.new(0.3212435245513916, Color3.new(1, 0.917647, 0.00392157)),
                            ColorSequenceKeypoint.new(0.46286702156066895, Color3.new(0.00392157, 1, 0.121569)),
                            ColorSequenceKeypoint.new(0.6010362505912781, Color3.new(0, 0.815686, 0.760784)),
                            ColorSequenceKeypoint.new(0.7547495365142822, Color3.new(0.0588236, 0, 0.705882)),
                            ColorSequenceKeypoint.new(1, Color3.new(0.666667, 0, 1))
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
            Rate = {
                ghosted = false,
                data = {
                    {
                        value = 6,
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
                            NumberSequenceKeypoint.new(0, 0.6874996423721313, 0),
                            NumberSequenceKeypoint.new(1, 0.37499964237213135, 0)
                        }),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            SpreadAngle = {
                ghosted = false,
                data = {
                    {
                        value = Vector2.new(360, -360),
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
                            NumberSequenceKeypoint.new(1, 0.6633333563804626, 0)
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
                        value = NumberRange.new(1, 30),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Lifetime = {
                ghosted = false,
                data = {
                    {
                        value = NumberRange.new(0.10000000149011612, 1.5),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            LightEmission = {
                ghosted = false,
                data = {
                    {
                        value = 0,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Brightness = {
                ghosted = false,
                data = {
                    {
                        value = 50,
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
                        value = "rbxassetid://6749866161",
                        ease = "OutLinear",
                        time = 0
                    }
                }
            }
        },
        {
            Enabled = {
                ghosted = false,
                data = {
                    {
                        value = true,
                        ease = "OutLinear",
                        time = 0
                    },
                    {
                        value = false,
                        ease = "OutLinear",
                        time = 0.616667
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
                            ColorSequenceKeypoint.new(0, Color3.new(1, 0, 0.015686)),
                            ColorSequenceKeypoint.new(0.1623488813638687, Color3.new(1, 0.584314, 0.00392157)),
                            ColorSequenceKeypoint.new(0.3212435245513916, Color3.new(1, 0.917647, 0.00392157)),
                            ColorSequenceKeypoint.new(0.46286702156066895, Color3.new(0.00392157, 1, 0.121569)),
                            ColorSequenceKeypoint.new(0.6010362505912781, Color3.new(0, 0.815686, 0.760784)),
                            ColorSequenceKeypoint.new(0.7547495365142822, Color3.new(0.0588236, 0, 0.705882)),
                            ColorSequenceKeypoint.new(1, Color3.new(0.666667, 0, 1))
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
            Rate = {
                ghosted = false,
                data = {
                    {
                        value = 6,
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
                            NumberSequenceKeypoint.new(0, 0.6874996423721313, 0),
                            NumberSequenceKeypoint.new(1, 0.37499964237213135, 0)
                        }),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            SpreadAngle = {
                ghosted = false,
                data = {
                    {
                        value = Vector2.new(360, -360),
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
                            NumberSequenceKeypoint.new(1, 0.6633333563804626, 0)
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
                        value = NumberRange.new(1, 8),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Lifetime = {
                ghosted = false,
                data = {
                    {
                        value = NumberRange.new(0.10000000149011612, 1.5),
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            LightEmission = {
                ghosted = false,
                data = {
                    {
                        value = 0,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            },
            Brightness = {
                ghosted = false,
                data = {
                    {
                        value = 50,
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
                        value = "rbxassetid://6749866161",
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
            EmitDelay = {
                ghosted = false,
                data = {
                    {
                        value = 0,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            }
        },
        [5] = {
            EmitDelay = {
                ghosted = false,
                data = {
                    {
                        value = 0,
                        ease = "OutLinear",
                        time = 0
                    }
                }
            }
        },
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
            }
        }
    },
    length = 2,
    _version = 6,
    methods = {
        [3] = {
            Emit = {
                ghosted = false,
                data = {}
            }
        },
        [4] = {
            Emit = {
                ghosted = false,
                data = {}
            }
        },
        [5] = {
            Emit = {
                ghosted = false,
                data = {}
            }
        },
        [6] = {
            Emit = {
                ghosted = false,
                data = {}
            }
        },
        [7] = {
            Emit = {
                ghosted = false,
                data = {}
            }
        }
    }
}
