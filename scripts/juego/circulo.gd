extends Area2D

var velocidad = 200
var tipo_circulo = 1

# Esta función corre una sola vez al nacer el círculo
func _ready():
	# Primero ocultamos todos los dibujos
	$Visual_Nivel1.hide()
	$Visual_Nivel2.hide()
	$Visual_Nivel3.hide()
	
	# Mostramos solo el que corresponde según nuestra variable
	if tipo_circulo == 1:
		$Visual_Nivel1.show()
	elif tipo_circulo == 2:
		$Visual_Nivel2.show()
	elif tipo_circulo == 3:
		$Visual_Nivel3.show()

# Esta función corre todo el tiempo para que caiga
func _process(delta):
	position.y += velocidad * delta


# Esta función se ejecuta cuando OTRA área (como el proyectil) toca a este círculo
func _on_area_entered(area):
	# 1. Comprobamos si el área que nos chocó es un proyectil.
	# Lo hacemos preguntándole si tiene la variable "nivel_carga" en su código.
	if "nivel_carga" in area:
		
		# 2. Comparamos los niveles
		if area.nivel_carga == tipo_circulo:
			print("¡ÉXITO! Círculo de nivel ", tipo_circulo, " destruido. +100 Puntos")
			
			# Destruimos el proyectil para que no siga volando
			area.queue_free()
			
			# Destruimos este círculo (nosotros mismos)
			queue_free()
			
		else:
			print("ERROR: Proyectil nivel ", area.nivel_carga, " no le hace daño al Círculo nivel ", tipo_circulo)
			
			# Destruimos el proyectil porque chocó, pero dejamos que el círculo siga cayendo
			area.queue_free()
