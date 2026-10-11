/*
   CS 147 Spring 26
   Filename        : memory.v
   Description     : Memory stage of the processor.
*/
`default_nettype none

module memory (
   input wire        clk,
   input wire        rst,
   input wire        memRead_in,
   input wire        memReadorWrite_in,
   input wire        memWrite_in,
   input wire [15:0] aluResult_in,
   input wire [15:0] writeData_in,
   input wire        halt_in,

   output wire        memRead,
   output wire        memReadorWrite,
   output wire        memWrite,
   output wire [15:0] aluResult,
   output wire [15:0] writeData,
   output wire        halt,
   output wire [15:0] memoryData
);

   reg [7:0] data_mem [0:65535];
   reg       loaded;
   integer   i;

   assign memRead        = memRead_in;
   assign memReadorWrite = memReadorWrite_in;
   assign memWrite       = memWrite_in;
   assign aluResult      = aluResult_in;
   assign writeData      = writeData_in;
   assign halt           = halt_in;

   // combinational load
   assign memoryData =
      memRead_in
         ? {data_mem[aluResult_in],
            data_mem[aluResult_in + 16'h0001]}
         : 16'h0000;

   initial begin
      loaded = 1'b0;

      for (i = 0; i < 65536; i = i + 1) begin
         data_mem[i] = 8'h00;
      end
   end

   always @(posedge clk) begin
      if (rst) begin
         if (!loaded) begin
            $readmemh("loadfile_all.img", data_mem);
            loaded = 1'b1;
         end
      end
      else if (memWrite_in) begin
         data_mem[aluResult_in]          = writeData_in[15:8];
         data_mem[aluResult_in + 16'h0001] = writeData_in[7:0];
      end
   end

endmodule

`default_nettype wire