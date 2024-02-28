`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2024 01:51:41 PM
// Design Name: 
// Module Name: bound_flasher
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


module bound_flasher(flick, clk, rst, led_output);
    input wire flick;
    input wire clk;
    input wire rst;
    output reg [15:0] led_output;
    
    reg [2:0] state;
    reg [2:0] stateR;
    reg [15:0] led_buffer;
    
    reg flickFlag;
    
    always @(posedge clk or negedge rst) begin
        if (rst == 1'b0) begin
            led_output <= 16'b0;
        end
        else begin
            led_output <= led_buffer;
        end
    end
    
    always @(*) begin
        case(state)
            3'b000: begin
                led_buffer <= 16'b0;
            end
            
            3'b001: begin
                if (led_output[5] != 1) begin 
                    led_buffer <= (led_output << 1) | 1'b1;
                end
            end
            
            3'b010: begin
                if (led_output[0] != 0) begin
                    led_buffer <= (led_output >> 1);
                end           
            end
            
            3'b011: begin
                if (led_output[10] != 1) begin
                    led_buffer <= (led_output << 1) | 1'b1;
                end
            end
            
            3'b100: begin
                if (led_output[5] != 0) begin
                   led_buffer <= (led_output >> 1);
                end
            end
            
            3'b101: begin
                 if (led_buffer[15] != 1) begin 
                     led_buffer <= (led_output << 1) | 1'b1;
                 end
            end
            
            3'b110: begin
                 if (led_output[0] != 0) begin
                    led_buffer <= (led_output >> 1);
                 end
            end
            
            default: begin
                        led_buffer <= 16'b0;
                    end
        endcase      
    end
   
    
    always @(posedge clk or negedge rst) begin
        if (rst == 1'b0) begin
          stateR <= 3'b000;
        end
        else begin
          stateR <= state;
        end
     end
   
     always @(*) begin
         if (rst == 1'b0) begin
           state = 3'b000;
         end
         else begin
         case (stateR)
           3'b000: begin //INITIAL
             if (flick == 1) begin
               state = 3'b001;
             end
           end
           
           3'b001: begin //STATE_1
             if (led_output[5] == 1) begin
               state = 3'b010;
             end
           end
           
           3'b010: begin    //STATE_2
             if (led_output[0] == 0) begin
                  state = 3'b011;
             end
           end
           
           3'b011: begin //STATE_3
             if (led_output[10] == 1) begin
               state = 3'b100;
             end 
           end
           
           3'b100: begin    //STATE_4
             if (led_output[5] == 0) begin
                  state = 3'b101;
             end
           end
           
           3'b101: begin //STATE_5
             if (led_output[15] == 1) begin
                  state = 3'b110;
             end
           end
           
           3'b110: begin //FINAL
             if (led_output[0] == 0) begin
                  state = 3'b000;
             end
           end
           
           default: state = 3'b000;
         endcase
         end
       end
    
    endmodule