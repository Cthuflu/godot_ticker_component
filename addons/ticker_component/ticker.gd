extends Control

signal number_change(new_value: int)

const number_slot_scene = preload("res://addons/ticker_component/ticker.tscn")

@export_category("Nodes")
@export
var slots: Array[Control]

@export_category("Params")
@export
var number: int:
  set(value):
    if number != value:
      if tween:
        tween.kill()
      tween = create_tween()
      tween.tween_property(self, "current_number", value, 1).set_ease(Tween.EASE_OUT)

    number = value

var current_number: int:
  set(value):
    current_number = value
    update_display()
    number_change.emit(value)

var tween: Tween

@export
var expandable: bool

func calc_places(num: int) -> int:
  return str(num).length()

func update_display() -> void:
  var num: int = current_number
  var digit_count: int = 0
  while num > 0:
    var digit: int = num % 10
    num = int(num / 10)
    if digit_count + 1 > slots.size():
      if not expandable:
        return
      expand_display()
    slots[digit_count].number = digit
    digit_count += 1

  if digit_count < slots.size():
    for i in range(digit_count, slots.size()):
      slots[i].number = 0

func expand_display() -> void:
  var added_places: int = calc_places(current_number) - slots.size()
  for i in range(0, added_places):
    var new_slot: Control = number_slot_scene.instantiate()
    add_child(new_slot)
    move_child(new_slot, 0)
    slots.push_back(new_slot)
