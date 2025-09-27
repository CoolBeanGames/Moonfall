class_name gun extends Resource

@export var gun_name : StringName
@export var bullet_prefab : PackedScene
@export var fire_rate : float = 0.2
@export var reload_time : float = 3
@export var melee_time : float = 1
@export var melee_damage : int = 1
@export var bullet_damage : int = 1
@export var max_clip_size : int = 12
@export var loaded_bullets : int = 12
@export var fire_mode : FireMode = FireMode.single
@export var shooting_sounds : audio_set
@export var empty_sound : AudioStream
@export var reload_sound : AudioStream
@export var gun_object_path : String
@export var camera_shake : float = 0.1
@export var camera_shake_time : float  = 0.1

enum FireMode {single, rapid, spread}
