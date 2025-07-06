--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")


local screenGui = Instance.new("ScreenGui", PlayerGui)
screenGui.Name = "ImpossibleSlapTower"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true


local btnShow = Instance.new("TextButton")
btnShow.Size = UDim2.new(0, 100, 0, 30)
btnShow.Position = UDim2.new(1, -110, 0, 10)
btnShow.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
btnShow.TextColor3 = Color3.new(1, 1, 1)
btnShow.TextScaled = true
btnShow.Font = Enum.Font.SourceSansBold
btnShow.Text = "Show GUI"
btnShow.Visible = false
btnShow.Parent = screenGui


local bgFrame = Instance.new("Frame")
bgFrame.Size = UDim2.new(0, 220, 0, 200)
bgFrame.Position = UDim2.new(1, -230, 0, 10) -- pojok kanan atas
bgFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
bgFrame.BackgroundTransparency = 0.3
bgFrame.Active = true
bgFrame.Draggable = true
bgFrame.Parent = screenGui


local function createButton(name, orderY)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 35)
	btn.Position = UDim2.new(0, 10, 0, 10 + orderY * 40)
	btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.TextScaled = true
	btn.Font = Enum.Font.SourceSansBold
	btn.Text = name .. ": OFF"
	btn.Name = name
	btn.Parent = bgFrame
	return btn
end


local btnAutoWin = createButton("AutoWin", 0)
local btnCrownSteal = createButton("CrownSteal", 1)
local btnGetDucks = createButton("GetDucks", 2)


local btnHide = createButton("Hide GUI", 3)
btnHide.Text = "Hide GUI"
btnHide.BackgroundColor3 = Color3.fromRGB(100, 100, 100)


local creditLabel = Instance.new("TextLabel")
creditLabel.Size = UDim2.new(1, -20, 0, 20)
creditLabel.Position = UDim2.new(0, 10, 1, -25)
creditLabel.BackgroundTransparency = 1
creditLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
creditLabel.TextScaled = true
creditLabel.Font = Enum.Font.SourceSansItalic
creditLabel.Text = "Made By 3T3RN4L999"
creditLabel.TextTransparency = 0.2
creditLabel.Parent = bgFrame


btnHide.MouseButton1Click:Connect(function()
	bgFrame.Visible = false
	btnShow.Visible = true
end)

btnShow.MouseButton1Click:Connect(function()
	bgFrame.Visible = true
	btnShow.Visible = false
end)


local toggleWin = false
local toggleCrown = false
local toggleDucks = false

local currentHRP = nil
local function updateHRP()
	local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	currentHRP = character:WaitForChild("HumanoidRootPart")
end
updateHRP()
LocalPlayer.CharacterAdded:Connect(updateHRP)

btnAutoWin.MouseButton1Click:Connect(function()
	toggleWin = not toggleWin
	btnAutoWin.Text = "AutoWin: " .. (toggleWin and "ON" or "OFF")
	btnAutoWin.BackgroundColor3 = toggleWin and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
end)

btnCrownSteal.MouseButton1Click:Connect(function()
	toggleCrown = not toggleCrown
	btnCrownSteal.Text = "CrownSteal: " .. (toggleCrown and "ON" or "OFF")
	btnCrownSteal.BackgroundColor3 = toggleCrown and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
end)

btnGetDucks.MouseButton1Click:Connect(function()
	toggleDucks = not toggleDucks
	btnGetDucks.Text = "GetDucks: " .. (toggleDucks and "ON" or "OFF")
	btnGetDucks.BackgroundColor3 = toggleDucks and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)

	if toggleDucks then
		task.spawn(function()
			local function getTargets()
				local targets = {}
				for _, obj in pairs(workspace:GetDescendants()) do
					if (obj:IsA("MeshPart") or (obj:IsA("Part") and obj.Name == "Evil")) and obj:FindFirstChildOfClass("ProximityPrompt") then
						table.insert(targets, obj)
					end
				end
				return targets
			end

			for _, part in ipairs(getTargets()) do
				if not toggleDucks then break end
				if currentHRP then
					currentHRP.CFrame = part.CFrame + Vector3.new(0, 2, 0)
					task.wait(0.25)
					local prompt = part:FindFirstChildOfClass("ProximityPrompt")
					if prompt then
						fireproximityprompt(prompt)
					end
					task.wait(1)
				end
			end

			toggleDucks = false
			btnGetDucks.Text = "GetDucks: OFF"
			btnGetDucks.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
		end)
	end
end)

RunService.RenderStepped:Connect(function()
	if currentHRP then
		if toggleWin then
			local tower = workspace:FindFirstChild("Tower")
			local winPart = tower and tower:FindFirstChild("Black") and tower.Black:FindFirstChild("WinPart")
			if winPart then
				currentHRP.CFrame = winPart.CFrame + Vector3.new(0, 3, 0)
			end
		end

		if toggleCrown then
			for _, player in pairs(Players:GetPlayers()) do
				if player ~= LocalPlayer and player.Character then
					local head = player.Character:FindFirstChild("Head")
					local targetHRP = player.Character:FindFirstChild("HumanoidRootPart")
					if head and head:FindFirstChild("CrownTag") and targetHRP then
						local behind = targetHRP.Position - (targetHRP.CFrame.LookVector * 3)
						currentHRP.CFrame = CFrame.new(behind, targetHRP.Position)
						break
					end
				end
			end
		end
	end
end)
