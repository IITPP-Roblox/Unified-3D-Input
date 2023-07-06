--[[
TheNexusAvenger

Demo for an input.
--]]

local Unified3DInput = require(game:GetService("ReplicatedStorage"):WaitForChild("Unified3DInput"))

local Part = Instance.new("Part")
Part.Material = Enum.Material.Neon
Part.BrickColor = BrickColor.new("Bright green")
Part.Size = Vector3.new(2, 2, 2)
Part.CFrame = CFrame.new(0, 3, -10)
Part.Anchored = true
Part.Parent = game:GetService("Workspace")

local Input = Unified3DInput.new(Part)
    :SetMaxActivationDistance(20)
    :AddInput("ClickDetector")
    :AddInput("ProximityPrompt", {ActionText = "Activate", ObjectText = "Test Button", HoldDuration = 0.5, Offset = Vector3.new(0, 0, 0.5)})
    :AddInput("VRHandInteract", {DisableProximityPrompts = true})

Input.Activated:Connect(function(Player, Distance)
    print(tostring(Player).." activated at a distance of "..tostring(Distance))
    Input:Disable()
    Part.BrickColor = BrickColor.new("Bright red")
    task.wait(0.5)

    Input:Enable()
    Part.BrickColor = BrickColor.new("Bright green")
end)