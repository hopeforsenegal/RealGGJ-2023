package aroots

ChainedDialogue :: struct{
	dialogueIndex: 		i32,
	dialogueSegments: 	[50]DialogueSegment,
}

DialogueSegment :: struct {
	text: 		string,
	timerText: 	f32,
}

intro_dialogue: 		ChainedDialogue
first_seeds_dialogue: 	ChainedDialogue
halfway_first_batch_seeds_dialogue: 	ChainedDialogue
all_done_seeds_dialogue: ChainedDialogue
no_seeds_dialogue: 		ChainedDialogue

active_dialogue: 		^ChainedDialogue
random_old_dialouge: RandomUniqueStrings

SetActiveDialogue :: proc(chainedDialogue:^ChainedDialogue, forceReset:bool = false) {
	if(forceReset) { 
		chainedDialogue.dialogueIndex = -1
	}
	if(chainedDialogue.dialogueIndex < 0) {
		chainedDialogue.dialogueIndex = 0
	}
	active_dialogue = chainedDialogue
}

SetupAllDialogue :: proc() {
	random_old_dialouge_strings:= [?]string{
		"Granny\nis getting\nold!", 
		"Granny\nis getting\nold!",
		"Granny\nis getting\nold!", 
		"Granny\nis getting\nold!",
		"Granny\nnot built\nFord Tough!",
		"Granny\ntoo old\nfor this!", 
		"Granny\nneeds her nap!",
		"Granny\nsoon head to\nthe glue shop!",
		"Granny\nflirting with\nthe ancestors!",
		"Granny\n*yawn*\nwhat was..?",
		"Granny\n... ..\nzzZzzz",
	}
	Create_RandomUniqueStrings(&random_old_dialouge, random_old_dialouge_strings[:])
	defer Destroy_RandomUniqueStrings(&random_old_dialouge)
	{
		dialogue := &intro_dialogue
		adder := 0
		dialogue.dialogueIndex = -1	
		dialogue.dialogueSegments[0] = DialogueSegment{text="Um...", timerText=3}
		dialogue.dialogueSegments[1] = DialogueSegment{text="Hey child", timerText=3}
		dialogue.dialogueSegments[2] = DialogueSegment{text="You planting\nthose plants\nyet?", timerText=3}
		old_granny_text, ok := GetString_RandomUniqueStrings(&random_old_dialouge)
		assert(ok)
		dialogue.dialogueSegments[3] = DialogueSegment{text=old_granny_text, timerText=3}
	}
	{
		dialogue := &no_seeds_dialogue
		dialogue.dialogueIndex = -1
		dialogue.dialogueSegments[0] = DialogueSegment{text="Honey..", timerText=2}
		dialogue.dialogueSegments[1] = DialogueSegment{text="You ain't", timerText=3}
		dialogue.dialogueSegments[2] = DialogueSegment{text="Planting\nwithout seeds\nare you?", timerText=3}
		old_granny_text, ok := GetString_RandomUniqueStrings(&random_old_dialouge)
		assert(ok)
		dialogue.dialogueSegments[3] = DialogueSegment{text=old_granny_text, timerText=3}
	}
	{
		dialogue := &first_seeds_dialogue
		dialogue.dialogueIndex = -1
		dialogue.dialogueSegments[0] = DialogueSegment{text="Thats right\nsugar plum", timerText=3}
		dialogue.dialogueSegments[1] = DialogueSegment{text="Go ahead and", timerText=2.5}
		dialogue.dialogueSegments[2] = DialogueSegment{text="plant those\nover there\nsomewhere", timerText=3}
		old_granny_text, ok := GetString_RandomUniqueStrings(&random_old_dialouge)
		assert(ok)
		dialogue.dialogueSegments[3] = DialogueSegment{text=old_granny_text, timerText=3}
	}
	{
		dialogue := &all_done_seeds_dialogue
		dialogue.dialogueIndex = -1
		dialogue.dialogueSegments[0] = DialogueSegment{text="Well its\nbed time", timerText=3}
		dialogue.dialogueSegments[1] = DialogueSegment{text="Go ahead and", timerText=2.5}
		dialogue.dialogueSegments[2] = DialogueSegment{text="go to\nsleep over there\n...", timerText=3}
		dialogue.dialogueSegments[2] = DialogueSegment{text="Sweet cheeks", timerText=1}
		old_granny_text, ok := GetString_RandomUniqueStrings(&random_old_dialouge)
		assert(ok)
		dialogue.dialogueSegments[3] = DialogueSegment{text=old_granny_text, timerText=3}
	}
	{
		dialogue := &halfway_first_batch_seeds_dialogue
		dialogue.dialogueIndex = -1
		dialogue.dialogueSegments[0] = DialogueSegment{text="Thats right\nlong bottom", timerText=3}
		dialogue.dialogueSegments[1] = DialogueSegment{text="you bout halfway", timerText=2.5}
		dialogue.dialogueSegments[2] = DialogueSegment{text="gone head\nfinish up", timerText=3}
		old_granny_text, ok := GetString_RandomUniqueStrings(&random_old_dialouge)
		assert(ok)
		dialogue.dialogueSegments[3] = DialogueSegment{text=old_granny_text, timerText=3}
	}
}

ProgressDialogueIfReady :: proc(chainedDialogue: ^ChainedDialogue) {
	chainedDialogue.dialogueIndex = chainedDialogue.dialogueIndex + 1
	if(chainedDialogue.dialogueIndex >= len(chainedDialogue.dialogueSegments)) { 
		chainedDialogue.dialogueIndex = -1
	}
}

GetDialogueTimer :: proc(chainedDialogue: ^ChainedDialogue) ->^f32{
	index := chainedDialogue^.dialogueIndex
	return &chainedDialogue.dialogueSegments[index].timerText
}

GetDialogueText :: proc(chainedDialogue: ^ChainedDialogue) ->string{
	index := chainedDialogue^.dialogueIndex
	return chainedDialogue.dialogueSegments[index].text
}

ActiveDialogue :: proc() -> (^ChainedDialogue, bool){
	return active_dialogue, active_dialogue != nil
}