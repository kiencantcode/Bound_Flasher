`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2024 08:18:59 PM
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
//////////////////////////////////////////////////////////////////////////////////

module tb_bound_flasher;
  parameter CYCLE = HALF_CYCLE * 2;
  parameter HALF_CYCLE = 5;
  
  
  
  wire [15:0] led;
  reg flick, clk, rst;
  
  bound_flasher BF(.flick(flick), .clk(clk), .rst(rst), .led_output(led));
    
  //generate clock
  always begin
    clk = 1'b0;
    #HALF_CYCLE clk = 1'b1;
    #HALF_CYCLE;
  end
  
  initial begin
    rst = 0;
    flick = 0;
    #2 rst = 1;

    // Test case :
    #5 flick = 1;	// Normal flow
    #3 flick = 0;	
    
   #393 flick = 1; // Flick process
   #3 flick = 0;
   
   #89 flick = 1; // Flick at any time and no change 
   #3 flick = 0;

   #120 flick = 1; 
   #3 flick = 0;



   #200 rst = 1; flick = 1; // Flick and rst at the same time
   #3 flick = 0; rst = 0;

   #30 rst = 0;      // rst and restart process
   #3 rst = 1;
   #4 flick = 1;
   #2 flick = 0;

    #(CYCLE*90) $finish;
  end

//initial begin
//    $recordfile("./waves");
//    $recordvars("depth=0", tb_bound_flasher);
//end

endmodule