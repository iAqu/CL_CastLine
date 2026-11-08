-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)
local HalloweenDimension = require(ReplicatedStorage.Shared.Util.HalloweenDimension)
local Hud = require(ReplicatedStorage.Client.Hud)
local LightingController = require(ReplicatedStorage.Controllers.Game.LightingController)
local Trove = require(ReplicatedStorage.Packages.Trove)

require(script.Types)

local LocalPlayer = Players.LocalPlayer
local HalloweenDimension2 = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("HalloweenDimension")
local Sounds = HalloweenDimension2:WaitForChild("Sounds")
local WorldEventVFX = HalloweenDimension2:WaitForChild("WorldEventVFX")
local Attributes, PlayerAttributes = HalloweenDimension.Attributes, HalloweenDimension.PlayerAttributes
local t1 = {
    "Game",
    "Treadmill"
}
local t2 = {}
local t3 = {}

local function dimensionMap() -- line: 46
    -- upvalues: Workspace (copy), HalloweenDimension (copy)
    local v1 = Workspace:FindFirstChild(HalloweenDimension.MapName)

    return if v1 ~= nil and v1:IsA("Model") then v1 else nil
end

local function child(p1, p2, p3) -- line: 51
    local v2 = p1:FindFirstChild(p2)

    assert(v2 ~= nil and v2:IsA(p3), (("%* is missing %* %*"):format(p1:GetFullName(), p3, p2)))

    return v2
end

local function notify(p4, p5) -- line: 58
    -- upvalues: RunService (copy), Workspace (copy), Hud (copy), Attributes (copy), t1 (copy)
    local Attribute = Workspace:GetAttribute(Attributes.WorldEventText)
    local t4 = {}

    for _, v5 in t1 do
        local v6 = Hud.Get("WorldEventNotification", v5)
        local Icon = v6:FindFirstChild("Icon")

        assert(Icon ~= nil and Icon:IsA("ImageLabel"), (("%* is missing ImageLabel Icon"):format((v6:GetFullName()))))
        Icon.Image = p4

        local txt = v6:FindFirstChild("txt")

        assert(txt ~= nil and txt:IsA("TextLabel"), (("%* is missing TextLabel txt"):format((v6:GetFullName()))))

        if type(Attribute) == "string" then
            txt.Text = Attribute
        else
            txt.Text = ""
        end

        local TimerHolder = v6:FindFirstChild("TimerHolder")

        assert(TimerHolder ~= nil and TimerHolder:IsA("GuiObject"), (("%* is missing GuiObject TimerHolder"):format((v6:GetFullName()))))

        local TimerLabel = TimerHolder:FindFirstChild("TimerLabel")

        assert(TimerLabel ~= nil and TimerLabel:IsA("TextLabel"), (("%* is missing TextLabel TimerLabel"):format((TimerHolder:GetFullName()))))
        table.insert(t4, TimerLabel)
        v6.Visible = true
        p5:Add(function() -- line: 67
            -- upvalues: v6 (copy)
            v6.Visible = false
        end)
    end

    local function refresh() -- line: 72
        -- upvalues: t4 (copy), Workspace (copy), Attributes (copy)
        local Attribute = Workspace:GetAttribute(Attributes.WorldEventEndsAt)
        local v17 = math.max(0, (math.ceil(if type(Attribute) == "number" then Attribute - Workspace:GetServerTimeNow() else 0)))

        for _, v18 in t4 do
            v18.Text = string.format("Ends In %d:%02d", v17 // 60, v17 % 60)
        end
    end

    local n1 = 0

    p5:Connect(RunService.Heartbeat, function(p6) -- line: 84
        -- upvalues: refresh (copy), n1 (ref)
        n1 += p6

        if n1 >= 0.2 then
            n1 = 0
            refresh()
        end
    end)
    refresh()
end

local function begin(p7, p8) -- line: 94
    -- upvalues: LightingController (copy), Trove (copy), WorldEventVFX (copy), notify (copy)
    local v19 = Trove.new()

    LightingController.SetLayer("HalloweenWorldEvent", p7.Preset, 160, 2)
    v19:Add(function() -- line: 97
        -- upvalues: LightingController (copy)
        LightingController.ClearLayer("HalloweenWorldEvent", 2)
    end)

    local Sky = p8:FindFirstChild("Sky")

    assert(Sky ~= nil and Sky:IsA("Folder"), (("%* is missing Folder Sky"):format((p8:GetFullName()))))

    local Moon = Sky:FindFirstChild("Moon")

    assert(Moon ~= nil and Moon:IsA("BasePart"), (("%* is missing BasePart Moon"):format((Sky:GetFullName()))))

    local Color = Moon.Color

    Moon.Color = p7.MoonColor
    v19:Add(function() -- line: 104
        -- upvalues: Moon (copy), Color (copy)
        if Moon.Parent ~= nil then
            Moon.Color = Color
        end
    end)
    v19:Clone(WorldEventVFX[p7.Id]).Parent = p8

    local Icon = p7.Icon

    if Icon ~= nil then
        notify(Icon, v19)
    end

    if p7.Bind ~= nil then
        p7.Bind(p8, v19)
    end

    return v19
end

local function eventKey() -- line: 124
    -- upvalues: Workspace (copy), Attributes (copy), t2 (copy)
    local Attribute = Workspace:GetAttribute(Attributes.WorldEvent)
    local v24 = if type(Attribute) == "string" then t2[Attribute] else nil

    return if v24 ~= nil then ("%*:%*"):format(v24.Id, (Workspace:GetAttribute(Attributes.WorldEventEndsAt))) else nil
end

local function playStinger(p9) -- line: 132
    -- upvalues: Audio (copy), Sounds (copy)
    local v25 = Sounds:FindFirstChild(p9.Id .. "Start")

    if v25 ~= nil and v25:IsA("Sound") then
        Audio.Play(v25, script)
    end
end

function t3.Start(p10) -- line: 143
    -- upvalues: Workspace (copy), Audio (copy), HalloweenDimension (copy), LocalPlayer (copy), Sounds (copy), Attributes (copy), PlayerAttributes (copy), t2 (copy), begin (copy)
    local v26, v27
    local Attribute = Workspace:GetAttribute(Attributes.WorldEvent)
    local v28 = if type(Attribute) == "string" then t2[Attribute] else nil
    local v29 = if v28 == nil then nil else ("%*:%*"):format(v28.Id, (Workspace:GetAttribute(Attributes.WorldEventEndsAt)))

    local function stop() -- line: 148
        -- upvalues: v26 (ref), v27 (ref)
        v27 = nil

        local v30 = v26

        v26 = nil

        if v30 ~= nil then
            v30:Destroy()
        end
    end

    local function sync() -- line: 157
        -- upvalues: v26 (ref), v27 (ref), v29 (ref), Workspace (copy), Audio (copy), HalloweenDimension (copy), LocalPlayer (copy), Sounds (copy), Attributes (copy), PlayerAttributes (copy), t2 (copy), begin (copy)
        local v31 = LocalPlayer:GetAttribute(PlayerAttributes.Inside) == true
        local Attribute = Workspace:GetAttribute(Attributes.WorldEvent)
        local v32 = if type(Attribute) == "string" then t2[Attribute] else nil
        local v33 = Workspace:FindFirstChild(HalloweenDimension.MapName)

        if v33 == nil or not v33:IsA("Model") then
            v33 = nil
        end

        local Attribute2 = Workspace:GetAttribute(Attributes.WorldEvent)
        local v34 = if type(Attribute2) == "string" then t2[Attribute2] else nil
        local v35 = if v34 == nil then nil else ("%*:%*"):format(v34.Id, (Workspace:GetAttribute(Attributes.WorldEventEndsAt)))
        local v36 = v35 ~= nil and v35 ~= v29

        v29 = v35

        if not v31 or v32 == nil or v33 == nil then
            v35 = nil
        end

        if v35 == v27 then
            return
        end

        v27 = nil

        local v37 = v26

        v26 = nil

        if v37 ~= nil then
            v37:Destroy()
        end

        if v35 == nil or v32 == nil or v33 == nil then
            return
        end

        v27 = v35
        v26 = begin(v32, v33)

        if v36 then
            local v38 = Sounds:FindFirstChild(v32.Id .. "Start")

            if v38 ~= nil and v38:IsA("Sound") then
                Audio.Play(v38, script)
            end
        end
    end

    p10:Connect(LocalPlayer:GetAttributeChangedSignal(PlayerAttributes.Inside), sync)
    p10:Connect(Workspace:GetAttributeChangedSignal(Attributes.WorldEvent), sync)
    p10:Connect(Workspace:GetAttributeChangedSignal(Attributes.WorldEventEndsAt), sync)
    p10:Add(stop)
    sync()
end

for _, child in script.Events:GetChildren() do
    assert(child:IsA("ModuleScript"), (("%* must be a ModuleScript"):format((child:GetFullName()))))

    local v40 = require(child)

    assert(v40.Id == child.Name, (("%* declares Id %*"):format(child:GetFullName(), v40.Id)))
    assert(LightingController.Presets[v40.Preset] ~= nil, (("Lighting preset %* is missing"):format(v40.Preset)))
    assert(Sounds:FindFirstChild(v40.Id) ~= nil, (("HalloweenDimension sound %* is missing"):format(v40.Id)))
    assert(WorldEventVFX:FindFirstChild(v40.Id) ~= nil, (("HalloweenDimension world event VFX %* is missing"):format(v40.Id)))
    t2[v40.Id] = v40
end

return t3
