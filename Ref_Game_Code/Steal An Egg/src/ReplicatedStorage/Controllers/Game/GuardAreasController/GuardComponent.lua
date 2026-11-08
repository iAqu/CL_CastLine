-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local t = require(ReplicatedStorage.Packages.t)
local GuardWakeLookAt = require(script.Parent.GuardWakeLookAt)
local Log = require(ReplicatedStorage.Packages.Log)
local Trove = require(ReplicatedStorage.Packages.Trove)
local WaitFor = require(ReplicatedStorage.Packages.WaitFor)
local v1 = Log.new()
local t1 = {}

t1.__index = t1
t1.__class = "GuardComponent"

local v2 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, true)
local v3 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v4 = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v5 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

function t1.new(p1) -- line: 53
    -- upvalues: t (copy), GuardWakeLookAt (copy), Trove (copy), WaitFor (copy), t1 (copy)
    t.strict(t.instanceIsA("Model"))(p1)

    local self = setmetatable({}, t1)
    local Guard = p1:WaitForChild("Guard")

    assert(Guard:IsA("Model"), (("%*.Guard must be a Model"):format((p1:GetFullName()))))

    local v8, v9 = WaitFor.Descendant(Guard, "Head"):await()

    assert(v8 and v9 ~= nil, (("%* requires a Head descendant for alert GUI"):format((Guard:GetFullName()))))
    assert(v9:IsA("BasePart"), (("%* must be a BasePart"):format((v9:GetFullName()))))

    local HumanoidRootPart

    if p1.Name == "Forest" then
        HumanoidRootPart = Guard:WaitForChild("HumanoidRootPart")
        assert(HumanoidRootPart, (("%* requires a HumanoidRootPart descendant for Forest shake effects"):format((Guard:GetFullName()))))
        assert(HumanoidRootPart:IsA("BasePart"), (("%* must be a BasePart"):format((HumanoidRootPart:GetFullName()))))
    end

    local v15, v16 = WaitFor.Descendant(v9, "AlertGui"):await()

    assert(v15 and v16 and v16:IsA("BillboardGui"), (("%* requires an AlertGui descendant"):format((v9:GetFullName()))))
    self._alertGuiTemplate = v16
    self._alertGui = nil
    self._guardModel = Guard
    self._head = v9
    self._lastAlertAt = (-1e999)
    self._root = HumanoidRootPart
    self._sleepColorTrove = Trove.new()
    self._trove = Trove.new()

    if not Guard:GetAttribute("HeadLookAtDisabled") then
        self._wakeLookAt = GuardWakeLookAt.new(Guard)
    end

    self._trove:Add(self._sleepColorTrove)
    self._trove:Add(Guard:GetAttributeChangedSignal("TargetPlayer"):Connect(function() -- line: 100
        -- upvalues: self (copy)
        self:_updateTargetAlert()
    end))
    self._trove:Add(Guard:GetAttributeChangedSignal("Sleeping"):Connect(function() -- line: 102
        -- upvalues: self (copy), Guard (copy)
        self:_applySleepVfx()

        if Guard:GetAttribute("Sleeping") == true then
            self:_clearAlert()
        end
    end))
    self._trove:Add(Guard:GetAttributeChangedSignal("GuardState"):Connect(function() -- line: 108
        -- upvalues: self (copy)
        self:_applySleepVfx()
        self:_applyGuardStatePresentation()
    end))
    self._trove:Add(Guard:GetAttributeChangedSignal("WakeTargetPlayer"):Connect(function() -- line: 115
        -- upvalues: self (copy)
        self:_applyGuardStatePresentation()
    end))
    self._trove:Add(Guard:GetAttributeChangedSignal("Hidden"):Connect(function() -- line: 120
        -- upvalues: self (copy)
        self:_applySleepVfx()
    end))
    self:_applySleepVfx()
    self:_applyGuardStatePresentation()
    self:_updateTargetAlert()

    local v19 = false

    self._trove:Add(Guard.DescendantAdded:Connect(function(p2) -- line: 127
        -- upvalues: self (copy), v19 (ref)
        if p2:IsA("BasePart") then
            task.delay(1, function() -- line: 131
                -- upvalues: self (copy), v19 (ref)
                if not v19 then
                    v19 = true
                    self:_applyGuardStatePresentation()
                    task.wait(1)
                    v19 = false
                end
            end)
        end
    end))

    return self
end

function t1:_updateTargetAlert() -- line: 148
    local TargetPlayer = self._guardModel:GetAttribute("TargetPlayer")

    if typeof(TargetPlayer) == "string" and TargetPlayer ~= "" then
        local elapsed = os.clock()

        if not (elapsed - self._lastAlertAt < 3) then
            self._lastAlertAt = elapsed
            self:_showAlert()
        end
    end
end

function t1:_applySleepVfx() -- line: 163
    -- upvalues: v1 (copy)
    local v20 = self._guardModel:GetAttribute("GuardState") == "Sleeping" and self._guardModel:GetAttribute("Hidden") ~= true
    local v21 = self._guardModel:FindFirstChild("SleepVFXAttachment", true)

    if not v21 then
        v1:AtWarning():Log((("Guard model %* is missing SleepVFXAttachment"):format((self._guardModel:GetFullName()))))

        return
    end

    for _, descendant in ipairs(v21:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            descendant.Enabled = v20

            if not v20 then
                descendant:Clear()
            end
        end
    end
end

function t1:_applyGuardStatePresentation() -- line: 184
    -- upvalues: t (copy)
    local GuardState = self._guardModel:GetAttribute("GuardState")
    local WakeTargetPlayer = self._guardModel:GetAttribute("WakeTargetPlayer")

    t.strict(t.optional(t.string))(WakeTargetPlayer)

    if self._wakeLookAt then
        local _wakeLookAt = self._wakeLookAt
        local v22 = GuardState == "Waking"

        if WakeTargetPlayer == "" then
            WakeTargetPlayer = nil
        end

        _wakeLookAt:SetWaking(v22, WakeTargetPlayer)
    end

    if GuardState == "Sleeping" then
        self:_applySleepDetailColors()
    elseif GuardState == "Waking" then
        self:_animateSleepDetailColorsToOriginal()
    end
end

function t1:_applySleepDetailColors() -- line: 207
    self._sleepColorTrove:Clean()

    for _, descendant in ipairs(self._guardModel:GetDescendants()) do
        if descendant:IsA("BasePart") then
            local SleepColor = descendant:GetAttribute("SleepColor")

            if SleepColor then
                if descendant:GetAttribute("OriginalColor") == nil then
                    descendant:SetAttribute("OriginalColor", descendant.Color)
                end

                descendant.Color = SleepColor
            end
        end
    end
end

function t1:_animateSleepDetailColorsToOriginal() -- line: 227
    self._sleepColorTrove:Clean()

    for _, descendant in ipairs(self._guardModel:GetDescendants()) do
        if descendant:IsA("BasePart") and descendant:GetAttribute("SleepColor") then
            local OriginalColor = descendant:GetAttribute("OriginalColor")

            if OriginalColor == nil then
                OriginalColor = descendant.Color
                descendant:SetAttribute("OriginalColor", OriginalColor)
            end

            assert(OriginalColor, "luau")
            descendant.Color = OriginalColor
        end
    end
end

function t1:_clearAlert() -- line: 245
    local _alertGui = self._alertGui

    if _alertGui ~= nil then
        self._alertGui = nil
        _alertGui:Destroy()
    end
end

function t1:_showAlert() -- line: 255
    -- upvalues: TweenService (copy), v1 (copy), v3 (copy), v4 (copy), v5 (copy)
    if self._alertGui ~= nil then
        return
    end

    local clone = self._alertGuiTemplate:Clone()
    local v23 = assert(clone:FindFirstChildWhichIsA("ImageLabel"))

    v23.Transparency = 1
    clone.AlwaysOnTop = true
    clone.Enabled = true
    clone.Parent = self._head
    self._alertGui = clone
    self._trove:Add(clone)
    TweenService:Create(v23, v3, {
        ImageTransparency = 0
    }):Play()

    local tween = TweenService:Create(clone, v4, {
        StudsOffset = clone.StudsOffset + Vector3.new(0, 1, 0) * math.max(clone.StudsOffset.Y * 0.6, 1)
    })

    tween.Completed:Once(function() -- line: 274
        -- upvalues: v23 (copy), TweenService (copy), v5 (copy)
        task.wait(1)
        TweenService:Create(v23, v5, {
            ImageTransparency = 1
        }):Play()
    end)
    tween:Play()
    task.delay(3, function() -- line: 280
        -- upvalues: self (copy), clone (copy)
        if clone.Parent ~= nil then
            if self._alertGui == clone then
                self._alertGui = nil
            end

            clone:Destroy()
        end
    end)
    v1:AtTrace():Log((("Guard alert shown for %*"):format((self._guardModel:GetFullName()))))
end

function t1:Destroy() -- line: 298
    if self._wakeLookAt then
        self._wakeLookAt:Destroy()
    end

    self._trove:Destroy()
end

function t1:GetGuardModel() -- line: 305
    return self._guardModel
end

function t1:PlayWakeUp() -- line: 307
    -- upvalues: Debris (copy), TweenService (copy), v2 (copy)
    local Highlight = Instance.new("Highlight")

    Highlight.Name = "GuardWakeHighlight"
    Highlight.FillColor = Color3.fromRGB(255, 0, 0)
    Highlight.OutlineColor = Color3.fromRGB(132, 0, 0)
    Highlight.FillTransparency = 1
    Highlight.OutlineTransparency = 1
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    Highlight.Parent = self._guardModel
    TweenService:Create(Highlight, v2, {
        FillTransparency = 0.35,
        OutlineTransparency = 0
    }):Play()
    Debris:AddItem(Highlight, v2.Time * 2 + 0.05)
end

return t1
