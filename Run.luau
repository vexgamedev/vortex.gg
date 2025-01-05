local Players = game:GetService("Players")
local placeId = game.PlaceId
local LocalPlayer = Players.LocalPlayer

local Library
local IsDeveloper = getgenv().IsDeveloper ~= nil and getgenv().IsDeveloper == true
local Anonymous = getgenv().IsAnonymous ~= nil and getgenv().IsAnonymous == true
local suc

if IsDeveloper then
	suc, err = pcall(function() Library = loadstring(readfile("SkillBooster/Library.luau"))() end)
else
	Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/vexgamedev/SkillBooster/refs/heads/main/Library.luau"))()
end

if not suc then
	warn(err)
	Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/vexgamedev/SkillBooster/refs/heads/main/Library.luau"))()
end

task.spawn(function()
	local realName, realDisplayName = LocalPlayer.Name, LocalPlayer.DisplayName
	local fakeName, fakeDisplayName = string.format("SKILLBOOSTER%d",math.random(1000,9999)*math.random(1000,9999)^2), string.format("SKILLBOOSTER%d",math.random(1000,9999)*math.random(1000,9999)^2)
	
	local function replaceInfo(text: string)
		local templateText = text
		if text:lower():find(realName:lower()) then templateText = templateText:lower():gsub(realName:lower(), fakeName) end
		if text:lower():find(realDisplayName:lower()) then templateText = templateText:lower():gsub(realDisplayName:lower(), fakeDisplayName) end
		return templateText
	end

	local function TextLabelAdded(label: TextLabel)
		if label:IsA("TextLabel") then
			label.Text = replaceInfo(label.Text)
			label:GetPropertyChangedSignal("Text"):Connect(function()
				label.Text = replaceInfo(label.Text)
			end)
		end
	end

	if Anonymous ~= nil and Anonymous == true then
		for _, v in next, game:GetDescendants() do TextLabelAdded(v) end
		game.DescendantAdded:Connect(function(v) TextLabelAdded(v) end)
	end
end)

local Window = Library:CreateWindow("Skill Booster", Vector2.new(400, 540), Enum.KeyCode.RightShift)
local NotificationLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/vexgamedev/SkillBooster/refs/heads/main/AkaliNotify.luau"))()
Library.theme.accentcolor = Color3.new(0.603921, 0.011764, 1)

getgenv().Combat = Window:CreateTab("Combat")
getgenv().Blatant = Window:CreateTab("Blatant")
getgenv().Render = Window:CreateTab("Render")

if IsDeveloper == true then
	if isfile("SkillBooster/Games/" .. tostring(placeId) .. ".lua") then
		loadstring(readfile("SkillBooster/Games/" .. tostring(placeId) .. ".lua"))()
	end
else
	local success, source = pcall(function()
		return game:HttpGet("https://github.com/vexgamedev/SkillBooster/blob/main/Games/" .. tostring(placeId) .. ".lua")
	end)
	if not success then
		success, source = pcall(function()
			return game:HttpGet("https://github.com/vexgamedev/SkillBooster/blob/main/Games/" .. tostring(placeId) .. ".luau")
		end)
	end
	if success and typeof(source) == "string" then
		loadstring(source)()
	end
end
