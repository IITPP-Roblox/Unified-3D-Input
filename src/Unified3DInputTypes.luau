--Types used by Unified3DInput.
--!strict

export type Input = {
    Enable: (Input) -> (),
    Disable: (Input) -> (),
    UpdateProperties: (Input, {[string]: any}) -> (),
    Destroy: (Input) -> (),
}
export type Unified3DInput = {
    Part: BasePart,
    SetMaxActivationDistance: (Unified3DInput, number) -> Unified3DInput,
    AddInput: (Unified3DInput, string, {[string]: any}?) -> Unified3DInput,
    Enable: (Unified3DInput) -> (),
    Disable: (Unified3DInput) -> (),
    Activate: (Unified3DInput, Player: Player) -> (),
    Destroy: (Unified3DInput) -> (),
    Activated: RBXScriptSignal,
}



return {}