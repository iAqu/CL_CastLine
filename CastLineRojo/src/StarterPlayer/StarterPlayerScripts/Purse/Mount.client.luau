--!strict

-- AnimalFarm mount script. Requiring the module builds the BackpackGui/hotbar.
-- The topbar backpack icon is created separately by the sibling TopbarIcon script,
-- which also requires this module; requiring it twice is a no-op (module cached).

require(script.Parent)
