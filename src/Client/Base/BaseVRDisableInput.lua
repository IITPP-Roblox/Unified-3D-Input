--[[
TheNexusAvenger

Disables non-VR inputs when VR is enabled.
--]]

local UserInputService = game:GetService("UserInputService")

return function(ClassName: string)
    local BaseVRDisableInputs = {}
    BaseVRDisableInputs.__index = BaseVRDisableInputs

    --[[
    Creates a input object disabler.
    --]]
    function BaseVRDisableInputs.new(Part: BasePart)
        --Create the object.
        local self = {
            Part = Part,
            Events = {},
        }
        setmetatable(self, BaseVRDisableInputs)

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
    function BaseVRDisableInputs:UpdateChildren(): ()
        for _, Child in self.Part:GetDescendants() do
            if not Child:IsA(ClassName) then continue end
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
    function BaseVRDisableInputs:Destroy(): ()
        for _, Event in self.Events do
            Event:Disconnect()
        end
        self.Events = {}
    end

    return BaseVRDisableInputs
end