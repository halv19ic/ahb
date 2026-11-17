class packet;

   // import ahb_pkg ::*;
    // AHB Slave Transaction
    rand bit              hsel;
    rand bit [ADDR_W-1:0] haddr;
    rand bit [DATA_W-1:0] hwdata;
    rand bit              hwrite;
    rand bit [2:0]        hburst;
    rand bit [2:0]        hsize;
    rand bit [1:0]        htrans;
    rand bit [3:0]        hprot;
    rand bit              hsmartlock;
    rand bit              hready;

    // DUT response signals
    logic [DATA_W-1:0] hrdata;
    logic              hresp;
    // Constructor
    function new();
    endfunction

    // Display packet information
    function void display();
        $display("-----------------------------------");
        $display("[PACKET] AHB Transaction");
        $display("HSEL      = %0b", hsel);
        $display("HADDR     = %0h", haddr);
        $display("HWDATA    = %0h", hwdata);
        $display("HWRITE    = %0b", hwrite);
        $display("HBURST    = %0b", hburst);
        $display("HSIZE     = %0b", hsize);
        $display("HTRANS    = %0b", htrans);
        $display("HPROT     = %0b", hprot);
        $display("HSMARTLOCK= %0b", hsmartlock);
        $display("HREADY    = %0b", hready);
        $display("-----------------------------------");
    endfunction

endclass
