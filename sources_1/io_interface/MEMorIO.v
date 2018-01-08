`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Bus controller for Minisys-1
// 
//////////////////////////////////////////////////////////////////////////////////


module MEMorIO (
    // signals from controller unit
    input isR,
    input isW,
    // access address (from ALU)
    input[31:0] addr,
    // data channels
    input[31:0] dR_inst,
    input[31:0] dR_mem,
    input[15:0] dR_io,
    output[31:0] dW,
    // control signals for accessories
    output ctl_disp, // 7-seg display
    output ctl_kb, // keyboard
    output ctl_timer, // timers
    output ctl_pwm, // PWM controller
    output ctl_cop, // watchdog
    output ctl_led, // LEDs
    output ctl_switch // switches
);

wire isIO;
assign isIO = (addr[31:10] == 22'h3fffff) && (isR || isW);

assign dW = isW ? dR_inst :
            isR ? (isIO ? { 16'h0000, dR_io } : dR_mem ) :
            32'hzzzz;

assign ctl_disp = isIO && addr[9:4] == 6'h000;
assign ctl_kb = isIO && addr[9:4] == 6'h001;
assign ctl_timer = isIO && addr[9:4] == 6'h002;
assign ctl_pwm = isIO && addr[9:4] == 6'h003;
assign ctl_cop = isIO && addr[9:4] == 6'h005;
assign ctl_led = isIO && addr[9:4] == 6'h006;
assign ctl_switch = isIO && addr[9:4] == 6'h007;

endmodule
