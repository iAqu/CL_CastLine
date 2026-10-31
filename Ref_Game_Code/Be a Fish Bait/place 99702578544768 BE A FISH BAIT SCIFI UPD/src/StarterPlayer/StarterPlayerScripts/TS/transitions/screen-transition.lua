-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local TweenService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").TweenService
local v1 = Color3.fromRGB(27, 20, 12)
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 15
        return "ScreenTransition"
    end
})

self.__index = self

function self.new(...) -- line: 20
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2, p3) -- line: 24
    -- upvalues: v1 (copy)
    local v4 = if p3 == nil then {} else p3

    p1._tiles = {}
    p1._activeTweens = {}
    p1._animationId = 0
    p1._covered = false
    p1._destroyed = false

    local columns = v4.columns

    if columns == nil then
        columns = 12
    end

    local v6 = math.max(1, (math.floor(columns)))
    local rows = v4.rows

    if rows == nil then
        rows = 7
    end

    local v8 = math.max(1, (math.floor(rows)))
    local v9 = v4.color or v1
    local ScreenGui = Instance.new("ScreenGui")
    local name = v4.name

    ScreenGui.Name = if name == nil then "ScreenTransitionOverlay" else name

    local displayOrder = v4.displayOrder

    ScreenGui.DisplayOrder = if displayOrder == nil then 1E+06 else displayOrder
    ScreenGui.Enabled = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ScreenInsets = Enum.ScreenInsets.None
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    p1._gui = ScreenGui

    local Frame = Instance.new("Frame")

    Frame.Name = "InputBlocker"
    Frame.Active = true
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.Visible = false
    Frame.ZIndex = 0
    Frame.Parent = ScreenGui
    p1._blocker = Frame

    local v10 = 1 / v6
    local v11 = 1 / v8
    local n1 = 0
    local v12 = false

    while true do
        if v12 then
            n1 += 1
        else
            v12 = true
        end

        if n1 < v6 then
            local n2 = 0
            local v13 = false

            while true do
                if v13 then
                    n2 += 1
                else
                    v13 = true
                end

                if n2 < v8 then
                    local v14 = (n1 + 0.5) * v10
                    local v15 = (n2 + 0.5) * v11
                    local v17 = math.sqrt((v14 - 0.5) ^ 2 + (v15 - 0.5) ^ 2)
                    local v18 = UDim2.new(v10, 2, v11, 2)
                    local Frame = Instance.new("Frame")

                    Frame.Name = ("Tile_%*_%*"):format(n1, n2)
                    Frame.Active = true
                    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
                    Frame.BackgroundColor3 = v9
                    Frame.BorderSizePixel = 0
                    Frame.Position = UDim2.fromScale(v14, v15)
                    Frame.Size = UDim2.fromScale(0, 0)
                    Frame.Visible = false
                    Frame.ZIndex = 1
                    Frame.Parent = ScreenGui
                    table.insert(p1._tiles, {
                        frame = Frame,
                        fullSize = v18,
                        threshold = math.clamp(v17 / 0.7071067811865476, 0, 1)
                    })
                    continue
                end

                break
            end

            continue
        end

        break
    end

    ScreenGui.Parent = p2
end

function self.show(p4, p5) -- line: 125
    return p4:_play(true, if p5 == nil then 0.32 else p5)
end

function self.hide(p6, p7) -- line: 131
    return p6:_play(false, if p7 == nil then 0.28 else p7)
end

self.playInOut = RuntimeLib.async(function(p8, p9, p10, p11) -- line: 137
    -- upvalues: RuntimeLib (copy)
    local v21 = if p10 == nil then 0.32 else p10
    local v22 = if p11 == nil then 0.28 else p11

    RuntimeLib.await(p8:show(v21))
    RuntimeLib.await(p9())
    RuntimeLib.await(p8:hide(v22))
end)

function self.hideInstant(p12) -- line: 148
    if p12._destroyed then
        return nil
    end

    p12:_cancelAnimation()
    p12._covered = false
    p12._gui.Enabled = false
    p12._blocker.Visible = false

    for _, v23 in p12._tiles do
        v23.frame.Size = UDim2.fromScale(0, 0)
        v23.frame.Visible = false
    end
end

function self.destroy(p13) -- line: 161
    if p13._destroyed then
        return nil
    end

    p13._destroyed = true
    p13:_cancelAnimation()
    p13._gui:Destroy()
end

function self._play(p14, p15, p16) -- line: 169
    -- upvalues: RuntimeLib (copy), TweenService (copy)
    if p14._destroyed or p15 == p14._covered and #p14._activeTweens == 0 then
        return RuntimeLib.Promise.resolve()
    end

    p14:_cancelAnimation()

    local _animationId = p14._animationId
    local v24 = math.max(p16, 0)

    if v24 == 0 then
        p14:_setCoveredInstant(p15)

        return RuntimeLib.Promise.resolve()
    end

    p14._gui.Enabled = true
    p14._blocker.Visible = true

    local v26 = math.max(0.01, v24 * 0.45)
    local v28 = math.max(0, v24 - v26)
    local v29 = #p14._tiles

    return RuntimeLib.Promise.new(function(p17) -- line: 188
        -- upvalues: p14 (copy), p15 (copy), _animationId (copy), v26 (copy), v28 (copy), v29 (ref), TweenService (copy)
        p14._activeResolve = p17

        for _, v30 in p14._tiles do
            v30.frame.Visible = true

            local v31 = v30.threshold * v28
            local v34 = TweenService:Create(v30.frame, TweenInfo.new(v26, Enum.EasingStyle.Quad, if p15 then Enum.EasingDirection.Out else Enum.EasingDirection.In, 0, false, v31), {
                Size = if p15 then v30.fullSize else UDim2.fromScale(0, 0)
            })
            local connection = v34.Completed:Connect(function() -- line: 196
                -- upvalues: p14 (copy), p15 (copy), _animationId (copy), v29 (ref)
                if p14._animationId ~= _animationId then
                    return nil
                end

                v29 -= 1

                if v29 == 0 then
                    p14:_finishAnimation(_animationId, p15)
                end
            end)

            table.insert(p14._activeTweens, {
                connection = connection,
                tween = v34
            })
            v34:Play()
        end
    end)
end

function self._finishAnimation(p18, p19, p20) -- line: 215
    if p18._animationId ~= p19 then
        return nil
    end

    p18:_cleanupTweens()
    p18._covered = p20

    if not p20 then
        p18._gui.Enabled = false
        p18._blocker.Visible = false

        for _, v35 in p18._tiles do
            v35.frame.Visible = false
        end
    end

    local _activeResolve = p18._activeResolve

    p18._activeResolve = nil

    if _activeResolve ~= nil then
        _activeResolve()
    end
end

function self._setCoveredInstant(p21, p22) -- line: 235
    p21._covered = p22
    p21._gui.Enabled = p22
    p21._blocker.Visible = p22

    for _, v36 in p21._tiles do
        local frame = v36.frame

        if p22 then
            frame.Size = v36.fullSize
        else
            frame.Size = UDim2.fromScale(0, 0)
        end

        v36.frame.Visible = p22
    end
end

function self._cancelAnimation(p23) -- line: 244
    p23._animationId += 1
    p23:_cleanupTweens()

    local _activeResolve = p23._activeResolve

    p23._activeResolve = nil

    if _activeResolve ~= nil then
        _activeResolve()
    end
end

function self._cleanupTweens(p24) -- line: 254
    for _, v37 in p24._activeTweens do
        v37.connection:Disconnect()
        v37.tween:Cancel()
        v37.tween:Destroy()
    end

    table.clear(p24._activeTweens)
end

return {
    screenTransitionGuiName = "ScreenTransitionOverlay",
    ScreenTransition = self
}
