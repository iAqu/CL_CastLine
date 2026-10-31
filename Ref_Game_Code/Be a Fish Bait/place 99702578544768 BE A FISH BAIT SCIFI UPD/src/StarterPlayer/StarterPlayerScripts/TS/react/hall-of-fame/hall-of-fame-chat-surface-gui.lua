-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useBinding, useEffect = react.useBinding, react.useEffect
local createPortal = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react-roblox").createPortal
local RunService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").RunService
local hallOfFameChatMessagesData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "hall-of-fame-chat-messages").hallOfFameChatMessagesData
local default = RuntimeLib.import(script, script.Parent, "hall-of-fame-chat-message-row").default

local function useScrollOffset(p1) -- line: 24
    -- upvalues: useBinding (copy), useEffect (copy), RunService (copy)
    local v1, v2 = useBinding(0)

    useEffect(function() -- line: 26
        -- upvalues: p1 (copy), v2 (copy), RunService (copy)
        if p1 == 0 then
            return nil
        end

        local n1 = 0
        local connection = RunService.Heartbeat:Connect(function(p2) -- line: 31
            -- upvalues: n1 (ref), p1 (copy), v2 (copy)
            n1 = (n1 + 18 * p2) % p1
            v2(n1)
        end)

        return function() -- line: 35
            -- upvalues: connection (copy)
            return connection:Disconnect()
        end
    end, { p1, v2 })

    return v1
end

local function useWrappedRowPosition(p3, p4, p5) -- line: 51
    return p4:map(function(p6) -- line: 52
        -- upvalues: p3 (copy), p5 (copy)
        local v4 = ((p3 - p6) % p5 + p5) % p5

        return UDim2.fromOffset(0, v4)
    end)
end

local HallOfFameChatMessageRowSlot

local function HallOfFameChatSurfaceGui(p7) -- line: 59
    -- upvalues: react (copy), createPortal (copy), hallOfFameChatMessagesData (copy), useScrollOffset (copy), HallOfFameChatMessageRowSlot (ref)
    local boardPart = p7.boardPart
    local v5 = #hallOfFameChatMessagesData
    local v6 = v5 * 144
    local v7 = useScrollOffset(v6)

    if v5 == 0 then
        return nil
    end

    local v8 = react.createElement("uipadding", {
        PaddingLeft = UDim.new(0, 20),
        PaddingRight = UDim.new(0, 20)
    })
    local v9 = table.create(#hallOfFameChatMessagesData)

    for v10, v11 in hallOfFameChatMessagesData do
        local v12 = v10 - 1

        v9[v10] = react.createElement(HallOfFameChatMessageRowSlot, {
            baseY = v12 * 144,
            key = v11.id,
            message = v11,
            offset = v7,
            totalHeightPixels = v6
        })
    end

    return createPortal(react.createElement("surfacegui", {
        LightInfluence = 0,
        PixelsPerStud = 50,
        ResetOnSpawn = false,
        Adornee = boardPart,
        Face = Enum.NormalId.Front,
        SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    }, react.createElement("frame", {
        BackgroundTransparency = 0.25,
        ClipsDescendants = true,
        BackgroundColor3 = Color3.fromRGB(10, 10, 15),
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }, v8, v9))), boardPart)
end

function HallOfFameChatMessageRowSlot(p8) -- line: 103
    -- upvalues: react (copy), default (copy)
    local baseY, message, offset, totalHeightPixels = p8.baseY, p8.message, p8.offset, p8.totalHeightPixels
    local v13 = offset:map(function(p9) -- line: 52
        -- upvalues: baseY (copy), totalHeightPixels (copy)
        local v14 = ((baseY - p9) % totalHeightPixels + totalHeightPixels) % totalHeightPixels

        return UDim2.fromOffset(0, v14)
    end)

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        Position = v13,
        Size = UDim2.new(1, 0, 0, 130)
    }, react.createElement(default, {
        rowHeight = 130,
        message = message
    }))
end

return {
    default = HallOfFameChatSurfaceGui
}
