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
    Addsub = 0: + otherwise - of 2 operands
    Gout, DINout, Rout: select data from G, DIN or Register file to Bus
    Done = 1: when complete executing current IR
    Rin: allow which register in register_file to write bus data
*/

	// states: 
	localparam T0 = 2'b00;
	localparam T1 = 2'b01;
	localparam T2 = 2'b10;
	localparam T3 = 2'b11;

	// OPcodes:
	localparam OP_MV = 3'b000;
	localparam OP_MOVI = 3'b001;
	localparam OP_ADD = 3'b010;
	localparam OP_SUB = 3'b011;

	logic [1:0] current_state, next_state;
	logic [2:0] opcode, rx_addr, ry_addr;
	logic [7:0] Xreg, Yreg;

	assign opcode = IR[8:6];
	assign rx_addr = IR[5:3];
	assign ry_addr = IR[2:0];

	// decode X and Y reg:
	decoder3to8 X_reg_decode (
		.EN(1'b1),
		.din(rx_addr),
		.dout(Xreg)
	);

	decoder3to8 Y_reg_decode (
		.EN(1'b1),
		.din(ry_addr),
		.dout(Yreg)
	);
	
	always_ff @(posedge Clk or negedge Resetn) begin
		if (!Resetn) current_state <= T0;
		else current_state <= next_state;
	end

	always_comb begin
		case(current_state) 
			T0: begin
				if (Run) next_state = T1;
				else next_state = T0;
			end
			T1: begin
				case (opcode) 
					OP_MV, OP_MOVI: next_state = T0;
					OP_ADD, OP_SUB: next_state = T2;
					default: next_state = T0;
				endcase
			end
			T2: begin
				next_state = T3;
			end
			T3: begin
				next_state = T0;
			end
			default: next_state = T0;
		endcase
	end

	always_comb begin
		IRin = 1'b0;
		Ain = 1'b0;
		Gin = 1'b0;
		Addsub = 1'b0;
		Gout = 1'b0;
		DINout = 1'b0;
		Done = 1'b0;
		Rin = 8'b00000000;
		Rout = 8'b00000000;
		
		case(current_state) 
			T0: begin
				IRin = 1'b1;
			end
			T1: begin
				case(opcode) 
					OP_MV: begin
						Rout = Yreg;
						Rin = Xreg;
						Done = 1'b1;
					end
					OP_MOVI: begin
						Rin = Xreg;
						DINout = 1'b1;
						Done = 1'b1;
					end
					OP_ADD, OP_SUB: begin
						Rout = Xreg;
						Ain = 1'b1;
					end
					default: ;
				endcase
			end
			T2: begin
				Rout = Yreg;
				Gin = 1'b1;
				case(opcode)
					OP_ADD: Addsub = 1'b0;	
					OP_SUB: Addsub = 1'b1;
					default: ;
				endcase
			end
			T3: begin
				Gout = 1'b1;
				Rin = Xreg;
				Done = 1'b1;
			end
		endcase
	end
endmodule
