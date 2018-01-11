`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module MinisysMEM_sim();
    reg clk=1,clrn=0;
    reg [3:0] memwriteM=0;
    reg [31:0] alu_outM=0,write_dataM=0;
    reg op_lbM=0,op_lbuM=0,op_lhM=0,op_lhuM=0,op_lwM=0;
    wire clk_reverse;
    wire [31:0] in0,in1,read_dataM;    
    wire [7:0] read_data3,read_data2,read_data1,read_data0;
    MinisysMEM MinisysMEM(
        .clk(clk),.clrn(clrn),
        .clk_reverse(clk_reverse),
        .memwriteM(memwriteM),
        .alu_outM(alu_outM),.write_dataM(write_dataM),.in0(in0),.in1(in1),.read_dataM(read_dataM),
        .op_lbM(op_lbM),.op_lbuM(op_lbuM),.op_lhM(op_lhM),.op_lhuM(op_lhuM),.op_lwM(op_lwM),
        .read_data3(read_data3),.read_data2(read_data2),.read_data1(read_data1),.read_data0(read_data0)       
    );
    
    initial begin
    #5 clrn=1;
    forever
    #5 clk = ~clk;
    end
//    always begin
//    #20 memwriteM=4'b1111;
//        write_dataM=32'hffffffff;        
//    end
    
endmodule
