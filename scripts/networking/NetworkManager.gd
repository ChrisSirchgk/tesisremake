extends Node

enum Mode {
	OFFLINE,
	CLIENT,
	SERVER,
}

var current_mode: Mode = Mode.OFFLINE
var server_address: String = "127.0.0.1"
var server_port: int = 7777
var peer: ENetMultiplayerPeer

func configure(address: String, port: int) -> void:
	server_address = address
	server_port = port

func start_client() -> void:
	stop()
	peer = ENetMultiplayerPeer.new()
	var result := peer.create_client(server_address, server_port)
	if result != OK:
		peer = null
		push_error("Unable to start network client: %s" % error_string(result))
		return

	multiplayer.multiplayer_peer = peer
	current_mode = Mode.CLIENT

func start_server() -> void:
	stop()
	peer = ENetMultiplayerPeer.new()
	var result := peer.create_server(server_port)
	if result != OK:
		peer = null
		push_error("Unable to start network server: %s" % error_string(result))
		return

	multiplayer.multiplayer_peer = peer
	current_mode = Mode.SERVER

func stop() -> void:
	if multiplayer.multiplayer_peer != null:
		multiplayer.multiplayer_peer.close()
		multiplayer.multiplayer_peer = null
	peer = null
	current_mode = Mode.OFFLINE
