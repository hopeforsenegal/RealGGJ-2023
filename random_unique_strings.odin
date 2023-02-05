package aroots

import "core:math/rand"
import "core:intrinsics"
import "core:fmt"

RandomUniqueStrings :: struct{
	strings: map[string]bool,
}

Create_RandomUniqueStrings :: proc(randomUniqueStrings:^RandomUniqueStrings, strings: []string){
	rand.shuffle(strings)
	{
		randomUniqueStrings.strings = make(map[string]bool)
		for string_to_add in strings {
			randomUniqueStrings.strings[string_to_add] = false
		}
	}
}

Destroy_RandomUniqueStrings :: proc(randomUniqueStrings:^RandomUniqueStrings) {
	delete(randomUniqueStrings.strings)
}

GetString_RandomUniqueStrings :: proc(randomUniqueStrings:^RandomUniqueStrings) ->(string, bool) {
	for key, value in randomUniqueStrings.strings {
		if(!value){
			randomUniqueStrings.strings[key] = true
			return key, true
		}
	}
	return "", false
}