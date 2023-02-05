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

Equipment :: struct {
	watercanImageData: 	ImageData,
	seedBagImageData: 	ImageData,
}

Plot :: struct {
	plotImageData: 		ImageData,
	seededImageData: 	ImageData,
	plantImageData: 	ImageData,
	bloomImageData: 	ImageData,
	colorFadeBloom:		ColorFade,
	name: string,

	hovering:			bool,

	state: 				int,
	has_had_action: 	bool,
}

Crate :: struct {
	outerImageData: ImageData,
	innerImageData: ImageData,
	bloomImageData: ImageData,
	colorFadeBloom:	ColorFade,

	hovering:		bool,
	selected:		bool,
}

Ground :: struct {
  using imageData: 	ImageData,
}

ChatBubble :: struct{
  using imageData: 	ImageData,
}

ColorFade :: struct {
	timerColorFade: 	f32,
	initialTime: 		f32,
	colorFrom: 			raylib.Color,
	colorTo: 			raylib.Color,
  	colorCurrent:		raylib.Color,
}

GameState :: struct {
	has_game_started: 			bool,
	has_picked_up_seeds:		bool,
	number_of_seeds_picked_up:	int,
	number_of_seeds_planted:	int,
}

gui: GUI
ground: 			Ground
character_player: 	CharacterPlayer
grandma: 			GrandMa
equipment: 		Equipment
crate_red: 			Crate
plot_1: 				Plot
plot_2: 				Plot
plot_3: 				Plot
plot_4: 				Plot
plot_5: 				Plot
plot_6: 				Plot
plots: [6]^Plot
chat_br: 			ChatBubble
screenFade: 		ColorFade
screen_height: 		i32
screen_width: 		i32
timerInputCooldown:			f32
game_state:	GameState

main :: proc () {
	RunTests()

	raylib.InitWindow(800, 600, "Altered Roots")
	defer raylib.CloseWindow()
	raylib.SetTargetFPS(60)

	plots[0] = &plot_1
	plots[1] = &plot_2
	plots[2] = &plot_3
	plots[3] = &plot_4
	plots[4] = &plot_5
	plots[5] = &plot_6

	plots[0].name = "0"
	plots[1].name = "1"
	plots[2].name = "2"
	plots[3].name = "3"
	plots[4].name = "4"
	plots[5].name = "5"

	screen_height = raylib.GetScreenHeight()
	screen_width = raylib.GetScreenWidth()

	// Load images
	ground_image := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/ground.png")
	defer raylib.UnloadImage(ground_image)		
	character_image := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/character.png")
	defer raylib.UnloadImage(character_image)	
	equipment_watering_can_image := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/equipment_watering_can.png")
	defer raylib.UnloadImage(equipment_watering_can_image)	
	equipment_seed_bag_image := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/equipment_seed_bag.png")
	defer raylib.UnloadImage(equipment_seed_bag_image)	
	grandma_image := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/grandma.png")
	defer raylib.UnloadImage(grandma_image)
	plot_plot_image := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/plot_plot.png")
	defer raylib.UnloadImage(plot_plot_image)
	plot_seeds_image := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/plot_seeds.png")
	defer raylib.UnloadImage(plot_seeds_image)
	plot_plant_image := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/plot_plant.png")
	defer raylib.UnloadImage(plot_plant_image)
	crate_image := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/crate.png")
	defer raylib.UnloadImage(crate_image)
	crate_seed_image := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/crate_seed.png")
	defer raylib.UnloadImage(crate_seed_image)
	selection_bloom_image := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/selection_bloom.png")
	defer raylib.UnloadImage(selection_bloom_image)
	chat_bottom_right_image := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/chat_bottom_right.png")
	defer raylib.UnloadImage(chat_bottom_right_image)

	ResizeAndBindImageData(&ground, &ground_image, screen_width, screen_height)
	ResizeAndBindImageData(&character_player, &character_image, StandardDimensionsX, StandardDimensionsY)
	ResizeAndBindImageData(&grandma, &grandma_image, StandardDimensionsX, StandardDimensionsY)
	ResizeAndBindImageData(&equipment.watercanImageData, &equipment_watering_can_image, cast(i32)character_player.size.x/2, cast(i32)character_player.size.y/2 - 10)
	ResizeAndBindImageData(&equipment.seedBagImageData, &equipment_seed_bag_image, cast(i32)character_player.size.x/2, cast(i32)character_player.size.y/2 - 10)
	for a_plot in plots {
		ResizeAndBindImageData(&a_plot.plotImageData, &plot_plot_image, StandardDimensionsX, StandardDimensionsY)
		ResizeAndBindImageData(&a_plot.seededImageData, &plot_seeds_image, StandardDimensionsX, StandardDimensionsY)
		ResizeAndBindImageData(&a_plot.plantImageData, &plot_plant_image, StandardDimensionsX, StandardDimensionsY)
		ResizeAndBindImageData(&a_plot.bloomImageData, &selection_bloom_image, StandardDimensionsX, StandardDimensionsY)
	}
	ResizeAndBindImageData(&crate_red.outerImageData, &crate_image, cast(i32)character_player.size.x/2, cast(i32)character_player.size.y/2)
	ResizeAndBindImageData(&crate_red.innerImageData, &crate_seed_image, cast(i32)character_player.size.x/4, cast(i32)character_player.size.y/4)
	ResizeAndBindImageData(&crate_red.bloomImageData, &selection_bloom_image, cast(i32)character_player.size.x, cast(i32)character_player.size.y)
	ResizeAndBindImageData(&chat_br, &chat_bottom_right_image, 200, 150)
	{	
		// Setup gui
		gui.color = raylib.WHITE
		gui.fontSize = 20
		// Starting positions
		ground.centerPosition = raylib.Vector2{(cast(f32)(screen_width/2)), (cast(f32)(screen_height/2))}
		character_player.centerPosition = raylib.Vector2{(cast(f32)(screen_width/2) - character_player.size.x/2), (cast(f32)(screen_height/2) - character_player.size.y/2)}
		grandma.centerPosition = raylib.Vector2{cast(f32)(screen_width) - cast(f32)(grandma.size.x/2), cast(f32)(grandma.size.y/2) + 100}
		bias:= 0
		for a_plot in plots {
			a_plot.plotImageData.centerPosition = raylib.Vector2{cast(f32)(a_plot.plotImageData.size.x/2), cast(f32)(a_plot.plotImageData.size.y/2 + cast(f32)bias)}
			a_plot.seededImageData.centerPosition = raylib.Vector2{cast(f32)(a_plot.plotImageData.size.x/2), cast(f32)(a_plot.plotImageData.size.y/2 + cast(f32)bias)}
			a_plot.plantImageData.centerPosition = raylib.Vector2{cast(f32)(a_plot.plotImageData.size.x/2), cast(f32)(a_plot.plotImageData.size.y/2 + cast(f32)bias)}
			a_plot.bloomImageData.centerPosition = raylib.Vector2{cast(f32)(a_plot.plotImageData.size.x/2), cast(f32)(a_plot.plotImageData.size.y/2 + cast(f32)bias)}
			bias = bias + 100
		}
		crate_red.outerImageData.centerPosition = raylib.Vector2{750,575}
		crate_red.innerImageData.centerPosition = raylib.Vector2{750,575}
		crate_red.bloomImageData.centerPosition = raylib.Vector2{750,575}
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
		crate_red.colorFadeBloom = MakeColorFade(DurationSelectedCrateFade, raylib.WHITE, ColorTransparent)
		for a_plot in plots {
			a_plot.colorFadeBloom = MakeColorFade(DurationSelectedCrateFade, raylib.WHITE, ColorTransparent)
		}
		// Setup dialogue
		SetupAllDialogue()
	}

	for (!raylib.WindowShouldClose()) {
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
    actions := GetUserActions(character_player)

	if !HasHitTime(&screenFade.timerColorFade, deltaTime) {
		t := screenFade.timerColorFade/ screenFade.initialTime
		screenFade.colorCurrent = ColorLerp(screenFade.colorTo, screenFade.colorFrom, t)
	}else{
		if(!game_state.has_game_started){
			game_state.has_game_started = true
			// Show first dialogue
			SetActiveDialogue(&intro_dialogue)
		}
	}

	activeDialogue, hasDialogue := ActiveDialogue()
	if(hasDialogue && activeDialogue.dialogueIndex >= 0){
		if HasHitTime(GetDialogueTimer(activeDialogue), deltaTime) {
			fmt.println("dialogueIndex:", activeDialogue.dialogueIndex)
			// TODO: we should probably fix this at some point
			ProgressDialogueIfReady(activeDialogue)
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

		for a_plot in plots {
			a_plot.hovering = false
		}
		if character_player.centerPosition.x-(character_player.size.x/2) < 100 {		
			for a_plot in plots {
				// Use the watering can since its easier for collision detection
				if(HasAABBCollision(a_plot.plotImageData, equipment.watercanImageData)){
					a_plot.hovering = true
					fmt.println("on plot ", a_plot.name)
				}
			}
		}
		crate_red.hovering = false
		if character_player.centerPosition.y+(character_player.size.y/2) > cast(f32)(screen_height) - 100 {
			if(character_player.centerPosition.x >=700) {
				crate_red.hovering = true
			}			
		}
	}

	if(actions.interact) {
		actions.interact = false
		if(crate_red.hovering && !game_state.has_picked_up_seeds) {
			// deselect others
			crate_red.selected = true
			game_state.has_picked_up_seeds = true
			fmt.println("we picked up seeds")
			if(game_state.number_of_seeds_picked_up == 0) {
				SetActiveDialogue(&first_seeds_dialogue)
			} 
			game_state.number_of_seeds_picked_up = game_state.number_of_seeds_picked_up + 1
		}
		for a_plot in plots {
			if(a_plot.hovering){
				// deselect others
				if(crate_red.selected){
					if(!a_plot.has_had_action){
						fmt.println("we water or put down seeds on ", a_plot.name)
						a_plot.has_had_action = true
						a_plot.state = a_plot.state + 1
						game_state.number_of_seeds_planted = game_state.number_of_seeds_planted + 1
						game_state.has_picked_up_seeds = false
						if(game_state.number_of_seeds_planted == 3) {
							SetActiveDialogue(&halfway_first_batch_seeds_dialogue)
						}else if(game_state.number_of_seeds_planted >= 6) {
							fmt.println("Planted all the seeds of the day ", game_state.number_of_seeds_planted)
							SetActiveDialogue(&all_done_seeds_dialogue)
						}
					}
				}else{
					fmt.println("You aint got no seeds for ", a_plot.name)
					SetActiveDialogue(&no_seeds_dialogue)
				}
				return
			}
		}
	}
	if(crate_red.selected){
		crate_red.colorFadeBloom.timerColorFade = crate_red.colorFadeBloom.timerColorFade - deltaTime
		t := crate_red.colorFadeBloom.timerColorFade/ crate_red.colorFadeBloom.initialTime
		crate_red.colorFadeBloom.colorCurrent = ColorLerp(crate_red.colorFadeBloom.colorTo, crate_red.colorFadeBloom.colorFrom, PingPong(t, 1))		
	}
	// Set equipment to player position
	equipment.watercanImageData.centerPosition = character_player.centerPosition
	equipment.seedBagImageData.centerPosition = character_player.centerPosition
}

Draw :: proc () {
	{	// Ground
		x,y  := ToScreenOffsetPosition(ground)
		raylib.DrawTexture(ground.texture, x, y, raylib.WHITE)
	}
	{	// Plants
		for a_plot in plots {
			if(a_plot.state == 0) {
				x,y  := ToScreenOffsetPosition(a_plot.plotImageData)
				raylib.DrawTexture(a_plot.plotImageData.texture, x, y, raylib.WHITE)
			} else {
				x,y  := ToScreenOffsetPosition(a_plot.seededImageData)
				raylib.DrawTexture(a_plot.seededImageData.texture, x, y, raylib.WHITE)
			}
		}
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
		if(crate_red.selected){
			x,y  := ToScreenOffsetPosition(crate_red.bloomImageData)
			raylib.DrawTexture(crate_red.bloomImageData.texture, x, y, crate_red.colorFadeBloom.colorCurrent)

			// Highlight all the plots since you can plant a seed
			for a_plot in plots {
				if(a_plot.state == 0) {
					x,y  = ToScreenOffsetPosition(a_plot.bloomImageData)
					raylib.DrawTexture(a_plot.bloomImageData.texture, x, y, ColorHalfTransparent)
				}
			}
		}else if(crate_red.hovering) {
			x,y  := ToScreenOffsetPosition(crate_red.bloomImageData)
			raylib.DrawTexture(crate_red.bloomImageData.texture, x, y, ColorHalfTransparent)
		}
		x,y  := ToScreenOffsetPosition(crate_red.outerImageData)
		raylib.DrawTexture(crate_red.outerImageData.texture, x, y, raylib.WHITE)
		x,y  = ToScreenOffsetPosition(crate_red.innerImageData)
		raylib.DrawTexture(crate_red.innerImageData.texture, x, y, raylib.RED)
	}
	{	// Chat bubble
		activeDialogue, hasDialogue := ActiveDialogue()
		if(hasDialogue && activeDialogue.dialogueIndex >= 0){
			if(GetDialogueTimer(activeDialogue)^ > 0) {
  				local_scope_color(raylib.BLACK)
				GUI_DrawSpeechBubble(chat_br, GetDialogueText(activeDialogue))
			}
		}
	}
	{	// Screen Fade
		if(screenFade.timerColorFade > 0) {
			raylib.DrawRectangle(0, 0, screen_width, screen_height, screenFade.colorCurrent)
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

// We just leak these. The get cleaned up when the process exits anyways. and they don't leak over time
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

restore_color :: proc(color: raylib.Color) {
  	gui.color = color
}

@(deferred_out=restore_color)
local_scope_color :: proc(color: raylib.Color) -> raylib.Color {
	current_color := gui.color
	gui.color = color
	return current_color
}

HasAABBCollision :: proc(a: Rectangle, b: Rectangle) -> bool{
	bX := b.centerPosition.x - (b.size.x / 2)
	bY := b.centerPosition.y - (b.size.y / 2)
	aX := a.centerPosition.x - (a.size.x / 2)
	aY := a.centerPosition.y - (a.size.y / 2)
	hasCollisionX := aX+a.size.x >= bX && bX+b.size.x >= aX
	hasCollisionY := aY+a.size.y >= bY && bY+b.size.y >= aY
	return hasCollisionX && hasCollisionY
}