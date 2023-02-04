package aroots

import raylib "vendor:raylib"

InputCooldownSeconds 	:: 0.4

Rectangle :: struct {
	centerPosition: raylib.Vector2,
	size:           raylib.Vector2,
}

CharacterPlayer :: struct{
  using rectangle: 	Rectangle,
  using input: 		InputScheme,
		texture: 	raylib.Texture,
}

InputScheme :: struct {
	upButton:   	raylib.KeyboardKey,
	leftButton: 	raylib.KeyboardKey,
	downButton: 	raylib.KeyboardKey,
	rightButton:	raylib.KeyboardKey,
}

character_player: CharacterPlayer
height: 	i32
width: 		i32
timerInputCooldown: f32

main :: proc () {
	raylib.InitWindow(800, 600, "Altered Roots")
	defer raylib.CloseWindow()
	raylib.SetTargetFPS(60)

	height = raylib.GetScreenHeight()
	width = raylib.GetScreenWidth()

	character_player = CharacterPlayer{}
	{	// Load images
		character := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/character.png")
		defer raylib.UnloadImage(character)
		{
			raylib.ImageResize(&character, 100,100)
			character_texture := raylib.LoadTextureFromImage(character)
			assert(character_texture.id > 0)
			character_player.texture = character_texture
		}
	}
	defer raylib.UnloadTexture(character_player.texture);  
	{	// Bind to data
		character_player.centerPosition = raylib.Vector2{cast(f32)(width/2 - character_player.texture.width/2), cast(f32)(height/2 - character_player.texture.height/2 - 40)}
		character_player.input = InputScheme{
			.W,
			.A,
			.S,
			.D,
		}
	}

	for !raylib.WindowShouldClose() {
		raylib.BeginDrawing()
		defer raylib.EndDrawing()
		raylib.ClearBackground(raylib.BLACK)

		// Intentionally reassign width and height
		height = raylib.GetScreenHeight()
		width = raylib.GetScreenWidth()
		dt := raylib.GetFrameTime()
		Update(dt)
		Draw()
	}
}

Update :: proc (deltaTime:f32) {
	if HasHitTime(&timerInputCooldown, deltaTime) {
		if(raylib.IsKeyDown(character_player.upButton)){
			timerInputCooldown = InputCooldownSeconds
			// Update position
			character_player.centerPosition.y += 100
		}
		if(raylib.IsKeyDown(character_player.downButton)){
			timerInputCooldown = InputCooldownSeconds
			// Update position
			character_player.centerPosition.y -= 100
		}
		if(raylib.IsKeyDown(character_player.leftButton)){
			timerInputCooldown = InputCooldownSeconds
			// Update position
			character_player.centerPosition.x -= 100
		}
		if(raylib.IsKeyDown(character_player.rightButton)){
			timerInputCooldown = InputCooldownSeconds
			// Update position
			character_player.centerPosition.x += 100
		}
	}
}

Draw :: proc () {
    raylib.DrawTexture(character_player.texture, cast(i32)character_player.centerPosition.x, cast(i32)character_player.centerPosition.y, raylib.WHITE)
}

HasHitTime :: proc(timeRemaining:^f32, deltaTime:f32) ->bool {
	timeRemaining^ = timeRemaining^ - deltaTime
	return timeRemaining^ <= 0
}