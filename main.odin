package aroots

import raylib "vendor:raylib"

InputCooldownSeconds 	:: 0.4
StandardDimensionsX 	:: 100
StandardDimensionsY 	:: 100

Rectangle :: struct {
	centerPosition: raylib.Vector2,
	size:           raylib.Vector2,
}

CharacterPlayer :: struct{
  using rectangle: 	Rectangle,
  using input: 		InputScheme,
		texture: 	raylib.Texture,
}

Plant :: struct{
  using rectangle: 	Rectangle,
		texture: 	raylib.Texture,
}

Ground :: struct{
  using rectangle: 	Rectangle,
		texture: 	raylib.Texture,
}

InputScheme :: struct {
	upButton:   	raylib.KeyboardKey,
	leftButton: 	raylib.KeyboardKey,
	downButton: 	raylib.KeyboardKey,
	rightButton:	raylib.KeyboardKey,
}

ground: 			Ground
character_player: 	CharacterPlayer
plant1: 			Plant
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
	plant1 = Plant{}
	{	// Load images
		ground_image := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/ground.png")
		defer raylib.UnloadImage(ground_image)
		{
			raylib.ImageResize(&ground_image, StandardDimensionsX * 8, StandardDimensionsY * 6)
			ground_texture := raylib.LoadTextureFromImage(ground_image)
			assert(ground_texture.id > 0)
			ground.texture = ground_texture
			ground.size = raylib.Vector2{cast(f32)ground_texture.width, cast(f32)ground_texture.height}
		}
		character_image := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/character.png")
		defer raylib.UnloadImage(character_image)
		{
			raylib.ImageResize(&character_image, StandardDimensionsX, StandardDimensionsY)
			character_texture := raylib.LoadTextureFromImage(character_image)
			assert(character_texture.id > 0)
			character_player.texture = character_texture
			character_player.size = raylib.Vector2{cast(f32)character_texture.width, cast(f32)character_texture.height}
		}
		plant_image := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/plant.png")
		defer raylib.UnloadImage(plant_image)
		{
			raylib.ImageResize(&plant_image, StandardDimensionsX, StandardDimensionsY)
			plant_texture := raylib.LoadTextureFromImage(plant_image)
			assert(plant_texture.id > 0)
			plant1.texture = plant_texture
			plant1.size = raylib.Vector2{cast(f32)plant_texture.width, cast(f32)plant_texture.height}
		}
	}
	defer raylib.UnloadTexture(ground.texture)
	defer raylib.UnloadTexture(character_player.texture)
	defer raylib.UnloadTexture(plant1.texture)
	{	
		// Starting positions
		ground.centerPosition = raylib.Vector2{(cast(f32)(width/2)), (cast(f32)(height/2))}
		character_player.centerPosition = raylib.Vector2{(cast(f32)(width/2) - character_player.size.x/2), (cast(f32)(height/2) - character_player.size.y/2)}
		plant1.centerPosition = raylib.Vector2{cast(f32)(plant1.size.x/2), cast(f32)(plant1.size.y/2)}
		// Setup input
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
			character_player.centerPosition.y -= 100
		}
		if(raylib.IsKeyDown(character_player.downButton)){
			timerInputCooldown = InputCooldownSeconds
			// Update position
			character_player.centerPosition.y += 100
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
	{	// Ground
		x,y  := ToScreenOffsetPosition(ground);
		raylib.DrawTexture(ground.texture, x, y, raylib.WHITE)
	}
	{	// Player
		x,y := ToScreenOffsetPosition(character_player);
		raylib.DrawTexture(character_player.texture, x, y, raylib.WHITE)
	}
	{	// Plants
		x,y  := ToScreenOffsetPosition(plant1);
		raylib.DrawTexture(plant1.texture, x, y, raylib.WHITE)
	}
}

ToScreenOffsetPosition :: proc(using rectangle:Rectangle) -> (i32, i32) {
	return cast(i32)(centerPosition.x - size.x/2), cast(i32)(centerPosition.y - size.y/2)
}

HasHitTime :: proc(timeRemaining:^f32, deltaTime:f32) ->bool {
	timeRemaining^ = timeRemaining^ - deltaTime
	return timeRemaining^ <= 0
}