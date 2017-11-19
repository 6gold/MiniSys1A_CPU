module extend
(
    input [15:0] imm,
    input ExtOp,
    output reg[31:0] result
);

    always@(ExtOp, imm)
    begin
        if (imm[15]&ExtOp)
            result = {16'hffff, imm};
        else
            result = {16'h0000, imm};
     end                  
endmodule
