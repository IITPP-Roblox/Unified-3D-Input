--Input for a ClickDetector.
--!strict

local HttpService = game:GetService("HttpService")

local Unified3DInputTypes = require(script.Parent.Parent:WaitForChild("Unified3DInputTypes"))

local ClickDetector = {}
ClickDetector.__index = ClickDetector

export type ClickDetectorInput = {
    Input: Unified3DInputTypes.Unified3DInput,
    Enabled: boolean,
    Properties: {[string]: any},
    ClickDetector: ClickDetector?,
} & typeof(setmetatable({}, ClickDetector)) & Unified3DInputTypes.Input



--[[
Creates a ClickDetector Input.
--]]
function ClickDetector.new(Input: Unified3DInputTypes.Unified3DInput): ClickDetectorInput
    return setmetatable({
        Input = Input,
        Enabled = false,
        Properties = {},
    }, ClickDetector) :: ClickDetectorInput
end

--[[
Updates the properties of the input to use.
--]]
function ClickDetector.UpdateProperties(self: ClickDetectorInput, Properties: {[string]: any}): ()
    for Key, Value in Properties do
        self.Properties[Key] = Value
        if self.ClickDetector then
            (self.ClickDetector :: any)[Key] = Value
        end
    end
end

--[[
Enables the input.
--]]
function ClickDetector.Enable(self: ClickDetectorInput): ()
    if self.Enabled then return end
    self.Enabled = true

    --Create and connect the ClickDetector.
    local ClickDetector = Instance.new("ClickDetector")
    ClickDetector.Name = HttpService:GenerateGUID()
    ClickDetector.Parent = self.Input.Part
    self.ClickDetector = ClickDetector
    for Key, Value in self.Properties :: {[string]: any} do
        (self.ClickDetector :: any)[Key] = Value
    end
    ClickDetector.MouseClick:Connect(function(Player)
        self.Input:Activate(Player)
    end)
end

--[[
Disables the input.
--]]
function ClickDetector.Disable(self: ClickDetectorInput): ()
    if not self.Enabled then return end
    self.Enabled = false

    --Destroy the ClickDetector.
    if self.ClickDetector then
        self.ClickDetector:Destroy()
    end
    self.ClickDetector = nil
end

--[[
Destroys the input.
--]]
function ClickDetector.Destroy(self: ClickDetectorInput): ()
    self:Disable()
end



return ClickDetector