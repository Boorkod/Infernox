
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local old = game:GetService("CoreGui"):FindFirstChild("InfernoX_SeaMonitor")
if old then old:Destroy() end

local Gui = Instance.new("ScreenGui")
Gui.Name = "InfernoX_SeaMonitor"
Gui.ResetOnSpawn = false
Gui.Parent = game:GetService("CoreGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.fromOffset(240, 125)
Frame.Position = UDim2.new(1, -255, 0, 120)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 27)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Parent = Gui

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

local Stroke = Instance.new("UIStroke", Frame)
Stroke.Color = Color3.fromRGB(255, 65, 65)

local function Label(text, y, color)
    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, -16, 0, 19)
    L.Position = UDim2.fromOffset(8, y)
    L.BackgroundTransparency = 1
    L.Text = text
    L.TextColor3 = color or Color3.new(1, 1, 1)
    L.TextSize = 12
    L.Font = Enum.Font.GothamBold
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.Parent = Frame
    return L
end

Label("INFERNOX | SEA MONITOR", 5, Color3.fromRGB(255, 80, 80))
local Sea = Label("🌊 Sea Monster: WAITING", 30)
local Hydra = Label("🐉 Hydra: WAITING", 51)
local Ghost = Label("🚢 Ghost Ship: WAITING", 72)
local Updated = Label("Updated: --:--:--", 98, Color3.fromRGB(160, 160, 160))

local times = {}

local function IsSpawned(v)
    return v == "0" or v == "Spawned" or v == "UNLEASHED"
end

local function SetStatus(label, active)
    label.TextColor3 = active
        and Color3.fromRGB(50, 255, 100)
        or Color3.fromRGB(160, 160, 160)
end

task.spawn(function()
    while Gui.Parent do
        pcall(function()
            local sm = RS:GetAttribute("SeaMonsterSpawnText")
            local gs = RS:GetAttribute("GhostShipSpawnText")
            local hd = RS:GetAttribute("Hydra") == true

            local sea = IsSpawned(sm)
            local ghost = IsSpawned(gs)

            if sea and not times.Sea then times.Sea = os.time() end
            if ghost and not times.Ghost then times.Ghost = os.time() end
            if not sea then times.Sea = nil end
            if not ghost then times.Ghost = nil end

            Sea.Text = "🌊 Sea Monster: "..(sea and "SPAWNED" or "WAITING")
            Hydra.Text = "🐉 Hydra: "..(hd and "SPAWNED" or "WAITING")
            Ghost.Text = "🚢 Ghost Ship: "..(ghost and "SPAWNED" or "WAITING")

            SetStatus(Sea, sea)
            SetStatus(Hydra, hd)
            SetStatus(Ghost, ghost)

            Updated.Text = "Updated: "..os.date("%H:%M:%S")
        end)
        task.wait(1)
    end
end)

-- Drag GUI
local dragging, dragStart, startPos

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
