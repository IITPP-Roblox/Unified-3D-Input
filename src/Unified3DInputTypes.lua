--[[
TheNexusAvenger

Types used by Unified3DInput.
--]]

export type Input = {
    Enable: (Input) -> (),
    Disable: (Input) -> (),
    UpdateProperties: (Input, {[string]: any}) -> (),
    Destroy: (Input) -> (),
}
export type Unified3DInput = {
    SetMaxActivationDistance: (Unified3DInput, number) -> Unified3DInput,
    AddInput: (Unified3DInput, string, {[string]: any}?) -> Unified3DInput,
    Enable: (Unified3DInput) -> (),
    Disable: (Unified3DInput) -> (),
    Destroy: (Unified3DInput) -> (),
    Activated: RBXScriptSignal,
}



return {}