package aroots

RunTests :: proc(){
	assert(NumberOfCharacters("thiss", 'x') == 0)
	assert(NumberOfCharacters("thiss", 't') == 1)
	assert(NumberOfCharacters("thiss", 's') == 2)
	assert(NumberOfCharacters("thi\nss", '\n') == 1)
}