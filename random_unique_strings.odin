package aroots

import "core:fmt"
import "core:math/rand"
import "core:intrinsics"

RandomUniqueStrings :: struct{
	strings: 		map[string]bool,
	copy_strings: 	[]string,
}

Create_RandomUniqueStrings :: proc(randomUniqueStrings:^RandomUniqueStrings, strings: []string){
    randomUniqueStrings.copy_strings = make([]string, len(strings)) 
    copy(randomUniqueStrings.copy_strings, strings)
    rand.shuffle(randomUniqueStrings.copy_strings)
	{
		randomUniqueStrings.strings = make(map[string]bool)
		for string_to_add in randomUniqueStrings.copy_strings {
			randomUniqueStrings.strings[string_to_add] = false
		}
	}
}

Destroy_RandomUniqueStrings :: proc(randomUniqueStrings:^RandomUniqueStrings) {
	delete(randomUniqueStrings.strings)
	delete(randomUniqueStrings.copy_strings)
}

GetString_RandomUniqueStrings :: proc(randomUniqueStrings:^RandomUniqueStrings) ->(string, bool) {
	for str in randomUniqueStrings.copy_strings {	// do it this way because maps sort by index and will no longer be random
		value, ok := randomUniqueStrings.strings[str]
		if(ok && !value){
			randomUniqueStrings.strings[str] = true
			return str, true
		}
	}
	return "", false
}