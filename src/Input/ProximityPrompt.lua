--[[
TheNexusAvenger

Input for a ProximityPrompt.
--]]

local HttpService = game:GetService("HttpService")

local Unified3DInputTypes = require(script.Parent.Parent:WaitForChild("Unified3DInputTypes"))

local ProximityPrompt = {}
ProximityPrompt.__index = ProximityPrompt



--[[
Creates a ProximityPrompt Input.
--]]
function ProximityPrompt.new(Input: Unified3DInputTypes.Unified3DInput): Unified3DInputTypes.Input
    return setmetatable({
        Input = Input,
        Enabled = false,
        Properties = {},
    }, ProximityPrompt)
end

--[[
Updates the properties of the input to use.
--]]
function ProximityPrompt:UpdateProperties(Properties: table): nil
    for Key, Value in Properties do
        self.Properties[Key] = Value
        if self.ProximityPrompt and Key ~= "Offset" then
            self.ProximityPrompt[Key] = Value
        end
    end
    if Properties["Offset"] then
        self:UpdateOffset()
    end
end

--[[
Updates the offset of the ProximityPrompt.
--]]
function ProximityPrompt:UpdateOffset(): nil
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
        self.ProximityPromptAttachment = Instance.new("Attachment")
        self.ProximityPromptAttachment.Name = HttpService:GenerateGUID()
        self.ProximityPromptAttachment.Parent = self.Input.Part
        self.ProximityPrompt.Parent = self.ProximityPromptAttachment
    end
    self.ProximityPromptAttachment.Position = self.Properties["Offset"]
end

--[[
Enables the input.
--]]
function ProximityPrompt:Enable(): nil
    if self.Enabled then return end
    self.Enabled = true

    --Create and connect the ProximityPrompt.
    self.ProximityPrompt = Instance.new("ProximityPrompt")
    self.ProximityPrompt.Name = HttpService:GenerateGUID()
    self.ProximityPrompt.Parent = self.Input.Part
    for Key, Value in self.Properties do
        if Key ~= "Offset" then
            self.ProximityPrompt[Key] = Value
        end
    end
    self.ProximityPrompt.Triggered:Connect(function(Player)
        self.Input:Activate(Player)
    end)
    self:UpdateOffset()
end

--[[
Disables the input.
--]]
function ProximityPrompt:Disable(): nil
    if not self.Enabled then return end
    self.Enabled = false

    --Destroy the ProximityPrompt.
    self.ProximityPrompt:Destroy()
    self.ProximityPrompt = nil
    if self.ProximityPromptAttachment then
        self.ProximityPromptAttachment:Destroy()
        self.ProximityPromptAttachment = nil
    end
end

--[[
Destroys the input.
--]]
function ProximityPrompt:Destroy(): nil
    self:Disable()
end



return ProximityPrompt