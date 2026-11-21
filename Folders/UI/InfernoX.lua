local Release = "Prerelease Beta 6.1"

local InfernoX = { 
	Folder = "InfernoX", 
	Options = {}, 
	ThemeGradient = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 72, 72)), ColorSequenceKeypoint.new(0.50, Color3.fromRGB(220, 45, 55)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(150, 24, 38))} 
}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Localization = game:GetService("LocalizationService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local CoreGui = game:GetService("CoreGui")

local isStudio
local website = "github.com/Boorkod/Infernox"

if RunService:IsStudio() then
	isStudio = true
end

-- Credits To Latte Softworks And qweery for Lucide And Material Icons Respectively.
local IconModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/Boorkod/Infernox/refs/heads/main/Folders/UI/IconModule.lua"))()

-- Other Variables
local request = (syn and syn.request) or (http and http.request) or http_request or nil
local tweeninfo = TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local PresetGradients = {
	["Inferno Red"] = {Color3.fromRGB(255, 72, 72), Color3.fromRGB(220, 45, 55), Color3.fromRGB(150, 24, 38)},
	["Nightlight (Classic)"] = {Color3.fromRGB(147, 255, 239), Color3.fromRGB(201,211,233), Color3.fromRGB(255, 167, 227)},
	["Nightlight (Neo)"] = {Color3.fromRGB(117, 164, 206), Color3.fromRGB(123, 201, 201), Color3.fromRGB(224, 138, 175)},
	Starlight = {Color3.fromRGB(147, 255, 239), Color3.fromRGB(181, 206, 241), Color3.fromRGB(214, 158, 243)},
	Solar = {Color3.fromRGB(242, 157, 76), Color3.fromRGB(240, 179, 81), Color3.fromRGB(238, 201, 86)},
	Sparkle = {Color3.fromRGB(199, 130, 242), Color3.fromRGB(221, 130, 238), Color3.fromRGB(243, 129, 233)},
	Lime = {Color3.fromRGB(170, 255, 127), Color3.fromRGB(163, 220, 138), Color3.fromRGB(155, 185, 149)},
	Vine = {Color3.fromRGB(0, 191, 143), Color3.fromRGB(0, 126, 94), Color3.fromRGB(0, 61, 46)},
	Cherry = {Color3.fromRGB(148, 54, 54), Color3.fromRGB(168, 67, 70), Color3.fromRGB(188, 80, 86)},
	Daylight = {Color3.fromRGB(51, 156, 255), Color3.fromRGB(89, 171, 237), Color3.fromRGB(127, 186, 218)},
	Blossom = {Color3.fromRGB(255, 165, 243), Color3.fromRGB(213, 129, 231), Color3.fromRGB(170, 92, 218)},
}

local function GetIcon(icon, source)
	if source == "Custom" then
		return "rbxassetid://" .. icon
	elseif source == "Lucide" then
		-- full credit to latte softworks :)
		local iconData = not isStudio and game:HttpGet("https://raw.githubusercontent.com/latte-soft/lucide-roblox/refs/heads/master/lib/Icons.luau")
		local icons = isStudio and IconModule.Lucide or loadstring(iconData)()
		if not isStudio then
			icon = string.match(string.lower(icon), "^%s*(.*)%s*$") :: string
			local sizedicons = icons['48px']

			local r = sizedicons[icon]
			if not r then
				error("Lucide Icons: Failed to find icon by the name of \"" .. icon .. "\.", 2)
			end

			local rirs = r[2]
			local riro = r[3]

			if type(r[1]) ~= "number" or type(rirs) ~= "table" or type(riro) ~= "table" then
				error("Lucide Icons: Internal error: Invalid auto-generated asset entry")
			end

			local irs = Vector2.new(rirs[1], rirs[2])
			local iro = Vector2.new(riro[1], riro[2])

			local asset = {
				id = r[1],
				imageRectSize = irs,
				imageRectOffset = iro,
			}

			return asset
		else
			return "rbxassetid://10723434557"
		end
	else	
		if icon ~= nil and IconModule[source] then
			local sourceicon = IconModule[source]
			return sourceicon[icon]
		else
			return nil
		end
	end
end

local function RemoveTable(tablre, value)
	for i,v in pairs(tablre) do
		if tostring(v) == tostring(value) then
			table.remove(tablre, i)
		end
	end
end

local function Kwargify(defaults, passed)
	for i, v in pairs(defaults) do
		if passed[i] == nil then
			passed[i] = v
		end
	end
	return passed
end

local function PackColor(Color)
	return {R = Color.R * 255, G = Color.G * 255, B = Color.B * 255}
end    

local function UnpackColor(Color)
	return Color3.fromRGB(Color.R, Color.G, Color.B)
end

function tween(object, goal, callback, tweenin)
	local tween = TweenService:Create(object,tweenin or tweeninfo, goal)
	tween.Completed:Connect(callback or function() end)
	tween:Play()
end

local function BlurModule(Frame)
	local RunService = game:GetService('RunService')
	local camera = workspace.CurrentCamera
	local MTREL = "Glass"
	local binds = {}
	local root = Instance.new('Folder', camera)
	root.Name = 'InfernoXBlur'

	local gTokenMH = 99999999
	local gToken = math.random(1, gTokenMH)

	local DepthOfField = Instance.new('DepthOfFieldEffect', game:GetService('Lighting'))
	DepthOfField.FarIntensity = 0
	DepthOfField.FocusDistance = 51.6
	DepthOfField.InFocusRadius = 50
	DepthOfField.NearIntensity = 6
	DepthOfField.Name = "DPT_"..gToken

	local frame = Instance.new('Frame')
	frame.Parent = Frame
	frame.Size = UDim2.new(0.95, 0, 0.95, 0)
	frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.BackgroundTransparency = 1

	local GenUid; do -- Generate unique names for RenderStepped bindings
		local id = 0
		function GenUid()
			id = id + 1
			return 'neon::'..tostring(id)
		end
	end

	do
		local function IsNotNaN(x)
			return x == x
		end
		local continue = IsNotNaN(camera:ScreenPointToRay(0,0).Origin.x)
		while not continue do
			RunService.RenderStepped:wait()
			continue = IsNotNaN(camera:ScreenPointToRay(0,0).Origin.x)
		end
	end

	local DrawQuad; do

		local acos, max, pi, sqrt = math.acos, math.max, math.pi, math.sqrt
		local sz = 0.22
		local function DrawTriangle(v1, v2, v3, p0, p1) -- I think Stravant wrote this function

			local s1 = (v1 - v2).magnitude
			local s2 = (v2 - v3).magnitude
			local s3 = (v3 - v1).magnitude
			local smax = max(s1, s2, s3)
			local A, B, C
			if s1 == smax then
				A, B, C = v1, v2, v3
			elseif s2 == smax then
				A, B, C = v2, v3, v1
			elseif s3 == smax then
				A, B, C = v3, v1, v2
			end

			local para = ( (B-A).x*(C-A).x + (B-A).y*(C-A).y + (B-A).z*(C-A).z ) / (A-B).magnitude
			local perp = sqrt((C-A).magnitude^2 - para*para)
			local dif_para = (A - B).magnitude - para

			local st = CFrame.new(B, A)
			local za = CFrame.Angles(pi/2,0,0)

			local cf0 = st

			local Top_Look = (cf0 * za).lookVector
			local Mid_Point = A + CFrame.new(A, B).lookVector * para
			local Needed_Look = CFrame.new(Mid_Point, C).lookVector
			local dot = Top_Look.x*Needed_Look.x + Top_Look.y*Needed_Look.y + Top_Look.z*Needed_Look.z

			local ac = CFrame.Angles(0, 0, acos(dot))

			cf0 = cf0 * ac
			if ((cf0 * za).lookVector - Needed_Look).magnitude > 0.01 then
				cf0 = cf0 * CFrame.Angles(0, 0, -2*acos(dot))
			end
			cf0 = cf0 * CFrame.new(0, perp/2, -(dif_para + para/2))

			local cf1 = st * ac * CFrame.Angles(0, pi, 0)
			if ((cf1 * za).lookVector - Needed_Look).magnitude > 0.01 then
				cf1 = cf1 * CFrame.Angles(0, 0, 2*acos(dot))
			end
			cf1 = cf1 * CFrame.new(0, perp/2, dif_para/2)

			if not p0 then
				p0 = Instance.new('Part')
				p0.FormFactor = 'Custom'
				p0.TopSurface = 0
				p0.BottomSurface = 0
				p0.Anchored = true
				p0.CanCollide = false
				p0.CastShadow = false
				p0.Material = MTREL
				p0.Size = Vector3.new(sz, sz, sz)
				local mesh = Instance.new('SpecialMesh', p0)
				mesh.MeshType = 2
				mesh.Name = 'WedgeMesh'
			end
			p0.WedgeMesh.Scale = Vector3.new(0, perp/sz, para/sz)
			p0.CFrame = cf0

			if not p1 then
				p1 = p0:clone()
			end
			p1.WedgeMesh.Scale = Vector3.new(0, perp/sz, dif_para/sz)
			p1.CFrame = cf1

			return p0, p1
		end

		function DrawQuad(v1, v2, v3, v4, parts)
			parts[1], parts[2] = DrawTriangle(v1, v2, v3, parts[1], parts[2])
			parts[3], parts[4] = DrawTriangle(v3, v2, v4, parts[3], parts[4])
		end
	end

	if binds[frame] then
		return binds[frame].parts
	end

	local uid = GenUid()
	local parts = {}
	local f = Instance.new('Folder', root)
	f.Name = frame.Name

	local parents = {}
	do
		local function add(child)
			if child:IsA'GuiObject' then
				parents[#parents + 1] = child
				add(child.Parent)
			end
		end
		add(frame)
	end

	local function UpdateOrientation(fetchProps)
		local properties = {
			Transparency = 0.98;
			BrickColor = BrickColor.new('Institutional white');
		}
		local zIndex = 1 - 0.05*frame.ZIndex

		local tl, br = frame.AbsolutePosition, frame.AbsolutePosition + frame.AbsoluteSize
		local tr, bl = Vector2.new(br.x, tl.y), Vector2.new(tl.x, br.y)
		do
			local rot = 0;
			for _, v in ipairs(parents) do
				rot = rot + v.Rotation
			end
			if rot ~= 0 and rot%180 ~= 0 then
				local mid = tl:lerp(br, 0.5)
				local s, c = math.sin(math.rad(rot)), math.cos(math.rad(rot))
				local vec = tl
				tl = Vector2.new(c*(tl.x - mid.x) - s*(tl.y - mid.y), s*(tl.x - mid.x) + c*(tl.y - mid.y)) + mid
				tr = Vector2.new(c*(tr.x - mid.x) - s*(tr.y - mid.y), s*(tr.x - mid.x) + c*(tr.y - mid.y)) + mid
				bl = Vector2.new(c*(bl.x - mid.x) - s*(bl.y - mid.y), s*(bl.x - mid.x) + c*(bl.y - mid.y)) + mid
				br = Vector2.new(c*(br.x - mid.x) - s*(br.y - mid.y), s*(br.x - mid.x) + c*(br.y - mid.y)) + mid
			end
		end
		DrawQuad(
			camera:ScreenPointToRay(tl.x, tl.y, zIndex).Origin, 
			camera:ScreenPointToRay(tr.x, tr.y, zIndex).Origin, 
			camera:ScreenPointToRay(bl.x, bl.y, zIndex).Origin, 
			camera:ScreenPointToRay(br.x, br.y, zIndex).Origin, 
			parts
		)
		if fetchProps then
			for _, pt in pairs(parts) do
				pt.Parent = f
			end
			for propName, propValue in pairs(properties) do
				for _, pt in pairs(parts) do
					pt[propName] = propValue
				end
			end
		end

	end

	UpdateOrientation(true)
	RunService:BindToRenderStep(uid, 2000, UpdateOrientation)
end

local function unpackt(array : table)

	local val = ""
	local i = 0
	for _,v in pairs(array) do
		if i < 3 then
			val = val .. v .. ", "
			i += 1
		else
			val = "Various"
			break
		end
	end

	return val
end

-- Interface Management
local InterfaceUI = isStudio and script.Parent:WaitForChild("Infernox UI") or game:GetObjects("rbxassetid://86467455075715")[1]

local SizeBleh = nil

local function Hide(Window, bind, notif)
	SizeBleh = Window.Size
	bind = string.split(tostring(bind), "Enum.KeyCode.")
	bind = bind[2]
	if notif then
		InfernoX:Notification({Title = "Interface Hidden", Content = "The interface has been hidden, you may reopen the interface by Pressing the UI Bind In Settings ("..tostring(bind)..")", Icon = "visibility_off"})
	end
	tween(Window, {BackgroundTransparency = 1})
	tween(Window.Elements, {BackgroundTransparency = 1})
	tween(Window.Line, {BackgroundTransparency = 1})
	tween(Window.Title.Title, {TextTransparency = 1})
	tween(Window.Title.subtitle, {TextTransparency = 1})
	tween(Window.Logo, {ImageTransparency = 1})
	tween(Window.Navigation.Line, {BackgroundTransparency = 1})

	for _, TopbarButton in ipairs(Window.Controls:GetChildren()) do
		if TopbarButton.ClassName == "Frame" then
			tween(TopbarButton, {BackgroundTransparency = 1})
			tween(TopbarButton.UIStroke, {Transparency = 1})
			tween(TopbarButton.ImageLabel, {ImageTransparency = 1})
			TopbarButton.Visible = false
		end
	end
	for _, tabbtn in ipairs(Window.Navigation.Tabs:GetChildren()) do
		if tabbtn.ClassName == "Frame" and tabbtn.Name ~= "InActive Template" then
			TweenService:Create(tabbtn, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
			TweenService:Create(tabbtn.ImageLabel, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
			TweenService:Create(tabbtn.DropShadowHolder.DropShadow, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
			TweenService:Create(tabbtn.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
		end
	end

	task.wait(0.28)
	Window.Size = UDim2.new(0,0,0,0)
	Window.Parent.ShadowHolder.Visible = false
	task.wait()
	Window.Elements.Parent.Visible = false
	Window.Visible = false
end


if gethui then
	InterfaceUI.Parent = gethui()
elseif syn and syn.protect_gui then 
	syn.protect_gui(InterfaceUI)
	InterfaceUI.Parent = CoreGui
elseif not isStudio and CoreGui:FindFirstChild("RobloxGui") then
	InterfaceUI.Parent = CoreGui:FindFirstChild("RobloxGui")
elseif not isStudio then
	InterfaceUI.Parent = CoreGui
end

if gethui then
	for _, Interface in ipairs(gethui():GetChildren()) do
		if Interface.Name == InterfaceUI.Name and Interface ~= InterfaceUI then
			Hide(Interface.SmartWindow)
			Interface.Enabled = false
			Interface.Name = "InfernoX-Old"
		end
	end
elseif not isStudio then
	for _, Interface in ipairs(CoreGui:GetChildren()) do
		if Interface.Name == InterfaceUI.Name and Interface ~= InterfaceUI then
			Hide(Interface.SmartWindow)
			Interface.Enabled = false
			Interface.Name = "InfernoX-Old"
		end
	end
end

InterfaceUI.Enabled = false
InterfaceUI.SmartWindow.Visible = false
InterfaceUI.Notifications.Template.Visible = false
InterfaceUI.DisplayOrder = 1000000000

local Main : Frame = InterfaceUI.SmartWindow
local Dragger = Main.Drag
local dragBar = InterfaceUI.Drag
local dragInteract = dragBar and dragBar.Interact or nil
local dragBarCosmetic = dragBar and dragBar.Drag or nil
local Elements = Main.Elements.Interactions
local LoadingFrame = Main.LoadingFrame
local Navigation = Main.Navigation
local Tabs = Navigation.Tabs
local Notifications = InterfaceUI.Notifications
local KeySystem : Frame = Main.KeySystem

-- local function LoadConfiguration(Configuration, autoload)
-- 	local Data = HttpService:JSONDecode(Configuration)
-- 	local changed
-- 	local notified = false

-- 	-- Iterate through current UI elements' flags
-- 	for FlagName, Flag in pairs(InfernoX.Flags) do
-- 		local FlagValue = Data[FlagName]

-- 		if FlagValue then
-- 			task.spawn(function()
-- 				if Flag.Type == "ColorPicker" then
-- 					changed = true
-- 					Flag:Set(UnpackColor(FlagValue))
-- 				else
-- 					if (Flag.CurrentValue or Flag.CurrentKeybind or Flag.CurrentOption or Flag.Color) ~= FlagValue then 
-- 						changed = true
-- 						Flag:Set(FlagValue) 	
-- 					end
-- 				end
-- 			end)
-- 		else
-- 			notified = true
-- 			InfernoX:Notification({Title = "Config Error", Content = "InfernoX was unable to load or find '"..FlagName.. "'' in the current script. Check ".. website .." for help.", Icon = "flag"})
-- 		end
-- 	end
-- 	if autoload and notified == false then
-- 		InfernoX:Notification({
-- 			Title = "Config Autoloaded",
-- 			Content = "The Configuration Has Been Automatically Loaded. Thank You For Using InfernoX Library",
-- 			Icon = "file-code-2",
-- 			ImageSource = "Lucide"
-- 		})
-- 	elseif notified == false then
-- 		InfernoX:Notification({
-- 			Title = "Config Loaded",
-- 			Content = "The Configuration Has Been Loaded. Thank You For Using InfernoX Library",
-- 			Icon = "file-code-2",
-- 			ImageSource = "Lucide"
-- 		})
-- 	end

-- 	return changed
-- end

-- local function SaveConfiguration(Configuration, ConfigFolder, hasRoot)
-- 	local Data = {}
-- 	for i,v in pairs(InfernoX.Flags) do
-- 		if v.Type == "ColorPicker" then
-- 			Data[i] = PackColor(v.Color)
-- 		else
-- 			Data[i] = v.CurrentValue or v.CurrentBind or v.CurrentOption or v.Color
-- 		end
-- 	end	
-- 	if hasRoot then
-- 		writefile(ConfigurationFolder .. "/" .. hasRoot .. "/" .. ConfigFolder .. "/" .. Configuration .. ConfigurationExtension, tostring(HttpService:JSONEncode(Data)))
-- 	else
-- 		writefile(ConfigurationFolder .. "/" .. "/" .. ConfigFolder .. Configuration .. ConfigurationExtension, tostring(HttpService:JSONEncode(Data)))
-- 	end
-- end

-- local function SetAutoload(ConfigName, ConfigFolder, hasRoot)
-- 	if hasRoot then
-- 		writefile(ConfigurationFolder .. "/" .. hasRoot .. "/" .. ConfigFolder .. "/" .. "autoload.txt", tostring(ConfigName) .. ConfigurationExtension)
-- 	else
-- 		writefile(ConfigurationFolder .. "/" .. "/" .. ConfigFolder .. "autoload.txt", tostring(ConfigName) .. ConfigurationExtension)
-- 	end
-- end

-- local function LoadAutoLoad(ConfigFolder, hasRoot)
-- 	local autoload = isfile(ConfigurationFolder .. "/" .. "/" .. ConfigFolder .. "autoload.txt")
-- 	if hasRoot then
-- 		autoload = isfile(ConfigurationFolder .. "/" .. hasRoot .. "/" .. ConfigFolder .. "/" .. "autoload.txt")
-- 	end

-- 	if autoload then
-- 		if hasRoot then
-- 			LoadConfiguration(readfile(ConfigurationFolder .. "/" .. hasRoot .. "/" .. ConfigFolder .. "/" .. readfile(ConfigurationFolder .. "/" .. hasRoot .. "/" .. ConfigFolder .. "/" .. "autoload.txt")), true)
-- 		else
-- 			LoadConfiguration(readfile(ConfigurationFolder .. "/" .. ConfigFolder .. "/" .. readfile(ConfigurationFolder .. "/" .. ConfigFolder .. "/" .. "autoload.txt")), true)
-- 		end
-- 	end
-- end

local function Draggable(Bar, Window, enableTaptic, tapticOffset)
	pcall(function()
		local Dragging, DragInput, MousePos, FramePos

		local function connectFunctions()
			if dragBar and enableTaptic then
				dragBar.MouseEnter:Connect(function()
					if not Dragging then
						TweenService:Create(dragBarCosmetic, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 0.5, Size = UDim2.new(0, 120, 0, 4)}):Play()
					end
				end)

				dragBar.MouseLeave:Connect(function()
					if not Dragging then
						TweenService:Create(dragBarCosmetic, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 0.7, Size = UDim2.new(0, 100, 0, 4)}):Play()
					end
				end)
			end
		end

		connectFunctions()

		Bar.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				Dragging = true
				MousePos = Input.Position
				FramePos = Window.Position

				if enableTaptic then
					TweenService:Create(dragBarCosmetic, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 110, 0, 4), BackgroundTransparency = 0}):Play()
				end

				Input.Changed:Connect(function()
					if Input.UserInputState == Enum.UserInputState.End then
						Dragging = false
						connectFunctions()

						if enableTaptic then
							TweenService:Create(dragBarCosmetic, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 100, 0, 4), BackgroundTransparency = 0.7}):Play()
						end
					end
				end)
			end
		end)

		Bar.InputChanged:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
				DragInput = Input
			end
		end)

		UserInputService.InputChanged:Connect(function(Input)
			if Input == DragInput and Dragging then
				local Delta = Input.Position - MousePos

				local newMainPosition = UDim2.new(FramePos.X.Scale, FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y)
				TweenService:Create(Window, TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = newMainPosition}):Play()

				if dragBar then
					local newDragBarPosition = UDim2.new(FramePos.X.Scale, FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y + 240)
					dragBar.Position = newDragBarPosition
				end
			end
		end)

	end)
end

function InfernoX:Notification(data) -- action e.g open messages
	task.spawn(function()
		data = Kwargify({
			Title = "Missing Title",
			Content = "Missing or Unknown Content",
			Icon = "view_in_ar",
			ImageSource = "Material"
		}, data or {})

		-- Notification Object Creation
		local newNotification = Notifications.Template:Clone()
		newNotification.Name = data.Title
		newNotification.Parent = Notifications
		newNotification.LayoutOrder = #Notifications:GetChildren()
		newNotification.Visible = false
		BlurModule(newNotification)

		-- Set Data
		newNotification.Title.Text = data.Title
		newNotification.Description.Text = data.Content 
		newNotification.Icon.Image = GetIcon(data.Icon, data.ImageSource)

		-- Set initial transparency values
		newNotification.BackgroundTransparency = 1
		newNotification.Title.TextTransparency = 1
		newNotification.Description.TextTransparency = 1
		newNotification.UIStroke.Transparency = 1
		newNotification.Shadow.ImageTransparency = 1
		newNotification.Icon.ImageTransparency = 1
		newNotification.Icon.BackgroundTransparency = 1

		task.wait()

		-- Calculate textbounds and set initial values
		newNotification.Size = UDim2.new(1, 0, 0, -Notifications:FindFirstChild("UIListLayout").Padding.Offset)

		newNotification.Icon.Size = UDim2.new(0, 28, 0, 28)
		newNotification.Icon.Position = UDim2.new(0, 16, 0.5, -1)

		newNotification.Visible = true

		newNotification.Description.Size = UDim2.new(1, -65, 0, math.huge)
		local bounds = newNotification.Description.TextBounds.Y + 55
		newNotification.Description.Size = UDim2.new(1,-65,0, bounds - 35)
		newNotification.Size = UDim2.new(1, 0, 0, -Notifications:FindFirstChild("UIListLayout").Padding.Offset)
		TweenService:Create(newNotification, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, 0, 0, bounds)}):Play()

		task.wait(0.15)
		TweenService:Create(newNotification, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.45}):Play()
		TweenService:Create(newNotification.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()

		task.wait(0.05)

		TweenService:Create(newNotification.Icon, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0}):Play()

		task.wait(0.05)
		TweenService:Create(newNotification.Description, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0.35}):Play()
		TweenService:Create(newNotification.UIStroke, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {Transparency = 0.95}):Play()
		TweenService:Create(newNotification.Shadow, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0.82}):Play()

		local waitDuration = math.min(math.max((#newNotification.Description.Text * 0.1) + 2.5, 3), 10)
		task.wait(data.Duration or waitDuration)

		newNotification.Icon.Visible = false
		TweenService:Create(newNotification, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
		TweenService:Create(newNotification.UIStroke, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
		TweenService:Create(newNotification.Shadow, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
		TweenService:Create(newNotification.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
		TweenService:Create(newNotification.Description, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()

		TweenService:Create(newNotification, TweenInfo.new(1, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, -90, 0, 0)}):Play()

		task.wait(1)

		TweenService:Create(newNotification, TweenInfo.new(1, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, -90, 0, -Notifications:FindFirstChild("UIListLayout").Padding.Offset)}):Play()

		newNotification.Visible = false
		newNotification:Destroy()
	end)
end

local function Unhide(Window, currentTab)
	Window.Size = SizeBleh
	Window.Elements.Visible = true
	Window.Visible = true
	task.wait()
	tween(Window, {BackgroundTransparency = 0.2})
	tween(Window.Elements, {BackgroundTransparency = 0.08})
	tween(Window.Line, {BackgroundTransparency = 0})
	tween(Window.Title.Title, {TextTransparency = 0})
	tween(Window.Title.subtitle, {TextTransparency = 0})
	tween(Window.Logo, {ImageTransparency = 0})
	tween(Window.Navigation.Line, {BackgroundTransparency = 0})

	for _, TopbarButton in ipairs(Window.Controls:GetChildren()) do
		if TopbarButton.ClassName == "Frame" and TopbarButton.Name ~= "Theme" then
			TopbarButton.Visible = true
			tween(TopbarButton, {BackgroundTransparency = 0.25})
			tween(TopbarButton.UIStroke, {Transparency = 0.5})
			tween(TopbarButton.ImageLabel, {ImageTransparency = 0.25})
		end
	end
	for _, tabbtn in ipairs(Window.Navigation.Tabs:GetChildren()) do
		if tabbtn.ClassName == "Frame" and tabbtn.Name ~= "InActive Template" then
			if tabbtn.Name == currentTab then
				TweenService:Create(tabbtn, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
				TweenService:Create(tabbtn.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 0.41}):Play()
			end
			TweenService:Create(tabbtn.ImageLabel, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0}):Play()
			TweenService:Create(tabbtn.DropShadowHolder.DropShadow, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
		end
	end

end

local MainSize
local MinSize 
if Camera.ViewportSize.X > 774 and Camera.ViewportSize.Y > 503 then
	MainSize = UDim2.fromOffset(720, 460)
	MinSize = UDim2.fromOffset(500, 42)
else
	MainSize = UDim2.fromOffset(Camera.ViewportSize.X - 100, Camera.ViewportSize.Y - 100)
	MinSize = UDim2.fromOffset(Camera.ViewportSize.X - 275, 42)
end

local function Maximise(Window)
	Window.Controls.ToggleSize.ImageLabel.Image = "rbxassetid://10137941941"
	tween(Window, {Size = MainSize})
	Window.Elements.Visible = true
	Window.Navigation.Visible = true
end

local function Minimize(Window)
	Window.Controls.ToggleSize.ImageLabel.Image = "rbxassetid://11036884234"
	Window.Elements.Visible = false
	Window.Navigation.Visible = false
	tween(Window, {Size = MinSize})
end


function InfernoX:CreateWindow(WindowSettings)

	WindowSettings = Kwargify({
		Name = "InfernoX Hub",
		Subtitle = "",
		LogoID = "6031097225",
		LoadingEnabled = true,
		LoadingTitle = "InfernoX Hub",
		LoadingSubtitle = "by InfernoX",

		ConfigSettings = {},

		KeySystem = false,
		KeySettings = {}
	}, WindowSettings or {})

	WindowSettings.ConfigSettings = Kwargify({
		RootFolder = nil,
		ConfigFolder = "Big Hub"
	}, WindowSettings.ConfigSettings or {})

	WindowSettings.KeySettings = Kwargify({
		Title = WindowSettings.Name,
		Subtitle = "Key System",
		Note = "No Instructions",
		SaveInRoot = false, -- Enabling will save the key in your RootFolder (YOU MUST HAVE ONE BEFORE ENABLING THIS OPTION)
		SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
		Key = {""}, -- List of keys that will be accepted by the system, please use a system like Pelican or Luarmor that provide key strings based on your HWID since putting a simple string is very easy to bypass
		SecondAction = {}	
	}, WindowSettings.KeySettings or {})

	WindowSettings.KeySettings.SecondAction = Kwargify({
		Enabled = false,
		Type = "Discord", -- Link/Discord
		Parameter = "" -- for discord, add the invite link like home tab. for link, type the link of ur key sys
	}, WindowSettings.KeySettings.SecondAction)

	local Passthrough = false

	local Window = { Bind = Enum.KeyCode.K, CurrentTab = nil, State = true, Size = false, Settings = nil }

	Main.Title.Title.Text = WindowSettings.Name
	Main.Title.subtitle.Text = WindowSettings.Subtitle
	Main.Logo.Image = "rbxassetid://" .. WindowSettings.LogoID
	Main.Visible = true
	Main.BackgroundTransparency = 1
	Main.Size = MainSize
	Main.Size = UDim2.fromOffset(Main.Size.X.Offset - 70, Main.Size.Y.Offset - 55)
	Main.Parent.ShadowHolder.Size = Main.Size
	LoadingFrame.Frame.Frame.Title.TextTransparency = 1
	LoadingFrame.Frame.Frame.Subtitle.TextTransparency = 1
	LoadingFrame.Version.TextTransparency = 1
	LoadingFrame.Frame.ImageLabel.ImageTransparency = 1

	tween(Elements.Parent, {BackgroundTransparency = 1})
	Elements.Parent.Visible = false

	LoadingFrame.Frame.Frame.Title.Text = WindowSettings.LoadingTitle
	LoadingFrame.Frame.Frame.Subtitle.Text = WindowSettings.LoadingSubtitle
	LoadingFrame.Version.Text = LoadingFrame.Frame.Frame.Title.Text == "InfernoX Interface Suite" and Release or "InfernoX UI"

	Navigation.Player.icon.ImageLabel.Image = Players:GetUserThumbnailAsync(Players.LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
	Navigation.Player.Namez.Text = Players.LocalPlayer.DisplayName
	Navigation.Player.TextLabel.Text = Players.LocalPlayer.Name

	for i,v in pairs(Main.Controls:GetChildren()) do
		v.Visible = false
	end

	Main:GetPropertyChangedSignal("Position"):Connect(function()
		Main.Parent.ShadowHolder.Position = Main.Position
	end)
	Main:GetPropertyChangedSignal("Size"):Connect(function()
		Main.Parent.ShadowHolder.Size = Main.Size
	end)

	LoadingFrame.Visible = true

	-- pcall(function()
	-- 	if not isfolder(ConfigurationFolder) then
	-- 		makefolder(ConfigurationFolder)
	-- 	end
	-- 	if WindowSettings.ConfigSettings.RootFolder then
	-- 		if not isfolder(ConfigurationFolder .. WindowSettings.ConfigSettings.RootFolder) then
	-- 			makefolder(ConfigurationFolder .. WindowSettings.ConfigSettings.RootFolder)
	-- 			if not isfolder(ConfigurationFolder .. WindowSettings.ConfigSettings.RootFolder .. WindowSettings.ConfigSettings.ConfigFolder) then
	-- 				makefolder(ConfigurationFolder .. WindowSettings.ConfigSettings.RootFolder .. WindowSettings.ConfigSettings.ConfigFolder)
	-- 			end
	-- 		end
	-- 	else
	-- 		if not isfolder(ConfigurationFolder .. WindowSettings.ConfigSettings.ConfigFolder) then
	-- 			makefolder(ConfigurationFolder .. WindowSettings.ConfigSettings.ConfigFolder)
	-- 		end
	-- 	end

	-- 	LoadAutoLoad(WindowSettings.ConfigSettings.ConfigFolder, WindowSettings.ConfigSettings.RootFolder)
	-- end)

	InterfaceUI.Enabled = true

	BlurModule(Main)

	if WindowSettings.KeySystem then
		local KeySettings = WindowSettings.KeySettings
		
		Draggable(Dragger, Main)
		Draggable(InterfaceUI.MobileSupport, InterfaceUI.MobileSupport)
		if dragBar then Draggable(dragInteract, Main, true, 255) end

		if not WindowSettings.KeySettings then
			Passthrough = true
			return
		end
		
		WindowSettings.KeySettings.FileName = "key"

		if typeof(WindowSettings.KeySettings.Key) == "string" then WindowSettings.KeySettings.Key = {WindowSettings.KeySettings.Key} end

		local direc = WindowSettings.KeySettings.SaveInRoot and "InfernoX/Configurations/" .. WindowSettings.ConfigSettings.RootFolder .. "/" .. WindowSettings.ConfigSettings.ConfigFolder .. "/Key System/" or "InfernoX/Configurations/" ..  WindowSettings.ConfigSettings.ConfigFolder .. "/Key System/"

		if isfile and isfile(direc .. WindowSettings.KeySettings.FileName .. ".Infernox") then
			for i, Key in ipairs(WindowSettings.KeySettings.Key) do
				if string.find(readfile(direc .. WindowSettings.KeySettings.FileName .. ".Infernox"), Key) then
					Passthrough = true
					break
				end
			end
		end

		if not Passthrough then

			local Btn = KeySystem.Action.Copy
			local typesys = KeySettings.SecondAction.Type
			
			if typesys == "Discord" then
				Btn = KeySystem.Action.Discord
			end

			local AttemptsRemaining = math.random(2, 5)

			KeySystem.Visible = true
			KeySystem.Title.Text = WindowSettings.KeySettings.Title
			KeySystem.Subtitle.Text = WindowSettings.KeySettings.Subtitle
			KeySystem.textshit.Text = WindowSettings.KeySettings.Note

			if KeySettings.SecondAction.Enabled == true then
				Btn.Visible = true
			end
			
			Btn.Interact.MouseButton1Click:Connect(function()
				if typesys == "Discord" then
					setclipboard(tostring("https://discord.gg/"..KeySettings.SecondAction.Parameter)) -- Hunter if you see this I added copy also was too lazy to send u msg
					if request then
						request({
							Url = 'http://127.0.0.1:6463/rpc?v=1',
							Method = 'POST',
							Headers = {
								['Content-Type'] = 'application/json',
								Origin = 'https://discord.com'
							},
							Body = HttpService:JSONEncode({
								cmd = 'INVITE_BROWSER',
								nonce = HttpService:GenerateGUID(false),
								args = {code = KeySettings.SecondAction.Parameter}
							})
						})
					end
				else
					setclipboard(tostring(KeySettings.SecondAction.Parameter))
				end
			end)

			KeySystem.Action.Submit.Interact.MouseButton1Click:Connect(function()
				if #KeySystem.Input.InputBox.Text == 0 then return end
				local KeyFound = false
				local FoundKey = ''
				for _, Key in ipairs(WindowSettings.KeySettings.Key) do
					if KeySystem.Input.InputBox.Text == Key then
						KeyFound = true
						FoundKey = Key
						break
					end
				end
				if KeyFound then 
					for _, instance in pairs(KeySystem:GetDescendants()) do
						if instance.ClassName ~= "UICorner" and instance.ClassName ~= "UIPadding" then
							if instance.ClassName ~= "UIStroke" and instance.ClassName ~= "UIListLayout" then
								tween(instance, {BackgroundTransparency = 1}, nil,TweenInfo.new(0.6, Enum.EasingStyle.Exponential))
							end
							if instance.ClassName == "ImageButton" then
								tween(instance, {ImageTransparency = 1}, nil,TweenInfo.new(0.5, Enum.EasingStyle.Exponential))
							end
							if instance.ClassName == "TextLabel" then
								tween(instance, {TextTransparency = 1}, nil,TweenInfo.new(0.4, Enum.EasingStyle.Exponential))
							end
							if instance.ClassName == "UIStroke" then
								tween(instance, {Transparency = 1}, nil,TweenInfo.new(0.5, Enum.EasingStyle.Exponential))
							end
						end
					end
					tween(KeySystem, {BackgroundTransparency = 1}, nil,TweenInfo.new(0.6, Enum.EasingStyle.Exponential))
					task.wait(0.51)
					Passthrough = true
					KeySystem.Visible = false
					if WindowSettings.KeySettings.SaveKey then
						if writefile then
							writefile(direc .. WindowSettings.KeySettings.FileName .. ".Infernox", FoundKey)
						end
						InfernoX:Notification({Title = "Key System", Content = "The key for this script has been saved successfully.", Icon = "lock_open"})
					end
				else
					if AttemptsRemaining == 0 then

						game.Players.LocalPlayer:Kick("No Attempts Remaining")
						game:Shutdown()
					end
					KeySystem.Input.InputBox.Text = "Incorrect Key"
					AttemptsRemaining = AttemptsRemaining - 1
					task.wait(0.4)
					KeySystem.Input.InputBox.Text = ""
				end
			end)

			KeySystem.Close.MouseButton1Click:Connect(function()
				
				InfernoX:Destroy()
			end)
		end
	end

	if WindowSettings.KeySystem then
		repeat task.wait() until Passthrough
	end

	if WindowSettings.LoadingEnabled then
		task.wait(0.3)
		TweenService:Create(LoadingFrame.Frame.Frame.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
		TweenService:Create(LoadingFrame.Frame.ImageLabel, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0}):Play()
		task.wait(0.05)
		TweenService:Create(LoadingFrame.Frame.Frame.Subtitle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
		TweenService:Create(LoadingFrame.Version, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
		task.wait(0.29)
		TweenService:Create(LoadingFrame.Frame.ImageLabel, TweenInfo.new(1.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 2, false, 0.2), {Rotation = 450}):Play()

		task.wait(3.32)

		TweenService:Create(LoadingFrame.Frame.Frame.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
		TweenService:Create(LoadingFrame.Frame.ImageLabel, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
		task.wait(0.05)
		TweenService:Create(LoadingFrame.Frame.Frame.Subtitle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
		TweenService:Create(LoadingFrame.Version, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
		wait(0.3)
		TweenService:Create(LoadingFrame, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
	end

	TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundTransparency = 0.2, Size = MainSize}):Play()
	TweenService:Create(Main.Parent.ShadowHolder, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = MainSize}):Play()
	TweenService:Create(Main.Title.Title, TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
	TweenService:Create(Main.Title.subtitle, TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
	TweenService:Create(Main.Logo, TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
	TweenService:Create(Navigation.Player.icon.ImageLabel, TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
	TweenService:Create(Navigation.Player.icon.UIStroke, TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Transparency = 0}):Play()
	TweenService:Create(Main.Line, TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
	wait(0.4)
	LoadingFrame.Visible = false

	Draggable(Dragger, Main)
	Draggable(InterfaceUI.MobileSupport, InterfaceUI.MobileSupport)
	if dragBar then Draggable(dragInteract, Main, true, 255) end

	Elements.Template.LayoutOrder = 1000000000
	Elements.Template.Visible = false
	Navigation.Tabs["InActive Template"].LayoutOrder = 1000000000
	Navigation.Tabs["InActive Template"].Visible = false

	local FirstTab = true

	function Window:CreateHomeTab(HomeTabSettings)

		HomeTabSettings = Kwargify({
			Icon = 1,
			SupportedExecutors = {"Vega X", "Delta", "Nihon", "Xeno"}, -- THESE DEFAULTS ARE PLACEHOLDERS!! I DO NOT ADVERTISE THESE, THEY ARE JUS THE FIRST THAT CAME TO MIND. I HAVE NO IDEA WHETHER THEYA RE RATS (they prob are) AND IM NOT RESPONSIBLE IF U GET VIRUSES FROM INSTALLING AFTER SEEING THIS LIST
			DiscordInvite = "noinvitelink" -- The disvord invite link. Do not include the link so for example if my invite was discord.gg/nebula I would put nebula
		}, HomeTabSettings or {})

		local HomeTab = {}

		local HomeTabButton = Navigation.Tabs.Home
		HomeTabButton.Visible = true
		if HomeTabSettings.Icon == 2 then
			HomeTabButton.ImageLabel.Image = GetIcon("dashboard", "Material")
		end

		local HomeTabPage = Elements.Home
		HomeTabPage.Visible = true

		function HomeTab:Activate()
			tween(HomeTabButton.ImageLabel, {ImageColor3 = Color3.fromRGB(255,255,255)})
			tween(HomeTabButton, {BackgroundTransparency = 0})
			tween(HomeTabButton.UIStroke, {Transparency = 0.41})

			Elements.UIPageLayout:JumpTo(HomeTabPage)

			task.wait(0.05)

			for _, OtherTabButton in ipairs(Navigation.Tabs:GetChildren()) do
				if OtherTabButton.Name ~= "InActive Template" and OtherTabButton.ClassName == "Frame" and OtherTabButton ~= HomeTabButton then
					tween(OtherTabButton.ImageLabel, {ImageColor3 = Color3.fromRGB(221,221,221)})
					tween(OtherTabButton, {BackgroundTransparency = 1})
					tween(OtherTabButton.UIStroke, {Transparency = 1})
				end

			end

			Window.CurrentTab = "Home"
		end

		HomeTab:Activate()
		FirstTab = false
		HomeTabButton.Interact.MouseButton1Click:Connect(function()
			HomeTab:Activate()
		end)


		HomeTabPage.icon.ImageLabel.Image = Players:GetUserThumbnailAsync(Players.LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
		HomeTabPage.player.Text.Text = "Hello, " .. Players.LocalPlayer.DisplayName
		HomeTabPage.player.user.Text = Players.LocalPlayer.Name .. " - ".. WindowSettings.Name

		HomeTabPage.detailsholder.dashboard.Client.Title.Text = (isStudio and "Debugging (Studio)" or identifyexecutor()) or "Your Executor Does Not Support identifyexecutor."
		for i,v in pairs(HomeTabSettings.SupportedExecutors) do
			if isStudio then HomeTabPage.detailsholder.dashboard.Client.Subtitle.Text = "InfernoX Hub - Debugging Mode" break end
			if v == identifyexecutor() then
				HomeTabPage.detailsholder.dashboard.Client.Subtitle.Text = "Your Executor Supports This Script."
				break
			else
				HomeTabPage.detailsholder.dashboard.Client.Subtitle.Text = "Your Executor Isn't Officialy Supported By This Script."
				break
			end
		end

		-- Stolen From Sirius Stuff Begins Here

		HomeTabPage.detailsholder.dashboard.Discord.Interact.MouseButton1Click:Connect(function()
			setclipboard(tostring("https://discord.gg/"..HomeTabSettings.DiscordInvite)) -- Hunter if you see this I added copy also was too lazy to send u msg
			if request then
				request({
					Url = 'http://127.0.0.1:6463/rpc?v=1',
					Method = 'POST',
					Headers = {
						['Content-Type'] = 'application/json',
						Origin = 'https://discord.com'
					},
					Body = HttpService:JSONEncode({
						cmd = 'INVITE_BROWSER',
						nonce = HttpService:GenerateGUID(false),
						args = {code = HomeTabSettings.DiscordInvite}
					})
				})
			end
		end)

		local friendsCooldown = 0
		local function getPing() return math.clamp(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue(), 10, 700) end

		local function checkFriends()
			if friendsCooldown == 0 then

				friendsCooldown = 25

				local playersFriends = {}
				local friendsInTotal = 0
				local onlineFriends = 0 
				local friendsInGame = 0 

				local list = Players:GetFriendsAsync(Player.UserId)
				while true do -- loop through all the pages
					for _, data in list:GetCurrentPage() do
						friendsInTotal +=1
						table.insert(playersFriends, Data)
					end

					if list.IsFinished then
						-- stop the loop since this is the last page
						break
					else 
						-- go to the next page
						list:AdvanceToNextPageAsync()
					end
				end
				for i, v in pairs(Player:GetFriendsOnline()) do
					onlineFriends += 1
				end

				for i,v in pairs(playersFriends) do
					if Players:FindFirstChild(v.Username) then
						friendsInGame = friendsInGame + 1
					end
				end

				HomeTabPage.detailsholder.dashboard.Friends.All.Value.Text = tostring(friendsInTotal).." friends"
				HomeTabPage.detailsholder.dashboard.Friends.Offline.Value.Text = tostring(friendsInTotal - onlineFriends).." friends"
				HomeTabPage.detailsholder.dashboard.Friends.Online.Value.Text = tostring(onlineFriends).." friends"
				HomeTabPage.detailsholder.dashboard.Friends.InGame.Value.Text = tostring(friendsInGame).." friends"

			else
				friendsCooldown -= 1
			end
		end

		local function format(Int)
			return string.format("%02i", Int)
		end

		local function convertToHMS(Seconds)
			local Minutes = (Seconds - Seconds%60)/60
			Seconds = Seconds - Minutes*60
			local Hours = (Minutes - Minutes%60)/60
			Minutes = Minutes - Hours*60
			return format(Hours)..":"..format(Minutes)..":"..format(Seconds)
		end

		coroutine.wrap(function()
			while task.wait() do


				-- Players
				HomeTabPage.detailsholder.dashboard.Server.Players.Value.Text = #Players:GetPlayers().." playing"
				HomeTabPage.detailsholder.dashboard.Server.MaxPlayers.Value.Text = Players.MaxPlayers.." players can join this server"

				-- Ping
				HomeTabPage.detailsholder.dashboard.Server.Latency.Value.Text = isStudio and tostring(math.round((Players.LocalPlayer:GetNetworkPing() * 2 ) / 0.01)) .."ms" or tostring(math.floor(getPing()) .."ms")

				-- Time
				HomeTabPage.detailsholder.dashboard.Server.Time.Value.Text = convertToHMS(time())

				-- Region
				HomeTabPage.detailsholder.dashboard.Server.Region.Value.Text = Localization:GetCountryRegionForPlayerAsync(Players.LocalPlayer)

				checkFriends()
			end
		end)()

		-- Stolen From Sirius Stuff ends here

	end

	function Window:CreateTab(TabSettings)

		local Tab = {}

		TabSettings = Kwargify({
			Name = "Tab",
			ShowTitle = true,
			Icon = "view_in_ar",
			ImageSource = "Material" 
		}, TabSettings or {})

		local TabButton = Navigation.Tabs["InActive Template"]:Clone()

		TabButton.Name = TabSettings.Name
		TabButton.TextLabel.Text = TabSettings.Name
		TabButton.Parent = Navigation.Tabs
		TabButton.ImageLabel.Image = GetIcon(TabSettings.Icon, TabSettings.ImageSource)

		TabButton.Visible = true

		local TabPage = Elements.Template:Clone()
		TabPage.Name = TabSettings.Name
		TabPage.Title.Visible = TabSettings.ShowTitle
		TabPage.Title.Text = TabSettings.Name
		TabPage.Visible = true

		Tab.Page = TabPage

		if TabSettings.ShowTitle == false then
			TabPage.UIPadding.PaddingTop = UDim.new(0,10)
		end

		TabPage.LayoutOrder = #Elements:GetChildren() - 3

		for _, TemplateElement in ipairs(TabPage:GetChildren()) do
			if TemplateElement.ClassName == "Frame" or TemplateElement.ClassName == "TextLabel" and TemplateElement.Name ~= "Title" then
				TemplateElement:Destroy()
			end
		end
		TabPage.Parent = Elements

		function Tab:Activate()
			tween(TabButton.ImageLabel, {ImageColor3 = Color3.fromRGB(255,255,255)})
			tween(TabButton, {BackgroundTransparency = 0})
			tween(TabButton.UIStroke, {Transparency = 0.41})

			Elements.UIPageLayout:JumpTo(TabPage)

			task.wait(0.05)

			for _, OtherTabButton in ipairs(Navigation.Tabs:GetChildren()) do
				if OtherTabButton.Name ~= "InActive Template" and OtherTabButton.ClassName == "Frame" and OtherTabButton ~= TabButton then
					tween(OtherTabButton.ImageLabel, {ImageColor3 = Color3.fromRGB(221,221,221)})
					tween(OtherTabButton, {BackgroundTransparency = 1})
					tween(OtherTabButton.UIStroke, {Transparency = 1})
				end

			end

			Window.CurrentTab = TabSettings.Name
		end

		if FirstTab then
			Tab:Activate()
		end

		task.wait(0.01)

		TabButton.Interact.MouseButton1Click:Connect(function()
			Tab:Activate()
		end)

		FirstTab = false

		-- Section
		function Tab:CreateSection(name : string)

			local Section = {}

			if name == nil then name = "Section" end

			Section.Name = name

			local Sectiont = Elements.Template.Section:Clone()
			Sectiont.Text = name
			Sectiont.Visible = true
			Sectiont.Parent = TabPage
			local TabPage = Sectiont.Frame

			Sectiont.TextTransparency = 1
			tween(Sectiont, {TextTransparency = 0})

			function Section:Set(NewSection)
				Sectiont.Text = NewSection
			end

			function Section:Destroy()
				Sectiont:Destroy()
			end

			-- Divider
			function Section:CreateDivider()
				TabPage.Position = UDim2.new(0,0,0,28)
				local b = Elements.Template.Divider:Clone()
				b.Parent = TabPage
				b.Size = UDim2.new(1,0,0,18)
				b.Line.BackgroundTransparency = 1
				tween(b.Line, {BackgroundTransparency = 0})
			end

			-- Button
			function Section:CreateButton(ButtonSettings)
				TabPage.Position = UDim2.new(0,0,0,28)

				ButtonSettings = Kwargify({
					Name = "Button",
					Description = nil,
					Callback = function()

					end,
				}, ButtonSettings or {})

				local ButtonV = {
					Hover = false,
					Settings = ButtonSettings
				}


				local Button
				if ButtonSettings.Description == nil and ButtonSettings.Description ~= "" then
					Button = Elements.Template.Button:Clone()
				else
					Button = Elements.Template.ButtonDesc:Clone()
				end
				Button.Name = ButtonSettings.Name
				Button.Title.Text = ButtonSettings.Name
				if ButtonSettings.Description ~= nil and ButtonSettings.Description ~= "" then
					Button.Desc.Text = ButtonSettings.Description
				end
				Button.Visible = true
				Button.Parent = TabPage

				Button.UIStroke.Transparency = 1
				Button.Title.TextTransparency = 1
				if ButtonSettings.Description ~= nil and ButtonSettings.Description ~= "" then
					Button.Desc.TextTransparency = 1
				end

				TweenService:Create(Button, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
				TweenService:Create(Button.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
				TweenService:Create(Button.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()	
				if ButtonSettings.Description ~= nil and ButtonSettings.Description ~= "" then
					TweenService:Create(Button.Desc, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()	
				end

				Button.Interact["MouseButton1Click"]:Connect(function()
					local Success,Response = pcall(ButtonSettings.Callback)

					if not Success then
						TweenService:Create(Button, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
						TweenService:Create(Button, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
						TweenService:Create(Button.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
						Button.Title.Text = "Callback Error"
						print("InfernoX Interface Suite | "..ButtonSettings.Name.." Callback Error " ..tostring(Response))
						wait(0.5)
						Button.Title.Text = ButtonSettings.Name
						TweenService:Create(Button, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
						TweenService:Create(Button, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(32, 30, 38)}):Play()
						TweenService:Create(Button.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
					else
						tween(Button.UIStroke, {Color = Color3.fromRGB(136, 131, 163)})
						wait(0.2)
						if ButtonV.Hover then
							tween(Button.UIStroke, {Color = Color3.fromRGB(87, 84, 104)})
						else
							tween(Button.UIStroke, {Color = Color3.fromRGB(64,61,76)})
						end
					end
				end)

				Button["MouseEnter"]:Connect(function()
					ButtonV.Hover = true
					tween(Button.UIStroke, {Color = Color3.fromRGB(87, 84, 104)})
				end)

				Button["MouseLeave"]:Connect(function()
					ButtonV.Hover = false
					tween(Button.UIStroke, {Color = Color3.fromRGB(64,61,76)})
				end)

				function ButtonV:Set(ButtonSettings2)
					ButtonSettings2 = Kwargify({
						Name = ButtonSettings.Name,
						Description = ButtonSettings.Description,
						Callback = ButtonSettings.Callback
					}, ButtonSettings2 or {})

					ButtonSettings = ButtonSettings2
					ButtonV.Settings = ButtonSettings2

					Button.Name = ButtonSettings.Name
					Button.Title.Text = ButtonSettings.Name
					if ButtonSettings.Description ~= nil and ButtonSettings.Description ~= "" and Button.Desc ~= nil then
						Button.Desc.Text = ButtonSettings.Description
					end
				end

				function ButtonV:Destroy()
					Button.Visible = false
					Button:Destroy()
				end

				return ButtonV
			end

			-- Label
			function Section:CreateLabel(LabelSettings)
				TabPage.Position = UDim2.new(0,0,0,28)

				local LabelV = {}

				LabelSettings = Kwargify({
					Text = "Label",
					Style = 1
				}, LabelSettings or {}) 

				LabelV.Settings = LabelSettings

				local Label
				if LabelSettings.Style == 1 then
					Label = Elements.Template.Label:Clone()
				elseif LabelSettings.Style == 2 then
					Label = Elements.Template.Info:Clone()
				elseif LabelSettings.Style == 3 then
					Label = Elements.Template.Warn:Clone()
				end

				Label.Text.Text = LabelSettings.Text
				Label.Visible = true
				Label.Parent = TabPage

				Label.BackgroundTransparency = 1
				Label.UIStroke.Transparency = 1
				Label.Text.TextTransparency = 1

				if LabelSettings.Style ~= 1 then
					TweenService:Create(Label, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.8}):Play()
				else
					TweenService:Create(Label, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
				end
				TweenService:Create(Label.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
				TweenService:Create(Label.Text, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()	

				function LabelV:Set(NewLabel)
					LabelSettings.Text = NewLabel
					LabelV.Settings = LabelSettings
					Label.Text.Text = NewLabel
				end

				function LabelV:Destroy()
					Label.Visible = false
					Label:Destroy()
				end

				return LabelV
			end

			-- Paragraph
			function Section:CreateParagraph(ParagraphSettings)
				TabPage.Position = UDim2.new(0,0,0,28)

				ParagraphSettings = Kwargify({
					Title = "Paragraph",
					Text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus venenatis lacus sed tempus eleifend. Mauris interdum bibendum felis, in tempor augue egestas vel. Praesent tristique consectetur ex, eu pretium sem placerat non. Vestibulum a nisi sit amet augue facilisis consectetur sit amet et nunc. Integer fermentum ornare cursus. Pellentesque sed ultricies metus, ut egestas metus. Vivamus auctor erat ac sapien vulputate, nec ultricies sem tempor. Quisque leo lorem, faucibus nec pulvinar nec, congue eu velit. Duis sodales massa efficitur imperdiet ultrices. Donec eros ipsum, ornare pharetra purus aliquam, tincidunt elementum nisi. Ut mi tortor, feugiat eget nunc vitae, facilisis interdum dui. Vivamus ullamcorper nunc dui, a dapibus nisi pretium ac. Integer eleifend placerat nibh, maximus malesuada tellus. Cras in justo in ligula scelerisque suscipit vel vitae quam."
				}, ParagraphSettings or {})

				local ParagraphV = {
					Settings = ParagraphSettings
				}

				local Paragraph = Elements.Template.Paragraph:Clone()
				Paragraph.Title.Text = ParagraphSettings.Title
				Paragraph.Text.Text = ParagraphSettings.Text
				Paragraph.Visible = true
				Paragraph.Parent = TabPage

				Paragraph.BackgroundTransparency = 1
				Paragraph.UIStroke.Transparency = 1
				Paragraph.Title.TextTransparency = 1
				Paragraph.Text.TextTransparency = 1

				TweenService:Create(Paragraph, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
				TweenService:Create(Paragraph.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
				TweenService:Create(Paragraph.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()	
				TweenService:Create(Paragraph.Text, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()	

				function ParagraphV:Update()
					Paragraph.Text.Size = UDim2.new(Paragraph.Text.Size.X.Scale, Paragraph.Text.Size.X.Offset, 0, math.huge)
					Paragraph.Text.Size = UDim2.new(Paragraph.Text.Size.X.Scale, Paragraph.Text.Size.X.Offset, 0, Paragraph.Text.TextBounds.Y)
					tween(Paragraph, {Size = UDim2.new(Paragraph.Size.X.Scale, Paragraph.Size.X.Offset, 0, Paragraph.Text.TextBounds.Y + 40)})
				end

				function ParagraphV:Set(NewParagraphSettings)

					NewParagraphSettings = Kwargify({
						Title = ParagraphSettings.Title,
						Text = ParagraphSettings.Text
					}, NewParagraphSettings or {})

					ParagraphV.Settings = NewParagraphSettings

					Paragraph.Title.Text = NewParagraphSettings.Title
					Paragraph.Text.Text = NewParagraphSettings.Text

					ParagraphV:Update()

				end

				function ParagraphV:Destroy()
					Paragraph.Visible = false
					Paragraph:Destroy()
				end

				ParagraphV:Update()

				return ParagraphV
			end

			-- Slider
			function Section:CreateSlider(SliderSettings, Flag)
				TabPage.Position = UDim2.new(0,0,0,28)
				local SliderV = { IgnoreConfig = false, Class = "Slider", Settings = SliderSettings }

				SliderSettings = Kwargify({
					Name = "Slider",
					Range = {0, 200},
					Increment = 1,
					CurrentValue = 100,
					Callback = function(Value)

					end,
				}, SliderSettings or {})

				local SLDragging = false
				local Slider = Elements.Template.Slider:Clone()
				Slider.Name = SliderSettings.Name .. " - Slider"
				Slider.Title.Text = SliderSettings.Name
				Slider.Visible = true
				Slider.Parent = TabPage

				Slider.BackgroundTransparency = 1
				Slider.UIStroke.Transparency = 1
				Slider.Title.TextTransparency = 1

				TweenService:Create(Slider, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
				TweenService:Create(Slider.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
				TweenService:Create(Slider.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()	

				Slider.Main.Progress.Size =	UDim2.new(0, Slider.Main.AbsoluteSize.X * ((SliderSettings.CurrentValue + SliderSettings.Range[1]) / (SliderSettings.Range[2] - SliderSettings.Range[1])) > 5 and Slider.Main.AbsoluteSize.X * (SliderSettings.CurrentValue / (SliderSettings.Range[2] - SliderSettings.Range[1])) or 5, 1, 0)

				Slider.Value.Text = tostring(SliderSettings.CurrentValue)
				SliderV.CurrentValue = Slider.Value.Text

				SliderSettings.Callback(SliderSettings.CurrentValue)

				Slider["MouseEnter"]:Connect(function()
					tween(Slider.UIStroke, {Color = Color3.fromRGB(87, 84, 104)})
				end)

				Slider["MouseLeave"]:Connect(function()
					tween(Slider.UIStroke, {Color = Color3.fromRGB(64,61,76)})
				end)

				Slider.Interact.InputBegan:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then 
						SLDragging = true 
					end 
				end)

				Slider.Interact.InputEnded:Connect(function(Input) 
					if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then 
						SLDragging = false 
					end 
				end)

				Slider.Interact.MouseButton1Down:Connect(function()
					local Current = Slider.Main.Progress.AbsolutePosition.X + Slider.Main.Progress.AbsoluteSize.X
					local Start = Current
					local Location
					local Loop; Loop = RunService.Stepped:Connect(function()
						if SLDragging then
							Location = UserInputService:GetMouseLocation().X
							Current = Current + 0.025 * (Location - Start)

							if Location < Slider.Main.AbsolutePosition.X then
								Location = Slider.Main.AbsolutePosition.X
							elseif Location > Slider.Main.AbsolutePosition.X + Slider.Main.AbsoluteSize.X then
								Location = Slider.Main.AbsolutePosition.X + Slider.Main.AbsoluteSize.X
							end

							if Current < Slider.Main.AbsolutePosition.X + 5 then
								Current = Slider.Main.AbsolutePosition.X + 5
							elseif Current > Slider.Main.AbsolutePosition.X + Slider.Main.AbsoluteSize.X then
								Current = Slider.Main.AbsolutePosition.X + Slider.Main.AbsoluteSize.X
							end

							if Current <= Location and (Location - Start) < 0 then
								Start = Location
							elseif Current >= Location and (Location - Start) > 0 then
								Start = Location
							end
							Slider.Main.Progress.Size = UDim2.new(0, Location - Slider.Main.AbsolutePosition.X, 1, 0)
							local NewValue = SliderSettings.Range[1] + (Location - Slider.Main.AbsolutePosition.X) / Slider.Main.AbsoluteSize.X * (SliderSettings.Range[2] - SliderSettings.Range[1])

							NewValue = math.floor(NewValue / SliderSettings.Increment + 0.5) * (SliderSettings.Increment * 10000000) / 10000000

							Slider.Value.Text = tostring(NewValue)

							if SliderSettings.CurrentValue ~= NewValue then
								local Success, Response = pcall(function()
									SliderSettings.Callback(NewValue)
								end)
								if not Success then
									TweenService:Create(Slider, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
									TweenService:Create(Slider, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
									TweenService:Create(Slider.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
									Slider.Title.Text = "Callback Error"
									print("InfernoX Interface Suite | "..SliderSettings.Name.." Callback Error " ..tostring(Response))
									wait(0.5)
									Slider.Title.Text = SliderSettings.Name
									TweenService:Create(Slider, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
									TweenService:Create(Slider, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(32, 30, 38)}):Play()
									TweenService:Create(Slider.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
								end

								SliderSettings.CurrentValue = NewValue
								SliderV.CurrentValue = SliderSettings.CurrentValue
								-- InfernoX.Flags[SliderSettings.Flag] = SliderSettings
							end
						else
							TweenService:Create(Slider.Main.Progress, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.In, 0, false), {Size = UDim2.new(0, Location - Slider.Main.AbsolutePosition.X > 5 and Location - Slider.Main.AbsolutePosition.X or 5, 1, 0)}):Play()
							Loop:Disconnect()
						end
					end)
				end)

				local function Set(NewVal, bleh)

					NewVal = NewVal or SliderSettings.CurrentValue

					TweenService:Create(Slider.Main.Progress, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.InOut), {Size = UDim2.new(0, Slider.Main.AbsoluteSize.X * ((NewVal + SliderSettings.Range[1]) / (SliderSettings.Range[2] - SliderSettings.Range[1])) > 5 and Slider.Main.AbsoluteSize.X * (NewVal / (SliderSettings.Range[2] - SliderSettings.Range[1])) or 5, 1, 0)}):Play()
					if not bleh then Slider.Value.Text = tostring(NewVal) end
					local Success, Response = pcall(function()
						SliderSettings.Callback(NewVal)
					end)
					if not Success then
						TweenService:Create(Slider, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
						TweenService:Create(Slider, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
						TweenService:Create(Slider.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
						Slider.Title.Text = "Callback Error"
						print("InfernoX Interface Suite | "..SliderSettings.Name.." Callback Error " ..tostring(Response))
						wait(0.5)
						Slider.Title.Text = SliderSettings.Name
						TweenService:Create(Slider, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
						TweenService:Create(Slider, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(30, 33, 40)}):Play()
						TweenService:Create(Slider.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
					end

					SliderSettings.CurrentValue = NewVal
					SliderV.CurrentValue = SliderSettings.CurrentValue
					-- InfernoX.Flags[SliderSettings.Flag] = SliderSettings

				end

				function SliderV:UpdateValue(Value)
					Set(tonumber(Value))
				end 

				Slider.Value:GetPropertyChangedSignal("Text"):Connect(function()
					local text = Slider.Value.Text
					if not tonumber(text) and text ~= "." then
						Slider.Value.Text = text:match("[0-9.]*") or ""
					end
					if SliderSettings.Range[2] < (tonumber(Slider.Value.Text) or 0) then Slider.Value.Text = SliderSettings.Range[2] end
					Slider.Value.Size = UDim2.fromOffset(Slider.Value.TextBounds.X, 23)
					Set(tonumber(Slider.Value.Text), true)
				end)

				function SliderV:Set(NewSliderSettings)
					NewSliderSettings = Kwargify({
						Name = SliderSettings.Name,
						Range = SliderSettings.Range,
						Increment = SliderSettings.Increment,
						CurrentValue = SliderSettings.CurrentValue,
						Callback = SliderSettings.Callback
					}, NewSliderSettings or {})

					SliderSettings = NewSliderSettings
					SliderV.Settings = NewSliderSettings

					Slider.Name = SliderSettings.Name .. " - Slider"
					Slider.Title.Text = SliderSettings.Name

					Set()

					-- InfernoX.Flags[SliderSettings.Flag] = SliderSettings
				end

				function SliderV:Destroy()
					Slider.Visible = false
					Slider:Destroy()
				end

				if Flag then
					InfernoX.Options[Flag] = SliderV
				end

				InterfaceUI.ThemeRemote:GetPropertyChangedSignal("Value"):Connect(function()
					Slider.Main.color.Color = InfernoX.ThemeGradient
					Slider.Main.UIStroke.color.Color = InfernoX.ThemeGradient
				end)

				return SliderV

			end

			-- Toggle
			function Section:CreateToggle(ToggleSettings, Flag)    
				TabPage.Position = UDim2.new(0,0,0,28)
				local ToggleV = { IgnoreConfig = false, Class = "Toggle" }

				ToggleSettings = Kwargify({
					Name = "Toggle",
					Description = nil,
					CurrentValue = false,
					Callback = function(Value)
					end,
				}, ToggleSettings or {})


				local Toggle

				if ToggleSettings.Description ~= nil and ToggleSettings.Description ~= "" then
					Toggle = Elements.Template.ToggleDesc:Clone()
				else
					Toggle = Elements.Template.Toggle:Clone()
				end

				Toggle.Visible = true
				Toggle.Parent = TabPage

				Toggle.Name = ToggleSettings.Name .. " - Toggle"
				Toggle.Title.Text = ToggleSettings.Name
				if ToggleSettings.Description ~= nil and ToggleSettings.Description ~= "" then
					Toggle.Desc.Text = ToggleSettings.Description
				end

				Toggle.UIStroke.Transparency = 1
				Toggle.Title.TextTransparency = 1
				if ToggleSettings.Description ~= nil and ToggleSettings.Description ~= "" then
					Toggle.Desc.TextTransparency = 1
				end

				TweenService:Create(Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
				if ToggleSettings.Description ~= nil and ToggleSettings.Description ~= "" then
					TweenService:Create(Toggle.Desc, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
				end
				TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
				TweenService:Create(Toggle.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()	

				local function Set(bool)
					if bool then
						Toggle.toggle.color.Enabled = true
						tween(Toggle.toggle, {BackgroundTransparency = 0})

						Toggle.toggle.UIStroke.color.Enabled = true
						tween(Toggle.toggle.UIStroke, {Color = Color3.new(255,255,255)})

						tween(Toggle.toggle.val, {BackgroundColor3 = Color3.fromRGB(255,255,255), Position = UDim2.new(1,-23,0.5,0), BackgroundTransparency = 0.45})
					else
						Toggle.toggle.color.Enabled = false
						Toggle.toggle.UIStroke.color.Enabled = false

						Toggle.toggle.UIStroke.Color = Color3.fromRGB(97,97,97)

						tween(Toggle.toggle, {BackgroundTransparency = 1})

						tween(Toggle.toggle.val, {BackgroundColor3 = Color3.fromRGB(97,97,97), Position = UDim2.new(0,5,0.5,0), BackgroundTransparency = 0})
					end

					ToggleV.CurrentValue = bool
				end

				Toggle.Interact.MouseButton1Click:Connect(function()
					ToggleSettings.CurrentValue = not ToggleSettings.CurrentValue
					Set(ToggleSettings.CurrentValue)

					local Success, Response = pcall(function()
						ToggleSettings.Callback(ToggleSettings.CurrentValue)
					end)
					if not Success then
						TweenService:Create(Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
						TweenService:Create(Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
						TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
						Toggle.Title.Text = "Callback Error"
						print("InfernoX Interface Suite | "..ToggleSettings.Name.." Callback Error " ..tostring(Response))
						wait(0.5)
						Toggle.Title.Text = ToggleSettings.Name
						TweenService:Create(Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
						TweenService:Create(Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(32, 30, 38)}):Play()
						TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
					end
				end)

				Toggle["MouseEnter"]:Connect(function()
					tween(Toggle.UIStroke, {Color = Color3.fromRGB(87, 84, 104)})
				end)

				Toggle["MouseLeave"]:Connect(function()
					tween(Toggle.UIStroke, {Color = Color3.fromRGB(64,61,76)})
				end)

				if ToggleSettings.CurrentValue then
					Set(ToggleSettings.CurrentValue)
					local Success, Response = pcall(function()
						ToggleSettings.Callback(ToggleSettings.CurrentValue)
					end)
					if not Success then
						TweenService:Create(Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
						TweenService:Create(Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
						TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
						Toggle.Title.Text = "Callback Error"
						print("InfernoX Interface Suite | "..ToggleSettings.Name.." Callback Error " ..tostring(Response))
						wait(0.5)
						Toggle.Title.Text = ToggleSettings.Name
						TweenService:Create(Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
						TweenService:Create(Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(32, 30, 38)}):Play()
						TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
					end
				end

				function ToggleV:UpdateState(State)
					ToggleSettings.CurrentValue = State
					Set(ToggleSettings.CurrentValue)
				end

				function ToggleV:Set(NewToggleSettings)

					NewToggleSettings = Kwargify({
						Name = ToggleSettings.Name,
						Description = ToggleSettings.Description,
						CurrentValue = ToggleSettings.CurrentValue,
						Callback = ToggleSettings.Callback
					}, NewToggleSettings or {})

					ToggleV.Settings = NewToggleSettings
					ToggleSettings = NewToggleSettings

					Toggle.Name = ToggleSettings.Name .. " - Toggle"
					Toggle.Title.Text = ToggleSettings.Name
					if ToggleSettings.Description ~= nil and ToggleSettings.Description ~= "" and Toggle.Desc ~= nil then
						Toggle.Desc.Text = ToggleSettings.Description
					end

					Set(ToggleSettings.CurrentValue)

					ToggleV.CurrentValue = ToggleSettings.CurrentValue

					local Success, Response = pcall(function()
						ToggleSettings.Callback(ToggleSettings.CurrentValue)
					end)
					if not Success then
						TweenService:Create(Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
						TweenService:Create(Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
						TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
						Toggle.Title.Text = "Callback Error"
						print("InfernoX Interface Suite | "..ToggleSettings.Name.." Callback Error " ..tostring(Response))
						wait(0.5)
						Toggle.Title.Text = ToggleSettings.Name
						TweenService:Create(Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
						TweenService:Create(Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(32, 30, 38)}):Play()
						TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
					end
				end

				function ToggleV:Destroy()
					Toggle.Visible = false
					Toggle:Destroy()
				end

				InterfaceUI.ThemeRemote:GetPropertyChangedSignal("Value"):Connect(function()
					Toggle.toggle.color.Color = InfernoX.ThemeGradient
					Toggle.toggle.UIStroke.color.Color = InfernoX.ThemeGradient
				end)

				if Flag then
					InfernoX.Options[Flag] = ToggleV
				end

				return ToggleV

			end

			-- Bind
			function Section:CreateBind(BindSettings, Flag)
				TabPage.Position = UDim2.new(0,0,0,28)
				local BindV = { Class = "Keybind", IgnoreConfig = false, Settings = BindSettings, Active = false }

				BindSettings = Kwargify({
					Name = "Bind",
					Description = nil,
					CurrentBind = "Q",
					HoldToInteract = false, -- setting this makes the Bind in toggle mode
					Callback = function(Bind)
						-- The function that takes place when the Bind is pressed
						-- The variable (Bind) is a boolean for whether the Bind is being held or not (HoldToInteract needs to be true) or whether the Bind is currently active
					end,

					OnChangedCallback = function(Bind)
						-- The function that takes place when the binded key changes
						-- The variable (Bind) is a Enum.KeyCode for the new Binded Key
					end,
				}, BindSettings or {})

				local CheckingForKey = false

				local Bind
				if BindSettings.Description ~= nil and BindSettings.Description ~= "" then
					Bind = Elements.Template.BindDesc:Clone()
				else
					Bind = Elements.Template.Bind:Clone()
				end

				Bind.Visible = true
				Bind.Parent = TabPage

				Bind.Name = BindSettings.Name
				Bind.Title.Text = BindSettings.Name
				if BindSettings.Description ~= nil and BindSettings.Description ~= "" then
					Bind.Desc.Text = BindSettings.Description
				end

				Bind.Title.TextTransparency = 1
				if BindSettings.Description ~= nil and BindSettings.Description ~= "" then
					Bind.Desc.TextTransparency = 1
				end
				Bind.BindFrame.BackgroundTransparency = 1
				Bind.BindFrame.UIStroke.Transparency = 1
				Bind.BindFrame.BindBox.TextTransparency = 1

				TweenService:Create(Bind, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
				TweenService:Create(Bind.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
				if BindSettings.Description ~= nil and BindSettings.Description ~= "" then
					TweenService:Create(Bind.Desc, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
				end
				TweenService:Create(Bind.BindFrame, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.9}):Play()
				TweenService:Create(Bind.BindFrame.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 0.3}):Play()
				TweenService:Create(Bind.BindFrame.BindBox, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()


				Bind.BindFrame.BindBox.Text = BindSettings.CurrentBind
				Bind.BindFrame.BindBox.Size = UDim2.new(0, Bind.BindFrame.BindBox.TextBounds.X + 20, 0, 42)

				Bind.BindFrame.BindBox.Focused:Connect(function()
					CheckingForKey = true
					Bind.BindFrame.BindBox.Text = ""
				end)

				Bind.BindFrame.BindBox.FocusLost:Connect(function()
					CheckingForKey = false
					if Bind.BindFrame.BindBox.Text == (nil or "") then
						Bind.BindFrame.BindBox.Text = BindSettings.CurrentBind
					end
				end)

				Bind["MouseEnter"]:Connect(function()
					tween(Bind.UIStroke, {Color = Color3.fromRGB(87, 84, 104)})
				end)

				Bind["MouseLeave"]:Connect(function()
					tween(Bind.UIStroke, {Color = Color3.fromRGB(64,61,76)})
				end)
				UserInputService.InputBegan:Connect(function(input, processed)

					if CheckingForKey then
						if input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode ~= Window.Bind then
							local SplitMessage = string.split(tostring(input.KeyCode), ".")
							local NewKeyNoEnum = SplitMessage[3]
							Bind.BindFrame.BindBox.Text = tostring(NewKeyNoEnum)
							BindSettings.CurrentBind = tostring(NewKeyNoEnum)
							local Success, Response = pcall(function()
								BindSettings.OnChangedCallback(BindSettings.CurrentBind)
							end)
							if not Success then
								TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
								TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
								TweenService:Create(Bind.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
								Bind.Title.Text = "Callback Error"
								print("InfernoX Interface Suite | "..BindSettings.Name.." Callback Error " ..tostring(Response))
								wait(0.5)
								Bind.Title.Text = BindSettings.Name
								TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
								TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(32, 30, 38)}):Play()
								TweenService:Create(Bind.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
							end
							Bind.BindFrame.BindBox:ReleaseFocus()
						end
					elseif BindSettings.CurrentBind ~= nil and (input.KeyCode == Enum.KeyCode[BindSettings.CurrentBind] and not processed) then -- Test
						local Held = true
						local Connection
						Connection = input.Changed:Connect(function(prop)
							if prop == "UserInputState" then
								Connection:Disconnect()
								Held = false
							end
						end)

						if not BindSettings.HoldToInteract then
							BindV.Active = not BindV.Active
							local Success, Response = pcall(function()
								BindSettings.Callback(BindV.Active)
							end)
							if not Success then
								TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
								TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
								TweenService:Create(Bind.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
								Bind.Title.Text = "Callback Error"
								print("InfernoX Interface Suite | "..BindSettings.Name.." Callback Error " ..tostring(Response))
								wait(0.5)
								Bind.Title.Text = BindSettings.Name
								TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
								TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(32, 30, 38)}):Play()
								TweenService:Create(Bind.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
							end
						else
							wait(0.1)
							if Held then
								local Loop; Loop = RunService.Stepped:Connect(function()
									if not Held then
										local Success, Response = pcall(function()
											BindSettings.Callback(false)
										end)
										if not Success then
											TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
											TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
											TweenService:Create(Bind.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
											Bind.Title.Text = "Callback Error"
											print("InfernoX Interface Suite | "..BindSettings.Name.." Callback Error " ..tostring(Response))
											wait(0.5)
											Bind.Title.Text = BindSettings.Name
											TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
											TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(32, 30, 38)}):Play()
											TweenService:Create(Bind.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
										end 
										Loop:Disconnect()
									else
										local Success, Response = pcall(function()
											BindSettings.Callback(true)
										end)
										if not Success then
											TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
											TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
											TweenService:Create(Bind.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
											Bind.Title.Text = "Callback Error"
											print("InfernoX Interface Suite | "..BindSettings.Name.." Callback Error " ..tostring(Response))
											wait(0.5)
											Bind.Title.Text = BindSettings.Name
											TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
											TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(32, 30, 38)}):Play()
											TweenService:Create(Bind.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
										end
									end
								end)	
							end
						end
					end
				end)

				Bind.BindFrame.BindBox:GetPropertyChangedSignal("Text"):Connect(function()
					TweenService:Create(Bind.BindFrame, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, Bind.BindFrame.BindBox.TextBounds.X + 20, 0, 30)}):Play()
				end)

				function BindV:Set(NewBindSettings)

					NewBindSettings = Kwargify({
						Name = BindSettings.Name,
						Description = BindSettings.Description,
						CurrentBind =  BindSettings.CurrentBind,
						HoldToInteract = BindSettings.HoldToInteract,
						Callback = BindSettings.Callback
					}, NewBindSettings or {})

					BindV.Settings = NewBindSettings
					BindSettings = NewBindSettings

					Bind.Name = BindSettings.Name
					Bind.Title.Text = BindSettings.Name
					if BindSettings.Description ~= nil and BindSettings.Description ~= "" and Bind.Desc ~= nil then
						Bind.Desc.Text = BindSettings.Description
					end

					Bind.BindFrame.BindBox.Text = BindSettings.CurrentBind
					Bind.BindFrame.Size = UDim2.new(0, Bind.BindFrame.BindBox.TextBounds.X + 20, 0, 42)


					BindV.CurrentBind = BindSettings.CurrentBind
				end

				function BindV:Destroy()
					Bind.Visible = false
					Bind:Destroy()
				end

				if Flag then
					InfernoX.Options[Flag] = BindV
				end

				-- InfernoX.Flags[BindSettings.Flag] = BindSettings

				return BindV

			end

			-- Dynamic Input
			function Section:CreateInput(InputSettings, Flag)
				TabPage.Position = UDim2.new(0,0,0,28)
				local InputV = { IgnoreConfig = false, Class = "Input", Settings = InputSettings }

				InputSettings = Kwargify({
					Name = "Dynamic Input",
					Description = nil,
					CurrentValue = "",
					PlaceholderText = "Input Placeholder",
					RemoveTextAfterFocusLost = false,
					Numeric = false,
					Enter = false,
					MaxCharacters = nil,
					Callback = function(Text)

					end, -- 52
				}, InputSettings or {})

				InputV.CurrentValue = InputSettings.CurrentValue

				local descriptionbool
				if InputSettings.Description ~= nil and InputSettings.Description ~= "" then
					descriptionbool = true
				end

				local Input 
				if descriptionbool then
					Input = Elements.Template.InputDesc:Clone()
				else
					Input = Elements.Template.Input:Clone()
				end

				Input.Name = InputSettings.Name
				Input.Title.Text = InputSettings.Name
				if descriptionbool then Input.Desc.Text = InputSettings.Description end
				Input.Visible = true
				Input.Parent = TabPage

				Input.BackgroundTransparency = 1
				Input.UIStroke.Transparency = 1
				Input.Title.TextTransparency = 1
				if descriptionbool then Input.Desc.TextTransparency = 1 end
				Input.InputFrame.BackgroundTransparency = 1
				Input.InputFrame.UIStroke.Transparency = 1
				Input.InputFrame.InputBox.TextTransparency = 1

				TweenService:Create(Input, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
				TweenService:Create(Input.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
				TweenService:Create(Input.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()	
				if descriptionbool then TweenService:Create(Input.Desc, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play() end
				TweenService:Create(Input.InputFrame, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.9}):Play()
				TweenService:Create(Input.InputFrame.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 0.3}):Play()
				TweenService:Create(Input.InputFrame.InputBox, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()

				Input.InputFrame.InputBox.PlaceholderText = InputSettings.PlaceholderText
				Input.InputFrame.Size = UDim2.new(0, Input.InputFrame.InputBox.TextBounds.X + 52, 0, 30)

				Input.InputFrame.InputBox.FocusLost:Connect(function(bleh)

					if InputSettings.Enter then
						if bleh then
							local Success, Response = pcall(function()
								InputSettings.Callback(Input.InputFrame.InputBox.Text)
								InputV.CurrentValue = Input.InputFrame.InputBox.Text
							end)
							if not Success then
								TweenService:Create(Input, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
								TweenService:Create(Input, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
								TweenService:Create(Input.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
								Input.Title.Text = "Callback Error"
								print("InfernoX Interface Suite | "..InputSettings.Name.." Callback Error " ..tostring(Response))
								wait(0.5)
								Input.Title.Text = InputSettings.Name
								TweenService:Create(Input, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
								TweenService:Create(Input, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(32, 30, 38)}):Play()
								TweenService:Create(Input.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
							end
						end
					end

					if InputSettings.RemoveTextAfterFocusLost then
						Input.InputFrame.InputBox.Text = ""
					end

				end)

				if InputSettings.Numeric then
					Input.InputFrame.InputBox:GetPropertyChangedSignal("Text"):Connect(function()
						local text = Input.InputFrame.InputBox.Text
						if not tonumber(text) and text ~= "." then
							Input.InputFrame.InputBox.Text = text:match("[0-9.]*") or ""
						end
					end)
				end

				Input.InputFrame.InputBox:GetPropertyChangedSignal("Text"):Connect(function()
					if tonumber(InputSettings.MaxCharacters) then
						if (#Input.InputFrame.InputBox.Text - 1) == InputSettings.MaxCharacters then
							Input.InputFrame.InputBox.Text = Input.InputFrame.InputBox.Text:sub(1, InputSettings.MaxCharacters)
						end
					end
					TweenService:Create(Input.InputFrame, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, Input.InputFrame.InputBox.TextBounds.X + 52, 0, 30)}):Play()
					if not InputSettings.Enter then
						local Success, Response = pcall(function()
							InputSettings.Callback(Input.InputFrame.InputBox.Text)
						end)
						if not Success then
							TweenService:Create(Input, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
							TweenService:Create(Input, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
							TweenService:Create(Input.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
							Input.Title.Text = "Callback Error"
							print("InfernoX Interface Suite | "..InputSettings.Name.." Callback Error " ..tostring(Response))
							wait(0.5)
							Input.Title.Text = InputSettings.Name
							TweenService:Create(Input, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
							TweenService:Create(Input, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(32, 30, 38)}):Play()
							TweenService:Create(Input.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
						end
					end
					InputV.CurrentValue = Input.InputFrame.InputBox.Text				
				end)

				Input["MouseEnter"]:Connect(function()
					tween(Input.UIStroke, {Color = Color3.fromRGB(87, 84, 104)})
				end)

				Input["MouseLeave"]:Connect(function()
					tween(Input.UIStroke, {Color = Color3.fromRGB(64,61,76)})
				end)


				function InputV:Set(NewInputSettings)

					NewInputSettings = Kwargify(InputSettings, NewInputSettings or {})

					InputV.Settings = NewInputSettings
					InputSettings = NewInputSettings

					Input.Name = InputSettings.Name
					Input.Title.Text = InputSettings.Name
					if InputSettings.Description ~= nil and InputSettings.Description ~= "" and Input.Desc ~= nil then
						Input.Desc.Text = InputSettings.Description
					end

					Input.InputFrame.InputBox:CaptureFocus()
					Input.InputFrame.InputBox.Text = tostring(InputSettings.CurrentValue)
					Input.InputFrame.InputBox:ReleaseFocus()
					Input.InputFrame.Size = UDim2.new(0, Input.InputFrame.InputBox.TextBounds.X + 52, 0, 42)

					InputV.CurrentValue = InputSettings.CurrentValue
				end

				function InputV:Destroy()
					Input.Visible = false
					Input:Destroy()
				end

				if Flag then
					InfernoX.Options[Flag] = InputV
				end


				return InputV

			end

			-- Dropdown
			function Section:CreateDropdown(DropdownSettings, Flag)
				TabPage.Position = UDim2.new(0,0,0,28)
				local DropdownV = { IgnoreConfig = false, Class = "Dropdown", Settings = DropdownSettings}

				DropdownSettings = Kwargify({
					Name = "Dropdown",
					Description = nil,
					Options = {"Option 1", "Option 2"},
					CurrentOption = {"Option 1"},
					MultipleOptions = false,
					SpecialType = nil, -- currently onl player, might add more soon
					Callback = function(Options)
						-- The function that takes place when the selected option is changed
						-- The variable (Options) is a table of strings for the current selected options or a string if multioptions is false
					end,
				}, DropdownSettings or {})

				DropdownV.CurrentOption = DropdownSettings.CurrentOption

				local descriptionbool = false
				if DropdownSettings.Description ~= nil and DropdownSettings.Description ~= "" then
					descriptionbool = true
				end
				local closedsize
				local openedsize
				if descriptionbool then
					closedsize = 48
					openedsize = 170
				elseif not descriptionbool then
					closedsize = 38
					openedsize = 160
				end
				local opened = false

				local Dropdown
				if descriptionbool then Dropdown = Elements.Template.DropdownDesc:Clone() else Dropdown = Elements.Template.Dropdown:Clone() end

				Dropdown.Name = DropdownSettings.Name
				Dropdown.Title.Text = DropdownSettings.Name
				if descriptionbool then Dropdown.Desc.Text = DropdownSettings.Description end

				Dropdown.Parent = TabPage
				Dropdown.Visible = true

				local function Toggle()
					opened = not opened
					if opened then
						tween(Dropdown.icon, {Rotation = 180})
						tween(Dropdown, {Size = UDim2.new(1, -25, 0, openedsize)})
					else
						tween(Dropdown.icon, {Rotation = 0})
						tween(Dropdown, {Size = UDim2.new(1, -25, 0, closedsize)})
					end
				end

				local function SafeCallback(param, c2)
					local Success, Response = pcall(function()
						DropdownSettings.Callback(param)
					end)
					if not Success then
						TweenService:Create(Dropdown, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
						TweenService:Create(Dropdown, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
						TweenService:Create(Dropdown.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
						Dropdown.Title.Text = "Callback Error"
						print("InfernoX Interface Suite | "..DropdownSettings.Name.." Callback Error " ..tostring(Response))
						wait(0.5)
						Dropdown.Title.Text = DropdownSettings.Name
						TweenService:Create(Dropdown, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
						TweenService:Create(Dropdown, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(32, 30, 38)}):Play()
						TweenService:Create(Dropdown.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
					end
					if Success and c2 then
						c2()
					end
				end

				-- fixed by justhey
				Dropdown.Selected:GetPropertyChangedSignal("Text"):Connect(function()
					local text = Dropdown.Selected.Text:lower()
					for _, Item in ipairs(Dropdown.List:GetChildren()) do
						if Item:IsA("TextLabel") and Item.Name ~= "Template" then
							Item.Visible = text == "" or string.find(Item.Name:lower(), text, 1, true) ~= nil
						end
					end
				end)


				local function Clear()
					for _, option in ipairs(Dropdown.List:GetChildren()) do
						if option.ClassName == "TextLabel" and option.Name ~= "Template" then
							option:Destroy()
						end
					end
				end

				local function ActivateColorSingle(name)
					for _, Option in pairs(Dropdown.List:GetChildren()) do
						if Option.ClassName == "TextLabel" and Option.Name ~= "Template" then
							tween(Option, {BackgroundTransparency = 0.98})
						end
					end

					Toggle()
					tween(Dropdown.List[name], {BackgroundTransparency = 0.95, TextColor3 = Color3.fromRGB(240,240,240)})
				end

				local function Refresh()
					Clear()
					for i,v in pairs(DropdownSettings.Options) do
						local Option = Dropdown.List.Template:Clone()
						local optionhover = false
						Option.Text = v
						if v == "Template" then v = "Template (Name)" end
						Option.Name = v
						Option.Interact.MouseButton1Click:Connect(function()
							local bleh
							if DropdownSettings.MultipleOptions then
								if table.find(DropdownSettings.CurrentOption, v) then
									RemoveTable(DropdownSettings.CurrentOption, v)
									DropdownV.CurrentOption = DropdownSettings.CurrentOption
									if not optionhover then
										tween(Option, {TextColor3 = Color3.fromRGB(200,200,200)})
									end
									tween(Option, {BackgroundTransparency = 0.98})
								else
									table.insert(DropdownSettings.CurrentOption, v)
									DropdownV.CurrentOption = DropdownSettings.CurrentOption
									tween(Option, {TextColor3 = Color3.fromRGB(240,240,240), BackgroundTransparency = 0.95})
								end
								bleh = DropdownSettings.CurrentOption
							else
								DropdownSettings.CurrentOption = {v}
								bleh = v
								DropdownV.CurrentOption = bleh
								ActivateColorSingle(v)
							end

							SafeCallback(bleh, function()
								if DropdownSettings.MultipleOptions then
									if DropdownSettings.CurrentOption and type(DropdownSettings.CurrentOption) == "table" then
										if #DropdownSettings.CurrentOption == 1 then
											Dropdown.Selected.PlaceholderText = DropdownSettings.CurrentOption[1]
										elseif #DropdownSettings.CurrentOption == 0 then
											Dropdown.Selected.PlaceholderText = "None"
										else
											Dropdown.Selected.PlaceholderText = unpackt(DropdownSettings.CurrentOption)
										end
									else
										DropdownSettings.CurrentOption = {}
										Dropdown.Selected.PlaceholderText = "None"
									end
								end
								if not DropdownSettings.MultipleOptions then
									Dropdown.Selected.PlaceholderText = DropdownSettings.CurrentOption[1] or "None"
								end
								Dropdown.Selected.Text = ""
							end)
						end)
						Option.Visible = true
						Option.Parent = Dropdown.List
						Option.MouseEnter:Connect(function()
							optionhover = true
							if Option.BackgroundTransparency == 0.95 then
								return
							else
								tween(Option, {TextColor3 = Color3.fromRGB(240,240,240)})
							end
						end)
						Option.MouseLeave:Connect(function()
							optionhover = false
							if Option.BackgroundTransparency == 0.95 then
								return
							else
								tween(Option, {TextColor3 = Color3.fromRGB(200,200,200)})
							end
						end)	
					end
				end

				local function PlayerTableRefresh()
					for i,v in pairs(DropdownSettings.Options) do
						table.remove(DropdownSettings.Options, i)
					end

					for i,v in pairs(Players:GetChildren()) do
						table.insert(DropdownSettings.Options, v.Name)
					end
				end

				Dropdown.Interact.MouseButton1Click:Connect(function()
					Toggle()
				end)

				Dropdown["MouseEnter"]:Connect(function()
					tween(Dropdown.UIStroke, {Color = Color3.fromRGB(87, 84, 104)})
				end)

				Dropdown["MouseLeave"]:Connect(function()
					tween(Dropdown.UIStroke, {Color = Color3.fromRGB(64,61,76)})
				end)

				if DropdownSettings.SpecialType == "Player" then

					for i,v in pairs(DropdownSettings.Options) do
						table.remove(DropdownSettings.Options, i)
					end
					PlayerTableRefresh()
					DropdownSettings.CurrentOption = DropdownSettings.Options[1]

					Players.PlayerAdded:Connect(function() PlayerTableRefresh() end)
					Players.PlayerRemoving:Connect(function() PlayerTableRefresh() end)

				end

				Refresh()

				if DropdownSettings.CurrentOption then
					if type(DropdownSettings.CurrentOption) == "string" then
						DropdownSettings.CurrentOption = {DropdownSettings.CurrentOption}
					end
					if not DropdownSettings.MultipleOptions and type(DropdownSettings.CurrentOption) == "table" then
						DropdownSettings.CurrentOption = {DropdownSettings.CurrentOption[1]}
					end
				else
					DropdownSettings.CurrentOption = {}
				end

				local bleh, ind = nil,0
				for i,v in pairs(DropdownSettings.CurrentOption) do
					ind = ind + 1
				end
				if ind == 1 then bleh = DropdownSettings.CurrentOption[1] else bleh = DropdownSettings.CurrentOption end
				SafeCallback(bleh)
				if type(bleh) == "string" then 
					tween(Dropdown.List[bleh], {TextColor3 = Color3.fromRGB(240,240,240), BackgroundTransparency = 0.95})
				else
					for i,v in pairs(bleh) do
						tween(Dropdown.List[v], {TextColor3 = Color3.fromRGB(240,240,240), BackgroundTransparency = 0.95})
					end
				end

				if DropdownSettings.MultipleOptions then
					if DropdownSettings.CurrentOption and type(DropdownSettings.CurrentOption) == "table" then
						if #DropdownSettings.CurrentOption == 1 then
							Dropdown.Selected.PlaceholderText = DropdownSettings.CurrentOption[1]
						elseif #DropdownSettings.CurrentOption == 0 then
							Dropdown.Selected.PlaceholderText = "None"
						else
							Dropdown.Selected.PlaceholderText = unpackt(DropdownSettings.CurrentOption)
						end
					else
						DropdownSettings.CurrentOption = {}
						Dropdown.Selected.PlaceholderText = "None"
					end
					for _, name in pairs(DropdownSettings.CurrentOption) do
						tween(Dropdown.List[name], {TextColor3 = Color3.fromRGB(227,227,227), BackgroundTransparency = 0.95})
					end
				else
					Dropdown.Selected.PlaceholderText = DropdownSettings.CurrentOption[1] or "None"
				end
				Dropdown.Selected.Text = ""

				function DropdownV:Set(NewDropdownSettings)
					NewDropdownSettings = Kwargify(DropdownSettings, NewDropdownSettings or {})

					DropdownV.Settings = NewDropdownSettings
					DropdownSettings = NewDropdownSettings

					Dropdown.Name = DropdownSettings.Name
					Dropdown.Title.Text = DropdownSettings.Name
					if DropdownSettings.Description ~= nil and DropdownSettings.Description ~= "" and Dropdown.Desc ~= nil then
						Dropdown.Desc.Text = DropdownSettings.Description
					end

					if DropdownSettings.SpecialType == "Player" then

						for i,v in pairs(DropdownSettings.Options) do
							table.remove(DropdownSettings.Options, i)
						end
						PlayerTableRefresh()
						DropdownSettings.CurrentOption = DropdownSettings.Options[1]                    
						Players.PlayerAdded:Connect(function() PlayerTableRefresh() end)
						Players.PlayerRemoving:Connect(function() PlayerTableRefresh() end)

					end

					Refresh()

					if DropdownSettings.CurrentOption then
						if type(DropdownSettings.CurrentOption) == "string" then
							DropdownSettings.CurrentOption = {DropdownSettings.CurrentOption}
						end
						if not DropdownSettings.MultipleOptions and type(DropdownSettings.CurrentOption) == "table" then
							DropdownSettings.CurrentOption = {DropdownSettings.CurrentOption[1]}
						end
					else
						DropdownSettings.CurrentOption = {}
					end

					local bleh, ind = nil,0
					for i,v in pairs(DropdownSettings.CurrentOption) do
						ind = ind + 1
					end
					if ind == 1 then bleh = DropdownSettings.CurrentOption[1] else bleh = DropdownSettings.CurrentOption end
					SafeCallback(bleh)
					for _, Option in pairs(Dropdown.List:GetChildren()) do
						if Option.ClassName == "TextLabel" then
							tween(Option, {TextColor3 = Color3.fromRGB(200,200,200), BackgroundTransparency = 0.98})
						end
					end
					tween(Dropdown.List[bleh], {TextColor3 = Color3.fromRGB(240,240,240), BackgroundTransparency = 0.95})

					if DropdownSettings.MultipleOptions then
						if DropdownSettings.CurrentOption and type(DropdownSettings.CurrentOption) == "table" then
							if #DropdownSettings.CurrentOption == 1 then
								Dropdown.Selected.PlaceholderText = DropdownSettings.CurrentOption[1]
							elseif #DropdownSettings.CurrentOption == 0 then
								Dropdown.Selected.PlaceholderText = "None"
							else
								Dropdown.Selected.PlaceholderText = unpackt(DropdownSettings.CurrentOption)
							end
						else
							DropdownSettings.CurrentOption = {}
							Dropdown.Selected.PlaceholderText = "None"
						end
						for _, name in pairs(DropdownSettings.CurrentOption) do
							tween(Dropdown.List[name], {TextColor3 = Color3.fromRGB(227,227,227), BackgroundTransparency = 0.95})
						end
					else
						Dropdown.Selected.PlaceholderText = DropdownSettings.CurrentOption[1] or "None"
					end
					Dropdown.Selected.Text = ""

					-- InfernoX.Flags[DropdownSettings.Flag] = DropdownSettings

				end

				function DropdownV:Destroy()
					Dropdown.Visible = false
					Dropdown:Destroy()
				end

				if Flag then
					InfernoX.Options[Flag] = DropdownV
				end

				-- InfernoX.Flags[DropdownSettings.Flag] = DropdownSettings

				return DropdownV

			end

			-- Color Picker
			function Section:CreateColorPicker(ColorPickerSettings, Flag) -- by Rayfield/Throit
				TabPage.Position = UDim2.new(0,0,0,28)
				local ColorPickerV = {IgnoreClass = false, Class = "Colorpicker", Settings = ColorPickerSettings}

				ColorPickerSettings = Kwargify({
					Name = "Color Picker",
					Color = Color3.fromRGB(255,255,255),
					Callback = function(Value)
						-- The function that takes place every time the color picker is moved/changed
						-- The variable (Value) is a Color3fromRGB value based on which color is selected
					end
				}, ColorPickerSettings or {})

				local function Color3ToHex(color)
					return string.format("#%02X%02X%02X", math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255))
				end

				ColorPickerV.Color = Color3ToHex(ColorPickerSettings.Color)

				local closedsize = UDim2.new(0, 75, 0, 22)
				local openedsize = UDim2.new(0, 219, 0, 129)

				local ColorPicker = Elements.Template.ColorPicker:Clone()
				local Background = ColorPicker.CPBackground
				local Display = Background.Display
				local Main = Background.MainCP
				local Slider = ColorPicker.ColorSlider

				ColorPicker.Name = ColorPickerSettings.Name
				ColorPicker.Title.Text = ColorPickerSettings.Name
				ColorPicker.Visible = true
				ColorPicker.Parent = TabPage
				ColorPicker.Size = UDim2.new(1.042, -25,0, 38)
				Background.Size = closedsize
				Display.BackgroundTransparency = 0

				ColorPicker["MouseEnter"]:Connect(function()
					tween(ColorPicker.UIStroke, {Color = Color3.fromRGB(87, 84, 104)})
				end)
				ColorPicker["MouseLeave"]:Connect(function()
					tween(ColorPicker.UIStroke, {Color = Color3.fromRGB(64,61,76)})
				end)

				local function SafeCallback(param, c2)
					local Success, Response = pcall(function()
						ColorPickerSettings.Callback(param)
					end)
					if not Success then
						TweenService:Create(ColorPicker, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
						TweenService:Create(ColorPicker, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
						TweenService:Create(ColorPicker.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
						ColorPicker.Title.Text = "Callback Error"
						print("InfernoX Interface Suite | "..ColorPickerSettings.Name.." Callback Error " ..tostring(Response))
						wait(0.5)
						ColorPicker.Title.Text = ColorPickerSettings.Name
						TweenService:Create(ColorPicker, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
						TweenService:Create(ColorPicker, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(32, 30, 38)}):Play()
						TweenService:Create(ColorPicker.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
					end
					if Success and c2 then
						c2()
					end
				end

				local opened = false

				local mouse = game.Players.LocalPlayer:GetMouse()
				Main.Image = "http://www.roblox.com/asset/?id=11415645739"
				local mainDragging = false 
				local sliderDragging = false 
				ColorPicker.Interact.MouseButton1Down:Connect(function()
					if not opened then
						opened = true 
						tween(ColorPicker, {Size = UDim2.new( 1.042, -25,0, 165)}, nil, TweenInfo.new(0.6, Enum.EasingStyle.Exponential))
						tween(Background, {Size = openedsize})
						tween(Display, {BackgroundTransparency = 1})
					else
						opened = false
						tween(ColorPicker, {Size = UDim2.new(1.042, -25,0, 38)}, nil, TweenInfo.new(0.6, Enum.EasingStyle.Exponential))
						tween(Background, {Size = closedsize})
						tween(Display, {BackgroundTransparency = 0})
					end
				end)
				UserInputService.InputEnded:Connect(function(input, gameProcessed) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
						mainDragging = false
						sliderDragging = false
					end end)
				Main.MouseButton1Down:Connect(function()
					if opened then
						mainDragging = true 
					end
				end)
				Main.MainPoint.MouseButton1Down:Connect(function()
					if opened then
						mainDragging = true 
					end
				end)
				Slider.MouseButton1Down:Connect(function()
					sliderDragging = true 
				end)
				Slider.SliderPoint.MouseButton1Down:Connect(function()
					sliderDragging = true 
				end)
				local h,s,v = ColorPickerSettings.Color:ToHSV()
				local color = Color3.fromHSV(h,s,v) 
				local r,g,b = math.floor((h*255)+0.5),math.floor((s*255)+0.5),math.floor((v*255)+0.5)
				local hex = string.format("#%02X%02X%02X",color.R*0xFF,color.G*0xFF,color.B*0xFF)
				ColorPicker.HexInput.InputBox.Text = hex
				local function setDisplay(hp,sp,vp)
					--Main
					Main.MainPoint.Position = UDim2.new(s,-Main.MainPoint.AbsoluteSize.X/2,1-v,-Main.MainPoint.AbsoluteSize.Y/2)
					Main.MainPoint.ImageColor3 = Color3.fromHSV(hp,sp,vp)
					Background.BackgroundColor3 = Color3.fromHSV(hp,1,1)
					Display.BackgroundColor3 = Color3.fromHSV(hp,sp,vp)
					--Slider 
					local x = hp * Slider.AbsoluteSize.X
					Slider.SliderPoint.Position = UDim2.new(0,x-Slider.SliderPoint.AbsoluteSize.X/2,0.5,0)
					Slider.SliderPoint.ImageColor3 = Color3.fromHSV(hp,1,1)
					local color = Color3.fromHSV(hp,sp,vp) 
					local r,g,b = math.floor((color.R*255)+0.5),math.floor((color.G*255)+0.5),math.floor((color.B*255)+0.5)
					ColorPicker.RInput.InputBox.Text = tostring(r)
					ColorPicker.GInput.InputBox.Text = tostring(g)
					ColorPicker.BInput.InputBox.Text = tostring(b)
					hex = string.format("#%02X%02X%02X",color.R*0xFF,color.G*0xFF,color.B*0xFF)
					ColorPicker.HexInput.InputBox.Text = hex
				end
				setDisplay(h,s,v)
				ColorPicker.HexInput.InputBox.FocusLost:Connect(function()
					if not pcall(function()
							local r, g, b = string.match(ColorPicker.HexInput.InputBox.Text, "^#?(%w%w)(%w%w)(%w%w)$")
							local rgbColor = Color3.fromRGB(tonumber(r, 16),tonumber(g, 16), tonumber(b, 16))
							h,s,v = rgbColor:ToHSV()
							hex = ColorPicker.HexInput.InputBox.Text
							setDisplay()
							ColorPickerSettings.Color = rgbColor
						end) 
					then 
						ColorPicker.HexInput.InputBox.Text = hex 
					end
					local r,g,b = math.floor((h*255)+0.5),math.floor((s*255)+0.5),math.floor((v*255)+0.5)
					ColorPickerSettings.Color = Color3.fromRGB(r,g,b)
					SafeCallback( Color3.fromRGB(r,g,b))
				end)
				--RGB
				local function rgbBoxes(box,toChange)
					local value = tonumber(box.Text) 
					local color = Color3.fromHSV(h,s,v) 
					local oldR,oldG,oldB = math.floor((color.R*255)+0.5),math.floor((color.G*255)+0.5),math.floor((color.B*255)+0.5)
					local save 
					if toChange == "R" then save = oldR;oldR = value elseif toChange == "G" then save = oldG;oldG = value else save = oldB;oldB = value end
					if value then 
						value = math.clamp(value,0,255)
						h,s,v = Color3.fromRGB(oldR,oldG,oldB):ToHSV()
						setDisplay()
					else 
						box.Text = tostring(save)
					end
					local r,g,b = math.floor((color.R*255)+0.5),math.floor((color.G*255)+0.5),math.floor((color.B*255)+0.5)
					ColorPickerSettings.Color = Color3.fromRGB(r,g,b)
				end
				ColorPicker.RInput.InputBox.FocusLost:connect(function()
					rgbBoxes(ColorPicker.RInput.InputBox,"R")
					SafeCallback(Color3.fromRGB(r,g,b))
				end)
				ColorPicker.GInput.InputBox.FocusLost:connect(function()
					rgbBoxes(ColorPicker.GInput.InputBox,"G")
					SafeCallback(Color3.fromRGB(r,g,b))
				end)
				ColorPicker.BInput.InputBox.FocusLost:connect(function()
					rgbBoxes(ColorPicker.BInput.InputBox,"B")
					SafeCallback(Color3.fromRGB(r,g,b))
				end)
				RunService.RenderStepped:connect(function()
					if mainDragging then 
						local localX = math.clamp(mouse.X-Main.AbsolutePosition.X,0,Main.AbsoluteSize.X)
						local localY = math.clamp(mouse.Y-Main.AbsolutePosition.Y,0,Main.AbsoluteSize.Y)
						Main.MainPoint.Position = UDim2.new(0,localX-Main.MainPoint.AbsoluteSize.X/2,0,localY-Main.MainPoint.AbsoluteSize.Y/2)
						s = localX / Main.AbsoluteSize.X
						v = 1 - (localY / Main.AbsoluteSize.Y)
						Display.BackgroundColor3 = Color3.fromHSV(h,s,v)
						Main.MainPoint.ImageColor3 = Color3.fromHSV(h,s,v)
						Background.BackgroundColor3 = Color3.fromHSV(h,1,1)
						local color = Color3.fromHSV(h,s,v) 
						local r,g,b = math.floor((color.R*255)+0.5),math.floor((color.G*255)+0.5),math.floor((color.B*255)+0.5)
						ColorPicker.RInput.InputBox.Text = tostring(r)
						ColorPicker.GInput.InputBox.Text = tostring(g)
						ColorPicker.BInput.InputBox.Text = tostring(b)
						ColorPicker.HexInput.InputBox.Text = string.format("#%02X%02X%02X",color.R*0xFF,color.G*0xFF,color.B*0xFF)
						SafeCallback(Color3.fromRGB(r,g,b))
						ColorPickerSettings.Color = Color3.fromRGB(r,g,b)
						ColorPickerV.Color = ColorPickerSettings.Color
					end
					if sliderDragging then 
						local localX = math.clamp(mouse.X-Slider.AbsolutePosition.X,0,Slider.AbsoluteSize.X)
						h = localX / Slider.AbsoluteSize.X
						Display.BackgroundColor3 = Color3.fromHSV(h,s,v)
						Slider.SliderPoint.Position = UDim2.new(0,localX-Slider.SliderPoint.AbsoluteSize.X/2,0.5,0)
						Slider.SliderPoint.ImageColor3 = Color3.fromHSV(h,1,1)
						Background.BackgroundColor3 = Color3.fromHSV(h,1,1)
						Main.MainPoint.ImageColor3 = Color3.fromHSV(h,s,v)
						local color = Color3.fromHSV(h,s,v) 
						local r,g,b = math.floor((color.R*255)+0.5),math.floor((color.G*255)+0.5),math.floor((color.B*255)+0.5)
						ColorPicker.RInput.InputBox.Text = tostring(r)
						ColorPicker.GInput.InputBox.Text = tostring(g)
						ColorPicker.BInput.InputBox.Text = tostring(b)
						ColorPicker.HexInput.InputBox.Text = string.format("#%02X%02X%02X",color.R*0xFF,color.G*0xFF,color.B*0xFF)
						SafeCallback(Color3.fromRGB(r,g,b))
						ColorPickerSettings.Color = Color3.fromRGB(r,g,b)
						ColorPickerV.Color = ColorPickerSettings.Color
					end
				end)

				function ColorPickerV:Set(NewColorPickerSettings)

					NewColorPickerSettings = Kwargify(ColorPickerSettings, NewColorPickerSettings or {})

					ColorPickerV.Settings = NewColorPickerSettings
					ColorPickerSettings = NewColorPickerSettings

					ColorPicker.Name = ColorPickerSettings.Name
					ColorPicker.Title.Text = ColorPickerSettings.Name
					ColorPicker.Visible = true

					local h,s,v = ColorPickerSettings.Color:ToHSV()
					local color = Color3.fromHSV(h,s,v) 
					local r,g,b = math.floor((color.R*255)+0.5),math.floor((color.G*255)+0.5),math.floor((color.B*255)+0.5)
					local hex = string.format("#%02X%02X%02X",color.R*0xFF,color.G*0xFF,color.B*0xFF)
					ColorPicker.HexInput.InputBox.Text = hex
					setDisplay(h,s,v)
					SafeCallback(Color3.fromRGB(r,g,b))

					ColorPickerV.Color = ColorPickerSettings.Color
				end

				function ColorPickerV:Destroy()
					ColorPicker:Destroy()
				end

				if Flag then
					InfernoX.Options[Flag] = ColorPickerV
				end

				SafeCallback(ColorPickerSettings.Color)

				return ColorPickerV
			end

			return Section

		end

		-- Divider
		function Tab:CreateDivider()
			local b = Elements.Template.Divider:Clone()
			b.Parent = TabPage
			b.Line.BackgroundTransparency = 1
			tween(b.Line, {BackgroundTransparency = 0})
		end

		-- Button
		function Tab:CreateButton(ButtonSettings)

			ButtonSettings = Kwargify({
				Name = "Button",
				Description = nil,
				Callback = function()

				end,
			}, ButtonSettings or {})

			local ButtonV = {
				Hover = false,
				Settings = ButtonSettings
			}


			local Button
			if ButtonSettings.Description == nil and ButtonSettings.Description ~= "" then
				Button = Elements.Template.Button:Clone()
			else
				Button = Elements.Template.ButtonDesc:Clone()
			end
			Button.Name = ButtonSettings.Name
			Button.Title.Text = ButtonSettings.Name
			if ButtonSettings.Description ~= nil and ButtonSettings.Description ~= "" then
				Button.Desc.Text = ButtonSettings.Description
			end
			Button.Visible = true
			Button.Parent = TabPage

			Button.UIStroke.Transparency = 1
			Button.Title.TextTransparency = 1
			if ButtonSettings.Description ~= nil and ButtonSettings.Description ~= "" then
				Button.Desc.TextTransparency = 1
			end

			TweenService:Create(Button, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
			TweenService:Create(Button.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
			TweenService:Create(Button.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()	
			if ButtonSettings.Description ~= nil and ButtonSettings.Description ~= "" then
				TweenService:Create(Button.Desc, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()	
			end

			Button.Interact["MouseButton1Click"]:Connect(function()
				local Success,Response = pcall(ButtonSettings.Callback)

				if not Success then
					TweenService:Create(Button, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
					TweenService:Create(Button, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
					TweenService:Create(Button.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
					Button.Title.Text = "Callback Error"
					print("InfernoX Interface Suite | "..ButtonSettings.Name.." Callback Error " ..tostring(Response))
					wait(0.5)
					Button.Title.Text = ButtonSettings.Name
					TweenService:Create(Button, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
					TweenService:Create(Button, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(32, 30, 38)}):Play()
					TweenService:Create(Button.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
				else
					tween(Button.UIStroke, {Color = Color3.fromRGB(136, 131, 163)})
					wait(0.2)
					if ButtonV.Hover then
						tween(Button.UIStroke, {Color = Color3.fromRGB(87, 84, 104)})
					else
						tween(Button.UIStroke, {Color = Color3.fromRGB(64,61,76)})
					end
				end
			end)

			Button["MouseEnter"]:Connect(function()
				ButtonV.Hover = true
				tween(Button.UIStroke, {Color = Color3.fromRGB(87, 84, 104)})
			end)

			Button["MouseLeave"]:Connect(function()
				ButtonV.Hover = false
				tween(Button.UIStroke, {Color = Color3.fromRGB(64,61,76)})
			end)

			function ButtonV:Set(ButtonSettings2)
				ButtonSettings2 = Kwargify({
					Name = ButtonSettings.Name,
					Description = ButtonSettings.Description,
					Callback = ButtonSettings.Callback
				}, ButtonSettings2 or {})

				ButtonSettings = ButtonSettings2
				ButtonV.Settings = ButtonSettings2

				Button.Name = ButtonSettings.Name
				Button.Title.Text = ButtonSettings.Name
				if ButtonSettings.Description ~= nil and ButtonSettings.Description ~= "" and Button.Desc ~= nil then
					Button.Desc.Text = ButtonSettings.Description
				end
			end

			function ButtonV:Destroy()
				Button.Visible = false
				Button:Destroy()
			end

			return ButtonV
		end

		-- Label
		function Tab:CreateLabel(LabelSettings)

			local LabelV = {}

			LabelSettings = Kwargify({
				Text = "Label",
				Style = 1
			}, LabelSettings or {}) 

			LabelV.Settings = LabelSettings

			local Label
			if LabelSettings.Style == 1 then
				Label = Elements.Template.Label:Clone()
			elseif LabelSettings.Style == 2 then
				Label = Elements.Template.Info:Clone()
			elseif LabelSettings.Style == 3 then
				Label = Elements.Template.Warn:Clone()
			end

			Label.Text.Text = LabelSettings.Text
			Label.Visible = true
			Label.Parent = TabPage

			Label.BackgroundTransparency = 1
			Label.UIStroke.Transparency = 1
			Label.Text.TextTransparency = 1

			if LabelSettings.Style ~= 1 then
				TweenService:Create(Label, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.8}):Play()
			else
				TweenService:Create(Label, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
			end
			TweenService:Create(Label.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
			TweenService:Create(Label.Text, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()	

			function LabelV:Set(NewLabel)
				LabelSettings.Text = NewLabel
				LabelV.Settings = LabelSettings
				Label.Text.Text = NewLabel
			end

			function LabelV:Destroy()
				Label.Visible = false
				Label:Destroy()
			end

			return LabelV
		end

		-- Paragraph
		function Tab:CreateParagraph(ParagraphSettings)

			ParagraphSettings = Kwargify({
				Title = "Paragraph",
				Text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus venenatis lacus sed tempus eleifend. Mauris interdum bibendum felis, in tempor augue egestas vel. Praesent tristique consectetur ex, eu pretium sem placerat non. Vestibulum a nisi sit amet augue facilisis consectetur sit amet et nunc. Integer fermentum ornare cursus. Pellentesque sed ultricies metus, ut egestas metus. Vivamus auctor erat ac sapien vulputate, nec ultricies sem tempor. Quisque leo lorem, faucibus nec pulvinar nec, congue eu velit. Duis sodales massa efficitur imperdiet ultrices. Donec eros ipsum, ornare pharetra purus aliquam, tincidunt elementum nisi. Ut mi tortor, feugiat eget nunc vitae, facilisis interdum dui. Vivamus ullamcorper nunc dui, a dapibus nisi pretium ac. Integer eleifend placerat nibh, maximus malesuada tellus. Cras in justo in ligula scelerisque suscipit vel vitae quam."
			}, ParagraphSettings or {})

			local ParagraphV = {
				Settings = ParagraphSettings
			}

			local Paragraph = Elements.Template.Paragraph:Clone()
			Paragraph.Title.Text = ParagraphSettings.Title
			Paragraph.Text.Text = ParagraphSettings.Text
			Paragraph.Visible = true
			Paragraph.Parent = TabPage

			Paragraph.BackgroundTransparency = 1
			Paragraph.UIStroke.Transparency = 1
			Paragraph.Title.TextTransparency = 1
			Paragraph.Text.TextTransparency = 1

			TweenService:Create(Paragraph, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
			TweenService:Create(Paragraph.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
			TweenService:Create(Paragraph.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()	
			TweenService:Create(Paragraph.Text, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()	

			function ParagraphV:Update()
				Paragraph.Text.Size = UDim2.new(Paragraph.Text.Size.X.Scale, Paragraph.Text.Size.X.Offset, 0, math.huge)
				Paragraph.Text.Size = UDim2.new(Paragraph.Text.Size.X.Scale, Paragraph.Text.Size.X.Offset, 0, Paragraph.Text.TextBounds.Y)
				tween(Paragraph, {Size = UDim2.new(Paragraph.Size.X.Scale, Paragraph.Size.X.Offset, 0, Paragraph.Text.TextBounds.Y + 40)})
			end

			function ParagraphV:Set(NewParagraphSettings)

				NewParagraphSettings = Kwargify({
					Title = ParagraphSettings.Title,
					Text = ParagraphSettings.Text
				}, NewParagraphSettings or {})

				ParagraphV.Settings = NewParagraphSettings

				Paragraph.Title.Text = NewParagraphSettings.Title
				Paragraph.Text.Text = NewParagraphSettings.Text

				ParagraphV:Update()

			end

			function ParagraphV:Destroy()
				Paragraph.Visible = false
				Paragraph:Destroy()
			end

			ParagraphV:Update()

			return ParagraphV
		end

		-- Slider
		function Tab:CreateSlider(SliderSettings, Flag)
			local SliderV = { IgnoreConfig = false, Class = "Slider", Settings = SliderSettings }

			SliderSettings = Kwargify({
				Name = "Slider",
				Range = {0, 200},
				Increment = 1,
				CurrentValue = 100,
				Callback = function(Value)

				end,
			}, SliderSettings or {})

			local SLDragging = false
			local Slider = Elements.Template.Slider:Clone()
			Slider.Name = SliderSettings.Name .. " - Slider"
			Slider.Title.Text = SliderSettings.Name
			Slider.Visible = true
			Slider.Parent = TabPage

			Slider.BackgroundTransparency = 1
			Slider.UIStroke.Transparency = 1
			Slider.Title.TextTransparency = 1

			TweenService:Create(Slider, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
			TweenService:Create(Slider.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
			TweenService:Create(Slider.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()	

			Slider.Main.Progress.Size =	UDim2.new(0, Slider.Main.AbsoluteSize.X * ((SliderSettings.CurrentValue + SliderSettings.Range[1]) / (SliderSettings.Range[2] - SliderSettings.Range[1])) > 5 and Slider.Main.AbsoluteSize.X * (SliderSettings.CurrentValue / (SliderSettings.Range[2] - SliderSettings.Range[1])) or 5, 1, 0)

			Slider.Value.Text = tostring(SliderSettings.CurrentValue)
			SliderV.CurrentValue = Slider.Value.Text

			SliderSettings.Callback(SliderSettings.CurrentValue)

			Slider["MouseEnter"]:Connect(function()
				tween(Slider.UIStroke, {Color = Color3.fromRGB(87, 84, 104)})
			end)

			Slider["MouseLeave"]:Connect(function()
				tween(Slider.UIStroke, {Color = Color3.fromRGB(64,61,76)})
			end)

			Slider.Interact.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then 
					SLDragging = true 
				end 
			end)

			Slider.Interact.InputEnded:Connect(function(Input) 
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then 
					SLDragging = false 
				end 
			end)

			Slider.Interact.MouseButton1Down:Connect(function()
				local Current = Slider.Main.Progress.AbsolutePosition.X + Slider.Main.Progress.AbsoluteSize.X
				local Start = Current
				local Location
				local Loop; Loop = RunService.Stepped:Connect(function()
					if SLDragging then
						Location = UserInputService:GetMouseLocation().X
						Current = Current + 0.025 * (Location - Start)

						if Location < Slider.Main.AbsolutePosition.X then
							Location = Slider.Main.AbsolutePosition.X
						elseif Location > Slider.Main.AbsolutePosition.X + Slider.Main.AbsoluteSize.X then
							Location = Slider.Main.AbsolutePosition.X + Slider.Main.AbsoluteSize.X
						end

						if Current < Slider.Main.AbsolutePosition.X + 5 then
							Current = Slider.Main.AbsolutePosition.X + 5
						elseif Current > Slider.Main.AbsolutePosition.X + Slider.Main.AbsoluteSize.X then
							Current = Slider.Main.AbsolutePosition.X + Slider.Main.AbsoluteSize.X
						end

						if Current <= Location and (Location - Start) < 0 then
							Start = Location
						elseif Current >= Location and (Location - Start) > 0 then
							Start = Location
						end
						Slider.Main.Progress.Size = UDim2.new(0, Location - Slider.Main.AbsolutePosition.X, 1, 0)
						local NewValue = SliderSettings.Range[1] + (Location - Slider.Main.AbsolutePosition.X) / Slider.Main.AbsoluteSize.X * (SliderSettings.Range[2] - SliderSettings.Range[1])

						NewValue = math.floor(NewValue / SliderSettings.Increment + 0.5) * (SliderSettings.Increment * 10000000) / 10000000

						Slider.Value.Text = tostring(NewValue)

						if SliderSettings.CurrentValue ~= NewValue then
							local Success, Response = pcall(function()
								SliderSettings.Callback(NewValue)
							end)
							if not Success then
								TweenService:Create(Slider, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
								TweenService:Create(Slider, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
								TweenService:Create(Slider.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
								Slider.Title.Text = "Callback Error"
								print("InfernoX Interface Suite | "..SliderSettings.Name.." Callback Error " ..tostring(Response))
								wait(0.5)
								Slider.Title.Text = SliderSettings.Name
								TweenService:Create(Slider, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
								TweenService:Create(Slider, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(32, 30, 38)}):Play()
								TweenService:Create(Slider.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
							end

							SliderSettings.CurrentValue = NewValue
							SliderV.CurrentValue = SliderSettings.CurrentValue
							-- InfernoX.Flags[SliderSettings.Flag] = SliderSettings
						end
					else
						TweenService:Create(Slider.Main.Progress, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.In, 0, false), {Size = UDim2.new(0, Location - Slider.Main.AbsolutePosition.X > 5 and Location - Slider.Main.AbsolutePosition.X or 5, 1, 0)}):Play()
						Loop:Disconnect()
					end
				end)
			end)

			local function Set(NewVal, bleh)

				NewVal = NewVal or SliderSettings.CurrentValue

				TweenService:Create(Slider.Main.Progress, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.InOut), {Size = UDim2.new(0, Slider.Main.AbsoluteSize.X * ((NewVal + SliderSettings.Range[1]) / (SliderSettings.Range[2] - SliderSettings.Range[1])) > 5 and Slider.Main.AbsoluteSize.X * (NewVal / (SliderSettings.Range[2] - SliderSettings.Range[1])) or 5, 1, 0)}):Play()
				if not bleh then Slider.Value.Text = tostring(NewVal) end
				local Success, Response = pcall(function()
					SliderSettings.Callback(NewVal)
				end)
				if not Success then
					TweenService:Create(Slider, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
					TweenService:Create(Slider, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
					TweenService:Create(Slider.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
					Slider.Title.Text = "Callback Error"
					print("InfernoX Interface Suite | "..SliderSettings.Name.." Callback Error " ..tostring(Response))
					wait(0.5)
					Slider.Title.Text = SliderSettings.Name
					TweenService:Create(Slider, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
					TweenService:Create(Slider, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(30, 33, 40)}):Play()
					TweenService:Create(Slider.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
				end

				SliderSettings.CurrentValue = NewVal
				SliderV.CurrentValue = SliderSettings.CurrentValue
				-- InfernoX.Flags[SliderSettings.Flag] = SliderSettings

			end

			function SliderV:UpdateValue(Value)
				Set(tonumber(Value))
			end 

			Slider.Value:GetPropertyChangedSignal("Text"):Connect(function()
				local text = Slider.Value.Text
				if not tonumber(text) and text ~= "." then
					Slider.Value.Text = text:match("[0-9.]*") or ""
				end
				if SliderSettings.Range[2] < (tonumber(Slider.Value.Text) or 0) then Slider.Value.Text = SliderSettings.Range[2] end
				Slider.Value.Size = UDim2.fromOffset(Slider.Value.TextBounds.X, 23)
				Set(tonumber(Slider.Value.Text), true)
			end)

			function SliderV:Set(NewSliderSettings)
				NewSliderSettings = Kwargify({
					Name = SliderSettings.Name,
					Range = SliderSettings.Range,
					Increment = SliderSettings.Increment,
					CurrentValue = SliderSettings.CurrentValue,
					Callback = SliderSettings.Callback
				}, NewSliderSettings or {})

				SliderSettings = NewSliderSettings
				SliderV.Settings = NewSliderSettings

				Slider.Name = SliderSettings.Name .. " - Slider"
				Slider.Title.Text = SliderSettings.Name

				Set()

				-- InfernoX.Flags[SliderSettings.Flag] = SliderSettings
			end

			function SliderV:Destroy()
				Slider.Visible = false
				Slider:Destroy()
			end

			if Flag then
				InfernoX.Options[Flag] = SliderV
			end

			InterfaceUI.ThemeRemote:GetPropertyChangedSignal("Value"):Connect(function()
				Slider.Main.color.Color = InfernoX.ThemeGradient
				Slider.Main.UIStroke.color.Color = InfernoX.ThemeGradient
			end)

			return SliderV

		end

		-- Toggle
		function Tab:CreateToggle(ToggleSettings, Flag)    
			local ToggleV = { IgnoreConfig = false, Class = "Toggle" }

			ToggleSettings = Kwargify({
				Name = "Toggle",
				Description = nil,
				CurrentValue = false,
				Callback = function(Value)
				end,
			}, ToggleSettings or {})


			local Toggle

			if ToggleSettings.Description ~= nil and ToggleSettings.Description ~= "" then
				Toggle = Elements.Template.ToggleDesc:Clone()
			else
				Toggle = Elements.Template.Toggle:Clone()
			end

			Toggle.Visible = true
			Toggle.Parent = TabPage

			Toggle.Name = ToggleSettings.Name .. " - Toggle"
			Toggle.Title.Text = ToggleSettings.Name
			if ToggleSettings.Description ~= nil and ToggleSettings.Description ~= "" then
				Toggle.Desc.Text = ToggleSettings.Description
			end

			Toggle.UIStroke.Transparency = 1
			Toggle.Title.TextTransparency = 1
			if ToggleSettings.Description ~= nil and ToggleSettings.Description ~= "" then
				Toggle.Desc.TextTransparency = 1
			end

			TweenService:Create(Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
			if ToggleSettings.Description ~= nil and ToggleSettings.Description ~= "" then
				TweenService:Create(Toggle.Desc, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
			end
			TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
			TweenService:Create(Toggle.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()	

			local function Set(bool)
				if bool then
					Toggle.toggle.color.Enabled = true
					tween(Toggle.toggle, {BackgroundTransparency = 0})

					Toggle.toggle.UIStroke.color.Enabled = true
					tween(Toggle.toggle.UIStroke, {Color = Color3.new(255,255,255)})

					tween(Toggle.toggle.val, {BackgroundColor3 = Color3.fromRGB(255,255,255), Position = UDim2.new(1,-23,0.5,0), BackgroundTransparency = 0.45})
				else
					Toggle.toggle.color.Enabled = false
					Toggle.toggle.UIStroke.color.Enabled = false

					Toggle.toggle.UIStroke.Color = Color3.fromRGB(97,97,97)

					tween(Toggle.toggle, {BackgroundTransparency = 1})

					tween(Toggle.toggle.val, {BackgroundColor3 = Color3.fromRGB(97,97,97), Position = UDim2.new(0,5,0.5,0), BackgroundTransparency = 0})
				end

				ToggleV.CurrentValue = bool
			end

			Toggle.Interact.MouseButton1Click:Connect(function()
				ToggleSettings.CurrentValue = not ToggleSettings.CurrentValue
				Set(ToggleSettings.CurrentValue)

				local Success, Response = pcall(function()
					ToggleSettings.Callback(ToggleSettings.CurrentValue)
				end)
				if not Success then
					TweenService:Create(Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
					TweenService:Create(Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
					TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
					Toggle.Title.Text = "Callback Error"
					print("InfernoX Interface Suite | "..ToggleSettings.Name.." Callback Error " ..tostring(Response))
					wait(0.5)
					Toggle.Title.Text = ToggleSettings.Name
					TweenService:Create(Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
					TweenService:Create(Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(32, 30, 38)}):Play()
					TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
				end
			end)

			Toggle["MouseEnter"]:Connect(function()
				tween(Toggle.UIStroke, {Color = Color3.fromRGB(87, 84, 104)})
			end)

			Toggle["MouseLeave"]:Connect(function()
				tween(Toggle.UIStroke, {Color = Color3.fromRGB(64,61,76)})
			end)

			if ToggleSettings.CurrentValue then
				Set(ToggleSettings.CurrentValue)
				local Success, Response = pcall(function()
					ToggleSettings.Callback(ToggleSettings.CurrentValue)
				end)
				if not Success then
					TweenService:Create(Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
					TweenService:Create(Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
					TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
					Toggle.Title.Text = "Callback Error"
					print("InfernoX Interface Suite | "..ToggleSettings.Name.." Callback Error " ..tostring(Response))
					wait(0.5)
					Toggle.Title.Text = ToggleSettings.Name
					TweenService:Create(Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
					TweenService:Create(Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(32, 30, 38)}):Play()
					TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
				end
			end

			function ToggleV:UpdateState(State)
				ToggleSettings.CurrentValue = State
				Set(ToggleSettings.CurrentValue)
			end

			function ToggleV:Set(NewToggleSettings)

				NewToggleSettings = Kwargify({
					Name = ToggleSettings.Name,
					Description = ToggleSettings.Description,
					CurrentValue = ToggleSettings.CurrentValue,
					Callback = ToggleSettings.Callback
				}, NewToggleSettings or {})

				ToggleV.Settings = NewToggleSettings
				ToggleSettings = NewToggleSettings

				Toggle.Name = ToggleSettings.Name .. " - Toggle"
				Toggle.Title.Text = ToggleSettings.Name
				if ToggleSettings.Description ~= nil and ToggleSettings.Description ~= "" and Toggle.Desc ~= nil then
					Toggle.Desc.Text = ToggleSettings.Description
				end

				Set(ToggleSettings.CurrentValue)

				ToggleV.CurrentValue = ToggleSettings.CurrentValue

				local Success, Response = pcall(function()
					ToggleSettings.Callback(ToggleSettings.CurrentValue)
				end)
				if not Success then
					TweenService:Create(Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
					TweenService:Create(Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
					TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
					Toggle.Title.Text = "Callback Error"
					print("InfernoX Interface Suite | "..ToggleSettings.Name.." Callback Error " ..tostring(Response))
					wait(0.5)
					Toggle.Title.Text = ToggleSettings.Name
					TweenService:Create(Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
					TweenService:Create(Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(32, 30, 38)}):Play()
					TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
				end
			end

			function ToggleV:Destroy()
				Toggle.Visible = false
				Toggle:Destroy()
			end

			InterfaceUI.ThemeRemote:GetPropertyChangedSignal("Value"):Connect(function()
				Toggle.toggle.color.Color = InfernoX.ThemeGradient
				Toggle.toggle.UIStroke.color.Color = InfernoX.ThemeGradient
			end)

			if Flag then
				InfernoX.Options[Flag] = ToggleV
			end

			return ToggleV

		end

		-- Bind
		function Tab:CreateBind(BindSettings, Flag)
			local BindV = { Class = "Keybind", IgnoreConfig = false, Settings = BindSettings, Active = false }

			BindSettings = Kwargify({
				Name = "Bind",
				Description = nil,
				CurrentBind = "Q",
				HoldToInteract = false, -- setting this makes the Bind in toggle mode
				Callback = function(Bind)
					-- The function that takes place when the Bind is pressed
					-- The variable (Bind) is a boolean for whether the Bind is being held or not (HoldToInteract needs to be true) or whether the Bind is currently active
				end,

				OnChangedCallback = function(Bind)
					-- The function that takes place when the binded key changes
					-- The variable (Bind) is a Enum.KeyCode for the new Binded Key
				end,
			}, BindSettings or {})

			local CheckingForKey = false

			local Bind
			if BindSettings.Description ~= nil and BindSettings.Description ~= "" then
				Bind = Elements.Template.BindDesc:Clone()
			else
				Bind = Elements.Template.Bind:Clone()
			end

			Bind.Visible = true
			Bind.Parent = TabPage

			Bind.Name = BindSettings.Name
			Bind.Title.Text = BindSettings.Name
			if BindSettings.Description ~= nil and BindSettings.Description ~= "" then
				Bind.Desc.Text = BindSettings.Description
			end

			Bind.Title.TextTransparency = 1
			if BindSettings.Description ~= nil and BindSettings.Description ~= "" then
				Bind.Desc.TextTransparency = 1
			end
			Bind.BindFrame.BackgroundTransparency = 1
			Bind.BindFrame.UIStroke.Transparency = 1
			Bind.BindFrame.BindBox.TextTransparency = 1

			TweenService:Create(Bind, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
			TweenService:Create(Bind.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
			if BindSettings.Description ~= nil and BindSettings.Description ~= "" then
				TweenService:Create(Bind.Desc, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
			end
			TweenService:Create(Bind.BindFrame, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.9}):Play()
			TweenService:Create(Bind.BindFrame.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 0.3}):Play()
			TweenService:Create(Bind.BindFrame.BindBox, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()


			Bind.BindFrame.BindBox.Text = BindSettings.CurrentBind
			Bind.BindFrame.BindBox.Size = UDim2.new(0, Bind.BindFrame.BindBox.TextBounds.X + 20, 0, 42)

			Bind.BindFrame.BindBox.Focused:Connect(function()
				CheckingForKey = true
				Bind.BindFrame.BindBox.Text = ""
			end)

			Bind.BindFrame.BindBox.FocusLost:Connect(function()
				CheckingForKey = false
				if Bind.BindFrame.BindBox.Text == (nil or "") then
					Bind.BindFrame.BindBox.Text = BindSettings.CurrentBind
				end
			end)

			Bind["MouseEnter"]:Connect(function()
				tween(Bind.UIStroke, {Color = Color3.fromRGB(87, 84, 104)})
			end)

			Bind["MouseLeave"]:Connect(function()
				tween(Bind.UIStroke, {Color = Color3.fromRGB(64,61,76)})
			end)
			UserInputService.InputBegan:Connect(function(input, processed)

				if CheckingForKey then
					if input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode ~= Window.Bind then
						local SplitMessage = string.split(tostring(input.KeyCode), ".")
						local NewKeyNoEnum = SplitMessage[3]
						Bind.BindFrame.BindBox.Text = tostring(NewKeyNoEnum)
						BindSettings.CurrentBind = tostring(NewKeyNoEnum)
						local Success, Response = pcall(function()
							BindSettings.OnChangedCallback(BindSettings.CurrentBind)
						end)
						if not Success then
							TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
							TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
							TweenService:Create(Bind.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
							Bind.Title.Text = "Callback Error"
							print("InfernoX Interface Suite | "..BindSettings.Name.." Callback Error " ..tostring(Response))
							wait(0.5)
							Bind.Title.Text = BindSettings.Name
							TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
							TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(32, 30, 38)}):Play()
							TweenService:Create(Bind.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
						end
						Bind.BindFrame.BindBox:ReleaseFocus()
					end
				elseif BindSettings.CurrentBind ~= nil and (input.KeyCode == Enum.KeyCode[BindSettings.CurrentBind] and not processed) then -- Test
					local Held = true
					local Connection
					Connection = input.Changed:Connect(function(prop)
						if prop == "UserInputState" then
							Connection:Disconnect()
							Held = false
						end
					end)

					if not BindSettings.HoldToInteract then
						BindV.Active = not BindV.Active
						local Success, Response = pcall(function()
							BindSettings.Callback(BindV.Active)
						end)
						if not Success then
							TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
							TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
							TweenService:Create(Bind.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
							Bind.Title.Text = "Callback Error"
							print("InfernoX Interface Suite | "..BindSettings.Name.." Callback Error " ..tostring(Response))
							wait(0.5)
							Bind.Title.Text = BindSettings.Name
							TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
							TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(32, 30, 38)}):Play()
							TweenService:Create(Bind.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
						end
					else
						wait(0.1)
						if Held then
							local Loop; Loop = RunService.Stepped:Connect(function()
								if not Held then
									local Success, Response = pcall(function()
										BindSettings.Callback(false)
									end)
									if not Success then
										TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
										TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
										TweenService:Create(Bind.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
										Bind.Title.Text = "Callback Error"
										print("InfernoX Interface Suite | "..BindSettings.Name.." Callback Error " ..tostring(Response))
										wait(0.5)
										Bind.Title.Text = BindSettings.Name
										TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
										TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(32, 30, 38)}):Play()
										TweenService:Create(Bind.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
									end 
									Loop:Disconnect()
								else
									local Success, Response = pcall(function()
										BindSettings.Callback(true)
									end)
									if not Success then
										TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
										TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
										TweenService:Create(Bind.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
										Bind.Title.Text = "Callback Error"
										print("InfernoX Interface Suite | "..BindSettings.Name.." Callback Error " ..tostring(Response))
										wait(0.5)
										Bind.Title.Text = BindSettings.Name
										TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
										TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(32, 30, 38)}):Play()
										TweenService:Create(Bind.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
									end
								end
							end)	
						end
					end
				end
			end)

			Bind.BindFrame.BindBox:GetPropertyChangedSignal("Text"):Connect(function()
				TweenService:Create(Bind.BindFrame, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, Bind.BindFrame.BindBox.TextBounds.X + 20, 0, 30)}):Play()
			end)

			function BindV:Set(NewBindSettings)

				NewBindSettings = Kwargify({
					Name = BindSettings.Name,
					Description = BindSettings.Description,
					CurrentBind =  BindSettings.CurrentBind,
					HoldToInteract = BindSettings.HoldToInteract,
					Callback = BindSettings.Callback
				}, NewBindSettings or {})

				BindV.Settings = NewBindSettings
				BindSettings = NewBindSettings

				Bind.Name = BindSettings.Name
				Bind.Title.Text = BindSettings.Name
				if BindSettings.Description ~= nil and BindSettings.Description ~= "" and Bind.Desc ~= nil then
					Bind.Desc.Text = BindSettings.Description
				end

				Bind.BindFrame.BindBox.Text = BindSettings.CurrentBind
				Bind.BindFrame.Size = UDim2.new(0, Bind.BindFrame.BindBox.TextBounds.X + 20, 0, 42)


				BindV.CurrentBind = BindSettings.CurrentBind
			end

			function BindV:Destroy()
				Bind.Visible = false
				Bind:Destroy()
			end

			if Flag then
				InfernoX.Options[Flag] = BindV
			end

			-- InfernoX.Flags[BindSettings.Flag] = BindSettings

			return BindV

		end

		function Tab:CreateKeybind(BindSettings)

			BindSettings = Kwargify({
				Name = "Bind",
				Description = nil,
				CurrentBind = "Q",
				HoldToInteract = false, -- setting this makes the Bind in toggle mode
				Callback = function(Bind)
					-- The function that takes place when the Bind is pressed
					-- The variable (Bind) is a boolean for whether the Bind is being held or not (HoldToInteract needs to be true) or whether the Bind is currently active
				end
			}, BindSettings or {})

			local BindV = { Settings = BindSettings, Active = false }
			local CheckingForKey = false

			local Bind
			if BindSettings.Description ~= nil and BindSettings.Description ~= "" then
				Bind = Elements.Template.BindDesc:Clone()
			else
				Bind = Elements.Template.Bind:Clone()
			end

			Bind.Visible = true
			Bind.Parent = TabPage

			Bind.Name = BindSettings.Name
			Bind.Title.Text = BindSettings.Name
			if BindSettings.Description ~= nil and BindSettings.Description ~= "" then
				Bind.Desc.Text = BindSettings.Description
			end

			Bind.Title.TextTransparency = 1
			if BindSettings.Description ~= nil and BindSettings.Description ~= "" then
				Bind.Desc.TextTransparency = 1
			end
			Bind.BindFrame.BackgroundTransparency = 1
			Bind.BindFrame.UIStroke.Transparency = 1
			Bind.BindFrame.BindBox.TextTransparency = 1

			TweenService:Create(Bind, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
			TweenService:Create(Bind.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
			if BindSettings.Description ~= nil and BindSettings.Description ~= "" then
				TweenService:Create(Bind.Desc, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
			end
			TweenService:Create(Bind.BindFrame, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.9}):Play()
			TweenService:Create(Bind.BindFrame.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 0.3}):Play()
			TweenService:Create(Bind.BindFrame.BindBox, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()


			Bind.BindFrame.BindBox.Text = BindSettings.CurrentBind
			Bind.BindFrame.BindBox.Size = UDim2.new(0, Bind.BindFrame.BindBox.TextBounds.X + 16, 0, 42)

			Bind.BindFrame.BindBox.Focused:Connect(function()
				CheckingForKey = true
				Bind.BindFrame.BindBox.Text = ""
			end)

			Bind.BindFrame.BindBox.FocusLost:Connect(function()
				CheckingForKey = false
				if Bind.BindFrame.BindBox.Text == (nil or "") then
					Bind.BindFrame.BindBox.Text = BindSettings.CurrentBind
				end
			end)

			Bind["MouseEnter"]:Connect(function()
				tween(Bind.UIStroke, {Color = Color3.fromRGB(87, 84, 104)})
			end)

			Bind["MouseLeave"]:Connect(function()
				tween(Bind.UIStroke, {Color = Color3.fromRGB(64,61,76)})
			end)
			UserInputService.InputBegan:Connect(function(input, processed)

				if CheckingForKey then
					if input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode ~= Enum.KeyCode.K then
						local SplitMessage = string.split(tostring(input.KeyCode), ".")
						local NewKeyNoEnum = SplitMessage[3]
						Bind.BindFrame.BindBox.Text = tostring(NewKeyNoEnum)
						BindSettings.CurrentBind = tostring(NewKeyNoEnum)
						Bind.BindFrame.BindBox:ReleaseFocus()
					end
				elseif BindSettings.CurrentBind ~= nil and (input.KeyCode == Enum.KeyCode[BindSettings.CurrentBind] and not processed) then -- Test
					local Held = true
					local Connection
					Connection = input.Changed:Connect(function(prop)
						if prop == "UserInputState" then
							Connection:Disconnect()
							Held = false
						end
					end)

					if not BindSettings.HoldToInteract then
						BindV.Active = not BindV.Active
						local Success, Response = pcall(function()
							BindSettings.Callback(BindV.Active)
						end)
						if not Success then
							TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
							TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
							TweenService:Create(Bind.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
							Bind.Title.Text = "Callback Error"
							print("InfernoX Interface Suite | "..BindSettings.Name.." Callback Error " ..tostring(Response))
							wait(0.5)
							Bind.Title.Text = BindSettings.Name
							TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
							TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(32, 30, 38)}):Play()
							TweenService:Create(Bind.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
						end
					else
						wait(0.1)
						if Held then
							local Loop; Loop = RunService.Stepped:Connect(function()
								if not Held then
									local Success, Response = pcall(function()
										BindSettings.Callback(false)
									end)
									if not Success then
										TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
										TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
										TweenService:Create(Bind.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
										Bind.Title.Text = "Callback Error"
										print("InfernoX Interface Suite | "..BindSettings.Name.." Callback Error " ..tostring(Response))
										wait(0.5)
										Bind.Title.Text = BindSettings.Name
										TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
										TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(32, 30, 38)}):Play()
										TweenService:Create(Bind.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
									end 
									Loop:Disconnect()
								else
									local Success, Response = pcall(function()
										BindSettings.Callback(true)
									end)
									if not Success then
										TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
										TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
										TweenService:Create(Bind.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
										Bind.Title.Text = "Callback Error"
										print("InfernoX Interface Suite | "..BindSettings.Name.." Callback Error " ..tostring(Response))
										wait(0.5)
										Bind.Title.Text = BindSettings.Name
										TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
										TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(32, 30, 38)}):Play()
										TweenService:Create(Bind.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
									end
								end
							end)	
						end
					end
				end
			end)

			Bind.BindFrame.BindBox:GetPropertyChangedSignal("Text"):Connect(function()
				TweenService:Create(Bind.BindFrame, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, Bind.BindFrame.BindBox.TextBounds.X + 16, 0, 30)}):Play()
			end)

			function BindV:Set(NewBindSettings)

				NewBindSettings = Kwargify({
					Name = BindSettings.Name,
					Description = BindSettings.Description,
					CurrentBind =  BindSettings.CurrentBind,
					HoldToInteract = BindSettings.HoldToInteract,
					Callback = BindSettings.Callback
				}, NewBindSettings or {})

				BindV.Settings = NewBindSettings
				BindSettings = NewBindSettings

				Bind.Name = BindSettings.Name
				Bind.Title.Text = BindSettings.Name
				if BindSettings.Description ~= nil and BindSettings.Description ~= "" and Bind.Desc ~= nil then
					Bind.Desc.Text = BindSettings.Description
				end

				Bind.BindFrame.BindBox.Text = BindSettings.CurrentBind
				Bind.BindFrame.BindBox.Size = UDim2.new(0, Bind.BindFrame.BindBox.TextBounds.X + 16, 0, 42)

				-- InfernoX.Flags[BindSettings.Flag] = BindSettings

			end

			function BindV:Destroy()
				Bind.Visible = false
				Bind:Destroy()
			end

			-- InfernoX.Flags[BindSettings.Flag] = BindSettings

			return BindV

		end

		-- Dynamic Input
		function Tab:CreateInput(InputSettings, Flag)
			local InputV = { IgnoreConfig = false, Class = "Input", Settings = InputSettings }

			InputSettings = Kwargify({
				Name = "Dynamic Input",
				Description = nil,
				CurrentValue = "",
				PlaceholderText = "Input Placeholder",
				RemoveTextAfterFocusLost = false,
				Numeric = false,
				Enter = false,
				MaxCharacters = nil,
				Callback = function(Text)

				end, -- 52
			}, InputSettings or {})

			InputV.CurrentValue = InputSettings.CurrentValue

			local descriptionbool
			if InputSettings.Description ~= nil and InputSettings.Description ~= "" then
				descriptionbool = true
			end

			local Input 
			if descriptionbool then
				Input = Elements.Template.InputDesc:Clone()
			else
				Input = Elements.Template.Input:Clone()
			end

			Input.Name = InputSettings.Name
			Input.Title.Text = InputSettings.Name
			if descriptionbool then Input.Desc.Text = InputSettings.Description end
			Input.Visible = true
			Input.Parent = TabPage

			Input.BackgroundTransparency = 1
			Input.UIStroke.Transparency = 1
			Input.Title.TextTransparency = 1
			if descriptionbool then Input.Desc.TextTransparency = 1 end
			Input.InputFrame.BackgroundTransparency = 1
			Input.InputFrame.UIStroke.Transparency = 1
			Input.InputFrame.InputBox.TextTransparency = 1

			TweenService:Create(Input, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
			TweenService:Create(Input.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
			TweenService:Create(Input.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()	
			if descriptionbool then TweenService:Create(Input.Desc, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play() end
			TweenService:Create(Input.InputFrame, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.9}):Play()
			TweenService:Create(Input.InputFrame.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 0.3}):Play()
			TweenService:Create(Input.InputFrame.InputBox, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()

			Input.InputFrame.InputBox.PlaceholderText = InputSettings.PlaceholderText
			Input.InputFrame.Size = UDim2.new(0, Input.InputFrame.InputBox.TextBounds.X + 52, 0, 30)

			Input.InputFrame.InputBox.FocusLost:Connect(function(bleh)

				if InputSettings.Enter then
					if bleh then
						local Success, Response = pcall(function()
							InputSettings.Callback(Input.InputFrame.InputBox.Text)
							InputV.CurrentValue = Input.InputFrame.InputBox.Text
						end)
						if not Success then
							TweenService:Create(Input, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
							TweenService:Create(Input, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
							TweenService:Create(Input.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
							Input.Title.Text = "Callback Error"
							print("InfernoX Interface Suite | "..InputSettings.Name.." Callback Error " ..tostring(Response))
							wait(0.5)
							Input.Title.Text = InputSettings.Name
							TweenService:Create(Input, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
							TweenService:Create(Input, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(32, 30, 38)}):Play()
							TweenService:Create(Input.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
						end
					end
				end

				if InputSettings.RemoveTextAfterFocusLost then
					Input.InputFrame.InputBox.Text = ""
				end

			end)

			if InputSettings.Numeric then
				Input.InputFrame.InputBox:GetPropertyChangedSignal("Text"):Connect(function()
					local text = Input.InputFrame.InputBox.Text
					if not tonumber(text) and text ~= "." then
						Input.InputFrame.InputBox.Text = text:match("[0-9.]*") or ""
					end
				end)
			end

			Input.InputFrame.InputBox:GetPropertyChangedSignal("Text"):Connect(function()
				if tonumber(InputSettings.MaxCharacters) then
					if (#Input.InputFrame.InputBox.Text - 1) == InputSettings.MaxCharacters then
						Input.InputFrame.InputBox.Text = Input.InputFrame.InputBox.Text:sub(1, InputSettings.MaxCharacters)
					end
				end
				TweenService:Create(Input.InputFrame, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, Input.InputFrame.InputBox.TextBounds.X + 52, 0, 30)}):Play()
				if not InputSettings.Enter then
					local Success, Response = pcall(function()
						InputSettings.Callback(Input.InputFrame.InputBox.Text)
					end)
					if not Success then
						TweenService:Create(Input, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
						TweenService:Create(Input, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
						TweenService:Create(Input.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
						Input.Title.Text = "Callback Error"
						print("InfernoX Interface Suite | "..InputSettings.Name.." Callback Error " ..tostring(Response))
						wait(0.5)
						Input.Title.Text = InputSettings.Name
						TweenService:Create(Input, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
						TweenService:Create(Input, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(32, 30, 38)}):Play()
						TweenService:Create(Input.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
					end
				end
				InputV.CurrentValue = Input.InputFrame.InputBox.Text				
			end)

			Input["MouseEnter"]:Connect(function()
				tween(Input.UIStroke, {Color = Color3.fromRGB(87, 84, 104)})
			end)

			Input["MouseLeave"]:Connect(function()
				tween(Input.UIStroke, {Color = Color3.fromRGB(64,61,76)})
			end)


			function InputV:Set(NewInputSettings)

				NewInputSettings = Kwargify(InputSettings, NewInputSettings or {})

				InputV.Settings = NewInputSettings
				InputSettings = NewInputSettings

				Input.Name = InputSettings.Name
				Input.Title.Text = InputSettings.Name
				if InputSettings.Description ~= nil and InputSettings.Description ~= "" and Input.Desc ~= nil then
					Input.Desc.Text = InputSettings.Description
				end

				Input.InputFrame.InputBox:CaptureFocus()
				Input.InputFrame.InputBox.Text = tostring(InputSettings.CurrentValue)
				Input.InputFrame.InputBox:ReleaseFocus()
				Input.InputFrame.Size = UDim2.new(0, Input.InputFrame.InputBox.TextBounds.X + 52, 0, 42)

				InputV.CurrentValue = InputSettings.CurrentValue
			end

			function InputV:Destroy()
				Input.Visible = false
				Input:Destroy()
			end

			if Flag then
				InfernoX.Options[Flag] = InputV
			end


			return InputV

		end

		-- Dropdown
		function Tab:CreateDropdown(DropdownSettings, Flag)
			local DropdownV = { IgnoreConfig = false, Class = "Dropdown", Settings = DropdownSettings}

			DropdownSettings = Kwargify({
				Name = "Dropdown",
				Description = nil,
				Options = {"Option 1", "Option 2"},
				CurrentOption = {"Option 1"},
				MultipleOptions = false,
				SpecialType = nil, -- currently onl player, might add more soon
				Callback = function(Options)
					-- The function that takes place when the selected option is changed
					-- The variable (Options) is a table of strings for the current selected options or a string if multioptions is false
				end,
			}, DropdownSettings or {})

			DropdownV.CurrentOption = DropdownSettings.CurrentOption

			local descriptionbool = false
			if DropdownSettings.Description ~= nil and DropdownSettings.Description ~= "" then
				descriptionbool = true
			end
			local closedsize
			local openedsize
			if descriptionbool then
				closedsize = 48
				openedsize = 170
			elseif not descriptionbool then
				closedsize = 38
				openedsize = 160
			end
			local opened = false

			local Dropdown
			if descriptionbool then Dropdown = Elements.Template.DropdownDesc:Clone() else Dropdown = Elements.Template.Dropdown:Clone() end

			Dropdown.Name = DropdownSettings.Name
			Dropdown.Title.Text = DropdownSettings.Name
			if descriptionbool then Dropdown.Desc.Text = DropdownSettings.Description end

			Dropdown.Parent = TabPage
			Dropdown.Visible = true

			local function Toggle()
				opened = not opened
				if opened then
					tween(Dropdown.icon, {Rotation = 180})
					tween(Dropdown, {Size = UDim2.new(1, -25, 0, openedsize)})
				else
					tween(Dropdown.icon, {Rotation = 0})
					tween(Dropdown, {Size = UDim2.new(1, -25, 0, closedsize)})
				end
			end

			local function SafeCallback(param, c2)
				local Success, Response = pcall(function()
					DropdownSettings.Callback(param)
				end)
				if not Success then
					TweenService:Create(Dropdown, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
					TweenService:Create(Dropdown, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
					TweenService:Create(Dropdown.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
					Dropdown.Title.Text = "Callback Error"
					print("InfernoX Interface Suite | "..DropdownSettings.Name.." Callback Error " ..tostring(Response))
					wait(0.5)
					Dropdown.Title.Text = DropdownSettings.Name
					TweenService:Create(Dropdown, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
					TweenService:Create(Dropdown, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(32, 30, 38)}):Play()
					TweenService:Create(Dropdown.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
				end
				if Success and c2 then
					c2()
				end
			end

			-- fixed by justhey
			Dropdown.Selected:GetPropertyChangedSignal("Text"):Connect(function()
				local text = Dropdown.Selected.Text:lower()
				for _, Item in ipairs(Dropdown.List:GetChildren()) do
					if Item:IsA("TextLabel") and Item.Name ~= "Template" then
						Item.Visible = text == "" or string.find(Item.Name:lower(), text, 1, true) ~= nil
					end
				end
			end)


			local function Clear()
				for _, option in ipairs(Dropdown.List:GetChildren()) do
					if option.ClassName == "TextLabel" and option.Name ~= "Template" then
						option:Destroy()
					end
				end
			end

			local function ActivateColorSingle(name)
				for _, Option in pairs(Dropdown.List:GetChildren()) do
					if Option.ClassName == "TextLabel" and Option.Name ~= "Template" then
						tween(Option, {BackgroundTransparency = 0.98})
					end
				end

				Toggle()
				tween(Dropdown.List[name], {BackgroundTransparency = 0.95, TextColor3 = Color3.fromRGB(240,240,240)})
			end

			local function Refresh()
				Clear()
				for i,v in pairs(DropdownSettings.Options) do
					local Option = Dropdown.List.Template:Clone()
					local optionhover = false
					Option.Text = v
					if v == "Template" then v = "Template (Name)" end
					Option.Name = v
					Option.Interact.MouseButton1Click:Connect(function()
						local bleh
						if DropdownSettings.MultipleOptions then
							if table.find(DropdownSettings.CurrentOption, v) then
								RemoveTable(DropdownSettings.CurrentOption, v)
								DropdownV.CurrentOption = DropdownSettings.CurrentOption
								if not optionhover then
									tween(Option, {TextColor3 = Color3.fromRGB(200,200,200)})
								end
								tween(Option, {BackgroundTransparency = 0.98})
							else
								table.insert(DropdownSettings.CurrentOption, v)
								DropdownV.CurrentOption = DropdownSettings.CurrentOption
								tween(Option, {TextColor3 = Color3.fromRGB(240,240,240), BackgroundTransparency = 0.95})
							end
							bleh = DropdownSettings.CurrentOption
						else
							DropdownSettings.CurrentOption = {v}
							bleh = v
							DropdownV.CurrentOption = bleh
							ActivateColorSingle(v)
						end

						SafeCallback(bleh, function()
							if DropdownSettings.MultipleOptions then
								if DropdownSettings.CurrentOption and type(DropdownSettings.CurrentOption) == "table" then
									if #DropdownSettings.CurrentOption == 1 then
										Dropdown.Selected.PlaceholderText = DropdownSettings.CurrentOption[1]
									elseif #DropdownSettings.CurrentOption == 0 then
										Dropdown.Selected.PlaceholderText = "None"
									else
										Dropdown.Selected.PlaceholderText = unpackt(DropdownSettings.CurrentOption)
									end
								else
									DropdownSettings.CurrentOption = {}
									Dropdown.Selected.PlaceholderText = "None"
								end
							end
							if not DropdownSettings.MultipleOptions then
								Dropdown.Selected.PlaceholderText = DropdownSettings.CurrentOption[1] or "None"
							end
							Dropdown.Selected.Text = ""
						end)
					end)
					Option.Visible = true
					Option.Parent = Dropdown.List
					Option.MouseEnter:Connect(function()
						optionhover = true
						if Option.BackgroundTransparency == 0.95 then
							return
						else
							tween(Option, {TextColor3 = Color3.fromRGB(240,240,240)})
						end
					end)
					Option.MouseLeave:Connect(function()
						optionhover = false
						if Option.BackgroundTransparency == 0.95 then
							return
						else
							tween(Option, {TextColor3 = Color3.fromRGB(200,200,200)})
						end
					end)	
				end
			end

			local function PlayerTableRefresh()
				for i,v in pairs(DropdownSettings.Options) do
					table.remove(DropdownSettings.Options, i)
				end

				for i,v in pairs(Players:GetChildren()) do
					table.insert(DropdownSettings.Options, v.Name)
				end
			end

			Dropdown.Interact.MouseButton1Click:Connect(function()
				Toggle()
			end)

			Dropdown["MouseEnter"]:Connect(function()
				tween(Dropdown.UIStroke, {Color = Color3.fromRGB(87, 84, 104)})
			end)

			Dropdown["MouseLeave"]:Connect(function()
				tween(Dropdown.UIStroke, {Color = Color3.fromRGB(64,61,76)})
			end)

			if DropdownSettings.SpecialType == "Player" then

				for i,v in pairs(DropdownSettings.Options) do
					table.remove(DropdownSettings.Options, i)
				end
				PlayerTableRefresh()
				DropdownSettings.CurrentOption = DropdownSettings.Options[1]

				Players.PlayerAdded:Connect(function() PlayerTableRefresh() end)
				Players.PlayerRemoving:Connect(function() PlayerTableRefresh() end)

			end

			Refresh()

			if DropdownSettings.CurrentOption then
				if type(DropdownSettings.CurrentOption) == "string" then
					DropdownSettings.CurrentOption = {DropdownSettings.CurrentOption}
				end
				if not DropdownSettings.MultipleOptions and type(DropdownSettings.CurrentOption) == "table" then
					DropdownSettings.CurrentOption = {DropdownSettings.CurrentOption[1]}
				end
			else
				DropdownSettings.CurrentOption = {}
			end

			local bleh, ind = nil,0
			for i,v in pairs(DropdownSettings.CurrentOption) do
				ind = ind + 1
			end
			if ind == 1 then bleh = DropdownSettings.CurrentOption[1] else bleh = DropdownSettings.CurrentOption end
			SafeCallback(bleh)
			if type(bleh) == "string" then 
				tween(Dropdown.List[bleh], {TextColor3 = Color3.fromRGB(240,240,240), BackgroundTransparency = 0.95})
			else
				for i,v in pairs(bleh) do
					tween(Dropdown.List[v], {TextColor3 = Color3.fromRGB(240,240,240), BackgroundTransparency = 0.95})
				end
			end

			if DropdownSettings.MultipleOptions then
				if DropdownSettings.CurrentOption and type(DropdownSettings.CurrentOption) == "table" then
					if #DropdownSettings.CurrentOption == 1 then
						Dropdown.Selected.PlaceholderText = DropdownSettings.CurrentOption[1]
					elseif #DropdownSettings.CurrentOption == 0 then
						Dropdown.Selected.PlaceholderText = "None"
					else
						Dropdown.Selected.PlaceholderText = unpackt(DropdownSettings.CurrentOption)
					end
				else
					DropdownSettings.CurrentOption = {}
					Dropdown.Selected.PlaceholderText = "None"
				end
				for _, name in pairs(DropdownSettings.CurrentOption) do
					tween(Dropdown.List[name], {TextColor3 = Color3.fromRGB(227,227,227), BackgroundTransparency = 0.95})
				end
			else
				Dropdown.Selected.PlaceholderText = DropdownSettings.CurrentOption[1] or "None"
			end
			Dropdown.Selected.Text = ""

			function DropdownV:Set(NewDropdownSettings)
				NewDropdownSettings = Kwargify(DropdownSettings, NewDropdownSettings or {})

				DropdownV.Settings = NewDropdownSettings
				DropdownSettings = NewDropdownSettings

				Dropdown.Name = DropdownSettings.Name
				Dropdown.Title.Text = DropdownSettings.Name
				if DropdownSettings.Description ~= nil and DropdownSettings.Description ~= "" and Dropdown.Desc ~= nil then
					Dropdown.Desc.Text = DropdownSettings.Description
				end

				if DropdownSettings.SpecialType == "Player" then

					for i,v in pairs(DropdownSettings.Options) do
						table.remove(DropdownSettings.Options, i)
					end
					PlayerTableRefresh()
					DropdownSettings.CurrentOption = DropdownSettings.Options[1]                    
					Players.PlayerAdded:Connect(function() PlayerTableRefresh() end)
					Players.PlayerRemoving:Connect(function() PlayerTableRefresh() end)

				end

				Refresh()

				if DropdownSettings.CurrentOption then
					if type(DropdownSettings.CurrentOption) == "string" then
						DropdownSettings.CurrentOption = {DropdownSettings.CurrentOption}
					end
					if not DropdownSettings.MultipleOptions and type(DropdownSettings.CurrentOption) == "table" then
						DropdownSettings.CurrentOption = {DropdownSettings.CurrentOption[1]}
					end
				else
					DropdownSettings.CurrentOption = {}
				end

				local bleh, ind = nil,0
				for i,v in pairs(DropdownSettings.CurrentOption) do
					ind = ind + 1
				end
				if ind == 1 then bleh = DropdownSettings.CurrentOption[1] else bleh = DropdownSettings.CurrentOption end
				SafeCallback(bleh)
				for _, Option in pairs(Dropdown.List:GetChildren()) do
					if Option.ClassName == "TextLabel" then
						tween(Option, {TextColor3 = Color3.fromRGB(200,200,200), BackgroundTransparency = 0.98})
					end
				end
				tween(Dropdown.List[bleh], {TextColor3 = Color3.fromRGB(240,240,240), BackgroundTransparency = 0.95})

				if DropdownSettings.MultipleOptions then
					if DropdownSettings.CurrentOption and type(DropdownSettings.CurrentOption) == "table" then
						if #DropdownSettings.CurrentOption == 1 then
							Dropdown.Selected.PlaceholderText = DropdownSettings.CurrentOption[1]
						elseif #DropdownSettings.CurrentOption == 0 then
							Dropdown.Selected.PlaceholderText = "None"
						else
							Dropdown.Selected.PlaceholderText = unpackt(DropdownSettings.CurrentOption)
						end
					else
						DropdownSettings.CurrentOption = {}
						Dropdown.Selected.PlaceholderText = "None"
					end
					for _, name in pairs(DropdownSettings.CurrentOption) do
						tween(Dropdown.List[name], {TextColor3 = Color3.fromRGB(227,227,227), BackgroundTransparency = 0.95})
					end
				else
					Dropdown.Selected.PlaceholderText = DropdownSettings.CurrentOption[1] or "None"
				end
				Dropdown.Selected.Text = ""

				-- InfernoX.Flags[DropdownSettings.Flag] = DropdownSettings

			end

			function DropdownV:Destroy()
				Dropdown.Visible = false
				Dropdown:Destroy()
			end

			if Flag then
				InfernoX.Options[Flag] = DropdownV
			end

			-- InfernoX.Flags[DropdownSettings.Flag] = DropdownSettings

			return DropdownV

		end

		-- Color Picker
		function Tab:CreateColorPicker(ColorPickerSettings, Flag) -- by Rayfield/Throit
			local ColorPickerV = {IgnoreClass = false, Class = "Colorpicker", Settings = ColorPickerSettings}

			ColorPickerSettings = Kwargify({
				Name = "Color Picker",
				Color = Color3.fromRGB(255,255,255),
				Callback = function(Value)
					-- The function that takes place every time the color picker is moved/changed
					-- The variable (Value) is a Color3fromRGB value based on which color is selected
				end
			}, ColorPickerSettings or {})

			local function Color3ToHex(color)
				return string.format("#%02X%02X%02X", math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255))
			end

			ColorPickerV.Color = Color3ToHex(ColorPickerSettings.Color)

			local closedsize = UDim2.new(0, 75, 0, 22)
			local openedsize = UDim2.new(0, 219, 0, 129)

			local ColorPicker = Elements.Template.ColorPicker:Clone()
			local Background = ColorPicker.CPBackground
			local Display = Background.Display
			local Main = Background.MainCP
			local Slider = ColorPicker.ColorSlider

			ColorPicker.Name = ColorPickerSettings.Name
			ColorPicker.Title.Text = ColorPickerSettings.Name
			ColorPicker.Visible = true
			ColorPicker.Parent = TabPage
			ColorPicker.Size = UDim2.new(1.042, -25,0, 38)
			Background.Size = closedsize
			Display.BackgroundTransparency = 0

			ColorPicker["MouseEnter"]:Connect(function()
				tween(ColorPicker.UIStroke, {Color = Color3.fromRGB(87, 84, 104)})
			end)
			ColorPicker["MouseLeave"]:Connect(function()
				tween(ColorPicker.UIStroke, {Color = Color3.fromRGB(64,61,76)})
			end)

			local function SafeCallback(param, c2)
				local Success, Response = pcall(function()
					ColorPickerSettings.Callback(param)
				end)
				if not Success then
					TweenService:Create(ColorPicker, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
					TweenService:Create(ColorPicker, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
					TweenService:Create(ColorPicker.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
					ColorPicker.Title.Text = "Callback Error"
					print("InfernoX Interface Suite | "..ColorPickerSettings.Name.." Callback Error " ..tostring(Response))
					wait(0.5)
					ColorPicker.Title.Text = ColorPickerSettings.Name
					TweenService:Create(ColorPicker, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
					TweenService:Create(ColorPicker, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(32, 30, 38)}):Play()
					TweenService:Create(ColorPicker.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
				end
				if Success and c2 then
					c2()
				end
			end

			local opened = false

			local mouse = game.Players.LocalPlayer:GetMouse()
			Main.Image = "http://www.roblox.com/asset/?id=11415645739"
			local mainDragging = false 
			local sliderDragging = false 
			ColorPicker.Interact.MouseButton1Down:Connect(function()
				if not opened then
					opened = true 
					tween(ColorPicker, {Size = UDim2.new( 1.042, -25,0, 165)}, nil, TweenInfo.new(0.6, Enum.EasingStyle.Exponential))
					tween(Background, {Size = openedsize})
					tween(Display, {BackgroundTransparency = 1})
				else
					opened = false
					tween(ColorPicker, {Size = UDim2.new(1.042, -25,0, 38)}, nil, TweenInfo.new(0.6, Enum.EasingStyle.Exponential))
					tween(Background, {Size = closedsize})
					tween(Display, {BackgroundTransparency = 0})
				end
			end)
			UserInputService.InputEnded:Connect(function(input, gameProcessed) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
					mainDragging = false
					sliderDragging = false
				end end)
			Main.MouseButton1Down:Connect(function()
				if opened then
					mainDragging = true 
				end
			end)
			Main.MainPoint.MouseButton1Down:Connect(function()
				if opened then
					mainDragging = true 
				end
			end)
			Slider.MouseButton1Down:Connect(function()
				sliderDragging = true 
			end)
			Slider.SliderPoint.MouseButton1Down:Connect(function()
				sliderDragging = true 
			end)
			local h,s,v = ColorPickerSettings.Color:ToHSV()
			local color = Color3.fromHSV(h,s,v) 
			local r,g,b = math.floor((h*255)+0.5),math.floor((s*255)+0.5),math.floor((v*255)+0.5)
			local hex = string.format("#%02X%02X%02X",color.R*0xFF,color.G*0xFF,color.B*0xFF)
			ColorPicker.HexInput.InputBox.Text = hex
			local function setDisplay(hp,sp,vp)
				--Main
				Main.MainPoint.Position = UDim2.new(s,-Main.MainPoint.AbsoluteSize.X/2,1-v,-Main.MainPoint.AbsoluteSize.Y/2)
				Main.MainPoint.ImageColor3 = Color3.fromHSV(hp,sp,vp)
				Background.BackgroundColor3 = Color3.fromHSV(hp,1,1)
				Display.BackgroundColor3 = Color3.fromHSV(hp,sp,vp)
				--Slider 
				local x = hp * Slider.AbsoluteSize.X
				Slider.SliderPoint.Position = UDim2.new(0,x-Slider.SliderPoint.AbsoluteSize.X/2,0.5,0)
				Slider.SliderPoint.ImageColor3 = Color3.fromHSV(hp,1,1)
				local color = Color3.fromHSV(hp,sp,vp) 
				local r,g,b = math.floor((color.R*255)+0.5),math.floor((color.G*255)+0.5),math.floor((color.B*255)+0.5)
				ColorPicker.RInput.InputBox.Text = tostring(r)
				ColorPicker.GInput.InputBox.Text = tostring(g)
				ColorPicker.BInput.InputBox.Text = tostring(b)
				hex = string.format("#%02X%02X%02X",color.R*0xFF,color.G*0xFF,color.B*0xFF)
				ColorPicker.HexInput.InputBox.Text = hex
			end
			setDisplay(h,s,v)
			ColorPicker.HexInput.InputBox.FocusLost:Connect(function()
				if not pcall(function()
						local r, g, b = string.match(ColorPicker.HexInput.InputBox.Text, "^#?(%w%w)(%w%w)(%w%w)$")
						local rgbColor = Color3.fromRGB(tonumber(r, 16),tonumber(g, 16), tonumber(b, 16))
						h,s,v = rgbColor:ToHSV()
						hex = ColorPicker.HexInput.InputBox.Text
						setDisplay()
						ColorPickerSettings.Color = rgbColor
					end) 
				then 
					ColorPicker.HexInput.InputBox.Text = hex 
				end
				local r,g,b = math.floor((h*255)+0.5),math.floor((s*255)+0.5),math.floor((v*255)+0.5)
				ColorPickerSettings.Color = Color3.fromRGB(r,g,b)
				SafeCallback( Color3.fromRGB(r,g,b))
			end)
			--RGB
			local function rgbBoxes(box,toChange)
				local value = tonumber(box.Text) 
				local color = Color3.fromHSV(h,s,v) 
				local oldR,oldG,oldB = math.floor((color.R*255)+0.5),math.floor((color.G*255)+0.5),math.floor((color.B*255)+0.5)
				local save 
				if toChange == "R" then save = oldR;oldR = value elseif toChange == "G" then save = oldG;oldG = value else save = oldB;oldB = value end
				if value then 
					value = math.clamp(value,0,255)
					h,s,v = Color3.fromRGB(oldR,oldG,oldB):ToHSV()
					setDisplay()
				else 
					box.Text = tostring(save)
				end
				local r,g,b = math.floor((color.R*255)+0.5),math.floor((color.G*255)+0.5),math.floor((color.B*255)+0.5)
				ColorPickerSettings.Color = Color3.fromRGB(r,g,b)
			end
			ColorPicker.RInput.InputBox.FocusLost:connect(function()
				rgbBoxes(ColorPicker.RInput.InputBox,"R")
				SafeCallback(Color3.fromRGB(r,g,b))
			end)
			ColorPicker.GInput.InputBox.FocusLost:connect(function()
				rgbBoxes(ColorPicker.GInput.InputBox,"G")
				SafeCallback(Color3.fromRGB(r,g,b))
			end)
			ColorPicker.BInput.InputBox.FocusLost:connect(function()
				rgbBoxes(ColorPicker.BInput.InputBox,"B")
				SafeCallback(Color3.fromRGB(r,g,b))
			end)
			RunService.RenderStepped:connect(function()
				if mainDragging then 
					local localX = math.clamp(mouse.X-Main.AbsolutePosition.X,0,Main.AbsoluteSize.X)
					local localY = math.clamp(mouse.Y-Main.AbsolutePosition.Y,0,Main.AbsoluteSize.Y)
					Main.MainPoint.Position = UDim2.new(0,localX-Main.MainPoint.AbsoluteSize.X/2,0,localY-Main.MainPoint.AbsoluteSize.Y/2)
					s = localX / Main.AbsoluteSize.X
					v = 1 - (localY / Main.AbsoluteSize.Y)
					Display.BackgroundColor3 = Color3.fromHSV(h,s,v)
					Main.MainPoint.ImageColor3 = Color3.fromHSV(h,s,v)
					Background.BackgroundColor3 = Color3.fromHSV(h,1,1)
					local color = Color3.fromHSV(h,s,v) 
					local r,g,b = math.floor((color.R*255)+0.5),math.floor((color.G*255)+0.5),math.floor((color.B*255)+0.5)
					ColorPicker.RInput.InputBox.Text = tostring(r)
					ColorPicker.GInput.InputBox.Text = tostring(g)
					ColorPicker.BInput.InputBox.Text = tostring(b)
					ColorPicker.HexInput.InputBox.Text = string.format("#%02X%02X%02X",color.R*0xFF,color.G*0xFF,color.B*0xFF)
					SafeCallback(Color3.fromRGB(r,g,b))
					ColorPickerSettings.Color = Color3.fromRGB(r,g,b)
					ColorPickerV.Color = ColorPickerSettings.Color
				end
				if sliderDragging then 
					local localX = math.clamp(mouse.X-Slider.AbsolutePosition.X,0,Slider.AbsoluteSize.X)
					h = localX / Slider.AbsoluteSize.X
					Display.BackgroundColor3 = Color3.fromHSV(h,s,v)
					Slider.SliderPoint.Position = UDim2.new(0,localX-Slider.SliderPoint.AbsoluteSize.X/2,0.5,0)
					Slider.SliderPoint.ImageColor3 = Color3.fromHSV(h,1,1)
					Background.BackgroundColor3 = Color3.fromHSV(h,1,1)
					Main.MainPoint.ImageColor3 = Color3.fromHSV(h,s,v)
					local color = Color3.fromHSV(h,s,v) 
					local r,g,b = math.floor((color.R*255)+0.5),math.floor((color.G*255)+0.5),math.floor((color.B*255)+0.5)
					ColorPicker.RInput.InputBox.Text = tostring(r)
					ColorPicker.GInput.InputBox.Text = tostring(g)
					ColorPicker.BInput.InputBox.Text = tostring(b)
					ColorPicker.HexInput.InputBox.Text = string.format("#%02X%02X%02X",color.R*0xFF,color.G*0xFF,color.B*0xFF)
					SafeCallback(Color3.fromRGB(r,g,b))
					ColorPickerSettings.Color = Color3.fromRGB(r,g,b)
					ColorPickerV.Color = ColorPickerSettings.Color
				end
			end)

			function ColorPickerV:Set(NewColorPickerSettings)

				NewColorPickerSettings = Kwargify(ColorPickerSettings, NewColorPickerSettings or {})

				ColorPickerV.Settings = NewColorPickerSettings
				ColorPickerSettings = NewColorPickerSettings

				ColorPicker.Name = ColorPickerSettings.Name
				ColorPicker.Title.Text = ColorPickerSettings.Name
				ColorPicker.Visible = true

				local h,s,v = ColorPickerSettings.Color:ToHSV()
				local color = Color3.fromHSV(h,s,v) 
				local r,g,b = math.floor((color.R*255)+0.5),math.floor((color.G*255)+0.5),math.floor((color.B*255)+0.5)
				local hex = string.format("#%02X%02X%02X",color.R*0xFF,color.G*0xFF,color.B*0xFF)
				ColorPicker.HexInput.InputBox.Text = hex
				setDisplay(h,s,v)
				SafeCallback(Color3.fromRGB(r,g,b))

				ColorPickerV.Color = ColorPickerSettings.Color
			end

			function ColorPickerV:Destroy()
				ColorPicker:Destroy()
			end

			if Flag then
				InfernoX.Options[Flag] = ColorPickerV
			end

			SafeCallback(ColorPickerSettings.Color)

			return ColorPickerV
		end


		function Tab:BuildConfigSection()
			if isStudio then
				Tab:CreateLabel({Text = "Config system unavailable. (Environment isStudio)", Style = 3})
				return "Config system unavailable." 
			end

			local inputPath = nil
			local selectedConfig = nil

			local Title = Elements.Template.Title:Clone()
			Title.Text = "Configurations"
			Title.Visible = true
			Title.Parent = TabPage
			Title.TextTransparency = 1
			TweenService:Create(Title, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()

			Tab:CreateSection("Config Creator")

			Tab:CreateInput({
				Name = "Config Name",
				Description = "Insert a name for your to be created config.",
				PlaceholderText = "Name",
				CurrentValue = "",
				Numeric = false,
				MaxCharacters = nil,
				Enter = false,
				Callback = function(input)
					inputPath = input
				end,
			})

			local configSelection

			Tab:CreateButton({
				Name = "Create Config",
				Description = "Create a config with all of your current settings.",
				Callback = function()
					if not inputPath or string.gsub(inputPath, " ", "") == "" then
						InfernoX:Notification({
							Title = "Interface",
							Icon = "warning",
							ImageSource = "Material",
							Content = "Config name cannot be empty."
						})
						return
					end

					local success, returned = InfernoX:SaveConfig(inputPath)
					if not success then
						InfernoX:Notification({
							Title = "Interface",
							Icon = "error",
							ImageSource = "Material",
							Content = "Unable to save config, return error: " .. returned
						})
					end

					InfernoX:Notification({
						Title = "Interface",
						Icon = "info",
						ImageSource = "Material",
						Content = string.format("Created config %q", inputPath),
					})

					configSelection:Set({ Options = InfernoX:RefreshConfigList() })
				end
			})

			Tab:CreateSection("Config Load/Settings")


			configSelection = Tab:CreateDropdown({
				Name = "Select Config",
				Description = "Select a config to load your settings on.",
				Options = InfernoX:RefreshConfigList(),
				CurrentOption = {},
				MultipleOptions = false,
				SpecialType = nil,
				Callback = function(Value)
					selectedConfig = Value
				end,
			})

			Tab:CreateButton({
				Name = "Load Config",
				Description = "Load your saved config settings.",
				Callback = function()
					local success, returned = InfernoX:LoadConfig(selectedConfig)
					if not success then
						InfernoX:Notification({
							Title = "Interface",
							Icon = "error",
							ImageSource = "Material",
							Content = "Unable to load config, return error: " .. returned
						})
						return
					end

					InfernoX:Notification({
						Title = "Interface",
						Icon = "info",
						ImageSource = "Material",
						Content = string.format("Loaded config %q", selectedConfig),
					})
				end
			})

			Tab:CreateButton({
				Name = "Overwrite Config",
				Description = "Overwrite your current config settings.",
				Callback = function()
					local success, returned = InfernoX:SaveConfig(selectedConfig)
					if not success then
						InfernoX:Notification({
							Title = "Interface",
							Icon = "error",
							ImageSource = "Material",
							Content = "Unable to overwrite config, return error: " .. returned
						})
						return
					end

					InfernoX:Notification({
						Title = "Interface",
						Icon = "info",
						ImageSource = "Material",
						Content = string.format("Overwrote config %q", selectedConfig),
					})
				end
			})

			Tab:CreateButton({
				Name = "Refresh Config List",
				Description = "Refresh the current config list.",
				Callback = function()
					configSelection:Set({ Options = InfernoX:RefreshConfigList() })
				end,
			})

			local loadlabel
			Tab:CreateButton({
				Name = "Set as autoload",
				Description = "Set a config to auto load setting in your next session.",
				Callback = function()
					local name = selectedConfig
					writefile(InfernoX.Folder .. "/settings/autoload.txt", name)
					loadlabel:Set({ Text = "Current autoload config: " .. name })

					InfernoX:Notification({
						Title = "Interface",
						Icon = "info",
						ImageSource = "Material",
						Content = string.format("Set %q to auto load", name),
					})
				end,
			})

			loadlabel = Tab:CreateParagraph({
				Title = "Current Auto Load",
				Text = "None"
			})

			Tab:CreateButton({
				Name = "Delete Autoload",
				Description = "Delete The Autoload File",
				Callback = function()
					local name = selectedConfig
					delfile(InfernoX.Folder .. "/settings/autoload.txt")
					loadlabel:Set({ Text = "None" })

					InfernoX:Notification({
						Title = "Interface",
						Icon = "info",
						ImageSource = "Material",
						Content = "Deleted Autoload",
					})
				end,
			})

			if isfile(InfernoX.Folder .. "/settings/autoload.txt") then
				local name = readfile(InfernoX.Folder .. "/settings/autoload.txt")
				loadlabel:Set( { Text = "Current autoload config: " .. name })
			end     
		end

		local ClassParser = {
			["Toggle"] = {
				Save = function(Flag, data)
					return {
						type = "Toggle", 
						flag = Flag, 
						state = data.CurrentValue or false
					}
				end,
				Load = function(Flag, data)
					if InfernoX.Options[Flag] then
						InfernoX.Options[Flag]:Set({ CurrentValue = data.state })
					end
				end
			},
			["Slider"] = {
				Save = function(Flag, data)
					return {
						type = "Slider", 
						flag = Flag, 
						value = (data.CurrentValue and tostring(data.CurrentValue)),
					}
				end,
				Load = function(Flag, data)
					if InfernoX.Options[Flag] and data.value then
						InfernoX.Options[Flag]:Set({ CurrentValue = data.value })
					end
				end
			},
			["Input"] = {
				Save = function(Flag, data)
					return {
						type = "Input", 
						flag = Flag, 
						text = data.CurrentValue
					}
				end,
				Load = function(Flag, data)
					if InfernoX.Options[Flag] and data.text and type(data.text) == "string" then
						InfernoX.Options[Flag]:Set({ CurrentValue = data.text })
					end
				end
			},
			["Dropdown"] = {
				Save = function(Flag, data)
					return {
						type = "Dropdown", 
						flag = Flag, 
						value = data.CurrentOption
					}
				end,
				Load = function(Flag, data)
					if InfernoX.Options[Flag] and data.value then
						InfernoX.Options[Flag]:Set({ CurrentOption = data.value })
					end
				end
			},
			-- buggy as hell stil
			["Colorpicker"] = {
				Save = function(Flag, data)
					local function Color3ToHex(color)
						return string.format("#%02X%02X%02X", math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255))
					end

					return {
						type = "Colorpicker", 
						flag = Flag, 
						color = Color3ToHex(data.Color) or nil,
						alpha = data.Alpha
					}
				end,
				Load = function(Flag, data)
					local function HexToColor3(hex)
						local r = tonumber(hex:sub(2, 3), 16) / 255
						local g = tonumber(hex:sub(4, 5), 16) / 255
						local b = tonumber(hex:sub(6, 7), 16) / 255
						return Color3.new(r, g, b)
					end

					if InfernoX.Options[Flag] and data.color then
						InfernoX.Options[Flag]:Set({Color = HexToColor3(data.color)})
					end
				end
			}
		}


		function Tab:BuildThemeSection()

			local Title = Elements.Template.Title:Clone()
			Title.Text = "Theming"
			Title.Visible = true
			Title.Parent = TabPage
			Title.TextTransparency = 1
			TweenService:Create(Title, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()

			Tab:CreateSection("Custom Editor")

			local c1cp = Tab:CreateColorPicker({
				Name = "Color 1",
				Color = Color3.fromRGB(117, 164, 206),
			}, "InfernoxInterfaceSuitePrebuiltCPC1") -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps

			local c2cp = Tab:CreateColorPicker({
				Name = "Color 2",
				Color = Color3.fromRGB(123, 201, 201),
			}, "InfernoxInterfaceSuitePrebuiltCPC2")

			local c3cp = Tab:CreateColorPicker({
				Name = "Color 3",
				Color = Color3.fromRGB(224, 138, 184),
			}, "InfernoxInterfaceSuitePrebuiltCPC3") 

			task.wait(1)

			c1cp:Set({
				Callback = function(Value)
					if c2cp and c3cp then
						InfernoX.ThemeGradient = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Value or Color3.fromRGB(255,255,255)), ColorSequenceKeypoint.new(0.50, c2cp.Color or Color3.fromRGB(255,255,255)), ColorSequenceKeypoint.new(1.00, c3cp.Color or Color3.fromRGB(255,255,255))}
						InterfaceUI.ThemeRemote.Value = not InterfaceUI.ThemeRemote.Value
					end
				end
			})

			c2cp:Set({
				Callback = function(Value)
					if c1cp and c3cp then
						InfernoX.ThemeGradient = ColorSequence.new{ColorSequenceKeypoint.new(0.00, c1cp.Color or Color3.fromRGB(255,255,255)), ColorSequenceKeypoint.new(0.50, Value or Color3.fromRGB(255,255,255)), ColorSequenceKeypoint.new(1.00, c3cp.Color or Color3.fromRGB(255,255,255))}
						InterfaceUI.ThemeRemote.Value = not InterfaceUI.ThemeRemote.Value
					end
				end
			})

			c3cp:Set({
				Callback = function(Valuex)
					if c2cp and c1cp then
						InfernoX.ThemeGradient = ColorSequence.new{ColorSequenceKeypoint.new(0.00, c1cp.Color or Color3.fromRGB(255,255,255)), ColorSequenceKeypoint.new(0.50, c2cp.Color or Color3.fromRGB(255,255,255)), ColorSequenceKeypoint.new(1.00, Valuex or Color3.fromRGB(255,255,255))}
						InterfaceUI.ThemeRemote.Value = not InterfaceUI.ThemeRemote.Value
					end
				end
			})

			Tab:CreateSection("Preset Gradients")

			for i,v in pairs(PresetGradients) do
				Tab:CreateButton({
					Name = tostring(i),
					Callback = function()
						c1cp:Set({ Color = v[1] })
						c2cp:Set({ Color = v[2] })
						c3cp:Set({ Color = v[3] })
					end,
				})
			end

		end


		local function BuildFolderTree()
			if isStudio then return "Config system unavailable." end
			local paths = {
				InfernoX.Folder,
				InfernoX.Folder .. "/settings"
			}

			for i = 1, #paths do
				local str = paths[i]
				if not isfolder(str) then
					makefolder(str)
				end
			end
		end

		local function SetFolder()

			if isStudio then return "Config system unavailable." end

			if WindowSettings.ConfigSettings.RootFolder ~= nil and WindowSettings.ConfigSettings.RootFolder ~= "" then
				InfernoX.Folder = WindowSettings.ConfigSettings.RootFolder .. "/" .. WindowSettings.ConfigSettings.ConfigFolder
			else
				InfernoX.Folder = WindowSettings.ConfigSettings.ConfigFolder
			end

			BuildFolderTree()
		end

		SetFolder()

		function InfernoX:SaveConfig(Path)
			if isStudio then return "Config system unavailable." end

			if (not Path) then
				return false, "Please select a config file."
			end

			local fullPath = InfernoX.Folder .. "/settings/" .. Path .. ".Infernox"

			local data = {
				objects = {}
			}

			for flag, option in next, InfernoX.Options do
				if not ClassParser[option.Class] then continue end
				if option.IgnoreConfig then continue end

				table.insert(data.objects, ClassParser[option.Class].Save(flag, option))
			end	

			local success, encoded = pcall(HttpService.JSONEncode, HttpService, data)
			if not success then
				return false, "Unable to encode into JSON data"
			end

			writefile(fullPath, encoded)
			return true
		end

		function InfernoX:LoadConfig(Path)
			if isStudio then return "Config system unavailable." end

			if (not Path) then
				return false, "Please select a config file."
			end

			local file = InfernoX.Folder .. "/settings/" .. Path .. ".Infernox"
			if not isfile(file) then return false, "Invalid file" end

			local success, decoded = pcall(HttpService.JSONDecode, HttpService, readfile(file))
			if not success then return false, "Unable to decode JSON data." end

			for _, option in next, decoded.objects do
				if ClassParser[option.type] then
					task.spawn(function() 
						ClassParser[option.type].Load(option.flag, option) 
					end)
				end
			end

			return true
		end

		function InfernoX:LoadAutoloadConfig()
			if isfile(InfernoX.Folder .. "/settings/autoload.txt") then

				if isStudio then return "Config system unavailable." end

				local name = readfile(InfernoX.Folder .. "/settings/autoload.txt")

				local success, err = InfernoX:LoadConfig(name)
				if not success then
					return InfernoX:Notification({
						Title = "Interface",
						Icon = "sparkle",
						ImageSource = "Material",
						Content = "Failed to load autoload config: " .. err,
					})
				end

				InfernoX:Notification({
					Title = "Interface",
					Icon = "sparkle",
					ImageSource = "Material",
					Content = string.format("Auto loaded config %q", name),
				})

			end 
		end

		function InfernoX:RefreshConfigList()
			if isStudio then return "Config system unavailable." end

			local list = listfiles(InfernoX.Folder .. "/settings")

			local out = {}
			for i = 1, #list do
				local file = list[i]
				if file:sub(-5) == ".Infernox" then
					local pos = file:find(".Infernox", 1, true)
					local start = pos

					local char = file:sub(pos, pos)
					while char ~= "/" and char ~= "\\" and char ~= "" do
						pos = pos - 1
						char = file:sub(pos, pos)
					end

					if char == "/" or char == "\\" then
						local name = file:sub(pos + 1, start - 1)
						if name ~= "options" then
							table.insert(out, name)
						end
					end
				end
			end

			return out
		end
		return Tab
	end


	Elements.Parent.Visible = true
	tween(Elements.Parent, {BackgroundTransparency = 0.1})
	Navigation.Visible = true
	tween(Navigation.Line, {BackgroundTransparency = 0})

	for _, TopbarButton in ipairs(Main.Controls:GetChildren()) do
		if TopbarButton.ClassName == "Frame" and TopbarButton.Name ~= "Theme" then
			TopbarButton.Visible = true
			tween(TopbarButton, {BackgroundTransparency = 0.25})
			tween(TopbarButton.UIStroke, {Transparency = 0.5})
			tween(TopbarButton.ImageLabel, {ImageTransparency = 0.25})
		end
	end

	Main.Controls.Close.ImageLabel.MouseButton1Click:Connect(function()
		Hide(Main, Window.Bind, true)
		dragBar.Visible = false
		Window.State = false
		if UserInputService.KeyboardEnabled == false then
			InterfaceUI.MobileSupport.Visible = true
		end
	end)
	Main.Controls.Close["MouseEnter"]:Connect(function()
		tween(Main.Controls.Close.ImageLabel, {ImageColor3 = Color3.new(1,1,1)})
	end)
	Main.Controls.Close["MouseLeave"]:Connect(function()
		tween(Main.Controls.Close.ImageLabel, {ImageColor3 = Color3.fromRGB(195,195,195)})
	end)

	UserInputService.InputBegan:Connect(function(input, gpe)
		if gpe then return end
		if Window.State then return end
		if input.KeyCode == Window.Bind then
			Unhide(Main, Window.CurrentTab)
			InterfaceUI.MobileSupport.Visible = false
			dragBar.Visible = true
			Window.State = true
		end
	end)

	Main.Logo.MouseButton1Click:Connect(function()
		if Navigation.Size.X.Offset == 205 then
			tween(Elements.Parent, {Size = UDim2.new(1, -55, Elements.Parent.Size.Y.Scale, Elements.Parent.Size.Y.Offset)})
			tween(Navigation, {Size = UDim2.new(Navigation.Size.X.Scale, 55, Navigation.Size.Y.Scale, Navigation.Size.Y.Offset)})
		else
			tween(Elements.Parent, {Size = UDim2.new(1, -205, Elements.Parent.Size.Y.Scale, Elements.Parent.Size.Y.Offset)})
			tween(Navigation, {Size = UDim2.new(Navigation.Size.X.Scale, 205, Navigation.Size.Y.Scale, Navigation.Size.Y.Offset)})
		end
	end)

	Main.Controls.ToggleSize.ImageLabel.MouseButton1Click:Connect(function()
		Window.Size = not Window.Size
		if Window.Size then
			Minimize(Main)
			dragBar.Visible = false
		else
			Maximise(Main)
			dragBar.Visible = true
		end
	end)
	Main.Controls.ToggleSize["MouseEnter"]:Connect(function()
		tween(Main.Controls.ToggleSize.ImageLabel, {ImageColor3 = Color3.new(1,1,1)})
	end)
	Main.Controls.ToggleSize["MouseLeave"]:Connect(function()
		tween(Main.Controls.ToggleSize.ImageLabel, {ImageColor3 = Color3.fromRGB(195,195,195)})
	end)

	Main.Controls.Theme.ImageLabel.MouseButton1Click:Connect(function()
		if Window.Settings then
			Window.Settings:Activate()
			Elements.Settings.CanvasPosition = Vector2.new(0,698)
		end
	end)
	Main.Controls.Theme["MouseEnter"]:Connect(function()
		tween(Main.Controls.Theme.ImageLabel, {ImageColor3 = Color3.new(1,1,1)})
	end)
	Main.Controls.Theme["MouseLeave"]:Connect(function()
		tween(Main.Controls.Theme.ImageLabel, {ImageColor3 = Color3.fromRGB(195,195,195)})
	end)	


	InterfaceUI.MobileSupport.Interact.MouseButton1Click:Connect(function()
		Unhide(Main, Window.CurrentTab)
		dragBar.Visible = true
		Window.State = true
		InterfaceUI.MobileSupport.Visible = false
	end)

	return Window
end

function InfernoX:Destroy()
	Main.Visible = false
	for _, Notification in ipairs(Notifications:GetChildren()) do
		if Notification.ClassName == "Frame" then
			Notification.Visible = false
			Notification:Destroy()
		end
	end
	InterfaceUI:Destroy()
end




return InfernoX
 
