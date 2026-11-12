module proc (
    input  logic [8:0] DIN,
    input  logic       Resetn,
    input  logic       Clock,
    input  logic       Run,
    output logic       Done,
    output logic [8:0] BusWires
);

    // ------------------------------------------------------------------------
    // Internal datapath signals
    // ------------------------------------------------------------------------
    logic [8:0] IR;

    logic [8:0] R0;
    logic [8:0] R1;
    logic [8:0] R2;
    logic [8:0] R3;
    logic [8:0] R4;
    logic [8:0] R5;
    logic [8:0] R6;
    logic [8:0] R7;

    logic [8:0] A_data;
    logic [8:0] G_data;
    logic [8:0] Alu_result;

    // ------------------------------------------------------------------------
    // Internal control signals
    // ------------------------------------------------------------------------
    logic       IRin;
    logic       Ain;
    logic       Gin;
    logic       AddSub;
    logic       Gout;
    logic       DINout;
    logic [7:0] Rin;
    logic [7:0] Rout;

    // ------------------------------------------------------------------------
    // Control Unit FSM
    // Port names are mapped to the common top-level signal names below.
    // ------------------------------------------------------------------------
    control_unit u_control_unit (
        .Clk    (Clock),
        .Resetn (Resetn),
        .Run    (Run),
        .IR     (IR),
        .IRin   (IRin),
        .Ain    (Ain),
        .Gin    (Gin),
        .Addsub (AddSub),
        .Gout   (Gout),
        .DINout (DINout),
        .Done   (Done),
        .Rin    (Rin),
        .Rout   (Rout)
    );

    // ------------------------------------------------------------------------
    // Instruction Register
    // ------------------------------------------------------------------------
    register_instruction u_instruction_register (
        .IRin (IRin),
        .Clk  (Clock),
        .DIN  (DIN),
        .IR   (IR)
    );

    // ------------------------------------------------------------------------
    // Register File: eight 9-bit general-purpose registers
    // ------------------------------------------------------------------------
    register_file u_register_file (
        .Clk  (Clock),
        .Rin  (Rin),
        .Bus  (BusWires),
        .R0   (R0),
        .R1   (R1),
        .R2   (R2),
        .R3   (R3),
        .R4   (R4),
        .R5   (R5),
        .R6   (R6),
        .R7   (R7)
    );

    // ------------------------------------------------------------------------
    // Shared 9-bit bus multiplexer
    // ------------------------------------------------------------------------
    multiplexer u_multiplexer (
        .DINout (DINout),
        .Gout   (Gout),
        .Rout   (Rout),
        .DIN    (DIN),
        .G_data (G_data),
        .R0     (R0),
        .R1     (R1),
        .R2     (R2),
        .R3     (R3),
        .R4     (R4),
        .R5     (R5),
        .R6     (R6),
        .R7     (R7),
        .Bus    (BusWires)
    );

    // ------------------------------------------------------------------------
    // A Register: stores the first ALU operand
    // ------------------------------------------------------------------------
    register_A u_register_A (
        .Bus    (BusWires),
        .Ain    (Ain),
        .Clock  (Clock),
        .A_data (A_data)
    );

    // ------------------------------------------------------------------------
    // ALU: combinational adder/subtractor
    // ------------------------------------------------------------------------
    alu u_alu (
        .A_data     (A_data),
        .Bus        (BusWires),
        .Addsub     (AddSub),
        .Alu_result (Alu_result)
    );

    // ------------------------------------------------------------------------
    // G Register: stores the ALU result
    // ------------------------------------------------------------------------
    register_G u_register_G (
        .Gin        (Gin),
        .Clk        (Clock),
        .Alu_result (Alu_result),
        .G_data     (G_data)
    );

endmodule
