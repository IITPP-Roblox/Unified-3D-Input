--[[
TheNexusAvenger

Main module for Unified 3D Input.
--]]

local CollectionService = game:GetService("CollectionService")

local Unified3DInputTypes = require(script:WaitForChild("Unified3DInputTypes"))

local Unified3DInput = {}
Unified3DInput.__index = Unified3DInput



--[[
Creates a Unified 3D Input.
--]]
function Unified3DInput.new(Part: BasePart): Unified3DInputTypes.Unified3DInput
    --Create the object.
    local self = {
        Part = Part,
        Enabled = true,
        Inputs = {},
        MaxActivationDistance = 32,
    }
    setmetatable(self, Unified3DInput)
    self.ActivatedEvent = Instance.new("BindableEvent")
    self.Activated = self.ActivatedEvent.Event

    --Return the object.
    return self
end

--[[
Sets up the client.
--]]
function Unified3DInput.SetUpClient()
    if Unified3DInput.ClientInitialized then return end
    Unified3DInput.ClientInitialized = true

    --[[
    Sets up an input module.
    --]]
    local function SetUpInputModule(InputModule: ModuleScript)
        local InputClass = require(InputModule)
        local InputTag = "Unified3DInput_"..InputModule.Name
        local PartToInput = {}
        CollectionService:GetInstanceAddedSignal(InputTag):Connect(function(Part)
            PartToInput[Part] = InputClass.new(Part)
        end)
        CollectionService:GetInstanceRemovedSignal(InputTag):Connect(function(Part)
            if not PartToInput[Part] then return end
            PartToInput[Part]:Destroy()
            PartToInput[Part] = nil
        end)
        for _, Part in CollectionService:GetTagged(InputTag) do
            PartToInput[Part] = InputClass.new(Part)
        end
    end

    --Set up the client input moduules.
    for _, Module in script:WaitForChild("Client"):GetChildren() do
        SetUpInputModule(Module)
    end
    script:WaitForChild("Client").ChildAdded:Connect(SetUpInputModule)
end

--[[
Sets the MaxActivationDistance.
Returns itself to allow chaining.
--]]
function Unified3DInput:SetMaxActivationDistance(MaxActivationDistance: number): Unified3DInputTypes.Unified3DInput
    self.MaxActivationDistance = MaxActivationDistance
    for _, Input in self.Inputs do
        Input:UpdateProperties({MaxActivationDistance = MaxActivationDistance})
    end
    return self
end

--[[
Adds an input.
Returns itself to allow chaining.
--]]
function Unified3DInput:AddInput(InputName: string, Properties: table?): Unified3DInputTypes.Unified3DInput
    --Raise an error if the input was already created.
    if self.Inputs[InputName] then
        error("Input already createD: "..tostring(InputName))
    end

    --Raise an error if the input does not exist.
    local InputModule = script:WaitForChild("Input"):FindFirstChild(InputName)
    if not InputModule then
        error("Input type is unknown: "..tostring(InputName))
    end

    --Create an add the input.
    local Input = require(InputModule).new(self)
    if Input.UpdateProperties then
        Input:UpdateProperties({MaxActivationDistance = self.MaxActivationDistance})
        if Properties then
            Input:UpdateProperties(Properties)
        end
    end
    self.Inputs[InputName] = Input
    if self.Enabled then
        task.spawn(function()
            Input:Enable()
        end)
    end

    --Return self to allow chaining.
    return self
end

--[[
Enables the input.
--]]
function Unified3DInput:Enable(): nil
    if self.Enabled then return end
    self.Enabled = true
    for _, Input in self.Inputs do
        Input:Enable()
    end
end

--[[
Disables the input.
--]]
function Unified3DInput:Disable(): nil
    if not self.Enabled then return end
    self.Enabled = false
    for _, Input in self.Inputs do
        Input:Disable()
    end
end

--[[
Activates the input for a player.
--]]
function Unified3DInput:Activate(Player: Player): nil
    if not self.Enabled then return end

    --Return if the player distance can't be calculated.
    local Character = Player.Character
    if not Character then return end
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    if not HumanoidRootPart then return end

    --Fire the event with the distance.
    self.ActivatedEvent:Fire(Player, (self.Part.Position - HumanoidRootPart.Position).Magnitude)
end

--[[
Destroys the input.
--]]
function Unified3DInput:Destroy(): nil
    self.ActivatedEvent:Destroy()
    for _, Input in self.Inputs do
        Input:Destroy()
    end
    self.Inputs = {}
end



return Unified3DInput