-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextService = game:GetService("TextService")
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local DisplayName, Thumbnail = require(ReplicatedStorage.Shared.Utils.Identity).DisplayName, require(ReplicatedStorage.Shared.Utils.Identity).Thumbnail
local Log = require(ReplicatedStorage.Packages.Log)
local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)
local Trove = require(ReplicatedStorage.Packages.Trove)

require(script.Parent.Types.Interface)
require(ReplicatedStorage.Client.VideoComments.Types.Interface)

local v1 = Color3.fromRGB(232, 68, 86)
local v2 = Color3.fromRGB(255, 255, 255)
local v3 = Log.new()
local t1 = {}

local function formatPostedAt(p1) -- line: 39
    local v5 = math.max(0, os.time() - p1)

    if v5 < 60 then
        return "just now"
    end

    if v5 < 3600 then
        return (("%*m ago"):format((math.floor(v5 / 60))))
    end

    if v5 < 86400 then
        return (("%*h ago"):format((math.floor(v5 / 3600))))
    end

    return (("%*d ago"):format((math.floor(v5 / 86400))))
end

local function fitDisplayName(p2, p3) -- line: 56
    -- upvalues: TextService (copy)
    p2.Text = p3
    p2.AutomaticSize = Enum.AutomaticSize.X
    p2.TextTruncate = Enum.TextTruncate.AtEnd

    local v10 = math.min(math.ceil(TextService:GetTextSize(p3, p2.TextSize, p2.Font, Vector2.new(1e999, p2.AbsoluteSize.Y)).X) + 2, 140)

    p2.Size = UDim2.new(0, v10, p2.Size.Y.Scale, p2.Size.Y.Offset)
end

local function configureDynamicLayout(p4) -- line: 72
    p4.AutomaticSize = Enum.AutomaticSize.Y
    p4.Size = UDim2.fromScale(1, 0)
    p4.Content.AutomaticSize = Enum.AutomaticSize.Y
    p4.Content.Size = UDim2.new(p4.Content.Size.X.Scale, p4.Content.Size.X.Offset, 0, 0)
    p4.Content.Comment.AutomaticSize = Enum.AutomaticSize.Y
    p4.Content.Comment.Size = UDim2.fromScale(1, 0)
    p4.Content.Comment.TextWrapped = true
end

local function configureOwnerPresentation(p5, p6, p7) -- line: 82
    -- upvalues: v2 (copy)
    local DisplayName = p5.Content.User.DisplayName

    p5.Content.User.OwnerTag.Visible = p6
    DisplayName.OwnerGradient.Enabled = p6
    DisplayName.OwnerStroke.Enabled = p6

    if p6 then
        DisplayName.TextColor3 = v2
    else
        DisplayName.TextColor3 = p7
    end
end

local function loadUserPresentation(p8, p9) -- line: 96
    -- upvalues: Constants (copy), DisplayName (copy), Thumbnail (copy), v3 (copy), fitDisplayName (copy)
    fitDisplayName(p8.Content.User.DisplayName, "Loading...")
    task.spawn(function() -- line: 98
        -- upvalues: p8 (copy), p9 (copy), Constants (copy), DisplayName (copy), v3 (copy), fitDisplayName (copy)
        local ok, result = pcall(DisplayName, p9)

        if p8.Parent ~= nil then
            if ok then
                if p9 == Constants.OWNER_ID then
                    result = ("%*"):format(result)
                end

                fitDisplayName(p8.Content.User.DisplayName, result)
            else
                v3:AtTrace():Log((("Failed to resolve comment display name for user %*"):format(p9)))
            end
        end
    end)
    task.spawn(function() -- line: 112
        -- upvalues: p8 (copy), p9 (copy), Thumbnail (copy), v3 (copy)
        local HeadShot = Enum.ThumbnailType.HeadShot
        local Size150x150 = Enum.ThumbnailSize.Size150x150
        local ok, result = pcall(Thumbnail, p9, HeadShot, Size150x150)

        if p8.Parent ~= nil then
            if not ok or result == nil then
                v3:AtTrace():Log((("Failed to resolve comment avatar for user %*"):format(p9)))
            else
                p8.Avatar.Image = result
            end
        end
    end)
end

function t1.Create(p10, p11, p12, p13, p14) -- line: 135
    -- upvalues: ButtonFX (copy), Constants (copy), Simple (copy), Trove (copy), v1 (copy), v2 (copy), formatPostedAt (copy), configureDynamicLayout (copy), loadUserPresentation (copy)
    local clone = p10:Clone()

    clone.Name = ("Comment_%*"):format(p12.Id)
    clone.LayoutOrder = p13
    clone.Visible = true
    clone.Parent = p11

    local Content = clone.Content
    local PostedAt = Content.Actions.Left.PostedAt
    local Like = Content.Actions.Right.Like
    local Icon = Like.Icon
    local TextColor3, FontFace = Icon.TextColor3, Icon.FontFace
    local TextColor3_2 = Content.User.DisplayName.TextColor3
    local v11 = Trove.new()

    PostedAt.LayoutOrder = Content.User.DisplayName.LayoutOrder + 1
    Content.Comment.Text = p12.Message
    PostedAt.Text = formatPostedAt(p12.CreatedAt)
    configureDynamicLayout(clone)

    local v12 = p12.UserId == Constants.OWNER_ID
    local DisplayName = clone.Content.User.DisplayName

    clone.Content.User.OwnerTag.Visible = v12
    DisplayName.OwnerGradient.Enabled = v12
    DisplayName.OwnerStroke.Enabled = v12
    DisplayName.TextColor3 = if v12 then v2 else TextColor3_2

    if p12.ImageAssetId ~= nil then
        Content.Photo.Visible = true
        Content.Photo.Container.Image.Image = ("rbxassetid://%*"):format(p12.ImageAssetId)
        Content.Photo.Container.Image.ScaleType = Enum.ScaleType.Crop
    else
        Content.Photo.Visible = false
    end

    local function updateLike(p15, p16) -- line: 171
        -- upvalues: Like (copy), Icon (copy), TextColor3 (copy), FontFace (copy), Simple (copy), v1 (copy)
        Icon.TextColor3 = if p15 then v1 else TextColor3
        Icon.FontFace = if p15 then Font.new(FontFace.Family, Enum.FontWeight.Bold, FontFace.Style) else FontFace
        Like.Label.Text = Simple.FormatCompact(math.max(0, p16), ".#")
    end

    local LikedByViewer, LikeCount = p12.LikedByViewer, p12.LikeCount

    Icon.TextColor3 = if LikedByViewer then v1 else TextColor3
    Icon.FontFace = if LikedByViewer then Font.new(FontFace.Family, Enum.FontWeight.Bold, FontFace.Style) else FontFace
    Like.Label.Text = Simple.FormatCompact(math.max(0, LikeCount), ".#")
    loadUserPresentation(clone, p12.UserId)
    v11:Add(ButtonFX(Like, nil, function() -- line: 181
        -- upvalues: p12 (copy), p14 (copy)
        p14(p12.Id)
    end))
    v11:Add(clone)

    return {
        Row = clone,
        UpdateLike = updateLike,
        Destroy = function() -- Destroy | line: 187
            -- upvalues: v11 (copy)
            v11:Destroy()
        end
    }
end

return t1
