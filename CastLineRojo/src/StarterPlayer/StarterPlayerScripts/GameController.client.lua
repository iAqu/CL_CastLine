-- local CollectionService = game:GetService("CollectionService")
-- local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- require the Stroke Adjustermodule, this modele take effect
-- local UIStrokeAdjuster = require(ReplicatedStorage.Libs.UIStrokeAdjuster)   

-- -- handle car initialization
-- local CarManager = require(game.ReplicatedStorage.Modules.CarManager)

-- local function handleNewCar(part)
--     -- LogHelper.Print("New TestCar found, part.name = ", part.Name)
--     local maxHealth = 10000
--     CarManager.initializeCar(part, maxHealth)
-- end

-- -- handle existing cars
-- for _, part in CollectionService:GetTagged("TestCar0") do 
--     handleNewCar(part)
-- end

-- -- handle new cars
-- CollectionService:GetInstanceAddedSignal("TestCar0"):Connect(handleNewCar)

-- -- handle GUI
-- local GUIManager = require(game.ReplicatedStorage.Modules.GUIManager)

-- local function handleNewGUITriiger(part)
--     -- LogHelper.Print("New GUI found, part.name = ", part.Name)
--     GUIManager.initGUITrigger(part)
-- end

-- for _, part in CollectionService:GetTagged("GUITrigger") do 
--     handleNewGUITriiger(part)
-- end

-- CollectionService:GetInstanceAddedSignal("GUITrigger"):Connect(handleNewGUITriiger)




