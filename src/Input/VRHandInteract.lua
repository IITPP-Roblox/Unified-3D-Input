--[[
TheNexusAvenger

Input for a VR hand interacting.
--]]

local INPUT_TAGS = {"DisableClickDetectors", "DisableProximityPrompts"}

local CollectionService = game:GetService("CollectionService")

local Unified3DInputTypes = require(script.Parent.Parent:WaitForChild("Unified3DInputTypes"))

local VRHandInteract = {}
VRHandInteract.PartsToInputs = {}
VRHandInteract.__index = VRHandInteract

local VRHandInteractedEvent = Instance.new("RemoteEvent")
VRHandInteractedEvent.Name = "VRHandInteracted"
VRHandInteractedEvent.Parent = script.Parent.Parent
VRHandInteractedEvent.OnServerEvent:Connect(function(Player, Part)
    if not VRHandInteract.PartsToInputs[Part] then return end
    VRHandInteract.PartsToInputs[Part]:Activate(Player)
end)



--[[
Creates a VR Hand Input.
--]]
function VRHandInteract.new(Input: Unified3DInputTypes.Unified3DInput): Unified3DInputTypes.Input
    return setmetatable({
        Input = Input,
        Enabled = false,
    }, VRHandInteract) :: any
end

--[[
Updates the properties of the input to use.
--]]
function VRHandInteract:UpdateProperties(Properties: {[string]: any}): ()
    for _, Tag in INPUT_TAGS do
        if Properties[Tag] ~= nil then
            if Properties[Tag] then
                CollectionService:AddTag(self.Input.Part, "Unified3DInput_VR"..Tag)
            else
                CollectionService:RemoveTag(self.Input.Part, "Unified3DInput_VR"..Tag)
            end
        end
    end
end

--[[
Enables the input.
--]]
function VRHandInteract:Enable(): ()
    if self.Enabled then return end
    self.Enabled = true

    CollectionService:AddTag(self.Input.Part, "Unified3DInput_VRHandInteract")
    self.PartsToInputs[self.Input.Part] = self.Input
end

--[[
Disables the input.
--]]
function VRHandInteract:Disable(): ()
    if not self.Enabled then return end
    self.Enabled = false

    CollectionService:RemoveTag(self.Input.Part, "Unified3DInput_VRHandInteract")
    self.PartsToInputs[self.Input.Part] = nil
end

--[[
Destroys the input.
--]]
function VRHandInteract:Destroy(): ()
    self:Disable()
    for _, Tag in INPUT_TAGS do
        CollectionService:RemoveTag(self.Input.Part, "Unified3DInput_VR"..Tag)
    end
end



return VRHandInteract