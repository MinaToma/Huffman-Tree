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

count10 dword 0
count11 dword 0
count12 dword 0
levelCount Dword 0

;--------------------------------------------------------------------------
; string for testing
;--------------------------------------------------------------------------
inputString byte "howare";
inputString2 byte "fffffffffffffffffffffffffffffffffffffffffffffccccccccccccdddddddddddddeeeeeeeeeeeeeeeeaaaaabbbbbbbbb"

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
_countendl word 0
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
nodesOffsetCount DWORD ?




;--------------------------------------------------------------------------
; TODO write disc fillData
;--------------------------------------------------------------------------
arrOfNumberOfRepeated DWORD 2000 dup(-1)
arrOfAlphabe DWORD 2000 dup(-1)
arrOfNodesPos DWORD 2000 dup(-1)
arrOfLeftChildren DWORD 2000 dup(-1)
arrOfRightChildren DWORD 2000 dup(-1)
arrTypeOfNode Dword 2000 dup(-2)

arrCode_Node Dword 2000 dup(00000000000000000000000000000000b)
arrLevelOfNode Dword 2000 dup(-2)	
arrNumberOfNodesInLevel dword 2000 dup(0)
sizeArrNumberOfNodesInLevel dword 0
countNodeInLevel dword 1

count dword  0 ;for nodes array
count2 dword 0 ;for tree array
count3 dword 0 ;for fill data array(Pis &Rep)
count4 dword 0 ;for number of elem in (arrOfNumberOfRepeated & arrOfNodesPos)
count5 dword 0 ;for fill array (arrOfLeftChildren & arrOfRightChildren)
count6 dword 0 ;for fill array (arrOfAlphabe)


count_Node dword ?  ; use in( Find_Node_Position  && Get_Node_Position) as counter 




leftCh DWORD ?
leftPos DWORD ?
rightCh DWORD ?
rightPos DWORD ?
nodeCode Dword ?
nodeLevel Dword ?
count7 dword 0 ; use to cal # of levels
count8 dword 0 ; use to cal # of levels
count9 dword 0 ; use to cal # of levels




;==========================================================================

lengthOfDecompressionString Dword 0

;==========================================================================
treeString byte 50000 dup(?)
alphabeString byte 50000 dup(?)
;==========================================================================
positionNode dword 0

test1 byte ?


;""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Find_Node_Position PROTO  arr_find:PTR DWORd   , type_Array : DWORD ,    arrCount:DWORD  ,    val2:DWORD
Save_Val_IN_Array PROTO   arr_Find:PTR DWORd   , type_Array : DWORD , val_Pos:DWORD , val: DWORD
Get_Val_From_Array PROTO    arr_Find:PTR DWORd   , type_Array : DWORD , val_Pos:DWORD 
Set_Type_Node PROTO   leftChild : DWORD , rightChild:DWORD  
Decompression_String PROTO decompressionString:PTR Byte , compressionString :PTR Byte , lengthOfCompressionString :DWORD 
Shift_Left_ArrCode_Node PROTO arrayCodeNode : PTR Dword , arrayLevelOfNode : PTR DWord , lengthOfArr : Dword 
sortArray PROTO offsetOfArray : PTR DWord , sizeOfArray : Dword , PQ : Byte
set_Leveel_Code PROTO  offsetOfTree : PTR Dword , typeOfTree : Dword , sizeOfTree : Dword , offsetOfArrLevelOfNode : PTR Dword , typeOfArrLevel : Dword , offsetOfArrCode_Node : PTR Dword , typeOfArrCode_Node : Dword
calculateNumberOfNodesInLevel PROTO sizeOfArrLevelOfNode : Dword

;""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

.code
main PROC


	
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
	
	mov ecx, lengthof inputString2
	mov esi, offset inputString2
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
		
		
		mov eax, [esi ]
		
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
constructTree PROC uses ecx
	
	
	INVOKE sortArray , OFFSET priorityQueue , priorityQueueSize , 1
	


	mov esi , priorityQueueSize
	mov count11 , esi
	pqSizeNotOne:
		
		;-----------------
		; First Node
		;-----------------
		mov esi, offset priorityQueue
		mov edi , offset huffmanTree
		mov ecx , huffmanTreeSize
		
		
		
		mov edx , 0
		mov eax , 12
		mul ecx
		mov ecx , eax

		mov edx , 0
		mov eax , 12
		mul count12
		mov edx , eax

		mov ebx, [esi + edx]
		mov eax, [esi + edx + 8]
		mov [edi + ecx + type huffmanTree], eax				;set left child
		add edx , shiftOffset
		
		;-----------------
		; Second Node
		;-----------------
		add ebx, [esi + edx ]
		mov eax, [esi + edx + type priorityQueue * 2]
		;mov [edi + type huffmanTree * 2], eax			;set right child
		mov [edi + ecx + type huffmanTree * 2], eax				;set right child

		mov [edi + ecx ], ebx									;set value

		add edi, shiftOffset
		CALL reSortPQ

		cmp count11, 1
		jnz pqSizeNotOne

	INVOKE sortArray , OFFSET huffmanTree , huffmanTreeSize , 0

		RET
constructTree ENDP


;--------------------------------------------------------------------------
; sorts prioirityQueue Array
; uses priorityQueueSize
;--------------------------------------------------------------------------

sortArray PROC offsetOfArray : PTR DWord , sizeOfArray : Dword , PQ : byte

	
	mov esi,offsetOfArray
	mov ecx, sizeOfArray
	
	oLoop:

		push ecx 

		mov ecx, sizeOfArray
		dec ecx

		iLoop:

			mov eax, [esi]
			mov edi , [esi + type priorityQueue * 3]
			cmp eax, [esi + type priorityQueue * 3]
			jbe _continue

			xchg eax, [esi + type priorityQueue * 3]
			mov [esi], eax

				;call writeint
				;call crlf

			mov eax , [esi + type priorityQueue]
			xchg eax, [esi + type priorityQueue * 4]
			mov[esi + type priorityQueue], eax

				;call writechar
				;call writeint
				;call crlf
				cmp PQ , 1
				je _continue
			mov eax , [esi + type priorityQueue  * 2]
			xchg eax, [esi + type priorityQueue * 5]
			mov[esi + type priorityQueue * 2], eax

				;call writeint
				;call crlf

			_continue:

			add esi, shiftOffset
		loop iLoop

		mov esi, offsetOfArray
		pop ecx
	loop oLoop

	RET
sortArray ENDP


;--------------------------------------------------------------------------
; removes first two elements and inserts new value (their sum)
; decreases prioirityQueueSize
;--------------------------------------------------------------------------
reSortPQ PROC uses edx edi

	mov esi, offset priorityQueue
	
	mov edi , count10   
	mov ebx, [esi + edi]
	add count10 , 12
	mov edi , count10  
	add ebx, [esi + edi]
	add count10 , 12

	mov edi , priorityQueueSize
	mov edx , 0
	mov eax , 12
	mul edi
	mov edi , eax
	

	mov [esi + edi ], ebx
	add edi , 4
	mov [esi + edi ] , ebx
	;mov eax, huffmanTreeSize
	mov eax , priorityQueueSize
	add edi , 4
	mov [esi + edi] , eax


	
	mov esi, offset priorityQueue

	inc priorityQueueSize
	inc huffmanTreeSize
	;call sortPQ
	INVOKE sortArray , OFFSET priorityQueue , priorityQueueSize , 1
		
	

	;dec priorityQueueSize
	dec count11
	add count12 , 2

	RET
reSortPQ ENDP

;--------------------------------------------------------------------------

set_Leveel_Code PROC  offsetOfTree : PTR Dword , typeOfTree : Dword , sizeOfTree : Dword , offsetOfArrLevelOfNode : PTR Dword , typeOfArrLevel : Dword , offsetOfArrCode_Node : PTR Dword , typeOfArrCode_Node : Dword

	mov esi , offsetOfTree
	mov ecx , sizeOfTree
	mov eax , ecx
	dec eax
	INVOKE Save_Val_IN_Array , offsetOfArrCode_Node  , typeOfArrCode_Node , eax , 0
	INVOKE Save_Val_IN_Array , offsetOfArrLevelOfNode , typeOfArrLevel , eax , 0


	
	L_L:
		dec ecx

		mov edx , 0
		mov eax , 12
		mul ecx
		mov edi , eax
		INVOKE Get_Val_From_Array , offset arrLevelOfNode , type arrLevelOfNode  , ecx
		mov nodeLevel , eax 
		inc nodeLevel
	
		mov eax , [esi +edi + 4]
		cmp eax  , -1
		je skip_L_L
		INVOKE Save_Val_IN_Array , offsetOfArrLevelOfNode ,typeOfArrLevel  , [esi +edi + 4] , nodeLevel		; set level left Node
		INVOKE Save_Val_IN_Array , offsetOfArrLevelOfNode , typeOfArrLevel  , [esi + edi + 8]  , nodeLevel		; set level left Node

		skip_L_L:
			inc ecx
	LOOP L_L


	INVOKE calculateNumberOfNodesInLevel , sizeOfTree

	mov esi , offset huffmanTree
	mov ecx , sizeOfTree
	L_C :
			dec ecx
			mov edx , 0
			mov eax , 12
			mul ecx
			mov edi , eax

			INVOKE Get_Val_From_Array , offsetOfArrCode_Node   , typeOfArrCode_Node , ecx
			mov nodeCode , eax
			shl nodeCode , 1
			shl eax , 1
			mov ebx , [esi+edi]
			mov ebx , [esi +edi + 4]
			cmp ebx  , -1
			je skip_L_C

			INVOKE Save_Val_IN_Array , offsetOfArrCode_Node  , typeOfArrCode_Node , [esi +edi + 4] , nodeCode		; set level left Node
			or al , 00000001b
			mov nodeCode , eax
			INVOKE Save_Val_IN_Array , offsetOfArrCode_Node  , typeOfArrCode_Node , [esi + edi + 8]  , nodeCode		; set level left Node
			skip_L_C:
			;add esi , 12
			inc ecx
	LOOP L_C 

	
	mov ecx , sizeOfTree
	dec ecx
	INVOKE Shift_Left_ArrCode_Node , offset arrCode_Node  , offset arrLevelOfNode ,ecx 
	
	

	RET
set_Leveel_Code ENDP

;--------------------------------------------------------------------------

;--------------------------------------------------------------------------
; TODO write disc
;--------------------------------------------------------------------------

readAllFile PROC ;fileName :PTR Byte , sizeOfFileName :PTR Byte , lengthOfCompressionString :DWORD 


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
			mWrite <"Buffer:",0dh,0ah,0dh,0ah>				
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
comment &
Set_Header_File PROC

	mov count7 , 0
	;mov edx , 0
	;mov eax , 12
	;mul huffmanTreeSize
	;sub eax , 12
	
	;mov eax , huffmanTreeSize
	;dec eax		;eax==> 0 base index 
	mov edi , offset treeString 
	mov esi , offset arrNumberOfNodesInLevel 
	mov ecx , sizeArrNumberOfNodesInLevel

	mov edx , offset huffmanTree
	;offset left  edx + 4
	;offset right edx+8
	; type = shiftOffset

	;INVOKE Save_Val_IN_Array , OFFSET arrOfAlphabe  , type arrOfAlphabe  , count5 , ebx
	;INVOKE Get_Val_From_Array , OFFSET arrOfNumberOfRepeated ,type arrOfNumberOfRepeated   , count5

		mov eax , huffmanTreeSize
		dec eax	
		INVOKE Get_Val_From_Array , edx  , shiftOffset , eax
		INVOKE Save_Val_IN_Array , OFFSET tree   , type tree   , 0 , eax
	L_L:
		push ecx
		mov ebx , sizeArrNumberOfNodesInLevel
		sub ebx , ecx
		mov ecx , [esi + ebx ]
		mov levelSize , ecx
	

			

		L_N_L:
			

				
			;inc count7
		LOOP L_N_L
		add edi , levelSize * 4

		pop ecx
	LOOP L_L

RET
Set_Header_File ENDP
&
;--------------------------------------------------------------------------
; TODO write disc
;--------------------------------------------------------------------------

comment &
readCompressionFile PROC


	call readAllFile
	;TODO remove this line (they use the offser of buffer) || creating new string
	mov ecx,OFFSET buffer
	

	RET
readCompressionFile ENDP
&

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
		cmp eax , 0
		je skip
		inc nodeCount
		push ecx
		mov ecx , nodesOffsetCount 
		mov [ecx] , eax
		add ecx , 4
		mov nodesOffsetCount , ecx
		pop ecx

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
	
	inc ecx
	mov esi , offset nodes
	INVOKE Save_Val_IN_Array , OFFSET arrOfNumberOfRepeated ,type arrOfNumberOfRepeated   , count3 , [esi]
	INVOKE Save_Val_IN_Array , OFFSET arrOfNodesPos ,type arrOfNodesPos   , count3 , 0
	cmp nodeCount , 1
	jne Skip_FillData
	mov esi , offset alphabe 
	INVOKE Save_Val_IN_Array , OFFSET arrOfAlphabe  ,type arrOfAlphabe    , count3 , [esi]
	INVOKE Save_Val_IN_Array , OFFSET arrOfLeftChildren   ,type arrOfLeftChildren     , count3 , -1
	INVOKE Save_Val_IN_Array , OFFSET arrOfRightChildren   ,type arrOfRightChildren     , count3 , -1
	INVOKE Save_Val_IN_Array , OFFSET arrTypeOfNode  ,type arrTypeOfNode    , count3 , 108
	INVOKE Save_Val_IN_Array , OFFSET arrCode_Node   ,type arrCode_Node     , count3 , 0
	
	jmp end_FillData
	;inc count3
	;dec count4

	Skip_FillData:
		mov count7  , 0
		inc levelCount  
		mov count8 , 0
		mov count9 , 1
		L_N:
		dec ecx

		mov esi , treeLenght
		cmp count2 , esi 
		je end_FillData
	
	
		INVOKE Get_Val_From_Array , OFFSET arrOfNumberOfRepeated ,type arrOfNumberOfRepeated   , count3
		
		push ecx
		call Get_Child
		pop ecx
		inc count3
		inc ecx
		LOOP L_N
	end_FillData:
		INVOKE Shift_Left_ArrCode_Node , offset arrCode_Node  , offset arrLevelOfNode , nodeCount 
		RET
fillData ENDP

;------------------------------------------------------


;----------------------------------------------------
Get_Child PROC  uses edx ecx
	inc count2
	
	INVOKE Get_Val_From_Array , OFFSET tree ,type tree   , count2
	mov ebx , eax
	cmp ebx , 0
	jne leftCh_Not_Zero
	;je	leftCh_Zero
	leftCh_Zero:
		mov leftPos   , -1
	leftCh_Not_Zero:
		mov leftCh , ebx
		INVOKE   Find_Node_Position , OFFSET nodes, type nodes , nodeCount , ebx
		mov leftPos  , eax
		mov esi , nodeCount 
		sub esi , count4
		inc esi
		;;	add  left  ch to  arrOfNumberOfRepeated  and arrOfNodesPos 
		INVOKE Save_Val_IN_Array , OFFSET arrOfNumberOfRepeated , type arrOfNumberOfRepeated , esi , leftCh 
		INVOKE Save_Val_IN_Array , OFFSET arrOfNodesPos   , type arrOfNodesPos  , esi , leftPos 
		INVOKE Get_Val_From_Array , OFFSET arrCode_Node  ,type arrCode_Node    , count3
		shl eax , 1
		INVOKE Save_Val_IN_Array , OFFSET arrCode_Node ,type arrCode_Node   , esi , eax
				mov eax , 20000
		INVOKE Get_Val_From_Array , OFFSET arrCode_Node  ,type arrCode_Node    , esi
				
		dec count4
	right:
	inc count2
	
	
	INVOKE Get_Val_From_Array , OFFSET tree ,type tree   , count2
	mov ebx , eax

	cmp ebx , zero
	je	rightCh_Zero
	jmp rightCh_Not_Zero
	rightCh_Zero:
		mov rightPos   , -1
		jmp skip

	rightCh_Not_Zero:
		mov rightCh , ebx 
		INVOKE   Find_Node_Position , OFFSET nodes, type nodes  , nodeCount , ebx
		mov rightPos  , eax


		mov esi , nodeCount 
		sub esi , count4
		inc esi

		INVOKE Save_Val_IN_Array , OFFSET arrOfNumberOfRepeated , type arrOfNumberOfRepeated , esi , rightCh 
		
		INVOKE Save_Val_IN_Array , OFFSET arrOfNodesPos   , type arrOfNodesPos  , esi , rightPos 
		
	
		INVOKE Get_Val_From_Array , OFFSET arrCode_Node  ,type arrCode_Node    , count3
		shl eax , 1
		or al , 00000001b
		INVOKE Save_Val_IN_Array , OFFSET arrCode_Node ,type arrCode_Node   , esi , eax
		mov eax , 20000
		INVOKE Get_Val_From_Array , OFFSET arrCode_Node  ,type arrCode_Node    , esi

		dec count4

	skip:

	INVOKE Save_Val_IN_Array , OFFSET arrOfRightChildren , type arrOfRightChildren , count5 , rightPos
	
	INVOKE Save_Val_IN_Array , OFFSET arrOfLeftChildren  , type arrOfLeftChildren  , count5 , leftPos 
	INVOKE Set_Type_Node, leftPos , rightPos
	inc count5
	end_Get_Child:
		RET
Get_Child ENDP
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
		inc ecx
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
			inc ecx
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
 Get_Node_Position PROC uses ecx eax edx
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
	
			RET

Get_Node_Position ENDP
;---------------------------------------------------------


;---------------------------------------------------------
Set_Type_Node PROC   leftChild : DWORD , rightChild:DWORD  

	push eax  
	push edi
	push ebx
	mov edi ,  offset alphabe 	
	
	cmp leftChild , -1
	jne not_Leaf_Node
	cmp rightChild , -1
	jne not_Leaf_Node 
	mov al , 'l'
	add edi , count6
	mov bl , [edi]
	movzx ebx , bl
	INVOKE Save_Val_IN_Array , OFFSET arrOfAlphabe  , type arrOfAlphabe  , count5 , ebx
	inc count6

	INVOKE Save_Val_IN_Array , OFFSET arrLevelOfNode  ,type arrLevelOfNode    , count5 , count7
	dec count9
	jmp skip_Set_Type_Node
		
	not_Leaf_Node:
		INVOKE Save_Val_IN_Array , OFFSET arrLevelOfNode  ,type arrLevelOfNode    , count5 , count7
		add count8 , 2
		dec count9

		mov al , 'p'
		push eax
		INVOKE Get_Val_From_Array , OFFSET arrOfNumberOfRepeated ,type arrOfNumberOfRepeated   , count5

		INVOKE Save_Val_IN_Array , OFFSET arrOfAlphabe  , type arrOfAlphabe  , count5 , eax
		pop eax


	skip_Set_Type_Node:
		cmp count9 , 0
		jne end_Set_Type_Node
		mov esi , count8
		mov count9 , esi
		mov count8 , 0
		inc count7

		
	end_Set_Type_Node:
		movzx eax , al
		INVOKE Save_Val_IN_Array , OFFSET arrTypeOfNode , type arrTypeOfNode , count5 , eax

		
			pop ebx 
			pop edi
			pop eax
			RET
Set_Type_Node ENDP
;-----------------------------------------------------------------

;-----------------------------------------------------------------
Decompression_String PROC decompressionString:PTR Byte , compressionString :PTR Byte , lengthOfCompressionString :DWORD 
	
	push esi 
	push edx
	push ecx
	push ebx
	mov esi , decompressionString
	mov edx , compressionString
	mov ecx , lengthOfCompressionString
	r:
	mov bl , [edx]
	push ecx
	mov ecx , 8 
	o:
		shl bl , 1
		;call dumpRegs
		call Set_Decompression_String
	loop o
	inc edx
	pop ecx
	loop r
	
	pop ebx
	pop ecx
	pop edx
	pop esi 
	RET
Decompression_String ENDP
;-----------------------------------------------------------------

;---------------------------------------------
	Set_Decompression_String PROC
		
		jc right
		left:
			INVOKE Get_Val_From_Array , OFFSET arrOfLeftChildren   ,type arrOfLeftChildren     , positionNode
			mov positionNode , eax

			jmp _ee

		right:
			INVOKE Get_Val_From_Array , OFFSET arrOfRightChildren   ,type arrOfRightChildren     , positionNode
			mov positionNode , eax

			_ee:
			
			INVOKE Get_Val_From_Array , OFFSET arrTypeOfNode   ,type arrTypeOfNode     , positionNode
			cmp eax , 108
			jne end_Set_Decompression_String
			INVOKE Get_Val_From_Array , OFFSET arrOfAlphabe     ,type arrOfAlphabe       , positionNode
			;call writechar
			mov [esi] , al
			inc	lengthOfDecompressionString
			inc esi
			mov positionNode , 0
			end_Set_Decompression_String:
				RET
	Set_Decompression_String ENDP
;---------------------------------------------
comment $
Compression_String PROC offsetOfDecompressionString : PTR byte , sizeOfDecompressionString : Dword , offsetOfArrCode : PTR Dword , offsetOfArrLevel : PTR Dword , treeSize : Dword
		mov ecx , sizeOfDecompressionString
		L_CH:
			


		LOOP L_CH

RET
Compression_String ENDP
$
;-----------------------------------------------

Shift_Left_ArrCode_Node PROC arrayCodeNode : PTR Dword , arrayLevelOfNode : PTR DWord , lengthOfArr : Dword

	push ebx
	push ecx
	push edx
	push esi
	mov ecx , lengthOfArr
	mov edx , arrayCodeNode
	mov ebx , arrayLevelOfNode
	call crlf
	
	Lo:
		push ecx	
		mov ecx , [ebx]

		mov esi , [edx]
		;inc ecx
		cmp ecx , 0
		je skip
		LLO:
			RCR esi , 1
			
		loop LLO
		skip:
		call crlf
				
		mov [edx] , esi
		add edx , 4 
		add ebx , 4
		pop ecx

	Loop Lo
	pop esi
	pop edx
	pop ecx
	pop ebx

	RET
Shift_Left_ArrCode_Node ENDP

;-----------------------------------------------

calculateNumberOfNodesInLevel PROC sizeOfArrLevelOfNode : Dword
	push esi 
	push edx
	push ecx
	push eax


	mov esi , offset arrNumberOfNodesInLevel 
	mov edx , offset arrLevelOfNode 
	mov ecx , sizeOfArrLevelOfNode
	
	l:
		dec ecx
		mov eax , [edx + ecx * type arrLevelOfNode   ]
		cmp eax , [edx + ecx * type arrLevelOfNode  - type arrLevelOfNode ]
		je _equal
		mov edi , sizeArrNumberOfNodesInLevel 
		mov eax , countNodeInLevel
		mov [esi + edi * type arrNumberOfNodesInLevel ] , eax
		call writedec
		call crlf
		mov countNodeInLevel , 1
		mov eax , sizeArrNumberOfNodesInLevel
		inc sizeArrNumberOfNodesInLevel
		call writedec
		call crlf
		call crlf
		jmp end_Loop
		_equal :
		inc countNodeInLevel 
		end_Loop:
		inc ecx
	LOOP l
	pop eax
	pop ecx 
	pop edx
	pop esi 
RET
calculateNumberOfNodesInLevel ENDP

END main