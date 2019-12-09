INCLUDE Irvine32.inc
INCLUDE macros.inc
BUFFER_SIZE = 5000
BUFFER_SIZE2 = 501
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


;------------------------------------------------------------------------------------------
;
;writeFile
;
;-----------------------------------------------------------------------------------------
buffer2 BYTE BUFFER_SIZE DUP(?)
filename2 BYTE "output.txt",0
fileHandle2 HANDLE ?
stringLength DWORD ?
bytesWritten DWORD ?
str1 BYTE "Cannot create file",0dh,0ah,0
str2 BYTE "Bytes written to file [output.txt]:",0
str3 BYTE "Enter up to 500 characters and press"
	BYTE "[Enter]: ",0dh,0ah,0


;---------------------------------------------------

;--------------------------------------------------------------------------
; TODO write disc readCompressionFile
;compression
;--------------------------------------------------------------------------


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
alphabe byte 2000 dup(?)
alphabetLenght dword 0               ;;;;;;;;;;;;;;; TODO remb

tree DWORD 2000 dup(?)
treeLenght dword 0

nodeCount DWORD -1				 ;;;;;;;;;;;;;;; TODO remb
nodes DWORD 2000 dup(?)
nodesOffset DWORD ?
nodesOffsetCount DWORD ?
ecx_temp1 DWORD ?
zero DWORD 0


;--------------------------------------------------------------------------
; TODO write disc fillData
;--------------------------------------------------------------------------
arrOfNumberOfRepeated DWORD 2000 dup(-1)
arrOfAlphabe DWORD 2000 dup(-1)
arrOfNodesPos DWORD 2000 dup(-1)
arrOfLeftChildren DWORD 2000 dup(-2)
arrOfRightChildren DWORD 2000 dup(-2)

count dword  0 ;for nodes array
count2 dword 0 ;for tree array
count3 dword 0 ;for fill data array(Pis &Rep)
count4 dword 0 ;for number of elem in (arrOfNumberOfRepeated & arrOfNodesPos)
count5 dword 0 ;for fill array (arrOfLeftChildren & arrOfRightChildren)
count6 dword 0 ;for fill array (arrOfAlphabe)



_none dword -1

count_Node dword ?  ; use in( Find_Node_Position  && Get_Node_Position) as counter 




leftCh DWORD ?
leftPos DWORD ?
rightCh DWORD ?
rightPos DWORD ?



;==========================================================================
;==========================================================================
;==========================================================================



;""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Find_Node_Position PROTO  arr_find:PTR DWORd   , type_Array : DWORD ,    arrCount:DWORD  ,    val2:DWORD
Save_Val_IN_Array PROTO   arr_Find:PTR DWORd   , type_Array : DWORD , val_Pos:DWORD , val: DWORD
Get_Val_From_Array PROTO    arr_Find:PTR DWORd   , type_Array : DWORD , val_Pos:DWORD 
;""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

;********************************************************
					;use for test

arr byte 4 dup(?)
arr2 byte "123456789",0
arr3 byte 1,2,3,4,5,6,7,8,9
nu dword ?
test1 byte ?
tt dword 0

;****************************************************
.code
main PROC
	

	;CALL constructOccurPQ
	;CALL constructTree

	;C:\Users\Mahmo\Desktop\prog_3\ass\test.txt
	;call readAllFile

	;call Save_Data_IN_File

	;call readCompressionFile 
	;mov edx , ecx
	;call writeString
	;call crlf


	;mov edx , 12
	;test dl , 00000001b
	;jz _even
	;	call readdec
	;	jmp oodd
	;_even:
	;---------------------------------------------------------------------
	;mov edx , 100
;	call find_x


	;--------------------------------------------------------------------
	call readDecompressionFile
	
	call FillData

	mov ecx , nodeCount 
	inc ecx
	hh:

	INVOKE Get_Val_From_Array , OFFSET arrOfNumberOfRepeated ,type arrOfNumberOfRepeated   , tt
	call writedec
	call crlf
	INVOKE Get_Val_From_Array , OFFSET arrOfNodesPos  ,type arrOfNodesPos    , tt
	call writedec
	call crlf
	;INVOKE Get_Val_From_Array , OFFSET arrOfLeftChildren  ,type arrOfLeftChildren    , tt
	;call writedec
	;call crlf
	INVOKE Get_Val_From_Array , OFFSET arrOfRightChildren  ,type arrOfRightChildren    , tt
	call writedec
	call crlf
		mWrite <"hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh",0dh,0ah>	

	inc tt
	loop hh


	mov edx , offset arrOfNumberOfRepeated
	mov ecx , 10
	Ld:
		mov eax , [edx]
		add edx , 4
		call writedec
		call crlf
	LOOP ld


	oodd:
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
	quit:
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





;------------------------------------------------------------------------------


;--------------------------------------------------------------------------
; TODO write disc
;--------------------------------------------------------------------------
;TOOD edit size buffer2 && Param..
Save_Data_IN_File PROC

	; Create a new text file.
	mov edx,OFFSET filename2
	call CreateOutputFile
	mov fileHandle2,eax


	; Check for errors.
	cmp eax, INVALID_HANDLE_VALUE			; error found?
	jne file_ok								; no: skip
	mov edx,OFFSET str1						; display error
	call WriteString
	jmp end_Save_Data_IN_File
	
	
	file_ok:
	; Ask the user to input a string.
	mov edx,OFFSET str3						; "Enter up to ...."
	call WriteString
	mov ecx,BUFFER_SIZE						; Input a string
	mov edx,OFFSET buffer2
	call ReadString 
	mov stringLength,eax					; counts chars entered


	;Write the buffer2 to the output file.
	mov eax,fileHandle2
	mov edx,OFFSET buffer2
	mov ecx,stringLength
	call WriteToFile
	mov bytesWritten,eax					; save return value
	mov eax , fileHandle2 ;;;;;habd
	call CloseFile


	; Display the return value. 
	mov edx,OFFSET str2						; "Bytes written"
	call WriteString
	mov eax,bytesWritten
	call WriteDec
	call Crlf


	end_Save_Data_IN_File:
		RET
Save_Data_IN_File ENDP
;-----------------------------------------------------------------------------

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
; TODO write disc readAlphabet + save reg + related reg || flag
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




;--------------------------------------------------------------------------
; TODO write disc readAlphabet + save reg + related reg || flag
;--------------------------------------------------------------------------

FillData PROC
	mov ecx , nodeCount
	mov count4 , ecx
	;inc count4
	inc ecx
	mov esi , offset nodes
	INVOKE Save_Val_IN_Array , OFFSET arrOfNumberOfRepeated ,type arrOfNumberOfRepeated   , count3 , [esi]
	INVOKE Save_Val_IN_Array , OFFSET arrOfNodesPos ,type arrOfNodesPos   , count3 , 0
	;inc count3
	;dec count4


	L_N:
	dec ecx

	mov esi , count4
	cmp esi , zero
	je end_FillData
	
	
	;	;add in arrOFNumberOfRepeated
	
	
	INVOKE Get_Val_From_Array , OFFSET arrOfNumberOfRepeated ,type arrOfNumberOfRepeated   , count3
	;cmp eax , _none
	;je end_FillData




	push ecx

	call Get_Child

	pop ecx


	inc count3
	inc ecx
	LOOP L_N


	

	end_FillData:
	RET
fillData ENDP

;------------------------------------------------------


;----------------------------------------------------
Get_Child PROC  uses edx ecx
	;push edx

;	push ecx

	;mov ecx , count2
	;mov ebx ,[eax+ecx*4] 

	inc count2
	INVOKE Get_Val_From_Array , OFFSET tree ,type tree   , count2
	mov ebx , eax


	cmp ebx , zero
	je	leftCh_Zero
	jmp leftCh_Not_Zero
	leftCh_Zero:
		mov leftPos   , -1
		jmp right
		;mov edi , offset arrOfLeftChildren
		;INVOKE Save_Val_IN_Array , OFFSET arrOfLeftChildren ,type arrOfLeftChildren   , count3 , -1


	push eax
	;call Get_Node_Position
	;mov eax , offset nodes
	leftCh_Not_Zero:
		mov leftCh , ebx
		INVOKE   Find_Node_Position , OFFSET nodes, type nodes , nodeCount , ebx
		mov leftPos  , eax
	
	

	pop eax
	mov edi , OFFSET arrOfLeftChildren



	;push ecx
	mov esi , count3
	mov [edi+esi*4] , ebx
	;pop ecx



	
	right:
	inc count2
	;inc ecx 
	INVOKE Get_Val_From_Array , OFFSET tree ,type tree   , count2
	mov ebx , eax

	cmp ebx , zero
	je	rightCh_Zero
	jmp rightCh_Not_Zero
	rightCh_Zero:
		mov rightPos   , -1
		;INVOKE Save_Val_IN_Array , OFFSET arrOfRightChildren ,type arrOfRightChildren   , count3 , -1
		jmp end_Get_Child

	rightCh_Not_Zero:
		mov rightCh , ebx 
		INVOKE   Find_Node_Position , OFFSET nodes, type nodes  , nodeCount , ebx
		mov rightPos  , eax
	;call Get_Node_Position

	;mov edx , OFFSET arrOfRightChildren 

	
	INVOKE Save_Val_IN_Array , OFFSET arrOfRightChildren , type arrOfRightChildren , count5 , rightPos
	INVOKE Get_Val_From_Array , OFFSET arrOfRightChildren ,type arrOfRightChildren   , count5								;for test

	INVOKE Save_Val_IN_Array , OFFSET arrOfLeftChildren  , type arrOfLeftChildren  , count5 , leftPos 
	INVOKE Get_Val_From_Array , OFFSET arrOfLeftChildren ,type arrOfLeftChildren   , count5									;for test

	;;	add  left and right ch to  arrOfNumberOfRepeated  and arrOfNodesPos 
	INVOKE Save_Val_IN_Array , OFFSET arrOfNumberOfRepeated , type arrOfNumberOfRepeated , count5 , leftCh 
	INVOKE Get_Val_From_Array , OFFSET arrOfNumberOfRepeated ,type arrOfNumberOfRepeated   , count5							;for test

	INVOKE Save_Val_IN_Array , OFFSET arrOfNodesPos   , type arrOfNodesPos  , count5 , leftPos 
	INVOKE Get_Val_From_Array , OFFSET arrOfNodesPos ,type arrOfNodesPos   , count5											;for test

	INVOKE Save_Val_IN_Array , OFFSET arrOfNumberOfRepeated , type arrOfNumberOfRepeated , count5 , rightCh 
	INVOKE Get_Val_From_Array , OFFSET arrOfNumberOfRepeated ,type arrOfNumberOfRepeated   , count3							;for test

	INVOKE Save_Val_IN_Array , OFFSET arrOfNodesPos   , type arrOfNodesPos  , count5 , rightPos 
	INVOKE Get_Val_From_Array , OFFSET arrOfNodesPos ,type arrOfNodesPos   , count3											;for test

	sub count4 , 2



	end_Get_Child:
;		pop ecx
;		pop edx
		RET


Get_Child ENDP

;----------------------------------------------------
;Get_Node_Position
;OFFSET arr
;arrCount
;val
;xx PROC uses edx

; how to use uses 
comment !  
find_x PROC  uses edx
	mov edx , 10
RET
find_x ENDP
!
;---------------------------------------------------------

;---------------------------------------------------------
Save_Val_IN_Array PROC  arr_Find:PTR DWORd , type_Array : DWORD , val_Pos:DWORD , val: DWORD 

	push edx
	push esi
	push eax

	mov edx , 0
	mov esi , val_Pos
	mov eax , type_Array
	mul esi

	mov edx , arr_Find
	mov esi , val
	mov [edx+ eax] , esi

	end_Save_Val_IN_Array:
		pop eax
		pop esi
		pop edx
		RET

Save_Val_IN_Array ENDP
;---------------------------------------------------------


;---------------------------------------------------------

Get_Val_From_Array PROC  arr_Find:PTR DWORd , type_Array : DWORD , val_Pos:DWORD

	push edx
	push esi


	mov edx , 0
	mov esi , val_Pos
	mov eax , type_Array
	mul esi
	mov esi , eax

	mov edx , arr_Find
	mov eax , [edx+ esi]

	end_Get_Val_From_Array:
		
		pop esi
		pop edx
		RET

Get_Val_from_Array ENDP

;---------------------------------------------------------








;---------------------------------------------------------


Find_Node_Position PROC  arr_find:PTR DWORd , type_Array : DWORD , arrCount:DWORD , val2 :DWORD 

	push ecx
	push ebx 
	push edx
	push esi
		

		mov count_Node , 0
		mov ecx  , arrCount 
		LL:
			dec ecx
			;use eax as counter try
			mov edx , 0
			mov eax , count_Node
			mov esi , type_Array
			mul esi
			;mov esi , eax
			mov ebx , val2
			mov edx , arr_find
			cmp ebx , [edx+eax] ; TODO USE type of not 4
			je find

			inc count_Node
			;inc ecx
		LOOP LL
		mov eax , -1
		jmp end_Find_Node_Position

	find:
		mov eax , count_Node
		end_Find_Node_Position:
			pop esi
			pop edx	
			pop ebx 
			pop ecx
			RET



		
Find_Node_Position ENDP

;---------------------------------------------------------


;---------------------------------------------------------
 Get_Node_Position PROC
	push ecx
	push eax 
	push edx
		

		mov edx , OFFSET nodes
		mov count_Node , 0
		mov ecx  , nodeCount 
		LL:
			dec ecx
			;use eax as counter try
			mov eax , count_Node
			cmp ebx , [edx+eax*4]
			je find

			inc count_Node
			inc ecx
		LOOP LL
		mov ebx , -1
		jmp end_Get_Node_Position

	find:
		mov ebx , count_Node
		end_Get_Node_Position:
			pop edx	
			pop eax 
			pop ecx
			RET

Get_Node_Position ENDP


;---------------------------------------------------------



;--------------------------------------------
;---------------------------------------------



END main