-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Fish = require(script.Parent.Fish)
local t1 = {
    Rebirths = {
        {
            need = "tidefather",
            cash = 2,
            luck = 2,
            strength = 2
        },
        {
            need = "seraphion",
            cash = 4,
            luck = 4,
            strength = 4
        },
        {
            need = "charybdis",
            cash = 8,
            luck = 8,
            strength = 8
        },
        {
            need = "kronos",
            cash = 16,
            luck = 16,
            strength = 16
        },
        {
            need = "khaos",
            cash = 32,
            luck = 32,
            strength = 32
        }
    }
}

local function rebirthStep(p1) -- line: 26
    -- upvalues: t1 (copy)
    return t1.Rebirths[math.floor(tonumber(p1) or 0)]
end

function t1.RebirthLuck(p2) -- line: 29
    -- upvalues: t1 (copy)
    local v3 = t1.Rebirths[math.floor(tonumber(p2) or 0)]

    if v3 then
        return v3.luck
    end

    return 1
end

function t1.RebirthCash(p3) -- line: 33
    -- upvalues: t1 (copy)
    local v5 = t1.Rebirths[math.floor(tonumber(p3) or 0)]

    return v5 and v5.cash or 1
end

function t1.RebirthStrength(p4) -- line: 37
    -- upvalues: t1 (copy)
    local v7 = t1.Rebirths[math.floor(tonumber(p4) or 0)]

    return v7 and v7.strength or 1
end

local t2 = {
    "I",
    "II",
    "III",
    "IV",
    "V",
    "VI",
    "VII",
    "VIII",
    "IX",
    "X"
}

function t1.Roman(p5) -- line: 43
    -- upvalues: t2 (copy)
    return t2[p5] or tostring(p5)
end

t1.Gifts = {
    {
        at = 1,
        give = {
            {
                kind = "cash",
                mins = 0.5,
                min = 100
            }
        }
    },
    {
        at = 3,
        give = {
            {
                kind = "lucky",
                n = 1
            }
        }
    },
    {
        at = 5,
        give = {
            {
                kind = "cash",
                mins = 1.5,
                min = 400
            }
        }
    },
    {
        at = 8,
        give = {
            {
                kind = "lucky",
                n = 2
            }
        }
    },
    {
        at = 12,
        give = {
            {
                kind = "cash",
                mins = 3,
                min = 1500
            }
        }
    },
    {
        at = 16,
        give = {
            {
                kind = "lucky",
                n = 3
            }
        }
    },
    {
        at = 20,
        give = {
            {
                kind = "cash",
                mins = 6,
                min = 5000
            }
        }
    },
    {
        at = 25,
        give = {
            {
                kind = "lucky",
                n = 5
            }
        }
    },
    {
        at = 30,
        give = {
            {
                kind = "cash",
                mins = 12,
                min = 20000
            }
        }
    },
    {
        at = 40,
        give = {
            {
                kind = "lucky",
                n = 8
            }
        }
    },
    {
        at = 50,
        give = {
            {
                kind = "cash",
                mins = 25,
                min = 80000
            }
        }
    },
    {
        at = 60,
        give = {
            {
                kind = "crate",
                key = "SpiritLantern",
                n = 1
            },
            {
                kind = "lucky",
                n = 5
            }
        }
    }
}

function t1.Day() -- line: 70
    return (math.floor(os.time() / 86400))
end

local n1 = 0

for _, v9 in ipairs(Fish.List) do
    if not v9.exclusive then
        n1 += 1
    end
end

t1.CATCHABLE = n1
t1.IndexRewards = {
    {
        at = 5,
        luck = 0,
        give = {
            {
                kind = "lucky",
                n = 2
            }
        }
    },
    {
        at = 10,
        luck = 0.05,
        give = {
            {
                kind = "cash",
                mins = 5,
                min = 2000
            }
        }
    },
    {
        at = 20,
        luck = 0.05,
        give = {
            {
                kind = "lucky",
                n = 3
            }
        }
    },
    {
        at = 30,
        luck = 0.05,
        give = {
            {
                kind = "cash",
                mins = 10,
                min = 20000
            }
        }
    },
    {
        at = 45,
        luck = 0.1,
        give = {
            {
                kind = "lucky",
                n = 5
            }
        }
    },
    {
        at = 60,
        luck = 0.1,
        give = {
            {
                kind = "cash",
                mins = 20,
                min = 2E+05
            }
        }
    },
    {
        at = 80,
        luck = 0.1,
        give = {
            {
                kind = "lucky",
                n = 8
            }
        }
    },
    {
        at = 100,
        luck = 0.15,
        give = {
            {
                kind = "crate",
                key = "SpiritLantern",
                n = 1
            }
        }
    },
    {
        at = 125,
        luck = 0.15,
        give = {
            {
                kind = "lucky",
                n = 10
            }
        }
    },
    {
        at = 150,
        luck = 0.2,
        give = {
            {
                kind = "cash",
                mins = 60,
                min = 1E+06
            }
        }
    },
    {
        at = 175,
        luck = 0.25,
        give = {
            {
                kind = "lucky",
                n = 15
            }
        }
    },
    {
        luck = 0.5,
        at = n1,
        give = {
            {
                kind = "crate",
                key = "RainbowCrate",
                n = 1
            },
            {
                kind = "crate",
                key = "SpiritLantern",
                n = 3
            }
        }
    }
}

function t1.IndexCount(p6) -- line: 100
    -- upvalues: Fish (copy)
    local n2 = 0

    for v10, v11 in pairs(p6 or {}) do
        if type(v11) == "table" and (v11.n or 0) > 0 and Fish.ById[v10] then
            n2 += 1
        end
    end

    return n2
end

function t1.IndexLuck(p7) -- line: 111
    -- upvalues: t1 (copy)
    local n3 = 0

    for _, v12 in ipairs(t1.IndexRewards) do
        if p7 and p7[tostring(v12.at)] then
            n3 += v12.luck
        end
    end

    return n3 + 1
end

function t1.LuckMultiplier(p8) -- line: 122
    -- upvalues: t1 (copy)
    return t1.RebirthLuck(p8.Rebirths) * t1.IndexLuck(p8.IndexClaimed)
end

return t1
