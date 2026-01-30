This project implements a simple stream cipher using an LFSR and a custom substitution table.

The goal is to demonstrate the principles of stream-based encryption and decryption in a hardware oriented context using *Verilog*. The encryption process operates on a reduced alphabet of 32 characters (5 bits), and the pseudo-random key stream is generated using an 8 bit LFSR. One character is processed per clock cycle.



## 1. Personalized 32 character table

The first positions of the substitution table are populated with letters from my first name, followed by remaining letters in the alphabet (A-Z), and finally, the table is completed with a couple of special characters and a few digits.
The table defines the complete alphabet of the cipher and is used bidirectionally to map characters to 5 bit indices and vice-versa during encryption and decryption.

To ensure the validity of the custom table, I tested it in a dedicated testbench, **table32_tb.v**.



## 2. Stream generator

The LFSR generator is implemented on 8 bits, and the internal state is declared as an 8-bit register - `reg [7:0] state`.

The primitive polynomial **x⁸ + x⁶ + x⁵ + x⁴ + 1** was implemented through XOR taps.
- so, the feedback bit is: **feedback = bit7 ⊕ bit5 ⊕ bit4 ⊕ bit3**



## 3. Encryption and Decryption

**Initialization**: the LFSR is initialized at the `start` signal in **cipher_core.v**, in the lfsr8 module.


**Step by step processing**: 
- the input plaintext character is read (`ch_in`)
- its 5 bit index (P) is found (signals: `idx_out, found`)
- the 5 bits are extracted from LFSR (K) - `lfsr_state[4:0]` 
- C = P XOR K - `assign idx_in_tbl`
- map C back to a character   
- advance LFSR - `state <= {state[6:0], fb};`


**Decryption**: the same cipher_core module was reused, so decryption works with the same table, same polynomial, same seed and same XOR operation.


To ensure the validity of the ENC/DEC operations, I tested them in dedicated testbenches, **cipher_core_tb.v**, **cipher_roundtrip_tb.v**.




## 4. Validating the LFSR module

To ensure the validity of the lfsr module, I tested it in a dedicated testbench, **lfsr8_tb.v**.

#### lfsr8_tb.v
##### Run in Terminal
```
iverilog -g2012 -o sim\lfsr8.out src\lfsr8.v tb\lfsr8_tb.v
vvp sim\lfsr8.out
```


## 5. Testing encryption and decryption

For every validation, a testbench was created.

- encrypting and decrypting a short word ("*circuit*")
#### test_short_word_tb.v
##### Run in Terminal
```
iverilog -g2012 -o sim\t1.out src\table32.v src\case_norm.v src\case_restore.v src\lfsr8.v src\cipher_core.v tb\test_short_word_tb.v
vvp sim\t1.out
```



- encrypting and decrypting my name 
	- spaces were removed since the space character is not in the valid alphabet (substitution table)
#### test_full_name_tb.v
##### Run in Terminal
```
iverilog -g2012 -o sim\t2.out src\table32.v src\case_norm.v src\case_restore.v src\lfsr8.v src\cipher_core.v tb\test_full_name_tb.v
vvp sim\t2.out
```



- encrypting and decrypting a word with repetitive characters ("*repetitive*")
#### test_repetitive_tb.v
##### Run in Terminal
```
iverilog -g2012 -o sim\t3.out src\table32.v src\case_norm.v src\case_restore.v src\lfsr8.v src\cipher_core.v tb\test_repetitive_tb.v
vvp sim\t3.out
```

- encrypting and decrypting a longer message of at least 100 characters ("*Verilogisahardwaredescriptionlanguagethatisdesignedtomodeldigitallogiccircuit&itisbasedontheCprogramminglanguage*")
	- spaces were removed since the space character is not in the valid alphabet (substitution table)
#### test_long_100_tb.v
##### Run in Terminal
```
iverilog -g2012 -o sim\t4.out src\table32.v src\case_norm.v src\case_restore.v src\lfsr8.v src\cipher_core.v tb\test_long_100_tb.v
vvp sim\t4.out
```




## 6. Lower and upper case validation

The substitution table contains only uppercase letters, the chosen special characters and the digits - it doesn't store lowercase variants.

Therefore, I added case normalization:
- if input is lowercase, it is converted to uppercase
- it has to remember its original form (lower/upper)
- if input is already uppercase or non letter, it's left unchanged

The case  restoration step is needed after mapping back to a character. 

The testbench **case_tb.v** preserves case deterministically by storing a 1 bit `was_lower` flag per plaintext character and applying it after decryption. This ensures the decrypted text matches the original plaintext case exactly, while the substitution table remains unchanged.

#### case_tb.v
##### Run in Terminal
```
iverilog -g2012 -o sim\case.out src\case_norm.v src\case_restore.v tb\case_tb.v
vvp sim\case.out
```


