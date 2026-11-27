-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local ButtonHover = require(Modules:WaitForChild("ButtonHover"))
local PanelFocus = require(Modules:WaitForChild("PanelFocus"))
local Loc = require(Modules:WaitForChild("Loc"))
local UpdateLogConfig = require(Modules:WaitForChild("UpdateLogConfig"))
local AdminAbuseConfig = require(Modules:WaitForChild("AdminAbuseConfig"))

local function shown() -- line: 20
    -- upvalues: UpdateLogConfig (copy), AdminAbuseConfig (copy)
    local t1 = {}
    local v1 = AdminAbuseConfig.Now()

    for _, v2 in ipairs(UpdateLogConfig) do
        if not v2.opens or v2.opens <= v1 then
            t1[#t1 + 1] = v2
        end
    end

    return t1
end

local Rows = require(script:WaitForChild("Rows"))
local Panel = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("UpdateLogGui"):WaitForChild("Panel")
local Scale = Panel:WaitForChild("Scale")
local Main = Panel:WaitForChild("Main")
local Subtitle = Main:WaitForChild("Subtitle")
local List = Main:WaitForChild("List")
local Updates = Main:WaitForChild("Updates")
local UIListLayout = List:WaitForChild("UIListLayout")
local UIPadding = List:WaitForChild("UIPadding")
local TitleTemplate = List:WaitForChild("TitleTemplate")
local LineTemplate = List:WaitForChild("LineTemplate")
local Close = Main:WaitForChild("Close")

Panel.Visible = false
TitleTemplate.Visible = false
LineTemplate.Visible = false
Subtitle.AutoLocalize = false

local Scale2 = UIListLayout.Padding.Scale
local Scale3 = UIPadding.PaddingTop.Scale
local v3

local function fitCanvas() -- line: 53
    -- upvalues: Scale (copy), List (copy), UIListLayout (copy), UIPadding (copy), Scale2 (copy), Scale3 (copy), v3 (ref)
    local Y = List.AbsoluteWindowSize.Y

    if v3 then
        v3(Scale.Scale)
    end

    UIListLayout.Padding = UDim.new(0, Scale2 * Y * 0.4)
    UIPadding.PaddingTop = UDim.new(0, Scale3 * Y)
    UIPadding.PaddingBottom = UDim.new(0, Scale3 * Y)
    List.CanvasSize = UDim2.fromOffset(0, UIListLayout.AbsoluteContentSize.Y + 2 * Scale3 * Y)
end

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(fitCanvas)
List:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(fitCanvas)
Updates:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(fitCanvas)

local v4 = {}

local function build() -- line: 67
    -- upvalues: Loc (copy), shown (copy), Rows (copy), List (copy), Updates (copy), TitleTemplate (copy), LineTemplate (copy), v3 (ref), fitCanvas (copy), v4 (ref)
    for _, v5 in ipairs(v4) do
        v5:Destroy()
    end

    v4, v3 = Rows.Build(List, Updates, TitleTemplate, LineTemplate, shown(), Loc.T)
    fitCanvas()
end

local function showLast() -- line: 74
    -- upvalues: Loc (copy), AdminAbuseConfig (copy), shown (copy), Subtitle (copy)
    local PlaceUpdatedAt = workspace:GetAttribute("PlaceUpdatedAt")

    Subtitle.Visible = type(PlaceUpdatedAt) == "number"

    if type(PlaceUpdatedAt) ~= "number" then
        return
    end

    local v7 = math.max(0, workspace:GetServerTimeNow() - PlaceUpdatedAt)
    local v8 = AdminAbuseConfig.Now()

    for _, v9 in ipairs((shown())) do
        if v9.opens then
            v7 = math.min(v7, (math.max(0, v8 - v9.opens)))
        end
    end

    if v7 < 60 then
        Subtitle.Text = Loc.F("upd.last_now", "LAST UPDATE: just now", {})
    elseif v7 < 3600 then
        Subtitle.Text = Loc.F("upd.last_m", "LAST UPDATE: {n}m ago", {
            n = tostring((math.floor(v7 / 60)))
        })
    elseif v7 < 86400 then
        Subtitle.Text = Loc.F("upd.last_h", "LAST UPDATE: {n}h ago", {
            n = tostring((math.floor(v7 / 3600)))
        })
    else
        Subtitle.Text = Loc.F("upd.last_d", "LAST UPDATE: {n}d ago", {
            n = tostring((math.floor(v7 / 86400)))
        })
    end
end

workspace:GetAttributeChangedSignal("PlaceUpdatedAt"):Connect(showLast)

local v18 = false
local v19
local n1 = 0
local t5 = {
    IsOpen = function() -- IsOpen | line: 101
        -- upvalues: v18 (ref)
        return v18
    end,
    First = function() -- First | line: 107
        -- upvalues: Updates (copy)
        for _, child in ipairs(Updates:GetChildren()) do
            if child:GetAttribute("Shown") then
                return child
            end
        end

        return nil
    end,
    Open = function(p1) -- Open | line: 114
        -- upvalues: ReplicatedStorage (copy), TweenService (copy), PanelFocus (copy), Panel (copy), Scale (copy), List (copy), Updates (copy), build (copy), showLast (copy), v18 (ref), v19 (ref), n1 (ref)
        if v18 then
            return
        end

        v18 = true
        v19 = p1

        local UpdateLogSeen = ReplicatedStorage:WaitForChild("Remotes"):FindFirstChild("UpdateLogSeen")

        if UpdateLogSeen then
            UpdateLogSeen:FireServer()
        end

        build()
        showLast()
        List.CanvasPosition = Vector2.zero
        Updates.CanvasPosition = Vector2.zero
        PanelFocus.Sound(PanelFocus.FEEL.OPEN_SOUND)
        Scale.Scale = PanelFocus.FEEL.FROM
        Panel.Visible = true
        TweenService:Create(Scale, PanelFocus.popIn, {
            Scale = 1
        }):Play()
        n1 += 1

        local v20 = n1

        task.spawn(function() -- line: 130
            -- upvalues: v20 (copy), showLast (copy), v18 (ref), n1 (ref)
            while v18 and n1 == v20 do
                task.wait(60)

                if v18 and n1 == v20 then
                    showLast()
                end
            end
        end)
    end,
    Close = function(p2) -- Close | line: 138
        -- upvalues: TweenService (copy), PanelFocus (copy), Panel (copy), Scale (copy), v18 (ref), v19 (ref)
        if not v18 then
            return
        end

        v18 = false
        v19 = nil

        if p2 then
            Panel.Visible = false
        else
            local tween = TweenService:Create(Scale, PanelFocus.popOut, {
                Scale = 0
            })

            tween.Completed:Once(function() -- line: 146
                -- upvalues: Panel (copy), v18 (ref)
                if not v18 then
                    Panel.Visible = false
                end
            end)
            tween:Play()
        end
    end
}

Close.Activated:Connect(function() -- line: 152
    -- upvalues: v18 (ref), v19 (ref)
    if v18 and v19 then
        v19()
    end
end)
ButtonHover.Attach(Close, {
    shine = false,
    tile = 1,
    icon = Close:FindFirstChild("X")
})
Loc.Changed:Connect(function() -- line: 156
    -- upvalues: build (copy), showLast (copy), v18 (ref)
    if v18 then
        build()
        showLast()
    end
end)

return t5
