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


;--------------------------------------------------------------------------
; shift to get next Node
;--------------------------------------------------------------------------
shiftOffset dword 12


;--------------------------------------------------------------------------
; Max Value
;--------------------------------------------------------------------------
maxValue dword 1000000000

;==========================================================================
;==========================================================================
;==========================================================================


.code
main PROC
	
	CALL constructOccurPQ
	CALL constructTree

	exit
main ENDP


;--------------------------------------------------------------------------
; Given a string it creates an occurrences array --> priorityQueue
; Fills Leaves nodes in huffmanTree
; at last:
;	----> huffmanTreeSize = equal to number of leaves
;	----> prioirtyQueueSize = number of unique chars 
;--------------------------------------------------------------------------
constructOccurPQ PROC
	
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
			add esi, shiftOffset 
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
		mov dword ptr [esi + type priorityQueue * 2], eax

		add esi, shiftOffset
		add edi, shiftOffset
		inc huffmanTreeSize
	Loop fillHuffmanTreeLeaves

	RET
constructOccurPQ ENDP


;--------------------------------------------------------------------------
; Constructs Huffman tree
;--------------------------------------------------------------------------
constructTree PROC
	
	CALL sortPQ
	
	pqSizeNotOne:
		
		;-----------------
		; First Node
		;-----------------
		mov esi, offset priorityQueue
		mov ebx, [esi]

		mov eax, [esi + type priorityQueue * 2]
		mov [edi + type huffmanTree], eax

		add esi, shiftOffset
		
		;-----------------
		; Second Node
		;-----------------
		add ebx, [esi]
		mov eax, [esi + type priorityQueue * 2]
		mov [edi + type huffmanTree * 2], eax

		mov [edi], ebx

		add edi, shiftOffset

		CALL reSortPQ
		cmp priorityQueueSize, 1
		jnz pqSizeNotOne

		RET
constructTree ENDP


;--------------------------------------------------------------------------
; sorts prioirityQueue Array
; uses priorityQueueSize
;--------------------------------------------------------------------------
sortPQ PROC
	
	mov esi, offset priorityQueue
	mov ecx, priorityQueueSize
	
	oLoop:

		push ecx 

		mov ecx, priorityQueueSize
		dec ecx

		iLoop:

			mov eax, [esi]
			cmp eax, [esi + type priorityQueue * 3]
			jbe _continue

			xchg eax, [esi + type priorityQueue * 3]
			mov [esi], eax

			mov eax , [esi + type priorityQueue]
			xchg eax, [esi + type priorityQueue * 4]
			mov[esi + type priorityQueue], eax

			mov eax , [esi + type priorityQueue  * 2]
			xchg eax, [esi + type priorityQueue * 5]
			mov[esi + type priorityQueue * 2], eax

			_continue:

			add esi, shiftOffset
		loop iLoop

		mov esi, offset priorityQueue
		pop ecx
	loop oLoop

	RET
sortPQ ENDP


;--------------------------------------------------------------------------
; removes first two elements and inserts new value (their sum)
; decreases prioirityQueueSize
;--------------------------------------------------------------------------
reSortPQ PROC

	mov esi, offset priorityQueue

	mov ebx, [esi]
	add ebx, [esi + type priorityQueue * 3]
	
	mov [esi], ebx
	mov [esi + type priorityQueue] , ebx
	mov eax, huffmanTreeSize
	mov [esi + type priorityQueue * 2] , eax
	
	mov eax, maxValue
	mov[esi + type priorityQueue * 3], eax
	mov esi, offset priorityQueue

	call sortPQ
	dec priorityQueueSize
	inc huffmanTreeSize

	RET
reSortPQ ENDP

END main