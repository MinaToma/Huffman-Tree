
INCLUDE Irvine32.inc
.DATA

COMMENT @
	This is the main container that simulates the original prioiry queue
	Data will be like
	fistBit secondBit thirdBit fourthBit
	------Occurrences--------- --value--
@
priorityQueue dword 300 dup(0)

;===========================================================================

COMMENT @
	The size of priorityQueue
@
Size



.code
main PROC


	exit
main ENDP

END main