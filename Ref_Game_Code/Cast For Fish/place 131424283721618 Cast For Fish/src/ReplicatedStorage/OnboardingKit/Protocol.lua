-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    KitVersion = "1.0.0",
    DataVersion = 3,
    RemoteName = "Push",
    RecordingAttribute = "OnboardingRecording",
    SessionAttribute = "OnboardingSessionId",
    ClientFlushSeconds = 5,
    ServerSaveSeconds = 60,
    JoinStatsSaveSeconds = 300,
    PerfSampleSeconds = 5,
    MoveSampleSeconds = 1,
    IdleSeconds = 4,
    MinBatchInterval = 3,
    MaxEventsPerBatch = 150,
    MaxEventsPerSession = 4000,
    MaxPayloadBytes = 3800000,
    MaxFields = 24,
    MaxString = 120,
    MaxEarlyLeaves = 500,
    EventTypes = table.freeze({
        Start = true,
        Input = true,
        Release = true,
        Button = true,
        Stage = true,
        Prog = true,
        Mark = true,
        Move = true,
        Idle = true,
        Tool = true,
        Prompt = true,
        Viewport = true,
        Focus = true,
        Perf = true,
        Load = true,
        End = true
    }),
    ServerOnly = table.freeze({
        Prog = true,
        Mark = true,
        End = true
    })
}

return table.freeze(t1)
