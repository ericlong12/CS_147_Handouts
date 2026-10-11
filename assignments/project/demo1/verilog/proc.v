/* $Author: sinclair $ */
/* $LastChangedDate: 2020-02-09 17:03:45 -0600 (Sun, 09 Feb 2020) $ */
/* $Rev: 46 $ */
`default_nettype none
module proc (/*AUTOARG*/
   // Outputs
   err, 
   // Inputs
   clk, rst
   );

   input wire clk;
   input wire rst;



   output reg err;

   // None of the above lines can be modified

   // OR all the err ouputs for every sub-module and assign it as this
   // err output
   
   // As desribed in the homeworks, use the err signal to trap corner
   // cases that you think are illegal in your statemachines
   

   // wire test
   wire [15:0] pcCurrent;
   wire [15:0] instr;
   wire        wb_write;
   wire [2:0]  wb_writeregsel;
   wire [15:0] wb_writedata;
   wire        memRead_out;
   wire        memReadorWrite_out;
   wire        memWrite_out;
   wire [15:0] mem_aluResult;
   wire [15:0] mem_writeData;
   wire        mem_halt;
   wire [15:0] instr_from_mem;
   wire [15:0] memoryData_from_memory;

   // wires for decodes outputs
   wire [4:0]  opcode;
   wire [2:0]  rsSel;
   wire [2:0]  rtSel;
   wire [2:0]  rdSel;
   wire [15:0] rsData;
   wire [15:0] rtData;

   wire [1:0] ext;


   // immediate
   wire [15:0] immediate;

   // execute 
   wire [15:0] execute_aluResult;
   wire [15:0] execute_storeData;
   wire [2:0]  execute_writeRegSel;

   wire        execute_regWrite;
   wire        execute_memRead;
   wire        execute_memReadorWrite;
   wire        execute_memWrite;

   wire [1:0]  execute_wbSel;
   wire [15:0] execute_pcNext;
   wire        execute_pcWe;
   wire        execute_halt;

   // we now connect the  execute outputs to the memory
   assign memRead_out        = execute_memRead;
   assign memReadorWrite_out = execute_memReadorWrite;
   assign memWrite_out       = execute_memWrite;
   assign mem_aluResult      = execute_aluResult;
   assign mem_writeData      = execute_storeData;
   assign mem_halt           = execute_halt;

   // intruction from memory
   memory2c instruction_memory(
      .data_out(instr_from_mem),
      .data_in(16'h0000),
      .addr(pcCurrent),
      .enable(1'b1),
      .wr(1'b0),
      .createdump(1'b0),
      .clk(clk),
      .rst(rst)
   );


   fetch fetch0(
      .clk      (clk),
      .rst      (rst),
      .pc_we    (execute_pcWe),
      .pc_next  (execute_pcNext),
      .instr_in (instr_from_mem),
      .pcCurrent(pcCurrent),
      .instr    (instr)
   );

   // adding more output connections for decode 
   decode decode0(
      .clk           (clk),
      .rst           (rst),
      .instr         (instr),

      .write_in      (wb_write),
      .writeregsel_in(wb_writeregsel),
      .writedata_in  (wb_writedata),

      .opcode        (opcode),
      .rsSel         (rsSel),
      .rtSel         (rtSel),
      .rdSel         (rdSel),
      .rsData        (rsData),
      .rtData        (rtData),
      .immediate     (immediate),
      .ext           (ext)


   );

   //execute call

   execute execute0(
      .clk              (clk),
      .rst              (rst),

      .pcCurrent        (pcCurrent),
      .opcode           (opcode),
      .rsSel            (rsSel),
      .rtSel            (rtSel),
      .rdSel            (rdSel),
      .rsData           (rsData),
      .rtData           (rtData),
      .immediate        (immediate),
      .ext              (ext),

      .aluResult        (execute_aluResult),
      .storeData        (execute_storeData),
      .writeRegSel      (execute_writeRegSel),

      .regWrite         (execute_regWrite),
      .memRead          (execute_memRead),
      .memReadorWrite   (execute_memReadorWrite),
      .memWrite         (execute_memWrite),

      .wbSel            (execute_wbSel),
      .pcNext           (execute_pcNext),
      .pcWe             (execute_pcWe),
      .halt             (execute_halt)

   );



   memory memory0(
      .clk(clk),
      .rst(rst),
      .memRead_in(memRead_out),
      .memReadorWrite_in(memReadorWrite_out),
      .memWrite_in(memWrite_out),
      .aluResult_in(mem_aluResult),
      .writeData_in(mem_writeData),
      .halt_in(mem_halt),
      .memRead(),
      .memReadorWrite(),
      .memWrite(),
      .aluResult(),
      .writeData(),
      .halt(),
      .memoryData(memoryData_from_memory)
   );
    
   // write back 

   wb wb0(
      .clk           (clk),
      .rst           (rst),

      .aluResult_in  (execute_aluResult),
      .memoryData_in (memoryData_from_memory),
      .pcPlus2_in    (16'h0000),

      .wbSel         (execute_wbSel),
      .writeRegSel_in(execute_writeRegSel),
      .regWrite_in   (execute_regWrite),

      .write         (wb_write),
      .writeregsel   (wb_writeregsel),
      .writedata     (wb_writedata)
   );
   
endmodule // proc
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :0:
