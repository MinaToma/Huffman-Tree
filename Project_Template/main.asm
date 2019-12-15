INCLUDE Irvine32.inc
INCLUDE macros.inc

.DATA


;--------------------------------------------------------------------------
; Random purpose variables
;--------------------------------------------------------------------------
inputString byte 1000 dup(0)							;input string
inputStringSize dword 0									;ipnut string size
outputString byte 1000 dup(0)							;output string
outputStringSize dword 0								;output string size
outputStringCharacter byte 1000 dup(0)					;output string for characters
outputStringCharacterSize dword 0						;output string for characters size
newLineChar db 0Dh, 0Ah									;Variable for newLineChar
newLineCharLength dword 2								;Length of newLineChar
shiftOffset dword 12									;shift to get next Node
maxValue dword 1000000000								;Max Value


;--------------------------------------------------------------------------
; Variables for reading form file
;--------------------------------------------------------------------------
bufferSize DWORD  1000d 
buffer BYTE 1000 DUP(?)
inputFileName BYTE "C:\Huffman-Tree\Project_Template\Debug\input.txt",0
inputFileHandle HANDLE ?


;--------------------------------------------------------------------------
; Variables for wrting to file
;--------------------------------------------------------------------------
outputFileName BYTE "C:\Huffman-Tree\Project_Template\Debug\output.txt", 0
outputFileHandle HANDLE ?
stringLength DWORD ?
bytesWritten DWORD ?
cannotCreateFileError BYTE "Cannot create file", 0dh, 0ah, 0


;--------------------------------------------------------------------------
;	This is the main container that simulates the original prioiry queue
;	Data will be like
;	FirstDword			SecondDword			ThirdDword
;	Occurrences			Value				Index in huffmanTree
;--------------------------------------------------------------------------
priorityQueue dword 1024 dup(-1)
characterArray dword 1024 dup(-1)
priorityQueueSize dword 0								;The size of priorityQueue
characterCount dword 0									;Number of Characters


;--------------------------------------------------------------------------
;	The main data structure to hold huffman tree nodes
;	Data will be like
;	FirstDword			SecondDword			ThirdDword
;	Value				LeftChild			RightChild
;--------------------------------------------------------------------------
huffmanTree dword 2048 dup(-1)
huffmanTreeSize dword 0									;The size of huffmanTree


;--------------------------------------------------------------------------
;	Main array to perform BFS on the tree	
;--------------------------------------------------------------------------
bfsArray dword 1024 dup(0)
bfsArrayHead dword 0									;Pointer of bfsArray head
bfsArrayTail dword 0									;Pointer of bfsArray tail



;==========================================================================
;==========================================================================
;==========================================================================


.code
main PROC
	
	CALL Read_File
	CALL constructOccurPQ
	CALL constructTree
	CALL bfsTraversal
	CALL Write_File

	exit
main ENDP


; ------------------------------------------------------------------------------------------------------------
; Proc for reading Huffman file 
; Takse name of file and buffer to read on it
; Reutrns buff => data of file 
; ------------------------------------------------------------------------------------------------------------
Read_File proc 

	mov edx, OFFSET inputFileName

	call OpenInputFile
	mov inputFileHandle, eax

	; Check for errors.
	cmp eax, INVALID_HANDLE_VALUE   ; error opening file ?
	jne file_ok  ; no: skip
	mWrite <"Cannot open file", 0dh, 0ah>
	jmp quit  ; and quit

	; Read the file into a buffer.
	file_ok:                                    
	mov edx, OFFSET buffer
	mov ecx, bufferSize
	call ReadFromFile

	jnc check_bufferSize ; error reading ?

	mWrite "Error reading file. "; yes: show error message
	call WriteWindowsMsg
	jmp close_file

	check_bufferSize:
	cmp eax, bufferSize ; buffer large enough ?
	jb buf_size_ok  ; yes
	mWrite <"Error: Buffer too small for the file", 0dh, 0ah>
	jmp quit; terminate

	buf_size_ok:
	mov esi, offset buffer
	mov edi, offset inputString
	mov ecx, eax
	mov inputStringSize, eax
	rep movsb

	close_file:
	mov eax, inputFileHandle
	call CloseFile
 
	quit:
  ret
Read_File Endp


; ------------------------------------------------------------------------------------------------------------
; Proc for writing into file
; Takes handle of file and buffer to read on it
; Reutrns new updated file after writing
; ------------------------------------------------------------------------------------------------------------
Write_File proc

	mov edx, OFFSET outputFileName ; Create a new text file.
	call CreateOutputFile
	mov outputFileHandle, eax

	; Check for errors.
	cmp eax, INVALID_HANDLE_VALUE ; error found ?
	jne file_ok ; no: skip
	mov edx, OFFSET cannotCreateFileError; display error
	call WriteString
	jmp quit

	file_ok:

	mov esi, offset outputString
	mov edi, offset buffer
	mov ecx, outputStringSize
	rep movsb

	mov eax, outputStringSize
	mov stringLength, eax ; counts chars entered
 
	mov eax, outputFileHandle ;Write the buffer to the output file.
	mov edx, OFFSET buffer
	mov ecx, stringLength
	call WriteToFile

	mov eax, outputFileHandle ;Write the buffer to the output file.
	mov edx, OFFSET newLineChar
	mov ecx, newLineCharLength
	call WriteToFile

	mov eax, outputFileHandle ;Write the buffer to the output file.
	mov edx, OFFSET outputStringCharacter
	mov ecx, outputStringCharacterSize
	call WriteToFile

	call CloseFile

	quit:

    ret
Write_File ENDP


;--------------------------------------------------------------------------
; Given a string it creates an occurrences array --> priorityQueue
; Fills Leaves nodes in huffmanTree
; at last:
;	----> huffmanTreeSize = equal to number of leaves
;	----> prioirtyQueueSize = number of unique chars 
;--------------------------------------------------------------------------
constructOccurPQ PROC

	mov ecx, inputStringSize
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
	mov edx, offset characterArray
	fillHuffmanTreeLeaves:
		mov eax, [esi + type priorityQueue]
		mov [edi], eax

		mov [edx + TYPE characterArray], eax
		mov eax, [esi]
		mov [edx], eax

		mov eax, huffmanTreeSize
		mov [esi + type priorityQueue * 2], eax
		
		add edx, shiftOffset
		add esi, shiftOffset
		add edi, shiftOffset
		inc characterCount
		inc huffmanTreeSize
	Loop fillHuffmanTreeLeaves

	RET
constructOccurPQ ENDP


;--------------------------------------------------------------------------
; Constructs Huffman tree
;--------------------------------------------------------------------------
constructTree PROC
	
	CALL sortPQ
	
	cmp priorityQueueSize, 1
	jz oneElementInPQ

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
	oneElementInPQ:

	mov esi, offset huffmanTree

	RET
constructTree ENDP


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

		cmp ecx, 0
		jz noElements
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
		
		noElements:

		mov esi, offset priorityQueue
		pop ecx
	loop oLoop

	RET
sortPQ ENDP


;--------------------------------------------------------------------------
; Performs BFS tree traversal to output the tree level by level
; Node, LeftChild, RighthChild
;--------------------------------------------------------------------------
bfsTraversal PROC
	
	mov esi, offset huffmanTree
	
	mov edi, offset bfsArray
	mov eax, huffmanTreeSize
	dec eax
	mov [edi], eax
	inc bfsArrayTail

	bfsLoop:
		mov ebx, bfsArrayHead
		imul ebx, TYPE bfsArray
		mov edx, [edi + ebx]

		imul edx, TYPE huffmanTree * 3
		mov eax, [esi + edx]

		inc bfsArrayHead
		push eax
		
		cmp eax, -1
		jz skipNullNode

		;----------------
		; Push Left Node
		;----------------
		mov eax, [esi + edx + type huffmanTree]
		mov ebx, bfsArrayTail
		imul ebx, TYPE bfsArray
		mov [edi + ebx], eax
		inc bfsArrayTail

		;----------------
		; Push Right Node
		;----------------
		mov eax, [esi + edx + type huffmanTree * 2]
		mov ebx, bfsArrayTail
		imul ebx, TYPE bfsArray
		mov [edi + ebx], eax
		inc bfsArrayTail

		cmp eax, -1
		jz noChildren

		pop eax
		jmp hasChildren

		noChildren:
		pop eax
		push esi
		mov esi, offset characterArray
		mov ecx, characterCount
		getCharValue:
			mov edx, ecx
			dec edx
			imul edx, TYPE characterArray * 3
			mov ebx, [esi + edx + TYPE characterArray]
			cmp [esi + edx + TYPE characterArray], eax
			jnz noMatchCharacter
			
			push edi
			push edx
			
			mov edi, offset outputStringCharacter
			mov edx, outputStringCharacterSize
			mov [edi + edx], eax
			inc outputStringCharacterSize
			mov dword ptr [edi + edx + TYPE outputStringCharacter], ' '
			inc outputStringCharacterSize

			pop edx
			pop edi

			mov eax, [esi + edx]
			pop esi
			jmp hasChildren
			noMatchCharacter:
		Loop getCharValue
		pop esi

		jmp hasChildren

		skipNullNode:
		pop eax
		mov eax, 0

		hasChildren:
		call numberToStringToOutputString

		mov eax, bfsArrayTail
		cmp bfsArrayHead, eax
		jnz bfsLoop

	ret
bfsTraversal ENDP


;--------------------------------------------------------------------------
; Takes number in eax and returns it concatenated to outputString
;--------------------------------------------------------------------------
numberToStringToOutputString PROC uses ebx ecx esi edx ecx
	
	mov ebx, 10
	mov esi, offset outputString
	mov ecx, 0
	whileNumberIsNotZero:
		mov edx, 0
		div ebx
		push edx
		inc ecx
		cmp eax, 0
		jnz whileNumberIsNotZero

	insertNumbers:
		pop eax
		or al, 00110000b
		mov edx, outputStringSize
		mov [esi + edx], al
		inc outputStringSize
	Loop insertNumbers

	mov dl, ' '
	mov ecx, outputStringSize
	mov [esi + ecx], dl
	inc outputStringSize	

	ret
numberToStringToOutputString ENDP

END main