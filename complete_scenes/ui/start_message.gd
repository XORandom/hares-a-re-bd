extends CanvasLayer

@export_multiline var start_message: String

@onready var message_panel: RichTextLabel = $Panel/MessagePanel

func _ready() -> void:
	message_panel.text = start_message
	visible = true
	await get_tree().create_timer(2.5).timeout
	visible = false


func _on_panel_gui_input(event: InputEvent) -> void:
	if event.is_action("ui_cancel") or event.is_action("left_click"):
		visible = false
	pass # Replace with function body.
