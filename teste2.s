.data
array1: .space 3200
id: .space 4
pos: .space 4

msg0: .asciiz "\tControle de Gastos\n"
msg1: .ascii "\t\t1) Registrar Despesas\n\t\t2) Excluir Despesas\n\t\t3) Listar Despesas\n\t\t4) Exibir Gasto Mensal\n\t\t"
msg11:.asciiz"5) Exibir gastos por Categoria\n\t\t6) Exibir Ranking por Despesas\n\t\t7) Sair\n\n"
msg2: .asciiz "\nInsira o dia:"
msg3: .asciiz "\nInsira o mes:"
msg4: .asciiz "\nInsira o ano:"
msg5: .asciiz "\nInsira o valor gasto:"
msg6: .asciiz "\nInsira o tipo de gasto:"
msg9: .asciiz "/"
msg10: .asciiz "\n"

#id(0-2), dia(2-4), mes(4-6), ano(6-8), soma(8-12) = 12
#salario(12-16)  = 4
#string(16-32) = 16
#total: 32 bytes por despesa ou 8 words

.text
.globl main

	la $t2, id
	sw $zero, 0($t2)

main:

	li $v0, 4     # Codigo SysCall p/ escrever strings
	la $a0, msg0  #Passa a msg para o parametro a0
	syscall

	li $v0, 4	 # Codigo SysCall p/ escrever strings
	la $a0, msg1 #Passa a msg para o parametro a0
	syscall

	li $v0, 5	 # Codigo SysCall p/ ler inteiros
	syscall

#---------------Verifica qual a opcao escolhida pelo usuario e desvia o programa para o label certo--
	addi $t0, $zero,1
	beq $t0,$v0,RegistrarDespesas #caso t0 e v0 sejam iguais da um jump

	addi $t0, $zero,2
	beq $t0,$v0,ExcluirDespesas #caso t0 e v0 sejam iguais da um jump

	addi $t0, $zero,3
	beq $t0,$v0,ListarDespesas #caso t0 e v0 sejam iguais da um jump

	addi $t0, $zero,4
	beq $t0,$v0,ExibirGastoMensal #caso t0 e v0 sejam iguais da um jump

	addi $t0, $zero,5
	beq $t0,$v0,ExibirgastosPorCategoria #caso t0 e v0 sejam iguais da um jump

	addi $t0, $zero,6
	beq $t0,$v0,ExibirRankingPorDespesas #caso t0 e v0 sejam iguais da um jump

	addi $t0, $zero,7
	beq $t0,$v0,Sair #caso t0 e v0 sejam iguais da um jump
#------------------------------------------------------------------------------------------------------
# dentro dos labels so tem uma funcao teste para saber se entro no label certo

RegistrarDespesas:
#----------Procura Posição-----------
la $t2, array1

addi $s7, $zero, 0 #pega o primeiro ID
lh $s2, 0($t2)

ContinuaBuscaRD:
beq $s2, $zero, ContinuaRD #compara se eh zero

la $t2, array1 # se for diferente de zero, anda para a proxima despesa
addi $s7, $s7, 32
add $t2, $t2, $s7
lh $s2, 0($t2)

la $t4, pos #salva a posicao atual do array
sw $s7, 0($t4)

j ContinuaBuscaRD

ContinuaRD: #acho o id zero

#----------Coloca ID----------------
	la $t3, id #pega endereco de ID

	lh $s3, 0($t3) #incrementa 1 no ID
	addi $s2, $s3, 1

	la $t3, id #salva novo ID
	sh $s2, 0($t3)

	la $t4, pos #pega a posicao do array
	lw $s0, 0($t4)

	la $t2, array1 # salva o ID na posicao correta do array
	add $t2, $t2, $s0
	sh $s2, 0($t2)

	li $v0, 1
	add $a0, $zero, $s2 #Print ID
	syscall

#----------Recebe dia---------------

	li $v0, 4     # Codigo SysCall p/ escrever strings
	la $a0, msg2  #Passa a msg para o parametro a0
	syscall

	addi $v0, $zero, 0

	li $v0, 5 #pega dia
	syscall
  move $s2, $v0

	la $t4, pos #pega posicao correta do array
	lw $s0, 0($t4)

	la $t2, array1

	addi $s0, $s0, 2 #ajusta o endereco do array
	add $t2, $t2, $s0

	sw $s0, 0($t4) #salva nova posicao atual e o dia
	sh $s2, 0($t2)

	la $t2, array1
  lh $s3, 2($t2)

	#li $v0, 1
	#add $a0, $zero, $s3 # printa dia
	#syscall

	# la $t2, array1
	# sh $s2, 0($t2)
	#
	# li $v0, 1
	# add $a0, $zero, $s2 #Print ID
	# syscall

#-------Recebe mes------------
	li $v0, 4     # Codigo SysCall p/ escrever strings
	la $a0, msg3  #Passa a msg para o parametro a0
	syscall

	addi $v0, $zero, 0

	li $v0, 5 #pega mes
	syscall
	move $s2, $v0

	la $t4, pos #pega posicao atual
	lw $s0, 0($t4)

	la $t2, array1

	addi $s0, $s0, 2 #ajusta posicao atual, salva ela novamente e salva o mes
	add $t2, $t2, $s0
	sh $s0, 0($t4)
	sh $s2, 0($t2)
	#lh $s3, $s0($t2)

	# la $t2, array1
	# sh $s2, 0($t2)
	#
	# li $v0, 1
	# add $a0, $zero, $s2 #Print ID
	# syscall

#--------Recebe ano---------------
	li $v0, 4     # Codigo SysCall p/ escrever strings
	la $a0, msg4  #Passa a msg para o parametro a0
	syscall

	addi $v0, $zero, 0

	li $v0, 5 #pega o ano
	syscall
	move $s2, $v0

	la $t4, pos #pega posicao atual
	lw $s0, 0($t4)

	la $t2, array1

	addi $s0, $s0, 2 #ajusta posicao atual, salva ela novamente, e salva o ano
	add $t2, $t2, $s0
	sw $s0, 0($t4)
	sh $s2, 0($t2)

	la $t2, array1

	lh $s3, 2($t2) #dia
	lh $s4, 4($t2) #mes
	lh $s5, 6($t2) #ano

	addi $t0, $zero, 365
	mul $t0, $t0, $s5 #ano * 365

	addi $t1, $zero, 30
	mul $t1, $t1, $s4 #mes*30

	add $t0, $t0, $t1
	add $t0, $t0, $s3 #t0 contem a data formatada: soma de dia + mes + ano

	la $t4, pos
	lw $s0, 0($t4)

	la $t2, array1
	addi $s0, $s0, 2
	add $t2, $t2, $s0

	sw $s0, 0($t4)
	sh $t0, 0($t2) #data formatada salva

	#lh $s0, 8($t2)
	# li $v0, 1
	# add $a0, $zero, $s0 #print data formatada
	# syscall

	li $v0, 1
	add $a0, $zero, $s3 # printa dia
	syscall

	li $v0, 4     # Codigo SysCall p/ escrever strings
	la $a0, msg9  #Passa a msg para o parametro a0
	syscall

	li $v0, 1
	add $a0, $zero, $s4 # printa mes
	syscall

	li $v0, 4     # Codigo SysCall p/ escrever strings
	la $a0, msg9  #Passa a msg para o parametro a0
	syscall

	li $v0, 1
	add $a0, $zero, $s5 # printa ano
	syscall

#---------------PEGANDO FLOAT--------------------------
	li $v0, 4     # Codigo SysCall p/ escrever strings
	la $a0, msg5  #Passa a msg para o parametro a0
	syscall

	li $v0, 6 #pega o salario
	syscall
	mov.s $f4, $f0

	la $t4, pos
	lw $s0, 0($t4)

	la $t2, array1
	addi $s0, $s0, 4
	add $t2, $t2, $s0
	sh $s0, 0($t4)

	s.s $f4, 0($t2)

	la $t2, array1
	l.s $f5, 12($t2)

	li $v0, 2
	mov.s $f12, $f5
	syscall

	li $v0, 4     # Codigo SysCall p/ escrever strings
	la $a0, msg10  #Passa a msg para o parametro a0
	syscall

#--------------PEGANDO STRING------------------------------
	li $v0, 4     # Codigo SysCall p/ escrever strings
	la $a0, msg6  #Passa a msg para o parametro a0
	syscall

	la $t2, array1
	li $v0, 8
	add $a0, $zero, $t2
	addi $a0, $a0, 16
	add $a1, $zero, 16
	syscall

	la $t4, pos
	lh $s0, 0($t4)

	addi $s0, $s0, 4
	add $t2, $t2, $s0
	sh $s0, 0($t4)

	#la $a0, $s0($t2)

	la $t2, array1
	li $v0,4
	la $a0, 16($t2)
	syscall

	la $t4, pos
	lh $s0, 0($t4)

	addi $s0, $s0, 16
	sh $s0, 0($t4)

	li $v0, 4     # Codigo SysCall p/ escrever strings
	la $a0, msg10  #Passa a msg para o parametro a0
	syscall
#---------------------------------------
	j main # retorna para a main

ExcluirDespesas:
	add $t0, $zero,$v0
	li $v0, 1
	add $a0, $zero, 2
	syscall
	j main # retorna para a main
ListarDespesas:

	la $t2, array1
	sh $s2, 0($t2)

	li $v0, 1
	add $a0, $zero, $s2 #Print ID
	syscall

	li $v0, 4     # Codigo SysCall p/ escrever strings
	la $a0, msg10  #Passa a msg para o parametro a0
	syscall

	lh $s3, 2($t2) #dia
	lh $s4, 4($t2) #mes
	lh $s5, 6($t2) #ano

	li $v0, 1
	add $a0, $zero, $s3 # printa dia
	syscall

	li $v0, 4     # Codigo SysCall p/ escrever strings
	la $a0, msg9  #Passa a msg para o parametro a0
	syscall

	li $v0, 1
	add $a0, $zero, $s4 # printa mes
	syscall

	li $v0, 4     # Codigo SysCall p/ escrever strings
	la $a0, msg9  #Passa a msg para o parametro a0
	syscall

	li $v0, 1
	add $a0, $zero, $s5 # printa ano
	syscall

	li $v0, 4     # Codigo SysCall p/ escrever strings
	la $a0, msg10  #Passa a msg para o parametro a0
	syscall

	la $t2, array1
	l.s $f5, 12($t2)

	li $v0, 2
	mov.s $f12, $f5
	syscall

	li $v0, 4     # Codigo SysCall p/ escrever strings
	la $a0, msg10  #Passa a msg para o parametro a0
	syscall

	la $t2, array1

	li $v0,4
	la $a0, 16($t2)
	syscall

	li $v0, 4     # Codigo SysCall p/ escrever strings
	la $a0, msg10  #Passa a msg para o parametro a0
	syscall

	j main # retorna para a main
ExibirGastoMensal:
	add $t0, $zero,$v0
	li $v0, 1
	addi $a0, $zero, 4
	syscall
	j main # retorna para a main
ExibirgastosPorCategoria:
	add $t0, $zero,$v0
	li $v0, 1
	addi $a0, $zero, 5
	syscall
	j main # retorna para a main
ExibirRankingPorDespesas:
	add $t0, $zero,$v0
	li $v0, 1
	addi $a0, $zero, 6
	syscall
	j main # retorna para a main
Sair:
	li $v0, 10 # comando de exit, nao sei se vamos usar mais por via das duvidas deixei comentado
	syscall

	#---------------STRCMP------------------------------------------------------------------------------
# STRCMP: #$a0 String 1, $a1 String 2, $v0 = 0 se igual, $v0 = 1 se diferente
#     add $t0, $zero, $zero # i = 0
# STRCMPL1:
#     add $t1, $a0, $t0 # $t1 = &str1[i]
#     lbu $t1, 0($t1) # $t1 = str1[i]
#     add $t2, $a1, $t0 # $t2 = &str2[i]
#     lbu $t2, 0($t2) # $t2 = str2[i]
#     beq $t1, $t2, STRCMP_L2 # se for igual entre si
#     addi $v0, $zero, 1
#     j STRCMP_FIM
# STRCMP_L2:
#     addi $t0, $t0, 1
#     bne $t1, $zero, STRCMPL1 # se nao for \0 volta com i++
#     add $v0, $zero, $zero
# STRCMP_FIM:
#     jr $ra
