-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    getTextSize = function(p1, p2) -- line: 2
        if p2 == "xsm" then
            if p1 == "sm" then
                return 8
            end

            if p1 == "md" then
                return 12
            end

            return 18
        end

        if p2 == "sm" then
            if p1 == "sm" then
                return 12
            end

            if p1 == "md" then
                return 16
            end

            return 24
        end

        if p2 == "xmd" then
            if p1 == "sm" then
                return 16
            end

            if p1 == "md" then
                return 24
            end

            return 30
        end

        if p2 == "md" then
            if p1 == "sm" then
                return 20
            end

            if p1 == "md" then
                return 32
            end

            return 36
        end

        if p2 == "lg" then
            if p1 == "sm" then
                return 24
            end

            if p1 == "md" then
                return 40
            end

            return 48
        end

        if p2 ~= "xl" then
            return
        end

        if p1 == "sm" then
            return 36
        end

        if p1 == "md" then
            return 52
        end

        return 60
    end,
    getMaxTextSize = function(p3, p4) -- line: 24
        if p4 == "xsm" then
            if p3 == "sm" then
                return 16
            end

            if p3 == "md" then
                return 24
            end

            return 32
        end

        if p4 == "sm" or p4 == "md" then
            if p3 == "sm" then
                return 24
            end

            if p3 == "md" then
                return 32
            end

            return 40
        end

        if p4 ~= "lg" then
            return
        end

        if p3 == "sm" then
            return 24
        end

        if p3 == "md" then
            return 32
        end

        return 40
    end,
    getTextStrokeThickness = function(p5, p6) -- line: 40
        if p6 == "xsm" then
            if p5 == "sm" then
                return 1.5
            end

            if p5 == "md" then
                return 2.5
            end

            return 3
        end

        if p6 == "sm" or p6 == "md" then
            if p5 == "sm" then
                return 2.5
            end

            if p5 == "md" then
                return 4
            end

            return 5
        end

        if p6 ~= "lg" then
            return
        end

        if p5 == "sm" then
            return 2.5
        end

        if p5 == "md" then
            return 4
        end

        return 5
    end,
    getBorderThickness = function(p7, p8) -- line: 56
        if p8 == "xsm" then
            if p7 == "sm" then
                return 1.5
            end

            if p7 == "md" then
                return 2.5
            end

            return 3
        end

        if p8 == "sm" then
            if p7 == "sm" then
                return 2.5
            end

            if p7 == "md" then
                return 4
            end

            return 5
        end

        if p8 == "md" then
            if p7 == "sm" then
                return 3.5
            end

            if p7 == "md" then
                return 5
            end

            return 6
        end

        if p8 ~= "lg" then
            return
        end

        if p7 == "sm" then
            return 4.5
        end

        if p7 == "md" then
            return 6
        end

        return 7
    end,
    getPadding = function(p9, p10) -- line: 72
        if p10 == "xsm" then
            if p9 == "sm" then
                return 5
            end

            if p9 == "md" then
                return 10
            end

            return 15
        end

        if p10 == "sm" then
            if p9 == "sm" then
                return 15
            end

            if p9 == "md" then
                return 25
            end

            return 30
        end

        if p10 == "md" then
            if p9 == "sm" then
                return 25
            end

            if p9 == "md" then
                return 35
            end

            return 40
        end

        if p10 ~= "lg" then
            return
        end

        if p9 == "sm" then
            return 35
        end

        if p9 == "md" then
            return 45
        end

        return 50
    end
}
