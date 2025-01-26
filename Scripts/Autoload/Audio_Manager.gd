extends Node

enum Bus {
	MASTER = 0,
	MUSIQUE = 1,
	BRUITAGE = 2,
	VOIX = 3,
	POP = 4,
	WRONG = 5
	}

enum Jukebox {
	MUSIQUE = 1 ,
	BRUITAGE = 2,
	VOIX = 3,
	POP = 4,
	WRONG = 5
	}

@export_category("Musiques")
@export var musiques_en_jeu : Array[AudioStream]
@export var bruitages_sounds : Array[AudioStream]
@export var pop_sounds : Array[AudioStream]
@export var wrong_sounds : Array[AudioStream]
@export var orage_sounds : Array[AudioStream]

@export_category("Audio Players")
@export var audio_players_musique : Array[AudioStreamPlayer]
@export var audio_players_bruitage : Array[AudioStreamPlayer]
@export var audio_players_voix : Array[AudioStreamPlayer]
@export var audio_players_pop : Array[AudioStreamPlayer]
@export var audio_players_wrong : Array[AudioStreamPlayer]


# Public Variables
var son : bool = true
var musique : bool = true
var bruitage : bool = true
var voix : bool = true
var pop : bool = true
var wrong : bool = true

# Variables internes
var son_en_cours: Dictionary = {}  # Associe un flux AudioStream à un AudioStreamPlayer

func _ready():
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	Connection_Signaux()

func Ajuster_Volume_Bus(bus : Bus, volume_db : float):
	AudioServer.set_bus_volume_db(bus, volume_db)

func Connection_Signaux():
	var all_players = audio_players_bruitage + audio_players_musique + audio_players_voix + audio_players_pop + audio_players_wrong
	for player in all_players:
		player.finished.connect(_On_AudioPlayer_Finished)

func _On_AudioPlayer_Finished(player: AudioStreamPlayer):
	# Trouver et retirer le son correspondant dans le dictionnaire
	for key in son_en_cours.keys():
		if son_en_cours[key] == player:
			son_en_cours.erase(key)
			break

## PUBLIC FUNCTIONS
func Is_Playing(bus : Bus) -> bool:
	var current_jukebox = _Return_Jukebox_Array_From_Enum(bus)
	return current_jukebox != null and current_jukebox.playing

func Play(musique: AudioStream, bus: Bus, volume: float = -5, pitch: float = 1.0):
	var jukebox_array = _Return_Jukebox_Array_From_Enum(bus)
	for jukebox in jukebox_array:
		if not jukebox.playing:
			jukebox.stream = musique
			jukebox.pitch_scale = pitch
			jukebox.volume_db = volume
			jukebox.play()
			son_en_cours[musique] = jukebox
			return
	printerr("Aucun AudioStreamPlayer disponible pour le bus : %d" % bus)

func Pop_Button(volume : float = 1, pitch_min : float = 0.9, pitch_max : float = 1.15):
	var random_pitch = randf_range(pitch_min, pitch_max)
	var stream_to_play = pop_sounds.pick_random()
	for player in audio_players_pop:
		if not player.playing:
			player.stream = stream_to_play
			player.pitch_scale = random_pitch
			player.volume_db = volume
			player.play()
			return
	printerr("Aucun AudioStreamPlayer disponible pour Pop_Button")

func Wrong(volume : float = 1, pitch_min : float = 0.9, pitch_max : float = 1.05):
	var random_pitch = randf_range(pitch_min, pitch_max)
	var stream_to_play = wrong_sounds.pick_random()
	for player in audio_players_wrong:
		if not player.playing:
			player.stream = stream_to_play
			player.pitch_scale = random_pitch
			player.volume_db = volume
			player.play()
			return

func Stop(bus : Bus):
	print("Stop Bus : ", _Return_Jukebox_Array_From_Enum(bus))
	var jukebox_array = _Return_Jukebox_Array_From_Enum(bus)
	for jukebox in jukebox_array:
		jukebox.stop()

func Stop_Specific(musique: AudioStream):
	if son_en_cours.has(musique):
		var player = son_en_cours[musique]
		player.stop()
		son_en_cours.erase(musique)
	else:
		printerr("Impossible de trouver le son spécifié en cours de lecture.")

func Toggle_Bus(bus : Bus):
	match bus:
		Bus.MUSIQUE:
			musique = !musique
			AudioServer.set_bus_mute(bus, !musique)

		Bus.BRUITAGE:
			bruitage = !bruitage
			AudioServer.set_bus_mute(bus, !bruitage)

		Bus.VOIX:
			voix = !voix
			AudioServer.set_bus_mute(bus, !voix)

		Bus.MASTER:
			son = !son
			AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), !son)

		Bus.POP:
			pop = !pop
			AudioServer.set_bus_mute(bus, !pop)

		Bus.WRONG:
			wrong = !wrong
			AudioServer.set_bus_mute(bus, !wrong)
			
		_:
			printerr("Le nom du bus est incorrect (AudioManager/Toggle_Bus)")
			return false

## PRIVATE FUNCTIONS
func _Return_Jukebox_Array_From_Enum(bus : Bus) -> Array[AudioStreamPlayer]:
	match bus:
		Bus.MUSIQUE: return audio_players_musique
		Bus.BRUITAGE: return audio_players_bruitage
		Bus.VOIX: return audio_players_voix
		Bus.POP: return audio_players_pop
		Bus.WRONG: return audio_players_wrong
		_: return []

func _is_Bus_Available(bus : Bus) -> bool:
	match bus:
		Bus.MUSIQUE: return musique
		Bus.BRUITAGE: return bruitage
		Bus.VOIX: return voix
		Bus.POP: return pop
		Bus.WRONG: return wrong
		_: return false
