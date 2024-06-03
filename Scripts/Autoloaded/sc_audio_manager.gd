class_name AudioManager
extends Node
## Plays and switches between music
## Plays SFX in multiple channels depending on channels

# List all Music files down in this format:
# const EXAMPLE_MUSIC = preload("res://Audio/Music/aud_example_music.ogg")

# List all SFX files down in this format:
# const EXAMPLE_SOUND = preload("res://Audio/SFX/aud_example_sound.wav")
const sfx_hurt = preload("res://Sounds/SFX_Hurt.wav")
const sfx_punch = preload("res://Sounds/SFX_Punch.mp3")
const sfx_menu = preload("res://Sounds/SFX_Menu.wav")
const sfx_death = preload("res://Sounds/SFX_Death.wav")
const sfx_card = preload("res://Sounds/SFX_Card.wav")

var music_pause_point: float = 0

@onready var music_stream_player = $MusicStreamPlayer

# Play sound in an empty audio channel
func play_sound(get_string):
	var sound
	var volume
	
	match get_string:
		
		"SFX_Hurt":
			sound = sfx_hurt
			volume = -5
		"SFX_Punch":
			sound = sfx_punch
			volume = 0
		"SFX_Death":
			sound = sfx_death
			volume = 0
		"SFX_Menu":
			sound = sfx_menu
			volume = -5
		"SFX_Card":
			sound = sfx_card
			volume = -5
		_:
			print("No Sound Found")
	
	for channel in $SFXChannels.get_children():
		if (channel.playing == false):
			channel.stream = sound
			channel.volume_db = volume
			channel.play()
			break

# Play specific music
func play_music(music):
	if (music_stream_player.playing == true):
		music_stream_player.stop()
	music_pause_point = 0
	music_stream_player.stream = music
	music_stream_player.play()

# Pause music
func pause_current_music():
	if (music_stream_player.playing == true):
		music_pause_point = music_stream_player.get_playback_position()
		music_stream_player.stop()

# Resume music
func resume_current_music():
	if (music_stream_player.playing == false):
		music_pause_point = 0
		music_stream_player.play()

func _ready():
	self.process_mode = Node.PROCESS_MODE_ALWAYS
