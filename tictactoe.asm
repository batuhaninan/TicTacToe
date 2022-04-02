.data
	
	# Data
	
	# ENUM 9, 9, 9, 9, 9, 9, 9, 9, 9
	# 9 = NULL
	# 0 = X
	# 1 = O
	
	array: .word 9, 9, 9, 9, 9, 9, 9, 9, 9
	
	# Variables
	row: .word 0
    column: .word 0
    arrayIndex: .word 0
    
    currentSymbol: .word 1
    
    shouldExit: .word 0
	 
	 
	u: .asciiz "?"
	x: .asciiz "X"
	o: .asciiz "O"
	 
	# Prompts
	newline: .asciiz "\n"
    space: .asciiz " "
    
    winPromptX: .asciiz "X wins!"
    winPromptO: .asciiz "O wins!"
    inputPromptRow: .asciiz "Please select row (1-2-3)\n>>> "
	inputPromptColumn: .asciiz "Please select column (1-2-3)\n>>> "
	currentSymbolPromptX: .asciiz "Current Turn: X"
    currentSymbolPromptO: .asciiz "Current Turn: O"
    sameSymbolPrompt: .asciiz "Please choose another row-column!"
    	
 
.text
main:
	

	mainLoop:
		jal printTable
    	jal printNewLine
    	
    	jal printCurrentSymbol
    	jal printNewLine
    	    	
		jal getInputRow
		jal getInputColumn
	
		jal calculateArrayIndexByRowColumn
    	
		jal calculateElementAddressByIndex
		
		jal validateInput
		
    	#jal getElementByIndex
    	
    	jal checkExitConditions
    	
    	lw $a0, shouldExit
    	li $a1, 1
    	beq $a0, $a1, nextSymbolL
    	nextSymbolR:

    	j mainLoop
    


sameSymbolError:
	
	la $a0, sameSymbolPrompt
	jal printStr
	jal printStr
	jal printNewLine
	
	j sameSymbolErrorR
	

nextSymbolL:
	jal nextSymbol
	j nextSymbolR

nextSymbol:
	addi, $sp, $sp, -4
    sw $ra, 0($sp)

	lw $a0, currentSymbol
	
	slti $t0, $a0, 1
	sw $t0, currentSymbol
	
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra


storeSymbol:
	li $s7, 1
	sw $s7, shouldExit
	lw $a0, currentSymbol
	sw $a0, 0($v0)
	j storeSymbolR
	

validateInput:
	addi, $sp, $sp, -4
    sw $ra, 0($sp)

	jal getElementByIndex
	
	li $s7, 0
	sw $s7, shouldExit
	
	move $a3, $v1
	
	lw $t1, currentSymbol
	
	li $s6, 9

	beq $a3, $s6, storeSymbol
	storeSymbolR:
    
    bne $a3, $s6, sameSymbolError
	sameSymbolErrorR:
	
	
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

promptWinMessageX:
	jal printTable
	la $a0, winPromptX
	jal printStr
	
	j exit


promptWinMessageO:
	jal printTable
	la $a0, winPromptO
	jal printStr
	
	j exit
	
promptWinMessage:
	lw $t0, currentSymbol
	li $t1, 0
	li $t2, 1

	beq $t0, $t1, promptWinMessageX
	beq $t0, $t2, promptWinMessageO


checkAndExit:
	addi, $sp, $sp, -4
    sw $ra, 0($sp)

	add $s0, $a0, $a1
	add $s0, $s0, $a2
	
	li $s1, 27
	
	bne $s0, $s1, promptWinMessage
	
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra


threeVariableCheck:
	addi, $sp, $sp, -4
    sw $ra, 0($sp)

	seq $t1, $a0, $a1
	seq $t6, $a1, $a2
	and $t1, $t1, $t6
	li $t6, 1
	beq $t1, $t6, checkAndExit
	
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra


checkExitConditions:
	addi, $sp, $sp, -4
    sw $ra, 0($sp)

	
	la $t0, array
		
	# Horizontal
	lw $a0, 0($t0)
	lw $a1, 4($t0)
	lw $a2, 8($t0)
	
	jal threeVariableCheck
		
	lw $a0, 12($t0)
	lw $a1, 16($t0)
	lw $a2, 20($t0)

	jal threeVariableCheck
		
	lw $a0, 24($t0)
	lw $a1, 28($t0)
	lw $a2, 32($t0)
	
	jal threeVariableCheck
	
	# Vertical
	lw $a0, 0($t0)
	lw $a1, 12($t0)
	lw $a2, 24($t0)
	
	jal threeVariableCheck
	
	lw $a0, 4($t0)
	lw $a1, 16($t0)
	lw $a2, 20($t0)
	
	jal threeVariableCheck
	
	lw $a0, 8($t0)
	lw $a1, 20($t0)
	lw $a2, 32($t0)
	
	jal threeVariableCheck
	
	# Left Diagonal
	lw $a0, 0($t0)
	lw $a1, 16($t0)
	lw $a2, 32($t0)
	
	jal threeVariableCheck
	
	# Right Diagonal
	lw $a0, 8($t0)
	lw $a1, 16($t0)
	lw $a2, 24($t0)
	
	jal threeVariableCheck

	
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra




exit:
    li $v0,10
    syscall

printX:
	addi, $sp, $sp, -4
    sw $ra, 0($sp)

	la $a0, x
	jal printStr
	
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

printU:
	addi, $sp, $sp, -4
    sw $ra, 0($sp)

	la $a0, u
	jal printStr
	
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

printO:
	addi, $sp, $sp, -4
    sw $ra, 0($sp)

	la $a0, o
	jal printStr
	
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
    
printSymbol:
	addi, $sp, $sp, -4
    sw $ra, 0($sp)

	move $t5, $a0
	li $t6, 0
	li $t7, 1

	beq $t5, $t6, printX
	beq $t5, $t7, printO
	li $t6, 9
	beq $t5, $t6, printU
	
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra


printTable:
	addi, $sp, $sp, -4
    sw $ra, 0($sp)

	la $t0, array    # Base pointer
    li $t1, 0        # i = 0
    li $t2, 9

        
    sumLoop:
        lw $t4, ($t0)    # array[i]

        move $a0, $t4
        jal printSymbol
        
        li $t3, 2
        beq $t1, $t3, printNewLineF
        printNewLineRF:
        
        li $t3, 5
        beq $t1, $t3, printNewLineS
        printNewLineRS:
        
        li $t3, 8
        beq $t1, $t3, printNewLineT
        printNewLineRT:

        # i += 1
        add $t1, $t1, 1
        
        # array[i * 4]
        add $t0, $t0, 4

        blt $t1, $t2, sumLoop
    
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

calculateElementAddressByIndex:
	addi, $sp, $sp, -4
    sw $ra, 0($sp)

	lw $t0, arrayIndex
	
	li $t1, 4
	
	mul $t0, $t0, $t1
	
	la $t1, array
	
	add $t1, $t1, $t0

	la $v0, 0($t1)
	
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra


getElementByIndex:
	addi, $sp, $sp, -4
    sw $ra, 0($sp)

	lw $a0, 0($v0)
	move $v1, $a0
	
	
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra


calculateArrayIndexByRowColumn:
    addi, $sp, $sp, -4
    sw $ra, 0($sp)

	lw $t2, row
	lw $t3, column

    mul $t1, $t2, 3
    add $t1, $t1, $t3

    sw $t1, arrayIndex
    mul $t1, $t1, 2
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra


printCurrentSymbol:

	addi, $sp, $sp, -4
    sw $ra, 0($sp)

    lw $t0, currentSymbol
    li $t1, 0
    beq $t0, $t1, printCurrentSymbolX
    
    li $t1, 1
    beq $t0, $t1, printCurrentSymbolO

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
	

printCurrentSymbolX:
	addi, $sp, $sp, -4
    sw $ra, 0($sp)

    # Print prompt
    la $a0, currentSymbolPromptX
    jal printStr

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra


printCurrentSymbolO:
	addi, $sp, $sp, -4
    sw $ra, 0($sp)

    # Print prompt
    la $a0, currentSymbolPromptO
    jal printStr

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

getInputRow:
    addi, $sp, $sp, -4
    sw $ra, 0($sp)

    # Print prompt
    la $a0, inputPromptRow
    jal printStr
    
    # Get row
    jal getInputInt
    
    subi $v0, $v0, 1
    sw $v0, row

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
   

getInputColumn:
    addi, $sp, $sp, -4
    sw $ra, 0($sp)

    # Print prompt
    la $a0, inputPromptColumn
    jal printStr
    
    # Get column
    jal getInputInt
    
    subi $v0, $v0, 1
    sw $v0, column
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    

getInputInt:
    addi, $sp, $sp, -4
    sw $ra, 0($sp)

    li $v0, 5
    syscall

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
    
printInt:
    addi, $sp, $sp, -4
    sw $ra, 0($sp)

    li $v0, 1
    syscall

    jal printNewLine

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
printStr:
	addi, $sp, $sp, -4
    sw $ra, 0($sp)

    li $v0, 4
    syscall

    jal printSpace

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
   
printStrN:
	addi, $sp, $sp, -4
    sw $ra, 0($sp)

    li $v0, 4
    syscall

    jal printNewLine

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra


printNewLine:
    addi, $sp, $sp, -4
    sw $ra, 0($sp)

    li $v0, 4
    la $a0, newline
    syscall

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra


printNewLineF:
	li $v0, 4
    la $a0, newline
    syscall
    j printNewLineRF
   
printNewLineS:
	li $v0, 4
    la $a0, newline
    syscall
    j printNewLineRS
    
printNewLineT:
	li $v0, 4
    la $a0, newline
    syscall
    j printNewLineRT


printSpace:
    addi, $sp, $sp, -4
    sw $ra, 0($sp)

    li $v0, 4
    la $a0, space
    syscall

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
