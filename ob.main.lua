setclipboard(tostring(game.Players.LocalPlayer.Character.HumanoidRootPart.Position))
local HALT;
if game.CoreGui:FindFirstChild("HALT") then
   HALT = game.CoreGui:FindFirstChild("HALT")
   HALT.Value = false
else
   HALT = Instance.new("BoolValue",game.CoreGui)
   HALT.Name = "HALT"
end
HALT.Value = true
task.wait(.5)
HALT.Value = false
local colors = {
   SchemeColor = Color3.fromRGB(105,105,105),
   Background = Color3.fromRGB(0, 0, 0),
   Header = Color3.fromRGB(0, 0, 0),
   TextColor = Color3.fromRGB(0,255,0),
   ElementColor = Color3.fromRGB(20, 20, 20)
}

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("County Jail Roleplay 2023", colors)

--MAIN
local Main = Window:NewTab("Main")
local MainSection = Main:NewSection("Main")


MainSection:NewToggle("Auto sprint", "Makes you auto sprint", function(v)
if v then
   game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 20
else
   game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
end
end)

MainSection:NewToggle("Shift lock", "Makes it so you can use shift lock", function(v)
if v then
   game.Players.LocalPlayer.DevEnableMouseLock = true
else
   game.Players.LocalPlayer.DevEnableMouseLock = false
end
end)

if game.CoreGui:FindFirstChild("ESP") then
   game.CoreGui:FindFirstChild("ESP"):Remove()
end

MainSection:NewButton("Reset","Reset your character",function(v)

local args = {
   [1] = "Reset"
}

game:GetService("ReplicatedStorage").Events.EscapeHandler:FireServer(unpack(args))

end)

local Holder = Instance.new("Folder", game.CoreGui)
Holder.Name = "ESP"

local Box = Instance.new("BoxHandleAdornment")
Box.Name = "nilBox"
Box.Size = Vector3.new(4, 7, 4)
Box.Color3 = Color3.new(100 / 255, 100 / 255, 100 / 255)
Box.Transparency = 0.7
Box.ZIndex = 0
Box.AlwaysOnTop = true
Box.Visible = true

local NameTag = Instance.new("BillboardGui")
NameTag.Name = "nilNameTag"
NameTag.Enabled = false
NameTag.Size = UDim2.new(0, 200, 0, 50)
NameTag.AlwaysOnTop = true
NameTag.StudsOffset = Vector3.new(0, 1.8, 0)
local Tag = Instance.new("TextLabel", NameTag)
Tag.Name = "Tag"
Tag.BackgroundTransparency = 1
Tag.Position = UDim2.new(0, -50, 0, 0)
Tag.Size = UDim2.new(0, 300, 0, 20)
Tag.TextSize = 20
Tag.TextColor3 = Color3.new(100 / 255, 100 / 255, 100 / 255)
Tag.TextStrokeColor3 = Color3.new(0 / 255, 0 / 255, 0 / 255)
Tag.TextStrokeTransparency = 0.4
Tag.Text = "nil"
Tag.Font = Enum.Font.SourceSansBold
Tag.TextScaled = false

local LoadCharacter = function(v)
if v.Userid == game.Players.LocalPlayer.UserId then return end
repeat wait() until v.Character ~= nil
   v.Character:WaitForChild("Humanoid")
   local vHolder = Holder:FindFirstChild(v.Name)
   vHolder:ClearAllChildren()
   local b = Box:Clone()
   b.Name = v.Name .. "Box"
   b.Adornee = v.Character
   b.Parent = vHolder
   local t = NameTag:Clone()
   t.Name = v.Name .. "NameTag"
   t.Enabled = true
   t.Parent = vHolder
   t.Adornee = v.Character:WaitForChild("Head", 5)
   if not t.Adornee then
      return UnloadCharacter(v)
   end
   t.Tag.Text = v.Name
   b.Color3 = Color3.new(v.TeamColor.r, v.TeamColor.g, v.TeamColor.b)
   t.Tag.TextColor3 = Color3.new(v.TeamColor.r, v.TeamColor.g, v.TeamColor.b)
   local Update
   local UpdateNameTag = function()
   if not pcall(function()
   v.Character.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
   local maxh = math.floor(v.Character.Humanoid.MaxHealth)
   local h = math.floor(v.Character.Humanoid.Health)
   t.Tag.Text = v.Name .. "\n" .. ((maxh ~= 0 and tostring(math.floor((h / maxh) * 100))) or "0") .. "%  " .. tostring(h) .. "/" .. tostring(maxh)
   end) then
      Update:Disconnect()
   end
end
UpdateNameTag()
Update = v.Character.Humanoid.Changed:Connect(UpdateNameTag)
end

local UnloadCharacter = function(v)
local vHolder = Holder:FindFirstChild(v.Name)
if vHolder and (vHolder:FindFirstChild(v.Name .. "Box") ~= nil or vHolder:FindFirstChild(v.Name .. "NameTag") ~= nil) then
vHolder:ClearAllChildren()
end
end

local LoadPlayer = function(v)
if v.Userid == game.Players.LocalPlayer.UserId then return end
local vHolder = Instance.new("Folder", Holder)
vHolder.Name = v.Name
v.CharacterAdded:Connect(function()
pcall(LoadCharacter, v)
end)
v.CharacterRemoving:Connect(function()
pcall(UnloadCharacter, v)
end)
v.Changed:Connect(function(prop)
if prop == "TeamColor" then
UnloadCharacter(v)
wait()
LoadCharacter(v)
end
end)
LoadCharacter(v)
end

local UnloadPlayer = function(v)
UnloadCharacter(v)
local vHolder = Holder:FindFirstChild(v.Name)
if vHolder then
vHolder:Destroy()
end
end
local ESPEnabled = false



MainSection:NewToggle("Esp", "See players through walls", function()

if ESPEnabled == true then
ESPEnabled = false
else
ESPEnabled = true
end
if ESPEnabled == false then
game.CoreGui.ESP:ClearAllChildren()
return
end

for i,v in pairs(game:GetService("Players"):GetPlayers()) do
if ESPEnabled == false then return end
spawn(function() pcall(LoadPlayer, v) end)
end


game:GetService("Players").LocalPlayer.NameDisplayDistance = 0
end)



game:GetService("Players").PlayerAdded:Connect(function(v)
if ESPEnabled == false then return end
pcall(LoadPlayer, v)
end)

game:GetService("Players").PlayerRemoving:Connect(function(v)
if ESPEnabled == false then return end
pcall(UnloadPlayer, v)
end)

local SLIENTAIMENABLED = false

local localPlayer = game:GetService("Players").LocalPlayer
local mouse = localPlayer:GetMouse()
local teamCheck = true
local sameTeams = {
["Minimum Security"]= {"Minimum Security","Medium Security","Maximum Security","Booking","Escapee"},
["Medium Security"]= {"Minimum Security","Medium Security","Maximum Security","Booking","Escapee"},
["Maximum Security"]= {"Minimum Security","Medium Security","Maximum Security","Booking","Escapee"},
["Booking"]= {"Minimum Security","Medium Security","Maximum Security","Booking","Escapee"},
["Escapee"]= {"Minimum Security","Medium Security","Maximum Security","Booking","Escapee"},
["Department of Corrections"]= {"Sheriff's Office","State Police","Department of Corrections"}
}

local optionsEnabled = {
noDoors = false,
noGarages = false,
}
local ENABLED = false
MainSection:NewToggle("No Garages", "Makes it so there are no Garages", function()
optionsEnabled["noGarages"] = not optionsEnabled["noGarages"]
end)
local doors = {}
for _,v in pairs(game.Workspace:GetDescendants()) do
if v:IsA("Model") then
if v:FindFirstChild("DoorPart") then
table.insert(doors,v)
end
end
end
MainSection:NewToggle("No doors", "Makes it so there are no doors", function()
if #DOORS == 0 then
game.StarterGui:SetCore("SendNotification", {
Title = "No more doors!";
Text = "You removed all the doors you silly pants";
Duration = 5;
})
return
end
ENABLED = true
optionsEnabled["noDoors"] = not optionsEnabled["noDoors"]
end)
MainSection:NewButton("No Vents", "Makes it so there are no vents", function()
for i, v in pairs(game.Workspace.Skeleton.Interactions.Prox:GetChildren()) do
if v:IsA("BasePart") then
if string.split(v.Name,"/")[2] and string.split(v.Name,"/")[2] == "VentDoor" then
v:Remove()
end
end
end
end)
MainSection:NewButton("Remove Pepper Spray Effect", "No more orange screen", function()
game:GetService("Players").LocalPlayer.PlayerGui.FirearmUI.Pepper:Remove()
end)
MainSection:NewButton("No Gates", "Makes it so there are no Gates", function()
workspace.Fence.EntranceGate:Remove()
workspace.Fence.ExitGate:Remove()
end)


MainSection:NewButton("Completely Remove Doors", "REMOVES DOORS", function()
for i, v in pairs(doors) do
v:Remove()
end
end)
MainSection:NewButton("Completely Remove GATES", "REMOVES GATES", function()
for i, v in pairs(doors) do
for i, v in pairs(game.Workspace.Doors:GetChildren()) do
if v:IsA("Model") then
if v:FindFirstChild("DecoCard1") and v:FindFirstChild("Door") and v:FindFirstChild("Door"):FindFirstChild("OpenSound") then
v:Remove()
end -- findFirst statement
end -- if model statement
end
end
end)

MainSection:NewButton("Remove Guard Hitbox", "It removes the hitbox preventing the guards from going further", function()
workspace.Skeleton.Interactions.CollisionNoMouse:ClearAllChildren()
end)
MainSection:NewButton("No Fences", "Bye bye fences!", function()
workspace.Fence.FenceChain:ClearAllChildren()
for _,e in pairs(game.Workspace.Map:GetChildren()) do
if e.Name == "hitbox" then
e:Remove()
end
end
end)


spawn(function()

while task.wait(0) do
if HALT.Value == true then break end

if optionsEnabled["noGarages"] then
for i, v in pairs(game.Workspace.Doors:GetChildren()) do
if v:IsA("Model") then
if v:FindFirstChild("DecoCard1") and v:FindFirstChild("Door") and v:FindFirstChild("Door"):FindFirstChild("OpenSound") then
   for _,e in pairs(v:GetDescendants()) do
      if e:IsA("BasePart") then
         e.CanCollide = false
         e.Transparency = 0.5
      end -- basepart statement
   end -- starting loop statement
end -- findFirst statement
end -- if model statement
end --for statement


else
for i, v in pairs(game.Workspace.Doors:GetChildren()) do
if v:IsA("Model") then
if v:FindFirstChild("DecoCard1") and v:FindFirstChild("Door") and v:FindFirstChild("Door"):FindFirstChild("OpenSound") then
   for _,e in pairs(v:GetDescendants()) do
      if e:IsA("BasePart") then
         e.CanCollide = true
         e.Transparency = 0
      end

   end
end
end
end
end -- end of noGarages
if ENABLED then
if optionsEnabled["noDoors"] then
for i, v in pairs(doors) do
for _,e in pairs(v:GetDescendants()) do
   if e:IsA("BasePart") then
      e.CanCollide = false
      e.Transparency = 0.5
   end -- base
end -- with
end -- for state

else
for i, v in pairs(doors) do
for _,e in pairs(v:GetDescendants()) do
   if e:IsA("BasePart") then
      e.CanCollide = true
      e.Transparency = 0
   end -- basepart
end -- within part state
end -- for state
end -- end of noDoors
end

end
end)

local DEBUG =false

--Development
if DEBUG then
local Dev=Window:NewTab("Dev")
local DevSec=Dev:NewSection("Dev")
DevSec:NewButton("DarkDex","Enable Dex",function()
local file = "dexV4.lua" -- cache file name (workspace folder)
local url = "https://raw.githubusercontent.com/loglizzy/dexV4/main/source.lua"

local raw = isfile and isfile(file) and readfile(file)
raw = raw or game:HttpGet(url)

if isfile then
task.spawn(writefile, file, game:HttpGet(url))
end

loadstring(raw)()
end)

DevSec:NewButton("Remote Spy","Enable Remote Spy",function()
loadstring(game:HttpGet("https://github.com/exxtremestuffs/SimpleSpySource/raw/master/SimpleSpy.lua"))()
end)

DevSec:NewButton("Infinte Yield","Enable Infinte Yield Admin",function()
loadstring(game:HttpGet(('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'),true))()
end)
DevSec:NewButton("HALF ALL SCRIPTS","Once you do this close this GUI",function()
HALT.Value = true
print("Halt")
game.StarterGui:SetCore("SendNotification", {
Title = "Wait!";
Text = "Wait until this notfication disappears";
Duration = 5;
Button1 = "Don't fucking dismiss me retard";
})
task.wait(5)
print("Safe")
HALT.Value = false
game.StarterGui:SetCore("SendNotification", {
Title = "Fin!";
Text = "You can safely close this and reopen a new script tard";
Duration = 5;
Button1 = "Now you can dismiss me retard";
})
end)

DevSec:NewButton("Humanoid RootPart CFrame","Get the current CFrame of player",function()
print(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
setclipboard(tostring(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame))
game.StarterGui:SetCore("SendNotification", {
Title = "Got!";
Text = "Successfully got your HumanoidRootPart";
Duration = 5;

})
end)

end

--TEAM
local TeamWin = Window:NewTab("Team")
local Team = TeamWin:NewSection("Team")

function returnToMenu()
local args = {
[1] = "ReturnToMenu"
}

game:GetService("ReplicatedStorage").Events.SendRequestToHandler:FireServer(unpack(args))

end

function changeTeam(arg1,arg2)
local args = {
[1] = arg1,
[2] = arg2
}

game:GetService("ReplicatedStorage").Functions.SelectTeam:InvokeServer(unpack(args))
end

Team:NewButton("Menu","Return to Menu",function()


returnToMenu()

end)


Team:NewButton("Booking","Switch to Booking Team",function()

returnToMenu()
task.wait(1)
changeTeam("Team","Inmates")

end)





Team:NewButton("Employee","Switch to Employee Team",function()

returnToMenu()
task.wait(.5)
changeTeam("Team","Department of Corrections")
task.wait(1)
changeTeam("Job","Employee")

end)


Team:NewButton("Civilian","Switch to Civ Team",function()

changeTeam("Team","Civilian")


end)

--TROLL
local Troll = Window:NewTab("Troll")
local TrollSection = Troll:NewSection("Troll")
TrollSection:NewToggle("Toggle TypingBubble","Toggle the typing bubble when you are about to chat",function(v)
if v then
game:GetService("ReplicatedStorage").Events.ToggleTypingBubble:FireServer(true)
else
game:GetService("ReplicatedStorage").Events.ToggleTypingBubble:FireServer(false)
end
end)

--PLAYER
local Player = Window:NewTab("Player")
local PlayerSection = Player:NewSection("Player")

PlayerSection:NewSlider("Speed", "Sets your speed", 35, 16, function(v)
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
end)
--[[
PlayerSection:NewSlider("Jump Power", "Sets your jump power", 90, 50, function(v)
game.Players.LocalPlayer.Character.Humanoid.JumpPower = v
end)

PlayerSection:NewSlider("Gravity", "Sets gravity", 196.2, 0, function(v)
game.Workspace.Gravity = v
end)
--]]
-- Teleport Function
local STOP = false
local function teleportPlayerStepByStep(destinationCFrame)
if STOP then
return
end
local player = game.Players.LocalPlayer
local character = player.Character

if character then
local humanoid = character:FindFirstChild("Humanoid")
if humanoid then
local startPosition = humanoid.RootPart.CFrame
local distance = (destinationCFrame.Position - startPosition.Position).Magnitude
local totalSteps = math.ceil(distance / 5) -- Adjust the step size as needed

local teleportDistance = (destinationCFrame.Position - startPosition.Position) / totalSteps

for step = 1, totalSteps do
if STOP or HALT.Value == true then break end
local newCFrame = CFrame.new(startPosition.Position + teleportDistance * step)
humanoid.RootPart.CFrame = newCFrame
wait(0.1) -- Adjust the delay as needed to control the teleport speed
end
if STOP or HALT.Value == true then return end
humanoid.RootPart.CFrame = destinationCFrame
end
end
end
-- PLAYERS
local PlayersTab = Window:NewTab("Players")
local PlayersSec = PlayersTab:NewSection("Players")
local players = {}
function getPlayers()
for _,e in pairs(game.Players:GetPlayers()) do
if e.UserId ~= game.Players.LocalPlayer.UserId then
table.insert(players,e.Name .. " ("..e.UserId..")")
end
end
end
getPlayers()
local selectedPlayer;
PlayersSec:NewDropdown("Player", "Select a player", players, function(playerSelected)
local numbers = playerSelected:match("%((%d+)%)")
for _,e in pairs(game.Players:GetPlayers()) do
if e.UserId == tonumber(numbers) then
selectedPlayer = e
print("Selected " .. e.Name)
break
end
end
end)
PlayersSec:NewButton("Teleport to player","Teleport to selected Player",function()
if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
teleportPlayerStepByStep(selectedPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame)
end
end)
PlayersSec:NewButton("Refresh Players","Refresh players",function()
getPlayers()
end)

--TELEPORTS
local Teleport = Window:NewTab("Teleport")
local TeleportSection = Teleport:NewSection("Teleport")



TeleportSection:NewButton("STOP", "Stop any current teleport, Wait is 2 seconds", function()
STOP=true
task.wait(2)
STOP=false
end)
local savedLocation;
TeleportSection:NewButton("Save Location","Save your location",function()
local HRP = game.Players.LocalPlayer.Character.HumanoidRootPart
savedLocation = HRP.CFrame
end)
TeleportSection:NewButton("TP To Location","Save your location",function()
if not savedLocation then return end
teleportPlayerStepByStep(savedLocation)

end)
TeleportSection:NewButton("Criminal hideout", "TP to crim hideout", function()
teleportPlayerStepByStep(CFrame.new(341.17334, -5.7791729, 381.205872, 0.559050798, -5.52637136e-09, 0.829133391, 4.28072191e-08, 1, -2.21979217e-08, -0.829133391, 4.79026596e-08, 0.559050798))
end)

TeleportSection:NewButton("Gate", "TP to the Gate", function()
teleportPlayerStepByStep(CFrame.new(-15.9535885, -10.7593746, -0.0283825397, 0.356183916, -1.3971138e-08, 0.934415877, 4.63970595e-09, 1, 1.31831559e-08, -0.934415877, -3.60213109e-10, 0.356183916))
end)
TeleportSection:NewButton("Gate Control", "TP to where the gate control is", function()
teleportPlayerStepByStep(CFrame.new(-14.8470736, -8.69899178, -14.0607195, -0.965656698, 2.38713938e-08, -0.259821326, 2.09883595e-08, 1, 1.38704692e-08, 0.259821326, 7.94088795e-09, -0.965656698))
end)
TeleportSection:NewButton("President Room", "TP to presidents room?", function()
teleportPlayerStepByStep(CFrame.new(389.263611, 4.20316458, -242.933243, 0.544697046, 7.95441437e-08, 0.838632882, -4.84137814e-08, 1, -6.3404741e-08, -0.838632882, -6.0650116e-09, 0.544697046))
end)
TeleportSection:NewButton("Sheriff Garage", "TP to Sherriffs Garage", function()
teleportPlayerStepByStep(CFrame.new(374.988922, -8.75761032, -256.439728, 0.765715241, -1.03275724e-07, -0.643179715, 1.14218388e-07, 1, -2.45918184e-08, 0.643179715, -5.46326184e-08, 0.765715241))
end)
TeleportSection:NewButton("Sheriff Place", "TP to Sheriffs Area", function()
teleportPlayerStepByStep(CFrame.new(362.331085, -8.75761223, -219.503693, -0.807128191, 9.18550569e-08, -0.590376258, 4.73738702e-08, 1, 9.08205138e-08, 0.590376258, 4.53353834e-08, -0.807128191))
end)
TeleportSection:NewButton("Koda Legal Solutions", "TP to The Legal Solutions", function()
teleportPlayerStepByStep(CFrame.new(-91.7167511, 8.7149477, -167.69165, -0.171286196, 9.67611324e-09, 0.985221326, 8.90652174e-08, 1, 5.66322278e-09, -0.985221326, 8.87189771e-08, -0.171286196))
end)
TeleportSection:NewButton("Directors Office", "TP to baked beans", function()
teleportPlayerStepByStep(CFrame.new(-123.84375, 8.67986488, -122.701012, -0.375622541, 2.68134515e-09, -0.926772714, -1.37010163e-08, 1, 8.4462517e-09, 0.926772714, 1.58703308e-08, -0.375622541))
end)
TeleportSection:NewButton("Control Room", "TP to the one and only control room", function()
teleportPlayerStepByStep(CFrame.new(-110.89122, 8.67986679, -86.1371384, 0.654154301, 6.38086846e-08, -0.756361127, -1.10613925e-07, 1, -1.13039818e-08, 0.756361127, 9.10586238e-08, 0.654154301))
end)
TeleportSection:NewButton("Yard", "TP to the middle of the yard. Not a good idea", function()
teleportPlayerStepByStep(CFrame.new(-82.3775406, -6.00000095, -346.62616, 0.974656403, -2.08453148e-08, -0.223707229, 1.94662544e-08, 1, -8.36989678e-09, 0.223707229, 3.80303167e-09, 0.974656403))
end)
TeleportSection:NewButton("Block B Yard", "TP to the middle of Max Security Yard. Again NOT a good idea", function()
teleportPlayerStepByStep(CFrame.new(36.052887, -6.00000143, -414.152252, -0.915377736, 1.54652451e-08, -0.402596027, 1.43581103e-08, 1, 5.76793946e-09, 0.402596027, -5.00674835e-10, -0.915377736))
end)
TeleportSection:NewButton("Laundry", "TP to Laundry Room, Get cleaning", function()
teleportPlayerStepByStep(CFrame.new(-210.107285, -5.46436977, -413.091003, -0.339778543, 2.69318168e-08, 0.940505445, 1.41561687e-08, 1, -2.35212401e-08, -0.940505445, 5.32194155e-09, -0.339778543))
end)
TeleportSection:NewButton("Block A", "TP to Min/Med Security", function()
teleportPlayerStepByStep(CFrame.new(-164.282822, -5.4643693, -482.272339, -0.660143137, 4.82954761e-08, -0.75113982, 2.06907202e-08, 1, 4.61121026e-08, 0.75113982, 1.48989656e-08, -0.660143137))
end)
TeleportSection:NewButton("Block B", "TP to Max Security", function()
teleportPlayerStepByStep(CFrame.new(124.326759, -5.50000095, -446.439575, 0.887063265, 3.99935303e-08, -0.461647928, -4.28968399e-08, 1, 4.20520285e-09, 0.461647928, 1.60729545e-08, 0.887063265))
end)
TeleportSection:NewButton("Block B Keycard Area", "TP to Block B's keycard area", function()
teleportPlayerStepByStep(CFrame.new(99.6348114, -5.5, -433.690735, 0.875333786, 4.1652104e-08, 0.483519167, -4.42473258e-09, 1, -7.81333824e-08, -0.483519167, 6.62533495e-08, 0.875333786))
end)
TeleportSection:NewButton("Behind Block B", "TP to a good rope area", function()
teleportPlayerStepByStep(CFrame.new(216.141769, -6.00000191, -451.569427, 0.480042011, -4.66853756e-09, -0.877245486, 3.51715528e-08, 1, 1.39245913e-08, 0.877245486, -3.75384737e-08, 0.480042011))
end)
TeleportSection:NewButton("Secure Cell Vent 2", "TP to the vent in Secure Cell area", function()
teleportPlayerStepByStep(CFrame.new(-56.7584076, -19.2000046, -191.581223, -0.965440989, 1.2147618e-08, -0.260621667, 1.28610305e-08, 1, -1.03194886e-09, 0.260621667, -4.34814895e-09, -0.965440989))
end)
TeleportSection:NewButton("Secure Cells", "TP to the Secure Cell area", function()
teleportPlayerStepByStep(CFrame.new(-86.720192, -19.2000046, -192.20636, 0.277789265, -9.68098206e-08, 0.96064204, -1.15010339e-08, 1, 1.04101929e-07, -0.96064204, -3.99667748e-08, 0.277789265))
end)
TeleportSection:NewButton("Booking Computer", "TP to where the booking computer area is", function()
teleportPlayerStepByStep(CFrame.new(-133.594162, -5.49444246, -167.253632, -0.231695548, 1.3185832e-08, 0.972788334, -3.04412551e-10, 1, -1.36271812e-08, -0.972788334, -3.45348616e-09, -0.231695548))
end)

local Items = Window:NewTab("Items")
local ItemsSection = Items:NewSection("Items")

local args = {
["Special"] = "None",
["Primary"] = "Kar98k",
["Melee"] = "Knife",
["Secondary"] = "Makarov"
}



--ItemsSection:NewLabel("Warning: For the Armoury to work you must FIRST go to it and open it")
local function fireproximityprompt(Obj, Amount, Skip)
if Obj.ClassName == "ProximityPrompt" then
Amount = Amount or 1
local PromptTime = Obj.HoldDuration
if Skip then
Obj.HoldDuration = 0
end
for i = 1, Amount do
Obj:InputHoldBegin()
if not Skip then
wait(Obj.HoldDuration)
end
Obj:InputHoldEnd()
end
Obj.HoldDuration = PromptTime
else
error("userdata<ProximityPrompt> expected")
end
end

local OldSpot;
local TPOld = false
ItemsSection:NewToggle("Teleport To Original Spot","Once finish with any action it will teleport you back",function()
TPOld = not TPOld
end)
local function getChildrenWithinDistance(parent, position, maxDistance)
local childrenWithinDistance = {}

for _, model in pairs(parent:GetChildren()) do
if model:IsA("Model") then
if not model:FindFirstChild("Handle") then return end
local child = model.Handle
if child.Transparency == 0 then
local distance = (position - child.Position).Magnitude
if distance <= maxDistance then
   table.insert(childrenWithinDistance, model)
end
end
end
end

return childrenWithinDistance
end

ItemsSection:NewButton("Get all clothing items near you","Gets all clothing items near you",function()
local clothes = workspace.Skeleton.Objects.Clothing
local HRP = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
local MaxDistance = 60
local allClothingItemsNear = getChildrenWithinDistance(clothes, HRP.Position, MaxDistance)
local names = {
["Shirt"] = 0,
["Pants"] = 0,
["Total"] = 0,
}
for _,model in pairs(allClothingItemsNear) do
if names[model.Name] then
names[model.Name] = names[model.Name] + 1
names["Total"] = names["Total"] + 1
end
end
game.StarterGui:SetCore("SendNotification", {
Title = "Found "..names["Total"].. " Clothing Items";
Text = names["Shirt"].." shirts and "..names["Pants"].." Pants";
Duration = 5;
})
for _, model in pairs(allClothingItemsNear) do
local child = model.Handle
teleportPlayerStepByStep(child.CFrame)
if child:FindFirstChild("Attachment") and child:FindFirstChild("Attachment"):FindFirstChild("ProximityPrompt") then
fireproximityprompt(child:FindFirstChild("Attachment"):FindFirstChild("ProximityPrompt"),1,true)
end
end
end)
local function findClosestPart(userPosition, partList)
local closestPart = nil
local closestDistance = math.huge

for _, part in ipairs(partList) do
local distance = (userPosition - part.Position).Magnitude
if distance < closestDistance then
closestDistance = distance
closestPart = part
end
end

return closestPart
end
ItemsSection:NewButton("Get Officer Keycard","Get any available officer keycard",function()
local kardLocations = workspace.Skeleton.Interactions.Prox
local kards={}

for _,e in pairs(kardLocations:GetChildren()) do
if e.Name == "Officer Keycard" then
if e:FindFirstChild("ProximityPrompt") and e:FindFirstChild("ProximityPrompt").Enabled == true and e.Transparency == 0 then
-- valid keycard
table.insert(kards,e)
end
end
end
local selectedKard = findClosestPart(game.Players.LocalPlayer.Character.HumanoidRootPart.Position,kards)
if selectedKard then
OldSpot = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
selectedKard:FindFirstChild("ProximityPrompt").HoldDuration = 0
teleportPlayerStepByStep(selectedKard.CFrame)
fireproximityprompt(selectedKard:FindFirstChild("ProximityPrompt"),1,true)
task.wait(3)
teleportPlayerStepByStep(OldSpot)
end
end)
ItemsSection:NewDropdown("Primary", "Set your primary weapon", {"Kar98k", "M4A1", "G36C", "R870"}, function(gunoption)
args["Primary"] = gunoption
end)
ItemsSection:NewDropdown("Secondary", "Set your secondary weapon", {"Makarov", "M4A1", "G36C", "R870"}, function(gunoption)
args["Secondary"] = gunoption
end)


ItemsSection:NewButton("Give Primary & Secondary", "Uses armory event to give you selected or default weapons", function()
OldSpot = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
if game:GetService("Players").LocalPlayer.PlayerGui.RoundScreen.Armoury:FindFirstChild("Escapee") and game:GetService("Players").LocalPlayer.PlayerGui.RoundScreen.Armoury:FindFirstChild("Escapee"):FindFirstChild("ArmouryEvent") then
print("TPing")
teleportPlayerStepByStep(game.Workspace.Skeleton.Interactions.Other["Armoury/Escapee1"].CFrame)
game:GetService("Players").LocalPlayer.PlayerGui.RoundScreen.Armoury.Escapee.ArmouryEvent:FireServer(args)


task.wait(1)
teleportPlayerStepByStep(OldSpot)
else
teleportPlayerStepByStep(game.Workspace.Skeleton.Interactions.Other["Armoury/Escapee1"].CFrame);
fireproximityprompt(workspace.Skeleton.Interactions.Other["Armoury/Escapee1"].ProximityPrompt,1,true)
if game:GetService("Players").LocalPlayer.PlayerGui.RoundScreen.Armoury:FindFirstChild("Escapee"):FindFirstChild("ArmouryEvent") then
game:GetService("Players").LocalPlayer.PlayerGui.RoundScreen.Armoury:FindFirstChild("Escapee").Visible = false
game:GetService("Players").LocalPlayer.PlayerGui.RoundScreen.Armoury.Escapee.ArmouryEvent:FireServer(args)
else
warn("Failed")
end
task.wait(1)
teleportPlayerStepByStep(OldSpot)
end

end)

local GETRIFLESTEPS = {
[1]=CFrame.new(-193.414047, -5.49444151, -158.667252, 0.0367138498, -5.06409528e-08, -0.999325812, 2.5324244e-08, 1, -4.97447381e-08, 0.999325812, -2.3480851e-08, 0.0367138498),
[2]=CFrame.new(-213.040222, -5.49444199, -158.925461, 0.0608763322, 1.20248345e-08, 0.998145342, 6.10765412e-08, 1, -1.57722031e-08, -0.998145342, 6.19234157e-08, 0.0608763322),
[3]=CFrame.new(-227.516891, -5.49444103, -159.103271, -0.191368416, 1.58313895e-08, 0.981518269, 2.02532036e-08, 1, -1.21806867e-08, -0.981518269, 1.7547892e-08, -0.191368416),
[4]=CFrame.new(-234.01532, -5.49444199, -149.496185, -0.953503788, 3.70918585e-08, -0.301380962, 2.39508804e-08, 1, 4.72976183e-08, 0.301380962, 3.78801204e-08, -0.953503788),
[5]=CFrame.new(-230.268829, -5.44444323, -138.889328, -0.969445169, -4.88224643e-08, -0.245308027, -5.73556562e-08, 1, 2.7641569e-08, 0.245308027, 4.08667908e-08, -0.969445169),
[6]=CFrame.new(-230.555161, -2.85601735, -136.648254, -0.939972878, -0.00230333046, 0.34124136, -0.00444524409, 0.999975026, -0.00549504347, -0.34122017, -0.00668209279, -0.939959645),
[7]=CFrame.new(-230.580719, -2.80258608, -129.920029, 0.46720165, 0.00500009162, 0.884136617, -0.00509655196, 0.999982655, -0.00296208425, -0.884136081, -0.00312215765, 0.467219025),
[8]=CFrame.new(-231.672852, -5.49444199, -118.792709, -0.335791379, -1.92719551e-09, 0.941936374, 9.30007857e-08, 1, 3.51998892e-08, -0.941936374, 9.94206459e-08, -0.335791379),
}
local GETPISTOLSTEPS = {
[1]=CFrame.new(-193.414047, -5.49444151, -158.667252, 0.0367138498, -5.06409528e-08, -0.999325812, 2.5324244e-08, 1, -4.97447381e-08, 0.999325812, -2.3480851e-08, 0.0367138498),
[2]=CFrame.new(-213.040222, -5.49444199, -158.925461, 0.0608763322, 1.20248345e-08, 0.998145342, 6.10765412e-08, 1, -1.57722031e-08, -0.998145342, 6.19234157e-08, 0.0608763322),
[3]=CFrame.new(-227.516891, -5.49444103, -159.103271, -0.191368416, 1.58313895e-08, 0.981518269, 2.02532036e-08, 1, -1.21806867e-08, -0.981518269, 1.7547892e-08, -0.191368416),
[4]=CFrame.new(-234.01532, -5.49444199, -149.496185, -0.953503788, 3.70918585e-08, -0.301380962, 2.39508804e-08, 1, 4.72976183e-08, 0.301380962, 3.78801204e-08, -0.953503788),
[5]=CFrame.new(-230.268829, -5.44444323, -138.889328, -0.969445169, -4.88224643e-08, -0.245308027, -5.73556562e-08, 1, 2.7641569e-08, 0.245308027, 4.08667908e-08, -0.969445169),
[6]=CFrame.new(-230.555161, -2.85601735, -136.648254, -0.939972878, -0.00230333046, 0.34124136, -0.00444524409, 0.999975026, -0.00549504347, -0.34122017, -0.00668209279, -0.939959645),
[7]=CFrame.new(-230.580719, -2.80258608, -129.920029, 0.46720165, 0.00500009162, 0.884136617, -0.00509655196, 0.999982655, -0.00296208425, -0.884136081, -0.00312215765, 0.467219025),
[8]=CFrame.new(-231.147629, -5.49444103, -124.258537, -0.84521085, -2.89320354e-08, 0.534433007, -1.63233942e-08, 1, 2.83203434e-08, -0.534433007, 1.52128994e-08, -0.84521085)
}


ItemsSection:NewButton("Get Rifle","Get the rifle from Guard Armory",function()
local HRP = game.Players.LocalPlayer.Character.HumanoidRootPart
OldSpot = HRP.CFrame
local HRP = game.Players.LocalPlayer.Character.HumanoidRootPart

for i=1,#GETRIFLESTEPS do
teleportPlayerStepByStep(GETRIFLESTEPS[i])
task.wait(.5)
end
fireproximityprompt(workspace.Skeleton.Interactions.Prox["Armoury/InmatesRifles"].ProximityPrompt,1,true)
task.wait(1)
if TPOld then
teleportPlayerStepByStep(OldSpot)
end
end)
ItemsSection:NewButton("Get Pistols","Get the pistols from Guard Armory",function()
local HRP = game.Players.LocalPlayer.Character.HumanoidRootPart
OldSpot = HRP.CFrame
for i=1,#GETPISTOLSTEPS do
teleportPlayerStepByStep(GETPISTOLSTEPS[i])
task.wait(.5)
end
fireproximityprompt(workspace.Skeleton.Interactions.Prox["Armoury/Inmates"].ProximityPrompt,1,true)
task.wait(1)
if TPOld then
teleportPlayerStepByStep(OldSpot)
end
end)



--Settings
local Settings = Window:NewTab("Settings")
local SettingsSection = Settings:NewSection("Settings")

SettingsSection:NewKeybind("Toggle UI", "Toggles ui", Enum.KeyCode.F, function()
Library:ToggleUI()
end)


