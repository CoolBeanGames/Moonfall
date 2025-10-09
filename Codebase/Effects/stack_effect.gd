##a stack effect is some effect that modifies a value
##a value is given to the effect function it then processesses that
##value and outputs it back out

##these values will be stored by the game manager and then 
##you can call through to process all of these effects one
##after another.

##each effect will have an effect type that will define if
##a given value will be processed by this effect or simply 
##passed through
@abstract
class_name stack_effect extends Resource

##a collection of types for the effect to process on
enum effector{damage,score,health,player_damage}

@export var display_scene : PackedScene = load("res://Scenes/UI_Scenes/effect_display.tscn")

@export_category("shader parameters")
@export var icon_image : Texture
@export var gradient_right_color : Color
@export var gradient_left_color : Color


##actually process the effect (if it is of the correct type) and return the 
##new value (which should be the same as the input value
@abstract func effect(input , type : effector) -> Variant
