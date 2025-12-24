extends Control

# Ссылки на кнопки
var btn_left: Button
var btn_right: Button

# Пути к изображениям
const IMG_SUPERMAN = "res://IMG/супермэн.webp"
const IMG_SMARTMAN = "res://IMG/умный человек.webp"

# Пути к персонажам
const CHAR_SUPERMAN = "res://ПЕРСОНАЖИ/character_body_2d.tscn"
const CHAR_SMARTMAN = "res://ПЕРСОНАЖИ/character_body1_2d.tscn"

const GAME_SCENE_PATH = "res://SCENE/scene001.tscn"

func _ready() -> void:
    # Получаем размер экрана
    var viewport_size = get_viewport_rect().size
    
    # Настройка левой кнопки
    btn_left = Button.new()
    # Текст можно убрать, так как есть картинка
    btn_left.text = "" 
    btn_left.name = "LeftButton"
    add_child(btn_left)
    setup_button_style(btn_left, IMG_SUPERMAN)
    
    # Настройка правой кнопки
    btn_right = Button.new()
    btn_right.text = ""
    btn_right.name = "RightButton"
    add_child(btn_right)
    setup_button_style(btn_right, IMG_SMARTMAN)
    
    # Подключаем сигналы с привязкой аргументов
    btn_left.pressed.connect(_on_left_button_pressed)
    btn_right.pressed.connect(_on_right_button_pressed)
    
    # Размеры
    btn_left.size = Vector2(viewport_size.x / 2, viewport_size.y)
    btn_right.size = Vector2(viewport_size.x / 2, viewport_size.y)
    
    # Начальные позиции (за пределами экрана)
    btn_left.position = Vector2(-btn_left.size.x, 0)
    btn_right.position = Vector2(viewport_size.x, 0)
    
    # Анимация выезда
    var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
    tween.tween_property(btn_left, "position:x", 0.0, 1.0)
    tween.tween_property(btn_right, "position:x", viewport_size.x / 2, 1.0)

func setup_button_style(btn: Button, path: String) -> void:
    if ResourceLoader.exists(path):
        var texture = load(path)
        var style_box = StyleBoxTexture.new()
        style_box.texture = texture
        style_box.modulate_color = Color(0.7, 0.7, 0.7, 1.0) # Затемнение
        
        # Устанавливаем стиль для всех состояний
        btn.add_theme_stylebox_override("normal", style_box)
        btn.add_theme_stylebox_override("hover", style_box)
        btn.add_theme_stylebox_override("pressed", style_box)
        btn.add_theme_stylebox_override("disabled", style_box)
        btn.add_theme_stylebox_override("focus", style_box)

func _on_left_button_pressed() -> void:
    _load_game(CHAR_SUPERMAN)

func _on_right_button_pressed() -> void:
    _load_game(CHAR_SMARTMAN)

func _load_game(char_path: String) -> void:
    Global.selected_character_path = char_path
    get_tree().change_scene_to_file(GAME_SCENE_PATH)
