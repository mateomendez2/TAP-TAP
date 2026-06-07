extends Control

var circulo_escena = preload("res://escenas/juego/circulo.tscn")
var proyectil_escena = preload("res://escenas/juego/proyectil.tscn")

# Variables para el sistema de disparos
var cargas_actuales = 0
var esta_presionando = false
var tiempo_presionado = 0.0
var posicion_inicial_toque = Vector2.ZERO

# Esta función corre constantemente, como el motor del juego
func _process(delta):
	# Si el jugador está manteniendo el dedo en la pantalla...
	if esta_presionando:
		tiempo_presionado += delta # Empezamos a sumar el tiempo
		
		# Si pasó medio segundo (0.5) y todavía no es nivel 3, le damos la carga máxima
		if tiempo_presionado >= 0.5 and cargas_actuales != 3:
			cargas_actuales = 3
			print("¡Carga máxima nivel 3 alcanzada por mantener presionado!")
			$IndicadorCarga.text = "Nivel de carga: 3"


func _on_spawn_timer_timeout():
	var nuevo_circulo = circulo_escena.instantiate()
	
	# --- NUEVO: Sorteamos un número del 1 al 3 ---
	var tipo_azar = randi_range(1, 3)
	nuevo_circulo.tipo_circulo = tipo_azar
	# ---------------------------------------------
	
	var posicion_x_azar = randf_range(50, 670)
	nuevo_circulo.position = Vector2(posicion_x_azar, -100)
	add_child(nuevo_circulo)


# Cuando el dedo TOCA el botón
func _on_boton_carga_button_down():
	esta_presionando = true
	tiempo_presionado = 0.0
	
	# Guardamos la posición exacta (X, Y) donde el jugador apoyó el mouse/dedo
	posicion_inicial_toque = get_global_mouse_position()


# Cuando el dedo SUELTA el botón
func _on_boton_carga_button_up():
	esta_presionando = false
	
	# Guardamos la posición donde levantó el mouse/dedo
	var posicion_final_toque = get_global_mouse_position()
	
	# Calculamos la diferencia en Y
	var distancia_y = posicion_final_toque.y - posicion_inicial_toque.y
	
	# Si la diferencia es menor a -50 (es decir, deslizó el dedo hacia ARRIBA)
	if distancia_y < -50:
		if cargas_actuales > 0:
			
			# --- INICIO DEL NUEVO CÓDIGO DE DISPARO DIRECCIONAL ---
			# Calculamos la dirección exacta del deslizamiento (Destino menos Origen)
			var vector_deslizamiento = posicion_final_toque - posicion_inicial_toque
			
			# .normalized() achica la flecha a un valor de 1, manteniendo el ángulo perfecto
			var direccion_disparo = vector_deslizamiento.normalized()
			
			var nuevo_proyectil = proyectil_escena.instantiate()
			nuevo_proyectil.nivel_carga = cargas_actuales
			nuevo_proyectil.global_position = $ZonaTap/BotonCarga/PuntoDisparo.global_position
			
			# ¡Le pasamos el ángulo exacto al proyectil!
			nuevo_proyectil.direccion = direccion_disparo
			
			add_child(nuevo_proyectil)
			# --- FIN DEL NUEVO CÓDIGO ---
			
			# Vaciamos la carga porque ya disparamos
			cargas_actuales = 0 
			$IndicadorCarga.text = "Nivel de carga: 0"
		else:
			print("Intento de disparo fallido: No hay cargas.")
			
	else:
		# Si NO deslizó el dedo (la distancia fue casi nula), es un TOQUE normal de carga
		if tiempo_presionado < 0.5:
			if cargas_actuales < 2:
				cargas_actuales += 1
				print("Proyectil cargado a nivel: ", cargas_actuales)
				$IndicadorCarga.text = "Nivel de carga: " + str(cargas_actuales)
