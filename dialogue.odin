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
early_bed_dialogue: 		ChainedDialogue
first_seeds_dialogue: 	ChainedDialogue
wake_up_dialogue1: 	ChainedDialogue
wake_up_dialogue2: 	ChainedDialogue
wake_up_dialogue3: 	ChainedDialogue
halfway_first_batch_seeds_dialogue: 	ChainedDialogue
all_done_seeds_dialogue1: ChainedDialogue
all_done_seeds_dialogue2: ChainedDialogue
no_seeds_dialogue: 		ChainedDialogue
more_red_dialogue: 		ChainedDialogue
green_black_mix_dialouge: 	ChainedDialogue
swap_green_black_dialouge: 	ChainedDialogue
stand_tall_dialouge:		ChainedDialogue
red_ends_dialouge:			ChainedDialogue
why_close_dialogue1: ChainedDialogue
why_close_dialogue2: ChainedDialogue
why_close_dialogue3: ChainedDialogue
why_close_dialogue4: ChainedDialogue
has_won_dialogue:		ChainedDialogue
one_of_each_dialogue: ChainedDialogue

active_dialogue: 		^ChainedDialogue
random_old_dialouge: RandomUniqueStrings

SetActiveDialogue :: proc(chainedDialogue:^ChainedDialogue) {
	if(chainedDialogue != nil && chainedDialogue.dialogueIndex < 0) {
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
		"Granny\nis getting\nold!",
		"Granny\nold OLD!",
		"Granny\nwas old\n70 years ago!",
		"Granny\nstarting to\nrot!",
		"Granny\nskin starting\nto odor!",
		"Granny\ngot amnesia\nok!", 
		"Granny\ngot that\nalzheimer's!",
		"Granny\nmemory\nneed work!",
		"Granny\nnot built\nFord Tough!",
		"Granny\ntoo old\nfor this!", 
		"Granny\nneeds her nap!",
		"Granny\nneeds her nap!",
		"Granny\nsoon head to\nthe glue shop!",
		"Granny\nhalfway to\nthe morgue!",
		"Granny\nsoon drop\ndead DEAD!",
		"Granny\nswear she saw\nher granny!",
		"Granny\nswear she saw\nher granny!",
		"Granny\nflirting with\nthe ancestors!",
		"Granny\nflirting with\nthe ancestors!",
		"Granny\n*yawn*\nwhat was..?",
		"Granny\nskin gettin\nleathery",
		"Granny\nheart stopped\n5 minutes ago",
		"Granny\nheart stopped\n5 minutes ago",
		"Granny\n... ..\nzzZzzz",
		"Granny\n... ..\nzzZzzz",
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
		dialogue := &all_done_seeds_dialogue1
		dialogue.dialogueIndex = -1
		dialogue.dialogueSegments[0] = DialogueSegment{text="Well its\nbed time", timerText=3}
		dialogue.dialogueSegments[1] = DialogueSegment{text="Go ahead and", timerText=2.5}
		dialogue.dialogueSegments[2] = DialogueSegment{text="go to\nsleep over there\n...", timerText=3}
		dialogue.dialogueSegments[3] = DialogueSegment{text="Sweet cheeks", timerText=1}
		old_granny_text, ok := GetString_RandomUniqueStrings(&random_old_dialouge)
		assert(ok)
		dialogue.dialogueSegments[4] = DialogueSegment{text=old_granny_text, timerText=3}
	}
	{
		dialogue := &all_done_seeds_dialogue2
		dialogue.dialogueIndex = -1
		dialogue.dialogueSegments[0] = DialogueSegment{text="Bed time\ncupcake!", timerText=3}
		dialogue.dialogueSegments[1] = DialogueSegment{text="Go ahead and", timerText=2.5}
		dialogue.dialogueSegments[2] = DialogueSegment{text="go rest\n down over there", timerText=3}
		dialogue.dialogueSegments[3] = DialogueSegment{text="Sugar plum", timerText=1}
		old_granny_text, ok := GetString_RandomUniqueStrings(&random_old_dialouge)
		assert(ok)
		dialogue.dialogueSegments[4] = DialogueSegment{text=old_granny_text, timerText=3}
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
	{
		dialogue := &early_bed_dialogue
		dialogue.dialogueIndex = -1
		dialogue.dialogueSegments[0] = DialogueSegment{text="What is \nyou doin?!", timerText=3}
		dialogue.dialogueSegments[1] = DialogueSegment{text="Don't go to\nsleep", timerText=3}
		dialogue.dialogueSegments[2] = DialogueSegment{text="before Granny!", timerText=3}
		old_granny_text, ok := GetString_RandomUniqueStrings(&random_old_dialouge)
		assert(ok)
		dialogue.dialogueSegments[3] = DialogueSegment{text=old_granny_text, timerText=3}
	}
	{
		dialogue := &wake_up_dialogue1
		dialogue.dialogueIndex = -1
		dialogue.dialogueSegments[0] = DialogueSegment{text="Bout time you\nwoke up!", timerText=4}
		dialogue.dialogueSegments[1] = DialogueSegment{text="Our ancestors\nweren't lazy", timerText=3}
		dialogue.dialogueSegments[2] = DialogueSegment{text="get moving!", timerText=3}
		old_granny_text, ok := GetString_RandomUniqueStrings(&random_old_dialouge)
		assert(ok)
		dialogue.dialogueSegments[3] = DialogueSegment{text=old_granny_text, timerText=3}
	}
	{
		dialogue := &wake_up_dialogue2
		dialogue.dialogueIndex = -1
		dialogue.dialogueSegments[0] = DialogueSegment{text="Well look who\nwoke up!", timerText=4}
		dialogue.dialogueSegments[1] = DialogueSegment{text="Quit yo\nlazy self", timerText=3}
		dialogue.dialogueSegments[2] = DialogueSegment{text="get moving!", timerText=3}
		old_granny_text, ok := GetString_RandomUniqueStrings(&random_old_dialouge)
		assert(ok)
		dialogue.dialogueSegments[3] = DialogueSegment{text=old_granny_text, timerText=3}
	}
	{
		dialogue := &wake_up_dialogue3
		dialogue.dialogueIndex = -1
		dialogue.dialogueSegments[0] = DialogueSegment{text="Get up\nsleepy head!", timerText=4}
		dialogue.dialogueSegments[1] = DialogueSegment{text="Whats the\nhold up?", timerText=3}
		dialogue.dialogueSegments[2] = DialogueSegment{text="get moving!", timerText=3}
		old_granny_text, ok := GetString_RandomUniqueStrings(&random_old_dialouge)
		assert(ok)
		dialogue.dialogueSegments[3] = DialogueSegment{text=old_granny_text, timerText=3}
	}
	{
		dialogue := &more_red_dialogue
		dialogue.dialogueIndex = -1
		dialogue.dialogueSegments[0] = DialogueSegment{text="No child!\nthats not it!", timerText=4}
		dialogue.dialogueSegments[1] = DialogueSegment{text="our past\nhas a lot", timerText=3}
		dialogue.dialogueSegments[2] = DialogueSegment{text="more blood in it!", timerText=3}
		dialogue.dialogueSegments[3] = DialogueSegment{text="Now try again!", timerText=3}
		old_granny_text, ok := GetString_RandomUniqueStrings(&random_old_dialouge)
		assert(ok)
		dialogue.dialogueSegments[4] = DialogueSegment{text=old_granny_text, timerText=3}
	}
	{
		dialogue := &red_ends_dialouge
		dialogue.dialogueIndex = -1
		dialogue.dialogueSegments[0] = DialogueSegment{text="No child!\nBut that feel\nclose!", timerText=4}
		dialogue.dialogueSegments[1] = DialogueSegment{text="Blood permeates\nthe outer\nlimbs", timerText=3}
		dialogue.dialogueSegments[2] = DialogueSegment{text="not just\nthe gut!", timerText=3}
		dialogue.dialogueSegments[3] = DialogueSegment{text="Now try again!", timerText=3}
		old_granny_text, ok := GetString_RandomUniqueStrings(&random_old_dialouge)
		assert(ok)
		dialogue.dialogueSegments[4] = DialogueSegment{text=old_granny_text, timerText=3}
	}
	{
		dialogue := &swap_green_black_dialouge
		dialogue.dialogueIndex = -1
		dialogue.dialogueSegments[0] = DialogueSegment{text="Uh child!\nYou need\n some tea?", timerText=4}
		dialogue.dialogueSegments[1] = DialogueSegment{text="You confusing\nthe people", timerText=3}
		dialogue.dialogueSegments[2] = DialogueSegment{text="with their\nwealth!", timerText=3}
		dialogue.dialogueSegments[3] = DialogueSegment{text="Now try again!", timerText=3}
		old_granny_text, ok := GetString_RandomUniqueStrings(&random_old_dialouge)
		assert(ok)
		dialogue.dialogueSegments[4] = DialogueSegment{text=old_granny_text, timerText=3}
	}
	{
		dialogue := &stand_tall_dialouge
		dialogue.dialogueIndex = -1
		dialogue.dialogueSegments[0] = DialogueSegment{text="Child!\nIts like\n I always say", timerText=4}
		dialogue.dialogueSegments[1] = DialogueSegment{text="the people\nneed to", timerText=3}
		dialogue.dialogueSegments[2] = DialogueSegment{text="stand taller\nthan that!", timerText=3}
		dialogue.dialogueSegments[3] = DialogueSegment{text="Now again!\n Again!", timerText=3}
		old_granny_text, ok := GetString_RandomUniqueStrings(&random_old_dialouge)
		assert(ok)
		dialogue.dialogueSegments[4] = DialogueSegment{text=old_granny_text, timerText=3}
	}	
	{
		dialogue := &one_of_each_dialogue
		dialogue.dialogueIndex = -1
		dialogue.dialogueSegments[0] = DialogueSegment{text="No child!\nNo!", timerText=4}
		dialogue.dialogueSegments[1] = DialogueSegment{text="our past\nis mixedup", timerText=3}
		dialogue.dialogueSegments[2] = DialogueSegment{text="We are\nsome of\neverythang!", timerText=3}
		dialogue.dialogueSegments[3] = DialogueSegment{text="Now try again!", timerText=3}
		old_granny_text, ok := GetString_RandomUniqueStrings(&random_old_dialouge)
		assert(ok)
		dialogue.dialogueSegments[4] = DialogueSegment{text=old_granny_text, timerText=3}
	}
	{
		dialogue := &green_black_mix_dialouge
		dialogue.dialogueIndex = -1
		dialogue.dialogueSegments[0] = DialogueSegment{text="Blasted child!\nNo!", timerText=4}
		dialogue.dialogueSegments[1] = DialogueSegment{text="blood is\nbetween", timerText=3}
		dialogue.dialogueSegments[2] = DialogueSegment{text="the people\nand their\nwealth!", timerText=3}
		dialogue.dialogueSegments[3] = DialogueSegment{text="Still close\nbut again!", timerText=3}
		old_granny_text, ok := GetString_RandomUniqueStrings(&random_old_dialouge)
		assert(ok)
		dialogue.dialogueSegments[4] = DialogueSegment{text=old_granny_text, timerText=3}
	}
	{
		dialogue := &why_close_dialogue1
		dialogue.dialogueIndex = -1
		dialogue.dialogueSegments[0] = DialogueSegment{text="Why you so\nclose child?", timerText=4}
		dialogue.dialogueSegments[1] = DialogueSegment{text="society is\nnothing", timerText=3}
		dialogue.dialogueSegments[2] = DialogueSegment{text="without blood\npeople and\nwealth!", timerText=3}
		old_granny_text, ok := GetString_RandomUniqueStrings(&random_old_dialouge)
		assert(ok)
		dialogue.dialogueSegments[3] = DialogueSegment{text=old_granny_text, timerText=3}
	}
	{
		dialogue := &why_close_dialogue2
		dialogue.dialogueIndex = -1
		dialogue.dialogueSegments[0] = DialogueSegment{text="Back up\nnah!!", timerText=4}
		dialogue.dialogueSegments[1] = DialogueSegment{text="Did you\nforget", timerText=3}
		dialogue.dialogueSegments[2] = DialogueSegment{text="what color\nblood is?", timerText=3}
		old_granny_text, ok := GetString_RandomUniqueStrings(&random_old_dialouge)
		assert(ok)
		dialogue.dialogueSegments[3] = DialogueSegment{text=old_granny_text, timerText=3}
	}
	{
		dialogue := &why_close_dialogue3
		dialogue.dialogueIndex = -1
		dialogue.dialogueSegments[0] = DialogueSegment{text="Get to it!", timerText=4}
		dialogue.dialogueSegments[1] = DialogueSegment{text="slacking off\nwont ever", timerText=3}
		dialogue.dialogueSegments[2] = DialogueSegment{text="get you\nthat green!", timerText=3}
		old_granny_text, ok := GetString_RandomUniqueStrings(&random_old_dialouge)
		assert(ok)
		dialogue.dialogueSegments[3] = DialogueSegment{text=old_granny_text, timerText=3}
	}
	{
		dialogue := &why_close_dialogue4
		dialogue.dialogueIndex = -1
		dialogue.dialogueSegments[0] = DialogueSegment{text="Zzzz\nzzz", timerText=4}
		dialogue.dialogueSegments[1] = DialogueSegment{text="people.. zz\nblack..", timerText=3}
		dialogue.dialogueSegments[2] = DialogueSegment{text="love...\n black people\n...", timerText=3}
		old_granny_text, ok := GetString_RandomUniqueStrings(&random_old_dialouge)
		assert(ok)
		dialogue.dialogueSegments[3] = DialogueSegment{text=old_granny_text, timerText=3}
	}
	{
		dialogue := &has_won_dialogue
		dialogue.dialogueIndex = -1
		dialogue.dialogueSegments[0] = DialogueSegment{text="Wow child!\nthats it!", timerText=4}
		dialogue.dialogueSegments[1] = DialogueSegment{text="Thats the\nkey to", timerText=3}
		dialogue.dialogueSegments[2] = DialogueSegment{text="our PAST!", timerText=3}
		dialogue.dialogueSegments[3] = DialogueSegment{text="granny is...", timerText=3}
		dialogue.dialogueSegments[4] = DialogueSegment{text="... granny ...", timerText=3}
		dialogue.dialogueSegments[5] = DialogueSegment{text="granny is so\nPROUD\ndarlin!", timerText=3}
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