
INCLUDE Irvine32.inc
.DATA

;--------------------------------------------------------------------------
;	This is the main container that simulates the original prioiry queue
;	Data will be like
;	FirstDword			SecondDword			ThirdDword
;	Occurrences			Value				Index in huffmanTree
;--------------------------------------------------------------------------
priorityQueue dword 1024 dup(-1)


;--------------------------------------------------------------------------
;The size of priorityQueue
;--------------------------------------------------------------------------
priorityQueueSize dword 0


;--------------------------------------------------------------------------
;	The main data structure to hold huffman tree nodes
;	Data will be like
;	FirstDword			SecondDword			ThirdDword
;	Value				LeftChild			RightChild
;--------------------------------------------------------------------------
huffmanTree dword 2048 dup(-1)

;--------------------------------------------------------------------------
;	The size of huffmanTree
;--------------------------------------------------------------------------
huffmanTreeSize dword 0

;--------------------------------------------------------------------------
; string for testing
;--------------------------------------------------------------------------
testingString byte "howaree";


.code
main PROC
	
	CALL constructOccurrencesArray

	exit
main ENDP

constructOccurrencesArray PROC
	
	mov ecx, lengthof testingString
	mov esi, offset testingString
	mov edi, offset priorityQueue

	loopOverInputSting:
		push ecx
		
		movzx eax, byte ptr [esi]
		mov ecx, priorityQueueSize
		push esi
		mov esi, offset priorityQueue
		
		cmp ecx, 0
		jz emptyPriorityQueue
		loopOverOccerrenceArray:
			cmp [esi + type priorityQueue], eax
			jnz continue		
			inc dword ptr [esi]
			jmp foundOccurrence

			continue:
			add esi, type priorityQueue
			add esi, type priorityQueue
			add esi, type priorityQueue
		loop loopOverOccerrenceArray

		emptyPriorityQueue:

		mov dword ptr [esi], 1
		mov [esi + type priorityQueue], eax

		inc priorityQueueSize

		foundOccurrence:
		pop esi
		pop ecx
		inc esi
	loop loopOverInputSting

	mov eax, priorityQueueSize
	call writedec

	RET
constructOccurrencesArray ENDP

END main



