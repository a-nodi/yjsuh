/* CSED273 Final project */

`timescale 1ns / 1ps

module safe(
    input row1, row2, row3, row4, col1, col2, col3,
    input reset_password, initialize, clk,
    output [5:0] password_led,
    output [2:0] state
);

    reg is_on;
    wire is_pressed_;
    wire [3:0] bcd_;
    reg correct;
    reg correct1, correct2;
    wire _correct_;
    reg is_star_pressed;
    reg is_sharp_pressed;

    initial begin
        is_on <= 1'b0;
        correct <= 1'b0;
        is_star_pressed <= 1'b0;
        is_sharp_pressed <= 1'b0;
        correct <= 1'b0;
        correct1 <= 1'b0;
        correct2 <= 1'b0;
    end
    
    always @(row4, col1) begin
        if(row4 & col1 === 1'b1) is_star_pressed <= 1'b1;
        else if(row4 === 1'b1 && col1 === 1'b0) is_star_pressed <= 1'b0;
    end
    
    always @(row4, col3) begin
        if(row4 & col3 === 1'b1) is_sharp_pressed <= 1'b1;
        else if(row4 === 1'b1 && col3 === 1'b0) is_sharp_pressed <= 1'b0;
    end
    
    // Detect Key press
    assign is_pressed_ = (col1 | col2 | col3) & ~(is_sharp_pressed) & ~(is_star_pressed);

    // 
    always @(posedge (is_star_pressed | is_sharp_pressed)) begin    
        correct <= _correct_;
    end

    always @(posedge (is_sharp_pressed | initialize)) begin
        is_on <= ~initialize & ~is_on;
    end

    // Convert pressed keypad row column to 8421 BCD code
    KeypadToBcdEncoder keypad_to_bcd(row1, row2, row3, row4, col1, col2, col3, bcd_);

    // Compare input word and answer word
    Comparator comparator(bcd_, is_star_pressed, reset_password, initialize, is_on, is_pressed_, _correct_, password_led);
    
    // Determine current machines states
    StateManager state_manager(is_on, is_star_pressed, reset_password, correct, initialize, clk, state);

endmodule
