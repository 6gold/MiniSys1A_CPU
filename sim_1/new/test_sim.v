`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/19 22:55:00
// Design Name: 
// Module Name: test_sim
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


module test_sim();
    reg [31:0] alu_a = 0,alu_b = 0;
    wire [31:0] q;
//   wire cf,of,zf;

    reg [31:0] instruction=0;
    wire op_add,op_addu,op_sub,op_subu,op_mult,op_multu,op_div,op_divu,//8条加减乘除指令信号
    op_and,op_or,op_xor,op_nor,op_addi,op_addiu,op_andi,op_ori,op_xori,op_lui,//10条逻辑运算指令信号 
    op_sll,op_srl,op_sra,op_sllv,op_srlv,op_srav,//6条移位指令信号
    op_lb,op_lbu,op_lh,op_lhu,op_lw,op_sb,op_sh,op_sw,//8条数据加载与存储指令信号
    op_beq,op_bne,op_slt,op_slti,op_sltu,op_sltiu,op_bgez,op_bgtz,op_blez,op_bltz,op_bgezal,op_bltzal,//12条条件转移指令信号
    op_j,op_jr,op_jal,op_jalr,//4条无条件转移指令信号
    op_mfhi,op_mflo,op_mthi,op_mtlo,//数据传送指令信号
    op_break,op_syscall,//异常指令信号
    op_eret,op_mfc0,op_mtc0;//特权指令信号
    
    /* 测试用：ALUctr */
        wire [3:0] ALUctr;
        wire SUBctr,OVctr,SIGctr,RIGHTctr,ARITHctr;  
        wire [2:0] OPctr;
        wire [31:0] add_res,and_res,or_res,xor_res,nor_res,lui_res,comp_res,shift_res;

    alu_32 alu_32(
        /* input */
        //操作数
        .alu_a(alu_a), .alu_b(alu_b),
        //与ALU相关的指令信号
        .op_add(op_add), .op_addu(op_addu), .op_sub(op_sub), .op_subu(op_subu),
        .op_addi(op_addi), .op_addiu(op_addiu),
        .op_lb(op_lb), .op_lbu(op_lbu), .op_lh(op_lh), .op_lhu(op_lhu),
        .op_lw(op_lw), .op_sb(op_sb), .op_sh(op_sh), .op_sw(op_sw),
        .op_and(op_and), .op_or(op_or), .op_xor(op_xor), .op_nor(op_nor),
        .op_andi(op_andi), .op_ori(op_ori), .op_xori(op_xori), .op_lui(op_lui),
        .op_sll(op_sll), .op_srl(op_srl), .op_sra(op_sra),
        .op_sllv(op_sllv), .op_srlv(op_srlv), .op_srav(op_srav),
        .op_beq(op_beq), .op_bne(op_bne),
        .op_slt(op_slt), .op_slti(op_slti), .op_sltu(op_sltu), .op_sltiu(op_sltiu),
 
        /* output */
        .q(q),                      //运算结果
    //        cf(), of(), zf()    //借位和溢出
        //测试用
        .ALUctr(ALUctr),
        .OPctr(OPctr),
        .SUBctr(SUBctr),
        .OVctr(OVctr),
        .SIGctr(SIGctr),
        .RIGHTctr(RIGHTctr),
        .ARITHctr(ARITHctr),
        .add_res(add_res),
        .and_res(and_res),
        .or_res(or_res),
        .xor_res(xor_res),
        .nor_res(nor_res),
        .lui_res(lui_res),
        .comp_res(comp_res),
        .shift_res(shift_res)
     );
 
     decoder de(
         .instruction(instruction),//输入指令
         .op_add(op_add),
         .op_addu(op_addu),
         .op_sub(op_sub),
         .op_subu(op_subu),
         .op_mult(op_mult),
         .op_multu(op_multu),
         .op_div(op_div),
         .op_divu(op_divu),//8条加减乘除指令信号
         .op_and(op_and),
         .op_or(op_or),
         .op_xor(op_xor),
         .op_nor(op_nor),
         .op_addi(op_addi),
         .op_addiu(op_addiu),
         .op_andi(op_andi),
         .op_ori(op_ori),
         .op_xori(op_xori),
         .op_lui(op_lui),//10条逻辑运算指令信号 
         .op_sll(op_sll),
         .op_srl(op_srl),
         .op_sra(op_sra),
         .op_sllv(op_sllv),
         .op_srlv(op_srlv),
         .op_srav(op_srav),//6条移位指令信号
         .op_lb(op_lb),
         .op_lbu(op_lbu),
         .op_lh(op_lh),
         .op_lhu(op_lhu),
         .op_lw(op_lw),
         .op_sb(op_sb),
         .op_sh(op_sh),
         .op_sw(op_sw),//8条数据加载与存储指令信号
         .op_beq(op_beq),
         .op_bne(op_bne),
         .op_slt(op_slt),
         .op_slti(op_slti),
         .op_sltu(op_sltu),
         .op_sltiu(op_sltiu),
         .op_bgez(op_bgez),
         .op_bgtz(op_bgtz),
         .op_blez(op_blez),
         .op_bltz(op_bltz),
         .op_bgezal(op_bgezal),
         .op_bltzal(op_bltzal),//12条条件转移指令信号
         .op_j(op_j),
         .op_jr(op_jr),
         .op_jal(op_jal),
         .op_jalr(op_jalr),//4条无条件转移指令信号
         .op_mfhi(op_mfhi),
         .op_mflo(op_mflo),
         .op_mthi(op_mthi),
         .op_mtlo(op_mtlo),//数据传送指令信号
         .op_break(op_break),
         .op_syscall(op_syscall),//异常指令信号
         .op_eret(op_eret),
         .op_mfc0(op_mfc0),
         .op_mtc0(op_mtc0)//特权指令信号
     );
     
     always begin
//     #10 instruction = {6'b000001 ,20'b0,6'b000000};
//     #10 instruction = {6'b000001 ,20'b0,6'b000000};
//     #10 instruction = {6'b010000 ,20'b0,6'b011000};
     #10 instruction[31:26]=6'b000000;//add
         instruction[5:0]  =6'b100000;
         alu_a = -2;
         alu_b = 2;
     #10 instruction[31:26]=6'b000000;//addu
         instruction[5:0]  =6'b100001;
         alu_a = 2;
         alu_b = 2;
     #10 instruction[31:26]=6'b000000;//sub
         instruction[5:0]  =6'b100010;
         alu_a = 0;
         alu_b = -1;
     #10 instruction[31:26]=6'b000000;//subu
         instruction[5:0]  =6'b100011;
         alu_a = 2;
         alu_b = 2;
     #10 instruction[31:26]=6'b000000;//and
         instruction[5:0]  =6'b100100;
         alu_a = 0;
         alu_b = 32'hffffffff;
//     #10 instruction = {6'b0 ,20'b0,6'b011000};
//     #10 instruction = {6'b0 ,20'b0,6'b011001};
//     #10 instruction = {6'b0 ,20'b0,6'b011010};
//     #10 instruction = {6'b0 ,20'b0,6'b011011};
//     #10 instruction = {6'b0 ,20'b0,6'b010000};
//     #10 instruction = {6'b0 ,20'b0,6'b010010};
//     #10 instruction = {6'b0 ,20'b0,6'b010001};
//     #10 instruction = {6'b0 ,20'b0,6'b010011};
//     #10 instruction = {6'b0 ,20'b0,6'b000000};
//     #10 instruction = {6'b0 ,20'b0,6'b0};
     #10 instruction[31:26]=6'b000000;//or
         instruction[5:0]  =6'b100101;
         alu_a = 0;
         alu_b = 32'hffffffff;
     #10 instruction[31:26]=6'b000000;//xor
         instruction[5:0]  =6'b100110;
         alu_a = 5;
         alu_b = 2;
     #10 instruction[31:26]=6'b000000;//nor
         instruction[5:0]  =6'b100111;
         alu_a = 5;
         alu_b = 2;
     #10 instruction[31:26]=6'b000000;//slt
         instruction[5:0]  =6'b101010;
         alu_a = -1;
         alu_b = 0;
     #10 instruction[31:26]=6'b000000;//sltu
         instruction[5:0]  =6'b101011;
         alu_a = 5;
         alu_b = 2;
     #10 instruction[31:26]=6'b000000;//sll
         instruction[5:0]  =6'b000000;
         alu_a = 1;
         alu_b = 1;
     #10 instruction[31:26]=6'b000000;//srl
         instruction[5:0]  =6'b000010;
         alu_a = 2;
         alu_b = 1;
     #10 instruction[31:26]=6'b000000;//sra
         instruction[5:0]  =6'b000011;
         alu_a = 32'h80000000;
         alu_b = 1;
//     #10 instruction[31:26]=6'b000000;
//         instruction[5:0]  =6'b000100;
//     #10 instruction[31:26]=6'b000000;
//         instruction[5:0]  =6'b000110;
//     #10 instruction[31:26]=6'b000000;
//         instruction[5:0]  =6'b000111;
//     #10 instruction[31:26]=6'b000000;
//         instruction[5:0]  =6'b001000;
//     #10 instruction[31:26]=6'b000000;
//         instruction[5:0]  =6'b001001;
//     #10 instruction[31:26]=6'b000000;
//         instruction[5:0]  =6'b001101;
//     #10 instruction[31:26]=6'b000000;
//         instruction[5:0]  =6'b001100;
//     #10 instruction[31:26]=6'b000000;
//         instruction[5:0]  =6'b011000;   //i
//     #10 instruction = {6'b001000 ,26'b0};      
//     #10 instruction = {6'b001001 ,20'b0,6'b0};
//     #10 instruction = {6'b001100 ,20'b0,6'b0};
//     #10 instruction = {6'b001101 ,20'b0,6'b0};
//     #10 instruction = {6'b001110 ,20'b0,6'b0};
     #10 instruction = {6'b001111 ,20'b0,6'b0};//lui
         alu_a = 0;
         alu_b = 32'h0000ffff;
//     #10 instruction = {6'b100000 ,20'b0,6'b0};
//     #10 instruction = {6'b100100 ,20'b0,6'b0};
//     #10 instruction = {6'b100001 ,20'b0,6'b0};
//     #10 instruction = {6'b100101 ,20'b0,6'b0};
//     #10 instruction = {6'b101000 ,20'b0,6'b0};
//     #10 instruction = {6'b101001 ,20'b0,6'b0};
//     #10 instruction = {6'b100011 ,20'b0,6'b0};
//     #10 instruction = {6'b101011 ,20'b0,6'b0};
//     #10 instruction = {6'b000100 ,20'b0,6'b0};
//     #10 instruction = {6'b000101 ,20'b0,6'b0};
//     #10 instruction = {6'b000001 ,20'b0,6'b0};
//     #10 instruction = {6'b000111 ,20'b0,6'b0};
//     #10 instruction = {6'b000110 ,20'b0,6'b0};
//     #10 instruction = {6'b000001 ,20'b0,6'b0};
//     #10 instruction = {6'b000001 ,20'b0,6'b0};
//     #10 instruction = {6'b001010 ,20'b0,6'b0};
//     #10 instruction = {6'b001011 ,20'b0,6'b0};
//     #10 instruction = {6'b000010 ,20'b0,6'b0};
//     #10 instruction = {6'b000011 ,20'b0,6'b0};
 
     end
endmodule
