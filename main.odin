package aroots

import raylib "vendor:raylib"


Rectangle :: struct {
	centerPosition: raylib.Vector2,
	size:           raylib.Vector2,
}

CharacterImage :: struct{
  using rectangle: Rectangle,
		texture: raylib.Texture,
}

character_player: CharacterImage
height: 	i32
width: 		i32

main :: proc () {
	raylib.InitWindow(800, 450, "Altered Roots")
	defer raylib.CloseWindow()

	height = raylib.GetScreenHeight()
	width = raylib.GetScreenWidth()

	character_player = CharacterImage{}
	{	// Load images
		character := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/character.png")
		defer raylib.UnloadImage(character)
    	character_texture := raylib.LoadTextureFromImage(character)
		assert(character_texture.id > 0)
		character_player.texture = character_texture
	}
	defer raylib.UnloadTexture(character_player.texture);  
	{	// Bind to data
		character_player.centerPosition = raylib.Vector2{cast(f32)(width/2 - character_player.texture.width/2), cast(f32)(height/2 - character_player.texture.height/2 - 40)}
	}

	raylib.SetTargetFPS(60)

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



Update :: proc (deltaTime:f32){
}

Draw :: proc (){
    raylib.DrawTexture(character_player.texture, cast(i32)character_player.centerPosition.x, cast(i32)character_player.centerPosition.y, raylib.WHITE)
}