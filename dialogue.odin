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
no_seeds_dialogue: 		ChainedDialogue
active_dialogue: 		^ChainedDialogue

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
	{
		dialogue := &intro_dialogue
		dialogue.dialogueIndex = -1
		dialogue.dialogueSegments[0] = DialogueSegment{text="Um...", timerText=3}
		dialogue.dialogueSegments[1] = DialogueSegment{text="Hey child", timerText=3}
		dialogue.dialogueSegments[2] = DialogueSegment{text="You planting\nthose plants\nyet?", timerText=3}
		dialogue.dialogueSegments[3] = DialogueSegment{text="Granny\nis getting\nold!", timerText=3}
	}
	{
		dialogue := &no_seeds_dialogue
		dialogue.dialogueIndex = -1
		dialogue.dialogueSegments[0] = DialogueSegment{text="Honey..", timerText=2}
		dialogue.dialogueSegments[1] = DialogueSegment{text="You ain't", timerText=3}
		dialogue.dialogueSegments[2] = DialogueSegment{text="Planting\nwithout seeds\nare you?", timerText=3}
		dialogue.dialogueSegments[3] = DialogueSegment{text="Granny\nis getting\nold!", timerText=3}
	}
	{
		dialogue := &first_seeds_dialogue
		dialogue.dialogueIndex = -1
		dialogue.dialogueSegments[0] = DialogueSegment{text="Thats right\nsugar plum", timerText=3}
		dialogue.dialogueSegments[1] = DialogueSegment{text="Go ahead and", timerText=2.5}
		dialogue.dialogueSegments[2] = DialogueSegment{text="plant those\nover there\nsomewhere", timerText=3}
		dialogue.dialogueSegments[3] = DialogueSegment{text="Granny\nnot built\nFord Tough!", timerText=3}
	}
	{
		dialogue := &halfway_first_batch_seeds_dialogue
		dialogue.dialogueIndex = -1
		dialogue.dialogueSegments[0] = DialogueSegment{text="Thats right\nsugar plum", timerText=3}
		dialogue.dialogueSegments[1] = DialogueSegment{text="Go ahead and", timerText=2.5}
		dialogue.dialogueSegments[2] = DialogueSegment{text="plant those\nover there\nsomewhere", timerText=3}
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