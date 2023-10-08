# VHDL_utils
Descriptions in VHDL of simple circuits that are useful for general purposes.

# ALU:
This ALU manages the next operations:
- And
- Or
- Xor
- Addition
- Substraction
- Addition of 4
- Shift left of 2 bits on A

## Check: 
- If we need to use unsigned, integer or what type of data to perform addition, substraction, comparation, etc.
If it's neccessary, modify types to integer and make the corresponding tests.
## Features to add
- Add overflow flag: V= (SA)*(SB)*/(SS) + /(SA)*/(SB)*(SS), being V: overflow flag, SA: MSB of A, etc.