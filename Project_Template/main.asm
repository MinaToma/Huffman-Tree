INCLUDE Irvine32.inc
INCLUDE macros.inc
BUFFER_SIZE = 5000
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
; TODO write disc readAllFile
;--------------------------------------------------------------------------


buffer BYTE BUFFER_SIZE DUP(?)
filename BYTE 80 DUP(0)
fileSize DWORD ?
fileHandle HANDLE ?
numberOfChar DWORD ?
;--------------------------------------------------------------------------
; TODO write disc readCompressionFile
;compression
;--------------------------------------------------------------------------
alphabe byte 2000 dup(?)
alphabetLenght dword 0

tree DWORD 2000 dup(?)
treeLenght dword 0

nodeCount DWORD -1
nodes DWORD 2000 dup(?)
nodesOffset DWORD ?
nodesOffsetCount DWORD ?
ecx_temp1 DWORD ?
zero DWORD 0

;--------------------------------------------------------------------------
; TODO write disc readheader
;compression
;--------------------------------------------------------------------------
_space byte 32
_endl1 byte 13
_endl2 byte 10
_countendl word 0
_one word 1
_countCharLenght DWORD 0

;--------------------------------------------------------------------------
; TODO write disc readdDecompressionFile
;--------------------------------------------------------------------------

;==========================================================================
;==========================================================================
;==========================================================================


arr byte 4 dup(?)
arr2 byte "123456789",0
arr3 byte 1,2,3,4,5,6,7,8,9
nu dword ?
test1 byte ?

.code
main PROC
	
	;CALL constructOccurPQ
	;CALL constructTree

	;C:\Users\Mahmo\Desktop\prog_3\ass\test.tx
	;call readAllFile

	;call readCompressionFile 
	;mov edx , ecx
	;call writeString
	;call crlf


	call readDecompressionFile

	mov ecx , treeLenght

	mov edx , offset tree
	lll:
	mov  eax , [edx]
	add edx , 4
	call writedec
	call crlf
	LOOP lll

	mov ecx , alphabetlenght
	mov edx , offset alphabe
	ll2:
	mov al , [edx]
	call writechar
	inc edx
	LOOP ll2


	mov ecx , nodeCount
	inc ecx
	;call readint
	mov edx , offset nodes
	ll3:
	mov  eax , [edx]
	add edx , 4
	call writedec
	call crlf
	loop ll3
			;nodeCount	10	unsigned long

	
	;mov ecx , fileSize
	;mov al  , 'w'
	;mov ah , 19
	;cmp al , ah
	;je testt

	;mov eax , 0
	;l1:
	;mov al , [edx]
	;call writechar
	;inc edx
	;loop l1
	;testt:
	;mov eax , 5
	;call readdec


	mov bl ,1
	movzx ebx , bl


	mov ecx , 9
LL:
	mov edx , offset arr2
	;shl eax,4
	;call writedec
	;mov nu , eax
	;rol eax , 16
	mov  eax , dword ptr  [edx]
	and al , 11001111b
	and ah , 11001111b
	;or eax , 00110000b
	inc edx
	LOOP LL
	call dumpRegs


	mov ecx , 4
	mov edx , offset arr
	lx:
	call readchar
	call writechar
	mov [edx] , al
	inc edx
	

	LOOP lx

	mov edx , offset arr2



	mov bl , 2
	mov dl , 2

	mov eax , 0
	or al , bl
	shl eax , 4
	or al , dl
	shl eax , 4


	mov ecx , 3
	mov edx , offset  arr
	mov al , 1
	mov ah , 2
	

	mov eax , 0
	l3:
	mov bl , 	_space
	cmp [edx] , bl
	jne not_space
	;jmp  
	not_space:
		or al , [edx]
		shl eax , 4
		jmp l3



	
	
	mWrite <"yes",0dh,0ah>	
	l2:
		call readchar
		call writechar
		mov [edx] , al
		inc edx
	loop l2
	mov eax , offset  arr
	call writedec
	mov  eax , offset  arr
	call writedec
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
; TODO write disc
;--------------------------------------------------------------------------

readAllFile PROC

	; Let user input a filename.
	mWrite "Enter an input filename: "
	mov edx,OFFSET filename
	mov ecx,SIZEOF filename
	call ReadString		


	; Open the file for input.
	mov edx,OFFSET filename
	call OpenInputFile
	mov fileHandle,eax
	
	
	; Check for errors.
	cmp eax,INVALID_HANDLE_VALUE			 ; error opening file?
	jne file_ok								 ; no: skip
	mWrite <"Cannot open file",0dh,0ah>
	jmp quit



	; Read the file into a buffer.
	file_ok:
		mov edx,OFFSET buffer
		mov ecx,BUFFER_SIZE
		call ReadFromFile
		jnc check_buffer_size
		mWrite "Error reading file. "
		call WriteWindowsMsg
		jmp close_file


		check_buffer_size:
			cmp eax,BUFFER_SIZE
			jb buf_size_ok
			mWrite <"Error: Buffer too small for the file",0dh,0ah>
			jmp quit

		buf_size_ok:
			
			mov buffer[eax],0
			mWrite "File size: "
			call WriteDec
			mov fileSize , eax
			call Crlf
			;To Display
			mWrite <"Buffer:",0dh,0ah,0dh,0ah>					;TODO SER 0dh,0ah,0dh,0ah
			mov edx,OFFSET buffer
			call WriteString
			call Crlf

		close_file:
			mov eax,fileHandle
			call CloseFile
		quit:
			RET
readAllFile ENDP




;--------------------------------------------------------------------------
; TODO write disc
;--------------------------------------------------------------------------


readCompressionFile PROC


	call readAllFile
	;TODO remove this line (they use the offser of buffer) || creating new string
	mov ecx,OFFSET buffer
	

	RET
readCompressionFile ENDP


;--------------------------------------------------------------------------
; TODO write disc
;--------------------------------------------------------------------------
readDecompressionFile PROC
	

	call readAllFile
	mov ebx , fileSize
	mov numberOfChar , ebx
	;sub numberOfChar , 4
	mov eax , 0
	mov edx , OFFSET buffer
	mov ecx , OFFSET nodes
	;mov nodesOffset , ecx
	mov nodesOffsetCount , ecx 
	mov ecx , OFFSET tree
	l3:
		mov bl , 	_endl1
		cmp [edx] , bl
		je new_Line
		;cmp _countCharLenght , numberOfChar                ;TODO handel this test case
		;je end_readAlphabet
		mov bl , 	_space
		cmp [edx] , bl
		jne add_to_tree      
		inc edx
		inc _countCharLenght


		mov   [ecx] , eax
		add  ecx  , 4
		add treeLenght , 1
		cmp eax , zero
		je skip
		inc nodeCount
		push ecx
		mov ecx , nodesOffsetCount 
		mov [ecx] , eax
		add ecx , 4
		mov nodesOffsetCount , ecx
		pop ecx


		;call writedec						; TODO push eax on the tree
		;call crlf

		skip:
			mov eax , 0
			jmp l3
		new_Line:
			sub numberOfChar , 2
			inc _countendl
			add edx , 2
			
			;sub ecx , 2
			mov bx, _one
			cmp _countendl , bx
			jne end_ReadDecompressionFile
			inc treeLenght
			mov ebx , treeLenght
			push ebx
			

			call readAlphabet
			pop ebx 
			mov treeLenght , ebx


			jmp end_ReadDecompressionFile

		add_to_tree:                   
			
			
			mov  bl ,  [edx]
			and bl , 11001111b
			movzx ebx , bl
			push edx
			push ebx
			mov edx , 0
			mov ebx , 10
			mul ebx
			pop ebx                    ; TODO check cf
			add eax , ebx 
			pop edx

			;or al , [edx]
			;shl eax , 4
			inc edx 
			inc _countCharLenght
			jmp l3

	


	end_ReadDecompressionFile:
		RET
readDecompressionFile ENDP


;--------------------------------------------------------------------------
; TODO write disc readAlphabet + save reg
;--------------------------------------------------------------------------


readAlphabet PROC

	
	mov ecx , OFFSET alphabe
	l5:
		mov bl , [edx]
		mov test1 , bl
		mov bl , 	_endl1
		cmp [edx] , bl
		je end_readAlphabet
		mov ebx , numberOfChar
		;add ebx , 1
		cmp _countCharLenght , ebx
		jae end_readAlphabet
		mov bl , 	_space
		cmp [edx] , bl
		jne  add_Alphabet
		inc edx
		inc _countCharLenght
		jmp l5
		add_Alphabet:
			mov bl ,   [edx] 
			mov [ecx] , bl 

			inc edx
			inc ecx
			inc _countCharLenght
			inc alphabetLenght
			jmp l5
	
	end_readAlphabet:
		sub numberOfChar , 2
		RET
readAlphabet ENDP


END main