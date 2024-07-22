# hardware-verilog


![image](https://github.com/lukapopovici/hardware-verilog/assets/128390767/7b151820-4728-4370-9163-92e97e472653)
### Acest repo prezinta proiectul realizat in cadrul stagiaturii de vara la AMD.

# Procesor MIPS Single-Cycle

### Schema:
![image](https://github.com/user-attachments/assets/77c247d3-f416-4c5c-bc4b-4ff94cec89c3)

### Testbench:
Instructiunile sunt codificate pe 32 de biti, fiecare pe 4 linii.Acestea sunt incarcate in fisierul instr.mem.

### Program: 

```
begin:
  nop
  add r2, r2, r1 
  sw r1, 2(r16) 
  lw r3, 0(r2) 
  rswp r1,r2
  jmp begin
```

### Registrele

Bancul de registre e definit in modulul RB si sunt initializate cu valoarea 0, din fisierul register.mem. 

### Instrucțiuni Implementate:

- **I-type:**  
  - ADDI
  - ANDI
  - ORI
    
- **R-type:**  
  - ADD  
  - SUB  
  - AND  
  - OR  
  - SLT
  - 
- **J-type:**  
  - JMP
    
- **B-type:**  
  - BEQ  
  - BNE  
- **Custom:**  
  - RSWP
 
### RSWP

Register swap. O instructiune custom care ia ca argumente 2 registre in fieldurile de dupa opcode si le interchimba valoare intr-un singur ciclu.


![image](https://github.com/user-attachments/assets/6387d26e-3bc2-4c4c-bab7-a03671b8a5b7)

OPCODE: 100000

Registrele destinate swapului sunt date in urmatorii 10 biti. Restul pot avea val X.

Exemplu de utilizare swap intre registrul 1 si 2.

