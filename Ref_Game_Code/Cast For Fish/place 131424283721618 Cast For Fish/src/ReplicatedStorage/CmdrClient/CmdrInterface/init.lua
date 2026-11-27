-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local LocalPlayer = game:GetService("Players").LocalPlayer

return function(p1) -- line: 6
    -- upvalues: LocalPlayer (copy)
    local Util = p1.Util
    local Window = require(script:WaitForChild("Window"))

    Window.Cmdr = p1

    local v1 = require(script:WaitForChild("AutoComplete"))(p1)

    Window.AutoComplete = v1

    function Window.ProcessEntry(p2) -- line: 17
        -- upvalues: p1 (copy), Util (copy), Window (copy), LocalPlayer (copy)
        local v2 = Util.TrimString(p2)

        if #v2 == 0 then
            return
        end

        Window:AddLine(Window:GetLabel() .. " " .. v2, Color3.fromRGB(255, 223, 93))
        Window:AddLine(p1.Dispatcher:EvaluateAndRun(v2, LocalPlayer, {
            IsHuman = true
        }))
    end

    function Window.OnTextChanged(p3) -- line: 30
        -- upvalues: p1 (copy), Util (copy), Window (copy), v1 (copy), LocalPlayer (copy)
        local v3 = p1.Dispatcher:Evaluate(p3, LocalPlayer, true)
        local v4 = Util.SplitString(p3)
        local v5 = table.remove(v4, 1)
        local v6 = false

        if v3 then
            v4 = Util.MashExcessArguments(v4, #v3.Object.Args)
            v6 = #v4 == #v3.Object.Args
        end

        local v7 = v5 and #v4 > 0

        if p3:sub(#p3, #p3):match("%s") and not v6 then
            v7 = true
            v4[#v4 + 1] = ""
        end

        if not v3 or not v7 then
            if v5 and #v4 == 0 then
                Window:SetIsValidInput(true)

                local Command = p1.Registry:GetCommand(v5)
                local t1

                if Command then
                    t1 = {
                        Command.Name,
                        Command.Name
                    }
                    t1.options = {
                        name = Command.Name,
                        description = Command.Description
                    }

                    local Args = Command.Args

                    if Args then
                        Args = Command.Args[1]

                        if type(Args) == "function" then
                            Args = Args(v3)
                        end

                        if Args and not Args.Optional and Args.Default == nil then
                            Window:SetIsValidInput(false, "This command has required arguments.")
                            Window:HideInvalidState()
                        end
                    elseif type(Args) == "function" then
                        Args = Args(v3)

                        if Args and not Args.Optional and Args.Default == nil then
                            Window:SetIsValidInput(false, "This command has required arguments.")
                            Window:HideInvalidState()
                        end
                    end
                else
                    Window:SetIsValidInput(false, ("%q is not a valid command name. Use the help command to see all available commands."):format(v5))
                end

                local t2 = {
                    t1
                }

                for _, v8 in pairs(p1.Registry:GetCommandNames()) do
                    if v5:lower() == v8:lower():sub(1, #v5) and (t1 == nil or t1[1] ~= v5) then
                        local Command = p1.Registry:GetCommand(v8)

                        t2[#t2 + 1] = {
                            v5,
                            v8,
                            options = {
                                name = Command.Name,
                                description = Command.Description
                            }
                        }
                    end
                end

                return v1:Show(t2)
            end
        else
            local v10, v11 = v3:Validate()

            Window:SetIsValidInput(v10, ("Validation errors: %s"):format(v11 or ""))

            local t5 = {}
            local Argument = v3:GetArgument(#v4)

            if Argument then
                local TextSegmentInProgress = Argument.TextSegmentInProgress
                local v12

                if Argument.RawSegmentsAreAutocomplete then
                    v12 = false

                    for v13, v14 in ipairs(Argument.RawSegments) do
                        t5[v13] = { v14, v14 }
                    end
                else
                    local Autocomplete, Autocomplete2 = Argument:GetAutocomplete()

                    v12 = (Autocomplete2 or {}).IsPartial or false

                    for v15, v16 in pairs(Autocomplete) do
                        t5[v15] = { TextSegmentInProgress, v16 }
                    end
                end

                local v17

                if #TextSegmentInProgress > 0 then
                    v17, v11 = Argument:Validate()
                else
                    v17 = true
                end

                if not v6 and v17 then
                    Window:HideInvalidState()
                end

                local t6 = {}

                t6.at = v6 and #p3 - #TextSegmentInProgress + (p3:sub(#p3, #p3):match("%s") and -1 or 0)
                t6.prefix = #Argument.RawSegments == 1 and Argument.Prefix or ""
                t6.isLast = #v3.Arguments == #v3.ArgumentDefinitions and #TextSegmentInProgress > 0
                t6.numArgs = #v4
                t6.command = v3
                t6.arg = Argument
                t6.name = Argument.Name .. (Argument.Required and "" or "?")
                t6.type = Argument.Type.DisplayName

                if v17 ~= false or not v11 then
                    v11 = Argument.Object.Description
                end

                t6.description = v11
                t6.invalid = not v17
                t6.isPartial = v12

                return v1:Show(t5, t6)
            end
        end

        Window:SetIsValidInput(false, "Use the help command to see all available commands.")
        v1:Hide()
    end

    Window:UpdateLabel()
    Window:UpdateWindowHeight()

    return {
        Window = Window,
        AutoComplete = v1
    }
end
