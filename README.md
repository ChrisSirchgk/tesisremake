# Tesis de Roguelike sin Nombre

Prototipo de tesis de un videojuego roguelike de acción y plataformas en 2D, con desplazamiento lateral (side-scrolling) y gráficos pixel art, inspirado en Castlevania y Dead Cells.

## Alcance actual del prototipo

- Sistema básico de movimiento lateral utilizando `CharacterBody2D`.
- Movimiento horizontal, gravedad, saltos y geometría de niveles preparada para colisiones.
- Distribución provisional de suelo y plataformas para desarrollar habitaciones de plataformas diseñadas manualmente.
- Estructura inicial preparada para implementar posteriormente combate cuerpo a cuerpo, a distancia y mágico, enemigos, jefes y habilidades de clase.
- Sistema de progresión persistente mediante perfiles de guardado locales en formato JSON.
- Arquitectura preparada para partidas cooperativas online de 2 a 4 jugadores, utilizando un servidor dedicado autoritativo.

## Tecnologías y plataformas

- Motor de videojuegos: Godot 4.x (edición estándar).
- Lenguaje de programación: GDScript.
- Plataforma objetivo: Computadoras con Windows.
- Modelo multijugador: ENet/UDP, con servidor dedicado autoritativo (Godot en modo headless, sin interfaz gráfica).
- Persistencia de datos: Archivos de guardado locales en formato JSON (`user://savegame.json`).

## Estructura del repositorio

- `/scenes` — Escenas del juego y de la interfaz de usuario.
- `/scripts` — Scripts del proyecto y módulos principales.
- `/assets` — Recursos originales de arte y audio.
- `/resources` — Recursos de Godot (`.tres`, `.res`).
- `/tests` — Estructura para pruebas automatizadas y manuales.
- `/docs` — Documentación de arquitectura, API, generación procedural y guías para colaboradores.

## Responsabilidades del equipo

- Angel Bustos: Redes, servidor dedicado y sincronización multijugador.
- Chris Aguilera: Mecánicas de juego, combate, enemigos y generación procedural.
- Isaac Hernandez: Interfaz de usuario, progresión e integración visual.

## Primeros pasos

1. Instalar Godot 4.x (versión estándar, sin Mono/.NET).
2. Clonar este repositorio.
3. Abrir Godot e importar el proyecto desde `/home/runner/work/tesis/tesis/project.godot`.
4. Ejecutar el proyecto presionando `F5` para abrir el menú principal.
5. Hacer clic en Jugar (Play) para iniciar la escena del prototipo de desplazamiento lateral.

## Ejecución del servidor dedicado (estructura inicial provisional del servidor autoritativo)

```
godot4 --headless --path /home/runner/work/tesis/tesis
```

## Validación y pasos para pruebas manuales

1. Iniciar el proyecto desde `res://scenes/main/Main.tscn` (escena de inicio predeterminada).
2. Presionar Jugar (Play) en el menú principal.
3. Comprobar que el personaje pueda:
   - Moverse hacia la izquierda y derecha (`A`/`D` o las flechas del teclado).
   - Saltar (`Espacio`, `W` o flecha hacia arriba).
   - Caer por efecto de la gravedad y aterrizar sobre el suelo o las plataformas.
4. Verificar que la cámara `Camera2D` siga al personaje.
5. Comprobar que los sistemas globales (autoloads) sigan disponibles:
   - `GameEvents`
   - `NetworkManager`
   - `SaveManager`

## Flujo de trabajo colaborativo

- Utilizar ramas de desarrollo de corta duración para cada módulo (`feature/gameplay-*`, `feature/network-*`, etc.).
- Mantener las solicitudes de integración (Pull Requests) pequeñas y enfocadas en funcionalidades específicas.
- Seguir las indicaciones del archivo `/docs/contributing.md` para conocer las convenciones de desarrollo y los criterios de revisión.
