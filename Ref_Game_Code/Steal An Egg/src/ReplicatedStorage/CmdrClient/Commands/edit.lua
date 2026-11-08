-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local t1 = {
    BackgroundTransparency = 0.05,
    BorderSizePixel = 20,
    ClearTextOnFocus = false,
    MultiLine = true,
    TextWrapped = true,
    TextSize = 18,
    TextXAlignment = "Left",
    TextYAlignment = "Top",
    AutoLocalize = false,
    PlaceholderText = "Right click to exit",
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Color3.fromRGB(17, 17, 17),
    BorderColor3 = Color3.fromRGB(17, 17, 17),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = UDim2.new(0.5, 0, 0.4, 0),
    Font = Enum.Font.Code,
    TextColor3 = Color3.fromRGB(241, 241, 241)
}
local v1

return {
    Name = "edit",
    Description = "Edit text in a TextBox",
    Group = "DefaultUtil",
    Aliases = {},
    Args = {
        {
            Type = "string",
            Name = "Input text",
            Description = "The text you wish to edit",
            Default = ""
        },
        {
            Type = "string",
            Name = "Delimiter",
            Description = "The character that separates each line",
            Default = ","
        }
    },
    ClientRun = function(p1, p2, p3) -- ClientRun | line: 45
        -- upvalues: Players (copy), t1 (copy), v1 (ref)
        v1 = v1 or p1.Cmdr.Util.Mutex()

        local v2 = v1()

        p1:Reply("Right-click on the text area to exit.", Color3.fromRGB(158, 158, 158))

        local ScreenGui = Instance.new("ScreenGui")

        ScreenGui.Name = "CmdrEditBox"
        ScreenGui.ResetOnSpawn = false

        local TextBox = Instance.new("TextBox")

        for v3, v4 in pairs(t1) do
            TextBox[v3] = v4
        end

        TextBox.Text = p2:gsub(p3, "\n")
        TextBox.Parent = ScreenGui
        ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

        local thread = coroutine.running()

        TextBox.InputBegan:Connect(function(p4) -- line: 69
            -- upvalues: p3 (copy), v2 (copy), ScreenGui (copy), TextBox (copy), thread (copy)
            if p4.UserInputType ~= Enum.UserInputType.MouseButton2 then
                return
            end

            coroutine.resume(thread, TextBox.Text:gsub("\n", p3))
            ScreenGui:Destroy()
            v2()
        end)

        return coroutine.yield()
    end
}
