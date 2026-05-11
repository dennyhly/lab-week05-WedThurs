module top (
    input  logic CLK, //FPGA's clock

	output logic LCD_CLK,//LCD clock. 
	output logic LCD_DEN,
	output logic [4:0] LCD_R,
	output logic [5:0] LCD_G,
	output logic [4:0] LCD_B,
);

logic [9:0] x = 0, y = 0;
logic [7:0] section = 160;
logic [9:0] active_len = 480, max_len = 525, active_height = 272, max_height = 285;

assign LCD_CLK = CLK;

always@ (posedge LCD_CLK) begin
    if (x >= max_len - 1) begin
        x <= 0;
        if (y >= max_height - 1) begin
            y <= 0;
        end else begin
            y <= y + 1;
        end
    end else begin
        x <= x + 1;
    end

    if ((x < active_len) && (y < active_height)) begin
        LCD_DEN <= 1;
        if (x < section) begin
            LCD_R <= 5'b11111; 
            LCD_G <= 6'b000000;
            LCD_B <= 5'b00000;
        end else if (x < section * 2) begin
            LCD_R <= 5'b00000;
            LCD_G <= 6'b111111; 
            LCD_B <= 5'b00000;
        end else if (x < section * 3) begin
            LCD_R <= 5'b00000;
            LCD_G <= 6'b000000;
            LCD_B <= 5'b11111;
        end 
    end else begin 
        LCD_DEN <= 0;
        LCD_R <= 5'b00000; 
        LCD_G <= 6'b000000;
        LCD_B <= 5'b00000;
    end
end

endmodule