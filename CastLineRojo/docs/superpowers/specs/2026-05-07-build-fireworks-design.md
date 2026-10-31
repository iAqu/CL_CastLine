# Build Completion Fireworks Design

## Goal

Add fireworks to the building flow and align the effect with the `Build A Bridge` reference project.

When a layer finishes building, play one firework at the final brick position. When the whole building finishes, play five fireworks at that same final brick position.

## Reference Effect

The reference project uses `ReplicatedStorage.Assets.VFX.Firework`:

- A transparent anchored `Part` named `Firework`.
- `Fly` and `Explode` sounds under the part.
- `A1` and `A2` attachments connected by a `Trail`.
- An `Attachment` containing multiple `ParticleEmitter` children.

The playback behavior is:

- Clone `Firework` into a temporary runtime container.
- Place it at the requested world position.
- Tween it upward by about 14 studs over 0.7 seconds.
- Play `Fly` during ascent.
- Stop `Fly`, play `Explode`, and emit 20 particles from each child particle emitter.
- Clean up the clone after about 5 seconds.

## Resource Plan

Use MCP to copy the complete `ReplicatedStorage.Assets.VFX.Firework` instance tree from the `Build A Bridge` Studio project into `DB_DEV`.

The target path in `DB_DEV` is:

`ReplicatedStorage.Assets.VFX.Firework`

If `Assets` or `VFX` does not exist, create it. If `Firework` already exists, do not overwrite it silently; preserve the existing instance by backing it up or ask before replacing it.

The copied resource must retain the full reference instance tree, properties, sound IDs, trail attachments, particle emitter settings, and attachment structure.

## Code Plan

Implement playback in `BuildController` because build visuals are already client-owned there and the controller receives `FightService.BuildProgressEvent`.

On a delta build payload:

- If `completedLayerId` is absent, do not play fireworks.
- If `completedLayerId` is present, use the last item in `completedPartKeys` to resolve the final brick.
- Play at that brick's world position after the normal reveal delay enough for the brick to exist visually.
- If `completedCount >= totalCount`, play five fireworks at the same position.
- Otherwise, play one firework.

Do not play fireworks for `sync` or `reset_sync` payloads. This prevents effects from replaying when a client joins, refreshes, resyncs existing progress, or resets build state.

For other players' slots, use the same delta payload and resolve the last completed part in that slot state. If the local model or part is unavailable, skip the effect without interrupting building.

## Safety And Error Handling

If `ReplicatedStorage.Assets.VFX.Firework` is missing, warn once and skip the firework effect. Building must continue normally.

If the target part is missing or destroyed, skip the firework. Do not synthesize a fallback position that could produce effects in the wrong location.

All firework clones should be cleaned with `Debris` to avoid leaking temporary instances.

## Verification

Verify in `DB_DEV` through Studio/Rojo:

- Completing a non-final layer plays one firework at the final brick position.
- Completing the whole building plays five fireworks at the final brick position.
- Existing progress sync does not play old fireworks.
- Resetting progress does not play fireworks.
- Missing or unavailable local parts do not break build progression.
