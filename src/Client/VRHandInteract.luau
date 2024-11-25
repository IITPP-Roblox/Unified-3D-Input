--Handles a VR hand interacting on the client.
--!strict

local HAND_NAMES = {"LeftHand", "RightHand"}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local VRHandInteract = {}
VRHandInteract.ActiveParts = {}
VRHandInteract.__index = VRHandInteract

export type VRHandInteract = {
    Part: BasePart,
} & typeof(setmetatable({}, VRHandInteract))



--[[
Creates a VR Hand Input.
--]]
function VRHandInteract.new(Part: BasePart): VRHandInteract
    --Create the object.
    local self = setmetatable({
        Part = Part,
    }, VRHandInteract) :: VRHandInteract

    --Store and return the object.
    VRHandInteract.ActiveParts[Part] = self
    return self
end

--[[
Destroys the input.
--]]
function VRHandInteract.Destroy(self: VRHandInteract): ()
    VRHandInteract.ActiveParts[self.Part] = nil
end



--Set up the player's hands intersecting with parts.
if UserInputService.VREnabled then
    local VRHandInteractEvent = script.Parent.Parent:WaitForChild("VRHandInteracted")
    local function CharacterAdded(Character)
        if not Character then return end
        for _, HandName in HAND_NAMES do
            local Hand = Character:WaitForChild(HandName)
            Hand.Touched:Connect(function(TouchPart)
                if not VRHandInteract.ActiveParts[TouchPart] then return end
                VRHandInteractEvent:FireServer(TouchPart)
            end)
        end
    end
    Players.LocalPlayer.CharacterAdded:Connect(CharacterAdded)
    CharacterAdded(Players.LocalPlayer.Character)
end



return VRHandInteract