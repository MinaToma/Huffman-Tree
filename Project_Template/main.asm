INCLUDE Irvine32.inc
INCLUDE macros.inc

.DATA


;--------------------------------------------------------------------------
; Random purpose variables
;--------------------------------------------------------------------------
inputString byte 1000 dup(0)							;input string
inputStringSize dword 0									;ipnut string size
outputString byte 1000 dup(0)							;output string
outputStringSize dword 0							    ;output string size
outputStringCharacter byte 1000 dup(0)					;output string for characters
outputStringCharacterSize dword 0						;output string for characters size
newLineChar db 0Dh, 0Ah								  	;Variable for newLineChar
newLineCharLength dword 2							  	;Length of newLineChar
shiftOffset dword 12					  			  	;shift to get next Node
nextValHuffmanTreeCode dword 8							;Go to next code at huffmanTreeCode
maxValue dword 1000000000							  	;Max Value
compressedOutputString byte 10000 dup(0)				;the result of huffmanTree code
compressedOutputStringSize dword 0						;size of result of huffmanTree code
decompressedOutputString byte 10000 dup(0)				;the result of decompressed huffman tree
decompressedOutputStringSize dword 0					; size of result of decompressed huffman tree


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


;--------------------------------------------------------------------------
; This data structure to hold huffman tree code  
;	Data will be like
;	FirstDword			SecondDword
;	Key					binaryCode
;--------------------------------------------------------------------------
huffmanTreeCode dword 2048 dup(-1)


;==========================================================================
;==========================================================================
;==========================================================================


.code
main PROC
	
	;CALL compress
	CALL decompress
	
	exit
main ENDP

; ------------------------------------------------------------------------------------------------------------
; Reset All variables
; ------------------------------------------------------------------------------------------------------------
init PROC
	
	mov inputStringSize, 0
	mov outputStringSize, 0
	mov outputStringCharacterSize, 0
	mov priorityQueueSize, 0
	mov characterCount, 0
	mov huffmanTreeSize, 0
	mov bfsArrayHead, 0
	mov bfsArrayTail, 0

	ret
init ENDP


; ------------------------------------------------------------------------------------------------------------
; Compression Function
; ------------------------------------------------------------------------------------------------------------
compress PROC
		
	CALL init
	CALL Read_File
	CALL constructOccurPQ
	CALL constructTree
	CALL bfsTraversal
	CALL Write_File
	CALL getAllHuffmanTreeCode

	ret
compress ENDP


; ------------------------------------------------------------------------------------------------------------
; Decompression
; ------------------------------------------------------------------------------------------------------------
decompress PROC

	CALL init	
	CALL Read_File
	CALL constuctTreeDecompression

	ret
decompress ENDP


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
	
	mov edi, offset huffmanTreeCode
	
	; 0FFFFFFFFh value to check is stack is empty
	mov eax, 0FFFFFFFFh
	push eax
	push eax
	
	; push current code and address of the root
	mov eax,1
	push eax
	push esi
	loopWhileStackNotEmpty:
		pop esi
		pop ecx
		; get left node 
		mov eax, [esi + type huffmanTree]
		; get right node
		mov ebx, [esi + type huffmanTree * 2]

		cmp eax,-1
		jnz getLeftAndRightNode

		; now add code value to our ds
		mov edx, [esi]
		mov [edi], edx
		mov [edi + type huffmanTreeCode], ecx
		add edi, nextValHuffmanTreeCode
		jmp endThisNode

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
	jnz loopWhileStackNotEmpty
	pop eax
	pop ecx
	
	RET
getAllHuffmanTreeCode ENDP


constuctTreeDecompression PROC
	
	mov edx, offset inputString
	call writestring
	call crlf

	mov esi, offset inputString
	mov ecx, inputStringSize
	mov edi, offset characterArray
	getCharacters:
		mov eax, 0
		mov eax, [esi + ecx - 1]
		call writechar
		call crlf
		cmp al, ' '
		
		jz skipChar
		cmp al, 0Ah
		jz endOfLine

		mov ebx, characterCount
		imul ebx, TYPE characterArray
		mov [edi + ebx + TYPE characterArray], eax
		inc characterCount

		skipChar:
	loop getCharacters

	endOfLine:
	sub ecx, 2

	mov ebx, 0
	mov edx, 0
	getTreeNodes:
		mov eax, [esi + edx]
		cmp al, ' '
		jz insertNodeValue
		imul ebx, 10
		and al, 11001111b
		push edx
		movzx edx, al
		mov eax, edx
		pop edx
		add ebx, eax
		jmp skipInsertNode

		insertNodeValue:
		mov eax, ebx
		call writedec
		call crlf
		mov ebx, 0

		skipInsertNode:
		inc edx
	loop getTreeNodes

	ret
constuctTreeDecompression ENDP


;--------------------------------------------------------------------------
; this function convert input string to compress huffman tree code
;--------------------------------------------------------------------------
getCompressedOutputString proc

	mov esi, offset inputString
	mov ecx, inputStringSize
	mov edx, offset compressedOutputString
	loopInInputStringToGetCode:
		; loop in huffman tree code to get code for each character
		mov edi, offset huffmanTreeCode
		sub edi, nextValHuffmanTreeCode
		loopToGetKayOfTreeCode:
			add edi,nextValHuffmanTreeCode
			movzx eax, byte ptr [edi]
			cmp al,[esi]
			jnz loopToGetKayOfTreeCode
		
		; push value in stack to store it in string and remove last one 
		mov eax,[edi + type huffmanTreeCode]
		mov ebx, 3
		push ebx
		getNumberValueFromTreeCode:
			test eax,1
			jnz addOneToStack
			mov ebx,0
			push ebx
			jmp donotAddOneToStack
			addOneToStack:
			mov ebx,1
			push ebx
			donotAddOneToStack:
			shr eax,1
			; remove last one
			cmp eax,1
			jnz getNumberValueFromTreeCode
		
		; get number from stack and add it into string 
		addNumberToOutputString:
			pop eax
			cmp eax, 3
		 	jz endAddNumberToOutputString
			add eax,48
			mov [edx], al
			inc edx
			inc compressedOutputStringSize
			jmp addNumberToOutputString
		
		endAddNumberToOutputString:
			inc esi
			
	loop loopInInputStringToGetCode	

	RET
getCompressedOutputString endp


;--------------------------------------------------------------------------
; this function take huffmanTree and input string and get value of decompressed 
;--------------------------------------------------------------------------


getDecompressedOutputString Proc
	
	; declare values to work with it
	mov edi, offset decompressedOutputString
	mov esi, offset compressedOutputString
	mov eax, huffmanTreeSize
	dec eax
	imul eax, shiftOffset
	add eax, offset huffmanTree
	mov ecx, compressedOutputStringSize
	
	loopInInputStringToGeCharater:
		; left node 
		mov ebx, [eax + type huffmanTree]
		
		; check if this node has value or not
		cmp ebx,-1
		jnz goAddNumberToDecompressedString
			mov ebx,[eax]
			mov [edi],bl
			inc edi
			mov eax, huffmanTreeSize
			dec eax
			imul eax, shiftOffset
			add eax, offset huffmanTree
			cmp ecx,0
			jz endTheLoopInInputStringToGeCharater
			jmp loopInInputStringToGeCharater
			
		cmp ecx,0
		jz endTheLoopInInputStringToGeCharater
			
		goAddNumberToDecompressedString:
			dec ecx
			; 48 here meanning char '0'
			mov edx,48
			cmp [esi],dl
			jnz GoToOneOnDecompressedString
			mov eax,ebx
			imul eax, shiftOffset
			add eax, offset huffmanTree
			inc esi
			jmp loopInInputStringToGeCharater
			
			GoToOneOnDecompressedString:
				; right node
				mov edx, [eax + type huffmanTree * 2]
				mov eax,edx
				imul eax, shiftOffset
				add eax, offset huffmanTree
				inc esi
				jmp loopInInputStringToGeCharater
	
		endTheLoopInInputStringToGeCharater:
		mov edi, offset decompressedOutputString
	
		
	RET
getDecompressedOutputString endp

END main