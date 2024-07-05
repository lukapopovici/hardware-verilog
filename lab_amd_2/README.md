# Behavioral ALU written in Verilog

### Features:

* out -> exit registry for arithmetic operations
* over/under -> dedicated bits for overflow/underflow operations
* err -> error detection bit for unknown operation
* log -> dedicated exit bit for logical operations

### Simulation:

![Screenshot 2024-07-02 122528](https://github.com/lukapopovici/hardware-verilog/assets/128390767/3bb1775e-17ab-4eae-a79c-0eedeaa34253)


### Operands are assumed to be unsigned!

Functionality:

    Command:                Action:
    0000                    SUM of OP
    0001                    SUB of OPb from OPa
    0010                    Shift bits from OPa left by [OPb] 
    0011                    Shift bits from OPa right by [OPb]
    0100                    Logical result of OPa == OPb
    0101                    Logical result of OPa > OPb
    0110                    Logical result of OPa < OPb


