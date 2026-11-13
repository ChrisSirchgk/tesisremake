# API Contracts

This file defines current module-level contracts and side-scrolling prototype integration points.

## `GameEvents` (`res://scripts/core/GameEvents.gd`)

### Signals

- `game_started` — emitted when the Play action is triggered.
- `quit_requested` — emitted when Quit action is triggered.

### Notes

- Module is autoloaded and globally accessible.
- Future systems should subscribe to signals instead of hard dependencies.

## `NetworkManager` (`res://scripts/networking/NetworkManager.gd`)

### Public API

- `configure(address: String, port: int) -> void`
- `start_client() -> void`
- `start_server() -> void`
- `stop() -> void`

### Current Behavior

- Stores connection settings and tracks current mode (`OFFLINE`, `CLIENT`, `SERVER`).
- Starts an ENet client or server peer and installs it as the scene tree multiplayer peer.
- Closes and clears the active peer when stopped or before starting a new session.

## `SaveManager` (`res://scripts/progression/SaveManager.gd`)

### Public API

- `save_profile(data: Dictionary) -> Error`
- `load_profile() -> Dictionary`

### Current Behavior

- Saves profile JSON to `user://savegame.json`.
- Returns an empty dictionary when no file exists or parsing fails.

## `SideScrollerPlayer` (`res://scripts/gameplay/SideScrollerPlayer.gd`)

### Public API

- `build_input_snapshot() -> Dictionary`
- `apply_authoritative_state(state: Dictionary) -> void`

### Current Behavior

- Uses input actions (`move_left`, `move_right`, `jump`) and deterministic movement parameters.
- Applies gravity/jump/horizontal motion through state-oriented helper methods.
- Exposes input and state hook methods for future authoritative server synchronization.
- Backward compatibility: does not alter `NetworkManager` or existing autoload interfaces.
