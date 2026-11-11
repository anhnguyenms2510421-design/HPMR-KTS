module control_unit (
    input logic         Clk,
    input logic         Resetn,
    input logic         Run,
    input logic [8:0]   IR,
    output logic        IRin,
    output logic        Ain,
    output logic        Gin,
    output logic        Addsub,
    output logic        Gout,
    output logic        DINout,
    output logic        Done,
    output logic [7:0]  Rin,
    output logic [7:0]  Rout
);

/*
    Resetn = 0: waiting for instructions
    Run = 1: instructions start to flow to control_unit otherwise waiting
    IRin = 1: allow DIN to flow to IR
    Ain = 1: allow Bus data to flow to register_A
    Gin = 1: allow Alu_result to flow to register_G
    Addsub = 1: + otherwise - of 2 operands
    Gout, DINout, Rout: select data from G, DIN or Register file to Bus
    Done = 1: when complete executing current IR
    Rin: allow which register in register_file to write bus data
*/

endmodule