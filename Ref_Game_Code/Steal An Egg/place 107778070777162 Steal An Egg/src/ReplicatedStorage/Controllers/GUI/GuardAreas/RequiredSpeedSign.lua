-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)
local TreadmillUtil = require(ReplicatedStorage.Shared.Util.TreadmillUtil)
local Trove = require(ReplicatedStorage.Packages.Trove)
local t1 = {}

t1.__index = t1
t1.__class = "RequiredSpeedSign"

local v1 = Color3.fromRGB(0, 255, 0)
local v2 = Color3.fromRGB(153, 255, 0)
local v3 = Color3.fromRGB(255, 170, 0)
local v4 = Color3.fromRGB(255, 0, 0)

function t1.new(p1) -- line: 44
    -- upvalues: t (copy), Trove (copy), t1 (copy)
    t.strict(t.instanceIsA("Model"))(p1)

    local self = setmetatable({}, t1)

    self._areaModel = p1
    self._color = Color3.new(1, 1, 1)
    self._text = "Loading..."
    self._trove = Trove.new()
    self._trove:Add(p1.DescendantAdded:Connect(function() -- line: 53
        -- upvalues: self (copy)
        self:_render()
    end))
    self:_render()

    return self
end

function t1:_render() -- line: 65
    local RequiredSpeedSign = self._areaModel:FindFirstChild("RequiredSpeedSign")
    local Main = if RequiredSpeedSign then RequiredSpeedSign:FindFirstChild("Main") else nil
    local SurfaceGui = if Main then Main:FindFirstChild("SurfaceGui") else nil
    local Required, Info

    if SurfaceGui then
        Info = SurfaceGui:FindFirstChild("Info")
        Required = SurfaceGui:FindFirstChild("Required")
    end

    local Speed = if Required then Required:FindFirstChild("Speed") else nil

    if Info and Info:IsA("TextLabel") then
        Info.TextColor3 = self._color
    end

    if Speed and Speed:IsA("TextLabel") then
        Speed.Text = self._text
        Speed.TextColor3 = self._color
    end
end

function t1:SetLoading() -- line: 83
    self._text = "Loading..."
    self._color = Color3.new(1, 1, 1)
    self:_render()
end

function t1:SetSlowdownTolerance(p5) -- line: 89
    -- upvalues: t (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy)
    t.strict(t.number)(p5)

    if p5 < 0.03 then
        self._color = v4
    elseif p5 < 0.1 then
        self._color = v3:Lerp(v2, (p5 - 0.03) / 0.07)
    elseif p5 < 0.4 then
        self._color = v2:Lerp(v1, (p5 - 0.1) / 0.30000000000000004)
    else
        self._color = v1
    end

    self:_render()
end

function t1:SetSpeedPowerRequirement(p7) -- line: 119
    -- upvalues: t (copy), TreadmillUtil (copy)
    t.strict(t.number)(p7)

    local v6 = p7

    if p7 > 0 then
        local v8 = 10 ^ (math.floor((math.log10(p7))) - 1)

        v6 = math.round(p7 / v8) * v8
    end

    self._text = TreadmillUtil.FormatSpeedPower(v6)
    self:_render()
end

function t1:Destroy() -- line: 132
    self._trove:Destroy()
end

return t1
