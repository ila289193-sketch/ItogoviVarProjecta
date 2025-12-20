extends Area2D
class_name Interactable

# Сигнал, который отправляется при взаимодействии
signal interacted(body)

# Метод, вызываемый игроком
func interact(body):
	print("Interacted with ", name)
	interacted.emit(body)
