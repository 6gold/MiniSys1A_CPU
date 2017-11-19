`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: 桶形移位器
//////////////////////////////////////////////////////////////////////////////////

module barrelshifter32(a,b,ctr,d);

    input [31:0] a;//操作数
    input [4:0] b;//移动的位数
    input [1:0] ctr;//11：算术右移； 10：逻辑右移； 01：算数左移； 00：逻辑左移
    
    output reg[31:0] d;//移位结果
    
    reg [31:0] temp;
    
    always @(a or b or ctr)
    begin
        case(ctr)
            2'b11: begin
                temp=b[0]?{{a[31]},a[31:1]}:a;
                temp = b[1] ? {{2{temp[31]}}, temp[31:2]} : temp;
                temp = b[2] ? {{4{temp[31]}}, temp[31:4]} : temp;
                temp = b[3] ? {{8{temp[31]}}, temp[31:8]} : temp;
                temp = b[4] ? {{16{temp[31]}}, temp[31:16]} : temp;
            end
            2'b10: begin
                 temp = b[0] ? {32'b0, a[31:1]} : a;
                 temp = b[1] ? {32'b0, temp[31:2]} : temp;
                 temp = b[2] ? {32'b0, temp[31:4]} : temp;
                 temp = b[3] ? {32'b0, temp[31:8]} : temp;
                 temp = b[4] ? {32'b0, temp[31:16]} : temp;
                end
            2'b01, 2'b00: begin
                 temp = b[0] ? {{a[30:0]}, 1'b0} : a;
                 temp = b[1] ? {{temp[29:0]}, 2'b0} : temp;
                 temp = b[2] ? {{temp[27:0]}, 4'b0} : temp;
                 temp = b[3] ? {{temp[23:0]}, 8'b0} : temp;
                 temp = b[4] ? {{temp[15:0]}, 16'b0} : temp;
                end
        endcase
        d = temp;
        end

endmodule
