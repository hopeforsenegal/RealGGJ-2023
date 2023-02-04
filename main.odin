package aroots

import "core:fmt"
import "core:intrinsics"
import "core:math"
import "core:strings"
import raylib "vendor:raylib"

InputCooldownSeconds 	:: 0.4
StandardDimensionsX 	:: 100
StandardDimensionsY 	:: 100

TextAlignment :: enum {
	Left, 
	Center,
	Right,
}

GUI :: struct{
	color: raylib.Color,
	fontSize: i32,
}

InputScheme :: struct {
	upButton:   	raylib.KeyboardKey,
	leftButton: 	raylib.KeyboardKey,
	downButton: 	raylib.KeyboardKey,
	rightButton:	raylib.KeyboardKey,
	interactButton:	raylib.KeyboardKey,
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
  using imageData: 	       ImageData,
  using input: 			   InputScheme,
  		lastDirectionRight: bool,
}

GrandMa :: struct {
  using imageData: 	ImageData,
}

WateringCan :: struct {
  using imageData: 	ImageData,
}

Plant :: struct {
  using imageData: 	ImageData,
}

Crate :: struct {
  outerImageData: 	ImageData,
  innerImageData: 	ImageData,
}

Ground :: struct {
  using imageData: 	ImageData,
}

ChatBubble :: struct{
  using imageData: 	ImageData,
  dialogueIndex: 	i32,
}

ColorFade :: struct {
	timerScreenFade: 	f32,
	initialTime: 		f32,
	colorFrom: 			raylib.Color,
	colorTo: 			raylib.Color,
}

DialogueSegment :: struct {
	text: 		string,
	timerText: 	f32,
}

gui: GUI
ground: 			Ground
character_player: 	CharacterPlayer
grandma: 			GrandMa
watering_can: 		WateringCan
crate: 				Crate
plant1: 			Plant
chat_br: 			ChatBubble
screenFade: 		ColorFade
screenFadeColor:	raylib.Color
screen_height: 		i32
screen_width: 		i32
timerInputCooldown:			f32

dialogue1: [4]DialogueSegment


main :: proc () {
	assert(NumberOfCharacters("thiss", 'x') == 0)
	assert(NumberOfCharacters("thiss", 't') == 1)
	assert(NumberOfCharacters("thiss", 's') == 2)
	assert(NumberOfCharacters("thi\nss", '\n') == 1)
	raylib.InitWindow(800, 600, "Altered Roots")
	defer raylib.CloseWindow()
	raylib.SetTargetFPS(60)

	screen_height = raylib.GetScreenHeight()
	screen_width = raylib.GetScreenWidth()

	ground = Ground{}
	character_player = CharacterPlayer{}
	grandma = GrandMa{}
	plant1 = Plant{}
	crate = Crate{}
	{	// Load images
		ground_image := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/ground.png")
		defer raylib.UnloadImage(ground_image)		
		character_image := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/character.png")
		defer raylib.UnloadImage(character_image)	
		watering_can_image := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/watering_can.png")
		defer raylib.UnloadImage(watering_can_image)	
		grandma_image := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/grandma.png")
		defer raylib.UnloadImage(grandma_image)
		plant_image := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/plant.png")
		defer raylib.UnloadImage(plant_image)
		crate_image := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/crate.png")
		defer raylib.UnloadImage(crate_image)
		chat_bottom_left_image := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/chat_bottom_left.png")
		defer raylib.UnloadImage(chat_bottom_left_image)
		chat_bottom_right_image := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/chat_bottom_right.png")
		defer raylib.UnloadImage(chat_bottom_right_image)
		chat_top_left_image := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/chat_top_left.png")
		defer raylib.UnloadImage(chat_top_left_image)

		ResizeAndBindImageData(&ground, &ground_image, screen_width, screen_height)
		ResizeAndBindImageData(&character_player, &character_image, StandardDimensionsX, StandardDimensionsY)
		ResizeAndBindImageData(&watering_can, &watering_can_image, cast(i32)character_player.size.x/2, cast(i32)character_player.size.y/2 - 10)
		ResizeAndBindImageData(&grandma, &grandma_image, StandardDimensionsX, StandardDimensionsY)
		ResizeAndBindImageData(&plant1, &plant_image, StandardDimensionsX, StandardDimensionsY)
		ResizeAndBindImageData(&crate.outerImageData, &crate_image, cast(i32)character_player.size.x/2, cast(i32)character_player.size.y/2)
		ResizeAndBindImageData(&crate.innerImageData, &crate_image, cast(i32)character_player.size.x/4, cast(i32)character_player.size.y/4)
		ResizeAndBindImageData(&chat_br, &chat_bottom_right_image, 200, 150)
	}
	defer raylib.UnloadTexture(ground.texture)
	defer raylib.UnloadTexture(character_player.texture)
	defer raylib.UnloadTexture(watering_can.texture)
	defer raylib.UnloadTexture(crate.outerImageData.texture)
	defer raylib.UnloadTexture(crate.innerImageData.texture)
	defer raylib.UnloadTexture(grandma.texture)
	defer raylib.UnloadTexture(plant1.texture)
	defer raylib.UnloadTexture(chat_br.texture)
	{	
		// Setup gui
		gui.color = raylib.WHITE
		gui.fontSize = 20
		// Starting positions
		ground.centerPosition = raylib.Vector2{(cast(f32)(screen_width/2)), (cast(f32)(screen_height/2))}
		character_player.centerPosition = raylib.Vector2{(cast(f32)(screen_width/2) - character_player.size.x/2), (cast(f32)(screen_height/2) - character_player.size.y/2)}
		grandma.centerPosition = raylib.Vector2{cast(f32)(screen_width) - cast(f32)(grandma.size.x/2), cast(f32)(grandma.size.y/2) + 100}
		plant1.centerPosition = raylib.Vector2{cast(f32)(plant1.size.x/2), cast(f32)(plant1.size.y/2)}
		crate.outerImageData.centerPosition = raylib.Vector2{750,575}
		crate.innerImageData.centerPosition = raylib.Vector2{750,575}
		chat_br.centerPosition = raylib.Vector2{grandma.centerPosition.x - 85, grandma.centerPosition.y-80}
		// Setup input
		character_player.input = InputScheme{
			.W,
			.A,
			.S,
			.D,
			.ENTER,
		}
		// Setup screen fade
		screenFade = MakeColorFade(3, raylib.BLACK, raylib.Color{1,1,1,0})
		// Setup dialogue
		chat_br.dialogueIndex = -1
		dialogue1[0] = DialogueSegment{text="Um...", timerText=3}
		dialogue1[1] = DialogueSegment{text="Hey child", timerText=3}
		dialogue1[2] = DialogueSegment{text="You planting\nthose plants\nyet?", timerText=3}
		dialogue1[3] = DialogueSegment{text="Granny\nis getting\nold!", timerText=3}
	}

	for !raylib.WindowShouldClose() {
		raylib.BeginDrawing()
		defer raylib.EndDrawing()
		raylib.ClearBackground(raylib.BLACK)

		// Intentionally reassign width and height incase we allow resizes
		screen_height = raylib.GetScreenHeight()
		screen_width = raylib.GetScreenWidth()
		dt := raylib.GetFrameTime()
		Update(dt)
		Draw()
	}
}

Update :: proc (deltaTime:f32) {
	if !HasHitTime(&screenFade.timerScreenFade, deltaTime) {
		t := screenFade.timerScreenFade/ screenFade.initialTime
		screenFadeColor = ColorLerp(screenFade.colorTo, screenFade.colorFrom, t)
	}else{
		// Show first dialogue
		if(chat_br.dialogueIndex < 0) {
			chat_br.dialogueIndex = 0;
		}
	}
	if(chat_br.dialogueIndex >= 0){
		if HasHitTime(&dialogue1[chat_br.dialogueIndex].timerText, deltaTime) {
			fmt.println("dialogueIndex:", chat_br.dialogueIndex)
			chat_br.dialogueIndex = chat_br.dialogueIndex + 1
			if(chat_br.dialogueIndex >= len(dialogue1)) { 
				chat_br.dialogueIndex = -1
			}
		}
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
			character_player.lastDirectionRight = false
		}
		if(raylib.IsKeyDown(character_player.rightButton)){
			timerInputCooldown = InputCooldownSeconds
			// Update position
			character_player.centerPosition.x += 100
			character_player.lastDirectionRight = true
		}
		// Keep player in level bounds
		if character_player.centerPosition.x+(character_player.size.x/2) > cast(f32)(screen_width) {
			character_player.centerPosition.x = cast(f32)(screen_width) - (character_player.size.x / 2)
		}
		if character_player.centerPosition.x-(character_player.size.x/2) < 0 {
			character_player.centerPosition.x = (character_player.size.x / 2)
		}
		if character_player.centerPosition.y+(character_player.size.y/2) > cast(f32)(screen_height) {
			character_player.centerPosition.y = cast(f32)(screen_height) - (character_player.size.y / 2)
		}
		if character_player.centerPosition.y-(character_player.size.y/2) < 0 {
			character_player.centerPosition.y = (character_player.size.y / 2)
		}
		// Detect by plants
		if character_player.centerPosition.x-(character_player.size.x/2) < 100 {
				fmt.println("plant")
		}
		// Set watering can to player position
		watering_can.centerPosition = character_player.centerPosition
	}
}

Draw :: proc () {
	{	// Ground
		x,y  := ToScreenOffsetPosition(ground);
		raylib.DrawTexture(ground.texture, x, y, raylib.WHITE)
	}
	{	// Player
		x,y := ToScreenOffsetPosition(character_player);
		position:= raylib.Vector2{cast(f32)x, cast(f32)y}
		texture_width := cast(f32)character_player.texture.width * (character_player.lastDirectionRight?-1:1)
		texture_height := cast(f32)character_player.texture.height
		raylib.DrawTextureRec(character_player.texture, raylib.Rectangle{ 0,0, texture_width, texture_height }, position, raylib.WHITE)
	}
	{	// Grandma
		x,y := ToScreenOffsetPosition(grandma);
		raylib.DrawTexture(grandma.texture, x, y, raylib.WHITE)
	}
	{	// Plants
		x,y  := ToScreenOffsetPosition(plant1);
		raylib.DrawTexture(plant1.texture, x, y, raylib.WHITE)
	}
	{	// Crate
		x,y  := ToScreenOffsetPosition(crate.outerImageData);
		raylib.DrawTexture(crate.outerImageData.texture, x, y, raylib.WHITE)
		x,y  = ToScreenOffsetPosition(crate.innerImageData);
		raylib.DrawTexture(crate.innerImageData.texture, x, y, raylib.WHITE)
	}
	{	// Chat bubble
		if(chat_br.dialogueIndex >= 0){
			if(dialogue1[chat_br.dialogueIndex].timerText > 0) {
  				local_scope_color(raylib.BLACK)
				GUI_DrawSpeechBubble(chat_br, dialogue1[chat_br.dialogueIndex].text)
			}
		}
	}
	{	// Progress Bar
  		local_scope_color(raylib.BLACK)
		GUI_ProgressBarVertical(raylib.Rectangle{0,0,5,50}, "", 1, 0, 1, false)
		GUI_ProgressBarVertical(raylib.Rectangle{5,40,5,50}, "", 1, 0, 1, false)
	}
	{	// Progress Bar
  		local_scope_color(raylib.WHITE)
		GUI_ProgressBarVertical(raylib.Rectangle{40,0,5,50}, "", 1, 0, 1, false)
		GUI_ProgressBarVertical(raylib.Rectangle{45,40,5,50}, "", 1, 0, 1, false)
	}
	{	// Screen Fade
		if(screenFade.timerScreenFade > 0){
			raylib.DrawRectangle(0, 0, screen_width, screen_height, screenFadeColor)
		}
	}
	{	// Debug
		if(raylib.IsKeyDown(.SPACE)){
  			local_scope_color(raylib.BLACK)
			GUI_DrawSpeechBubble(chat_br, "test")

			x,y  := ToScreenOffsetPosition(watering_can);
			position:= raylib.Vector2{cast(f32)x, cast(f32)y}
			texture_width := cast(f32)watering_can.texture.width * (character_player.lastDirectionRight?-1:1)
			texture_height := cast(f32)watering_can.texture.height
			raylib.DrawTextureRec(watering_can.texture, raylib.Rectangle{ 0,0, texture_width, texture_height }, position, raylib.WHITE)
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

GUI_DrawSpeechBubble :: proc(imageData: ImageData, 
					 	 	 text: string) {
	fontSize := gui.fontSize
	topLeftX,topLeftY  := ToScreenOffsetPosition(imageData);
	centerX:= topLeftX + cast(i32)(imageData.size.x/2)
	centerY:= topLeftY + cast(i32)(imageData.size.y/2)
	newText := strings.clone_to_cstring(text)
	numberOfNewlines :=  NumberOfCharacters(text, '\n')
	yBias := cast(i32)(numberOfNewlines>=1?numberOfNewlines*30: 20)
	defer delete(newText)

	raylib.DrawTexture(imageData.texture, topLeftX, topLeftY, raylib.WHITE)
	GUI_DrawText(newText, TextAlignment.Center, centerX, centerY - yBias, fontSize)
}

GUI_ProgressBarVertical :: proc(bounds: raylib.Rectangle, 
								text: string,	// ignore for now
								value : f32,
								min_value : f32,	// ignore for now
								max_value : f32,// ignore for now
								show_value : bool) -> f32 {
	color := gui.color
	newValue := clamp(0, 1, value)
	x := cast(i32)bounds.x
	y := cast(i32)bounds.y
	w := cast(i32)bounds.width
	h := cast(i32)(bounds.height * newValue)
	raylib.DrawRectangle(x, y, w, h, color)	
	// Should/could draw text
    return newValue	// should be a scale instead of clamp
}

GUI_DrawText :: proc (text:cstring, alignment:TextAlignment, posX:i32, posY:i32, fontSize :i32){
	color := gui.color
	if alignment == .Left {
		 raylib.DrawText(text, posX, posY, fontSize, color)
	} else if alignment == .Center {
		scoreSizeLeft := raylib.MeasureText(text, fontSize)
		raylib.DrawText(text, (posX - scoreSizeLeft/2), posY, fontSize, color)
	} else if alignment == .Right {
		scoreSizeLeft := raylib.MeasureText(text, fontSize)
		raylib.DrawText(text, (posX - scoreSizeLeft), posY, fontSize, color)
	}
}

NumberOfCharacters :: proc(text:string, of:rune) -> int{
	num := 0
	for character in text {
		if(character == of){
			num = num + 1
		}
	}
	return num
}

/* The following two functions make dealing with gui color easier like the following
	{
		currentColor := gui.color
		defer gui.color = currentColor
		gui.color = BLACK
		...
	}
*/
restore_color :: proc(color: raylib.Color) {
  gui.color = color
}

@(deferred_out=restore_color)
local_scope_color :: proc(color: raylib.Color) -> raylib.Color {
  current_color := gui.color
  gui.color = color
  return current_color
}