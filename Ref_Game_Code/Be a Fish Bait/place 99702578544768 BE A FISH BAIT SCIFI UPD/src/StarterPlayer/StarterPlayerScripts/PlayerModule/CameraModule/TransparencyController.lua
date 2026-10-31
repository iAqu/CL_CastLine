-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local VRService = game:GetService("VRService")
local t1 = {
    "BasePart",
    "Decal",
    "Beam",
    "ParticleEmitter",
    "Trail",
    "Fire",
    "Smoke",
    "Sparkles",
    "Explosion"
}
local CameraUtils = require(script.Parent:WaitForChild("CameraUtils"))
local t2 = {}

t2.__index = t2

function t2.new() -- line: 29
    -- upvalues: t2 (copy)
    local self = setmetatable({}, t2)

    self.transparencyDirty = false
    self.enabled = false
    self.lastTransparency = nil
    self.descendantAddedConn = nil
    self.descendantRemovingConn = nil
    self.toolDescendantAddedConns = {}
    self.toolDescendantRemovingConns = {}
    self.cachedParts = {}

    return self
end

function t2:HasToolAncestor(p2) -- line: 45
    if p2.Parent == nil then
        return false
    end

    assert(p2.Parent, "")

    return p2.Parent:IsA("Tool") or self:HasToolAncestor(p2.Parent)
end

function t2:IsValidPartToModify(p4) -- line: 51
    -- upvalues: t1 (copy)
    for _, v2 in t1 do
        if p4:IsA(v2) then
            return not self:HasToolAncestor(p4)
        end
    end

    return false
end

function t2:CachePartsRecursive(p6) -- line: 61
    if not p6 then
        return
    end

    if self:IsValidPartToModify(p6) then
        self.cachedParts[p6] = true
        self.transparencyDirty = true
    end

    for _, child in pairs(p6:GetChildren()) do
        self:CachePartsRecursive(child)
    end
end

function t2:TeardownTransparency() -- line: 73
    for v3, _ in pairs(self.cachedParts) do
        v3.LocalTransparencyModifier = 0
    end

    self.cachedParts = {}
    self.transparencyDirty = true
    self.lastTransparency = nil

    if self.descendantAddedConn then
        self.descendantAddedConn:disconnect()
        self.descendantAddedConn = nil
    end

    if self.descendantRemovingConn then
        self.descendantRemovingConn:disconnect()
        self.descendantRemovingConn = nil
    end

    for v4, v5 in pairs(self.toolDescendantAddedConns) do
        v5:Disconnect()
        self.toolDescendantAddedConns[v4] = nil
    end

    for v6, v7 in pairs(self.toolDescendantRemovingConns) do
        v7:Disconnect()
        self.toolDescendantRemovingConns[v6] = nil
    end
end

function t2:SetupTransparency(p9) -- line: 99
    self:TeardownTransparency()

    if self.descendantAddedConn then
        self.descendantAddedConn:disconnect()
    end

    self.descendantAddedConn = p9.DescendantAdded:Connect(function(p10) -- line: 103
        -- upvalues: self (copy), p9 (copy)
        if self:IsValidPartToModify(p10) then
            self.cachedParts[p10] = true
            self.transparencyDirty = true
        elseif p10:IsA("Tool") then
            if self.toolDescendantAddedConns[p10] then
                self.toolDescendantAddedConns[p10]:Disconnect()
            end

            self.toolDescendantAddedConns[p10] = p10.DescendantAdded:Connect(function(p11) -- line: 111
                -- upvalues: self (copy)
                self.cachedParts[p11] = nil

                if p11:IsA("BasePart") or p11:IsA("Decal") then
                    p11.LocalTransparencyModifier = 0
                end
            end)

            if self.toolDescendantRemovingConns[p10] then
                self.toolDescendantRemovingConns[p10]:disconnect()
            end

            self.toolDescendantRemovingConns[p10] = p10.DescendantRemoving:Connect(function(p12) -- line: 119
                -- upvalues: self (copy), p9 (copy)
                wait()

                if p9 and p12 and p12:IsDescendantOf(p9) and self:IsValidPartToModify(p12) then
                    self.cachedParts[p12] = true
                    self.transparencyDirty = true
                end
            end)
        end
    end)

    if self.descendantRemovingConn then
        self.descendantRemovingConn:disconnect()
    end

    self.descendantRemovingConn = p9.DescendantRemoving:connect(function(p13) -- line: 131
        -- upvalues: self (copy)
        if self.cachedParts[p13] then
            self.cachedParts[p13] = nil
            p13.LocalTransparencyModifier = 0
        end
    end)
    self:CachePartsRecursive(p9)
end

function t2:Enable(p15) -- line: 142
    if self.enabled ~= p15 then
        self.enabled = p15
    end
end

function t2.SetSubject(p16, p17) -- line: 148
    local Parent

    if p17 then
        if p17:IsA("Humanoid") then
            Parent = p17.Parent
        end

        if p17:IsA("VehicleSeat") and p17.Occupant then
            Parent = p17.Occupant.Parent
        end
    end

    if Parent then
        p16:SetupTransparency(Parent)
    else
        p16:TeardownTransparency()
    end
end

function t2:Update(p19) -- line: 163
    -- upvalues: VRService (copy), CameraUtils (copy)
    local CurrentCamera = workspace.CurrentCamera

    if not (CurrentCamera and self.enabled) then
        return
    end

    local magnitude = (CurrentCamera.Focus.p - CurrentCamera.CoordinateFrame.p).magnitude
    local v8 = magnitude < 2 and 1 - (magnitude - 0.5) / 1.5 or 0

    if v8 < 0.5 then
        v8 = 0
    end

    if self.lastTransparency and v8 < 1 and self.lastTransparency < 0.95 then
        local v9 = v8 - self.lastTransparency
        local v10 = 2.8 * p19
        local v12 = math.clamp(v9, -v10, v10)

        v8 = self.lastTransparency + v12
    else
        self.transparencyDirty = true
    end

    local v14 = math.clamp(CameraUtils.Round(v8, 2), 0, 1)

    if not self.transparencyDirty and self.lastTransparency == v14 then
        return
    end

    for v15, _ in pairs(self.cachedParts) do
        if VRService.VREnabled and VRService.AvatarGestures then
            local t4 = {
                [Enum.AccessoryType.Hat] = true,
                [Enum.AccessoryType.Hair] = true,
                [Enum.AccessoryType.Face] = true,
                [Enum.AccessoryType.Eyebrow] = true,
                [Enum.AccessoryType.Eyelash] = true
            }

            if v15.Parent:IsA("Accessory") and t4[v15.Parent.AccessoryType] or v15.Name == "Head" then
                v15.LocalTransparencyModifier = v14
            else
                v15.LocalTransparencyModifier = 0
            end
        else
            v15.LocalTransparencyModifier = v14
        end
    end

    self.transparencyDirty = false
    self.lastTransparency = v14
end

return t2
