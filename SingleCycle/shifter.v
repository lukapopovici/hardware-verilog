`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/18/2024 02:55:52 AM
// Design Name: 
// Module Name: shifter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module shifter#(parameter SIZE=26,parameter SHIFTVAL=2)(
         input [SIZE-1:0] in, output [SIZE-1:0] out
    );
    
    assign out=in<<SHIFTVAL;
endmodule
