local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

OrionLib:MakeNotification({
    Name = "Script Chargé",
    Content = "Le script a été chargé avec succès. < Chapkaman >",
    Image = "rbxassetid://4483345998",
    Time = 10
})

local Window = OrionLib:MakeWindow({
    Name = "Chapka-Scripts",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "chapkamanconfig",
    IntroEnabled = true,
    IntroText = "Chargement en cours..."
})

local flying = false
local speed = 0

local function Fly()
    local plr = game.Players.LocalPlayer
    local torso = plr.Character:WaitForChild("HumanoidRootPart")
    local mouse = plr:GetMouse()
    
    local bg = Instance.new("BodyGyro", torso)
    bg.P = 9e4
    bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.cframe = torso.CFrame
    
    local bv = Instance.new("BodyVelocity", torso)
    bv.velocity = Vector3.new(0, 0.1, 0)
    bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
    
    flying = true
    
    while flying do
        plr.Character.Humanoid.PlatformStand = true
        
        if speed > 0 then
            bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * Vector3.new(speed, speed, speed)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(0, 0, -1).p) - game.Workspace.CurrentCamera.CoordinateFrame.p)) * 10
        else
            bv.velocity = Vector3.new(0, 0.1, 0)
        end
        
        bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad(speed * 2), 0, 0)
        wait()
    end
    
    bv:Destroy()
    bg:Destroy()
    plr.Character.Humanoid.PlatformStand = false
end

local function StopFlying()
    flying = false
end

local function NoClip()
    local plr = game.Players.LocalPlayer
    local char = plr.Character
    if char then
        for _, child in ipairs(char:GetDescendants()) do
            if child:IsA("BasePart") then
                child.CanCollide = not noClipEnabled
            end
        end
    end
end

local MovementTab = Window:MakeTab({
    Name = "Mouvement"
})

local flyToggle = MovementTab:AddToggle({
    Name = "Activer Fly",
    Default = false,
    Callback = function(Value)
        if Value then
            Fly()
        else
            StopFlying()
        end
    end
})

local noClipToggle = MovementTab:AddToggle({
    Name = "No Clip",
    Default = false,
    Callback = function(Value)
        noClipEnabled = Value
        NoClip()
    end
})

local speedDropdown = MovementTab:AddDropdown({
    Name = "Vitesse Fly",
    Default = "Lent",
    Options = {"Lent", "Moyen", "Rapide", "Extrême esh", "Flash MCQUEEN"},
    Callback = function(Value)
        if Value == "Lent" then
            speed = 1
        elseif Value == "Moyen" then
            speed = 5
        elseif Value == "Rapide" then
            speed = 12
        elseif Value == "Extrême esh" then
            speed = 30
        elseif Value == "Flash MCQUEEN" then
            speed = 200
        end
    end
})

local OtherTab = Window:MakeTab({Name = "Autres"})

local isAntiAFKEnabled = false

OtherTab:AddToggle({
    Name = "Activer Anti-AFK",
    Default = false,
    Callback = function(Value)
        isAntiAFKEnabled = Value

        if isAntiAFKEnabled then
            print("Anti-AFK activé")
            
            coroutine.wrap(function()
                local keyCodes = {
                    Enum.KeyCode.W,
                    Enum.KeyCode.A,
                    Enum.KeyCode.S,
                    Enum.KeyCode.D,
                    Enum.KeyCode.Space,
                }
                
                while isAntiAFKEnabled do
                    local randomKeyCode = keyCodes[math.random(1, #keyCodes)]
                    local inputObject = Instance.new("InputObject", game)
                    inputObject.UserInputType = Enum.UserInputType.Keyboard
                    inputObject.KeyCode = randomKeyCode
                    inputObject.InputState = Enum.InputState.Begin

                    wait(0.05)

                    inputObject.InputState = Enum.InputState.End
                    wait(0.05)
                    inputObject:Destroy()

                    wait(math.random(2, 10))
                end
            end)()
        end
    end
})

local VisualTab = Window:MakeTab({
    Name = "Visuels"
})

local espToggle = VisualTab:AddToggle({
    Name = "Activer ESP",
    Default = false,
    Callback = function(Value)
        if Value then
            for _, player in pairs(game.Players:GetPlayers()) do
                local nameLabel = Instance.new("BillboardGui")
                nameLabel.Name = "NameLabel"
                nameLabel.Size = UDim2.new(0, 100, 0, 20)
                nameLabel.AlwaysOnTop = true
                nameLabel.Adornee = player.Character.Head
                nameLabel.StudsOffset = Vector3.new(0, 7, 0)  -- Augmenter la valeur pour afficher le nom plus haut
                
                local textLabel = Instance.new("TextLabel")
                textLabel.Text = player.Name
                textLabel.BackgroundTransparency = 1
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.TextColor3 = Color3.new(1, 1, 1)
                textLabel.Font = Enum.Font.SourceSansBold
                textLabel.TextSize = 18  -- Augmenter la valeur pour augmenter la taille du texte
                
                textLabel.Parent = nameLabel
                nameLabel.Parent = game.CoreGui
            end
        else
            for _, nameLabel in pairs(game.CoreGui:GetChildren()) do
                if nameLabel:IsA("BillboardGui") and nameLabel.Name == "NameLabel" then
                    nameLabel:Destroy()
                end
            end
        end
    end
})

local LeaveTab = Window:MakeTab({
    Name = "Quitter"
})

LeaveTab:AddButton({
    Name = "Détruire l'interface",
    Callback = function()
        StopFlying()
        OrionLib:MakeNotification({
            Name = "Le script s'auto détruira dans 5 secondes.",
            Content = "KABOOOOOOOOOOM",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
        wait(5)
        OrionLib:Destroy()
    end
})

OrionLib:Init()
