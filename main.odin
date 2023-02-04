package aroots

import raylib "vendor:raylib"

InputCooldownSeconds 	:: 0.4
StandardDimensionsX 	:: 100
StandardDimensionsY 	:: 100

InputScheme :: struct {
	upButton:   	raylib.KeyboardKey,
	leftButton: 	raylib.KeyboardKey,
	downButton: 	raylib.KeyboardKey,
	rightButton:	raylib.KeyboardKey,
}

ImageData :: struct{
  using rectangle: 	Rectangle,
		texture: 	raylib.Texture,
}

Rectangle :: struct {
	centerPosition: raylib.Vector2,
	size:           raylib.Vector2,
}

CharacterPlayer :: struct {
  using imageData: 	ImageData,
  using input: 		InputScheme,
}

Plant :: struct {
  using imageData: 	ImageData,
}

Ground :: struct {
  using imageData: 	ImageData,
}

ColorFade :: struct {
	timerScreenFade: 	f32,
	initialTime: 		f32,
	colorFrom: 			raylib.Color,
	colorTo: 			raylib.Color,
}

ground: 			Ground
character_player: 	CharacterPlayer
plant1: 			Plant
screenFade: 		ColorFade
screenFadeColor:	raylib.Color
height: 	i32
width: 		i32
timerInputCooldown:			f32


main :: proc () {
	raylib.InitWindow(800, 600, "Altered Roots")
	defer raylib.CloseWindow()
	raylib.SetTargetFPS(60)

	height = raylib.GetScreenHeight()
	width = raylib.GetScreenWidth()

	ground = Ground{}
	character_player = CharacterPlayer{}
	plant1 = Plant{}
	{	// Load images
		ground_image := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/ground.png")
		defer raylib.UnloadImage(ground_image)		
		character_image := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/character.png")
		defer raylib.UnloadImage(character_image)
		plant_image := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/plant.png")
		defer raylib.UnloadImage(plant_image)

		ResizeAndBindImageData(&ground, &ground_image, StandardDimensionsX * 8, StandardDimensionsY * 6)
		ResizeAndBindImageData(&character_player, &character_image, StandardDimensionsX, StandardDimensionsY)
		ResizeAndBindImageData(&plant1, &plant_image, StandardDimensionsX, StandardDimensionsY)
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
		// Setup screen fade
		screenFade = MakeColorFade(3, raylib.BLACK, raylib.WHITE)
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
	if !HasHitTime(&screenFade.timerScreenFade, deltaTime) {
		t := screenFade.timerScreenFade/ screenFade.initialTime
		screenFadeColor = ColorLerp(screenFade.colorTo, screenFade.colorFrom, t)
	}
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
	{	// Screen Fade
		if(screenFade.timerScreenFade > 0){
			raylib.DrawRectangle(0, 0, width, height, screenFadeColor)
		}
	}
}

ToScreenOffsetPosition :: proc(using rectangle:Rectangle) -> (i32, i32) {
	return cast(i32)(centerPosition.x - size.x/2), cast(i32)(centerPosition.y - size.y/2)
}

HasHitTime :: proc(timeRemaining:^f32, deltaTime:f32) ->bool {
	timeRemaining^ = timeRemaining^ - deltaTime
	return timeRemaining^ <= 0
}

ResizeAndBindImageData :: proc(imageData:^ImageData, image:^raylib.Image, dimensionX:i32, dimensionY:i32) {
	raylib.ImageResize(image, dimensionX, dimensionY)
	texture := raylib.LoadTextureFromImage(image^)
	assert(texture.id > 0)
	imageData.texture = texture
	imageData.size = raylib.Vector2{cast(f32)texture.width, cast(f32)texture.height}
}

MakeColorFade :: proc(initialTime:f32, colorFrom: raylib.Color, colorTo:raylib.Color) -> ColorFade{
	return ColorFade{initialTime, initialTime, colorFrom, colorTo}
}

Lerp :: proc(from:u8, to:u8, t:f32) ->u8 {
     return cast(u8)(cast(f32)from * (1 - t)) + cast(u8)(cast(f32)to * t);
}

ColorLerp :: proc(from:raylib.Color, to:raylib.Color, t:f32) -> raylib.Color {
    r := Lerp(from.r, to.r, t);
    g := Lerp(from.g, to.g, t);
    b := Lerp(from.b, to.b, t);
    a := Lerp(from.a, to.a, t);
    return raylib.Color{r,g,b,a}
}