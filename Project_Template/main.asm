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

;--------------------------------------------------------------------------
; 	This data structure to hold huffman tree code  
;	Data will be like
;	FirstDword			SecondDword
;	Key					binaryCode
;--------------------------------------------------------------------------
huffmanTreeCode dword 2048 dup(-1)

;--------------------------------------------------------------------------
; go to next code at huffmanTreeCode
;--------------------------------------------------------------------------
nextValHuffmanTreeCode dword 8

;==========================================================================
;==========================================================================
;==========================================================================


.code
main PROC
	
	CALL constructOccurPQ
	CALL constructTree
	CALL getAllHuffmanTreeCode

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


;--------------------------------------------------------------------------
; add all huffmanTree Code in data structure called huffmanTreeCode 
; by traverse tree by stack
;--------------------------------------------------------------------------

getAllHuffmanTreeCode PROC
	
	mov esi, offset huffmanTree
	mov ecx, huffmanTreeSize
	dec ecx
	
	goToLastIndexInHuffmanTree:
		add esi, shiftOffset
	loop goToLastIndexInHuffmanTree
	
	mov eax, esi
	call writeDec
	call crlf

	mov edi, offset huffmanTreeCode
	
	; 0FFFFFFFFh value to check is stack is empty
	mov eax, 0FFFFFFFFh
	push eax
	push eax
	
	; push current code and address of the root
	mov eax,1
	push eax
	push esi
	loopWhileStackNotEmp:
		pop esi
		pop ecx
		; get left node 
		mov eax, [esi + type huffmanTree]
		; get right node
		mov ebx, [esi + type huffmanTree * 2]


		cmp eax,-1
		jnz getLeftAndRightNode
		cmp ebx,-1
		jnz	getLeftAndRightNode

			; now add code value to our ds
			mov edx, [esi]
			mov [edi], edx
			mov [edi + type huffmanTreeCode], ecx
			add edi, nextValHuffmanTreeCode
			; now go to end of the loop 
			mov eax,0
			cmp eax,0
			jz endThisNode



		; if node is not null push the currnet code in stack and address 
		getLeftAndRightNode:
			cmp eax,-1
			jz leftNodeIsNull
			imul eax, TYPE huffmanTree * 3
			shl ecx,1
			push ecx
			shr ecx,1
			mov edx, offset huffmanTree
			add edx, eax
			push edx
		leftNodeIsNull:


			cmp ebx,-1
		jz rightNodeIsNull
			imul ebx, TYPE huffmanTree * 3
			shl ecx,1
			inc ecx
			push ecx
			shr ecx,1
			mov edx, offset huffmanTree
			add edx, ebx
			push edx
		rightNodeIsNull:


		endThisNode:
			pop eax
			pop ecx
			cmp eax,0FFFFFFFFh
			push ecx
			push eax
	; now stack is empty
	jnz loopWhileStackNotEmp
	pop eax
	pop ecx
	
	RET
getAllHuffmanTreeCode ENDP


END main