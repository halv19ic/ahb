
 //==============================================================================
 // Company      :
 // File         : scoreboard.sv
 // Author       : vinhha
 // Created      : 2026-11-09
 // Last Modified: 2026-11-09
 //==============================================================================
 // Description  :
 // AHB Slave Scoreboard
 //
 // - Check expected HRESP (OKAY / ERROR)
 // - Check address range, alignment and HSIZE
 // - Store reference data for WRITE transactions
 // - Compare READ data with reference memory
 // - Report PASS / FAIL statistics
 //==============================================================================

 class scoreboard;

     mailbox #(packet) m2s_mb;

     //==========================================================================
     // Configuration (match current RTL)
     //==========================================================================
     localparam logic [ADDR_W-1:0] ADDR_BASE = '0;
     localparam int unsigned ADDR_RANGE = 1024;
     localparam int unsigned MAX_HSIZE = $clog2(DATA_W / 8);

     //==========================================================================
     // Reference memory
     //==========================================================================
     logic [DATA_W-1:0] ref_mem [logic [ADDR_W-1:0]];

     //==========================================================================
     // Statistics
     //==========================================================================
     int total_count;
     int write_count;
     int read_count;

     int pass_count;
     int fail_count;

     int okay_count;
     int expected_error_count;
     int unexpected_error_count;

     int data_pass_count;
     int data_fail_count;
     int skip_count;

     //==========================================================================
     // Constructor
     //==========================================================================
     function new(mailbox #(packet) m2s_mb);

         this.m2s_mb = m2s_mb;

         total_count            = 0;
         write_count            = 0;
         read_count             = 0;

         pass_count             = 0;
         fail_count             = 0;

         okay_count             = 0;
         expected_error_count   = 0;
         unexpected_error_count = 0;

         data_pass_count        = 0;
         data_fail_count        = 0;
         skip_count             = 0;

     endfunction

     //==========================================================================
     // Calculate expected address error
     //==========================================================================
     function bit check_addr_error(packet pkt);

         bit range_error;
         bit size_error;
         bit align_error;

         logic [ADDR_W-1:0] align_mask;

         // Address range checking
         range_error =
             (pkt.haddr < ADDR_BASE) ||
             (pkt.haddr >= ADDR_BASE + ADDR_RANGE);

         // Transfer size checking
         size_error = (pkt.hsize > MAX_HSIZE);

         // Address alignment checking
         align_mask = (ADDR_W'(1) << pkt.hsize) - 1'b1;

         align_error = |(pkt.haddr & align_mask);

         return (range_error || size_error || align_error);

     endfunction

     //==========================================================================
     // Check transaction
     //==========================================================================
     function void check_pkt(packet pkt);

         bit expected_error;
         logic [DATA_W-1:0] expected_data;

         total_count++;

         if (pkt.hwrite)
             write_count++;
         else
             read_count++;

         //======================================================================
         // 1. Calculate expected response
         //======================================================================
         expected_error = check_addr_error(pkt);

         //======================================================================
         // 2. Compare expected and actual response
         //======================================================================
         if (pkt.hresp !== expected_error) begin

             fail_count++;

             if (pkt.hresp === 1'b1)
                 unexpected_error_count++;

             //$error(
             //    "[SCOREBOARD] RESPONSE FAIL | ADDR=%08h EXPECTED=%0b ACTUAL=%0b",
             //    pkt.haddr,
             //    expected_error,
             //    pkt.hresp
             //);

             return;

         end

         //======================================================================
         // 3. Expected ERROR response
         //======================================================================
         if (expected_error) begin

             expected_error_count++;
             pass_count++;

             $display(
                 "%0t [SCOREBOARD] PASS EXPECTED ERROR | %s ADDR=%08h HSIZE=%0d HRESP=%0b",
                 $time,
                 pkt.hwrite ? "WRITE" : "READ",
                 pkt.haddr,
                 pkt.hsize,
                 pkt.hresp
             );

             // Invalid transfer must not update reference memory
             return;

         end

         //======================================================================
         // 4. Legal transfer with OKAY response
         //======================================================================
         okay_count++;

         // Current reference data checking supports 32-bit transfers
         if (pkt.hsize != 3'b010) begin

             skip_count++;

             $display(
                 "%0t [SCOREBOARD] SKIP DATA CHECK | ADDR=%08h HSIZE=%0d",
                 $time,
                 pkt.haddr,
                 pkt.hsize
             );

             return;

         end

         //======================================================================
         // 5. WRITE transaction
         //======================================================================
         if (pkt.hwrite) begin

             ref_mem[pkt.haddr] = pkt.hwdata;

             pass_count++;

             $display(
                 "%0t [SCOREBOARD] WRITE PASS | ADDR=%08h DATA=%08h",
                 $time,
                 pkt.haddr,
                 pkt.hwdata
             );

         end

         //======================================================================
         // 6. READ transaction
         //======================================================================
         else begin

             // Check if address has been initialized
             if (!ref_mem.exists(pkt.haddr)) begin

                 skip_count++;

                 $display(
                     "%0t [SCOREBOARD] READ SKIP | ADDR=%08h NOT INITIALIZED",
                     $time,
                     pkt.haddr
                 );

                 return;

             end

             expected_data = ref_mem[pkt.haddr];

             // Compare read data
             if (pkt.hrdata === expected_data) begin

                 pass_count++;
                 data_pass_count++;

                 $display(
                     "%0t [SCOREBOARD] READ PASS | ADDR=%08h EXPECTED=%08h ACTUAL=%08h",
                     $time,
                     pkt.haddr,
                     expected_data,
                     pkt.hrdata
                 );

             end
             else begin

                 fail_count++;
                 data_fail_count++;

                 //$error(
                 //    "[SCOREBOARD] READ FAIL | ADDR=%08h EXPECTED=%08h ACTUAL=%08h",
                 //    pkt.haddr,
                 //    expected_data,
                 //    pkt.hrdata
                 //);

             end

         end

     endfunction

     //==========================================================================
     // Scoreboard main task
     //==========================================================================
     task run();

         packet pkt;

         $display("%0t [SCOREBOARD] Start", $time);

         forever begin

             m2s_mb.get(pkt);

             check_pkt(pkt);

         end

     endtask

     //==========================================================================
     // Final report
     //==========================================================================
     function void report();

         $display("");
         $display("================================================");
         $display("              AHB SCOREBOARD REPORT             ");
         $display("================================================");
         $display("TOTAL TRANSACTIONS : %0d", total_count);
         $display("WRITE TRANSACTIONS : %0d", write_count);
         $display("READ TRANSACTIONS  : %0d", read_count);
         $display("------------------------------------------------");
         $display("OKAY RESPONSES     : %0d", okay_count);
         $display("EXPECTED ERRORS    : %0d", expected_error_count);
         $display("UNEXPECTED ERRORS  : %0d", unexpected_error_count);
         $display("------------------------------------------------");
         $display("DATA PASS          : %0d", data_pass_count);
         $display("DATA FAIL          : %0d", data_fail_count);
         $display("SKIPPED DATA CHECK : %0d", skip_count);
         $display("------------------------------------------------");
         $display("TOTAL PASS         : %0d", pass_count);
         $display("TOTAL FAIL         : %0d", fail_count);
         $display("================================================");

         if (fail_count == 0 && total_count > 0)
             $display("[SCOREBOARD] TEST COMPLETED WITH NO DETECTED FAILURES");
         else
             $display("[SCOREBOARD] TEST HAS FAILURES OR NO TRANSACTIONS");

         $display("================================================");

     endfunction

 endclass

