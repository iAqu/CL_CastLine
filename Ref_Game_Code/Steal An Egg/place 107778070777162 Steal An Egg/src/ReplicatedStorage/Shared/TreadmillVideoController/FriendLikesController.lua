-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local GUI = require(ReplicatedStorage.Client.GUI)
local DisplayName, Thumbnail = require(ReplicatedStorage.Shared.Utils.Identity).DisplayName, require(ReplicatedStorage.Shared.Utils.Identity).Thumbnail
local Log = require(ReplicatedStorage.Packages.Log)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local TreadmillMediaIdentity = require(ReplicatedStorage.Shared.Modules.TreadmillMediaIdentity)
local Schema = require(ReplicatedStorage.Shared.Types.TreadmillMediaLike.Types.Schema)

require(ReplicatedStorage.Shared.Types.TreadmillMediaLike.Types.Interface)

local Trove = require(ReplicatedStorage.Packages.Trove)
local t = require(ReplicatedStorage.Packages.t)

require(script.Parent.Types.Interface)

local TryCall = require(ReplicatedStorage.Shared.Utils.TryCall)
local t1 = {}

t1.__index = t1
t1.__class = "FriendLikesController"

local v1 = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v2 = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local v3 = TweenInfo.new(2.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
local v4 = Vector2.new(0.13, 0.13)
local v5 = Log.new()
local v6 = GUI.TreadmillScreenFriendLikes()

assert(v6:IsA("SurfaceGui"), "Treadmill friend-like GUI must be a SurfaceGui")

local Frame = v6.Frame
local Main = Frame.Main
local Template = Main.Template

assert(Template:IsA("Frame"), "Treadmill friend-like template must be a Frame")
assert(Template.Button:IsA("ImageButton"), "Treadmill friend-like template button must be an ImageButton")

local Profile = Frame.Profile

assert(Profile:IsA("Frame"), "Treadmill friend-like profile must be a Frame")

local ProfilePosition = Profile.Position
local PlayerIcon = Profile.Main.Icon.PlayerIcon

assert(PlayerIcon:IsA("ImageLabel"), "Treadmill friend-like profile icon must be an ImageLabel")

local TextLabel = Profile.Main.TextLabel

assert(TextLabel:IsA("TextLabel"), "Treadmill friend-like profile label must be a TextLabel")

function t1.new(p1, p2, p3, p4, p5) -- line: 103
    -- upvalues: Trove (copy), t (copy), t1 (copy), v6 (copy), Main (copy), Template (copy), Profile (copy), ProfilePosition (copy), PlayerIcon (copy), TextLabel (copy)
    t.strict(t.callback)(p1)
    t.strict(t.callback)(p2)
    t.strict(t.table)(p3)
    t.strict(t.table)(p4)
    t.strict(t.instanceIsA("BasePart"))(p5)

    local self = setmetatable({}, t1)

    self._destroyed = false
    self._friendLikeUserIdsByMediaLikeKey = {}
    self._getActiveVideoIndex = p1
    self._interactionCallback = p2
    self._mediaEntries = p3
    self._profile = Profile
    self._profilePlayerIcon = PlayerIcon
    self._profileTextLabel = TextLabel
    self._profileTween = nil
    self._profileVisiblePosition = ProfilePosition
    self._rowsContainer = Main
    self._rowsTrove = Trove.new()
    self._rowTemplate = Template
    self._screenTapSuppressUntil = 0
    self._snapshotRequestSerial = 0
    self._surfaceGui = v6
    self._trove = p4:Extend()
    self:_init(p5)

    return self
end

local function escapeRichText(p6) -- line: 142
    return p6:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub("\"", "&quot;"):gsub("'", "&apos;")
end

local function getRandomFloatPosition(p7) -- line: 151
    -- upvalues: v4 (copy)
    return UDim2.fromScale(0.5 + p7:NextNumber(-v4.X, v4.X), 0.5 + p7:NextNumber(-v4.Y, v4.Y))
end

local function startButtonFloat(p8, p9) -- line: 158
    -- upvalues: TweenService (copy), v3 (copy), v4 (copy)
    local v8 = Random.new()
    local tween = nil
    local v9 = false

    p8.AnchorPoint = Vector2.new(0.5, 0.5)
    p8.Position = UDim2.fromScale(0.5, 0.5)

    local function playNext() -- line: 166
        -- upvalues: p8 (copy), v8 (copy), tween (ref), v9 (ref), playNext (copy), TweenService (copy), v3 (copy), v4 (copy)
        if not v9 and p8.Parent ~= nil then
            local tween2 = TweenService:Create(p8, v3, {
                Position = UDim2.fromScale(0.5 + v8:NextNumber(-v4.X, v4.X), 0.5 + v8:NextNumber(-v4.Y, v4.Y))
            })

            tween = tween2
            tween2.Completed:Once(function() -- line: 175
                -- upvalues: tween2 (copy), tween (ref), playNext (copy)
                if tween == tween2 then
                    tween = nil
                    playNext()
                end
            end)
            tween2:Play()
        end
    end

    p9:Add(function() -- line: 186
        -- upvalues: tween (ref), v9 (ref)
        v9 = true

        if tween == nil then
            return
        end

        tween:Cancel()
        tween = nil
    end)
    playNext()
end

function t1:_isAlive() -- line: 196
    return not self._destroyed
end

function t1:_getMediaKey() -- line: 200
    -- upvalues: TreadmillMediaIdentity (copy)
    local v10 = self._getActiveVideoIndex()
    local v11 = self._mediaEntries[v10]

    assert(v11 ~= nil, (("Missing treadmill media entry for index %*"):format(v10)))

    return TreadmillMediaIdentity.GetMediaKey(v11)
end

function t1:_getProfileHiddenPosition() -- line: 207
    local _profileVisiblePosition = self._profileVisiblePosition

    return UDim2.new(_profileVisiblePosition.X.Scale, _profileVisiblePosition.X.Offset, 2, _profileVisiblePosition.Y.Offset)
end

function t1:_cancelProfileTween() -- line: 217
    local _profileTween = self._profileTween

    self._profileTween = nil

    if _profileTween ~= nil then
        _profileTween:Cancel()
    end
end

function t1:_hideProfileImmediate() -- line: 225
    self:_cancelProfileTween()
    self._profile.Visible = false
    self._profile.Position = self:_getProfileHiddenPosition()
end

function t1:_clearRows() -- line: 231
    -- upvalues: Trove (copy)
    self._rowsTrove:Destroy()
    self._rowsTrove = Trove.new()
end

function t1:_getRequestedMediaKeys() -- line: 236
    -- upvalues: TreadmillMediaIdentity (copy)
    local t4 = {}
    local t5 = {}
    local v14 = self._getActiveVideoIndex()

    for _, v15 in ipairs({
            v14,
            v14 + 1,
            v14 - 1
        }) do
        local v16 = self._mediaEntries[v15]

        if v16 ~= nil then
            local v17 = TreadmillMediaIdentity.GetMediaKey(v16)

            if not t5[v17] then
                t5[v17] = true
                table.insert(t4, v17)
            end
        end
    end

    return t4
end

function t1:_requestFriendLikeSnapshot(p18) -- line: 263
    -- upvalues: Remotes (copy), Schema (copy), TryCall (copy), v5 (copy)
    local v18, v19 = TryCall(function() -- line: 268
        -- upvalues: self (copy), Remotes (copy)
        return Remotes.Treadmill.AskFriendFavourSnapshot:InvokeServer({
            MediaKeys = self:_getRequestedMediaKeys()
        })
    end)

    if v18 then
        if Schema.FriendLikeSnapshot(v19) then
            if self:_isAlive() and p18 == self._snapshotRequestSerial then
                self._friendLikeUserIdsByMediaLikeKey = table.clone(v19.FriendLikeUserIdsByMediaLikeKey)
                self:UpdatePresentation()
            end
        else
            v5:AtError():Log("Invalid treadmill friend-like snapshot payload")
        end
    else
        v5:AtError():Log((("Failed to load treadmill friend-like snapshot: %*"):format(v19)))
    end
end

function t1:_requestFriendLikeSnapshotAsync() -- line: 294
    self._snapshotRequestSerial += 1

    local _snapshotRequestSerial = self._snapshotRequestSerial

    task.spawn(function() -- line: 297
        -- upvalues: self (copy), _snapshotRequestSerial (copy)
        if self:_isAlive() then
            self:_requestFriendLikeSnapshot(_snapshotRequestSerial)
        end
    end)
end

function t1._resolveDisplayName(_, p21) -- line: 306
    -- upvalues: Players (copy), DisplayName (copy)
    local PlayerByUserId = Players:GetPlayerByUserId(p21)

    if PlayerByUserId == nil then
        return DisplayName(p21)
    end

    return PlayerByUserId.DisplayName
end

function t1:_showProfilePreview(p23, p24) -- line: 315
    -- upvalues: TweenService (copy), Constants (copy), Thumbnail (copy), v1 (copy), escapeRichText (copy)
    self:_cancelProfileTween()

    local v20 = self:_resolveDisplayName(p23)

    if not self:_isAlive() then
        return
    end

    self._profilePlayerIcon.Image = p24
    self._profileTextLabel.RichText = true

    local v21 = p23 == Constants.OWNER_ID and " (OWNER)" or ""

    self._profileTextLabel.Text = ("<b>%*%*</b> liked this video"):format(escapeRichText(v20), v21)
    self._profile.Position = self:_getProfileHiddenPosition()
    self._profile.Visible = true

    if p24 == "" then
        task.spawn(function() -- line: 335
            -- upvalues: self (copy), p23 (copy), Thumbnail (copy)
            local v22 = Thumbnail(p23, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180)

            if v22 == nil then
                v22 = ""
            end

            if self:_isAlive() and self._profile.Visible then
                self._profilePlayerIcon.Image = v22
            end
        end)
    end

    local tween = TweenService:Create(self._profile, v1, {
        Position = self._profileVisiblePosition
    })

    self._profileTween = tween
    tween.Completed:Once(function() -- line: 355
        -- upvalues: self (copy), tween (copy)
        if self._profileTween == tween then
            self._profileTween = nil
        end
    end)
    tween:Play()
end

function t1:_startRefreshLoop() -- line: 365
    task.spawn(function() -- line: 366
        -- upvalues: self (copy)
        while true do
            if self:_isAlive() then
                task.wait(180)

                if self:_isAlive() then
                    self:_requestFriendLikeSnapshotAsync()
                    continue
                end
            end

            break
        end
    end)
end

function t1:_init(p27) -- line: 378
    self._surfaceGui.Adornee = p27
    self._surfaceGui.Enabled = true
    self._rowTemplate.Visible = false
    self._profileTextLabel.RichText = true
    self:_hideProfileImmediate()
    self:UpdatePresentation()
    self:_requestFriendLikeSnapshotAsync()
    self:_startRefreshLoop()
end

function t1:UpdatePresentation() -- line: 393
    -- upvalues: ButtonFX (copy), Thumbnail (copy), startButtonFloat (copy)
    if not self:_isAlive() then
        return
    end

    self:_clearRows()

    local v23 = self:_getMediaKey()
    local v24 = self._friendLikeUserIdsByMediaLikeKey[v23]

    if v24 ~= nil and #v24 ~= 0 then
        for v25, v26 in ipairs(v24) do
            local clone = self._rowTemplate:Clone()
            local Button = clone.Button

            clone.Name = ("FriendLike_%*"):format(v26)
            clone.Visible = true
            clone.LayoutOrder = v25
            Button.PlayerIcon.Image = ""
            clone.Parent = self._rowsContainer

            local v27 = self._rowsTrove:Extend()

            startButtonFloat(Button, v27)
            v27:Add(ButtonFX(Button, nil, function() -- line: 418
                -- upvalues: self (copy), Button (copy), v26 (copy)
                self:SuppressScreenTap()
                self._interactionCallback()
                self:_showProfilePreview(v26, Button.PlayerIcon.Image)
            end))
            v27:Add(clone)
            task.spawn(function() -- line: 425
                -- upvalues: self (copy), clone (copy), Button (copy), v26 (copy), Thumbnail (copy)
                local v28 = Thumbnail(v26, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180)

                if v28 == nil then
                    v28 = ""
                end

                if self:_isAlive() and clone.Parent ~= nil then
                    Button.PlayerIcon.Image = v28
                end
            end)
        end
    end
end

function t1:HandleScreenTap() -- line: 442
    if self:_isAlive() and not (os.clock() < self._screenTapSuppressUntil) then
        self:HideProfilePreview()
    end
end

function t1:SuppressScreenTap() -- line: 450
    self._screenTapSuppressUntil = os.clock() + 0.12
end

function t1:HandleMediaChanged() -- line: 454
    if not self:_isAlive() then
        return
    end

    self:HideProfilePreview()
    self:UpdatePresentation()
    self:_requestFriendLikeSnapshotAsync()
end

function t1:HideProfilePreview() -- line: 464
    -- upvalues: TweenService (copy), v2 (copy)
    if not self:_isAlive() then
        return
    end

    self:_cancelProfileTween()

    if not self._profile.Visible then
        self._profile.Position = self:_getProfileHiddenPosition()

        return
    end

    local tween = TweenService:Create(self._profile, v2, {
        Position = self:_getProfileHiddenPosition()
    })

    self._profileTween = tween
    tween.Completed:Once(function() -- line: 479
        -- upvalues: self (copy), tween (copy)
        if self._profileTween == tween then
            self._profileTween = nil
            self._profile.Visible = false
        end
    end)
    tween:Play()
end

function t1:Destroy() -- line: 490
    if self._destroyed then
        return
    end

    self._destroyed = true
    self:_clearRows()
    self:_hideProfileImmediate()
    self._surfaceGui.Enabled = false
    self._trove:Destroy()
end

return t1
