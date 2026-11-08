-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Bind = function(p1) -- Bind | line: 4
        local t1 = {}

        for _, v1 in p1 do
            for _, child in v1:GetChildren() do
                if child:IsA("Model") and child:GetAttribute("TrainWheel") == true then
                    local TrainWheelRadius = child:GetAttribute("TrainWheelRadius")
                    local TrainWheelAxis = child:GetAttribute("TrainWheelAxis")

                    assert(type(TrainWheelRadius) == "number" and TrainWheelRadius > 0 and TrainWheelRadius < 1e999, "Invalid train wheel radius")
                    assert(typeof(TrainWheelAxis) == "Vector3" and math.abs(TrainWheelAxis.Magnitude - 1) < 0.001, "Invalid train wheel axle")

                    local Pivot = child:GetPivot()
                    local v5 = Pivot:VectorToWorldSpace(TrainWheelAxis):Dot(v1:GetPivot().RightVector)

                    assert(math.abs(v5) > 0.99, "Train wheel axle is not lateral")
                    table.insert(t1, {
                        Car = v1,
                        Model = child,
                        Frame = v1:GetPivot():ToObjectSpace(Pivot),
                        Axis = TrainWheelAxis,
                        Radius = TrainWheelRadius,
                        Direction = v5 > 0 and 1 or -1
                    })
                end
            end
        end

        return t1
    end,
    Update = function(p2, p3) -- Update | line: 31
        for _, v7 in p2 do
            if v7.Model.Parent and v7.Car.Parent then
                local v8 = -p3 / v7.Radius * v7.Direction % 6.283185307179586

                v7.Model:PivotTo(v7.Car:GetPivot() * v7.Frame * CFrame.fromAxisAngle(v7.Axis, v8))
            end
        end
    end
}
