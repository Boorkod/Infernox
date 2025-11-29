local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")
local LocalScript = PlayerScripts:FindFirstChildOfClass("LocalScript")
local Char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local rootP = Char:WaitForChild("HumanoidRootPart")
local Data = LocalPlayer:WaitForChild("Data")
local Enemies = Workspace:WaitForChild("Enemies")
local Net = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
local RegisterAttack = Net:WaitForChild("RE/RegisterAttack")
local RegisterHit = Net:WaitForChild("RE/RegisterHit")
-- รอ LocalScript โหลด
while not LocalScript do
	LocalPlayer.PlayerScripts.ChildAdded:Wait()
	LocalScript = PlayerScripts:FindFirstChildOfClass("LocalScript")
end

-- ดึงฟังก์ชัน Hit
local HIT_FUNCTION
if getsenv then
	pcall(function()
		local ok, env = pcall(getsenv, LocalScript)
		if ok and env then
			HIT_FUNCTION = env._G.SendHitsToServer
		end
	end)
end

-- Fast Attack Loop
task.spawn(function()
	while task.wait() do
		if _G.Fast_Attack then
			pcall(function()
				if Char:FindFirstChildOfClass("Tool")
					and Char:FindFirstChild("Humanoid")
					and Char.Humanoid.Health > 0
				then
					for _, v in pairs(Enemies:GetChildren()) do
						if v:FindFirstChild("Humanoid")
							and v.Humanoid.Health > 0
							and v:FindFirstChild("HumanoidRootPart")
						then
							if (v.HumanoidRootPart.Position - rootP.Position).Magnitude <= 60 then

								if Char:FindFirstChild("Stun") then Char.Stun.Value = 0 end
								if Char:FindFirstChild("Busy") then Char.Busy.Value = false end
								if v:FindFirstChild("Stun") then v.Stun.Value = 0 end
								if v:FindFirstChild("Busy") then v.Busy.Value = false end

								local Targets = {}
								for _, y in pairs(Enemies:GetChildren()) do
									if y:FindFirstChild("Humanoid")
										and y.Humanoid.Health > 0
										and y:FindFirstChild("HumanoidRootPart")
										and (y.HumanoidRootPart.Position - rootP.Position).Magnitude <= 60
									then
										table.insert(Targets, {y, y.HumanoidRootPart})
									end
								end

								if #Targets > 0 then
									RegisterAttack:FireServer(math.random(0,0.5))

									if HIT_FUNCTION then
										HIT_FUNCTION(v.HumanoidRootPart, Targets)
									else
										RegisterHit:FireServer(v.HumanoidRootPart, Targets)
									end
								end
							end
						end
					end
				end
			end)
		end
	end
end)