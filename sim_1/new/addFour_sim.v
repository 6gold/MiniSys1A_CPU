`timescale 1ns / 1ps

module addFour_sim();
    reg [31:0] pc = 0;
    wire [31:0] pc_plus4;

    addFour addFour(
        .pc(pc),
        .pc_plus4(pc_plus4)
    );
    
    always begin
    #10 pc = 32'h0;
    #10 pc = 32'h4;
    #10 pc = 32'h12;
    end

endmodule
