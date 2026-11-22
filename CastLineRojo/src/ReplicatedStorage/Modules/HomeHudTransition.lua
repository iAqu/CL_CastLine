local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local HomeHudTransition = {}

local SLIDE_OUT = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local SLIDE_IN = TweenInfo.new(0.30, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local EDGE_PADDING = 12

local PANEL_DIRECTIONS = {
    LeftFrame = Vector2.new(-1, 0),
    RightFrame = Vector2.new(1, 0),
    TopFrame = Vector2.new(0, -1),
    BottomFrame = Vector2.new(0, 1),
}

local function getBounds(root: GuiObject): (Vector2, Vector2)
    local first = root.AbsolutePosition
    local last = first + root.AbsoluteSize

    local function includeChildren(parent: GuiObject)
        if parent.ClipsDescendants then
            return
        end
        for _, child in parent:GetChildren() do
            if child:IsA("GuiObject") and child.Visible then
                local start = child.AbsolutePosition
                local finish = start + child.AbsoluteSize
                first = Vector2.new(math.min(first.X, start.X), math.min(first.Y, start.Y))
                last = Vector2.new(math.max(last.X, finish.X), math.max(last.Y, finish.Y))
                includeChildren(child)
            end
        end
    end

    includeChildren(root)
    return first, last
end

local function offscreenPosition(gui: ScreenGui, panel: GuiObject, home: UDim2, direction: Vector2): UDim2
    local first, last = getBounds(panel)
    local anchor = panel.AbsolutePosition + panel.AbsoluteSize * panel.AnchorPoint
    local camera = Workspace.CurrentCamera
    local inset = if camera then camera.ViewportSize - gui.AbsoluteSize else Vector2.zero

    if direction.X ~= 0 then
        local padding = EDGE_PADDING + math.max(0, inset.X)
        local overhang = if direction.X < 0 then last.X - anchor.X else anchor.X - first.X
        return UDim2.new(if direction.X < 0 then 0 else 1, direction.X * math.ceil(overhang + padding),
            home.Y.Scale, home.Y.Offset)
    end

    local padding = EDGE_PADDING + math.max(0, inset.Y)
    local overhang = if direction.Y < 0 then last.Y - anchor.Y else anchor.Y - first.Y
    return UDim2.new(home.X.Scale, home.X.Offset,
        if direction.Y < 0 then 0 else 1, direction.Y * math.ceil(overhang + padding))
end

type Panel = {
    position: UDim2,
    interactable: boolean,
    direction: Vector2,
    tween: Tween?,
}

type Decoration = {
    visible: boolean,
    connection: RBXScriptConnection,
}

function HomeHudTransition.new(gui: ScreenGui, onRestored: () -> ())
    local transition = {}
    local hidden = false
    local panels: { [GuiObject]: Panel } = {}
    local decorations: { [GuiObject]: Decoration } = {}
    local restoringCount = 0

    local function restoreDecorations()
        for object, decoration in pairs(decorations) do
            decoration.connection:Disconnect()
            if object.Parent == gui then
                object.Visible = decoration.visible
            end
        end
        table.clear(decorations)
    end

    local function finishRestore()
        if hidden or restoringCount > 0 then
            return
        end
        restoreDecorations()
        onRestored()
    end

    local function muteDecoration(object: GuiObject)
        decorations[object] = {
            visible = object.Visible,
            connection = object:GetPropertyChangedSignal("Visible"):Connect(function()
                if object.Visible then
                    object.Visible = false
                end
            end),
        }
        object.Visible = false
    end

    local function movePanel(object: GuiObject, panel: Panel, immediately: boolean?)
        local previousTween = panel.tween
        panel.tween = nil
        if previousTween then
            previousTween:Cancel()
        end

        local position = if hidden then offscreenPosition(gui, object, panel.position, panel.direction)
            else panel.position
        if immediately then
            object.Position = position
            return
        end

        local tween = TweenService:Create(object, if hidden then SLIDE_OUT else SLIDE_IN, { Position = position })
        panel.tween = tween
        tween.Completed:Once(function(state)
            if state ~= Enum.PlaybackState.Completed or panel.tween ~= tween then
                return
            end
            panel.tween = nil
            if hidden then
                object.Position = offscreenPosition(gui, object, panel.position, panel.direction)
                return
            end
            panels[object] = nil
            object.Interactable = panel.interactable
            restoringCount -= 1
            finishRestore()
        end)
        tween:Play()
    end

    local function trackChild(child: Instance)
        if not child:IsA("GuiObject") then
            return
        end
        local direction = PANEL_DIRECTIONS[child.Name]
        if direction then
            local panel = panels[child]
            if not panel then
                panel = { position = child.Position, interactable = child.Interactable, direction = direction }
                panels[child] = panel
                child.Interactable = false
            end
            movePanel(child, panel)
        elseif not decorations[child] then
            muteDecoration(child)
        end
    end

    gui.ChildAdded:Connect(function(child)
        if hidden then
            trackChild(child)
        elseif restoringCount > 0 and child:IsA("GuiObject") and not PANEL_DIRECTIONS[child.Name] then
            muteDecoration(child)
        end
    end)

    gui.ChildRemoved:Connect(function(child)
        if not child:IsA("GuiObject") then
            return
        end
        local panel = panels[child]
        if panel then
            panels[child] = nil
            if panel.tween then
                panel.tween:Cancel()
            end
            child.Position = panel.position
            child.Interactable = panel.interactable
            if not hidden then
                restoringCount -= 1
                finishRestore()
            end
        end
        local decoration = decorations[child]
        if decoration then
            decorations[child] = nil
            decoration.connection:Disconnect()
            child.Visible = decoration.visible
        end
    end)

    gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        if hidden then
            for object, panel in pairs(panels) do
                if not panel.tween then
                    movePanel(object, panel, true)
                end
            end
        end
    end)

    function transition.IsInteractive(): boolean
        return not hidden and restoringCount == 0
    end

    function transition.SetHidden(shouldHide: boolean)
        if hidden == shouldHide then
            return
        end
        hidden = shouldHide
        restoringCount = 0
        if hidden then
            for _, child in gui:GetChildren() do
                trackChild(child)
            end
            return
        end

        for object, panel in pairs(panels) do
            restoringCount += 1
            movePanel(object, panel)
        end
        finishRestore()
    end

    return transition
end

return HomeHudTransition
