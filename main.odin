package aroots

import raylib "vendor:raylib"

main :: proc() {
	raylib.InitWindow(800, 450, "ODIN Sample")
	defer raylib.CloseWindow()

	raylib.SetTargetFPS(60)

	for !raylib.WindowShouldClose() {
		raylib.BeginDrawing()
		defer raylib.EndDrawing()
		raylib.ClearBackground(raylib.BLACK)

		dt := raylib.GetFrameTime()
		Update(dt)
		Draw()
	}
}



Update :: proc (deltaTime:f32){
}

Draw :: proc (){
	raylib.DrawText("Congrats! You created your first window!", 190, 200, 20, raylib.WHITE)	
}