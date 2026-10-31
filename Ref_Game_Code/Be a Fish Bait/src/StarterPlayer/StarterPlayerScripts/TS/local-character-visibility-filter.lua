-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 8
        return "LocalCharacterVisibilityFilter"
    end
})

self.__index = self

function self.new(...) -- line: 13
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2) -- line: 17
    -- upvalues: Players (copy)
    p1._allowedUserIds = {}
    p1._connections = {}
    p1._characterConnections = {}
    p1._descendantConnections = {}
    p1._parts = {}
    p1._textures = {}
    p1._toggleVisuals = {}
    p1._humanoids = {}
    p1._sounds = {}
    p1._destroyed = false

    local _connections = p1._connections
    local connection = Players.PlayerAdded:Connect(function(p3) -- line: 29
        -- upvalues: p1 (copy)
        return p1:_watchPlayer(p3)
    end)
    local connection2 = Players.PlayerRemoving:Connect(function(p4) -- line: 32
        -- upvalues: p1 (copy)
        return p1:_unwatchPlayer(p4)
    end)

    table.insert(_connections, connection)
    table.insert(_connections, connection2)

    for _, player in Players:GetPlayers() do
        p1:_watchPlayer(player)
    end

    p1:setAllowedUserIds(p2)
end

function self.setAllowedUserIds(p5, p6) -- line: 44
    -- upvalues: Players (copy)
    if p5._destroyed then
        return nil
    end

    p5:_restoreAll()
    table.clear(p5._allowedUserIds)
    p5._allowedUserIds[Players.LocalPlayer.UserId] = true

    for _, v3 in p6 do
        p5._allowedUserIds[v3] = true
    end

    for _, player in Players:GetPlayers() do
        p5:_applyPlayer(player)
    end
end

function self.destroy(p7) -- line: 60
    if p7._destroyed then
        return nil
    end

    p7._destroyed = true

    for _, v4 in p7._connections do
        v4:Disconnect()
    end

    for _, v5 in p7._characterConnections do
        v5:Disconnect()
    end

    for _, v6 in p7._descendantConnections do
        v6:Disconnect()
    end

    table.clear(p7._connections)
    table.clear(p7._characterConnections)
    table.clear(p7._descendantConnections)
    p7:_restoreAll()
end

function self._watchPlayer(p8, p9) -- line: 79
    if p8._characterConnections[p9] ~= nil then
        return nil
    end

    p8._characterConnections[p9] = p9.CharacterAdded:Connect(function() -- line: 87
        -- upvalues: p8 (copy), p9 (copy)
        task.defer(function() -- line: 88
            -- upvalues: p8 (copy), p9 (copy)
            return p8:_applyPlayer(p9)
        end)
    end)
    p8:_applyPlayer(p9)
end

function self._unwatchPlayer(p10, p11) -- line: 95
    local v7 = p10._characterConnections[p11]

    if v7 ~= nil then
        v7:Disconnect()
    end

    p10._characterConnections[p11] = nil
end

function self._applyPlayer(p12, p13) -- line: 106
    if p12._destroyed or p12._allowedUserIds[p13.UserId] ~= nil then
        return nil
    end

    local Character = p13.Character

    if not Character then
        return nil
    end

    p12:_hideCharacter(Character)

    if p12._descendantConnections[Character] ~= nil then
        return
    end

    p12._descendantConnections[Character] = Character.DescendantAdded:Connect(function(p14) -- line: 123
        -- upvalues: p12 (copy), p13 (copy)
        if p12._allowedUserIds[p13.UserId] == nil then
            p12:_hideInstance(p14)
        end
    end)
end

function self._hideCharacter(p15, p16) -- line: 133
    for _, descendant in p16:GetDescendants() do
        p15:_hideInstance(descendant)
    end
end

function self._hideInstance(p17, p18) -- line: 138
    if p18:IsA("BasePart") then
        if p17._parts[p18] == nil then
            p17._parts[p18] = p18.LocalTransparencyModifier
        end

        p18.LocalTransparencyModifier = 1
    elseif p18:IsA("Decal") or p18:IsA("Texture") then
        if p17._textures[p18] == nil then
            p17._textures[p18] = p18.Transparency
        end

        p18.Transparency = 1
    elseif not p18:IsA("BillboardGui") and not p18:IsA("SurfaceGui") and not p18:IsA("ParticleEmitter") and not p18:IsA("Beam") and not p18:IsA("Trail") and not p18:IsA("Highlight") then
        if p18:IsA("Humanoid") then
            if p17._humanoids[p18] == nil then
                p17._humanoids[p18] = p18.DisplayDistanceType
            end

            p18.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        elseif p18:IsA("Sound") then
            if p17._sounds[p18] == nil then
                p17._sounds[p18] = p18.Volume
            end

            p18.Volume = 0
        end
    else
        if p17._toggleVisuals[p18] == nil then
            p17._toggleVisuals[p18] = p18.Enabled
        end

        p18.Enabled = false
    end
end

function self._restoreAll(p19) -- line: 191
    for v8, v9 in p19._parts do
        if v8.Parent ~= nil then
            v8.LocalTransparencyModifier = v9
        end
    end

    for v10, v11 in p19._textures do
        if v10.Parent ~= nil then
            v10.Transparency = v11
        end
    end

    for v12, v13 in p19._toggleVisuals do
        if v12.Parent ~= nil then
            v12.Enabled = v13
        end
    end

    for v14, v15 in p19._humanoids do
        if v14.Parent ~= nil then
            v14.DisplayDistanceType = v15
        end
    end

    for v16, v17 in p19._sounds do
        if v16.Parent ~= nil then
            v16.Volume = v17
        end
    end

    table.clear(p19._parts)
    table.clear(p19._textures)
    table.clear(p19._toggleVisuals)
    table.clear(p19._humanoids)
    table.clear(p19._sounds)
end

return {
    LocalCharacterVisibilityFilter = self
}
