-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "transition", "window-transition").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default3 = RuntimeLib.import(script, script.Parent, "zone-gacha-window").default

local function ZoneGachaWindowShowcase() -- line: 10
    -- upvalues: RuntimeLib (copy), react (copy), useState (copy), default (copy), default3 (copy)
    local v1, v2 = useState(true)
    local v3, v4 = useState({ "head1", "eyes1", "eyes2" })
    local v5, v6 = useState({
        eyes = "eyes1",
        head = nil,
        legendary = nil
    })
    local v7, v8 = useState({
        eyes = nil,
        head = "head1",
        legendary = nil
    })

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement(default, {
        enableCameraEffects = false,
        ["in"] = v1
    }, react.createElement(default3, {
        disableSceneCamera = true,
        equippedBuffIdByCategory = v7,
        equippedSkinIdByCategory = v5,
        onBuyMoreTokens = function() -- onBuyMoreTokens | line: 33
        end,
        onClose = function() -- onClose | line: 34
            -- upvalues: v2 (copy)
            return v2(false)
        end,
        onEquipAsBuff = function(p1, p2) -- onEquipAsBuff | line: 37
            -- upvalues: v8 (copy)
            return v8(function(p3) -- line: 38
                -- upvalues: p1 (copy), p2 (copy)
                local v9 = table.clone(p3)

                setmetatable(v9, nil)
                v9[p1] = p2

                return v9
            end)
        end,
        onEquipAsSkin = function(p4, p5) -- onEquipAsSkin | line: 45
            -- upvalues: v6 (copy)
            return v6(function(p6) -- line: 46
                -- upvalues: p4 (copy), p5 (copy)
                local v10 = table.clone(p6)

                setmetatable(v10, nil)
                v10[p4] = p5

                return v10
            end)
        end,
        onRoll = RuntimeLib.async(function(p7) -- line: 53
            -- upvalues: v3 (copy), v4 (copy)
            local v11 = if p7 == "eyes" then "eyes3" else "head3"

            if table.find(v3, v11) == nil then
                v4(function(p8) -- line: 56
                    -- upvalues: v11 (copy)
                    local t4 = {}
                    local v12 = #t4
                    local v13 = #p8

                    table.move(p8, 1, v13, v12 + 1, t4)
                    t4[v12 + v13 + 1] = v11

                    return t4
                end)
            end

            return {
                displayName = "Rolled Item",
                rarity = "rare",
                id = v11
            }
        end),
        ownedItemIds = v3,
        tokenBalances = {
            tokenA = 25,
            tokenB = 5,
            tokenC = 0
        }
    })))
end

return storyForScreenGui(react.createElement(default2, {
    initialState = {}
}, react.createElement(ZoneGachaWindowShowcase)))
