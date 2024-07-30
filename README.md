# hardware-verilog


![image](https://github.com/lukapopovici/hardware-verilog/assets/128390767/7b151820-4728-4370-9163-92e97e472653)
### Acest repo prezinta proiectul realizat in cadrul stagiaturii de vara la AMD.

# Procesor MIPS Single-Cycle

[Aici](https://github.com/lukapopovici/hardware-verilog/tree/main/SINGLE_CYCLE) poate fi gasita implementarea unui procesor MIPS single-cycle in Verilog. 


### Schema:
![image](https://github.com/user-attachments/assets/77c247d3-f416-4c5c-bc4b-4ff94cec89c3)

*Semnalul MemRead nu este implementat

### Testbench:
Instructiunile sunt codificate pe 32 de biti, fiecare stocata pe 4 linii in fisierul instr.mem, de unde sunt incarcate.

### Program (assembly) : 

```
begin:
  nop
  add r2, r2, r1 
  sw r1, 2(r16) 
  lw r3, 0(r2) 
  rswp r1,r2
  jmp begin
```

### Program (binary) :

```
00000000_00000000_00000000_00000000

00000000_00000000_00000000_00000000

00000000_00100001_00010000_00100000

10101100_01000001_00000000_00000010

10001100_00100011_00000000_00000000

10000000_00100010_00000000_00000000

00001000_00000000_00000000_00000000

```


### Registrele

Bancul de registre e definit in modulul RB si sunt initializate cu valoarea 0, din fisierul register.mem. 

### Instrucțiuni Implementate:

- **I-type:**  
  - ADDI
  - ANDI
  - ORI
 
- **LW (OPCODE: 100011)**
 
- **SW (OPCODE: 101011)** 
    
- **R-type (OPCODE: 000000):**  
  - ADD  
  - SUB  
  - AND  
  - OR  
  - SLT
  
- **J-type: (OPCODE: 000010)**  
  - JMP
    
- **B-type: (OPCODE: 000100)**  
  - BEQ
    
- **Custom:**  
  - RSWP
 
### RSWP

Register swap. O instructiune custom care ia ca argumente 2 registre in fieldurile de dupa opcode si le interchimba valoare intr-un singur ciclu.


![image](https://github.com/user-attachments/assets/6387d26e-3bc2-4c4c-bab7-a03671b8a5b7)

OPCODE: 100000

Registrele destinate swapului sunt date in urmatorii 10 biti. Restul pot avea val X.

Exemplu de utilizare swap intre registrul 1 si 2.


## Alte circuite de interes

[Circuite ALU](https://github.com/lukapopovici/hardware-verilog/tree/main/ALU_EXECUTE)
