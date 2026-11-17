//==============================================================================
// Company      : 
// File         : ahb_error_test.sv
// Author       : vinhha
// Created      : 2026-11-09
// Last Modified: 2026-11-09
//==============================================================================
// Description  :
//
//==============================================================================

 //==============================================================================
 // Company      :
 // File         : ahb_error_test.sv
 // Author       : vinhha
 // Created      : 2026-11-09
 // Last Modified: 2026-11-09
 //==============================================================================
 // Description  :
 // AHB Slave ERROR response verification
 //
 // Test scenarios:
 // 1. Legal WRITE / READ
 // 2. Out-of-range address ERROR
 // 3. Unaligned address ERROR
 // 4. Unsupported HSIZE ERROR
 // 5. Recovery after ERROR response
 //==============================================================================

 class ahb_error_test extends base_test;

     packet pkt;

     function new();
         super.new();
     endfunction

     //==========================================================================
     // Send a single AHB transfer
     //==========================================================================
     task send_transfer(
         input bit        write_mode,
         input bit [31:0] addr,
         input bit [2:0]  size,
         input bit        expect_error
     );

         pkt = new();

         // AHB control signals
         pkt.hsel       = 1'b1;
         pkt.hwrite     = write_mode;
         pkt.haddr      = addr;
         pkt.hsize      = size;

         // Single transfer
         pkt.hburst     = SINGLE;
         pkt.htrans     = 2'b10; // NONSEQ

         pkt.hprot      = 4'b0011;
         pkt.hsmartlock = 1'b0;
         pkt.hready     = 1'b1;

         // Random write data
         pkt.hwdata = $urandom();

         $display("========================================");
         $display(
             "%0t [AHB_ERROR_TEST] %s",
             $time,
             write_mode ? "WRITE" : "READ"
         );

         $display("ADDR          = %08h", pkt.haddr);
         $display("HSIZE         = %03b", pkt.hsize);
         $display("HBURST        = SINGLE");
         $display("HTRANS        = NONSEQ");
         $display(
             "EXPECTED HRESP= %s",
             expect_error ? "ERROR" : "OKAY"
         );
         $display("========================================");

         send_pkt(pkt);

     endtask

     //==========================================================================
     // Main test scenario
     //==========================================================================
     virtual task run_scenario();

         $display("");
         $display("========================================");
         $display("       AHB ERROR RESPONSE TEST          ");
         $display("========================================");

         //======================================================================
         // TEST 1: Legal WRITE and READ
         //======================================================================
         $display("[TEST 1] LEGAL WRITE / READ");

         send_transfer(
             1'b1,
             32'h0000_0100,
             3'b010,
             1'b0
         );

         send_transfer(
             1'b0,
             32'h0000_0100,
             3'b010,
             1'b0
         );

         //======================================================================
         // TEST 2: Address out of range
         // Valid range: 0x000 - 0x3FF
         //======================================================================
         $display("[TEST 2] ADDRESS OUT OF RANGE");

         // Invalid WRITE
         send_transfer(
             1'b1,
             32'h0000_0400,
             3'b010,
             1'b1
         );

         // Invalid READ
         send_transfer(
             1'b0,
             32'h0000_0400,
             3'b010,
             1'b1
         );

         // Recovery: legal READ
         send_transfer(
             1'b0,
             32'h0000_0100,
             3'b010,
             1'b0
         );

         //======================================================================
         // TEST 3: Unaligned address
         // WORD transfer requires 4-byte alignment
         //======================================================================
         $display("[TEST 3] UNALIGNED ADDRESS");

         // Invalid WRITE
         send_transfer(
             1'b1,
             32'h0000_0103,
             3'b010,
             1'b1
         );

         // Invalid READ
         send_transfer(
             1'b0,
             32'h0000_0103,
             3'b010,
             1'b1
         );

         // Recovery: legal READ
         send_transfer(
             1'b0,
             32'h0000_0100,
             3'b010,
             1'b0
         );

         //======================================================================
         // TEST 4: Unsupported transfer size
         // DATA_W = 32 bits
         // Supported HSIZE: BYTE / HALFWORD / WORD
         //======================================================================
         $display("[TEST 4] UNSUPPORTED HSIZE");

         // Invalid WRITE: 64-bit transfer
         send_transfer(
             1'b1,
             32'h0000_0100,
             3'b011,
             1'b1
         );

         // Invalid READ: 64-bit transfer
         send_transfer(
             1'b0,
             32'h0000_0100,
             3'b011,
             1'b1
         );

         // Recovery: legal READ
         send_transfer(
             1'b0,
             32'h0000_0100,
             3'b010,
             1'b0
         );

         $display("");
         $display("[AHB_ERROR_TEST] All test packets sent");
         $display("");

     endtask

 endclass

