`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: decoder
// Description: ָ��������
//////////////////////////////////////////////////////////////////////////////////

module decoder(
 //   instruction,//����ָ��
    op,func,
    op_add,op_addu,op_sub,op_subu,op_mult,op_multu,op_div,op_divu,//8���Ӽ��˳�ָ���ź�
    op_and,op_or,op_xor,op_nor,op_addi,op_addiu,op_andi,op_ori,op_xori,op_lui,//10���߼�����ָ���ź� 
    op_sll,op_srl,op_sra,op_sllv,op_srlv,op_srav,//6����λָ���ź�
    op_lb,op_lbu,op_lh,op_lhu,op_lw,op_sb,op_sh,op_sw,//8�����ݼ�����洢ָ���ź�
    op_beq,op_bne,op_slt,op_slti,op_sltu,op_sltiu,op_bgez,op_bgtz,op_blez,op_bltz,op_bgezal,op_bltzal,//12������ת��ָ���ź�
    op_j,op_jr,op_jal,op_jalr,//4��������ת��ָ���ź�
    op_mfhi,op_mflo,op_mthi,op_mtlo,//���ݴ���ָ���ź�
    op_break,op_syscall,//�쳣ָ���ź�
    op_eret,op_mfc0,op_mtc0//��Ȩָ���ź�
    );
  //  input [31:0] instruction;
    input wire [5:0] op,func;
    /* һ��57��ָ�� */
    //8���Ӽ��˳�ָ��
    output op_add,op_addu,op_sub,op_subu,op_mult,op_multu,op_div,op_divu;
    //10���߼�����ָ��
    output op_and,op_or,op_xor,op_nor,op_addi,op_addiu,op_andi,op_ori,op_xori,op_lui;
    //6����λָ��
    output op_sll,op_srl,op_sra,op_sllv,op_srlv,op_srav;
    //8�����ݼ�����洢ָ��
    output op_lb,op_lbu,op_lh,op_lhu,op_lw,op_sb,op_sh,op_sw;
    //12������ת��ָ��
    output op_beq,op_bne,op_slt,op_slti,op_sltu,op_sltiu,op_bgez,op_bgtz,op_blez,op_bltz,op_bgezal,op_bltzal;
    //4��������ת��ָ��
    output op_j,op_jr,op_jal,op_jalr;
    //4�����ݴ���ָ��
    output op_mfhi,op_mflo,op_mthi,op_mtlo;
    //2���쳣ָ��
    output op_break,op_syscall;
    //3����Ȩָ��
    output op_eret,op_mfc0,op_mtc0;
    
 //   wire [4:0] rs,rt;
 //   wire [5:0] op,func;
    wire nop;
    
//    assign rs   = instruction[25:21];
//    assign rt   = instruction[20:16];
//    assign op   = instruction[31:26];
//    assign func = instruction[5:0];
    
    //R��ָ��
    assign nop    =    ~op[5] & ~op[4] & ~op[3] & ~op[2] & ~op[1] & ~op[0];//000000
    
    assign op_add   = nop & func[5] & ~func[4] & ~func[3] & ~func[2] & ~func[1] & ~func[0];    //100000
    assign op_addu  = nop & func[5] & ~func[4] & ~func[3] & ~func[2] & ~func[1] &  func[0];    //100001
    assign op_sub   = nop & func[5] & ~func[4] & ~func[3] & ~func[2] &  func[1] & ~func[0];    //100010
    assign op_subu  = nop & func[5] & ~func[4] & ~func[3] & ~func[2] &  func[1] &  func[0];    //100011
    assign op_and   = nop & func[5] & ~func[4] & ~func[3] &  func[2] & ~func[1] & ~func[0];    //100100
    
    assign op_mult  = nop & ~func[5] & func[4] & func[3] & ~func[2] & ~func[1] & ~func[0];    //011000
    assign op_multu = nop & ~func[5] & func[4] & func[3] & ~func[2] & ~func[1] &  func[0];    //011001
    assign op_div   = nop & ~func[5] & func[4] & func[3] & ~func[2] &  func[1] & ~func[0];    //011010
    assign op_divu  = nop & ~func[5] & func[4] & func[3] & ~func[2] &  func[1] &  func[0];    //011011
    
    assign op_mfhi  = nop & ~func[5] & func[4] & ~func[3] & ~func[2] & ~func[1] & ~func[0];    //010000
    assign op_mflo  = nop & ~func[5] & func[4] & ~func[3] & ~func[2] &  func[1] & ~func[0];    //010010
    assign op_mthi  = nop & ~func[5] & func[4] & ~func[3] & ~func[2] & ~func[1] &  func[0];    //010001
    assign op_mtlo  = nop & ~func[5] & func[4] & ~func[3] & ~func[2] &  func[1] &  func[0];    //010011
    
//    assign op_mfc0  = nop & ~func[5] & func[4] & ~func[3] & ~func[2] & ~func[1] & ~func[0] & ~rs[4] & ~rs[3] & ~rs[2] & ~rs[1] & ~rs[0];//010000  00000(rs)
//    assign op_mtc0  = nop & ~func[5] & func[4] & ~func[3] & ~func[2] & ~func[1] & ~func[0] & ~rs[4] & ~rs[3] &  rs[2] & ~rs[1] & ~rs[0];//010000  00100(rs)
    
    assign op_or    = nop & func[5] & ~func[4] & ~func[3] & func[2] & ~func[1] &  func[0];    //100101
    assign op_xor   = nop & func[5] & ~func[4] & ~func[3] & func[2] &  func[1] & ~func[0];    //100110
    assign op_nor   = nop & func[5] & ~func[4] & ~func[3] & func[2] &  func[1] &  func[0];    //100111
    
    assign op_slt   = nop & func[5] & ~func[4] & func[3] & ~func[2] & func[1] & ~func[0];    //101010
    assign op_sltu  = nop & func[5] & ~func[4] & func[3] & ~func[2] & func[1] &  func[0];    //101011
    
    assign op_sll   = nop & ~func[5] & ~func[4] & ~func[3] & ~func[2] & ~func[1] & ~func[0];//000000
    assign op_srl   = nop & ~func[5] & ~func[4] & ~func[3] & ~func[2] &  func[1] & ~func[0];//000010
    assign op_sra   = nop & ~func[5] & ~func[4] & ~func[3] & ~func[2] &  func[1] &  func[0];//000011
    assign op_sllv  = nop & ~func[5] & ~func[4] & ~func[3] &  func[2] & ~func[1] & ~func[0];//000100
    assign op_srlv  = nop & ~func[5] & ~func[4] & ~func[3] &  func[2] &  func[1] & ~func[0];//000110
    assign op_srav  = nop & ~func[5] & ~func[4] & ~func[3] &  func[2] &  func[1] &  func[0];//000111
    
    assign op_jr    = nop & ~func[5] & ~func[4] & func[3] & ~func[2] & ~func[1] & ~func[0];    //001000
    assign op_jalr  = nop & ~func[5] & ~func[4] & func[3] & ~func[2] & ~func[1] &  func[0];    //001001
    
    assign op_break  = nop & ~func[5] & ~func[4] & func[3] & func[2] & ~func[1] &  func[0];    //001101
    assign op_syscall= nop & ~func[5] & ~func[4] & func[3] & func[2] & ~func[1] & ~func[0];    //001100
    
    assign op_eret   = ~op[5] & op[4] & ~op[3] & ~op[2] & ~op[1] & ~op[0] 
                    & ~func[5] & func[4] & func[3] & ~func[2] & ~func[1] & ~func[0];//010000  011000
    
    //I��ָ��
    assign op_addi  = ~op[5] & ~op[4] & op[3] & ~op[2] & ~op[1] & ~op[0];    //001000
    assign op_addiu = ~op[5] & ~op[4] & op[3] & ~op[2] & ~op[1] &  op[0];    //001001
    assign op_andi  = ~op[5] & ~op[4] & op[3] &  op[2] & ~op[1] & ~op[0];    //001100
    assign op_ori   = ~op[5] & ~op[4] & op[3] &  op[2] & ~op[1] &  op[0];    //001101
    assign op_xori  = ~op[5] & ~op[4] & op[3] &  op[2] &  op[1] & ~op[0];    //001110
    assign op_lui   = ~op[5] & ~op[4] & op[3] &  op[2] &  op[1] &  op[0];    //001111
    
    assign op_lb    = op[5] & ~op[4]& ~op[3] & ~op[2] & ~op[1] & ~op[0];    //100000
    assign op_lbu   = op[5] & ~op[4]& ~op[3] &  op[2] & ~op[1] & ~op[0];    //100100
    assign op_lh    = op[5] & ~op[4]& ~op[3] & ~op[2] & ~op[1] &  op[0];    //100001
    assign op_lhu   = op[5] & ~op[4]& ~op[3] &  op[2] & ~op[1] &  op[0];    //100101
    
    assign op_sb    = op[5] & ~op[4] & op[3] & ~op[2] & ~op[1] & ~op[0];    //101000
    assign op_sh    = op[5] & ~op[4] & op[3] & ~op[2] & ~op[1] &  op[0];    //101001
    
    assign op_lw    = op[5] & ~op[4] & ~op[3] & ~op[2] & op[1] & op[0];        //100011
    assign op_sw    = op[5] & ~op[4] &  op[3] & ~op[2] & op[1] & op[0];        //101011
    
    assign op_beq   = ~op[5] & ~op[4] & ~op[3] &  op[2] & ~op[1] & ~op[0];    //000100
    assign op_bne   = ~op[5] & ~op[4] & ~op[3] &  op[2] & ~op[1] &  op[0];    //000101
    assign op_bgez  = ~op[5] & ~op[4] & ~op[3] & ~op[2] & ~op[1] &  op[0];    //000001
    assign op_bgtz  = ~op[5] & ~op[4] & ~op[3] &  op[2] &  op[1] &  op[0];    //000111
    assign op_blez  = ~op[5] & ~op[4] & ~op[3] &  op[2] &  op[1] & ~op[0];    //000110
    
    assign op_bltz   = ~op[5] & ~op[4] & ~op[3] & ~op[2] & ~op[1] & op[0] ;//000001   
    assign op_bgezal = ~op[5] & ~op[4] & ~op[3] & ~op[2] & ~op[1] & op[0] ;//000001    
    assign op_bltzal = ~op[5] & ~op[4] & ~op[3] & ~op[2] & ~op[1] & op[0] ;//000001 
    
    assign op_slti   = ~op[5] & ~op[4] & op[3] & ~op[2] & op[1] & ~op[0];    //001010
    assign op_sltiu  = ~op[5] & ~op[4] & op[3] & ~op[2] & op[1] &  op[0];    //001011
    
    //J��ָ��
    assign op_j    = ~op[5] & ~op[4] & ~op[3] & ~op[2] & op[1] & ~op[0];    //000010
    assign op_jal  = ~op[5] & ~op[4] & ~op[3] & ~op[2] & op[1] &  op[0];    //000011
endmodule
