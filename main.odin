package aroots

import "core:fmt"
import "core:intrinsics"
import "core:math"
import "core:strings"
import "core:math/rand"
import raylib "vendor:raylib"


InputCooldownSeconds 	:: 0.2
StandardDimensionsX 	:: 100
StandardDimensionsY 	:: 100

StartingCratePositionX :: 550
StartingCratePositionY :: 575

DurationScreenFade			:: 3
DurationSelectedCrateFade 	:: 1

ColorHalfTransparent 	:: raylib.Color{255,255,255,125}
ColorQuarterTransparent :: raylib.Color{255,255,255,60}
ColorTransparent 		:: raylib.Color{1,1,1,0}

TextAlignment :: enum {
	Left, 
	Center,
	Right,
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
	interactButton3:	raylib.KeyboardKey,
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

Bed :: struct {
  using imageData: 	ImageData,

	is_hovering:			bool,
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

	is_hovering:			bool,

	state: 				int,
	seed_type:			int,
	has_had_action: 	bool,
}

Crate :: struct {
	outerImageData: ImageData,
	innerImageData: ImageData,
	bloomImageData: ImageData,
	colorFadeBloom:	ColorFade,
	name: string,

	is_hovering:		bool,
	seed_type:			int,
}

Ground :: struct {
  using imageData: 	ImageData,
}

ChatBubble :: struct{
  using imageData: 	ImageData,
}

Menu :: struct{
  foreImageData: 	ImageData,
  backImageData: 	ImageData,
  titleImageData: 	ImageData,
}

ColorFade :: struct {
	timerColorFade: 	f32,
	initialTime: 		f32,
	colorFrom: 			raylib.Color,
	colorTo: 			raylib.Color,
  	colorCurrent:		raylib.Color,
}

GameState :: struct {
	is_menu:				bool,
	is_sleeping:				bool,
	is_showing_end_movie:			bool,
	is_restarting: 			bool,
	has_talked_to_grandma:	bool,
	has_game_started: 			bool,
	has_won:					bool,
	has_not_learned_from_their_past: bool,
	has_picked_up_seeds_once:	bool,
	number_of_seeds_planted:	int,
	crate_in_use: 				^Crate,
}

ground: 			Ground
character_player: 	CharacterPlayer
grandma: 			GrandMa
bed: 		Bed
equipment: 	Equipment
crate_red: 		Crate
crate_black: 	Crate
crate_green: 	Crate
crates: [3]^Crate
plot_1: 				Plot
plot_2: 				Plot
plot_3: 				Plot
plot_4: 				Plot
plot_5: 				Plot
plot_6: 				Plot
plots: [6]^Plot
chat_br: 			ChatBubble
menu:		Menu
fadeBlackToClear: 		ColorFade
fadeClearToBlack: 		ColorFade
screen_height: 		i32
screen_width: 		i32
timerInputCooldown:			f32
game_state:	GameState
music_menu: 		raylib.Music
music_background: 	raylib.Music
sound_shuffle: 	raylib.Sound

main :: proc () {
	RunTests()

	raylib.InitWindow(800, 600, "Altered Roots")
	defer raylib.CloseWindow()
	raylib.InitAudioDevice()      // Initialize audio device
	raylib.SetTargetFPS(60)

	crates[0] = &crate_red
	crates[1] = &crate_black
	crates[2] = &crate_green

	crates[0].name = "c0"
	crates[1].name = "c1"
	crates[2].name = "c2"
	crates[0].seed_type = 1
	crates[1].seed_type = 2
	crates[2].seed_type = 3

	plots[0] = &plot_1
	plots[1] = &plot_2
	plots[2] = &plot_3
	plots[3] = &plot_4
	plots[4] = &plot_5
	plots[5] = &plot_6

	plots[0].name = "p0"
	plots[1].name = "p1"
	plots[2].name = "p2"
	plots[3].name = "p3"
	plots[4].name = "p4"
	plots[5].name = "p5"

	screen_height = raylib.GetScreenHeight()
	screen_width = raylib.GetScreenWidth()

	game_state.is_menu = true

	// Load audio
	music_menu = raylib.LoadMusicStream("/Users/kvasall/Documents/Repos/Altered Roots/resources/music_menu.ogg")
	defer raylib.UnloadMusicStream(music_menu)
	music_background = raylib.LoadMusicStream("/Users/kvasall/Documents/Repos/Altered Roots/resources/music_background.ogg")
	defer raylib.UnloadMusicStream(music_background)
	sound_shuffle = raylib.LoadSound("/Users/kvasall/Documents/Repos/Altered Roots/resources/Foliage03.wav")
	defer raylib.UnloadSound(sound_shuffle)

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
	bed_image := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/bed.png")
	defer raylib.UnloadImage(bed_image)
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
	menu_fore_image := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/menu.png")
	defer raylib.UnloadImage(menu_fore_image)
	menu_back_image := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/menu_background.png")
	defer raylib.UnloadImage(menu_back_image)
	menu_title_image := raylib.LoadImage("/Users/kvasall/Documents/Repos/Altered Roots/resources/title.png")
	defer raylib.UnloadImage(menu_title_image)

	ResizeAndBindImageData(&ground, &ground_image, screen_width, screen_height)
	ResizeAndBindImageData(&character_player, &character_image, StandardDimensionsX, StandardDimensionsY)
	ResizeAndBindImageData(&grandma, &grandma_image, StandardDimensionsX, StandardDimensionsY)
	ResizeAndBindImageData(&bed, &bed_image, StandardDimensionsX, StandardDimensionsY)
	ResizeAndBindImageData(&equipment.watercanImageData, &equipment_watering_can_image, cast(i32)character_player.size.x/2, cast(i32)character_player.size.y/2 - 10)
	ResizeAndBindImageData(&equipment.seedBagImageData, &equipment_seed_bag_image, cast(i32)character_player.size.x/2, cast(i32)character_player.size.y/2 - 10)
	for a_plot in plots {
		ResizeAndBindImageData(&a_plot.plotImageData, &plot_plot_image, StandardDimensionsX, StandardDimensionsY)
		ResizeAndBindImageData(&a_plot.seededImageData, &plot_seeds_image, StandardDimensionsX, StandardDimensionsY)
		ResizeAndBindImageData(&a_plot.plantImageData, &plot_plant_image, StandardDimensionsX, StandardDimensionsY)
		ResizeAndBindImageData(&a_plot.bloomImageData, &selection_bloom_image, StandardDimensionsX, StandardDimensionsY)
	}
	for a_crate in crates {
		ResizeAndBindImageData(&a_crate.outerImageData, &crate_image, cast(i32)character_player.size.x/2, cast(i32)character_player.size.y/2)
		ResizeAndBindImageData(&a_crate.innerImageData, &crate_seed_image, cast(i32)character_player.size.x/4, cast(i32)character_player.size.y/4)
		ResizeAndBindImageData(&a_crate.bloomImageData, &selection_bloom_image, cast(i32)character_player.size.x, cast(i32)character_player.size.y + 20)
	}
	ResizeAndBindImageData(&chat_br, &chat_bottom_right_image, 200, 150)
	ResizeAndBindImageData(&menu.foreImageData, &menu_fore_image, 1000, 1000)
	ResizeAndBindImageData(&menu.backImageData, &menu_back_image, 1000, 1000)
	ResizeAndBindImageData(&menu.titleImageData, &menu_title_image, 550, 350)

	{	
		// Setup gui
		// Starting positions
		ground.centerPosition = raylib.Vector2{(cast(f32)(screen_width/2)), (cast(f32)(screen_height/2))}
		character_player.centerPosition = raylib.Vector2{cast(f32)(cast(f32)screen_width - cast(f32)(StandardDimensionsX * 2) + cast(f32)(character_player.size.x/2)), (cast(f32)(screen_height/2) + character_player.size.y/2)}
		grandma.centerPosition = raylib.Vector2{cast(f32)(screen_width) - cast(f32)(grandma.size.x/2), cast(f32)(grandma.size.y/2) + 100}
		bed.centerPosition = raylib.Vector2{grandma.centerPosition.x, grandma.centerPosition.y + 200}
		bias := 0
		for a_plot in plots {
			a_plot.plotImageData.centerPosition = raylib.Vector2{cast(f32)(a_plot.plotImageData.size.x/2), cast(f32)(a_plot.plotImageData.size.y/2 + cast(f32)bias)}
			a_plot.seededImageData.centerPosition = raylib.Vector2{cast(f32)(a_plot.plotImageData.size.x/2), cast(f32)(a_plot.plotImageData.size.y/2 + cast(f32)bias)}
			a_plot.plantImageData.centerPosition = raylib.Vector2{cast(f32)(a_plot.plotImageData.size.x/2), cast(f32)(a_plot.plotImageData.size.y/2 + cast(f32)bias)}
			a_plot.bloomImageData.centerPosition = raylib.Vector2{cast(f32)(a_plot.plotImageData.size.x/2), cast(f32)(a_plot.plotImageData.size.y/2 + cast(f32)bias)}
			bias = bias + 100
		}		
		bias = 0
		for a_crate in crates {
			a_crate.outerImageData.centerPosition = raylib.Vector2{StartingCratePositionX + cast(f32)bias, StartingCratePositionY}
			a_crate.innerImageData.centerPosition = raylib.Vector2{StartingCratePositionX + cast(f32)bias, StartingCratePositionY}
			a_crate.bloomImageData.centerPosition = raylib.Vector2{StartingCratePositionX + cast(f32)bias, StartingCratePositionY - 10}
			bias = bias + 100
		}
		
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
			.E,
		}
		// Setup various fades
		fadeBlackToClear = MakeColorFade(DurationScreenFade, raylib.BLACK, ColorTransparent)
		for a_crate in crates {
			a_crate.colorFadeBloom = MakeColorFade(DurationSelectedCrateFade, raylib.WHITE, ColorQuarterTransparent)
		}
		for a_plot in plots {
			a_plot.colorFadeBloom = MakeColorFade(DurationSelectedCrateFade, raylib.WHITE, ColorTransparent)
		}
		// Setup dialogue
		SetupAllDialogue()
		// Music
		raylib.PlayMusicStream(music_menu)
	}

	for (!raylib.WindowShouldClose()) {
		raylib.BeginDrawing()
		defer raylib.EndDrawing()
		raylib.ClearBackground(raylib.BLACK)
		raylib.UpdateMusicStream(music_menu)   // Update music buffer with new stream data
		raylib.UpdateMusicStream(music_background)   // Update music buffer with new stream data

		// Intentionally reassign width and height incase we allow resizes
		screen_height = raylib.GetScreenHeight()
		screen_width = raylib.GetScreenWidth()
		dt := raylib.GetFrameTime()
		Update(dt)
		Draw()
	}
}

Update :: proc (deltaTime:f32) {
	if(game_state.is_menu){
		fmt.println("in menu")
		if(raylib.GetKeyPressed() > .APOSTROPHE || raylib.IsKeyDown(.SPACE) || raylib.IsMouseButtonDown(.LEFT)) {
			fmt.println("exit menu ", raylib.GetKeyPressed())
			game_state.is_menu = false
			raylib.StopMusicStream(music_menu)
			raylib.PlayMusicStream(music_background)
		}
		return
	}
    actions := GetUserActions(character_player)

	// Fadings
	if !HasHitTime(&fadeBlackToClear.timerColorFade, deltaTime) {
		t := fadeBlackToClear.timerColorFade/ fadeBlackToClear.initialTime
		fadeBlackToClear.colorCurrent = ColorLerp(fadeBlackToClear.colorTo, fadeBlackToClear.colorFrom, t)
		return
	}
	if !HasHitTime(&fadeClearToBlack.timerColorFade, deltaTime) {
		t := fadeClearToBlack.timerColorFade/ fadeClearToBlack.initialTime
		fadeClearToBlack.colorCurrent = ColorLerp(fadeClearToBlack.colorTo, fadeClearToBlack.colorFrom, t)
		return
	}

	if(game_state.is_showing_end_movie){
		return
	}

	if(!game_state.is_restarting && fadeBlackToClear.timerColorFade < 0) {
		if(!game_state.has_game_started){
			game_state.has_game_started = true
			// Show first dialogue
			SetActiveDialogue(&intro_dialogue)
		}
	}
	if(fadeClearToBlack.timerColorFade < 0) {
		if(game_state.is_sleeping){
			fmt.println("wake up")
			game_state.is_sleeping = false
			r := cast(int)(rand.uint64()%3)
			switch r {
				case 0: SetActiveDialogue(&wake_up_dialogue1)
				case 1: SetActiveDialogue(&wake_up_dialogue2)
				case 2: SetActiveDialogue(&wake_up_dialogue3)
			}
			fadeBlackToClear = MakeColorFade(DurationScreenFade, raylib.BLACK, ColorTransparent)
			// update plant states
			for a_plot in plots {
				a_plot.state = a_plot.state + 1
				a_plot.has_had_action = false
			}
		}
		if(game_state.is_restarting){
			game_state.is_restarting = false
			fadeBlackToClear = MakeColorFade(DurationScreenFade, raylib.BLACK, ColorTransparent)
			fmt.println("should be restarted")
		}
	}

	activeDialogue, hasDialogue := ActiveDialogue()
	if(hasDialogue && activeDialogue.dialogueIndex >= 0){
		if HasHitTime(GetDialogueTimer(activeDialogue), deltaTime) {
			fmt.println("dialogueIndex:", activeDialogue.dialogueIndex)
			// TODO: we should probably fix this at some point
			ProgressDialogueIfReady(activeDialogue)
			if(activeDialogue.dialogueIndex > 20){
				if(game_state.has_won) {
					game_state.has_won = false
					game_state.is_showing_end_movie = true
					fadeClearToBlack = MakeColorFade(DurationScreenFade, ColorTransparent, raylib.BLACK)
					return
				}
				if(game_state.has_not_learned_from_their_past) {
					game_state = {}
					for a_plot in plots {
						a_plot.state = 0
						a_plot.is_hovering = false
						a_plot.has_had_action = false
					}
					for a_crate in crates {
						a_crate.is_hovering = false
					}

					SetupAllDialogue()
					SetActiveDialogue(nil)
					game_state.is_restarting = true
					fadeClearToBlack = MakeColorFade(DurationScreenFade, ColorTransparent, raylib.BLACK)
					return
				}
			}
		}
	}

	if HasHitTime(&timerInputCooldown, deltaTime) {
		previousPosition := character_player.centerPosition
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
		boundsRight := 	character_player.centerPosition.x+(character_player.size.x/2) > cast(f32)(screen_width)
		boundsLeft := 	character_player.centerPosition.x-(character_player.size.x/2) < 0
		boundsBottom :=	character_player.centerPosition.y+(character_player.size.y/2) > cast(f32)(screen_height)
		boundsTop := 	character_player.centerPosition.y-(character_player.size.y/2) < 0
		if boundsRight || boundsLeft || boundsBottom || boundsTop {
			character_player.centerPosition = previousPosition
		}

		// Detect by objects of interest
		// NOTE: We use the watering can since its easier for collision detection
		for a_plot in plots {
			a_plot.is_hovering = false
		}	
		for a_plot in plots {			
			if(HasAABBCollision(a_plot.plotImageData, equipment.watercanImageData)){
				a_plot.is_hovering = true
				fmt.println("on plot ", a_plot.name)
				break
			}
		}
		for a_crate in crates {
			a_crate.is_hovering = false
		}	
		for a_crate in crates {			
			if(HasAABBCollision(a_crate.outerImageData, equipment.watercanImageData)){
				a_crate.is_hovering = true
				fmt.println("on crate ", a_crate.name)
				break
			}
		}
		bed.is_hovering = false
		if HasAABBCollision(bed, equipment.watercanImageData) {
			bed.is_hovering = true
		}
		// Set equipment to player position
		equipment.watercanImageData.centerPosition = character_player.centerPosition
		equipment.seedBagImageData.centerPosition = character_player.centerPosition
		// Can't walk on grandma (need the above updated equipment position for the AABB)
		if(HasAABBCollision(grandma, equipment.watercanImageData)){
			character_player.centerPosition = previousPosition
			// Set equipment to player position after moving back
			equipment.watercanImageData.centerPosition = character_player.centerPosition
			equipment.seedBagImageData.centerPosition = character_player.centerPosition

			if(!game_state.has_talked_to_grandma){
				game_state.has_talked_to_grandma = true
				r := cast(int)(rand.uint64()%4)
				switch r {
					case 0: SetActiveDialogue(&why_close_dialogue1)
					case 1: SetActiveDialogue(&why_close_dialogue2)
					case 2: SetActiveDialogue(&why_close_dialogue3)
					case 3: SetActiveDialogue(&why_close_dialogue4)
				}
			}
		}
	}

	if(actions.interact) {
		actions.interact = false
		for a_crate in crates {	
			if(a_crate.is_hovering && game_state.crate_in_use != a_crate) {
				game_state.crate_in_use = a_crate
				fmt.println("we picked up seeds from ", a_crate.name)
				if(!game_state.has_picked_up_seeds_once) {
					game_state.has_picked_up_seeds_once = true
					SetActiveDialogue(&first_seeds_dialogue)
				} 
			}
		}
		for a_plot in plots {
			if(a_plot.is_hovering){
				fmt.println("plant state ", a_plot.state)
				if(a_plot.state == 0){
					if(game_state.crate_in_use != nil){
						if(!a_plot.has_had_action){
							fmt.println("we water or put down seeds on ", a_plot.name)
							raylib.PlaySound(sound_shuffle)
							a_plot.has_had_action = true
							a_plot.state = a_plot.state + 1
							a_plot.seed_type = game_state.crate_in_use.seed_type
							game_state.number_of_seeds_planted = game_state.number_of_seeds_planted + 1
							if(game_state.number_of_seeds_planted == 3) {
								SetActiveDialogue(&halfway_first_batch_seeds_dialogue)
							}else if(game_state.number_of_seeds_planted >= 6) {
								fmt.println("Planted all the seeds of the day ", game_state.number_of_seeds_planted)
								r := cast(int)(rand.uint64()%2)
								switch r {
									case 0: SetActiveDialogue(&all_done_seeds_dialogue1)
									case 1: SetActiveDialogue(&all_done_seeds_dialogue2)
								}
							}
						}
					}else{
						fmt.println("You aint got no seeds for ", a_plot.name)
						SetActiveDialogue(&no_seeds_dialogue)
					}
					return
				}else if(a_plot.state == 2){
					if(!a_plot.has_had_action){
						fmt.println("Collected plant of ", a_plot.seed_type, " on ", a_plot.name)
						raylib.PlaySound(sound_shuffle)
						a_plot.has_had_action = true
						a_plot.state = a_plot.state + 1
					}
				}
			}
		}
		if(bed.is_hovering){
			if(game_state.number_of_seeds_planted < 6){
				fmt.println("You trying to go to bed early")
				SetActiveDialogue(&early_bed_dialogue)
			}else{
				fmt.println("You trying to go to bed on time")
				fadeClearToBlack = MakeColorFade(DurationScreenFade, ColorTransparent, raylib.BLACK)
				game_state.is_sleeping = true
			}
		}
	}

	if (game_state.crate_in_use != nil) {
		game_state.crate_in_use.colorFadeBloom.timerColorFade = game_state.crate_in_use.colorFadeBloom.timerColorFade - deltaTime
		t := game_state.crate_in_use.colorFadeBloom.timerColorFade/ game_state.crate_in_use.colorFadeBloom.initialTime
		game_state.crate_in_use.colorFadeBloom.colorCurrent = ColorLerp(game_state.crate_in_use.colorFadeBloom.colorTo, game_state.crate_in_use.colorFadeBloom.colorFrom, PingPong(t, 1))		
	}
	// Set equipment to player position
	equipment.watercanImageData.centerPosition = character_player.centerPosition
	equipment.seedBagImageData.centerPosition = character_player.centerPosition

	// Win round
	hasWin := true
	for a_plot in plots {
		if(a_plot.state != 3){
			hasWin = false
			break
		}
	}
	if(hasWin /*|| raylib.IsKeyDown(.P)*/){
		fmt.println("You deserve an explination")
		fmt.println("plot_1.seed_type ", plot_1.seed_type,
				 "&& plot_2.seed_type ", plot_2.seed_type,
				 "&& plot_3.seed_type ", plot_3.seed_type,
				 "&& plot_4.seed_type ", plot_4.seed_type,
				 "&& plot_5.seed_type ", plot_5.seed_type,
				 "&& plot_6.seed_type ", plot_6.seed_type)
		hasWinningCombination := (plot_1.seed_type == 1 
							   && plot_2.seed_type == 3 
							   && plot_3.seed_type == 1 
							   && plot_4.seed_type == 2 
							   && plot_5.seed_type == 1 
							   && plot_6.seed_type == 1)
								
		if(hasWinningCombination /*|| raylib.IsKeyDown(.P)*/){
			fmt.println("You won won!")
			game_state.has_won = true
			SetActiveDialogue(&has_won_dialogue)
		}else /*if raylib.IsKeyDown(.P) */{
			fmt.println("You need to try again!")
			game_state.has_not_learned_from_their_past = true
			adder:= make(map[int]int)
			defer delete(adder)
			
			for a_plot in plots {
				adder[a_plot.seed_type] = adder[a_plot.seed_type] + 1
			}
			if(len(adder) != 3) {
				fmt.println("You need one of each color!")
				SetActiveDialogue(&one_of_each_dialogue)
			}else{
				if(adder[1] < 4){
					fmt.println("You need more red!")
					SetActiveDialogue(&more_red_dialogue)
				}else{
					if(plot_1.seed_type != 1 || plot_6.seed_type != 1){
						fmt.println("You need red at the ends!")
						SetActiveDialogue(&red_ends_dialouge)
					}else{
						if(plot_2.seed_type == 2){
							fmt.println("You need to probably swap!")
							SetActiveDialogue(&swap_green_black_dialouge)
						}else{
							if(plot_5.seed_type == 2){
								fmt.println("You need to stand tall swap!")
								SetActiveDialogue(&stand_tall_dialouge)
							}else{
								fmt.println("You need red between black and green!")
								SetActiveDialogue(&green_black_mix_dialouge)
							}
						}
					}
				}
			}
		}
	}
}

Draw :: proc () {
	if(game_state.is_menu){
		raylib.DrawTexture(menu.backImageData.texture, -100, -200, raylib.WHITE)
		raylib.DrawTexture(menu.foreImageData.texture, -100, -200, raylib.WHITE)
		raylib.DrawTexture(menu.titleImageData.texture, +150, -50, raylib.WHITE)
		return
	}

	{	// Ground
		x,y  := ToScreenOffsetPosition(ground)
		raylib.DrawTexture(ground.texture, x, y, raylib.WHITE)
	}
	{	// Plants
		for a_plot in plots {
			imageData: ImageData
			color	:= raylib.WHITE
			if(a_plot.state == 3){
				continue	// Was collected so don't render
			} else if(a_plot.state == 0) {
				imageData = a_plot.plotImageData
			} else if a_plot.state == 1 {
				imageData = a_plot.seededImageData
			} else if (a_plot.state == 2) {
				imageData = a_plot.plantImageData
				if(a_plot.seed_type == 1){
					color = raylib.RED
				}else if(a_plot.seed_type == 2) { 
					color = raylib.BLACK
				}else if(a_plot.seed_type == 3) {
					color = raylib.DARKGREEN
				}
			}
			x,y  := ToScreenOffsetPosition(imageData)
			raylib.DrawTexture(imageData.texture, x, y, color)
		}
	}
	{	// Bed
		x,y := ToScreenOffsetPosition(bed)
		raylib.DrawTexture(bed.texture, x, y, raylib.WHITE)
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
		for a_crate in crates {	
			if(a_crate == game_state.crate_in_use){
				x,y  := ToScreenOffsetPosition(a_crate.bloomImageData)
				raylib.DrawTexture(a_crate.bloomImageData.texture, x, y, a_crate.colorFadeBloom.colorCurrent)

				// Highlight all the plots since you can plant a seed
				for a_plot in plots {
					if(a_plot.state == 0) {
						x,y  = ToScreenOffsetPosition(a_plot.bloomImageData)
						raylib.DrawTexture(a_plot.bloomImageData.texture, x, y, ColorHalfTransparent)
					}
				}
			}else if(a_crate.is_hovering) {
				x,y  := ToScreenOffsetPosition(a_crate.bloomImageData)
				raylib.DrawTexture(a_crate.bloomImageData.texture, x, y, ColorHalfTransparent)
			}
			x,y  := ToScreenOffsetPosition(a_crate.outerImageData)
			raylib.DrawTexture(a_crate.outerImageData.texture, x, y, raylib.WHITE)
			x,y  = ToScreenOffsetPosition(a_crate.innerImageData)
			if(a_crate.seed_type == 1){
				raylib.DrawTexture(a_crate.innerImageData.texture, x, y, raylib.RED)
			}else if(a_crate.seed_type == 2){
				raylib.DrawTexture(a_crate.innerImageData.texture, x, y, raylib.BLACK)
			} else if(a_crate.seed_type == 3){
				raylib.DrawTexture(a_crate.innerImageData.texture, x, y, raylib.DARKGREEN)
			}
		}
	}
	{	// Chat bubble
		activeDialogue, hasDialogue := ActiveDialogue()
		if(hasDialogue && activeDialogue.dialogueIndex >= 0){
			if(GetDialogueTimer(activeDialogue)^ > 0) {
				GUI_DrawSpeechBubble(chat_br, GetDialogueText(activeDialogue))
			}
		}
	}
	{	// Screen Fade
		if(fadeBlackToClear.timerColorFade > 0) {
			raylib.DrawRectangle(0, 0, screen_width, screen_height, fadeBlackToClear.colorCurrent)
		}
		if(fadeClearToBlack.timerColorFade > 0) {
			raylib.DrawRectangle(0, 0, screen_width, screen_height, fadeClearToBlack.colorCurrent)
		}
		if(fadeClearToBlack.timerColorFade < 0) {
			if(game_state.is_showing_end_movie){
				raylib.DrawRectangle(0, 0, screen_width, screen_height, raylib.BLACK)
				GUI_DrawText("Granny loves you...", TextAlignment.Center, screen_width/2, screen_height/2, 20, raylib.WHITE)
			}
		}
	}
}

GetUserActions :: proc(using input: InputScheme) ->Actions {
	return Actions {
				left 		= raylib.IsKeyDown(leftButton)	|| raylib.IsKeyDown(leftButton2),
				up 			= raylib.IsKeyDown(upButton)	|| raylib.IsKeyDown(upButton2),
				down 		= raylib.IsKeyDown(downButton)	|| raylib.IsKeyDown(downButton2),
				right 		= raylib.IsKeyDown(rightButton)	|| raylib.IsKeyDown(rightButton2),
				interact 	= raylib.IsKeyDown(interactButton)|| raylib.IsKeyDown(interactButton2) || raylib.IsKeyDown(interactButton3),
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
	topLeftX, topLeftY  := ToScreenOffsetPosition(imageData)
	centerX := topLeftX + cast(i32)(imageData.size.x/2)
	centerY := topLeftY + cast(i32)(imageData.size.y/2)
	numberOfNewlines :=  NumberOfCharacters(text, '\n')
	yBias := cast(i32)(numberOfNewlines>=1?numberOfNewlines*30: 20)
	newText := strings.clone_to_cstring(text)
	defer delete(newText)

	raylib.DrawTexture(imageData.texture, topLeftX, topLeftY, raylib.WHITE)
	GUI_DrawText(newText, TextAlignment.Center, centerX, centerY - yBias, 20, raylib.BLACK)
}

GUI_DrawText :: proc (text:cstring, alignment:TextAlignment, posX:i32, posY:i32, fontSize :i32, fontColor: raylib.Color){
	if alignment == .Left {
		raylib.DrawText(text, posX, posY, fontSize, fontColor)
	} else if alignment == .Center {
		scoreSizeLeft := raylib.MeasureText(text, fontSize)
		raylib.DrawText(text, (posX - scoreSizeLeft/2), posY, fontSize, fontColor)
	} else if alignment == .Right {
		scoreSizeLeft := raylib.MeasureText(text, fontSize)
		raylib.DrawText(text, (posX - scoreSizeLeft), posY, fontSize, fontColor)
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

HasAABBCollision :: proc(a: Rectangle, b: Rectangle) -> bool{
	bX := b.centerPosition.x - (b.size.x / 2)
	bY := b.centerPosition.y - (b.size.y / 2)
	aX := a.centerPosition.x - (a.size.x / 2)
	aY := a.centerPosition.y - (a.size.y / 2)
	hasCollisionX := aX+a.size.x >= bX && bX+b.size.x >= aX
	hasCollisionY := aY+a.size.y >= bY && bY+b.size.y >= aY
	return hasCollisionX && hasCollisionY
}