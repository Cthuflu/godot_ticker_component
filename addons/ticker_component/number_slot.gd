extends Control

@export_category("Nodes")
@export
var label_prev: Label

@export
var label_current: Label

@export
var label_next: Label

@export
var blur_tex: Control

@export
var animation_player: AnimationPlayer

@export_category("Params")
var current_number: int:
  set(value):
    if value > current_number:
      label_current.text = str((value - 1) % 10)
      label_next.text = str(value % 10)
      animation_player.play("spin_next", -1, 2)
    if value < current_number:
      if value < 0:
        value = (value % 10 + 10)
      label_current.text = str((value + 1) % 10)
      label_prev.text = str(value % 10)
      animation_player.play("spin_prev", -1, 2)
    current_number = value % 10

@export
var number: int:
  set(value):
    number = (value + 10) % 10

func _ready() -> void:
  animation_player.animation_finished.connect(set_current_display)

func _physics_process(_delta: float) -> void:
  if number == current_number:
    return

  if not animation_player.is_playing():
    current_number += 1

func set_current_display(anim_name: StringName) -> void:
  if anim_name == "RESET":
    return

  label_current.text = str(current_number)
  animation_player.play("RESET")