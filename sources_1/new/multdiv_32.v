`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: multdiv_32
// Description: 32位乘除法器
//////////////////////////////////////////////////////////////////////////////////

module multdiv_32(
    clk,rst,
    ALU_OP,ALU_A,ALU_B,ALU_HI,ALU_LO,
    MULTBUSY,DIVBUSY,MULTWRITE,DIVWRITE
    );
    
    input clk,rst;
    input [4:0] ALU_OP;                 //{divu,div,multu,mult}
    input [31:0] ALU_A,ALU_B;           //操作数
    output reg [31:0] ALU_HI,ALU_LO;    //运算结果输出，对于除法HI存放余数，LO存放商
    output reg MULTBUSY,DIVBUSY;        //忙检测控制信号
    output reg MULTWRITE,DIVWRITE;      //写使能控制信号
    
    //运算辅助
    wire [36:0] temp[31:0];             //乘法辅助信号线
    reg [62:0] temp1[31:0];             //除法辅助寄存器堆
    reg [3:0] state;                    //状态寄存器
    reg [37:0] result0,result1,result2,result3,result4; //乘法运算结果中间寄存器
    reg [33:0] result5;
    reg [31:0] A,B;
    reg sign,sig_remainder,sig_result;  //①sign:标记是有符号运算还是无符号运算;
                                        //②sig_remainder:余数的符号(由被除数的符号决定);
                                        //③sig_result:乘法结果符号和商的符号
    
    /* 对B分组后进行运算 */
    //组①：B[5:0] 每一位分别与A相乘（考虑移位）
    assign temp[0] = B[0]?{5'b0,A}:37'b0;
    assign temp[1] = B[1]?{4'b0,A,1'b0}:37'b0;
    assign temp[2] = B[2]?{3'b0,A,2'b0}:37'b0;
    assign temp[3] = B[3]?{2'b0,A,3'b0}:37'b0;
    assign temp[4] = B[4]?{1'b0,A,4'b0}:37'b0;
    assign temp[5] = B[5]?{A,5'b0}:37'b0;
    //组②：B[11:6]
    assign temp[6] = B[6]?{5'b0,A}:37'b0;
    assign temp[7] = B[7]?{4'b0,A,1'b0}:37'b0;
    assign temp[8] = B[8]?{3'b0,A,2'b0}:37'b0;
    assign temp[9] = B[9]?{2'b0,A,3'b0}:37'b0;
    assign temp[10]= B[10]?{1'b0,A,4'b0}:37'b0;
    assign temp[11]= B[11]?{A,5'b0}:37'b0;
    //组③：B[17:12]
    assign temp[12]= B[12]?{5'b0,A}:37'b0;
    assign temp[13]= B[13]?{4'b0,A,1'b0}:37'b0;
    assign temp[14]= B[14]?{3'b0,A,2'b0}:37'b0;
    assign temp[15]= B[15]?{2'b0,A,3'b0}:37'b0;
    assign temp[16]= B[16]?{1'b0,A,4'b0}:37'b0;
    assign temp[17]= B[17]?{A,5'b0}:37'b0;
    //组④：B[23:18]
    assign temp[18]= B[18]?{5'b0,A}:37'b0;
    assign temp[19]= B[19]?{4'b0,A,1'b0}:37'b0;
    assign temp[20]= B[20]?{3'b0,A,2'b0}:37'b0;
    assign temp[21]= B[21]?{2'b0,A,3'b0}:37'b0;
    assign temp[22]= B[22]?{1'b0,A,4'b0}:37'b0;
    assign temp[23]= B[23]?{A,5'b0}:37'b0;
    //组⑤：B[29:24]
    assign temp[24]= B[24]?{5'b0,A}:37'b0;
    assign temp[25]= B[25]?{4'b0,A,1'b0}:37'b0;
    assign temp[26]= B[26]?{3'b0,A,2'b0}:37'b0;
    assign temp[27]= B[27]?{2'b0,A,3'b0}:37'b0;
    assign temp[28]= B[28]?{1'b0,A,4'b0}:37'b0;
    assign temp[29]= B[29]?{A,5'b0}:37'b0;
    //组⑥：B[31:30]
    assign temp[30]= B[30]?{5'b0,A}:37'b0;
    assign temp[31]= B[31]?{4'b0,A,1'b0}:37'b0;
    
    always@(posedge clk or negedge rst)begin
        if(rst == 1'b0) begin
            state<=4'b0000;         //enter S0 in the next clk
            ALU_HI<=32'h00000000;   //结果寄存器初始化
            ALU_LO<=32'h00000000;
            MULTWRITE<=1'b0;        //4根写、忙信号线初始化
            MULTBUSY<=1'b0;
            DIVWRITE<=1'b0;
            DIVBUSY<=1'b0;
            sign<=1'b0;
            sig_remainder<=1'b0;
        end else
        case(state)
            /* S0:进行一些寄存器的初始化操作 */
            4'b0000:begin
                /* 4根写、忙信号线初始化 */
                MULTWRITE<=1'b0;                //mult not writing
                DIVWRITE<=1'b0;                 //div not writing
                MULTBUSY<=1'b0;                 //mult not busy
                DIVBUSY<=1'b0;                  //div not busy
                /* if multu */
                if(ALU_OP == 5'b01110) begin
                    A<=ALU_A;
                    B<=ALU_B;
                    MULTBUSY<=1'b1;             //mult busy
                    sign<=1'b0;                 //无符号运算
                    state<=4'b0001;             //enter S1
                end
                /* if mult */
                else if(ALU_OP==5'b01101) begin
                    A<=ALU_A[31]?{~ALU_A[30:0]+1}:ALU_A;   //求A的原码
                    B<=ALU_B[31]?{~ALU_B[30:0]+1}:ALU_B;   //求B的原码
                    sig_result<=ALU_A[31]^ALU_B[31];       //结果符号位
                    A[31]<=1'b0;        //取绝对值
                    B[31]<=1'b0;        //取绝对值
                    MULTBUSY<=1'b1;     //mult busy
                    sign<=1'b1;         //有符号运算
                    state<=4'b0001;     //enter S1 in the next clk
                end
                /* if divu (保证商和余数都为整数)*/
                else if(ALU_OP==5'b10000) begin
                    if(ALU_B[31]) begin          //若B的最高位为1，则A/B的商只可能是0或者1
                        A<=ALU_A;
                        B<=ALU_B;
                        DIVBUSY<=1'b1;          //div busy
                        state<=4'b1101;         //enter S13 in the next clk
                    end else begin
                        A<=ALU_A;
                        B<=ALU_B;
                        DIVBUSY<=1'b1;          //div busy
                        sign<=1'b0;             //无符号运算
                        state<=4'b0100;         //enter S4 in the next clk
                    end
                end
                /* if div */
                else if(ALU_OP==5'b01111) begin
                    A<=ALU_A[31]?{~ALU_A[30:0]+1}:ALU_A;    //求A的原码
                    B<=ALU_B[31]?{~ALU_B[30:0]+1}:ALU_B;    //求B的原码
                    sig_result<=ALU_A[31]^ALU_B[31];        //结果符号位
                    A[31]<=1'b0;                //取绝对值
                    B[31]<=1'b0;                //取绝对值
                    sig_remainder<=ALU_A[31];   //余数的符号
                    DIVBUSY<=1'b1;              //div busy
                    sign<=1'b1;                 //有符号运算
                    state<=4'b0100;             //enter S4 in the next clk
                end
            end//end of S0
            
            /* S1:继续乘法运算-分组相加 */
            4'b0001:begin
                //temp寄存器堆包含32个37位寄存器
                //考虑进位，result0-result4均为38位，result为34位
                result0<=temp[0]+temp[1]+temp[2]+temp[3]+temp[4]+temp[5];
                result1<=temp[6]+temp[7]+temp[8]+temp[9]+temp[10]+temp[11];
                result2<=temp[12]+temp[13]+temp[14]+temp[15]+temp[16]+temp[17];
                result3<=temp[18]+temp[19]+temp[20]+temp[21]+temp[22]+temp[23];
                result4<=temp[24]+temp[25]+temp[26]+temp[27]+temp[28]+temp[29];
                result5<=temp[30]+temp[31];
                state<=4'b0010;         //enter S2 in the next clk
            end//end of S1
            
            /* S2:继续乘法运算-每组之和相加 */
            4'b0010: begin
                state<=4'b0011;         //enter S3 in the next clk
                {ALU_HI,ALU_LO}<=result0+{result1,6'b0}+{result2,12'b0}+{result3,18'b0}+{result4,24'b0}+{result5,30'b0};
            end//end of S2
            
            /* S3:乘法运算结果写入 */
            4'b0011: begin
                state<=4'b0000;         //enter S0 in the next clk
                MULTWRITE<=1'b1;        //乘法计算完毕，信号保持一个时钟周期
                /* 如果是进行的有符号运算,则要由原码还原成补码 */
                if(sign) begin          
                    {ALU_HI,ALU_LO}<=sig_result?(~{ALU_HI[30:0],ALU_LO}+1):{ALU_HI,ALU_LO};//原码转补码
                    ALU_HI[31]<=sig_result;   //恢复符号位
                end
            end//end of S3
            
            /* S4:继续除法运算-分组求商，放入ALU_LO[31:28] */
            4'b0100: begin
                DIVBUSY<=1'b1;          //div busy
                state<=4'b0101;         //enter S5 in the next clk
                temp1[3]={31'b0,A}-{B,31'b0};
                temp1[2]=temp1[3][62]?(temp1[3]+{1'b0,B,30'b0}):(temp1[3]-{1'b0,B,30'b0});
                temp1[1]=temp1[2][61]?(temp1[2]+{2'b0,B,29'b0}):(temp1[2]-{2'b0,B,29'b0});
                temp1[0]=temp1[1][60]?(temp1[1]+{3'b0,B,28'b0}):(temp1[1]-{3'b0,B,28'b0});
                ALU_LO[31:28]=~{temp1[3][62],temp1[2][61],temp1[1][60],temp1[0][59]};
            end//end of S4
            
            /* S5:继续除法运算-分组求商，放入ALU_LO[27:24] */
            4'b0101: begin
                state<=4'b0110;         //enter S6 in the next clk
                temp1[3]=temp1[0][59]?(temp1[0]+{4'b0,B,27'b0}):(temp1[0]-{4'b0,B,27'b0});
                temp1[2]=temp1[3][58]?(temp1[3]+{5'b0,B,26'b0}):(temp1[3]-{5'b0,B,26'b0});
                temp1[1]=temp1[2][57]?(temp1[2]+{6'b0,B,25'b0}):(temp1[2]-{6'b0,B,25'b0});
                temp1[0]=temp1[1][56]?(temp1[1]+{7'b0,B,24'b0}):(temp1[1]-{7'b0,B,24'b0});
                ALU_LO[27:24]=~{temp1[3][58],temp1[2][57],temp1[1][56],temp1[0][55]};
            end//end of S5
            
            /* S6:继续除法运算-分组求商，放入ALU_LO[23:20] */
            4'b0110: begin
                state<=4'b0111;         //enter S7 in the next clk
                temp1[3]=temp1[0][55]?(temp1[0]+{8'b0,B,23'b0}):(temp1[0]-{8'b0,B,23'b0});
                temp1[2]=temp1[3][54]?(temp1[3]+{9'b0,B,22'b0}):(temp1[3]-{9'b0,B,22'b0});
                temp1[1]=temp1[2][53]?(temp1[2]+{10'b0,B,21'b0}):(temp1[2]-{10'b0,B,21'b0});
                temp1[0]=temp1[1][52]?(temp1[1]+{11'b0,B,20'b0}):(temp1[1]-{11'b0,B,20'b0});
                ALU_LO[23:20]=~{temp1[3][54],temp1[2][53],temp1[1][52],temp1[0][51]};
            end//end of S6
            
            /* S7:继续除法运算-分组求商，放入ALU_LO[19:16] */
            4'b0111: begin
                state<=4'b1000;         //enter S8 in the next clk
                temp1[3]=temp1[0][51]?(temp1[0]+{12'b0,B,19'b0}):(temp1[0]-{12'b0,B,19'b0});
                temp1[2]=temp1[3][50]?(temp1[3]+{13'b0,B,18'b0}):(temp1[3]-{13'b0,B,18'b0});
                temp1[1]=temp1[2][49]?(temp1[2]+{14'b0,B,17'b0}):(temp1[2]-{14'b0,B,17'b0});
                temp1[0]=temp1[1][48]?(temp1[1]+{15'b0,B,16'b0}):(temp1[1]-{15'b0,B,16'b0});
                ALU_LO[19:16]=~{temp1[3][50],temp1[2][49],temp1[1][48],temp1[0][47]};
            end//end of S7
            
            /* S8:继续除法运算-分组求商，放入ALU_LO[15:12] */
            4'b1000: begin
                state<=4'b1001;         //enter S9 in the next clk
                temp1[3]=temp1[0][47]?(temp1[0]+{16'b0,B,15'b0}):(temp1[0]-{16'b0,B,15'b0});
                temp1[2]=temp1[3][46]?(temp1[3]+{17'b0,B,14'b0}):(temp1[3]-{17'b0,B,14'b0});
                temp1[1]=temp1[2][45]?(temp1[2]+{18'b0,B,13'b0}):(temp1[2]-{18'b0,B,13'b0});
                temp1[0]=temp1[1][44]?(temp1[1]+{19'b0,B,12'b0}):(temp1[1]-{19'b0,B,12'b0});
                ALU_LO[15:12]=~{temp1[3][46],temp1[2][45],temp1[1][44],temp1[0][43]};
            end//end of S8
            
            /* S9:继续除法运算-分组求商，放入ALU_LO[11:8] */
            4'b1001: begin
                state<=4'b1010;         //enter S10 in the next clk
                temp1[3]=temp1[0][43]?(temp1[0]+{20'b0,B,11'b0}):(temp1[0]-{20'b0,B,11'b0});
                temp1[2]=temp1[3][42]?(temp1[3]+{21'b0,B,10'b0}):(temp1[3]-{21'b0,B,10'b0});
                temp1[1]=temp1[2][41]?(temp1[2]+{22'b0,B,9'b0}):(temp1[2]-{22'b0,B,9'b0});
                temp1[0]=temp1[1][40]?(temp1[1]+{23'b0,B,8'b0}):(temp1[1]-{23'b0,B,8'b0});
                ALU_LO[11:8]=~{temp1[3][42],temp1[2][41],temp1[1][40],temp1[0][39]};
            end//end of S9
            
            /* S10:继续除法运算-分组求商，放入ALU_LO[7:4] */
            4'b1010: begin
                state<=4'b1011;         //enter S11 in the next clk
                temp1[3]=temp1[0][39]?(temp1[0]+{24'b0,B,7'b0}):(temp1[0]-{24'b0,B,7'b0});
                temp1[2]=temp1[3][38]?(temp1[3]+{25'b0,B,6'b0}):(temp1[3]-{25'b0,B,6'b0});
                temp1[1]=temp1[2][37]?(temp1[2]+{26'b0,B,5'b0}):(temp1[2]-{26'b0,B,5'b0});
                temp1[0]=temp1[1][36]?(temp1[1]+{27'b0,B,4'b0}):(temp1[1]-{27'b0,B,4'b0});
                ALU_LO[7:4]=~{temp1[3][38],temp1[2][37],temp1[1][36],temp1[0][35]};
            end//end of S10
            
            /* S11:继续除法运算-分组求商，放入ALU_LO[3:0] */
            4'b1011: begin
                state<=4'b1100;         //enter S12 in the next clk
                temp1[3]=temp1[0][35]?(temp1[0]+{28'b0,B,3'b0}):(temp1[0]-{28'b0,B,3'b0});
                temp1[2]=temp1[3][34]?(temp1[3]+{29'b0,B,2'b0}):(temp1[3]-{29'b0,B,2'b0});
                temp1[1]=temp1[2][33]?(temp1[2]+{30'b0,B,1'b0}):(temp1[2]-{30'b0,B,1'b0});
                temp1[0]=temp1[1][32]?(temp1[1]+{31'b0,B}):(temp1[1]-{31'b0,B});
                ALU_HI=temp1[0][32]?(temp1[0][31:0]+B):temp1[0][31:0];
                ALU_LO[3:0]=~{temp1[3][62],temp1[2][61],temp1[1][60],temp1[0][59]};
            end//end of S11
            
            /* S12:除法运算结果写入 */
            4'b1100: begin
                DIVWRITE<=1'b1;
                state<=4'b0000;
                /* 如果是进行的有符号运算,则要由原码还原成补码 */
                if(sign) begin
                    ALU_HI<=sig_remainder?(~ALU_HI[30:0]+1'b1):ALU_HI[30:0];
                    ALU_HI[31]<=sig_remainder;
                    ALU_LO<=sig_result?(~ALU_LO[30:0]+1'b1):ALU_LO;
                    ALU_LO[31]<=sig_result;
                end
            end//end of S12
            
            /* S13:单独处理B[31]==1的情况 */
            4'b1101: begin
                DIVWRITE<=1'b1;             //div write busy
                state<=4'b0000;             //enter S0 in the next clk
                if(A<B) begin               //if A<B，则余数为A，商为0
                    ALU_HI=A;               
                    ALU_LO=32'h00000000;    
                end else begin              //if A>B，则余数为A-B，商为1
                    ALU_HI=A-B;
                    ALU_LO=32'h00000001;
                end
            end//end of S13
            
            default: begin
                ALU_HI<=0;
                ALU_LO<=0;
                state<=4'b0000;
            end
            
        endcase
        
    end//endmodule
    
endmodule