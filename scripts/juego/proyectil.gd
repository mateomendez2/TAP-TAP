extends Area2D

var velocidad = 800 
var nivel_carga = 0 
var direccion = Vector2.UP # Variable nueva: por defecto apunta hacia arriba

func _process(delta):
	# Ahora multiplicamos la velocidad por la dirección exacta que le diga el Main
	position += direccion * velocidad * delta
	
	# Si se sale de la pantalla por arriba o por los costados, lo borramos
	if position.y < -50 or position.x < -50 or position.x > 770:
		queue_free()
