`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: 运算器顶层文件
//////////////////////////////////////////////////////////////////////////////////

module alu_32(
    /* input */
    //操作数
    alu_a,alu_b,alu_control,
    //与ALU相关的指令信号
//    op_add,op_addu,op_sub,op_subu,op_addi,op_addiu,//6条加减乘除指令信号
//    op_lb,op_lbu,op_lh,op_lhu,op_lw,op_sb,op_sh,op_sw,//8条数据加载与存储指令信号
//    op_and,op_or,op_xor,op_nor,op_andi,op_ori,op_xori,op_lui,//8条逻辑运算指令信号 
//    op_sll,op_srl,op_sra,op_sllv,op_srlv,op_srav,//6条移位指令信号
//    op_beq,op_bne,op_slt,op_slti,op_sltu,op_sltiu,//6条比较指令信号

    /* output */
    q,//运算结果
    cf,of,zf,//借位和溢出
    //测试用
//    ALUctr,OPctr,SUBctr,OVctr,SIGctr,RIGHTctr,ARITHctr,
//    add_res,and_res,or_res,xor_res,nor_res,lui_res,comp_res,shift_res
    );
    
    input [31:0] alu_a,alu_b;   //操作数
    input [3:0] alu_control;
    output [31:0] q;            //运算结果
    output cf,of,zf;
//    input op_add,op_addu,op_sub,op_subu,op_addi,op_addiu,//6条加减乘除指令信号
//        op_lb,op_lbu,op_lh,op_lhu,op_lw,op_sb,op_sh,op_sw,//8条数据加载与存储指令信号
//        op_and,op_or,op_xor,op_nor,op_andi,op_ori,op_xori,op_lui,//8条逻辑运算指令信号 
//        op_sll,op_srl,op_sra,op_sllv,op_srlv,op_srav,//6条移位指令信号
//        op_beq,op_bne,op_slt,op_slti,op_sltu,op_sltiu;//6条比较指令信号
    //测试用
//    output [3:0] ALUctr;
//    output [2:0] OPctr;
//    output SUBctr,OVctr,SIGctr,RIGHTctr,ARITHctr;
//    output [31:0] add_res,and_res,or_res,xor_res,nor_res,lui_res,comp_res,shift_res;
    
    /* ALUctr */
    wire [3:0] ALUctr;
    wire SUBctr,OVctr,SIGctr,RIGHTctr,ARITHctr;  
    wire [2:0] OPctr;
    assign ALUctr[3] = alu_control[3];
    assign ALUctr[2] = alu_control[2];
    assign ALUctr[1] = alu_control[1];
    assign ALUctr[0] = alu_control[0];
//    assign ALUctr[3] = op_subu|op_beq|op_bne|op_sub|op_srl|op_srlv|op_sra|op_srav|op_slt|op_slti|op_sltu|op_sltiu;
//    assign ALUctr[2] = op_addu|op_addiu|op_lw|op_lb|op_lbu|op_lh|op_lhu|op_sb|op_sh|op_sw|op_xor|op_xori|op_nor|op_srl|op_srlv|op_sra|op_srav|op_lui;
//    assign ALUctr[1] = op_add|op_addi|op_addu|op_addiu|op_lw|op_lb|op_lbu|op_lh|op_lhu|op_sb|op_sh|op_sw|op_subu|op_beq|op_bne|op_sub|op_or|op_ori|op_xor|op_xori;
//    assign ALUctr[0] = op_subu|op_beq|op_bne|op_or|op_ori|op_xor|op_xori|op_sll|op_sllv|op_srl|op_srlv|op_lui|op_sltu|op_sltiu;
    
    assign SUBctr   = ALUctr[3] & ~ALUctr[2];
    assign OVctr    = ~ALUctr[2] & ALUctr[1] & ~ALUctr[0];
    assign SIGctr   = ALUctr[3] & ~ALUctr[2] & ~ALUctr[1] & ~ALUctr[0];
    assign RIGHTctr = ALUctr[3] & ALUctr[2] & ~ALUctr[1];
    assign ARITHctr = ALUctr[3] & ALUctr[2] & ~ALUctr[1] & ~ALUctr[0];
    
    assign OPctr[2] = (ALUctr[3] & ~ALUctr[1]) | (ALUctr[2] & ~ALUctr[1]) | (~ALUctr[1] & ALUctr[0]); 
    assign OPctr[1] = (ALUctr[3] & ~ALUctr[1]) | (~ALUctr[3] & ALUctr[1] & ALUctr[0]) | (~ALUctr[3] & ~ALUctr[2] & ALUctr[0]);
    assign OPctr[0] = (~ALUctr[3] & ~ALUctr[2] & ~ALUctr[1]) | (~ALUctr[3] & ALUctr[2] & ALUctr[0]) | (ALUctr[3] & ALUctr[2] & ~ALUctr[1]);
        
    /* 逻辑运算 */
    //op_and,op_or,op_xor,op_nor,op_andi,op_ori,op_xori,op_lui,
    wire [31:0] and_res,or_res,nor_res,xor_res;
    assign and_res = alu_a & alu_b;
    assign or_res = alu_a|alu_b;
    assign nor_res = ~(alu_a|alu_b);
    assign xor_res = alu_a^alu_b;
    
    //完成lui指令
    wire [31:0] lui_res;
    assign alu_b = {alu_b[15:0],16'b0}; 
    
    //桶型移位器例化
    //完成op_sll,op_srl,op_sra,op_sllv,op_srlv,op_srav功能
    wire [31:0] shift_res;
    barrelshifter32 shiftLR(
        .a(alu_b),
        .b(alu_a),
        .ctr({RIGHTctr,ARITHctr}),
        .d(shift_res)
    );
    
    //加减法器例化
    //完成op_add,op_addu,op_sub,op_subu,op_addi,op_addiu功能
    wire [31:0] add_res;
    wire add_of;
    addsub_32 addsub(
        .a(alu_a),
        .b(alu_b),
        .sub_ctrl(SUBctr), 
        .s(add_res),
        .cf(cf),
        .of(add_of)
    );
    assign zf = (add_res == 32'b0) ? 1 : 0;
    assign of = OVctr & add_of;
    
    //比较模块
    wire temp;
    wire [31:0] comp_res; 
    wire in_0,in_1;
    assign in_0 = SUBctr^cf;
    assign in_1 = add_of^add_res[31]; 
    assign temp = (SIGctr) ? in_1 : in_0;
    //选择结果为全0或者全1
    mux2_1 mux2_1(
        .in0(32'b0),
        .in1(32'hffffffff),
        .sel(temp),
        .out(comp_res)
    );
            
    //结果选择模块
    //0：加法器；1：and；2：or；3：xor；4：nor；5：lui；6：比较结果；7：桶型移位器  
    mux8_1 mux8_1(
        .in0(add_res),
        .in1(and_res),
        .in2(or_res),
        .in3(xor_res),
        .in4(nor_res),
        .in5(lui_res),
        .in6(comp_res),
        .in7(shift_res),
        .sel(OPctr),
        .out(q)
    );
    
endmodule