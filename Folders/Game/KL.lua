local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local VIM = game:GetService("VirtualInputManager")
local LP = Players.LocalPlayer
local Stats = LP:WaitForChild("PlayerStats")
local CurrentQuest = LP:WaitForChild("CurrentQuest")
local QuestProgress = LP:WaitForChild("QuestProgress")
local Chest = RS:WaitForChild("Chest")
local Remotes = Chest.Remotes.Functions
local QuestRemote = Remotes.Quest
local EtcRemote = Remotes.EtcFunction
local ProxyFolder = RS.Chest.Assets.Modules.EntityClient.Proxy
local SkillRemote = Remotes.SkillAction
local HakiRemote = Chest.Remotes.Events.Armament
local QuestData = require(Chest.Modules.QuestManager)
local SkillData = Chest.Modules.SkillData
local NPCFolder = workspace:WaitForChild("AllNPC")
local MonsterFolder = workspace:WaitForChild("Monster"):WaitForChild("Mon")
local BossFolder = workspace.Monster:WaitForChild("Boss")
local CharacterWorkshop = workspace:WaitForChild("CharacterWorkshop")
local RepeatFrame = LP.PlayerGui.MainGui.QuestFrame.RepeatFrame
local StatsUI = LP.PlayerGui.MainGui.StarterFrame.StatsFrame
local StatsRemote = StatsUI.RemoteEvent
local Points = StatsUI.StatsPage.FunctionBar.PointsFrame.PointText
local MapName = MarketplaceService:GetProductInfo(game.PlaceId).Name:gsub("[%c%p%s]", "_")

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "InfernoX HUB",
    Icon = "rbxassetid://133128937209520",
    Author = "by Bxylic",
    Folder = "WindUI",
    Size = UDim2.fromOffset(650, 450),
    Transparent = true,
    Theme = "Dark",
    Resizable = true
})

local ConfigManager = Window.ConfigManager
local MyConfig = ConfigManager:CreateConfig(MapName .. "/" .. LP.UserId)

-- SETTINGS

_G.Farm = false
_G.Haki = false
_G.AutoStats = false
_G.HidePopupEnabled = false
_G.AutoSkillEnabled = true
_G.SkillAimEnabled = true
_G.FarmMode = "Above"
_G.FarmDistance = 7
_G.WeaponType = ""
_G.SelectedStats = {"Melee"}
_G.StatsAmount = 10
_G.SkillAimTarget = nil
_G.SkillAimMaxDistance = 1000
_G.AutoSkillDelay = 0.2
_G.AutoSkillKeys = {"Z", "X", "C", "V"}

local M1Delay = 0.25
local StatsDelay = 0.3
local StatsIndex = 1

local LockedMob
local MobPositions = {}
local LastQuest = ""
local RepeatQuest = ""
local SwitchingQuest = false
local WaitingRepeat = false
local RepeatDecisionMade = false
local LastRepeatClick = 0
local QuestEndedAt = 0

local Character
local HRP
local CharacterGeneration = 0
local st = CFrame.identity
local QuestCandidateCache

local EquipCategories = {
    Melee = SkillData.Styles,
    Sword = SkillData.Swords,
    Fruit = SkillData.Fruits
}

-- CONFIG

local function AddElement(Tab, ElementType, Data)
    local Callback = Data.Callback

    Data.Callback = function(Value)
        if Callback then Callback(Value) end

        task.spawn(function()
            task.wait(1)
            MyConfig:Save()
        end)
    end

    local Element = Tab[ElementType](Tab, Data)

    if Data.Flag then
        MyConfig:Register(Data.Flag, Element)
    end

    return Element
end

local function GetDropdown(Value)
    return type(Value) == "table" and Value[1] or Value
end

-- POPUP
local function HidePopup()
    if not _G.HidePopupEnabled then return end
    local Popup = LP.PlayerGui:FindFirstChild("Popup")
    if Popup and Popup:IsA("ScreenGui") then
        Popup.Enabled = false
    end
end
local function WatchPopup(Popup)
    if not Popup:IsA("ScreenGui") then return end
    if _G.HidePopupEnabled then
        Popup.Enabled = false
    end
    Popup:GetPropertyChangedSignal("Enabled"):Connect(function()
        if _G.HidePopupEnabled and Popup.Enabled then
            Popup.Enabled = false
        end
    end)
end
local ExistingPopup = LP.PlayerGui:FindFirstChild("Popup")
if ExistingPopup then WatchPopup(ExistingPopup) end
LP.PlayerGui.ChildAdded:Connect(function(Child)
    if Child.Name == "Popup" then
        WatchPopup(Child)
    end
end)

-- LOOP MANAGER

local Running = {}

local function StartLoop(Name, Condition, Delay, Callback)
    if Running[Name] then return end

    Running[Name] = true
    task.spawn(function()
        while Condition() do
            pcall(Callback)
            task.wait(Delay)
        end

        Running[Name] = nil
    end)
end

-- CORE FUNCTIONS

local function GetRoot(Target)
    Target = Target or LP.Character

    if not Target then return nil end
    if Target:IsA("BasePart") then return Target end

    if Target:IsA("Model") then
        return Target:FindFirstChild("HumanoidRootPart")
            or Target.PrimaryPart
            or Target:FindFirstChildWhichIsA("BasePart", true)
    end

    return nil
end

local function IsAlive(Mob)
    local Humanoid = Mob and Mob:FindFirstChildOfClass("Humanoid")
    return Mob and Mob.Parent and Humanoid and Humanoid.Health > 0
end

local function GetEquipTool(Type)
    local Folder = EquipCategories[Type]
    if not Folder then return nil end

    local Char = LP.Character

    if Char then
        for _, Tool in ipairs(Char:GetChildren()) do
            if Tool:IsA("Tool") and Folder:FindFirstChild(Tool.Name .. "_Data") then
                return Tool
            end
        end
    end

    for _, Tool in ipairs(LP.Backpack:GetChildren()) do
        if Tool:IsA("Tool") and Folder:FindFirstChild(Tool.Name .. "_Data") then
            return Tool
        end
    end
end

local function EquipToolNow()
    if not _G.Farm then return false end

    local Tool = GetEquipTool(_G.WeaponType)
    local Char = LP.Character
    local Humanoid = Char and Char:FindFirstChildOfClass("Humanoid")

    if not Tool or not Humanoid then return false end
    if Tool.Parent == Char then return true end

    if Tool.Parent == LP.Backpack then
        return pcall(function()
            Humanoid:EquipTool(Tool)
        end)
    end

    return false
end

local function StopFarm()
    if HRP then
        local Clip = HRP:FindFirstChild("BodyClip")
        if Clip then Clip:Destroy() end
    end

    HRP = nil
    _G.SkillAimTarget = nil
end

local function GetNPCRoot(NPC)
    if not NPC then return nil end

    local Current = NPC

    while Current and Current ~= NPCFolder do
        if Current:IsA("Model") then
            if Current.PrimaryPart then return Current.PrimaryPart end

            local Root = Current:FindFirstChild("HumanoidRootPart", true)
            if Root and Root:IsA("BasePart") then return Root end
        end

        if Current:IsA("BasePart") then return Current end
        Current = Current.Parent
    end

    return nil
end

local function TeleportToNPC(NPC)
    local Root = Character and Character:FindFirstChild("HumanoidRootPart")
    local NPCRoot = GetNPCRoot(NPC)

    if not Root or not NPCRoot then return false end

    Root.CFrame = NPCRoot.CFrame * CFrame.new(0, 0, 3)
    task.wait(1)

    return true
end

local function ModeFarm()
    if not HRP or not HRP.Parent then return end

    local Offset = CFrame.identity
    local Rotation = CFrame.identity

    if _G.FarmMode == "Behind" then
        Offset = CFrame.new(0, 0, _G.FarmDistance)
    elseif _G.FarmMode == "Above" then
        Offset = CFrame.new(0, _G.FarmDistance, 0)
        Rotation = CFrame.Angles(math.rad(-90), 0, 0)
    elseif _G.FarmMode == "Under" then
        Offset = CFrame.new(0, -_G.FarmDistance, 0)
        Rotation = CFrame.Angles(math.rad(90), 0, 0)
    end

    st = Offset * Rotation

    local Clip = HRP:FindFirstChild("BodyClip")

    if not Clip then
        Clip = Instance.new("BodyVelocity")
        Clip.Name = "BodyClip"
        Clip.Parent = HRP
    end

    Clip.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    Clip.P = 1e6
    Clip.Velocity = Vector3.zero

    HRP.AssemblyLinearVelocity = Vector3.zero
    HRP.AssemblyAngularVelocity = Vector3.zero
end

-- QUEST FUNCTIONS

local function IsMainQuest(Data)
    return type(Data) == "table"
        and type(Data.Level) == "number"
        and type(Data.Mob) == "string"
        and Data.Mob:find("%[Lv%.")
        and type(Data.Ammount) == "number"
        and type(Data.Rewards) == "table"
        and not Data.DailyQuest
        and not Data.OneTimeQuest
        and not Data.CustomPrompt
        and not Data.Interact
        and not Data.Track
end

local function GetQuestCandidates(Level)
    if QuestCandidateCache and QuestCandidateCache.Level == Level then
        return QuestCandidateCache.Candidates
    end

    local Candidates = {}

    for _, NPC in ipairs(NPCFolder:GetDescendants()) do
        local Min = NPC:GetAttribute("LevelMin")
        local Max = NPC:GetAttribute("LevelMax")

        if type(Min) == "number" and type(Max) == "number" and Level >= Min then
            local BestQuest
            local BestQuestLevel = -1

            for Name, Data in pairs(QuestData) do
                if IsMainQuest(Data)
                    and Data.Level <= Level
                    and Data.Level >= Min
                    and Data.Level <= Max
                    and Data.Level > BestQuestLevel then

                    BestQuest = Name
                    BestQuestLevel = Data.Level
                end
            end

            if BestQuest then
                table.insert(Candidates, {
                    NPC = NPC,
                    Quest = BestQuest,
                    QuestLevel = BestQuestLevel,
                    Min = Min,
                    Max = Max
                })
            end
        end
    end

    table.sort(Candidates, function(A, B)
        if A.QuestLevel == B.QuestLevel then
            return A.Min > B.Min
        end

        return A.QuestLevel > B.QuestLevel
    end)

    QuestCandidateCache = {
        Level = Level,
        Candidates = Candidates
    }

    return Candidates
end

NPCFolder.DescendantAdded:Connect(function()
    QuestCandidateCache = nil
end)

NPCFolder.DescendantRemoving:Connect(function()
    QuestCandidateCache = nil
end)

local function FindMonster()
    local Data = QuestData[CurrentQuest.Value]
    if not Data then return nil end

    if IsAlive(LockedMob) and LockedMob.Name == Data.Mob then
        return LockedMob
    end

    LockedMob = nil
    local Targets = {}

    for _, Folder in ipairs({MonsterFolder, BossFolder}) do
        for _, Mob in ipairs(Folder:GetChildren()) do
            local Root = Mob:FindFirstChild("HumanoidRootPart")

            if Mob.Name == Data.Mob and Root and IsAlive(Mob) then
                table.insert(Targets, Mob)
            end
        end
    end

    table.sort(Targets, function(A, B)
        return A.Humanoid.Health < B.Humanoid.Health
    end)

    LockedMob = Targets[1]

    if LockedMob then
        local Root = LockedMob:FindFirstChild("HumanoidRootPart")
        if Root then
            MobPositions[Data.Mob] = Root.CFrame
        end
    end

    return LockedMob
end
local function GetMonsterSpawn()
    local Data = QuestData[CurrentQuest.Value]
    if not Data then return nil end
    local Model = ProxyFolder:FindFirstChild(Data.Mob)
    if not Model then return nil end
    local Root = Model:FindFirstChild("HumanoidRootPart")
    return Root and Root.CFrame
end

local function ChangeQuest(Target, NPC)
    if SwitchingQuest or not Target then return end

    SwitchingQuest = true
    WaitingRepeat = false
    RepeatDecisionMade = false
    RepeatQuest = ""
    LockedMob = nil

    local Success = pcall(function()
        if CurrentQuest.Value ~= "" then
            EtcRemote:InvokeServer("CancelQuest", {})
            task.wait(0.5)
        end

        if CurrentQuest.Value == "" then
            if NPC then TeleportToNPC(NPC) end
            QuestRemote:InvokeServer("take", Target)
        end
    end)

    task.wait(1)
    SwitchingQuest = false

    return Success
end

local function UpdateQuest()
    if WaitingRepeat or SwitchingQuest then return end

    local Candidates = GetQuestCandidates(Stats.lvl.Value)
    local Candidate = Candidates[1]

    if Candidate and CurrentQuest.Value ~= Candidate.Quest then
        ChangeQuest(Candidate.Quest, Candidate.NPC)
    end
end

local function CheckLevelChange()
    if SwitchingQuest or CurrentQuest.Value == "" then return end

    local CurrentData = QuestData[CurrentQuest.Value]
    if not CurrentData then return end

    local Candidates = GetQuestCandidates(Stats.lvl.Value)
    local Candidate = Candidates[1]
    local NewData = Candidate and QuestData[Candidate.Quest]

    if NewData and NewData.Level > CurrentData.Level then
        ChangeQuest(Candidate.Quest, Candidate.NPC)
    end
end

local function AutoRepeat()
    if not WaitingRepeat or not RepeatFrame.Visible or RepeatDecisionMade
        or SwitchingQuest or os.clock() - LastRepeatClick < 2 then
        return
    end

    local Candidates = GetQuestCandidates(Stats.lvl.Value)
    local Candidate = Candidates[1]
    local Target = Candidate and Candidate.Quest

    LastRepeatClick = os.clock()
    RepeatDecisionMade = true

    if Target == RepeatQuest and RepeatFrame:FindFirstChild("Yes") then
        firesignal(RepeatFrame.Yes.MouseButton1Click)
    else
        if RepeatFrame:FindFirstChild("No") then
            firesignal(RepeatFrame.No.MouseButton1Click)
        end

        task.delay(1.5, function()
            WaitingRepeat = false
            if _G.Farm then UpdateQuest() end
        end)
    end
end

-- FARM ACTIONS

local function UpdateFarm()
    if not _G.Farm then StopFarm() return end
    if not Character or Character ~= LP.Character then StopFarm() return end

    local Root = Character:FindFirstChild("HumanoidRootPart")
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")

    if not Root or not Humanoid or Humanoid.Health <= 0 then
        StopFarm()
        return
    end

    if HRP ~= Root then
        StopFarm()
        HRP = Root
    end

    ModeFarm()
    if CurrentQuest.Value == "" or SwitchingQuest then return end

    local Mob = FindMonster()
    local TargetRoot = Mob and Mob:FindFirstChild("HumanoidRootPart")

    if IsAlive(Mob) and TargetRoot then
        Root.CFrame = TargetRoot.CFrame * st
    else
        local SpawnCFrame = MobPositions[QuestData[CurrentQuest.Value].Mob]

        if SpawnCFrame then
            Root.CFrame = SpawnCFrame * st
        end
    end
end

local function AutoM1Action()
    if not _G.Farm or not Character or Character ~= LP.Character then return end

    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    if not Humanoid or Humanoid.Health <= 0 then return end

    local Mob = FindMonster()
    if not IsAlive(Mob) then return end

    local Tool = Character:FindFirstChildOfClass("Tool")
    if not Tool then return end

    local SwordName = Stats:FindFirstChild("SwordName")
    local FightingStyle = Stats:FindFirstChild("FightingStyle")
    local Sword = SwordName and tostring(SwordName.Value)
    local Style = FightingStyle and tostring(FightingStyle.Value)
    local SkillName

    if Sword and Sword ~= "None" and Tool.Name == Sword then
        SkillName = "SW_" .. Sword .. "_M1"
    else
        if not Style then return end
        SkillName = "FS_" .. Style .. "_M1"
    end

    if not IsAlive(Mob) then return end

    pcall(function()
        SkillRemote:InvokeServer(SkillName)
    end)
end

-- AUTO SKILL

local function autoskill(Target)
    if not _G.Farm or not _G.SkillAimEnabled or not IsAlive(Target) then
        _G.SkillAimTarget = nil
        return false
    end

    local Root = GetRoot(Target)
    local PlayerRoot = GetRoot()

    if not Root or not PlayerRoot then
        _G.SkillAimTarget = nil
        return false
    end

    local Distance = (PlayerRoot.Position - Root.Position).Magnitude

    if Distance > _G.SkillAimMaxDistance then
        _G.SkillAimTarget = nil
        return false
    end

    _G.SkillAimTarget = Root
    return true
end

local OldNamecall

OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local Args = {...}

    if _G.Farm and _G.SkillAimEnabled and self == SkillRemote
        and getnamecallmethod() == "InvokeServer"
        and type(Args[1]) == "string"
        and Args[1]:match("^FS_")
        and type(Args[2]) == "table" then

        local Target = _G.SkillAimTarget

        if Target and Target.Parent then
            Args[2] = table.clone(Args[2])
            Args[2].MouseHit = Target.CFrame
            return OldNamecall(self, unpack(Args))
        end
    end

    return OldNamecall(self, ...)
end))

local function AutoSkillAction()
    if not _G.Farm or not _G.AutoSkillEnabled then
        _G.SkillAimTarget = nil
        return
    end

    local Mob = FindMonster()

    if not IsAlive(Mob) then
        _G.SkillAimTarget = nil
        return
    end

    autoskill(Mob)

    for _, Key in ipairs(_G.AutoSkillKeys) do
        if not _G.Farm or not _G.AutoSkillEnabled then break end

        if not IsAlive(Mob) or FindMonster() ~= Mob then
            _G.SkillAimTarget = nil
            break
        end

        if _G.SkillAimEnabled then autoskill(Mob) end

        local KeyCode = Enum.KeyCode[Key]

        if KeyCode then
            VIM:SendKeyEvent(true, KeyCode, false, game)
            task.wait(1)
            VIM:SendKeyEvent(false, KeyCode, false, game)
        end

        task.wait(_G.AutoSkillDelay)
    end

    if not IsAlive(Mob) then _G.SkillAimTarget = nil end
end

-- STATS

local function AddStats()
    local Selected = _G.SelectedStats
    if type(Selected) ~= "table" or #Selected == 0 then return end

    local Available = tonumber(Points.ContentText:match("%d+"))
    if not Available or Available <= 0 then return end

    if StatsIndex > #Selected then StatsIndex = 1 end

    local StatName = Selected[StatsIndex]
    StatsIndex += 1

    if StatName then
        StatsRemote:FireServer(StatName, math.min(_G.StatsAmount, Available))
    end
end

-- PUBLIC FUNCTIONS

function AutoFarm()
    StartLoop("Farm", function()
        return _G.Farm
    end, 0, UpdateFarm)
end

function AutoEquip()
    StartLoop("Equip", function()
        return _G.Farm
    end, 1.5, EquipToolNow)
end

function AutoQuest()
    StartLoop("Quest", function()
        return _G.Farm
    end, 1.5, function()
        AutoRepeat()

        if CurrentQuest.Value == "" then
            if WaitingRepeat then
                if not RepeatFrame.Visible and not RepeatDecisionMade
                    and os.clock() - QuestEndedAt > 2 then

                    WaitingRepeat = false
                    UpdateQuest()
                end
            else
                UpdateQuest()
            end
        else
            CheckLevelChange()
        end
    end)
end

function AutoM1()
    StartLoop("M1", function()
        return _G.Farm
    end, M1Delay, AutoM1Action)
end

function AutoSkill()
    StartLoop("Skill", function()
        return _G.Farm and _G.AutoSkillEnabled
    end, 1, AutoSkillAction)
end

local function StartAutoStats()
    StartLoop("Stats", function()
        return _G.AutoStats
    end, StatsDelay, AddStats)
end

-- HAKI

local function ToggleHaki(State)
    _G.Haki = State

    if State then
        StartLoop("Haki", function()
            return _G.Haki
        end, 1, function()
            local Char = LP.Character
            local Humanoid = Char and Char:FindFirstChildOfClass("Humanoid")

            if Char and Humanoid and Humanoid.Health > 0 then
                local ArmamentName = LP.Name .. "ArmamentGroup"

                if not CharacterWorkshop:FindFirstChild(ArmamentName) then
                    HakiRemote:FireServer()
                end
            end
        end)
    end
end

-- CHARACTER

local function WatchCharacterEquip(Char)
    Char.ChildRemoved:Connect(function(Tool)
        if not Tool:IsA("Tool") then return end

        task.defer(function()
            if _G.Farm then EquipToolNow() end
        end)
    end)
end

LP.Backpack.ChildAdded:Connect(function(Tool)
    if not Tool:IsA("Tool") then return end

    task.defer(function()
        if _G.Farm then EquipToolNow() end
    end)
end)

local function ResetCharacter(NewCharacter)
    CharacterGeneration += 1
    local Generation = CharacterGeneration

    StopFarm()
    HidePopup()

    LockedMob = nil
    Character = NewCharacter
    HRP = nil

    WatchCharacterEquip(NewCharacter)

    task.spawn(function()
        local Humanoid = NewCharacter:WaitForChild("Humanoid", 15)
        local Root = NewCharacter:WaitForChild("HumanoidRootPart", 15)

        if Generation ~= CharacterGeneration then return end
        if not Humanoid or not Root or Humanoid.Health <= 0 then return end

        Character = NewCharacter
        HRP = Root
        LockedMob = nil

        task.wait(0.5)
        if Generation ~= CharacterGeneration then return end

        HidePopup()

        if _G.Farm then
            AutoEquip()
            AutoFarm()
            AutoQuest()
            AutoM1()
            AutoSkill()

            if CurrentQuest.Value == "" and not WaitingRepeat then
                UpdateQuest()
            elseif CurrentQuest.Value ~= "" then
                CheckLevelChange()
            end
        end
    end)
end

LP.CharacterAdded:Connect(ResetCharacter)

LP.CharacterRemoving:Connect(function(OldCharacter)
    if Character == OldCharacter then
        CharacterGeneration += 1
        Character = nil
        LockedMob = nil
        StopFarm()
    end
end)

Stats.lvl.Changed:Connect(function()
    if _G.Farm then task.defer(CheckLevelChange) end
end)

CurrentQuest.Changed:Connect(function()
    local NewQuest = CurrentQuest.Value

    if NewQuest == "" and LastQuest ~= "" then
        RepeatQuest = LastQuest
        WaitingRepeat = true
        RepeatDecisionMade = false
        QuestEndedAt = os.clock()
        LockedMob = nil
        StopFarm()
    elseif NewQuest ~= "" then
        WaitingRepeat = false
        RepeatDecisionMade = false
        RepeatQuest = ""
        LockedMob = nil
        _G.SkillAimTarget = nil
    end

    LastQuest = NewQuest
end)

if LP.Character then ResetCharacter(LP.Character) end

local Codes = {
    "4BVISITS",
    "MOBILEFIXED",
    "HALLOWEENRESET",
    "TRADE8SLOTS",
    "PITYSYSTEM",
    "LEGACYISLAND",
    "MYTHICALDRAGON",
    "<3LEEPUNGG",
    "DragonColorRefund",
    "WELCOMETOKINGLEGACY",
    "FREESTATSRESET",
    "2MFAV"
}

local RedeemRemote = game:GetService("ReplicatedStorage")
    :WaitForChild("Chest")
    :WaitForChild("Remotes")
    :WaitForChild("Functions")
    :WaitForChild("redeemcode")
local Redeeming = false
local function RedeemAllCodes()
    if Redeeming then return end
    Redeeming = true
    task.spawn(function()
        for _, Code in ipairs(Codes) do
            pcall(function()
                RedeemRemote:InvokeServer(Code)
            end)
            task.wait(1)
        end
        Redeeming = false
    end)
end

-- UI

Window:Tag({
    Title = "v0.0.1",
    Icon = "github",
    Color = Color3.fromHex("#30ff6a"),
    Radius = 10
})

Window:Tag({
    Title = "Beta Test",
    Icon = "shield-check",
    Color = Color3.fromHex("#3aa0ff"),
    Radius = 10
})

Window:Tag({
    Title = "Mobile",
    Icon = "smartphone",
    Color = Color3.fromHex("#ffaa00"),
    Radius = 10
})

local Tabs = {
    Main = Window:Tab({Title = "Main", Icon = "house"}),
    Item = Window:Tab({Title = "Item", Icon = "sword"}),
    Buy = Window:Tab({Title = "Buy", Icon = "shopping-cart"}),
    Teleport = Window:Tab({Title = "Teleport", Icon = "map-pin"}),
    Settings = Window:Tab({Title = "Settings", Icon = "settings"})
}

AddElement(Tabs.Main, "Toggle", {
    Title = "Auto Farm",
    Desc = "Farm",
    Flag = "AutoFarm",
    Value = false,
    Callback = function(State)
        _G.Farm = State

        if State then
            AutoFarm()
            AutoEquip()
            AutoQuest()
            AutoM1()
            AutoSkill()
        else
            StopFarm()
            LockedMob = nil
        end
    end
})

AddElement(Tabs.Main, "Dropdown", {
    Title = "Farm Method",
    Desc = "เปลี่ยนตำแหน่งฟาร์มแบบ Real-time",
    Values = {"Above", "Behind", "Below"},
    Value = {"Behind"},
    Flag = "FarmMode_Config",
    Callback = function(Value)
        local Mode = GetDropdown(Value)

        _G.FarmMode = ({
            Behind = "Behind",
            Below = "Under",
            Upper = "Above",
            Above = "Above"
        })[Mode] or "Above"
    end
})

AddElement(Tabs.Main, "Slider", {
    Title = "Farm Distance",
    Flag = "FarmDist_Value",
    Value = {Min = 0, Max = 15, Default = 7},
    Callback = function(Value)
        _G.FarmDistance = Value
    end
})

AddElement(Tabs.Main, "Dropdown", {
    Title = "Weapon Type",
    Desc = "เลือกประเภทอาวุธสำหรับ Auto Equip",
    Values = {"Melee", "Sword", "Fruit"},
    Value = {"Melee"},
    Flag = "WeaponType_Config",
    Callback = function(Value)
        _G.WeaponType = GetDropdown(Value) or "Melee"
        if _G.Farm then AutoEquip() end
    end
})

AddElement(Tabs.Main, "Toggle", {
    Title = "Auto Stats",
    Desc = "เปิด/ปิดระบบอัปสเตตัสอัตโนมัติ",
    Flag = "AutoStats",
    Value = false,
    Callback = function(State)
        _G.AutoStats = State
        if State then StartAutoStats() end
    end
})

AddElement(Tabs.Main, "Dropdown", {
    Title = "Select Stats",
    Desc = "เลือกสเตตัสที่ต้องการอัป",
    Values = {"Melee", "Defense", "Sword", "DevilFruit"},
    Value = {"Melee"},
    Multi = true,
    Flag = "Stats_Config",
    Callback = function(Options)
        _G.SelectedStats = type(Options) == "table" and Options or {}
        StatsIndex = 1
    end
})

AddElement(Tabs.Main, "Slider", {
    Title = "Stats Amount",
    Desc = "จำนวนพอยต์ต่อครั้ง",
    Flag = "StatsAmount_Config",
    Value = {Min = 1, Max = 100, Default = 10},
    Callback = function(Value)
        _G.StatsAmount = Value
    end
})

AddElement(Tabs.Main, "Toggle", {
    Title = "Auto Skill",
    Desc = "กดสกิลอัตโนมัติพร้อมเล็งไปยังมอนที่ฟาร์ม",
    Flag = "AutoSkill",
    Value = true,
    Callback = function(State)
        _G.AutoSkillEnabled = State
        _G.SkillAimEnabled = State

        if State and _G.Farm then
            AutoSkill()
        else
            _G.SkillAimTarget = nil
        end
    end
})

AddElement(Tabs.Main, "Dropdown", {
    Title = "Select Skills",
    Desc = "เลือกปุ่มสกิลที่ต้องการให้กดอัตโนมัติ",
    Values = {"Z", "X", "C", "V"},
    Value = {"Z", "X", "C", "V"},
    Multi = true,
    Flag = "AutoSkillKeys",
    Callback = function(Options)
        _G.AutoSkillKeys = type(Options) == "table" and Options or {}
    end
})

AddElement(Tabs.Main, "Button", {
    Title = "Redeem All Codes",
    Desc = "แลกโค้ดทั้งหมดอัตโนมัติ",
    Callback = function()
        RedeemAllCodes()
    end
})

AddElement(Tabs.Settings, "Toggle", {
    Title = "Auto Haki",
    Desc = "Auto enable Armament Haki",
    Flag = "AutoHaki",
    Value = false,
    Callback = function(State)
        ToggleHaki(State)
    end
})

AddElement(Tabs.Settings, "Toggle", {
    Title = "Hide Popup",
    Desc = "ซ่อนหน้าต่าง Popup",
    Flag = "HidePopup",
    Value = false,
    Callback = function(State)
        _G.HidePopupEnabled = State
        if State then
            HidePopup()
        end
    end
})

-- SERVER EVENTS STATUS

local StatusParagraph = Tabs.Item:Paragraph({
    Title = "Server Events Status",
    Desc = "Fetching data...",
    Icon = "lucide-clock"
})

local LastStatusText

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local SeaText = RS:GetAttribute("SeaMonsterSpawnText") or "N/A"
            local GhostText = RS:GetAttribute("GhostShipSpawnText") or "N/A"
            local IsHydra = RS:GetAttribute("Hydra")

            local function CheckStatus(Text)
                return (Text == "0" or Text == "Spawned" or Text == "UNLEASHED")
                    and "SPAWNED!!🟢" or Text
            end

            local NewStatus = string.format(
                "🌊 %s: %s\n🚢 Ghost Ship: %s",
                IsHydra and "Hydra" or "Sea Monster",
                CheckStatus(SeaText),
                CheckStatus(GhostText)
            )

            if NewStatus ~= LastStatusText then
                LastStatusText = NewStatus
                StatusParagraph:SetDesc(NewStatus)
            end
        end)
    end
end)

-- SETTINGS

AddElement(Tabs.Settings, "Input", {
    Title = "Webhook URL",
    Flag = "Webhook_Config",
    Value = "",
    Callback = function(Text)
        _G.WebhookURL = Text
    end
})

AddElement(Tabs.Settings, "Keybind", {
    Title = "Hide Menu",
    Desc = "ปุ่มสำหรับเปิด/ปิดเมนู",
    Value = "LeftControl",
    Flag = "UI_Bind",
    Callback = function(Key)
        _G.HideKey = Key
    end
})

-- LOAD CONFIG

MyConfig:Load()

local WelcomeFolder = "WindUI"
local WelcomeFile = WelcomeFolder .. "/InfernoX_Welcome.dat"

if isfolder and not isfolder(WelcomeFolder) then
    makefolder(WelcomeFolder)
end

if isfile and isfile(WelcomeFile) then
    WindUI:Notify({
        Title = "InfernoX Hub",
        Content = "ยินดีต้อนรับกลับ " .. readfile(WelcomeFile),
        Duration = 3,
        Icon = "user-check"
    })
else
    writefile(WelcomeFile, LP.DisplayName)
end

Tabs.Main:Select()
