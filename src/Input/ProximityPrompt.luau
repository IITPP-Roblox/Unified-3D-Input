--Input for a ProximityPrompt.
--!strict

local HttpService = game:GetService("HttpService")

local Unified3DInputTypes = require(script.Parent.Parent:WaitForChild("Unified3DInputTypes"))

local ProximityPrompt = {}
ProximityPrompt.__index = ProximityPrompt

export type ProximityPromptInput = {
    Input: Unified3DInputTypes.Unified3DInput,
    Enabled: boolean,
    Properties: {[string]: any},
    ProximityPromptAttachment: Attachment?,
    ProximityPrompt: ProximityPrompt?,
} & typeof(setmetatable({}, ProximityPrompt)) & Unified3DInputTypes.Input



--[[
Creates a ProximityPrompt Input.
--]]
function ProximityPrompt.new(Input: Unified3DInputTypes.Unified3DInput): ProximityPromptInput
    return setmetatable({
        Input = Input,
        Enabled = false,
        Properties = {},
    }, ProximityPrompt) :: ProximityPromptInput
end

--[[
Updates the properties of the input to use.
--]]
function ProximityPrompt.UpdateProperties(self: ProximityPromptInput, Properties: {[string]: any}): ()
    for Key, Value in Properties do
        self.Properties[Key] = Value
        if self.ProximityPrompt and Key ~= "Offset" then
            (self.ProximityPrompt :: any)[Key] = Value
        end
    end
    if Properties["Offset"] then
        self:UpdateOffset()
    end
end

--[[
Updates the offset of the ProximityPrompt.
--]]
function ProximityPrompt.UpdateOffset(self: ProximityPromptInput): ()
    if not self.ProximityPrompt then return end
    if not self.Properties["Offset"] then
        self.ProximityPrompt.Parent = self.Input.Part
        if self.ProximityPromptAttachment then
            self.ProximityPromptAttachment:Destroy()
            self.ProximityPromptAttachment = nil
        end
        return
    end

    --Create the attachment.
    if not self.ProximityPromptAttachment then
        local ProximityPromptAttachment = Instance.new("Attachment")
        ProximityPromptAttachment.Name = HttpService:GenerateGUID()
        ProximityPromptAttachment.Parent = self.Input.Part
        ProximityPrompt.Parent = self.ProximityPromptAttachment
        self.ProximityPromptAttachment = ProximityPromptAttachment
    end
    (self.ProximityPromptAttachment :: Attachment).Position = self.Properties["Offset"]
end

--[[
Enables the input.
--]]
function ProximityPrompt.Enable(self: ProximityPromptInput): ()
    if self.Enabled then return end
    self.Enabled = true

    --Create and connect the ProximityPrompt.
    local ProximityPrompt = Instance.new("ProximityPrompt")
    ProximityPrompt.Name = HttpService:GenerateGUID()
    ProximityPrompt.Parent = self.Input.Part
    for Key, Value in self.Properties do
        if Key ~= "Offset" then
            (ProximityPrompt :: any)[Key] = Value
        end
    end
    ProximityPrompt.Triggered:Connect(function(Player)
        self.Input:Activate(Player)
    end)
    self.ProximityPrompt = ProximityPrompt
    self:UpdateOffset()
end

--[[
Disables the input.
--]]
function ProximityPrompt.Disable(self: ProximityPromptInput): ()
    if not self.Enabled then return end
    self.Enabled = false

    --Destroy the ProximityPrompt.
    if self.ProximityPrompt then
        self.ProximityPrompt:Destroy()
    end
    self.ProximityPrompt = nil
    if self.ProximityPromptAttachment then
        self.ProximityPromptAttachment:Destroy()
        self.ProximityPromptAttachment = nil
    end
end

--[[
Destroys the input.
--]]
function ProximityPrompt.Destroy(self: ProximityPromptInput): ()
    self:Disable()
end



return ProximityPrompt