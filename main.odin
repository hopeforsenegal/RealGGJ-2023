package aroots

import "core:fmt"
import "core:intrinsics"
import "core:math"
import "core:strings"
import raylib "vendor:raylib"

InputCooldownSeconds 	:: 0.4
StandardDimensionsX 	:: 100
StandardDimensionsY 	:: 100

DurationScreenFade			:: 3
DurationSelectedCrateFade 	:: 1

ColorHalfTransparent 	:: raylib.Color{255,255,255,120}
ColorTransparent 		:: raylib.Color{1,1,1,0}

TextAlignment :: enum {
	Left, 
	Center,
	Right,
}

GUI :: struct {
	color: raylib.Color,
	fontSize: i32,
}

Actions :: struct {
    left: bool,
    up: bool,
    down: bool,
    right: bool,
    interact: bool,
}

InputScheme :: struct {
	upButton:   	raylib.KeyboardKey,
	upButton2:   	raylib.KeyboardKey,
	leftButton: 	raylib.KeyboardKey,
	leftButton2: 	raylib.KeyboardKey,
	downButton: 	raylib.KeyboardKey,
	downButton2: 	raylib.KeyboardKey,
	rightButton:	raylib.KeyboardKey,
	rightButton2:	raylib.KeyboardKey,
	interactButton:		raylib.KeyboardKey,
	interactButton2:	raylib.KeyboardKey,
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

Plot :: struct {
	plotImageData: 		ImageData,
	seededImageData: 	ImageData,
	plantImageData: 	ImageData,
	bloomImageData: 	ImageData,
	colorFadeBloom:		ColorFade,
}

Crate :: struct {
  outerImageData: 	ImageData,
  innerImageData: 	ImageData,
  bloomImageData: 	ImageData,
  colorFadeBloom:	ColorFade,
  hovering:			bool,
  selected:			bool,
}

Ground :: struct {
  using imageData: 	ImageData,
}

ChatBubble :: struct{
  using imageData: 	ImageData,
  dialogueIndex: 	i32,
}

ColorFade :: struct {
	timerColorFade: 	f32,
	initialTime: 		f32,
	colorFrom: 			raylib.Color,
	colorTo: 			raylib.Color,
  	colorCurrent:		raylib.Color,
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
red_crate: 			Crate
plot1: 				Plot
chat_br: 			ChatBubble
screenFade: 		ColorFade
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
	plot1 = Plot{}
	red_crate = Crate{}
	{	// Load images
		ground_image := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/ground.png")
		defer raylib.UnloadImage(ground_image)		
		character_image := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/character.png")
		defer raylib.UnloadImage(character_image)	
		watering_can_image := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/watering_can.png")
		defer raylib.UnloadImage(watering_can_image)	
		grandma_image := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/grandma.png")
		defer raylib.UnloadImage(grandma_image)
		plot_image := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/plot.png")
		defer raylib.UnloadImage(plot_image)
		seeds_image := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/seeds.png")
		defer raylib.UnloadImage(seeds_image)
		plant_image := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/plant.png")
		defer raylib.UnloadImage(plant_image)
		crate_image := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/crate.png")
		defer raylib.UnloadImage(crate_image)
		seed_icon_image := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/seed_icon.png")
		defer raylib.UnloadImage(seed_icon_image)
		selection_bloom_image := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/selection_bloom.png")
		defer raylib.UnloadImage(selection_bloom_image)
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
		ResizeAndBindImageData(&plot1.plotImageData, &plot_image, StandardDimensionsX, StandardDimensionsY)
		ResizeAndBindImageData(&plot1.seededImageData, &seeds_image, StandardDimensionsX, StandardDimensionsY)
		ResizeAndBindImageData(&plot1.plantImageData, &plant_image, StandardDimensionsX, StandardDimensionsY)
		ResizeAndBindImageData(&plot1.bloomImageData, &selection_bloom_image, StandardDimensionsX, StandardDimensionsY)
		ResizeAndBindImageData(&red_crate.outerImageData, &crate_image, cast(i32)character_player.size.x/2, cast(i32)character_player.size.y/2)
		ResizeAndBindImageData(&red_crate.innerImageData, &seed_icon_image, cast(i32)character_player.size.x/4, cast(i32)character_player.size.y/4)
		ResizeAndBindImageData(&red_crate.bloomImageData, &selection_bloom_image, cast(i32)character_player.size.x, cast(i32)character_player.size.y)
		ResizeAndBindImageData(&chat_br, &chat_bottom_right_image, 200, 150)
	}
	defer raylib.UnloadTexture(ground.texture)
	defer raylib.UnloadTexture(character_player.texture)
	defer raylib.UnloadTexture(watering_can.texture)
	defer raylib.UnloadTexture(plot1.plotImageData.texture)
	defer raylib.UnloadTexture(plot1.seededImageData.texture)
	defer raylib.UnloadTexture(plot1.plantImageData.texture)
	defer raylib.UnloadTexture(plot1.bloomImageData.texture)
	defer raylib.UnloadTexture(red_crate.outerImageData.texture)
	defer raylib.UnloadTexture(red_crate.innerImageData.texture)
	defer raylib.UnloadTexture(red_crate.bloomImageData.texture)
	defer raylib.UnloadTexture(grandma.texture)
	defer raylib.UnloadTexture(chat_br.texture)
	{	
		// Setup gui
		gui.color = raylib.WHITE
		gui.fontSize = 20
		// Starting positions
		ground.centerPosition = raylib.Vector2{(cast(f32)(screen_width/2)), (cast(f32)(screen_height/2))}
		character_player.centerPosition = raylib.Vector2{(cast(f32)(screen_width/2) - character_player.size.x/2), (cast(f32)(screen_height/2) - character_player.size.y/2)}
		grandma.centerPosition = raylib.Vector2{cast(f32)(screen_width) - cast(f32)(grandma.size.x/2), cast(f32)(grandma.size.y/2) + 100}
		plot1.plotImageData.centerPosition = raylib.Vector2{cast(f32)(plot1.plotImageData.size.x/2), cast(f32)(plot1.plotImageData.size.y/2)}
		plot1.seededImageData.centerPosition = raylib.Vector2{cast(f32)(plot1.plotImageData.size.x/2), cast(f32)(plot1.plotImageData.size.y/2)}
		plot1.plantImageData.centerPosition = raylib.Vector2{cast(f32)(plot1.plotImageData.size.x/2), cast(f32)(plot1.plotImageData.size.y/2)}
		red_crate.outerImageData.centerPosition = raylib.Vector2{750,575}
		red_crate.innerImageData.centerPosition = raylib.Vector2{750,575}
		red_crate.bloomImageData.centerPosition = raylib.Vector2{750,575}
		chat_br.centerPosition = raylib.Vector2{grandma.centerPosition.x - 85, grandma.centerPosition.y-80}
		// Setup input
		character_player.input = InputScheme{
			.W,
			.UP,
			.A,
			.LEFT,
			.S,
			.DOWN,
			.D,
			.RIGHT,
			.ENTER,
			.SPACE,
		}
		// Setup various fades
		screenFade = MakeColorFade(DurationScreenFade, raylib.BLACK, ColorTransparent)
		red_crate.colorFadeBloom = MakeColorFade(DurationSelectedCrateFade, raylib.WHITE, ColorTransparent)
		plot1.colorFadeBloom = MakeColorFade(DurationSelectedCrateFade, raylib.WHITE, ColorTransparent)
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
    actions := GetUserActions(character_player);

	if !HasHitTime(&screenFade.timerColorFade, deltaTime) {
		t := screenFade.timerColorFade/ screenFade.initialTime
		screenFade.colorCurrent = ColorLerp(screenFade.colorTo, screenFade.colorFrom, t)
	}else{
		// Show first dialogue
		if(chat_br.dialogueIndex < 0) {
			chat_br.dialogueIndex = 0
		}
	}
	if(chat_br.dialogueIndex >= 0){
		if HasHitTime(&dialogue1[chat_br.dialogueIndex].timerText, deltaTime) {
			//fmt.println("dialogueIndex:", chat_br.dialogueIndex)
			// TODO: we should probably fix this at some point
			chat_br.dialogueIndex = chat_br.dialogueIndex + 1
			if(chat_br.dialogueIndex >= len(dialogue1)) { 
				chat_br.dialogueIndex = -1
			}
		}
	}
	if HasHitTime(&timerInputCooldown, deltaTime) {
		if(actions.up){
			actions.up = false
			timerInputCooldown = InputCooldownSeconds
			// Update position
			character_player.centerPosition.y -= 100
		}
		if(actions.down){
			actions.down = false
			timerInputCooldown = InputCooldownSeconds
			// Update position
			character_player.centerPosition.y += 100
		}
		if(actions.left){
			actions.left = false
			timerInputCooldown = InputCooldownSeconds
			// Update position
			character_player.centerPosition.x -= 100
			character_player.lastDirectionRight = false
		}
		if(actions.right){
			actions.right = false
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
		// Detect by objects of interest
		if character_player.centerPosition.x-(character_player.size.x/2) < 100 {
			fmt.println("plant")
		}
		red_crate.hovering = false
		if character_player.centerPosition.y+(character_player.size.y/2) > cast(f32)(screen_height) - 100 {
			if(character_player.centerPosition.x >=700){
				red_crate.hovering = true
			}			
		}
	}

	if(red_crate.hovering && actions.interact){
		actions.interact = false
		red_crate.selected = true
		// deselect others
	}
	if(red_crate.selected){
		red_crate.colorFadeBloom.timerColorFade = red_crate.colorFadeBloom.timerColorFade - deltaTime
		t := red_crate.colorFadeBloom.timerColorFade/ red_crate.colorFadeBloom.initialTime
		red_crate.colorFadeBloom.colorCurrent = ColorLerp(red_crate.colorFadeBloom.colorTo, red_crate.colorFadeBloom.colorFrom, PingPong(t, 1))		
	}
	// Set watering can to player position
	watering_can.centerPosition = character_player.centerPosition
}

Draw :: proc () {
	{	// Ground
		x,y  := ToScreenOffsetPosition(ground)
		raylib.DrawTexture(ground.texture, x, y, raylib.WHITE)
	}
	{	// Plants
		x,y  := ToScreenOffsetPosition(plot1.plotImageData)
		raylib.DrawTexture(plot1.plotImageData.texture, x, y, raylib.WHITE)
	}
	{	// Player
		x,y := ToScreenOffsetPosition(character_player)
		position:= raylib.Vector2{cast(f32)x, cast(f32)y}
		texture_width := cast(f32)character_player.texture.width * (character_player.lastDirectionRight?-1:1)
		texture_height := cast(f32)character_player.texture.height
		raylib.DrawTextureRec(character_player.texture, raylib.Rectangle{ 0,0, texture_width, texture_height }, position, raylib.WHITE)
	}
	{	// Grandma
		x,y := ToScreenOffsetPosition(grandma)
		raylib.DrawTexture(grandma.texture, x, y, raylib.WHITE)
	}
	{	// Crate
		if(red_crate.selected){
			x,y  := ToScreenOffsetPosition(red_crate.bloomImageData)
			raylib.DrawTexture(red_crate.bloomImageData.texture, x, y, red_crate.colorFadeBloom.colorCurrent)
		}else if(red_crate.hovering){
			x,y  := ToScreenOffsetPosition(red_crate.bloomImageData)
			raylib.DrawTexture(red_crate.bloomImageData.texture, x, y, ColorHalfTransparent)
		}
		x,y  := ToScreenOffsetPosition(red_crate.outerImageData)
		raylib.DrawTexture(red_crate.outerImageData.texture, x, y, raylib.WHITE)
		x,y  = ToScreenOffsetPosition(red_crate.innerImageData)
		raylib.DrawTexture(red_crate.innerImageData.texture, x, y, raylib.RED)
	}
	{	// Chat bubble
		if(chat_br.dialogueIndex >= 0){
			if(dialogue1[chat_br.dialogueIndex].timerText > 0) {
  				local_scope_color(raylib.BLACK)
				GUI_DrawSpeechBubble(chat_br, dialogue1[chat_br.dialogueIndex].text)
			}
		}
	}
	{	// Screen Fade
		if(screenFade.timerColorFade > 0){
			raylib.DrawRectangle(0, 0, screen_width, screen_height, screenFade.colorCurrent)
		}
	}
	{	// Debug
		if(raylib.IsKeyDown(.SPACE)){
  			local_scope_color(raylib.BLACK)
			GUI_DrawSpeechBubble(chat_br, "test")

			x,y  := ToScreenOffsetPosition(watering_can)
			position:= raylib.Vector2{cast(f32)x, cast(f32)y}
			texture_width := cast(f32)watering_can.texture.width * (character_player.lastDirectionRight?-1:1)
			texture_height := cast(f32)watering_can.texture.height
			raylib.DrawTextureRec(watering_can.texture, raylib.Rectangle{ 0,0, texture_width, texture_height }, position, raylib.WHITE)
		}
	}
}

GetUserActions :: proc(using input: InputScheme) ->Actions {
	return Actions {
				left = raylib.IsKeyDown(leftButton)|| raylib.IsKeyDown(leftButton2),
				up = raylib.IsKeyDown(upButton)|| raylib.IsKeyDown(upButton2),
				down = raylib.IsKeyDown(downButton)|| raylib.IsKeyDown(downButton2),
				right = raylib.IsKeyDown(rightButton)|| raylib.IsKeyDown(rightButton2),
				interact = raylib.IsKeyDown(interactButton)|| raylib.IsKeyDown(interactButton2),
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
	return ColorFade{initialTime, initialTime, colorFrom, colorTo, colorFrom}
}

Repeat :: proc(t:f32, length:f32) ->f32 {
    return clamp(t - math.floor(t / length) * length, 0, length)
}

PingPong :: proc(t:f32, length:f32) ->f32 {
    t := Repeat(t, length * 2)
    return length - abs(t - length)
}

Lerp :: proc(from:u8, to:u8, t:f32) ->u8 {
     return cast(u8)(cast(f32)from * (1 - t)) + cast(u8)(cast(f32)to * t)
}

ColorLerp :: proc(from:raylib.Color, to:raylib.Color, t:f32) -> raylib.Color {
    r := Lerp(from.r, to.r, t)
    g := Lerp(from.g, to.g, t)
    b := Lerp(from.b, to.b, t)
    a := Lerp(from.a, to.a, t)
    return raylib.Color{r,g,b,a}
}

GUI_DrawSpeechBubble :: proc(imageData: ImageData, text: string) {
	fontSize := gui.fontSize
	topLeftX, topLeftY  := ToScreenOffsetPosition(imageData)
	centerX := topLeftX + cast(i32)(imageData.size.x/2)
	centerY := topLeftY + cast(i32)(imageData.size.y/2)
	numberOfNewlines :=  NumberOfCharacters(text, '\n')
	yBias := cast(i32)(numberOfNewlines>=1?numberOfNewlines*30: 20)
	newText := strings.clone_to_cstring(text)
	defer delete(newText)

	raylib.DrawTexture(imageData.texture, topLeftX, topLeftY, raylib.WHITE)
	GUI_DrawText(newText, TextAlignment.Center, centerX, centerY - yBias, fontSize)
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