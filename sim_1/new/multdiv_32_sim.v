`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: multdiv_32����
//////////////////////////////////////////////////////////////////////////////////

module multdiv_32_sim();
    //input   
    reg clk,rst=0;
    reg [4:0] ALU_OP = 0;
    reg [31:0] ALU_A = 0;
    reg [31:0] ALU_B = 0;
    //output
    wire MULTBUSY,DIVBUSY,MULTWRITE,DIVWRITE;
    wire [31:0] ALU_HI,ALU_LO;
    
    //����
    multdiv_32 multdiv32 (
        .clk(clk),
        .rst(rst),
        .ALU_OP(ALU_OP),
        .ALU_A(ALU_A),
        .ALU_B(ALU_B),
        .ALU_HI(ALU_HI),
        .ALU_LO(ALU_LO),
        .MULTBUSY(MULTBUSY),
        .DIVBUSY(DIVBUSY),
        .MULTWRITE(MULTWRITE),
        .DIVWRITE(DIVWRITE)
    );
    
    //��ʼ��ʱ���ź�
    initial begin
        clk = 0;
        forever
        #5 clk = ~clk;
    end    
    
    always begin
    /* if multu */
    # 10 rst=1;
         ALU_OP = 5'b01110;
         ALU_A = 4;
         ALU_B = 5;
         
    # 40 rst = 0;//��λ
    
    /* if mult */
    # 10 rst = 1;
         ALU_OP = 5'b01101;
         ALU_A = -4;
         ALU_B = 5;
         
    # 40 rst = 0;//��λ
    
    /* if divu */
    # 10 rst = 1;
         ALU_OP = 5'b10000;
         ALU_A = 7;
         ALU_B = 2;
         
    # 100 rst = 0;//��λ
    
    /* if div */
    # 10 rst = 1;
         ALU_OP = 5'b01111;
         ALU_A = -7;
         ALU_B = 2;
         
    # 100 rst = 0;//��λ
    end
endmodule