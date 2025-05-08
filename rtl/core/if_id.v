

`include "defines.v"

// inst fetch module
module if_id (

    input wire clk,
    input wire rst,

    input wire[`SramBus] inst_i,            // inst content
    input wire[`SramAddrBus] inst_addr_i,   // inst addr

    input wire jump_flag_ex_i,
    input wire hold_flag_ex_i,
    input wire int_flag_ex_i,
    input wire dm_halt_req_i,

    output reg[`SramBus] inst_o,
    output reg[`SramAddrBus] inst_addr_o

    );

    always @ (posedge clk) begin
        if (rst == `RstEnable) begin
            inst_o <= `ZeroWord;
            inst_addr_o <= `ZeroWord;
        end else if (dm_halt_req_i == 1'b1) begin
            inst_o <= `INST_NOP;
            inst_addr_o <= `ZeroWord;
        end else if (int_flag_ex_i == 1'b1) begin
            inst_o <= `INST_NOP;
            inst_addr_o <= `ZeroWord;
        end else if (jump_flag_ex_i == `JumpEnable) begin
            inst_o <= `INST_NOP;
            inst_addr_o <= `ZeroWord;
        end else if (hold_flag_ex_i == `HoldEnable) begin
            inst_o <= `INST_NOP;
            inst_addr_o <= `ZeroWord;
        end else begin
            inst_o <= inst_i;
            inst_addr_o <= inst_addr_i;
        end
    end

endmodule
