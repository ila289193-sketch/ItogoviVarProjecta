extends Interactable

func interact(body):
	super.interact(body)
	print("Сундук открыт!")
	
	# Пример реакции: меняем цвет
	var sprite = $Sprite2D
	if sprite:
		# Если сундук "закрыт" (белый), красим в желтый (открыт)
		if sprite.modulate == Color.WHITE:
			sprite.modulate = Color.YELLOW
			print("Вы нашли сокровище!")
		else:
			sprite.modulate = Color.WHITE
			print("Сундук закрылся.")
