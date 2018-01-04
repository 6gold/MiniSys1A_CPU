`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: �����������ļ�
//////////////////////////////////////////////////////////////////////////////////

module alu_32(
    /* input */
    //������
    alu_a,alu_b,alu_control,
    //��ALU��ص�ָ���ź�
//    op_add,op_addu,op_sub,op_subu,op_addi,op_addiu,//6���Ӽ��˳�ָ���ź�
//    op_lb,op_lbu,op_lh,op_lhu,op_lw,op_sb,op_sh,op_sw,//8�����ݼ�����洢ָ���ź�
//    op_and,op_or,op_xor,op_nor,op_andi,op_ori,op_xori,op_lui,//8���߼�����ָ���ź� 
//    op_sll,op_srl,op_sra,op_sllv,op_srlv,op_srav,//6����λָ���ź�
//    op_beq,op_bne,op_slt,op_slti,op_sltu,op_sltiu,//6���Ƚ�ָ���ź�

    /* output */
    q,//������
    cf,of,zf,//��λ�����
    //������
//    ALUctr,OPctr,SUBctr,OVctr,SIGctr,RIGHTctr,ARITHctr,
//    add_res,and_res,or_res,xor_res,nor_res,lui_res,comp_res,shift_res
    );
    
    input [31:0] alu_a,alu_b;   //������
    input [3:0] alu_control;
    output [31:0] q;            //������
    output cf,of,zf;
//    input op_add,op_addu,op_sub,op_subu,op_addi,op_addiu,//6���Ӽ��˳�ָ���ź�
//        op_lb,op_lbu,op_lh,op_lhu,op_lw,op_sb,op_sh,op_sw,//8�����ݼ�����洢ָ���ź�
//        op_and,op_or,op_xor,op_nor,op_andi,op_ori,op_xori,op_lui,//8���߼�����ָ���ź� 
//        op_sll,op_srl,op_sra,op_sllv,op_srlv,op_srav,//6����λָ���ź�
//        op_beq,op_bne,op_slt,op_slti,op_sltu,op_sltiu;//6���Ƚ�ָ���ź�
    //������
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
        
    /* �߼����� */
    //op_and,op_or,op_xor,op_nor,op_andi,op_ori,op_xori,op_lui,
    wire [31:0] and_res,or_res,nor_res,xor_res;
    assign and_res = alu_a & alu_b;
    assign or_res = alu_a|alu_b;
    assign nor_res = ~(alu_a|alu_b);
    assign xor_res = alu_a^alu_b;
    
    //���luiָ��
    wire [31:0] lui_res;
    assign alu_b = {alu_b[15:0],16'b0}; 
    
    //Ͱ����λ������
    //���op_sll,op_srl,op_sra,op_sllv,op_srlv,op_srav����
    wire [31:0] shift_res;
    barrelshifter32 shiftLR(
        .a(alu_b),
        .b(alu_a),
        .ctr({RIGHTctr,ARITHctr}),
        .d(shift_res)
    );
    
    //�Ӽ���������
    //���op_add,op_addu,op_sub,op_subu,op_addi,op_addiu����
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
    
    //�Ƚ�ģ��
    wire temp;
    wire [31:0] comp_res; 
    wire in_0,in_1;
    assign in_0 = SUBctr^cf;
    assign in_1 = add_of^add_res[31]; 
    assign temp = (SIGctr) ? in_1 : in_0;
    //ѡ����Ϊȫ0����ȫ1
    mux2_1 mux2_1(
        .in0(32'b0),
        .in1(32'hffffffff),
        .sel(temp),
        .out(comp_res)
    );
            
    //���ѡ��ģ��
    //0���ӷ�����1��and��2��or��3��xor��4��nor��5��lui��6���ȽϽ����7��Ͱ����λ��  
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