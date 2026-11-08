-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Codec = require(script.Parent.Codec)
local Environment = require(ReplicatedStorage.Shared.Modules.Environment)
local Promise = require(ReplicatedStorage.Packages.Promise)
local Renderer = require(script.Parent.Renderer)
local StaffTagFlags = require(ReplicatedStorage.Shared.Flags.StaffTagFlags)
local Trove = require(ReplicatedStorage.Packages.Trove)
local v1 = table.freeze({
    [11907795] = true,
    [3871388597] = true
})
local Parent = script.Parent

assert(Parent:IsA("ScreenGui"), "OverlayDisplay must belong to a ScreenGui")

local Frame = Parent:FindFirstChild("Frame")

if not (Frame and Frame:IsA("GuiObject")) then
    Frame = nil
end

Parent.Enabled = false
Renderer.clear(Parent)

if Frame then
    Frame.Visible = false
end

if not Environment.IsDevPlace() and not Environment.IsTestPlace() then
    return
end

Parent.ResetOnSpawn = false
Parent.IgnoreGuiInset = true
Parent.ScreenInsets = Enum.ScreenInsets.None
Parent.SafeAreaCompatibility = Enum.SafeAreaCompatibility.None
Parent.ClipToDeviceSafeArea = false

local v2 = Trove.new()
local v3 = v2:Extend()
local v4 = v2:Extend()
local v5 = ""
local v6 = RunService:IsStudio()

v2:AttachToInstance(Parent)
v2:Add(function() -- line: 49
    -- upvalues: Renderer (copy), Parent (copy)
    Renderer.clear(Parent)
end)

local function isStaff() -- line: 53
    -- upvalues: Players (copy), StaffTagFlags (copy), v1 (copy)
    local UserId = Players.LocalPlayer.UserId

    if v1[UserId] == true then
        return true
    end

    return StaffTagFlags.Roles:Get()[tostring(UserId)] ~= nil
end

local function hideForStaff() -- line: 59
    -- upvalues: Renderer (copy), Parent (copy), Frame (ref), v5 (ref)
    v5 = ""
    Renderer.clear(Parent)

    if Frame then
        Frame.Visible = false
    end

    Parent.Enabled = false
end

local function configureCapture(p1) -- line: 68
    -- upvalues: v2 (copy)
    if p1:IsA("ScreenshotHud") then
        local HidePlayerGuiForCaptures = p1.HidePlayerGuiForCaptures

        local function v7() -- line: 73
            -- upvalues: p1 (copy)
            p1.HidePlayerGuiForCaptures = false

            return true
        end

        local ok, result = pcall(v7)

        if ok then
            v2:Add(function() -- line: 81
                -- upvalues: p1 (copy), HidePlayerGuiForCaptures (copy)
                if p1.Parent then
                    local function v8() -- line: 85
                        -- upvalues: p1 (copy), HidePlayerGuiForCaptures (copy)
                        p1.HidePlayerGuiForCaptures = HidePlayerGuiForCaptures
                    end

                    pcall(v8)
                end
            end)
        else
            warn("[QAOverlay] Cannot include PlayerGui in capture: " .. tostring(result))
        end
    end
end

local function showFallback() -- line: 91
    -- upvalues: Players (copy), Renderer (copy), StaffTagFlags (copy), v1 (copy), Parent (copy), Frame (ref), v5 (ref)
    local UserId = Players.LocalPlayer.UserId

    if v1[UserId] == true or StaffTagFlags.Roles:Get()[tostring(UserId)] ~= nil then
        v5 = ""
        Renderer.clear(Parent)

        if Frame then
            Frame.Visible = false
        end

        Parent.Enabled = false
    else
        v5 = ""
        Renderer.clear(Parent)

        if Frame then
            for _, v9 in Frame:QueryDescendants("#UID") do
                if v9:IsA("TextLabel") then
                    v9.Text = tostring(Players.LocalPlayer.UserId)
                end
            end

            Frame.Visible = true
        else
            local TextLabel = Instance.new("TextLabel")

            TextLabel.Name = "FingerprintUnavailable"
            TextLabel:SetAttribute("OverlayOwner", Renderer.OWNER)
            TextLabel.BackgroundTransparency = 1
            TextLabel.Size = UDim2.new(1, 0, 0, 32)
            TextLabel.Text = "QA capture marker pending: " .. Players.LocalPlayer.UserId
            TextLabel.TextColor3 = Color3.new(1, 1, 1)
            TextLabel.TextStrokeTransparency = 0
            TextLabel.TextSize = 16
            TextLabel.Active = false
            TextLabel.Interactable = false
            TextLabel.Selectable = false
            TextLabel.Parent = Parent
        end

        Parent.Enabled = true
    end
end

local function refresh() -- line: 123
    -- upvalues: Players (copy), Codec (copy), Renderer (copy), StaffTagFlags (copy), v1 (copy), Parent (copy), Frame (ref), v5 (ref), v6 (copy), showFallback (copy)
    if Parent.Parent then
        local UserId = Players.LocalPlayer.UserId

        if v1[UserId] == true or StaffTagFlags.Roles:Get()[tostring(UserId)] ~= nil then
            v5 = ""
            Renderer.clear(Parent)

            if Frame then
                Frame.Visible = false
            end

            Parent.Enabled = false
        else
            local FingerprintUserId = Parent:GetAttribute("FingerprintUserId")
            local v10

            if type(FingerprintUserId) ~= "number" or not Codec.getIsUserId(FingerprintUserId) then
                if not v6 then
                    showFallback()

                    return
                end

                local UserId = Players.LocalPlayer.UserId

                v10 = if Codec.getIsUserId(UserId) then Codec.createUserIdPayload(UserId) else Codec.PREVIEW_PAYLOAD
            else
                v10 = Codec.createUserIdPayload(FingerprintUserId)
            end

            local CurrentCamera = workspace.CurrentCamera

            if CurrentCamera and not (CurrentCamera.ViewportSize.X <= 1) and not (CurrentCamera.ViewportSize.Y <= 1) then
                local v11 = table.concat({
                    v10,
                    tostring(CurrentCamera.ViewportSize),
                    tostring(Parent:GetAttribute("DotOpacity")),
                    (tostring(Parent:GetAttribute("TilePixels")))
                }, ":")

                if v11 ~= v5 then
                    Renderer.mount(Parent, {
                        payload = v10,
                        viewport = CurrentCamera.ViewportSize,
                        isPreview = v10 == Codec.PREVIEW_PAYLOAD
                    })
                    v5 = v11
                end

                if Frame then
                    Frame.Visible = false
                end

                Parent.Enabled = true
            end
        end
    end
end

local function scheduleRefresh() -- line: 168
    -- upvalues: Promise (copy), v4 (copy), refresh (copy)
    v4:Clean()
    v4:AddPromise(Promise.delay(0.2):andThen(refresh))
end

local function bindCamera() -- line: 173
    -- upvalues: Promise (copy), v3 (copy), v4 (copy), refresh (copy), scheduleRefresh (copy)
    v3:Clean()

    local CurrentCamera = workspace.CurrentCamera

    if CurrentCamera then
        v3:Connect(CurrentCamera:GetPropertyChangedSignal("ViewportSize"), scheduleRefresh)
    end

    v4:Clean()
    v4:AddPromise(Promise.delay(0.2):andThen(refresh))
end

local ScreenshotHud = GuiService:FindFirstChild("ScreenshotHud")

if ScreenshotHud then
    configureCapture(ScreenshotHud)
end

v2:Connect(GuiService.ChildAdded, configureCapture)
v2:Connect(workspace:GetPropertyChangedSignal("CurrentCamera"), bindCamera)
v2:Connect(StaffTagFlags.Roles.Changed, scheduleRefresh)

for _, v14 in { "FingerprintUserId", "DotOpacity", "TilePixels" } do
    v2:Connect(Parent:GetAttributeChangedSignal(v14), scheduleRefresh)
end

if not v6 then
    showFallback()
    v2:AddPromise(Promise.delay(30):andThen(function() -- line: 194
        -- upvalues: Players (copy), Codec (copy), StaffTagFlags (copy), v1 (copy), Parent (copy)
        if Parent.Parent then
            local UserId = Players.LocalPlayer.UserId

            if v1[UserId] ~= true and StaffTagFlags.Roles:Get()[tostring(UserId)] == nil and not Codec.getIsUserId(Parent:GetAttribute("FingerprintUserId")) then
                warn("[QAOverlay] No UserId marker for " .. Players.LocalPlayer.Name)
            end
        end
    end))
end

v3:Clean()

local CurrentCamera = workspace.CurrentCamera

if CurrentCamera then
    v3:Connect(CurrentCamera:GetPropertyChangedSignal("ViewportSize"), scheduleRefresh)
end

v4:Clean()
v4:AddPromise(Promise.delay(0.2):andThen(refresh))
