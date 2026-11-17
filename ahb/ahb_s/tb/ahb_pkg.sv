package ahb_pkg;

    parameter ADDR_W = 32;
    parameter DATA_W = 32;

    parameter SINGLE = 3'b000;
    parameter INCR   = 3'b001;
    parameter WRAP4  = 3'b010;
    parameter INCR4  = 3'b011;
    parameter WRAP8  = 3'b100;
    parameter INCR8  = 3'b101;
    parameter WRAP16 = 3'b110;
    parameter INCR16 = 3'b111;

    `include "packet.sv"
    `include "stimulus.sv"
    `include "driver.sv"
    `include "monitor.sv"
    `include "scoreboard.sv"
    `include "environment.sv"

endpackage
