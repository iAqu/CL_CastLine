-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    Basic = {
        hpPerPlayer = 10,
        sizeMultiplier = 1
    },
    Hard = {
        hpPerPlayer = 15,
        sizeMultiplier = 2
    },
    Insane = {
        hpPerPlayer = 25,
        sizeMultiplier = 5
    }
}
local t2 = {
    "Basic",
    "Hard",
    "Insane"
}

local function isPinataBossDifficulty(p1) -- line: 20
    -- upvalues: t2 (copy)
    return table.find(t2, p1) ~= nil
end

local function rollPinataBossDifficultyForSlot(p2, p3) -- line: 30
    -- upvalues: t2 (copy)
    return t2[math.floor(p2 / p3 * 48271 % 2147483647) % #t2 + 1]
end

local function computeBossLegAlpha(p4, p5) -- line: 45
    local currentPosition, targetPosition, moveStartTime, moveSpeed = p4.currentPosition, p4.targetPosition, p4.moveStartTime, p4.moveSpeed
    local Magnitude = (targetPosition - currentPosition).Magnitude

    if Magnitude <= 0 or moveSpeed <= 0 then
        return 1
    end

    return math.min(math.max(0, p5 - moveStartTime) * moveSpeed, Magnitude) / Magnitude
end

local function computeInterpolatedBossPosition(p6, p7) -- line: 63
    local currentPosition, targetPosition, moveStartTime, moveSpeed = p6.currentPosition, p6.targetPosition, p6.moveStartTime, p6.moveSpeed
    local Magnitude = (targetPosition - currentPosition).Magnitude
    local v5 = if Magnitude <= 0 or moveSpeed <= 0 then 1 else math.min(math.max(0, p7 - moveStartTime) * moveSpeed, Magnitude) / Magnitude

    return p6.currentPosition:Lerp(p6.targetPosition, v5)
end

local function pickRandomDestination(p8, p9) -- line: 68
    local v8 = math.random() * 3.141592653589793 * 2
    local v9 = math.random() * p9

    return (Vector3.new(p8.X + math.cos(v8) * v9, p8.Y, p8.Z + math.sin(v8) * v9))
end

local t3 = {
    Basic = {
        {
            minContributionShare = 0.5,
            lootTable = {
                {
                    chance = 50,
                    reward = {
                        amount = 15,
                        kind = "tickets"
                    }
                },
                {
                    chance = 35,
                    reward = {
                        amount = 25,
                        kind = "tickets"
                    }
                },
                {
                    chance = 15,
                    reward = {
                        amount = 40,
                        kind = "tickets"
                    }
                }
            }
        },
        {
            minContributionShare = 0.2,
            lootTable = {
                {
                    chance = 55,
                    reward = {
                        amount = 8,
                        kind = "tickets"
                    }
                },
                {
                    chance = 30,
                    reward = {
                        amount = 15,
                        kind = "tickets"
                    }
                },
                {
                    chance = 15,
                    reward = {
                        amount = 25,
                        kind = "tickets"
                    }
                }
            }
        },
        {
            minContributionShare = 0,
            lootTable = {
                {
                    chance = 70,
                    reward = {
                        amount = 3,
                        kind = "tickets"
                    }
                },
                {
                    chance = 25,
                    reward = {
                        amount = 8,
                        kind = "tickets"
                    }
                },
                {
                    chance = 5,
                    reward = {
                        amount = 15,
                        kind = "tickets"
                    }
                }
            }
        }
    },
    Hard = {
        {
            minContributionShare = 0.5,
            lootTable = {
                {
                    chance = 50,
                    reward = {
                        amount = 25,
                        kind = "tickets"
                    }
                },
                {
                    chance = 35,
                    reward = {
                        amount = 40,
                        kind = "tickets"
                    }
                },
                {
                    chance = 15,
                    reward = {
                        amount = 60,
                        kind = "tickets"
                    }
                }
            }
        },
        {
            minContributionShare = 0.2,
            lootTable = {
                {
                    chance = 55,
                    reward = {
                        amount = 12,
                        kind = "tickets"
                    }
                },
                {
                    chance = 30,
                    reward = {
                        amount = 25,
                        kind = "tickets"
                    }
                },
                {
                    chance = 15,
                    reward = {
                        amount = 40,
                        kind = "tickets"
                    }
                }
            }
        },
        {
            minContributionShare = 0,
            lootTable = {
                {
                    chance = 70,
                    reward = {
                        amount = 5,
                        kind = "tickets"
                    }
                },
                {
                    chance = 25,
                    reward = {
                        amount = 12,
                        kind = "tickets"
                    }
                },
                {
                    chance = 5,
                    reward = {
                        amount = 25,
                        kind = "tickets"
                    }
                }
            }
        }
    },
    Insane = {
        {
            minContributionShare = 0.5,
            lootTable = {
                {
                    chance = 50,
                    reward = {
                        amount = 45,
                        kind = "tickets"
                    }
                },
                {
                    chance = 35,
                    reward = {
                        amount = 70,
                        kind = "tickets"
                    }
                },
                {
                    chance = 15,
                    reward = {
                        amount = 100,
                        kind = "tickets"
                    }
                }
            }
        },
        {
            minContributionShare = 0.2,
            lootTable = {
                {
                    chance = 55,
                    reward = {
                        amount = 22,
                        kind = "tickets"
                    }
                },
                {
                    chance = 30,
                    reward = {
                        amount = 45,
                        kind = "tickets"
                    }
                },
                {
                    chance = 15,
                    reward = {
                        amount = 70,
                        kind = "tickets"
                    }
                }
            }
        },
        {
            minContributionShare = 0,
            lootTable = {
                {
                    chance = 70,
                    reward = {
                        amount = 10,
                        kind = "tickets"
                    }
                },
                {
                    chance = 25,
                    reward = {
                        amount = 22,
                        kind = "tickets"
                    }
                },
                {
                    chance = 5,
                    reward = {
                        amount = 45,
                        kind = "tickets"
                    }
                }
            }
        }
    }
}

return {
    pinataBossWanderRadius = 100,
    pinataBossDefaultMoveSpeed = 6,
    pinataBossDefaultMaxHp = 5,
    pinataBossHitRadius = 10,
    pinataBossFightDurationSeconds = 300,
    isPinataBossDifficulty = isPinataBossDifficulty,
    rollPinataBossDifficultyForSlot = rollPinataBossDifficultyForSlot,
    computeBossLegAlpha = computeBossLegAlpha,
    computeInterpolatedBossPosition = computeInterpolatedBossPosition,
    pickRandomDestination = pickRandomDestination,
    getPinataBossDamageTier = function(p10, p11) -- getPinataBossDamageTier | line: 286
        -- upvalues: t3 (copy)
        local v12 = t3[p11]

        for _, v13 in v12 do
            if v13.minContributionShare <= p10 then
                return v13
            end
        end

        return v12[#v12]
    end,
    rollPinataBossReward = function(p12) -- rollPinataBossReward | line: 296
        local n1 = 0

        for _, v14 in p12.lootTable do
            n1 += v14.chance
        end

        local v15 = math.random() * n1

        for _, v16 in p12.lootTable do
            v15 -= v16.chance

            if v15 <= 0 then
                return v16.reward
            end
        end

        return p12.lootTable[#p12.lootTable].reward
    end,
    pinataBossDifficultyConfigs = t1,
    pinataBossDifficulties = t2,
    pinataBossDamageTiersByDifficulty = t3
}
