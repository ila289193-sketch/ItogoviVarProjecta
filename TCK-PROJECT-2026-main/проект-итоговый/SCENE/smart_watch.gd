extends Control

# --- ССЫЛКИ НА ЭЛЕМЕНТЫ ИНТЕРФЕЙСА ---
# Ссылка на главную панель (первая вкладка меню)
@onready var main_panel = $MainPanel
# Ссылка на панель рандомайзера (вторая вкладка меню)
@onready var randomizer_panel = $RandomizerPanel
# Ссылка на текстовое поле диалога помощника
@onready var helper_label = $MainPanel/DialogueBox/RichTextLabel
# Ссылки на слоты для картинок в рандомайзере
@onready var slot1 = $RandomizerPanel/Slots/Slot1/Image
@onready var slot2 = $RandomizerPanel/Slots/Slot2/Image
@onready var slot3 = $RandomizerPanel/Slots/Slot3/Image
# Ссылки на кнопки управления рандомайзером
@onready var spin_btn = $RandomizerPanel/SpinBtn
@onready var teleport_btn = $RandomizerPanel/TeleportBtn

# --- ДАННЫЕ ДЛЯ ДИАЛОГА ---
# Массив фраз помощника, которые можно пролистывать
var helper_lines = [
	"Привет! Я твой умный помощник.",
	"Нажми 'Выбор вселенной', чтобы испытать удачу.",
	"Если выпадут три одинаковые картинки, ты сможешь переместиться!",
	"Не забывай проверять сундуки.",
	"Удачи в путешествиях!"
]
# Индекс текущей отображаемой фразы
var current_line_index = 0

# --- ДАННЫЕ ДЛЯ РАНДОМАЙЗЕРА ---
# Загружаем картинки для слотов (предварительная загрузка)
var images = [
	preload("res://IMG/вселеная.webp"),
	preload("res://IMG/супермэн.webp"),
	preload("res://IMG/умный человек.webp")
]

# Функция инициализации при запуске сцены
func _ready():
	# Скрываем все меню при старте
	visible = false
	# Показываем главную панель по умолчанию
	main_panel.visible = true
	# Скрываем панель рандомайзера
	randomizer_panel.visible = false
	# Блокируем кнопку телепортации до выигрыша
	teleport_btn.disabled = true
	# Обновляем текст помощника
	update_helper_text()
	
	# Подключаем сигнал изменения видимости для паузы
	if not visibility_changed.is_connected(_on_visibility_changed):
		visibility_changed.connect(_on_visibility_changed)

# Обработка ввода (Z для открытия/закрытия)
# func _input(event):
# 	if event is InputEventKey and event.pressed and event.keycode == KEY_Z and not event.echo:
# 		visible = not visible

# --- ФУНКЦИИ ГЛАВНОЙ ПАНЕЛИ ---

# Нажатие на кнопку закрытия
func _on_close_pressed():
	visible = false

# Обработчик изменения видимости (ставит паузу)
func _on_visibility_changed():
	get_tree().paused = visible

# Нажатие на кнопку "Выбор вселенной"
func _on_universe_select_pressed():
	# Скрываем главную панель
	main_panel.visible = false
	# Показываем панель рандомайзера
	randomizer_panel.visible = true

# Нажатие на кнопку "Назад" (<) в диалоге
func _on_prev_line_pressed():
	# Если это не первая фраза
	if current_line_index > 0:
		# Уменьшаем индекс
		current_line_index -= 1
		# Обновляем текст
		update_helper_text()

# Нажатие на кнопку "Вперед" (>) в диалоге
func _on_next_line_pressed():
	# Если это не последняя фраза
	if current_line_index < helper_lines.size() - 1:
		# Увеличиваем индекс
		current_line_index += 1
		# Обновляем текст
		update_helper_text()

# Функция обновления текста в лейбле
func update_helper_text():
	helper_label.text = helper_lines[current_line_index]

# --- ФУНКЦИИ ПАНЕЛИ РАНДОМАЙЗЕРА ---

# Нажатие на кнопку "Назад" (возврат в главное меню часов)
func _on_back_pressed():
	# Скрываем рандомайзер
	randomizer_panel.visible = false
	# Показываем главную панель
	main_panel.visible = true

# Нажатие на кнопку "Крутить"
func _on_spin_pressed():
	if not Global.spend_coins(1):
		randomizer_panel.visible = false
		main_panel.visible = true
		helper_label.text = "Недостаточно монет для запуска! Поищи их в мире."
		return

	# Блокируем кнопку кручения, чтобы не нажимали повторно
	spin_btn.disabled = true
	# Блокируем телепорт на время вращения
	teleport_btn.disabled = true
	
	# Цикл анимации прокрутки (20 шагов)
	for i in range(20):
		# Ставим случайную картинку в каждый слот
		slot1.texture = images.pick_random()
		slot2.texture = images.pick_random()
		slot3.texture = images.pick_random()
		# Ждем 0.1 секунды (асинхронно)
		await get_tree().create_timer(0.1).timeout
		
	# Определяем финальный результат (случайный выбор)
	var result1 = images.pick_random()
	var result2 = images.pick_random()
	var result3 = images.pick_random()
	
	# Устанавливаем финальные картинки
	slot1.texture = result1
	slot2.texture = result2
	slot3.texture = result3
	
	# Разблокируем кнопку кручения
	spin_btn.disabled = false
	
	# Проверяем на совпадение (Джекпот)
	if result1 == result2 and result2 == result3:
		# Разблокируем кнопку телепортации
		teleport_btn.disabled = false
		print("Джекпот! Перемещение разблокировано.")

# Нажатие на кнопку "Переместиться"
func _on_teleport_pressed():
	print("Телепортация...")
	# Здесь можно добавить логику смены сцены или другого действия
