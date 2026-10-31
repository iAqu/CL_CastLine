-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useContext = react.useContext
local default = RuntimeLib.import(script, script.Parent.Parent, "common", "cyt-style", "rounded-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent, "common", "styled-text-label").default
local default3 = RuntimeLib.import(script, script.Parent.Parent, "common", "cyt-style", "cyt-button").default
local v1 = RuntimeLib.import(script, script.Parent.Parent, "utils", "responsive-utils")
local getBorderThickness, getTextStrokeThickness, getMaxTextSize = v1.getBorderThickness, v1.getTextStrokeThickness, v1.getMaxTextSize
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local ThemeContext = RuntimeLib.import(script, script.Parent.Parent, "context", "theme-context").ThemeContext
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local useCanSendGameInvite = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-can-send-game-invite").useCanSendGameInvite
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local SocialService, Players = services.SocialService, services.Players

return {
    default = function(p1) -- FreeRewardWindow | line: 21
        -- upvalues: react (copy), useContext (copy), default (copy), default2 (copy), default3 (copy), getBorderThickness (copy), getTextStrokeThickness (copy), getMaxTextSize (copy), useScreenSizeState (copy), ThemeContext (copy), images (copy), useCanSendGameInvite (copy), SocialService (copy), Players (copy)
        local v2 = useScreenSizeState()
        local v3 = useContext(ThemeContext)
        local v4 = useCanSendGameInvite()
        local Value = v3.colorSequences.greenGradient.Keypoints[1].Value

        return react.createElement(default, {
            backgroundTransparency = 0.7,
            cornerRadius = 15,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor3 = Color3.fromRGB(0, 0, 0),
            borderColor3 = Color3.fromRGB(0, 0, 0),
            borderThickness = getBorderThickness(v2, "md"),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(0.45, 0.7)
        }, react.createElement(default3, {
            cornerRadius = 25,
            uiAspectRatio = 1,
            zIndex = 10,
            anchorPoint = Vector2.new(0.5, 0.5),
            borderThickness = getBorderThickness(v2, "sm"),
            onClick = p1.onClose,
            position = UDim2.fromScale(1, 0),
            size = UDim2.fromScale(0.12, 0.12)
        }, react.createElement(default, {
            cornerRadius = 25,
            zIndex = 1,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor3 = Color3.fromRGB(255, 0, 0),
            borderColor3 = Color3.fromRGB(0, 0, 0),
            borderThickness = getBorderThickness(v2, "sm"),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1)
        }, react.createElement("textlabel", {
            BackgroundTransparency = 1,
            Text = "X",
            TextScaled = true,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Font = v3.textFont,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.75, 0.75),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextXAlignment = Enum.TextXAlignment.Center
        }, react.createElement("uistroke", {
            Color = Color3.fromRGB(0, 0, 0),
            Thickness = getBorderThickness(v2, "xsm")
        })))), react.createElement("frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.12),
            Size = UDim2.fromScale(0.9, 0.1)
        }, react.createElement(default2, {
            text = "FREE RABBIT GEM",
            overrideProps = {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.3),
                Size = UDim2.fromScale(1, 1)
            }
        }, react.createElement("uigradient", {
            Color = v3.colorSequences.blueGradient
        }), react.createElement("uistroke", {
            Color = Color3.fromRGB(0, 0, 0),
            Thickness = getTextStrokeThickness(v2, "lg")
        }), react.createElement("uitextsizeconstraint", {
            MaxTextSize = getMaxTextSize(v2, "lg")
        }))), react.createElement("frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.22),
            Size = UDim2.fromScale(0.8, 0.08)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0, 10),
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement("textlabel", {
            BackgroundTransparency = 1,
            Text = "🔥",
            TextScaled = true,
            Font = Enum.Font.FredokaOne,
            Size = UDim2.fromScale(0.15, 1),
            TextColor3 = Value
        }, react.createElement("uistroke", {
            Color = Color3.fromRGB(0, 0, 0),
            Thickness = getTextStrokeThickness(v2, "sm")
        })), react.createElement(default2, {
            text = "How to Claim",
            overrideProps = {
                Size = UDim2.fromScale(0.6, 1)
            },
            textColor3 = Value
        }, react.createElement("uistroke", {
            Color = Color3.fromRGB(0, 0, 0),
            Thickness = getTextStrokeThickness(v2, "md")
        }), react.createElement("uitextsizeconstraint", {
            MaxTextSize = getMaxTextSize(v2, "md")
        })), react.createElement("textlabel", {
            BackgroundTransparency = 1,
            Text = "🔥",
            TextScaled = true,
            Font = Enum.Font.FredokaOne,
            Size = UDim2.fromScale(0.15, 1),
            TextColor3 = Value
        }, react.createElement("uistroke", {
            Color = Color3.fromRGB(0, 0, 0),
            Thickness = getTextStrokeThickness(v2, "sm")
        }))), react.createElement("frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.55),
            Size = UDim2.fromScale(0.9, 0.5)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Top
        }), react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            Size = UDim2.fromScale(1, 0.3)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0, 5),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement(default2, {
            text = "1. Like and Favourite the game!",
            overrideProps = {
                Size = UDim2.fromScale(1, 0.35)
            }
        }, react.createElement("uistroke", {
            Color = Color3.fromRGB(0, 0, 0),
            Thickness = getTextStrokeThickness(v2, "sm")
        }), react.createElement("uitextsizeconstraint", {
            MaxTextSize = getMaxTextSize(v2, "sm")
        })), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.likeGuide,
            Position = UDim2.fromScale(0.5, 0.5),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(1, 1)
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 2,
            Size = UDim2.fromScale(1, 0.3)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0, 5),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement(default2, {
            text = "2. Join our Community!",
            overrideProps = {
                Size = UDim2.fromScale(1, 0.35)
            }
        }, react.createElement("uistroke", {
            Color = Color3.fromRGB(0, 0, 0),
            Thickness = getTextStrokeThickness(v2, "sm")
        }), react.createElement("uitextsizeconstraint", {
            MaxTextSize = getMaxTextSize(v2, "sm")
        })), react.createElement(default3, {
            cornerRadius = 8,
            layoutOrder = 2,
            borderThickness = getBorderThickness(v2, "sm"),
            onClick = p1.onJoinCommunity or function() -- line: 188
            end,
            size = UDim2.fromScale(0.3, 0.45)
        }, react.createElement(default, {
            cornerRadius = 8,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColorSequence = v3.colorSequences.lightBlue,
            borderColor3 = Color3.fromRGB(0, 0, 0),
            borderThickness = getBorderThickness(v2, "sm"),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1)
        }, react.createElement(default2, {
            text = "Join",
            overrideProps = {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.8, 0.8)
            },
            textColor3 = Color3.fromRGB(255, 255, 255)
        }, react.createElement("uitextsizeconstraint", {
            MaxTextSize = getMaxTextSize(v2, "sm")
        }))))), react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 3,
            Size = UDim2.fromScale(1, 0.3)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0, 5),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement(default2, {
            text = "3. Invite all your Friends!",
            overrideProps = {
                Size = UDim2.fromScale(1, 0.35)
            }
        }, react.createElement("uistroke", {
            Color = Color3.fromRGB(0, 0, 0),
            Thickness = getTextStrokeThickness(v2, "sm")
        }), react.createElement("uitextsizeconstraint", {
            MaxTextSize = getMaxTextSize(v2, "sm")
        })), react.createElement(default3, {
            cornerRadius = 8,
            layoutOrder = 2,
            borderThickness = getBorderThickness(v2, "sm"),
            onClick = function() -- onClick | line: 232
                -- upvalues: v4 (copy), SocialService (copy), Players (copy)
                if v4 then
                    SocialService:PromptGameInvite(Players.LocalPlayer)
                end
            end,
            size = UDim2.fromScale(0.3, 0.45)
        }, react.createElement(default, {
            cornerRadius = 8,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColorSequence = v3.colorSequences.lightBlue,
            borderColor3 = Color3.fromRGB(0, 0, 0),
            borderThickness = getBorderThickness(v2, "sm"),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1)
        }, react.createElement(default2, {
            text = "Invite",
            overrideProps = {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.8, 0.8)
            },
            textColor3 = Color3.fromRGB(255, 255, 255)
        }, react.createElement("uitextsizeconstraint", {
            MaxTextSize = getMaxTextSize(v2, "sm")
        })))))), react.createElement(default3, {
            cornerRadius = 10,
            anchorPoint = Vector2.new(0.5, 0.5),
            borderThickness = getBorderThickness(v2, "md"),
            onClick = p1.onClaim,
            position = UDim2.fromScale(0.5, 0.92),
            size = UDim2.fromScale(0.5, 0.1)
        }, react.createElement(default, {
            cornerRadius = 10,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColorSequence = if p1.isClaimed then v3.colorSequences.white else v3.colorSequences.greenGradient,
            borderColor3 = Color3.fromRGB(0, 100, 0),
            borderThickness = getBorderThickness(v2, "md"),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1)
        }, react.createElement(default2, {
            overrideProps = {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.9, 0.9)
            },
            text = p1.isClaimed and "CLAIMED" or "Claim!",
            textColor3 = Color3.fromRGB(255, 255, 255)
        }, react.createElement("uistroke", {
            Color = Color3.fromRGB(0, 0, 0),
            Thickness = getTextStrokeThickness(v2, "md")
        }), react.createElement("uitextsizeconstraint", {
            MaxTextSize = getMaxTextSize(v2, "md")
        })))))
    end
}
