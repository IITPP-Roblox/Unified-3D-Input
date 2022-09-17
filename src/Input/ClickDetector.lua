--[[
TheNexusAvenger

Input for a ClickDetector.
--]]

local HttpService = game:GetService("HttpService")

local Unified3DInputTypes = require(script.Parent.Parent:WaitForChild("Unified3DInputTypes"))

local ClickDetector = {}
ClickDetector.__index = ClickDetector



--[[
Creates a ClickDetector Input.
--]]
function ClickDetector.new(Input: Unified3DInputTypes.Unified3DInput): Unified3DInputTypes.Input
    return setmetatable({
        Input = Input,
        Enabled = false,
        Properties = {},
    }, ClickDetector)
end

--[[
Updates the properties of the input to use.
--]]
function ClickDetector:UpdateProperties(Properties: table): nil
    for Key, Value in Properties do
        self.Properties[Key] = Value
        if self.ClickDetector then
            self.ClickDetector[Key] = Value
        end
    end
end

--[[
Enables the input.
--]]
function ClickDetector:Enable(): nil
    if self.Enabled then return end
    self.Enabled = true

    --Create and connect the ClickDetector.
    self.ClickDetector = Instance.new("ClickDetector")
    self.ClickDetector.Name = HttpService:GenerateGUID()
    self.ClickDetector.Parent = self.Input.Part
    for Key, Value in self.Properties do
        self.ClickDetector[Key] = Value
    end
    self.ClickDetector.MouseClick:Connect(function(Player)
        self.Input:Activate(Player)
    end)
end

--[[
Disables the input.
--]]
function ClickDetector:Disable(): nil
    if not self.Enabled then return end
    self.Enabled = false

    --Destroy the ClickDetector.
    self.ClickDetector:Destroy()
    self.ClickDetector = nil
end

--[[
Destroys the input.
--]]
function ClickDetector:Destroy(): nil
    self:Disable()
end



return ClickDetector