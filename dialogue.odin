package aroots

ChainedDialogue :: struct{
	dialogueIndex: 		i32,
	dialogueSegments: 	[50]DialogueSegment,
}

DialogueSegment :: struct {
	text: 		string,
	timerText: 	f32,
}

intro_dialogue: 	ChainedDialogue
no_seeds_dialogue: 	ChainedDialogue
active_dialogue: 	^ChainedDialogue

SetActiveDialogue :: proc(chainedDialogue:^ChainedDialogue) {
	if(chainedDialogue.dialogueIndex < 0) {
		chainedDialogue.dialogueIndex = 0
	}
	active_dialogue = chainedDialogue
}

SetupIntroDialouge :: proc() {
	intro_dialogue.dialogueIndex = -1
	intro_dialogue.dialogueSegments[0] = DialogueSegment{text="Um...", timerText=3}
	intro_dialogue.dialogueSegments[1] = DialogueSegment{text="Hey child", timerText=3}
	intro_dialogue.dialogueSegments[2] = DialogueSegment{text="You planting\nthose plants\nyet?", timerText=3}
	intro_dialogue.dialogueSegments[3] = DialogueSegment{text="Granny\nis getting\nold!", timerText=3}
}

SetupNoSeedsDialouge :: proc() {
	no_seeds_dialogue.dialogueIndex = -1
	no_seeds_dialogue.dialogueSegments[0] = DialogueSegment{text="Honey..", timerText=3}
	no_seeds_dialogue.dialogueSegments[1] = DialogueSegment{text="You ain't", timerText=3}
	no_seeds_dialogue.dialogueSegments[2] = DialogueSegment{text="Planting\nwithout seeds\nare you?", timerText=3}
	no_seeds_dialogue.dialogueSegments[3] = DialogueSegment{text="Granny\nis getting\nold!", timerText=3}
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