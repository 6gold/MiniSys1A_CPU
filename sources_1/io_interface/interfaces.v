`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: 
//////////////////////////////////////////////////////////////////////////////////

module interfaces(
    input clk,
    input isReset,
    // signals from controller unit
    input isR,
    input isW,
    // access address (from ALU)
    input[31:0] addr,
    // data channels
    input[31:0] dR_inst,
    input[31:0] dR_mem,
    output[31:0] dW,
    // LED outputs
    output[15:0] o_led,
    // switch inputs
    input[15:0] i_switch,
    // reset signal from watchdog
    output o_wreset,
    // 7-seg display
    output[7:0] disp_data,
    output[7:0] disp_sel,
    // PWM
    output pwm_out,
    // Timer
    input pulse1,
    input pulse2,
    output cout1,
    output cout2,
    // Keyboard
    input[3:0] row,
    output[3:0] col
 );

wire[15:0] dR_io;
wire ctl_disp; // 7-seg display
wire ctl_kb; // keyboard
wire ctl_timer; // timers
wire ctl_pwm; // PWM controller
wire ctl_cop; // watchdog
wire ctl_led; // LEDs
wire ctl_switch; // switches
MEMorIO controller(isR(), isW(), addr(), dR_inst(), dR_mem, dR_io, dW,
                   ctl_disp, ctl_kb, ctl_timer, ctl_pwm, ctl_cop, ctl_led, ctl_switch);
WatchDog watchdog(isReset, ctl_cop, isW, dW[15:0], dR_io, clk, o_wreset);
LED led(isReset, ctl_led, isW, dW[15:0], dR_io, clk, o_led);
Switch switch(isReset, ctl_switch, isW, dW[15:0], dR_io, i_switch);
SegDisp segdisp(isReset, ctl_disp, isW, dW[15:0], dR_io, clk, addr[3:0], disp_data, disp_sel);
PWMCtrl pwm_ctrl(isReset, ctl_pwm, isW, dW[15:0], dR_io, clk, addr[3:0], pwm_out);
Timer timer(isReset, ctl_timer, isW, dW[15:0], dR_io, clk, addr[3:0], pulse1, pulse2, cout1, cout2);
Keyboard keyboard(isReset, ctl_kb, isW, dW[15:0], dR_io, clk, addr[3:0], row, col);
endmodule
