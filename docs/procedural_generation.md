# Procedural Generation Direction

The project now targets side-scrolling action-platformer runs built from interconnected handcrafted platforming rooms.

## Room Model

- Rooms are authored as platforming chunks with traversal intent (combat lane, vertical climb, jump puzzle, reward branch).
- Generation assembles a directed room graph with valid entry/exit connections and traversal continuity.
- Encounter, loot, and checkpoint placement decorate rooms after graph assembly.

## Constraints for Multiplayer and Sync

- Generated room graph must be deterministic from a shared seed and generation settings.
- Traversal-critical collision geometry and spawn points are authoritative-server owned.
- Clients receive validated room-state updates and render-only hints.

## Implementation Ownership

- Chris Aguilera: gameplay/combat/enemies/procedural generation implementation
- Angel Bustos: network synchronization of generated room state
- Isaac Hernandez: UI/progression/visual integration for run feedback and unlock flows
