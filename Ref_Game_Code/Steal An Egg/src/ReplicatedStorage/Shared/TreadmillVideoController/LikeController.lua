-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)
local GUI = require(ReplicatedStorage.Client.GUI)
local TryLock = require(ReplicatedStorage.Shared.Utils.TryLock)
local RecommendationSignals = require(script.Parent.RecommendationSignals)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local TreadmillMediaIdentity = require(ReplicatedStorage.Shared.Modules.TreadmillMediaIdentity)
local Schema = require(ReplicatedStorage.Shared.Types.TreadmillMediaLike.Types.Schema)

require(ReplicatedStorage.Shared.Types.TreadmillMediaLike.Types.Interface)

local t = require(ReplicatedStorage.Packages.t)
local TryCall = require(ReplicatedStorage.Shared.Utils.TryCall)
local v1 = t.intersection(t.numberMinExclusive((-1e999)), t.numberMaxExclusive(1e999))

local function v2(p1) -- line: 26
    -- upvalues: v1 (copy)
    if typeof(p1) == "Vector2" then
        return v1(p1.X) and v1(p1.Y)
    end

    return false
end

require(ReplicatedStorage.Shared.Globals.Constants)

local Log = require(ReplicatedStorage.Packages.Log)
local WarmAssets = require(ReplicatedStorage.Shared.Utils.Preload).WarmAssets

require(ReplicatedStorage.Packages.Trove)
require(script.Parent.Types.Interface)

local t1 = {}

t1.__index = t1
t1.__class = "LikeController"

local v3 = Color3.fromRGB(255, 92, 122)
local v4 = Log.new()

task.spawn(function() -- line: 60
    -- upvalues: WarmAssets (copy)
    local t2 = {}

    for _, v5 in { "rbxassetid://90146064998908", "rbxassetid://123761405635833" } do
        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Image = v5
        table.insert(t2, ImageLabel)
    end

    WarmAssets(t2)

    for _, v6 in t2 do
        v6:Destroy()
    end
end)

local v7 = GUI.TreadmillScreenSideButtons()

assert(v7:IsA("SurfaceGui"), "Treadmill like GUI must be a SurfaceGui")

local LikeButton = v7.Frame.Buttons.LikeButton

assert(LikeButton:IsA("ImageButton"), "Treadmill like button must be an ImageButton")

local LikeCount = LikeButton.LikeCount

assert(LikeCount:IsA("TextLabel"), "Treadmill like count label must be a TextLabel")

function t1.new(p2, p3, p4, p5, p6, p7) -- line: 110
    -- upvalues: t (copy), t1 (copy), v7 (copy), LikeButton (copy), LikeCount (copy)
    t.strict(t.callback)(p2)
    t.strict(t.callback)(p3)
    t.strict(t.table)(p4)
    t.strict(t.table)(p5)
    t.strict(t.Instance)(p6)
    t.strict(t.instanceIsA("BasePart"))(p7)

    local self = setmetatable({}, t1)

    self._countsByMediaLikeKey = {}
    self._defaultLikeButtonColor = LikeButton.ImageColor3
    self._destroyed = false
    self._getActiveVideoIndex = p2
    self._lastScreenTapPosition = nil
    self._lastScreenTapTime = nil
    self._likeButton = LikeButton
    self._likeCountLabel = LikeCount
    self._likeRequestLocks = {}
    self._likeSurfaceGui = v7
    self._likedTreadmillMedia = {}
    self._mediaEntries = p4
    self._onSingleTap = p3
    self._pendingSingleTapSerial = 0
    self._snapshotRequestSerial = 0
    self._screenTapSuppressUntil = 0
    self._trove = p5:Extend()
    self._videoFrame = p6
    self:_init(p7)

    return self
end

local function formatLikeCount(p8) -- line: 152
    -- upvalues: Simple (copy)
    return Simple.FormatCompact(math.max(p8, 0), ".#")
end

local function getSquareHeartSize(p9, p10) -- line: 156
    local v9 = math.min(p9.X, p9.Y)

    return UDim2.fromScale(v9 / p9.X * p10, v9 / p9.Y * p10)
end

function t1:_isAlive() -- line: 164
    return not self._destroyed
end

function t1:_getMediaKey() -- line: 166
    -- upvalues: TreadmillMediaIdentity (copy)
    local v10 = self._getActiveVideoIndex()
    local v11 = self._mediaEntries[v10]

    assert(v11 ~= nil, (("Missing treadmill media entry for index %*"):format(v10)))

    return TreadmillMediaIdentity.GetMediaKey(v11)
end

function t1:_setRuntimeLikedState(p14, p15) -- line: 173
    if p15 then
        self._likedTreadmillMedia[p14] = true
    else
        self._likedTreadmillMedia[p14] = nil
    end
end

function t1:_applyLocalLikedState(p17, p18) -- line: 185
    if self._likedTreadmillMedia[p17] == true == p18 then
        return
    end

    self:_setRuntimeLikedState(p17, p18)

    local v14 = if p18 then 1 else -1

    self._countsByMediaLikeKey[p17] = math.max((self._countsByMediaLikeKey[p17] or 0) + v14, 0)
    self:UpdatePresentation()
end

function t1:_reconcileLikedState(p20, p21) -- line: 202
    self:_setRuntimeLikedState(p20, p21.Liked == true)

    if typeof(p21.Count) == "number" then
        self._countsByMediaLikeKey[p20] = p21.Count
    end

    self:UpdatePresentation()
end

function t1:_requestLikeSnapshot(p23) -- line: 214
    -- upvalues: Remotes (copy), Schema (copy), TryCall (copy), v4 (copy)
    local v16, v17 = TryCall(function() -- line: 219
        -- upvalues: Remotes (copy)
        return Remotes.Treadmill.AskFavourSnapshot:InvokeServer()
    end)

    if not v16 then
        v4:AtError():Log((("Failed to load treadmill media like snapshot: %*"):format(v17)))

        return
    end

    if not Schema.LikeSnapshot(v17) then
        v4:AtError():Log("Invalid treadmill media like snapshot payload")

        return
    end

    if self:_isAlive() and p23 == self._snapshotRequestSerial then
        self._countsByMediaLikeKey = table.clone(v17.CountsByMediaLikeKey)
        self._likedTreadmillMedia = table.clone(v17.LikedTreadmillMedia)
        self:UpdatePresentation()
    end
end

function t1:_requestLikeSnapshotAsync() -- line: 242
    self._snapshotRequestSerial += 1

    local _snapshotRequestSerial = self._snapshotRequestSerial

    task.spawn(function() -- line: 245
        -- upvalues: self (copy), _snapshotRequestSerial (copy)
        if self:_isAlive() then
            self:_requestLikeSnapshot(_snapshotRequestSerial)
        end
    end)
end

function t1:_setLikedState(p26) -- line: 254
    -- upvalues: TryLock (copy), RecommendationSignals (copy), Remotes (copy), Schema (copy), TryCall (copy), v4 (copy)
    local v18 = self:_getMediaKey()
    local v19 = self._likeRequestLocks[v18]

    if v19 == nil then
        v19 = TryLock()
        self._likeRequestLocks[v18] = v19
    end

    v19(function() -- line: 262
        -- upvalues: self (copy), p26 (copy), v18 (copy), RecommendationSignals (copy), Remotes (copy), Schema (copy), TryCall (copy), v4 (copy)
        self._snapshotRequestSerial += 1

        local v20 = self._likedTreadmillMedia[v18] == true
        local v21 = self._countsByMediaLikeKey[v18] or 0

        self:_applyLocalLikedState(v18, p26)

        local v22, v23 = TryCall(function() -- line: 270
            -- upvalues: p26 (copy), v18 (copy), Remotes (copy)
            return Remotes.Treadmill.AskClipFavour:InvokeServer(v18, p26)
        end)

        if v22 then
            if Schema.LikeToggleResult(v23) then
                if v23.Ok == true then
                    if self:_isAlive() then
                        self:_reconcileLikedState(v18, v23)
                        RecommendationSignals.NotifyLikeResult(v18, v23.Liked == true)
                    end
                elseif self:_isAlive() then
                    self:_setRuntimeLikedState(v18, v20)
                    self._countsByMediaLikeKey[v18] = v21
                    self:UpdatePresentation()
                    v4:AtError():Log((("Rejected treadmill media like state update: %*"):format((tostring(v23.Error)))))
                end
            elseif self:_isAlive() then
                self:_setRuntimeLikedState(v18, v20)
                self._countsByMediaLikeKey[v18] = v21
                self:UpdatePresentation()
                v4:AtError():Log("Rejected treadmill media like state update: Invalid like toggle response")
            end
        elseif self:_isAlive() then
            self:_setRuntimeLikedState(v18, v20)
            self._countsByMediaLikeKey[v18] = v21
            self:UpdatePresentation()
            v4:AtError():Log((("Failed to update treadmill media like state: %*"):format(v23)))
        end
    end)
end

function t1:_spawnHeartAnimation(p28) -- line: 321
    -- upvalues: RunService (copy), TweenService (copy), t (copy), v2 (copy), v3 (copy)
    t.strict(v2)(p28)

    local _videoFrame = self._videoFrame
    local AbsoluteSize = _videoFrame.AbsoluteSize

    assert(AbsoluteSize.X > 0 and AbsoluteSize.Y > 0, "Treadmill like animation requires a non-zero video frame size")

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "TreadmillLikeHeart"
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = "rbxassetid://90146064998908"
    ImageLabel.ImageColor3 = v3
    ImageLabel.ImageTransparency = 0
    ImageLabel.Position = UDim2.fromScale(p28.X, p28.Y)
    ImageLabel.Size = UDim2.fromScale(0.15, 0.08)
    ImageLabel.ZIndex = self._likeButton.ZIndex + 10
    ImageLabel.Parent = _videoFrame
    Instance.new("UIAspectRatioConstraint").Parent = ImageLabel

    local v26 = Random.new()
    local v27 = v26:NextNumber(-0.08, 0.08)
    local v28 = -v26:NextNumber(0.24, 0.34)
    local v32 = Vector2.new(math.clamp(p28.X + v27, 0.05, 0.95), (math.clamp(p28.Y + v28, 0.05, 0.95)))
    local v36 = Vector2.new(math.clamp(p28.X + v27 * 0.55, 0.05, 0.95), (math.clamp(p28.Y + v28 * 0.45, 0.05, 0.95)))

    local function bezier(p29) -- line: 375
        -- upvalues: p28 (copy), v32 (copy), v36 (copy)
        return p28:Lerp(v36, p29):Lerp(v36:Lerp(v32, p29), p29)
    end

    local connection
    local v37 = false

    local function cleanupHeart() -- line: 382
        -- upvalues: ImageLabel (copy), connection (ref), v37 (ref)
        if v37 then
            return
        end

        v37 = true

        local connection2 = connection

        connection = nil

        if connection2 ~= nil then
            connection2:Disconnect()
        end

        if ImageLabel.Parent ~= nil then
            ImageLabel:Destroy()
        end
    end

    local n1 = 0

    connection = RunService.PreRender:Connect(function(p30) -- line: 400
        -- upvalues: self (copy), p28 (copy), AbsoluteSize (copy), ImageLabel (copy), v32 (copy), v36 (copy), connection (ref), v37 (ref), n1 (ref), TweenService (copy)
        local v38, v39, v40

        if not self:_isAlive() or ImageLabel.Parent == nil then
            if v37 then
                return
            end

            v37 = true

            local connection2 = connection

            connection = nil

            if connection2 ~= nil then
                connection2:Disconnect()
            end

            if ImageLabel.Parent ~= nil then
                ImageLabel:Destroy()
            end
        else
            n1 = math.min(n1 + p30, 0.65)
            v38 = n1 / 0.65

            local Value = TweenService:GetValue(v38, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

            v39 = p28:Lerp(v36, Value):Lerp(v36:Lerp(v32, Value), Value)
            v40 = if v38 <= 0.18 then 0.6 + -0.19999999999999996 * TweenService:GetValue(v38 / 0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out) else 0.4 + -0.32 * TweenService:GetValue((v38 - 0.18) / 0.82, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            ImageLabel.Position = UDim2.fromScale(v39.X, v39.Y)

            local v43 = math.min(AbsoluteSize.X, AbsoluteSize.Y)

            ImageLabel.Size = UDim2.fromScale(v43 / AbsoluteSize.X * v40, v43 / AbsoluteSize.Y * v40)
            ImageLabel.ImageTransparency = math.clamp((v38 - 0.35) / 0.65, 0, 1)

            if v38 >= 1 then
                if v37 then
                    return
                end

                v37 = true

                local connection2 = connection

                connection = nil

                if connection2 ~= nil then
                    connection2:Disconnect()
                end

                if ImageLabel.Parent ~= nil then
                    ImageLabel:Destroy()
                end
            end
        end
    end)
    self._trove:Add(cleanupHeart)
end

function t1:_handleDoubleTap(p32) -- line: 439
    -- upvalues: t (copy), v2 (copy)
    t.strict(v2)(p32)
    self:_spawnHeartAnimation(p32)

    local v45 = self:_getMediaKey()

    if self._likedTreadmillMedia[v45] ~= true then
        self:_setLikedState(true)
    end
end

function t1:_startRefreshLoop() -- line: 451
    task.spawn(function() -- line: 452
        -- upvalues: self (copy)
        while true do
            if self:_isAlive() then
                task.wait(180)

                if self:_isAlive() then
                    self:_requestLikeSnapshotAsync()
                    continue
                end
            end

            break
        end
    end)
end

function t1:_init(p35) -- line: 464
    -- upvalues: ButtonFX (copy)
    self._likeSurfaceGui.Adornee = p35
    self._likeSurfaceGui.Enabled = true
    self:UpdatePresentation()
    self._trove:Add(ButtonFX(self._likeButton, nil, function() -- line: 469
        -- upvalues: self (copy)
        self:Toggle()
    end))
    self:_requestLikeSnapshotAsync()
    self:_startRefreshLoop()
end

function t1:UpdatePresentation() -- line: 479
    -- upvalues: Simple (copy), v3 (copy)
    if not self:_isAlive() then
        return
    end

    local v46 = self:_getMediaKey()
    local v47 = self._likedTreadmillMedia[v46] == true
    local v48 = self._countsByMediaLikeKey[v46] or 0
    local _likeButton = self._likeButton

    if v47 then
        _likeButton.ImageColor3 = v3
    else
        _likeButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
    end

    self._likeButton.Image = v47 and "rbxassetid://90146064998908" or "rbxassetid://123761405635833"
    self._likeCountLabel.Text = Simple.FormatCompact(math.max(v48, 0), ".#")
end

function t1:SuppressScreenTap() -- line: 495
    self._screenTapSuppressUntil = os.clock() + 0.12
end

function t1:Toggle() -- line: 499
    if not self:_isAlive() then
        return
    end

    self:SuppressScreenTap()

    local v49 = self:_getMediaKey()

    self:_setLikedState(self._likedTreadmillMedia[v49] ~= true)
end

function t1:HandleScreenTap(p40) -- line: 509
    -- upvalues: t (copy), v2 (copy)
    t.strict(v2)(p40)

    local elapsed, AbsoluteSize, v50

    if not self:_isAlive() or os.clock() < self._screenTapSuppressUntil then
        return
    else
        elapsed = os.clock()
        AbsoluteSize = self._videoFrame.AbsoluteSize
        v50 = AbsoluteSize.X > 0 and AbsoluteSize.Y > 0
    end

    assert(v50, "Treadmill like tap handling requires a non-zero video frame size")

    if self._lastScreenTapTime ~= nil and self._lastScreenTapPosition ~= nil and elapsed - self._lastScreenTapTime <= 0.25 and Vector2.new((p40.X - self._lastScreenTapPosition.X) * AbsoluteSize.X, (p40.Y - self._lastScreenTapPosition.Y) * AbsoluteSize.Y).Magnitude <= 36 then
        self._pendingSingleTapSerial += 1
        self._lastScreenTapTime = nil
        self._lastScreenTapPosition = nil
        self:_handleDoubleTap(p40)
    else
        self._pendingSingleTapSerial += 1

        local _pendingSingleTapSerial = self._pendingSingleTapSerial

        self._lastScreenTapTime = elapsed
        self._lastScreenTapPosition = p40
        task.delay(0.25, function() -- line: 545
            -- upvalues: self (copy), _pendingSingleTapSerial (copy)
            if not self:_isAlive() or self._pendingSingleTapSerial ~= _pendingSingleTapSerial then
                return
            end

            self._lastScreenTapTime = nil
            self._lastScreenTapPosition = nil
            self._onSingleTap()
        end)
    end
end

function t1:Destroy() -- line: 556
    if self._destroyed then
        return
    end

    self._destroyed = true
    self._pendingSingleTapSerial += 1
    self._likeSurfaceGui.Enabled = false
    self._trove:Destroy()
end

return t1
