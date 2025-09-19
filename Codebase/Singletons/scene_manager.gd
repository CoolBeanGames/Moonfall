##a global class for loading and unloading scenes
extends Node

##a list of all of the active UI Scenes
@export var active_scenes : Dictionary[String,Node]
##a list of all of the active ui Scenes
@export var active_ui_scenes : Dictionary[String,Node]
##a scene to show when loading
@export var loading_scene : PackedScene
##the root scene we are adding these scenes to
var root
##the loading screen we spawned
var loading_scene_instance : Node

##setup our root node
func _ready() -> void:
	await get_tree().process_frame
	var SceneContainer = Node.new()
	get_tree().root.add_child(SceneContainer)
	SceneContainer.name = "Scenes"
	root = SceneContainer

##load in a show a scene
func load_scene(scene_to_load : PackedScene, name_for_scene : String, unload_all_scenes : bool = false, show_loading_screen : bool = false) -> Node:
	if show_loading_screen:
		_show_loading_screen()
		await get_tree().process_frame
	if unload_all_scenes:
		unload_all()
	if active_scenes.has(name_for_scene):
		push_warning("attempted to add scene ", name_for_scene, " but it already exists")
		return null
	var scene = scene_to_load.instantiate()
	root.add_child(scene)
	active_scenes[name_for_scene] = scene
	if show_loading_screen:
		_hide_loading_screen()
	print("💾 loaded scene ", name_for_scene)
	return scene

##load in and show a ui scene
func load_ui_scene(scene_to_load : PackedScene, name_for_scene : String) -> Node:
	if active_ui_scenes.has(name_for_scene):
		push_warning("attempted to add ui scene ", name_for_scene, " but it already exists")
		return null
	var scene = scene_to_load.instantiate()
	root.add_child(scene)
	active_ui_scenes[name_for_scene] = scene
	print("💾 loaded ui scene ", name_for_scene)
	return scene

##show the loading screen
func _show_loading_screen():
	loading_scene_instance = loading_scene.instantiate()
	root.add_child(loading_scene_instance)

##hide and unspawn the loading screen
func _hide_loading_screen():
	if loading_scene_instance == null:
		push_warning("attempted to remove loading screen but it was not active")
		return
	loading_scene_instance.queue_free()
	loading_scene_instance = null

##unload a single scene by name
func unload_scene(scene_name : String):
	if active_scenes.has(scene_name):
		active_scenes[scene_name].free()
		active_scenes.erase(scene_name)
		print("🚫 unloaded scene ", scene_name)
	else:
		push_warning("attempted to remove scene ", scene_name, " but it does not exist in the scene manager")

##unload a single ui by name
func unload_ui(ui_name : String):
	if active_ui_scenes.has(ui_name):
		active_ui_scenes[ui_name].free()
		active_ui_scenes.erase(ui_name)
		print("🚫 unloaded ui scene ", ui_name)
	else:
		push_warning("attempted to remove scene ", ui_name, " but it does not exist in the scene manager")


##remove every spawned scene from the game
func unload_all():
	print("🟥 unloading all scenes")
	for n in active_scenes.keys():
		unload_scene(n)
	for u in active_ui_scenes.keys():
		unload_ui(u)
	active_scenes.clear()
	active_ui_scenes.clear()
