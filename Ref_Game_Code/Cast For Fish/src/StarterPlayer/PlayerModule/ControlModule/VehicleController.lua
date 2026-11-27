-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local VehicleContext = script.Parent.Parent:WaitForChild("InputContexts"):WaitForChild("VehicleContext")
local ThrottleAction = VehicleContext:WaitForChild("ThrottleAction")
local SteerAction = VehicleContext:WaitForChild("SteerAction")

require(script.Parent.Parent:WaitForChild("CommonUtils")).get("FlagUtil")

local t1 = {}

t1.__index = t1

function t1.new() -- line: 23
    -- upvalues: t1 (copy)
    local self = setmetatable({}, t1)

    self.enabled = false
    self.vehicleSeat = nil

    return self
end

function t1:Enable(p2, p3) -- line: 32
    -- upvalues: VehicleContext (copy)
    if p2 ~= self.enabled or p3 ~= self.vehicleSeat then
        self.enabled = p2

        if p2 then
            if p3 then
                self.vehicleSeat = p3
                VehicleContext.Enabled = true
            end
        else
            VehicleContext.Enabled = false
            self.vehicleSeat = nil
        end
    end
end

function t1:Update(p5, p6) -- line: 53
    -- upvalues: ThrottleAction (copy), SteerAction (copy)
    if not self.vehicleSeat then
        return p5, false
    end

    if p6 then
        local State = ThrottleAction:GetState()
        local v3 = p5 + Vector3.new(SteerAction:GetState(), 0, -State)

        self.vehicleSeat.ThrottleFloat = -v3.Z
        self.vehicleSeat.SteerFloat = v3.X

        return v3, true
    end

    local v4 = self.vehicleSeat.Occupant.RootPart.CFrame:VectorToObjectSpace(p5)

    self.vehicleSeat.ThrottleFloat = self:ComputeThrottle(v4)
    self.vehicleSeat.SteerFloat = self:ComputeSteer(v4)

    return Vector3.new(0, 0, 0), true
end

function t1.ComputeThrottle(_, p8) -- line: 80
    if p8 == Vector3.new(0, 0, 0) then
        return 0
    end

    return -p8.Z
end

function t1.ComputeSteer(_, p10) -- line: 88
    if p10 == Vector3.new(0, 0, 0) then
        return 0
    end

    return -math.atan2(-p10.x, -p10.z) * 57.29577951308232
end

return t1
