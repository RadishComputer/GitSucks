extends Panel

const CAT_INFO = {
	"Found_Chloe": {
		"name": "Chloe",
		"character_texture": "res://Art/Beta/Characters/Cat_Chloe.png",
		"scene_texture": "res://Art/Beta/Places/Cat_Chloe_Scene.png"
	},
	"Found_Creamy_Color": {
		"name": "Creamy Color",
		"character_texture": "res://Art/Beta/Characters/Cat_Creamy_Color.png",
		"scene_texture": "res://Art/Beta/Places/Cat_Creamy_Color_Scene.png"
	},
	"Found_Felicia": {
		"name": "Felicia",
		"character_texture": "res://Art/Beta/Characters/Cat_Felicia.png",
		"scene_texture": "res://Art/Beta/Places/Cat_Felicia_Scene.png"
	},
	"Found_Joey": {
		"name": "Joey",
		"character_texture": "res://Art/Beta/Characters/Cat_Joey.png",
		"scene_texture": "res://Art/Beta/Places/Cat_Joey_Scene.png"
	},
	"Found_Spock": {
		"name": "Spock",
		"character_texture": "res://Art/Beta/Characters/Cat_Spock.png",
		"scene_texture": "res://Art/Beta/Places/Cat_Spock_Scene.png"
	}
}

@onready var scroll = $ScrollContainer
@onready var background = $"../../Cats_Layer/Cat_Background"
@onready var scene = $"../../Cats_Layer/Cat_Scene"

var list_container: VBoxContainer

func _ready():
	list_container = scroll.get_node_or_null("VBoxContainer")
	if not list_container:
		list_container = VBoxContainer.new()
		list_container.name = "VBoxContainer"
		list_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		scroll.add_child(list_container)

	background.visible = false
	scene.visible = false

	background.gui_input.connect(overlay_clicked)
	call_deferred("connect_cats")

func overlay_clicked(event: InputEvent):
	if GameGlue.InputManager.click_release(event):
		hide_cat_image()

func connect_cats():
	populate_cats()
	GameGlue.KnowledgeManager.knowledge_learned.connect(on_knowledge_learned)

func on_knowledge_learned(_id: String):
	populate_cats()

func populate_cats():
	for child in list_container.get_children():
		child.queue_free()

	for cat_id in CAT_INFO:
		if not GameGlue.KnowledgeManager.knows(cat_id):
			continue

		var info = CAT_INFO[cat_id]
		var name_label = Label.new()
		name_label.text = info["name"]
		list_container.add_child(name_label)

		var image = TextureButton.new()
		image.texture_normal = load(info["character_texture"])
		image.pressed.connect(show_cat_scene.bind(info["scene_texture"]))
		list_container.add_child(image)

func show_cat_scene(texture_path: String):
	var texture = load(texture_path)
	if texture:
		scene.texture = texture
		background.visible = true
		scene.visible = true

func hide_cat_image():
	background.visible = false
	scene.visible = false
