# Architecture Overview

## Goals

- Modular Godot 4 project ready for three concurrent contributors
- Separation between gameplay, networking/server, and progression systems
- Authoritative multiplayer architecture with a dedicated headless server process
- Side-scrolling action-platformer roguelike foundation with extensible combat and run progression

## High-Level Modules

- **Core (`scripts/core`)**
  - Shared event bus (`GameEvents`) for low-coupling communication.
- **Networking (`scripts/networking`)**
  - Client/server session setup, ENet transport, replication orchestration.
  - Maintains client intent -> server authority direction.
- **Server (`scripts/server`)**
  - Dedicated authoritative simulation entry points and runtime orchestration.
- **Gameplay (`scripts/gameplay`)**
  - `SideScrollerPlayer` controller for horizontal movement, gravity, jumping, and future combat/ability hooks.
  - Side-scrolling entities, combat, interactions, and enemy encounters.
- **Procedural Generation (`scripts/procedural_generation`)**
  - Connected graph of handcrafted platforming rooms (instead of top-down dungeon rooms).
  - Encounter placement, traversal gates, and reward distribution.
- **Progression (`scripts/progression`)**
  - Save/load and persistent unlock systems via local JSON files.
- **UI (`scripts/ui`, `scenes/main`)**
  - Main menu and in-game interface flows.

## Scene Composition

- `res://scenes/main/Main.tscn` remains the project entry scene.
- Main menu launches `res://scenes/gameplay/PrototypeLevel.tscn` for playable platforming tests.
- Prototype level contains placeholder geometry representing interconnected platforming-room building blocks.

## Networking Direction

- ENet/UDP transport via Godot high-level multiplayer APIs.
- Dedicated headless server acts as authority for simulation.
- Clients send input-intent snapshots; server validates and replicates state deltas.
- Player controller includes state snapshot/apply hooks for future authoritative sync without replacing local prototype flow.

## Ownership Boundaries

- **Angel Bustos:** networking, dedicated server, synchronization
- **Chris Aguilera:** gameplay, combat, enemies, procedural generation
- **Isaac Hernandez:** UI, progression, visual integration
