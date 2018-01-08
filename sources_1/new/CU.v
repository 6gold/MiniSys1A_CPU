`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: ���Ƶ�ԪCU
//////////////////////////////////////////////////////////////////////////////////


module CU(
    /* input */
    op,func,rt,
    /* output */
    regwriteD,mem2regD,memwriteD,jumpD,alucontrolD,alusrcD,regdstD,lwswD,
    op_lb,op_lbu,op_lh,op_lhu,op_lw,
    op_sll,op_srl,op_sra,
    write_$31,jump_rs,
    op_beq,op_bne,op_bgez,op_bgtz,op_blez,op_bltz,op_bgezal,op_bltzal,alu_md,md,
    op_mthi,op_mtlo,op_mfhi,op_mflo,
    );
    
    input [5:0] op,func;
    input [4:0] rt;
    output regwriteD,mem2regD,jumpD,alusrcD,regdstD,lwswD;
    output [3:0] alucontrolD,memwriteD;
    output op_lb,op_lbu,op_lh,op_lhu,op_lw;
    output op_sll,op_srl,op_sra;
    output write_$31,jump_rs;
    output op_beq,op_bne,op_bgez,op_bgtz,op_blez,op_bltz,op_bgezal,op_bltzal ;
    output [1:0] alu_md;
    output md;//��ʾ�ǳ˳���
    output op_mthi,op_mtlo,op_mfhi,op_mflo;
//    ��CU�ľ���ʵ�֡�
    /* һ��57��ָ�� */
	//8���Ӽ��˳�ָ��
	wire op_add,op_addu,op_sub,op_subu,op_mult,op_multu,op_div,op_divu;
	//10���߼�����ָ��
	wire op_and,op_or,op_xor,op_nor,op_addi,op_addiu,op_andi,op_ori,op_xori,op_lui;
	//6����λָ��
	wire op_sll,op_srl,op_sra,op_sllv,op_srlv,op_srav;
	//8�����ݼ�����洢ָ��
	wire op_lb,op_lbu,op_lh,op_lhu,op_lw,op_sb,op_sh,op_sw;
	//12������ת��ָ��
	wire op_beq,op_bne,op_slt,op_slti,op_sltu,op_sltiu,op_bgez,op_bgtz,op_blez,op_bltz,op_bgezal,op_bltzal;
	//4��������ת��ָ��
	wire op_j,op_jr,op_jal,op_jalr;
	//4�����ݴ���ָ��
	wire op_mfhi,op_mflo,op_mthi,op_mtlo;
	//2���쳣ָ��
	wire op_break,op_syscall;
	//3����Ȩָ��
	wire op_eret,op_mfc0,op_mtc0;
    decoder decoder(
    .op(op),.func(func),.rt(rt),
   // .instruction(instruction),//����ָ��
    .op_add(op_add),.op_addu(op_addu),.op_sub(op_sub),.op_subu(op_subu),.op_mult(op_mult),.op_multu(op_multu),
    .op_div(op_div),.op_divu(op_divu),//8���Ӽ��˳�ָ���ź�
    .op_and(op_and),.op_or(op_or),.op_xor(op_xor),.op_nor(op_nor),.op_addi(op_addi),.op_addiu(op_addiu),
    .op_andi(op_andi),.op_ori(op_ori),.op_xori(op_xori),.op_lui(op_lui),//10���߼�����ָ���ź� 
    .op_sll(op_sll),.op_srl(op_srl),.op_sra(op_sra),.op_sllv(op_sllv),.op_srlv(op_srlv),.op_srav(op_srav),//6����λָ���ź�
    .op_lb(op_lb),.op_lbu(op_lbu),.op_lh(op_lh),.op_lhu(op_lhu),.op_lw(op_lw),.op_sb(op_sb),.op_sh(op_sh),
    .op_sw(op_sw),//8�����ݼ�����洢ָ���ź�
    .op_beq(op_beq),.op_bne(op_bne),.op_slt(op_slt),.op_slti(op_slti),.op_sltu(op_sltu),.op_sltiu(op_sltiu),
    .op_bgez(op_bgez),.op_bgtz(op_bgtz),.op_blez(op_blez),.op_bltz(op_bltz),.op_bgezal(op_bgezal),.op_bltzal(op_bltzal),//12������ת��ָ���ź�
    .op_j(op_j),.op_jr(op_jr),.op_jal(op_jal),.op_jalr(op_jalr),//4��������ת��ָ���ź�
    .op_mfhi(op_mfhi),.op_mflo(op_mflo),.op_mthi(op_mthi),.op_mtlo(op_mtlo),//���ݴ���ָ���ź�
    .op_break(op_break),.op_syscall(op_syscall),//�쳣ָ���ź�
    .op_eret(op_eret),.op_mfc0(op_mfc0),.op_mtc0(op_mtc0)//��Ȩָ���ź�
    );
    
    assign regwireD = op_add | op_addi | op_addu | op_addiu | op_lw | op_lb | op_lbu | op_lh | op_lhu | op_subu | op_and 
                      | op_andi | op_or | op_ori | op_xor | op_xori | op_nor | op_sll | op_sllv | op_srl | op_srlv | op_sra
                      | op_srav | op_lui | op_slt | op_slti | op_sltu | op_sltiu | op_jal | op_bgezal | op_bltzal | op_mfhi
                      | op_mflo | op_mfc0 | op_jalr ;
   //ѡ����������ΪaluB����
    assign alusrcD = op_addi | op_addiu | op_lw | op_lb | op_lbu | op_lh | op_lhu | op_sb | op_sh | op_sw | op_addi | op_ori
                     | op_xori | op_slti | op_sltiu ;
    //����д��rt                 
    assign regdstD = op_addi | op_addiu | op_lw | op_lb | op_lbu | op_lh | op_lhu | op_andi | op_ori | op_xori | op_lui
                     | op_slti | op_sltiu | op_mfc0 ;
//    assign branchD = op_beq | op_bne | op_bgez | op_bgtz | op_blez | op_bltz | op_bgezal | op_bltzal ;
    assign jumpD = op_jr | op_j | op_jal | op_jalr ;
    assign jump_rs = op_jr | op_jalr;
    assign write_$31 = op_jal | op_jalr ;
    assign mem2regD = op_lw | op_lb | op_lbu | op_lh | op_lhu ;
    assign memwriteD[0] = op_sb | op_sh | op_sw ;
    assign memwriteD[1] = op_sh | op_sw ;
    assign memwriteD[2] = op_sw ;
    assign memwriteD[3] = op_sw ;
 //   assign lwswD = op_lw | op_sw ;
 //   assign lbsbD = op_lb | op_lbu | op_sb ;
 //   assign lhshD = op_lh | op_lhu | op_sh ;    
    assign alucontrolD[3] = op_subu|op_beq|op_bne|op_sub|op_srl|op_srlv|op_sra|op_srav|op_slt|op_slti|op_sltu|op_sltiu;
    assign alucontrolD[2] = op_addu|op_addiu|op_lw|op_lb|op_lbu|op_lh|op_lhu|op_sb|op_sh|op_sw|op_xor|op_xori|op_nor|op_srl|op_srlv|op_sra|op_srav|op_lui;
    assign alucontrolD[1] = op_add|op_addi|op_addu|op_addiu|op_lw|op_lb|op_lbu|op_lh|op_lhu|op_sb|op_sh|op_sw|op_subu|op_beq|op_bne|op_sub|op_or|op_ori|op_xor|op_xori;
    assign alucontrolD[0] = op_subu|op_beq|op_bne|op_or|op_ori|op_xor|op_xori|op_sll|op_sllv|op_srl|op_srlv|op_lui|op_sltu|op_sltiu;
    
    reg [1:0] alu_md;
    always @ (*)begin
      case({op_mult,op_multu,op_div,op_divu})
      4'b1000:alu_md=2'b00;
      4'b0100:alu_md=2'b01;
      4'b0010:alu_md=2'b10;
      4'b0001:alu_md=2'b11;
      default:alu_md=2'b00;
      endcase
    end    
    
    assign md = op_mult|op_multu|op_div|op_divu;
endmodule
