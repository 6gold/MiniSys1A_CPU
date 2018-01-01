`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: 存储器读写模块
//////////////////////////////////////////////////////////////////////////////////

module MinisysMEM(
    /* input*/
    clk,clrn,
    //from【EXE阶段】
    regwriteM,mem2regM,memwriteM,branchM,
    zeroM,
    alu_outM,write_dataM,write_regM,     
    /* output */
    //to【WB阶段】
    regwriteW,      //该信号作为下一个【ID阶段】的输入
    mem2regW,
    alu_outW,       //alu_out作为读写存储器的地址
    read_dataW,
    write_regW,     //该组信号作为下一个【ID阶段】的输入
    pc_srcM         //该信号作为下一个【IF阶段】的输入
    );
    
    input clk,clrn;
    input regwriteM,mem2regM,branchM,zeroM;
    input [3:0] memwriteM;
    input [31:0] alu_outM,write_dataM;
    input [4:0] write_regM;        
    output regwriteW,mem2regW;
    output [31:0] alu_outW,read_dataW;  //alu_out作为读写存储器的地址
    output [4:0] write_regW;
    
    assign pc_srcM = branchM & zeroM;
    
    /* 中间变量 */ 
    wire [31:0] read_dataM;             //读出数据
    
    /* 元件例化 */
       
    //数据存储器例化
    wire clk_reverse;
    assign clk_reverse = !clk;
    //因为使用芯片的固有延迟，RAM的地址线来不及在时钟上升沿准备好
    //使得时钟上升沿数据读出有误，所以采用反向时钟，使得读出数据比地址准备好要晚大约半个时钟
    //从而得到正确的地址
    ram0 ram0(
        .clka(clk_reverse),
        .wea(memwriteM[0]),
        .addra(alu_outM[15:2]),
        .dina(write_dataM[7:0]),//小端存储
        .douta(read_dataM[7:0])
    );    
    ram1 ram1(
        .clka(clk_reverse),
        .wea(memwriteM[1]),
        .addra(alu_outM[15:2]),
        .dina(write_dataM[15:8]),
        .douta(read_dataM[15:8])
    );    
    ram2 ram2(
        .clka(clk_reverse),
        .wea(memwriteM[2]),
        .addra(alu_outM[15:2]),
        .dina(write_dataM[23:16]),
        .douta(read_dataM[23:16])
    );
    ram3 ram3(
        .clka(clk_reverse),
        .wea(memwriteM[3]),
        .addra(alu_outM[15:2]),
        .dina(write_dataM[31:24]),
        .douta(read_dataM[31:24])
    );
    
    //寄存器：存alu_outM
    dff_32 alu_out_reg(
        .d(alu_outM),
        .clk(clk),
        .clrn(clrn),
        .q(alu_outW)
    );
    
    //寄存器：存read_dataW
    dff_32 read_data_reg(
        .d(read_dataM),
        .clk(clk),
        .clrn(clrn),
        .q(read_dataW)
    );

    //寄存器：存write_regM,regwriteM,mem2regM,
    wire [31:0] write_regW_32;
    dff_32 write_reg_reg(
        .d({25'b0,regwriteM,mem2regM,write_regM}),
        .clk(clk),
        .clrn(clrn),
        .q(write_regW_32)
    );
    assign write_regW = write_regW_32[4:0];
    assign mem2regW = write_regW_32[5];
    assign regwriteW = write_regW_32[6];
    
endmodule
