.data 
num0: .word 1 # posic 0
num1: .word 2 # posic 4
num2: .word 4 # posic 8 
num3: .word 8 # posic 12 
num4: .word 16 # posic 16 
num5: .word 32 # posic 20
num6: .word 0 # posic 24
num7: .word 0 # posic 28
num8: .word 0 # posic 32
num9: .word 0 # posic 36
num10: .word 0 # posic 40
num11: .word 0 # posic 44
.text 
main:
  lw $t1, 0($zero)
  lw $t2, 4($zero)
  lw $t3, 8($zero)
  nop
  nop
  nop
  slt $t3, $t1, $t2
  slt $t4, $t3, $t2
  nop
  nop
  nop
  nop