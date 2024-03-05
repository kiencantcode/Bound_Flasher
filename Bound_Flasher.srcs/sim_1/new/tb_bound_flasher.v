//`timescale 1ms / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2024 05:45:40 PM
// Design Name: 
// Module Name: tb_bound_flasher
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
//////////
//`define CYCLE 10;

//module tb_bound_flasher;

//reg rst_n;
//reg flick;

//initial begin
//    #(CYCLE*20);
//    $display("____");
//    $display("Active test");
//    $display("----");
//    rst_n = 1'b0;
//    #(CYCLE*3) rst_n = 1'b1;
//    #(CYCLE*3) flick = 1'b1;
//    #(CYCLE*3) flick = 1'b0;
//    #(CYCLE*60) $finish;
//end
    
    
//endmodule
// `timescale 1ns/1ps


`define CLK_PERIOD 10
`define test


`define testflick1
`define testflick2
`define testflick3
`define testflick4
`define testflick5
`define testflick6
`define testflick7
`define testflick8
`define testflick9
`define testflick10

module tb_bound_flasher;
    // Signals
    reg clk;
    reg flick;
    reg rst;
    wire [15:0] lamps;
    // Instantiate bound_flasher module
    bound_flasher UUT (
        .flick(flick),
        .clk(clk),
        .rst(rst),
        .led_output(lamps)
    );

    // Clock generation
    always #((`CLK_PERIOD / 10)) clk = ~clk;

    // Testbench behavior
    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        flick = 1;

        // Activate flick signal after a delay
`ifdef test //Normal Flow
        #2 flick = 0;
        #98 flick = 0;

`ifdef testflick1 //Active new test case for test
        #27 flick = ~flick;
        #3 flick = ~flick;
`endif
        
`ifdef testflick2 //Flick signal at L5 in state 3
        #30 flick = ~flick;
        #10 flick = ~flick;
`endif 
`ifdef testflick3 //Flick signal at L10 in state 3
        #28 flick = ~flick;
        #10 flick = ~flick;
`endif 

`ifdef testflick4 //Flick signal at L5 in state 5
        #47 flick = ~flick;
        #10 flick = ~flick;

`endif 
`ifdef testflick5 //Flick signal at L10 in state 5 
        #10 flick = ~flick;
        #20 flick = ~flick;

`endif

`ifdef testflick6 //Flick signal to repeat the process
        #65 flick = ~flick;
        #3 flick = ~flick;
        #110 flick = 0;
`endif

`ifdef testflick7 //Flick signal at any time slot (not kickback point in turning off leds state)
        #10 flick = ~flick;
        #10 flick = ~flick;
        #18 flick = ~flick; 
        #5 flick = ~flick;
`endif

`ifdef testflick8 //Flick signal at between L5 and L10 in state 3
        #6 flick = ~flick;
        #5 flick = ~flick;
`endif
`ifdef testflick9 //Reset signal at any time slot
        #30 rst = 0;
`endif

`ifdef testflick10 //Reset signal with flick signal at kickback point in turning off leds state
        #10 flick = 1;
            rst = 1;
        #10 flick = 0;
        #20 flick = 1;
            rst = 0;
`endif
`endif

        // Allow simulation to run for some time
        #(1000*`CLK_PERIOD) $finish;
    end

    // Monitor
    always @(posedge clk) begin
        $display("Time = %0t, lamps = %b", $time, lamps);
    end

endmodule