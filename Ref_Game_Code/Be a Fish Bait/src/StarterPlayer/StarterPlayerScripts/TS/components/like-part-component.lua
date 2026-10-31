-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out")
local Component, BaseComponent = out.Component, out.BaseComponent
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players, TweenService = services.Players, services.TweenService
local Maid = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "maid", "Maid")
local clientProducer = RuntimeLib.import(script, script.Parent.Parent, "reflex", "producer").clientProducer
local functions = RuntimeLib.import(script, script.Parent.Parent, "network").functions
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent, "utils").localPlayerUserId
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local selectCommunityMemberLikeCount = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "community-likes.selectors").selectCommunityMemberLikeCount
local selectPlayerHasLikedCommunityMember = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerHasLikedCommunityMember
local v1 = UDim.new(0, 4)
local v2 = Color3.fromRGB(255, 85, 120)
local v3 = Color3.new(1, 1, 1)
local PressStart2P = Font.fromName("PressStart2P")
local v4 = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v5 = TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 44
        return "LikePartComponent"
    end,
    __index = BaseComponent
})

self.__index = self

function self.new(...) -- line: 50
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, ...) -- line: 54
    -- upvalues: BaseComponent (copy), Maid (copy)
    BaseComponent.constructor(p1, ...)
    p1._maid = Maid.new()
    p1._isLiking = false
end

function self.onStart(p2) -- line: 59
    -- upvalues: Players (copy), clientProducer (copy), localPlayerUserId (copy), images (copy), selectCommunityMemberLikeCount (copy), selectPlayerHasLikedCommunityMember (copy), v1 (copy), v2 (copy), v3 (copy), PressStart2P (copy)
    local Name = p2.instance.Name
    local v8 = selectCommunityMemberLikeCount(Name)
    local v9 = selectPlayerHasLikedCommunityMember(localPlayerUserId, Name)

    p2.instance.CanQuery = true

    local SurfaceGui = Instance.new("SurfaceGui")

    SurfaceGui.Name = "LikeGui"
    SurfaceGui.Face = Enum.NormalId.Front
    SurfaceGui.Adornee = p2.instance
    SurfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    SurfaceGui.PixelsPerStud = 50
    SurfaceGui.LightInfluence = 0
    SurfaceGui.Parent = p2.instance
    p2._maid:GiveTask(SurfaceGui)

    local Frame = Instance.new("Frame")

    Frame.Name = "Container"
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.Parent = SurfaceGui

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.FillDirection = Enum.FillDirection.Vertical
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = v1
    UIListLayout.Parent = Frame

    local ImageButton = Instance.new("ImageButton")

    ImageButton.Name = "HeartButton"
    ImageButton.BackgroundTransparency = 1
    ImageButton.Image = images.heartIcon
    ImageButton.LayoutOrder = 0
    ImageButton.Size = UDim2.fromScale(0.7, 0.7)
    ImageButton.Parent = Frame

    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

    UIAspectRatioConstraint.AspectRatio = 1
    UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Width
    UIAspectRatioConstraint.Parent = ImageButton

    local UIScale = Instance.new("UIScale")

    UIScale.Parent = ImageButton

    local ProximityPrompt = Instance.new("ProximityPrompt")

    ProximityPrompt.Name = "LikePrompt"
    ProximityPrompt.ActionText = "Like"
    ProximityPrompt.ObjectText = Name
    ProximityPrompt.HoldDuration = 0.3
    ProximityPrompt.MaxActivationDistance = 10
    ProximityPrompt.RequiresLineOfSight = false
    ProximityPrompt.Parent = p2.instance
    p2._maid:GiveTask(ProximityPrompt)

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "CountLabel"
    TextLabel.BackgroundTransparency = 1
    TextLabel.FontFace = PressStart2P
    TextLabel.LayoutOrder = 1
    TextLabel.Size = UDim2.fromScale(1, 0.22)
    TextLabel.TextColor3 = Color3.new(1, 1, 1)
    TextLabel.TextScaled = true
    TextLabel.Parent = Frame

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = Color3.new(0, 0, 0)
    UIStroke.Thickness = 3
    UIStroke.Parent = TextLabel
    TextLabel.Text = tostring(clientProducer:getState(v8))
    p2._maid:GiveTask(clientProducer:subscribe(v8, function(p3) -- line: 129
        -- upvalues: TextLabel (copy)
        TextLabel.Text = tostring(p3)
    end))

    local function v10(p4) -- line: 132
        -- upvalues: ImageButton (copy), ProximityPrompt (copy), v2 (copy), v3 (copy)
        ImageButton.Active = not p4
        ImageButton.AutoButtonColor = not p4
        ImageButton.ImageColor3 = if p4 then v2 else v3
        ProximityPrompt.Enabled = not p4
    end

    local v12 = clientProducer:getState(v9)

    ImageButton.Active = not v12
    ImageButton.AutoButtonColor = not v12
    ImageButton.ImageColor3 = if v12 then v2 else v3
    ProximityPrompt.Enabled = not v12
    p2._maid:GiveTask(clientProducer:subscribe(v9, v10))
    p2._maid:GiveTask(ImageButton.Activated:Connect(function() -- line: 140
        -- upvalues: p2 (copy), Name (copy), UIScale (copy)
        p2:_playPressFeedback(UIScale)
        p2:_handleLikePressed(Name)
    end))
    p2._maid:GiveTask(ProximityPrompt.Triggered:Connect(function(p5) -- line: 144
        -- upvalues: p2 (copy), Name (copy), UIScale (copy), Players (copy)
        if p5 ~= Players.LocalPlayer then
            return nil
        end

        p2:_playPressFeedback(UIScale)
        p2:_handleLikePressed(Name)
    end))
end

function self.destroy(p6) -- line: 152
    -- upvalues: BaseComponent (copy)
    BaseComponent.destroy(p6)
    p6._maid:Destroy()
end

function self._playPressFeedback(_, p8) -- line: 156
    -- upvalues: TweenService (copy), v4 (copy), v5 (copy)
    TweenService:Create(p8, v4, {
        Scale = 0.82
    }):Play()

    local v14 = TweenService:Create(p8, v5, {
        Scale = 1
    })

    task.delay(v4.Time, function() -- line: 163
        -- upvalues: v14 (copy)
        return v14:Play()
    end)
end

function self._handleLikePressed(p9, p10) -- line: 167
    -- upvalues: RuntimeLib (copy), clientProducer (copy), functions (copy), localPlayerUserId (copy), selectPlayerHasLikedCommunityMember (copy)
    if p9._isLiking or clientProducer:getState(selectPlayerHasLikedCommunityMember(localPlayerUserId, p10)) then
        return nil
    end

    p9._isLiking = true
    task.spawn(RuntimeLib.async(function() -- line: 176
        -- upvalues: p9 (copy), p10 (copy), RuntimeLib (copy), functions (copy)
        RuntimeLib.await(functions.likeCommunityMember(p10))
        p9._isLiking = false
    end))
end

Reflect.defineMetadata(self, "identifier", "client/components/like-part-component@LikePartComponent")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$c:components@Component", Component, {
    {
        tag = "LikePart",
        attributes = {},
        instanceGuard = t.instanceIsA("BasePart")
    }
})

return {
    LikePartComponent = self
}
