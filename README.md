# Unified-3D-Input
Unified 3D Input is a system developed for the [Innovation Inc Thermal Power Plant on Roblox](https://www.roblox.com/games/2337178805/Innovation-Inc-Thermal-Power-Plant)
to centralize multiple inputs with a common interface.

# Setup
## Project
This project uses [Rojo](https://github.com/rojo-rbx/rojo) for the project
structure. Two project files in included in the repository.
* `default.project.json` - Structure for just the module. Intended for use
  with `rojo build` and to be included in Rojo project structures as a
  dependency.
* `demo.project.json` - Full Roblox place that can be synced into Roblox
  studio and ran with demo models.

## Game
Unified 3D Input can be placed anywhere in the game and does not require
any additional server setup beyond setting up individual inputs. On the
client, there is optional setup depending on the inputs used. VR inputs
require client setup, which is done with the following assuming `Unified3DInput`
is directly in `ReplicatedStorage`.

```lua
require(game:GetService("ReplicatedStorage"):WaitForChild("Unified3DInput")):SetUpClient()
```

# API
## Part Inputs
### `Unified3DInput.new(Part: BasePart): Unified3DInput`
Creates a Unified 3D Input.

### `Unified3DInput.Activated: CustomEvent`
Event that is fired when the input is activated. The input parameters
are the player that activated the input and the distance the player
activated it at. Due to replication delays, it may be higher than
the max activation distance.

### `Unified3DInput:SetMaxActivationDistance(MaxActivationDistance: number): Unified3DInput`
Sets the MaxActivationDistance of all the inputs.
Returns itself to allow chaining.

### `Unified3DInput:AddInput(InputName: string, Properties: table?): Unified3DInput`
Adds an input. The name of the input is the input type to add (included
ones are `"ClickDetector"`, `"ProximityPrompt"`, and `"VRHandInteract"`) and
the properties is an optional table of properties to set for the inputs.
The properties for each of the included ones include:
* `ClickDetector` - Any property of a `ClickDetector`. `Parent` and
  `MaxActivationDistance` are unsupported.
* `ProximityPrompt` - Any property of a `ProximityPrompt`. `Parent`,
  `MaxActivationDistance`, and `Enabled` are unsupported.
* `"VRHandInteract"` - Only a bool value for `DisableOtherInputs` is
  supported, which makes it so VR users have to physically touch the part.

Returns itself to allow chaining.

### `Unified3DInput:Enable(): nil`
Enables the input.

### `Unified3DInput:Disable(): nil`
Disables the input.

### `Unified3DInput:Destroy(): nil`
Destroys the input.

## Custom Inputs
Custom inputs can be added to the module in the `Input` folder. They are
expected to have the following implemented.

### `Input.new(Input: Unified3DInput): Input`
Creates the input for a Unified3DInput, which is passed in as a parameter.

### `Input:UpdateProperties?(Properties: table): nil`
Optional function that sets the properties for the input. It will be called
once when it is created with properties and when `SetMaxActivationDistance`
is called. If it isn't implemented, it will not be called.

### `Input:Enable(): nil`
Enables the input.

### `Input:Disable(): nil`
Disables the input.

### `Input:Destroy(): nil`
Destroys the input.

# License
This project is available under the terms of the MIT License. See [LICENSE](LICENSE)
for details.