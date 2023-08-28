--Naval warfare
local UiLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/H17S32/UiLib/main/Reptorv1'))()
local UserInputService = game:GetService("UserInputService")
local Player = game:GetService("Players").LocalPlayer

local GameFrame = UiLib.CreatePop("Game")
local LocalPlayerFrame = UiLib.CreatePop("LocalPlayer")
local TeleportsFrame = UiLib.CreatePop("Teleports")
local GunModsFrame = UiLib.CreatePop("GunMods")

local States = {
	InfAmmo = false,
	RapidFire = false,
	Sprint = false,
	SpamVoteKickRadom = true,
	Godmode = false,
	KillEn = false,
	HoldingMouse = false,
}
local Teleports = {
	['USA Harbor'] = CFrame.new(134, 23, 8113),
	['Japan Harbor'] = CFrame.new(-112, 23, -8105)
}
function MoveTo(Cframe)
	if Cframe then
		for i =1,5 do
			pcall(function()
				Player.Character:FindFirstChildOfClass("Humanoid").Sit = false
				Player.Character:FindFirstChild("HumanoidRootPart").CFrame = Cframe
			end)
		end
	end
end
for i,v in pairs(Teleports) do
	if v then
		TeleportsFrame.CreateButton(tostring(i),function()
			MoveTo(v)
		end)
	end
end
--
local Table = {}
local Island = nil
task.spawn(function()
	while wait() do
		for i,v in pairs(workspace:GetChildren()) do
			if v and v:IsA("Model") and v.Name == "Island" and v:FindFirstChild("IslandCode") then
				Island = v
				local Code = v:FindFirstChild("IslandCode").Value
				local l = TeleportsFrame.CreateButton("Island "..tostring(Code),function()
					MoveTo(CFrame.new(v.MainBody.Position)*CFrame.new(0,5,0))
				end)
				Table[#Table+1] = l
			end
		end
		repeat task.wait() until not Island
		for i,v in pairs(Table) do
			v:Destroy()
			Table[i] = nil
		end
	end
end)
LocalPlayerFrame.CreateSlider("Speed",function(a)
	Player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = a
end,1,200)
LocalPlayerFrame.CreateSlider("HipHeight",function(a)
	Player.Character:FindFirstChildOfClass("Humanoid").HipHeight = a
end,1,150)
GameFrame.CreateSlider("Gravity",function(a)
	workspace.Gravity = a
end,1,500)
LocalPlayerFrame.CreateSlider("JumpPower",function(a)
	Player.Character:FindFirstChildOfClass("Humanoid").JumpPower = a
end,1,500)
LocalPlayerFrame.CreateToggle("Godmode",function(a)
	States.Godmode = a
	wait()
end)
GameFrame.CreateToggle("Kill enemies",function(a)
	States.KillEn = a
	wait()
end)
LocalPlayerFrame.CreateToggle("Add sprint [Left shift]",function(a)
	States.Sprint = a
	wait()
	if States.Sprint == false then
		Player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
	end
end)
UserInputService.InputBegan:Connect(function(input,_gameProcessed)
	if input.KeyCode == Enum.KeyCode.LeftShift and States.Sprint then
		Player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 41
	end
	if input.UserInputType == Enum.UserInputType.MouseButton1 and not _gameProcessed then
		States.HoldingMouse = true
	end
end)
UserInputService.InputEnded:Connect(function(input,_gameProcessed)
	if input.KeyCode == Enum.KeyCode.LeftShift and States.Sprint then
		Player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
	end
	if input.UserInputType == Enum.UserInputType.MouseButton1 and not _gameProcessed then
		States.HoldingMouse = false
	end
end)
GunModsFrame.CreateToggle("RapidFire",function(a)
	States.RapidFire = a
end)
GunModsFrame.CreateToggle("Inf Ammo",function(a)
	States.InfAmmo = a
end)
GameFrame.CreateToggle("Spam Votekick",function(a)
	States.SpamVoteKickRadom = a
end)
coroutine.wrap(function()
	while wait(.6) do
		if States.SpamVoteKickRadom then
			local RandomP = game:GetService("Players"):GetPlayers()[math.random(1,#game:GetService("Players"):GetPlayers())]
			if RandomP == Player then
				RandomP = game:GetService("Players"):GetPlayers()[math.random(1,#game:GetService("Players"):GetPlayers())]
			end
			if RandomP~=Player then
				coroutine.wrap(function()
					game:GetService("ReplicatedStorage").Event:FireServer("KickExploiter", {
						[1] = RandomP
					})
				end)()
			end
		end
	end
end)()
function Respawn()
	local Connection
	local oldPos = Player.Character:FindFirstChild("HumanoidRootPart").CFrame
	local args = {
		[1] = "Teleport",
		[2] = {
			[1] = "Harbour",
			[2] = ""
		}
	}
	task.spawn(function()
		game:GetService("ReplicatedStorage"):WaitForChild("Event"):FireServer(unpack(args))
		for i =1,30 do
			game:GetService("RunService").RenderStepped:Wait()
			Player.Character:FindFirstChild("HumanoidRootPart").CFrame = oldPos
		end
	end)

end
task.spawn(function()
	while wait() do
		if States.Godmode then
			Respawn()
			wait(.7)
			repeat task.wait() until not Player.Character:FindFirstChildOfClass("ForceField")
		end
	end
end)
task.spawn(function()
	while wait(1) do
		if States.KillEn then
			for i,v in pairs(game.workspace:GetDescendants()) do 
				if v.Name == "Humanoid" then
					if v.Parent.Name.Team ~= game.Players.LocalPlayer.Team then
						game:GetService("ReplicatedStorage").Event:FireServer("shootRifle", "", {[1]=v.Parent.HumanoidRootPart})
						game:GetService("ReplicatedStorage").Event:FireServer("shootRifle", "hit", {[1]=v})
					end
				end
			end
		end
		if Player and Player.Character:FindFirstChildOfClass("Humanoid") and States.InfAmmo then
			local gc,closure,infode,setupvalue = getgc or false, is_sirhurt_closure or checkclosure or false,debug.getinfo or getinfo or false, debug.setupvalue or setupvalue or setupval or false
			if not infode and not setupvalue and not gc and not closure then
			else
				local FindFunction = function(name)
					for i,v in pairs(gc()) do
						if type(v) == "function" and not closure(v) then
							if infode(v).name == name then
								return v
							end
						end
					end
				end
				setupvalue(FindFunction("reload"), 4, 999999999999999999999999999999999999999999999999)
			end
		end
	end
end)
task.spawn(function()
	while wait() do
		if States.RapidFire and States.HoldingMouse and game:GetService("Players").LocalPlayer.Character:FindFirstChild("M1 Garand") then
			game:GetService("Players").LocalPlayer.Character:FindFirstChild("M1 Garand"):Activate()
		end
	end
end)
