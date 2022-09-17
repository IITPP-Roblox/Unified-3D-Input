--[[
TheNexusAvenger

Disables non-VR inputs when VR is enabled.
--]]

local UserInputService = game:GetService("UserInputService")

local VRDisableOtherInputs = {}
VRDisableOtherInputs.__index = VRDisableOtherInputs



--[[
Creates a input object disabler.
--]]
function VRDisableOtherInputs.new(Part: BasePart)
    --Create the object.
    local self = {
        Part = Part,
        Events = {},
    }
    setmetatable(self, VRDisableOtherInputs)

    if UserInputService.VREnabled then
        --Connect the inputs.
        table.insert(self.Events, self.Part.DescendantAdded:Connect(function()
            self:UpdateChildren()
        end))
        table.insert(self.Events, self.Part.DescendantRemoving:Connect(function(Child)
            if not self.Events[Child] then return end
            self.Events[Child]:Disconnect()
            self.Events[Child] = nil
        end))
        self:UpdateChildren()
    end

    --Return the object.
    return self
end

--[[
Updates the children of the part.
--]]
function VRDisableOtherInputs:UpdateChildren(): nil
    for _, Child in self.Part:GetDescendants() do
        if not Child:IsA("ClickDetector") and not Child:IsA("ProximityPrompt") then continue end
        if self.Events[Child] then continue end

        Child.MaxActivationDistance = 0
        self.Events[Child] = Child:GetPropertyChangedSignal("MaxActivationDistance"):Connect(function()
            Child.MaxActivationDistance = 0
        end)
    end
end

--[[
Destroys the input.
--]]
function VRDisableOtherInputs:Destroy(): nil
    for _, Event in self.Events do
        Event:Disconnect()
    end
    self.Events = {}
end



return VRDisableOtherInputs