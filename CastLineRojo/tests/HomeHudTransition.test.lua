local sourcePath = "src/ReplicatedStorage/Modules/HomeHudTransition.lua"
local source = assert(io.open(sourcePath, "r")):read("*a")

local vector = {}
local vectorMetatable = {}
function vector.new(x, y)
    return setmetatable({ X = x, Y = y }, vectorMetatable)
end
vector.zero = vector.new(0, 0)
function vectorMetatable.__add(a, b)
    return vector.new(a.X + b.X, a.Y + b.Y)
end
function vectorMetatable.__sub(a, b)
    return vector.new(a.X - b.X, a.Y - b.Y)
end
function vectorMetatable.__mul(a, b)
    return vector.new(a.X * b.X, a.Y * b.Y)
end

local function position(xScale, xOffset, yScale, yOffset)
    return { X = { Scale = xScale, Offset = xOffset }, Y = { Scale = yScale, Offset = yOffset } }
end

local function signal()
    local listeners = {}
    local event = {}
    function event:Connect(callback)
        local key = {}
        listeners[key] = callback
        return {
            Disconnect = function()
                listeners[key] = nil
            end,
        }
    end
    function event:Once(callback)
        local connection
        connection = self:Connect(function(...)
            connection.Disconnect()
            callback(...)
        end)
    end
    function event:Fire(...)
        for _, callback in pairs(table.clone(listeners)) do
            callback(...)
        end
    end
    return event
end

local activeTweens = {}
local tweenService = {}
function tweenService.Create(_, object, _info, properties)
    local tween = { Completed = signal(), Goal = properties.Position }
    function tween:Play()
        activeTweens[object] = self
    end
    function tween:Cancel()
        activeTweens[object] = nil
        self.Completed:Fire("Cancelled")
    end
    function tween:Finish()
        activeTweens[object] = nil
        object.Position = self.Goal
        self.Completed:Fire("Completed")
    end
    return tween
end

local services = {
    TweenService = tweenService,
    Workspace = { CurrentCamera = { ViewportSize = vector.new(800, 600) } },
}
local chunk, loadError = loadstring(source, sourcePath)
local module = setfenv(assert(chunk, loadError), setmetatable({
    game = { GetService = function(_, name) return services[name] end },
    Vector2 = vector,
    UDim2 = { new = position },
    TweenInfo = { new = function(...) return { ... } end },
    Enum = {
        EasingStyle = { Quad = "Quad", Back = "Back" },
        EasingDirection = { In = "In", Out = "Out" },
        PlaybackState = { Completed = "Completed" },
    },
}, { __index = getfenv() }))()

local function element(name, x, y, width, height, anchorX, anchorY)
    local properties = {
        Name = name,
        Position = position(0, x, 0, y),
        AbsolutePosition = vector.new(x, y),
        AbsoluteSize = vector.new(width, height),
        AnchorPoint = vector.new(anchorX, anchorY),
        Interactable = true,
        Visible = true,
        Children = {},
        ChildAdded = signal(),
        ChildRemoved = signal(),
    }
    local changes = {}
    function properties:IsA(class)
        return class == "GuiObject" and name ~= "HomeGui"
    end
    function properties:GetChildren()
        return self.Children
    end
    function properties:GetPropertyChangedSignal(key)
        changes[key] = changes[key] or signal()
        return changes[key]
    end
    return setmetatable({}, {
        __index = properties,
        __newindex = function(_, key, value)
            if properties[key] ~= value then
                properties[key] = value
                if changes[key] then
                    changes[key]:Fire()
                end
            end
        end,
    })
end

local function add(parent, child)
    child.Parent = parent
    table.insert(parent.Children, child)
    parent.ChildAdded:Fire(child)
end

local function finishTweens()
    for _, tween in pairs(table.clone(activeTweens)) do
        tween:Finish()
    end
end

local home = element("HomeGui", 0, 0, 800, 560, 0, 0)
home.Enabled = false
local left = element("LeftFrame", 10, 10, 100, 200, 0, 0)
local right = element("RightFrame", 690, 15, 100, 200, 1, 0)
local top = element("TopFrame", 10, 20, 400, 50, 0, 0)
local bottom = element("BottomFrame", 10, 460, 400, 100, 0, 1)
local tooltip = element("PlayerStateInfoHover", 0, 0, 60, 20, 0, 0)
local protrudingButton = element("Button", 670, 15, 50, 40, 0, 0)
add(right, protrudingButton)
for _, object in ipairs({ left, right, top, bottom, tooltip }) do
    add(home, object)
end
top.Interactable = false
local rightHome = right.Position
local restored = 0
local transition = module.new(home, function()
    restored += 1
end)

transition.SetHidden(true)
assert(not transition.IsInteractive() and not left.Interactable and not tooltip.Visible, "Collapse must block input")
assert(activeTweens[left].Goal.X.Offset == -112, "The left panel must clear the screen")
assert(activeTweens[right].Goal.X.Scale == 1 and activeTweens[right].Goal.X.Offset == 132,
    "The right edge must clear a button extending past the left side of its parent")
assert(activeTweens[top].Goal.Y.Offset == -102 and activeTweens[bottom].Goal.Y.Offset == 152,
    "Vertical slides must clear the viewport insets")
local effect = element("RewardParticle", 0, 0, 20, 20, 0, 0)
add(home, effect)
assert(not effect.Visible, "New decorations must stay hidden behind an open window")
tooltip.Visible = true
assert(not tooltip.Visible, "A hover event must not reveal the tooltip while collapsed")
finishTweens()

transition.SetHidden(false)
assert(not transition.IsInteractive() and not right.Interactable and not tooltip.Visible,
    "Input and decorations must stay suppressed during the return animation")
transition.SetHidden(true)
finishTweens()
assert(restored == 0 and not right.Interactable, "A cancelled return animation must not restore input")
transition.SetHidden(false)
finishTweens()
assert(restored == 1 and transition.IsInteractive(), "The final return must restore input once")
assert(right.Position == rightHome and right.Interactable and not top.Interactable,
    "The final return must preserve original positions and interaction flags")
assert(tooltip.Visible and effect.Visible and not home.Enabled,
    "Showing the HUD must preserve external ScreenGui.Enabled and restore decorations")

print("HomeHudTransition.test.lua passed")
