local RainbowGradientModule = {}

local animationThread = nil

-- local gradient = guiObject.UIGradient
local gradient = nil
local ts = game:GetService("TweenService")
local ti = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
local offset = {Offset = Vector2.new(1, 0)}

local originalColor = nil
local originalOffset = nil
local originalRotation = nil
-- local create = ts:Create(gradient, ti, offset)
local create = nil
local startingPos = Vector2.new(-1, 0)
local s, kpt = ColorSequence.new, ColorSequenceKeypoint.new
local counter = 0
local status = "down"
local list = {}

local function animate()
    while true do
        create:Play()
        create.Completed:Wait()
        gradient.Offset = startingPos
        gradient.Rotation = 180
        
        if counter == #list - 1 and status == "down" then
            gradient.Color = s({
                kpt(0, gradient.Color.Keypoints[1].Value),
                kpt(0.5, list[#list]),
                kpt(1, list[1])
        
            })
            counter = 1
            status = "up"
            
        elseif counter == #list and status == "down" then
            
            gradient.Color = s({
                kpt(0, gradient.Color.Keypoints[1].Value),
                kpt(0.5, list[1]),
                kpt(1, list[2])
            })
        
            counter = 2
            status = "up"
            
        elseif counter <= #list - 2 and status == "down" then 
            
            gradient.Color = s({ 
                kpt(0, gradient.Color.Keypoints[1].Value),
                kpt(0.5, list[counter + 1]),
                kpt(1, list[counter + 2])
            })
            counter = counter + 2
            status = "up"
        end
        
        create:Play()
        create.Completed:Wait()
        gradient.Offset = startingPos
        gradient.Rotation = 0
        
        if counter == #list - 1 and status == "up" then
            
            gradient.Color = s({
            
                kpt(0, list[1]),
                kpt(0.5, list[#list]),
                kpt(1, gradient.Color.Keypoints[3].Value)
                    
            })
            
            counter = 1
            status = "down"
            
        elseif counter == #list and status == "up" then
            
            gradient.Color = s({     
                kpt(0, list[2]),
                kpt(0.5, list[1]),
                kpt(1, gradient.Color.Keypoints[3].Value)    
            })
    
            counter = 2
            status = "down"

        elseif counter <= #list - 2 and status == "up" then

            gradient.Color = s({ 
                kpt(0, list[counter + 2]),
                kpt(0.5, list[counter + 1]),
                kpt(1, gradient.Color.Keypoints[3].Value)  
            })

            counter = counter + 2
            status = "down"
        end
    end
end

function RainbowGradientModule.StartRainbowAnimation(guiObject, Colorlist)
    if create then
        create:Destroy()
        -- create:Cancel()
        create = nil
    end

    if animationThread then
        task.cancel(animationThread)
        animationThread = nil
    end

    originalColor = guiObject.UIGradient.Color
    originalOffset = guiObject.UIGradient.Offset
    originalRotation = guiObject.UIGradient.Rotation

    list = Colorlist
    gradient = guiObject.UIGradient
    gradient.Offset = startingPos
    gradient.Color = s({
        kpt(0, list[#list]),
        kpt(0.5, list[#list - 1]),
        kpt(1, list[#list - 2])
    })

    counter = #list

    create = ts:Create(gradient, ti, offset)

    animationThread = task.spawn(animate)
end

function RainbowGradientModule.StopRainbowAnimation(guiObject)

    if create then
        -- create:Cancel()
        create:Pause()
        create:Destroy()
        create = nil
    end
    if animationThread then
        task.cancel(animationThread)
        animationThread = nil
    end

    guiObject.UIGradient.Color = originalColor
    guiObject.UIGradient.Offset = Vector2.new(0, 0)
    guiObject.UIGradient.Rotation = originalRotation
end

return RainbowGradientModule
