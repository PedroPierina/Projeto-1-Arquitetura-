.data
array1: .space 3200 #$t2
id: .space 4 #$t3
pos: .space 4 #t4
pos2: .space 4#usada pra tanto print quanto excluir
tam: .space 4 #tamanho do array

msg0: .asciiz "\tControle de Gastos\n"
msg1: .ascii "\t\t1) Registrar Despesas\n\t\t2) Excluir Despesas\n\t\t3) Listar Despesas\n\t\t4) Exibir Gasto Mensal\n\t\t"
msg11:.asciiz"5) Exibir gastos por Categoria\n\t\t6) Exibir Ranking por Despesas\n\t\t7) Sair\n\n"
msg2: .asciiz "\nInsira o dia:"
msg3: .asciiz "\nInsira o mes:"
msg4: .asciiz "\nInsira o ano:"
msg5: .asciiz "\nInsira o valor gasto:"
msg6: .asciiz "\nInsira o tipo de gasto:"
msg7: .asciiz "\nInsira o ID a excluir:"
msg8: .asciiz "\nID nao cadastrado"
msg9: .asciiz "/"
msg10: .asciiz "\n"

#id(0-2), dia(2-4), mes(4-6), ano(6-8), soma(8-12) = 12
#salario(12-16)  = 4
#string(16-32) = 16
#total: 32 bytes por despesa ou 8 words

.text
.globl main

	la $t2, array1
	sh $zero, 0($t2)

	la $t3, id #zera o ID no comeco do programa
	sw $zero, 0($t3)

	la $t4, pos #zera a Posicao no comeco do programa
	sw $zero, 0($t4)

	la $t4, pos2 #zera a Posicao2 no comeco do programa
	sw $zero, 0($t4)


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

addi $s0, $zero, 0 #pega o primeiro ID
lh $s2, 0($t2)

ContinuaBuscaRD:
beq $s2, $zero, ContinuaRD #compara se eh zero

la $t4, pos #recupera a posicao atual do array
lw $s0, 0($t4)

la $t2, array1 # se for diferente de zero, anda para a proxima despesa
addi $s0, $s0, 32 #Atualiza a posicao do array em 32(nova conta)
add $t2, $t2, $s0
lh $s2, 0($t2)

la $t4, pos #salva a posicao atual do array
sw $s0, 0($t4)

j ContinuaBuscaRD

ContinuaRD: #acho o id zero

#----------Coloca ID----------------
	 la $t4, tam
	 lw $s0, 0($t4)

	 addi $s0, $s0, 1

	 sw $s0, 0($t4)

	 la $t3, id #pega endereco de ID
	 lw $s3, 0($t3)

	 addi $s3, $s3, 1 #incrementa 1 no ID

	 la $t3, id #salva novo ID
	 sw $s3, 0($t3)

	 la $t4, pos #pega a posicao do array
	 lw $s0, 0($t4)

	 la $t2, array1 # salva o ID na posicao correta do array
	 add $t2, $t2, $s0
	 sh $s3, 0($t2)

#----------Recebe dia---------------

	 li $v0, 4     # Codigo SysCall p/ escrever strings
	 la $a0, msg2  #Passa a msg para o parametro a0
	 syscall

	 li $v0, 5 #pega dia
	 syscall
	 add $s0, $zero, $v0

	 la $t4, pos #pega posicao correta do array
	 lw $s2, 0($t4)

	 la $t2, array1

	 addi $s2, $s2, 2 #ajusta o endereco do array
	 add $t2, $t2, $s2

	 sh $s0, 0($t2)

#-------Recebe mes------------
	li $v0, 4     # Codigo SysCall p/ escrever strings
	la $a0, msg3  #Passa a msg para o parametro a0
	syscall

	li $v0, 5 #pega mes
	syscall
	add $s2, $zero, $v0

	la $t4, pos #pega posicao atual
	lw $s0, 0($t4)

	la $t2, array1

	addi $s0, $s0, 4 #ajusta posicao atual, salva ela novamente e salva o mes
	add $t2, $t2, $s0
	sh $s2, 0($t2)

#--------Recebe ano---------------
	li $v0, 4     # Codigo SysCall p/ escrever strings
	la $a0, msg4  #Passa a msg para o parametro a0
	syscall

	li $v0, 5 #pega o ano
	syscall
	add $s2, $zero, $v0

	la $t4, pos #pega posicao atual
	lw $s0, 0($t4)

	la $t2, array1

	addi $s0, $s0, 6 #ajusta posicao atual, salva ela novamente, e salva o ano
	add $t2, $t2, $s0
	sh $s2, 0($t2)


	la $t4, pos #pega posicao atual
	lw $s0, 0($t4)

	la $t2, array1
	add $t2, $t2, $s0

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
	addi $s0, $s0, 8
	add $t2, $t2, $s0

	sw $t0, 0($t2) #data formatada salva

#---------------PEGANDO FLOAT--------------------------
	li $v0, 4     # Codigo SysCall p/ escrever strings
	la $a0, msg5  #Passa a msg para o parametro a0
	syscall

	li $v0, 6 #pega o salario
	syscall
	mov.s $f4, $f0 #.s eh o comando para mexer com floats

	la $t4, pos
	lw $s0, 0($t4)

	la $t2, array1
	addi $s0, $s0, 12
	add $t2, $t2, $s0

	s.s $f4, 0($t2)

	li $v0, 4     # Codigo SysCall p/ escrever strings
	la $a0, msg10  #Passa a msg para o parametro a0
	syscall

#--------------PEGANDO STRING------------------------------
	li $v0, 4     # Codigo SysCall p/ escrever strings
	la $a0, msg6  #Passa a msg para o parametro a0
	syscall

	la $t4, pos
	lw $s0, 0($t4)

	la $t2, array1

	li $v0, 8
	add $t2,$t2,$s0
	add $a0, $zero, $t2# passa o endereco de array pra a0
	addi $a0, $a0, 16 #salva na posicao de memoria passada para a0 + 16 bytes
	add $a1, $zero, 16#limita pra 16 bytes o tamanho da string
	syscall

	j main # retorna para a main
#-----------------------------------------------------------------------------Exclui Despesas---------------------------------------------
ExcluirDespesas:
	la $t4, tam
	lw $s0, 0($t4)

	sub $s0, $s0, 1

	sw $s0, 0($t4)

	la $t4, pos2 #zera o ID no comeco do programa
	sw $zero, 0($t4)

	la $t2, array1
	lh $s2, 0($t2)

	li $v0, 4     # Codigo SysCall p/ escrever strings
	la $a0, msg7  #Passa a msg para o parametro a0
	syscall

	li $v0,5 #pega ID
	syscall

	add $s0,$zero,$v0 #Passa id pra s0
ProcuraID:
	beq $s0,$s2,ExcluidID # compara se o id digitado e o mesmo que o registrado

	la $t4,pos2
	lw $s1,0($t4)

	la $t2, array1
	addi $s1,$s1,32 #atualiza a pos2
	add $t2,$t2,$s1
	lh $s2, 0($t2) #pega o id da proxima posicao

	la $t4, pos2
	sw $s1,0($t4) #salva a pos2 atualizada

	la $t4, pos
	lw $s5,0($t4) #pega o valor da pos

	beq $s5,$s1,$saimain #compara se a pos2 e a mesma que a pos, logo chego no fim do cadastro e nao achou o id

	j ProcuraID

ExcluidID:
	la $t4,pos2
	lw $s1,0($t4) #pega a posicao salva em pos2

	la $t2, array1
	add $t2,$t2,$s1 # vai pra posicao do array indicada por pos2
	sw $zero, 0($t2)#zera o id

	j main # retorna para a main

saimain:
	li $v0, 4     # Codigo SysCall p/ escrever strings
	la $a0, msg7  #Passa a msg para o parametro a0
	syscall

	j main
#-----------------------------------------------------------------------------ListaDespesas---------------------------------------------
ListarDespesas:

	jal BubbleSort
	#print para testes
	la $t4, pos2 #zera o ID no comeco do programa
	sw $zero, 0($t4)

	la $t2, array1
	lh $s2, 0($t2)

ContinuaBuscaLD:
bne $s2, $zero, ContinuaLD #compara se eh zero

j main

ContinuaLD:

	la $t2, array1 # passa o endereco de array1 para t2

	la $t4, pos2 #recupera a posicao atual do array
	lw $s0, 0($t4)
	add $t2, $t2, $s0

	lh $s2, 0($t2) # pega o id

	li $v0, 1
	add $a0, $zero, $s2 #Print ID
	syscall
#--------------------------
	li $v0, 4     # Codigo SysCall p/ escrever strings
	la $a0, msg9  #Passa a msg para o parametro a0
	syscall
#-----------------------------
	la $t2, array1
	la $t4, pos2 #recupera a posicao atual do array
	lw $s0, 0($t4)
	add $t2, $t2, $s0

	lh $s3, 2($t2) # pega o dia

	li $v0, 1
	add $a0, $zero, $s3 # printa dia
	syscall
#-----------------------------
	li $v0, 4     # Codigo SysCall p/ escrever strings
	la $a0, msg9  #Passa a msg para o parametro a0
	syscall
#-----------------------------
	la $t2, array1
	la $t4, pos2 #recupera a posicao atual do array
	lw $s0, 0($t4)
	add $t2, $t2, $s0

	lh $s3, 4($t2)# pega o mes

	li $v0, 1
  add $a0, $zero, $s3 #Print mes
	syscall
#-----------------------------
	li $v0, 4     # Codigo SysCall p/ escrever strings
	la $a0, msg9  #Passa a msg para o parametro a0
	syscall
#---------------------------
	la $t2, array1
	la $t4, pos2 #recupera a posicao atual do array
	lw $s0, 0($t4)
	add $t2, $t2, $s0

	lh $s3, 6($t2)# pega o ano

	li $v0, 1
  add $a0, $zero, $s3 #Printa ano
	syscall
#-----------------------------
li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, msg9  #Passa a msg para o parametro a0
syscall
#----------------------------
	la $t2, array1
	la $t4, pos2 #recupera a posicao atual do array
	lw $s0, 0($t4)
	add $t2, $t2, $s0

	l.s $f5, 12($t2) #pega o valor gasto

	li $v0, 2
	mov.s $f12, $f5
	syscall
#---------------------------
li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, msg9  #Passa a msg para o parametro a0
syscall
#---------------------------
	la $t2, array1
	la $t4, pos2 #recupera a posicao atual do array
	lw $s0, 0($t4)
	add $t2, $t2, $s0

	li $v0,4
	la $a0, 16($t2)#passa a string salva no byte 16 pra a0 e printa
	syscall
#---------------------------
	li $v0, 4     # Codigo SysCall p/ escrever strings
	la $a0, msg10  #Passa a msg para o parametro a0
	syscall

	la $t4, pos2 #recupera a posicao atual do array
	lw $s0, 0($t4)

	la $t2, array1 # se for diferente de zero, anda para a proxima despesa
	addi $s0, $s0, 32
	add $t2, $t2, $s0
	lh $s2, 0($t2)

	la $t4, pos2 #salva a posicao atual do array
	sw $s0, 0($t4)

	j ContinuaBuscaLD #

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
	#---------------Bubble Sort-------------------------------------------------------------------------
BubbleSort:
	la $a0, array1
	lw $a1, tam
	j bubble

bubble: li $s0, 0               # (s0) i = 0
	move $t6, $zero

eloop:  bge $s0, $a1, excluiMenos1       # break if i >= vecsz
	li  $s1, 0

iloop:  bge $s1, $a1 endiloop   # break if j >= vecsz (vecsz >= j)

	sll $t1, $s0, 5         # t1 = i * 32 (para indexar o vetor)
	sll $t2, $s1, 5         # t2 = j * 32 (para indexar o vetor)

	add $t1, $a0, $t1       # endereço de vec[i] => t1 = vec + i * 4
	add $t2, $a0, $t2       # endereço de vec[j] => t2 = vec + j * 4

	lw $t3, ($t1)           # t3 = vec[i]
	lw $t4, ($t2)           # t4 = vec[j]

	addi $t5, $zero, -1
	beq $t3, $t5, swapi  #id igual -1

	addi $t1, $t1, 8
	addi $t2, $t2, 8

	lw $t3, ($t1)
	lw $t4, ($t2)

	addi $t1, $t1, -8
	addi $t2, $t2, -8

	blt $t3, $t4, swap

	addi $s1, $s1, 1 # j++
	j iloop
swapi:
	addi $t6, $t6, 1
swap:

	sw $t3, ($t2)           #id e dia swap
	sw $t4, ($t1)

	addi $t1,$t1, 4
	addi $t2,$t2, 4


	sw $t3, ($t2)
	sw $t4, ($t1)          #mes e ano swap

	addi $t1,$t1, 4
	addi $t2,$t2, 4

	sw $t3, ($t2)
	sw $t4, ($t1)           #data formatada swap

	addi $t1,$t1, 4
	addi $t2,$t2, 4

	sw $t3, ($t2)
	sw $t4, ($t1)           #salario swap

	addi $t1,$t1, 4
	addi $t2,$t2, 4

	sw $t3, ($t2)
	sw $t4, ($t1)           #part1 string swap

	addi $t1,$t1, 4
	addi $t2,$t2, 4

	sw $t3, ($t2)
	sw $t4, ($t1)           #part2 string swap

	addi $t1,$t1, 4
	addi $t2,$t2, 4

	sw $t3, ($t2)
	sw $t4, ($t1)           #part3 string swap

	addi $t1,$t1, 4
	addi $t2,$t2, 4

	sw $t3, ($t2)
	sw $t4, ($t1)           #part4 string swap


endiloop:
	addi $s0, $s0, 1        # i++
	j eloop
excluiMenos1:
	beq $t6, $zero, end
	la $a0, vec

	addi $a1, $a1, -1 # numero de elementos -1
	mul $t7, $a1, 32
	add $t7, $a0, $t7 #soma a pos 0 numero de elementos
	sw $zero, ($t7) # salva zero no id
	addi $t6, $t6, -1 # numero de -1, reduz em 1
	j excluiMenos1
end:
	jr $ra

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
