--[[----------------------------------------------------------------------

YARDS HUB DOCUMENTATION

----------------------------------------------------------------------]]--

--[[----------------------------------------------------------------------

GETTING THE LIBRARY

----------------------------------------------------------------------]]--
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/exigents/Yard-s-Hub-v1/main/lib.lua"))()

--[[----------------------------------------------------------------------

CREATING A WINDOW
Arguments: 
title = "UI HUB TITLE"
color = Color3.fromRGB(255, 255, 255)

----------------------------------------------------------------------]]--

local Window = lib:new({
	title = "UI HUB TITLE",
})

--[[----------------------------------------------------------------------

CREATING A TAB
Arguments: 
title = "TAB TITLE"
icon = AssetId

----------------------------------------------------------------------]]--

local Tab = Window:NewTab({
	title = "Home",
	icon = 13212905277,
})

--[[----------------------------------------------------------------------

CREATING A BUTTON
Arguments: 
title = "BUTTON TITLE"
callback = function() end

----------------------------------------------------------------------]]--

local Button = Tab:MakeButton({
	title = "Test",
	callback = function()
		print("Clicked Test Button")
	end,
})

--[[----------------------------------------------------------------------

CREATING A WARNING
Arguments: 
text = "Warning Text"


Updating Funcs:
Warning:Update
----------------------------------------------------------------------]]--

local Warning = Tab:MakeWarning({
	text = "Warning 1"
})

Warning:Update({
	text = "Warning 2"
})

--[[----------------------------------------------------------------------

CREATING A INFORMATION BOX
Arguments: 
text = "Information Text"


Updating Funcs:
Warning:Update
----------------------------------------------------------------------]]--

local Information = Tab:MakeInfo({
	text = "Info 1"
})

Information:Update({
	text = "Info 2"
})

--[[----------------------------------------------------------------------

CREATING A SLIDER
Arguments: 
title = "Slider Title"
start = 0 -- START VALUE
min = 0 -- MIN VALUE
max = 100 -- MAX VALUE
callback = function(value) end


Updating Funcs:
Slider:SetValue(20)
----------------------------------------------------------------------]]--

local Slider = Tab:MakeSlider({
	title = "Slider 1",
	start = 25,
	min = 1,
	max = 100,
	callback = function(value)
		print(value)
	end,
})

Slider:SetValue(50)

--[[----------------------------------------------------------------------

CREATING A TOGGLE
Arguments: 
title = "Toggle Title"
start = false,
callback = function(value) end

----------------------------------------------------------------------]]--

local Toggle = Tab:MakeToggle({
	title = "Toggle 1",
	start = false,
	callback =function(val)
		print(val)
	end,
})

--[[----------------------------------------------------------------------

CREATING A DROPDOWN
Arguments: 
title = "Dropdown Title"
options = {"Option 1", "Option 2"}
callback = function(value) end

----------------------------------------------------------------------]]--

local Dropdown = Tab:MakeDropdown({
	title = "Dropdown 1",
	options = {"Option 1", "Option 2", "Option 3", "Option 4", "Option 5"},
	callback = function(value)
		print(value)
	end,
})

--[[----------------------------------------------------------------------

CREATING A NOTIFICATION
Arguments: 
title = "Notification Title"
text = "Notification Text"
icon = AssetId
length = 5

----------------------------------------------------------------------]]--

Window:Notify({
    title = "Notification",
    text = "Test",
    length = 10,
    icon = 13223888731
})
