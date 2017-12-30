`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: ”√”⁄pc+4
//////////////////////////////////////////////////////////////////////////////////

module addFour(pc,pc_plus4);
    input [31:0] pc;
    output [31:0] pc_plus4;

    reg [31:0] pc_plus4;
    
    always @(pc) begin
        pc_plus4 = pc + 32'h4;
    end
//    assign pc_plus4 = pc + 32'h4;

endmodule
