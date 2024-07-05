# Behavioral ALU written in Verilog

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

### Results of logical operations is given trough a dedicated bit as opposed of the normal output of the alu for arithmetic operations
