extends Camera2D

@export var smoothing_speed: float = 5.0 # Скорость сглаживания (меньше = плавнее)

func _ready() -> void:
    # Включаем сглаживание
    position_smoothing_enabled = true
    position_smoothing_speed = smoothing_speed
    
    # Приближение камеры
    zoom = Vector2(4.0, 4.0)
    
    # Убираем лимиты карты (ставим очень большие значения), чтобы камера следила везде
    limit_left = -10000000
    limit_right = 10000000
    limit_top = -10000000
    limit_bottom = 10000000
    
    # Делаем эту камеру активной
    make_current()
    
    # Отключаем "мертвую зону" (Drag Margins), чтобы камера всегда держала игрока в центре
    drag_horizontal_enabled = false
    drag_vertical_enabled = false
    
    # Сбрасываем смещение
    offset = Vector2.ZERO
    
    # Гарантируем, что камера привязана к родителю
    top_level = false
    
    # Синхронизируем обновление камеры с физикой
    process_callback = Camera2D.CAMERA2D_PROCESS_PHYSICS
