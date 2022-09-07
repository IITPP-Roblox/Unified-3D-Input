--[[
TheNexusAvenger

Types used by Unified3DInput.
--]]

export type Input = {
    Enable: (Input) -> nil,
    Disable: (Input) -> nil,
    UpdateProperties: (Input, table) -> nil,
    Destroy: (Input) -> nil,
}
export type Unified3DInput = {
    SetMaxActivationDistance: (Unified3DInput, number) -> Unified3DInput,
    AddInput: (Unified3DInput, string, table?) -> Unified3DInput,
    Enable: (Unified3DInput) -> nil,
    Disable: (Unified3DInput) -> nil,
    Destroy: (Unified3DInput) -> nil,
    Activated: CustomEvent,
}



return {}