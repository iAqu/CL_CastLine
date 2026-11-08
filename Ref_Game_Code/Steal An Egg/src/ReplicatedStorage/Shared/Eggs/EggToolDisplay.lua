-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ModelBounds = require(ReplicatedStorage.Shared.Utils.ModelBounds)
local EggRenderer = require(script.Parent.EggRenderer)
local Log = require(ReplicatedStorage.Packages.Log)
local ParasiteVisual = require(script.Parent.ParasiteVisual)
local Trove = require(ReplicatedStorage.Packages.Trove)
local t = require(ReplicatedStorage.Packages.t)

require(script.Parent.Types)

local v1 = Log.new()
local t1 = {}

t1.__index = t1
t1.__class = "EggToolDisplay"

function t1.new(p1, p2) -- line: 40
    -- upvalues: EggRenderer (copy), Trove (copy), t (copy), v1 (copy), t1 (copy)
    t.strict(t.instanceIsA("Tool"))(p1)

    local self = setmetatable({}, t1)

    self._trove = Trove.new()
    self._tool = p1
    self._renderResult = EggRenderer.RenderVisual(p2, p1)
    self:_init()
    v1:AtDebug():Log((("Attached egg tool display for %*"):format(p2.UID)))

    return self
end

local function getStringAttribute(p3, p4) -- line: 57
    local Attribute = p3:GetAttribute(p4)

    return if typeof(Attribute) == "string" and Attribute ~= "" then Attribute else nil
end

local function positionModel(p5, p6) -- line: 62
    -- upvalues: ModelBounds (copy)
    local Handle = p5:WaitForChild("Handle")

    assert(Handle:IsA("BasePart"), (("Missing egg tool handle for %*"):format((p5:GetFullName()))))

    local Model = p6.Model
    local Pivot = Model:GetPivot()
    local v4, v5 = ModelBounds(Model)
    local v6 = (v4 * CFrame.new(0, v5.Y * -0.5, v5.Z * 0.1)):ToObjectSpace(Pivot)

    Model:PivotTo(Handle.CFrame * v6)

    return Handle
end

function t1:IsEggTool() -- line: 81
    -- upvalues: t (copy)
    t.strict(t.instanceIsA("Tool"))(self)

    return self:GetAttribute("ItemType") == "AssetEgg"
end

function t1:GetToolUid() -- line: 86
    -- upvalues: t (copy)
    t.strict(t.instanceIsA("Tool"))(self)

    local UID = self:GetAttribute("UID")

    return if typeof(UID) == "string" and UID ~= "" then UID else nil
end

function t1:Destroy() -- line: 91
    self._trove:Destroy()
end

function t1:SyncParasite(p11) -- line: 93
    -- upvalues: ParasiteVisual (copy)
    ParasiteVisual.Attach(self._renderResult.Model, p11)
end

function t1:_init() -- line: 101
    -- upvalues: positionModel (copy)
    self._trove:Add(self._renderResult.Model)

    local v7 = positionModel(self._tool, self._renderResult)
    local v8 = self._renderResult.VisibleParts[1]
    local Motor6D

    if v7.Anchored then
        Motor6D = Instance.new("Motor6D")
        Motor6D.C0 = v8.CFrame:ToObjectSpace(v7.CFrame)
    else
        Motor6D = Instance.new("WeldConstraint")
    end

    Motor6D.Part0 = v8
    Motor6D.Part1 = v7
    Motor6D.Parent = v8
    self._trove:Add(Motor6D)
end

return t1
