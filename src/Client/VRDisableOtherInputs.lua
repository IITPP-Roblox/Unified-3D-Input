--[[
TheNexusAvenger

Disables non-VR inputs when VR is enabled.
--]]

local CollectionService = game:GetService("CollectionService")
local UserInputService = game:GetService("UserInputService")

local VRDisableOtherInputs = {}
VRDisableOtherInputs.PartsToInputs = {}
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
    VRDisableOtherInputs.PartsToInputs[Part] = self

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
function VRDisableOtherInputs:UpdateChildren(): ()
    local TagsMap = {}
    for _, Tag in CollectionService:GetTags(self.Part) do
        TagsMap[Tag] = true
    end
    for _, Child in self.Part:GetDescendants() do
        if not TagsMap["Disable"..Child.ClassName.."s"] then continue end
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
function VRDisableOtherInputs:Destroy(): ()
    for _, Event in self.Events do
        Event:Disconnect()
    end
    self.Events = {}
    VRDisableOtherInputs.PartsToInputs[self.Part] = nil
end



--Connect changing tags.
for _, Tag in {"DisableClickDetectors", "DisableProximityPrompts"} do
    CollectionService:GetInstanceAddedSignal(Tag):Connect(function(Part)
        if not VRDisableOtherInputs.PartsToInputs[Part] then return end
        VRDisableOtherInputs.PartsToInputs:UpdateChildren()
    end)
    CollectionService:GetInstanceRemovedSignal(Tag):Connect(function(Part)
        if not VRDisableOtherInputs.PartsToInputs[Part] then return end
        VRDisableOtherInputs.PartsToInputs:UpdateChildren()
    end)
end



return VRDisableOtherInputs