
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
inputString byte "howaree";


.code
main PROC
	
	CALL constructOccurArray

	exit
main ENDP

;--------------------------------------------------------------------------
; Given a string it creates an occurrences array --> priorityQueue
; Fills Leaves nodes in huffmanTree
;--------------------------------------------------------------------------
constructOccurArray PROC
	
	mov ecx, lengthof inputString
	mov esi, offset inputString
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
			jnz noEqualChars		
			inc dword ptr [esi]
			jmp foundOccurrence

			noEqualChars:
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

	mov ecx, priorityQueueSize
	mov esi, offset priorityQueue
	mov edi, offset huffmanTree
	fillHuffmanTreeLeaves:
		
		mov eax, [esi + type priorityQueue]
		mov [edi], eax

		mov eax, huffmanTreeSize
		mov dword ptr [esi + type priorityQueue + type priorityQueue], eax

		add esi, type priorityQueue
		add esi, type priorityQueue
		add esi, type priorityQueue

		add edi, type huffmanTree
		add edi, type huffmanTree
		add edi, type huffmanTree

		inc huffmanTreeSize
	Loop fillHuffmanTreeLeaves

	mov esi, offset huffmanTree
	mov edi, offset priorityQueue

	RET
constructOccurArray ENDP

END main



