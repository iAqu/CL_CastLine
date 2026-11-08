-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local Info = require(ReplicatedStorage.Shared.Utils.Marketplace).Info
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local Trove = require(ReplicatedStorage.Packages.Trove)

require(script.Parent.Types.Interface)

local t = require(ReplicatedStorage.Packages.t)
local TryCall = require(ReplicatedStorage.Shared.Utils.TryCall)
local t1 = {}

t1.__index = t1
t1.__class = "PhotoInputController"

local v1 = t.interface({
    AssetTypeId = t.number
})

function t1.new(p1, p2) -- line: 57
    -- upvalues: Trove (copy), t1 (copy)
    local AddPhoto = p1.AddPhoto
    local Content = p1.Sheet.Actions.Content
    local self = setmetatable({}, t1)

    self._addButton = AddPhoto.Frame.Buttons.Add
    self._attachment = Content.TextInputWrapper.AddedPhoto
    self._cancelButton = AddPhoto.Frame.Buttons.Cancel
    self._composerAddPhotoButton = Content.AddPhoto
    self._destroyed = false
    self._imageAssetId = nil
    self._input = AddPhoto.Frame.TextInputWrapper.TextInput
    self._onInteraction = p2
    self._overlay = AddPhoto
    self._removeButton = self._attachment.RemoveButton
    self._requestSerial = 0
    self._textInputWrapper = Content.TextInputWrapper
    self._trove = Trove.new()
    self:_init()

    return self
end

local function parseImageAssetId(p3) -- line: 85
    local v3 = p3:match("^%s*(.-)%s*$") or ""
    local v4 = v3:match("^%d+$")

    if v4 == nil then
        v4 = string.lower(v3):match("^rbxassetid://(%d+)$")
    end

    local v5 = if v4 == nil then nil else tonumber(v4)

    return if v5 ~= nil and not (v5 <= 0) and v5 % 1 == 0 then v5 else nil
end

local function showInvalidImageNotification() -- line: 100
    -- upvalues: Toast (copy)
    Toast.Show({
        Lane = "Banner",
        Text = "Invalid image, please upload another image.",
        Seconds = 3,
        ShowShadow = true,
        Color = Color3.new(1, 1, 1)
    })
end

local function showImageLookupFailedNotification() -- line: 110
    -- upvalues: Toast (copy)
    Toast.Show({
        Lane = "Banner",
        Text = "Something went wrong, please try again later.",
        Seconds = 3,
        ShowShadow = true,
        Color = Color3.new(1, 1, 1)
    })
end

local function isImageAsset(p4) -- line: 120
    -- upvalues: Info (copy), TryCall (copy), v1 (copy)
    local v6, v7 = TryCall(Info, p4, Enum.InfoType.Asset)

    if not v6 or not v1(v7) then
        return false, "ImageAssetLookupFailed"
    end

    local AssetTypeId = v7.AssetTypeId

    if AssetTypeId == Enum.AssetType.Image.Value or AssetTypeId == Enum.AssetType.Decal.Value then
        return true, nil
    end

    return false, "InvalidImageAssetId"
end

function t1:_setAttachment(p6) -- line: 138
    self._imageAssetId = p6
    self._attachment.Visible = p6 ~= nil

    if p6 ~= nil then
        self._attachment.Icon.Image = ("rbxassetid://%*"):format(p6)
    else
        self._attachment.Icon.Image = ""
    end
end

function t1:_closeOverlay() -- line: 148
    self._requestSerial += 1
    self._addButton.Active = true
    self._overlay.Visible = false
    self._input.Text = ""
end

function t1:GetImageAssetId() -- line: 159
    return self._imageAssetId
end

function t1.Reset(p9) -- line: 163
    p9:_closeOverlay()
    p9:_setAttachment(nil)
end

function t1:Destroy() -- line: 168
    if self._destroyed then
        return
    end

    self._destroyed = true
    self:Reset()
    self._trove:Destroy()
end

function t1:_init() -- line: 182
    -- upvalues: Players (copy), ButtonFX (copy), Constants (copy), Toast (copy), parseImageAssetId (copy), isImageAsset (copy)
    local v8 = Players.LocalPlayer.UserId == Constants.OWNER_ID

    self._overlay.Visible = false
    self._attachment.Visible = false
    self._composerAddPhotoButton.Visible = v8
    self._composerAddPhotoButton.Active = v8
    self._composerAddPhotoButton.Selectable = v8

    local _textInputWrapper = self._textInputWrapper

    if not v8 then
        _textInputWrapper.Size = UDim2.new(1, -50, 0, 48)
    else
        _textInputWrapper.Size = UDim2.new(1, -105, 0, 48)
        self._trove:Add(ButtonFX(self._composerAddPhotoButton, nil, function() -- line: 196
            -- upvalues: self (copy)
            self._onInteraction()
            self._overlay.Visible = true
            self._input:CaptureFocus()
        end))
        self._trove:Add(ButtonFX(self._cancelButton, 1.08, function() -- line: 201
            -- upvalues: self (copy)
            self._onInteraction()
            self:_closeOverlay()
        end))
        self._trove:Add(ButtonFX(self._removeButton, nil, function() -- line: 205
            -- upvalues: self (copy)
            self._onInteraction()
            self:_setAttachment(nil)
        end))
        self._trove:Add(ButtonFX(self._addButton, 1.08, function() -- line: 209
            -- upvalues: self (copy), Toast (copy), parseImageAssetId (copy), isImageAsset (copy)
            self._onInteraction()

            local v9 = parseImageAssetId(self._input.Text)

            if v9 ~= nil then
                self._requestSerial += 1

                local _requestSerial = self._requestSerial

                self._addButton.Active = false
                task.spawn(function() -- line: 220
                    -- upvalues: v9 (copy), _requestSerial (copy), self (copy), Toast (copy), isImageAsset (copy)
                    local v10, v11 = isImageAsset(v9)

                    if not self._destroyed and _requestSerial == self._requestSerial then
                        self._addButton.Active = true

                        if v10 then
                            self:_setAttachment(v9)
                            self:_closeOverlay()
                        elseif v11 == "ImageAssetLookupFailed" then
                            Toast.Show({
                                Lane = "Banner",
                                Text = "Something went wrong, please try again later.",
                                Seconds = 3,
                                ShowShadow = true,
                                Color = Color3.new(1, 1, 1)
                            })
                        else
                            Toast.Show({
                                Lane = "Banner",
                                Text = "Invalid image, please upload another image.",
                                Seconds = 3,
                                ShowShadow = true,
                                Color = Color3.new(1, 1, 1)
                            })
                        end
                    end
                end)
            else
                Toast.Show({
                    Lane = "Banner",
                    Text = "Invalid image, please upload another image.",
                    Seconds = 3,
                    ShowShadow = true,
                    Color = Color3.new(1, 1, 1)
                })
            end
        end))
    end
end

return t1
