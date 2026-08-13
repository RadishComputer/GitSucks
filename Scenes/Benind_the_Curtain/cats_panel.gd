extends Panel

const CAT_INFO = {
	"cat_chloe": {
		"name": "Chloe",
		"texture": "res://Art/Beta/Characters/Cat_Chloe.png"
	},
	"cat_cleo": {
		"name": "Cleo",
		"texture": "res://Art/Beta/Characters/Cat_Cleo.png"
	},
	"cat_creamy_color": {
		"name": "Creamy Color",
		"texture": "res://Art/Beta/Characters/Cat_Creamy_Color.png"
	},
	"cat_felicia": {
		"name": "Felicia",
		"texture": "res://Art/Beta/Characters/Cat_Felicia.png"
	},
	"cat_joey": {
		"name": "Joey",
		"texture": "res://Art/Beta/Characters/Cat_Joey.png"
	},
	"cat_spock": {
		"name": "Spock",
		"texture": "res://Art/Beta/Characters/Cat_Spock.png"
	}
}

@onready var grid = $GridContainer

# Overlay for showing the cat image
var cat_display: TextureButton

func _ready():
	# Configure the GridContainer for a nice vertical grid of buttons
	grid.columns = 2
	grid.offset_left = 40
	grid.offset_top = 40
	grid.offset_right = 560
	grid.offset_bottom = 560
	grid.add_theme_constant_override("h_separation", 20)
	grid.add_theme_constant_override("v_separation", 20)
	
	# Create the cat display overlay
	setup_cat_display()
	
	call_deferred("connect_cats")

func setup_cat_display():
	cat_display = TextureButton.new()
	cat_display.name = "CatDisplayOverlay"
	cat_display.visible = false
	cat_display.z_index = 10
	
	# Cover the entire CatsPanel area
	cat_display.set_anchors_preset(Control.PRESET_FULL_RECT)
	cat_display.offset_left = 0
	cat_display.offset_top = 0
	cat_display.offset_right = 0
	cat_display.offset_bottom = 0
	
	# Semitransparent background
	var bg = ColorRect.new()
	bg.color = Color(0, 0, 0, 0.75)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cat_display.add_child(bg)
	
	# Centered TextureRect for the cat image
	var img = TextureRect.new()
	img.name = "CatImage"
#	img.expand_mode = TextureRect.EXPAND_KEEP_ASPECT_CENTERED
	img.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	img.set_anchors_preset(Control.PRESET_CENTER)
	img.offset_left = -200
	img.offset_top = -200
	img.offset_right = 200
	img.offset_bottom = 200
	cat_display.add_child(img)
	
	# Clicking anywhere on the overlay will hide it
	cat_display.pressed.connect(hide_cat_image)
	
	add_child(cat_display)

func connect_cats():
	populate_cats()
	GameGlue.KnowledgeManager.knowledge_learned.connect(on_knowledge_learned)

func on_knowledge_learned(_id: String):
	populate_cats()

func populate_cats():
	# Clear existing child controls
	for child in grid.get_children():
		child.queue_free()
		
	var found_any = false
	for cat_id in CAT_INFO.keys():
		if GameGlue.KnowledgeManager.knows(cat_id):
			found_any = true
			var info = CAT_INFO[cat_id]
			
			var btn = Button.new()
			btn.text = info["name"]
			btn.custom_minimum_size = Vector2(240, 60)
			btn.pressed.connect(show_cat_image.bind(info["texture"]))
			grid.add_child(btn)
			
	# If no cats found yet, display a placeholder message
	if not found_any:
		var label = Label.new()
		label.text = "No cats found yet.\nKeep exploring!"
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.custom_minimum_size = Vector2(520, 100)
		grid.add_child(label)

func show_cat_image(texture_path: String):
	var texture = load(texture_path)
	if texture:
		cat_display.get_node("CatImage").texture = texture
		cat_display.visible = true

func hide_cat_image():
	cat_display.visible = false
