extends Interactable

@export var npc_name: String = "NPC"
@export_multiline var dialogue_text: String = "Привет! Я просто NPC."
# Можно расширить до массива строк для нескольких реплик
@export var dialogue_lines: Array[String] = []

func interact(body):
	super.interact(body)
	print("Говорим с NPC...")
	
	var dialogue_ui = get_tree().get_first_node_in_group("DialogueUI")
	if dialogue_ui:
		var lines = []
		
		# Если задан массив строк, используем его
		if dialogue_lines.size() > 0:
			for line in dialogue_lines:
				lines.append({
					"name": npc_name,
					"text": line
				})
		else:
			# Иначе используем одну строку
			lines.append({
				"name": npc_name,
				"text": dialogue_text
			})
			
		dialogue_ui.start_dialogue(lines)
	else:
		print("ОШИБКА: Не найден UI диалога! Убедитесь, что dialogue_box.tscn добавлен в сцену.")
