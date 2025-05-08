

`include "defines.v"

// pc reg module
module pc_reg (

    input wire clk,
    input wire rst,

    input wire jump_flag_ex_i,
    input wire[`RegBus] jump_addr_ex_i,

    input wire hold_flag_ex_i,
    input wire[`RegBus] hold_addr_ex_i,

    input wire int_flag_ex_i,
    input wire[`RegBus] int_addr_ex_i,

    input wire dm_halt_req_i,
    input wire dm_reset_req_i,

	output reg[`SramAddrBus] pc_o,
	output reg re_o

    );

    reg[`SramAddrBus] offset;

    always @ (posedge clk) begin
        if (rst == `RstEnable || dm_reset_req_i == 1'b1) begin
            pc_o <= `ZeroWord;
            offset <= `ZeroWord;
        end else if (dm_halt_req_i == 1'b1) begin
            pc_o <= offset;
        end else if (int_flag_ex_i == 1'b1) begin
            pc_o <= int_addr_ex_i;
            offset <= int_addr_ex_i + 4'h4;
        end else if (jump_flag_ex_i == `JumpEnable) begin
            pc_o <= jump_addr_ex_i;
            offset <= jump_addr_ex_i + 4'h4;
        end else if (hold_flag_ex_i == `HoldEnable) begin
            pc_o <= hold_addr_ex_i;
            offset <= hold_addr_ex_i;
        end else begin
            pc_o <= offset;
            offset <= offset + 4'h4;
        end
    end

    always @ (posedge clk) begin
        if (rst == `RstEnable) begin
            re_o <= `ReadDisable;
        end else begin
            re_o <= `ReadEnable;
        end
    end

endmodule
