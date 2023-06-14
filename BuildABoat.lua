--I had a broken finger when writing this
local UiLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/H17S32/UiLib/main/Reptorv1'))()

local plr = game:GetService("Players").LocalPlayer
local FindPlayer = function(h,h2)
	h = h:gsub("%s+", "")
	for m, n in pairs(game:GetService("Players"):GetPlayers()) do
		if n.Name:lower():match("^" .. h:lower()) or n.DisplayName:lower():match("^" .. h:lower()) then
			return n
		end
	end
	return nil
end
local Farming = UiLib.CreatePop("Auto Farming")
local Movement = UiLib.CreatePop("Movement")
local Other = UiLib.CreatePop("Other")
local States = {
	Farming =false,
	SpeedFarm = 14,
	LoopClaim = false,
}
Farming.CreateToggle("Auto farm",function(a)
	States.Farming = a
end)
Farming.CreateToggle("Loop Claim",function(a)
	States.LoopClaim = a
end)
Farming.CreateSlider("Fly slowdown",function(a)
	States.SpeedFarm = tonumber(a)
end,5,30)
Movement.CreateSlider("Speed",function(a)
	plr.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = a
end,1,200)

Movement.CreateSlider("Jumppower",function(a)
	plr.Character:FindFirstChildOfClass("Humanoid").JumpPower = a
end,1,200)
Other.CreateSlider("FOV",function(a)
	workspace.CurrentCamera.FieldOfView = a
end,1,150)
Other.CreateSlider("Gravity",function(a)
	workspace.Gravity.FieldOfView = a
end,1,1000)
Farmm = true
function Tween(Obj,Prop,New,Time)
	if not Time then Time = .5 end
	local TweenService = game:GetService("TweenService")
	local info = TweenInfo.new( Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, 0, false,0)
	local propertyTable = {
		[Prop] = New,
	}
	TweenService:Create(Obj, info, propertyTable):Play()
end
function Farm()
	if States.Farming == false then return end
	game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart")
	local o = Instance.new("BoolValue",game:GetService("Players").LocalPlayer.Character)
	o.Name = "Farming"
	workspace.Gravity = 0
	Tween(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart,"CFrame",CFrame.new(55, 103, 1281),10)
	wait(5)
	Tween(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart,"CFrame",CFrame.new(-88, 73, 8678),States.SpeedFarm)
	wait(States.SpeedFarm)
	Tween(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart,"CFrame",CFrame.new(-56, -360, 9460),1)
	wait(1)
	Tween(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart,"CFrame",CFrame.new(-56, -360, 9489),.5)
	wait(2)
	workspace.Gravity = 198
end
coroutine.wrap(function()
	while wait(1) do
		if States.LoopClaim then
			game:GetService("Workspace").ClaimRiverResultsGold:FireServer()
		end
	end
end)
while (true) do
	repeat task.wait() until States.Farming == true
	Farm()
	wait()
	repeat task.wait() until not game:GetService("Players").LocalPlayer.Character or not game:GetService("Players").LocalPlayer.Character:FindFirstChild("Farming")
	game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(c)
		c:WaitForChild("HumanoidRootPart")
		wait(.5)
		local Event = game:GetService("Workspace").ClaimRiverResultsGold
		Event:FireServer()
		Farm()
	end)
end
