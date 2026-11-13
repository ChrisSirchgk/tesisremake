# Contributing Guidelines

## Branch Strategy

- Use feature branches from the integration branch:
  - `feature/gameplay-*`
  - `feature/network-*`
  - `feature/progression-*`
- Keep pull requests scoped to one subsystem whenever possible.

## Module Ownership

- **Angel Bustos:** networking, dedicated server, synchronization
- **Chris Aguilera:** gameplay, combat, enemies, procedural generation
- **Isaac Hernandez:** UI, progression, visual integration

## Development Rules

- Maintain Godot 4.x compatibility.
- Preserve existing functional networking, UI, and progression modules.
- Prefer composition and event-driven communication over direct cross-module coupling.
- Avoid introducing external dependencies unless justified and reviewed.
- Keep side-scrolling gameplay logic deterministic/state-oriented for future authoritative sync.

## Code Style

- Use descriptive GDScript names and typed variables where practical.
- Keep scripts small and purpose-focused.
- Add concise documentation for public APIs and shared module boundaries.

## Verification Checklist

Before opening a pull request:

1. Open project in Godot and confirm no startup errors.
2. Verify the side-scrolling prototype scene runs and player movement/jump/gravity work.
3. Confirm no broken scene/script/resource paths.
4. Update docs/API contracts when module interfaces change.
