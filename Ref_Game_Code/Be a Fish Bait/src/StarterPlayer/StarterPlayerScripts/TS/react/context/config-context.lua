-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local createContext, useContext = react.createContext, react.useContext
local ReplicatedStorage = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").ReplicatedStorage
local soundAttributesGuard = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "components", "sound-component").soundAttributesGuard
local soundGroupAttributesGuard = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "components", "sound-group-component").soundGroupAttributesGuard
local t1 = {
    disableMovement = function() -- disableMovement | line: 11
    end,
    enableMovement = function() -- enableMovement | line: 12
    end,
    handleWeaponUsed = function() -- handleWeaponUsed | line: 13
    end,
    playAnimation = function() -- playAnimation | line: 14
        -- upvalues: RuntimeLib (copy)
        return RuntimeLib.Promise.resolve(nil)
    end,
    stopAllAnimations = function() -- stopAllAnimations | line: 17
    end,
    promptToFavoriteGame = function() -- promptToFavoriteGame | line: 18
    end,
    promptToJoinCommunity = function() -- promptToJoinCommunity | line: 19
        -- upvalues: RuntimeLib (copy)
        return RuntimeLib.Promise.resolve(false)
    end,
    promptToJoinGroup = function() -- promptToJoinGroup | line: 22
    end,
    getSound = function(p1) -- getSound | line: 23
        -- upvalues: ReplicatedStorage (copy), soundAttributesGuard (copy)
        local Descendants = ReplicatedStorage:GetDescendants()
        local t2 = {}

        local function v1(p2) -- line: 27
            return p2:IsA("Sound")
        end

        local n1 = 0

        for v2, v3 in Descendants do
            local _ = v2 - 1

            if v3:IsA("Sound") == true then
                n1 += 1
                t2[n1] = v3
            end
        end

        local t3 = {}

        local function v4(p3) -- line: 40
            return p3:HasTag("Sound")
        end

        local n2 = 0

        for v5, v6 in t2 do
            local _ = v5 - 1

            if v6:HasTag("Sound") == true then
                n2 += 1
                t3[n2] = v6
            end
        end

        local t4 = {}

        local function v7(p4) -- line: 53
            -- upvalues: soundAttributesGuard (copy)
            local Attributes = p4:GetAttributes()

            if soundAttributesGuard(Attributes) then
                return {
                    instance = p4,
                    attributes = Attributes
                }
            end
        end

        local n3 = 0

        for v8, v9 in t3 do
            local _ = v8 - 1
            local Attributes = v9:GetAttributes()
            local t5 = if soundAttributesGuard(Attributes) then {
                instance = v9,
                attributes = Attributes
            } else nil

            if t5 ~= nil then
                n3 += 1
                t4[n3] = t5
            end
        end

        local v10

        for v11, v12 in t4 do
            local _ = v11 - 1

            if v12.instance.Name == p1 == true then
                v10 = v12
                break
            end

            v10 = nil
        end

        if not v10 then
            error("[src/client/react/context/config-context.tsx:54]" .. ("Sound %* not found"):format(p1))
        end

        return v10.instance
    end,
    getSoundGroup = function(p5) -- getSoundGroup | line: 89
        -- upvalues: ReplicatedStorage (copy), soundGroupAttributesGuard (copy)
        local Descendants = ReplicatedStorage:GetDescendants()
        local t6 = {}

        local function v13(p6) -- line: 93
            return p6:IsA("SoundGroup")
        end

        local n4 = 0

        for v14, v15 in Descendants do
            local _ = v14 - 1

            if v15:IsA("SoundGroup") == true then
                n4 += 1
                t6[n4] = v15
            end
        end

        local t7 = {}

        local function v16(p7) -- line: 106
            return p7:HasTag("SoundGroup")
        end

        local n5 = 0

        for v17, v18 in t6 do
            local _ = v17 - 1

            if v18:HasTag("SoundGroup") == true then
                n5 += 1
                t7[n5] = v18
            end
        end

        local t8 = {}

        local function v19(p8) -- line: 119
            -- upvalues: soundGroupAttributesGuard (copy)
            local Attributes = p8:GetAttributes()

            if soundGroupAttributesGuard(Attributes) then
                return {
                    instance = p8,
                    attributes = Attributes
                }
            end
        end

        local n6 = 0

        for v20, v21 in t7 do
            local _ = v20 - 1
            local Attributes = v21:GetAttributes()
            local t9 = if soundGroupAttributesGuard(Attributes) then {
                instance = v21,
                attributes = Attributes
            } else nil

            if t9 ~= nil then
                n6 += 1
                t8[n6] = t9
            end
        end

        local v22

        for v23, v24 in t8 do
            local _ = v23 - 1

            if v24.instance.Name == p5 == true then
                v22 = v24
                break
            end

            v22 = nil
        end

        if not v22 then
            error("[src/client/react/context/config-context.tsx:73]" .. ("Sound group %* not found"):format(p5))
        end

        return v22.instance
    end,
    teleportToHome = function() -- teleportToHome | line: 155
    end
}
local v25 = createContext(t1)

return {
    ConfigProvider = function(p9) -- ConfigProvider | line: 159
        -- upvalues: react (copy), v25 (copy)
        local children, configValue = p9.children, p9.configValue

        return react.createElement(v25.Provider, {
            value = configValue
        }, children)
    end,
    useConfig = function() -- useConfig | line: 166
        -- upvalues: useContext (copy), v25 (copy)
        local v26 = useContext(v25)

        if v26 == nil then
            error("[src/client/react/context/config-context.tsx:94]useConfig must be used within a ConfigProvider")
        end

        return v26
    end,
    initialConfig = t1
}
