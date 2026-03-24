extends Node

static func drag_release(event: InputEvent):
	return event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released()

static func click_release(event: InputEvent):
	return (
		(event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released()) or
		(event is InputEventScreenTouch and not event.pressed) or
		(event is InputEventJoypadButton and event.button_index == JOY_BUTTON_A and not event.pressed) or 
		(event is InputEventKey and event.keycode in [KEY_ENTER, KEY_SPACE] and event.is_released())
	)

static func right_click_release(event: InputEvent):
	return event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and not event.pressed
