//==============================================================================
// Company      : 
// File         : ahb_m_v2.sv
// Author       : vinhha
// Created      : 2026-11-15
// Last Modified: 2026-11-17
//==============================================================================
// Description  :
//
//==============================================================================
module ahb_m #(
parameter   DATA_W =32,
parameter   ADDR_W =32,
parameter   BEAT_LEN =5
)(
input  logic                clk,
input  logic                rstn,

//User command Inteface
output logic                cmd_ready_o,
input  logic                cmd_vld_i,
input  logic [3:0]          cmd_id_i,// define later
input  logic [BEAT_LEN-1:0] len_i,
input  logic [2:0]          burst_i, 
input  logic                write_i, 
input  logic [2:0]          size_i, 
input  logic [3:0]          prot_i, 
input  logic                busy_i, 
//User Address
input  logic [ADDR_W-1:0]   addr_i, 
//User Data
input  logic [DATA_W-1:0]   wdata_i, 


//AHB Interface
output logic [ADDR_W-1:0]   haddr_o, 
output logic [2:0]          hburst_o, 
output logic [2:0]          hsize_o, 
output logic [1:0]          htrans_o, 
output logic [3:0]          hprot_o, 
output logic                hsmartlock_o , 
output logic                hwrite_o , 

output logic [DATA_W-1:0]   hwdata_o,

input  logic                hready_i, 
input  logic [DATA_W-1:0]   hrdata_i, 
input  logic                hresp_i 
); 

//Command & Address Declared
logic                       cmd_vld;
logic                       ap_done;
logic                       dp_vld_d;
logic                       dp_vld_r;
logic                       get_new_cmd;

//Address Logic
logic [ADDR_W-1:0]          haddr_d;
logic [ADDR_W-1:0]          haddr_r;
logic [ADDR_W-1:0]          addr_base;
logic [11:0]                addr_bound;
logic [ADDR_W-1:0]          addr_wrap_point;
logic [ADDR_W-1:0]          addr_store;
logic                       wrap_burst_en; 
logic [ADDR_W-1:0]          nxt_addr;
logic [ADDR_W-1:0]          nxt_addr_incr;
logic [ADDR_W-1:0]          nxt_addr_wrap;
logic                       inc_burst_mode;
logic                       wrap_burst_mode;
logic                       inc_burst_en;
logic [7:0]                 bit_mask;
logic [3:0]                 wrap_type;


logic [2:0]                 hburst_d;
logic [2:0]                 hsize_d;
logic [1:0]                 htrans_d;
logic                       hwrite_d;

//Counter
logic                       bcnt_en;
logic                       bcnt_clr;
logic [4:0]                 bcnt_d;
logic [4:0]                 bcnt_r;
logic                       last_beat;
typedef enum logic [1:0] {
    ST_IDLE   = 2'b00,
    ST_BUSY   = 2'b01,
    ST_SINGLE = 2'b10,
    ST_BURST  = 2'b11
} state;

state nxt_state;
state current_state;
logic [1:0] cur_state;

//===================================
//FSM
logic                   idle_to_single;
logic                   idle_to_burst;
logic                   single_to_idle;
logic                   burst_to_idle;
logic                   burst_to_busy;
logic                   busy_to_burst;
logic                   busy_to_idle;

logic                   nxt_trans_vld;

assign nxt_trans_vld  = hready_i & dp_vld_r;
assign idle_to_single = (cmd_vld && (burst_i == 3'b000))  & (cur_state == ST_IDLE); 
assign idle_to_burst  = (cmd_vld && (burst_i != 3'b000))  & (cur_state == ST_IDLE);  
assign single_to_idle = nxt_trans_vld & 
                        (cur_state == ST_SINGLE);     
assign burst_to_idle  = nxt_trans_vld           &
                        (cur_state == ST_BURST) &
                        last_beat;     

assign burst_to_busy  = nxt_trans_vld           &
                        (cur_state == ST_BURST) &
                        (busy_i & dp_vld_r);     
assign busy_to_burst  = nxt_trans_vld &
                        (cur_state == ST_BUSY)  &
                        ~(busy_i & dp_vld_r);     
assign busy_to_idle   = 1'b0;

always_comb begin 
case(cur_state) 
    ST_IDLE:    nxt_state = idle_to_single ? ST_SINGLE : 
                            idle_to_burst  ? ST_BURST  : ST_IDLE;

    ST_SINGLE:  nxt_state = single_to_idle ? ST_IDLE   : ST_SINGLE;

    ST_BURST:   nxt_state = burst_to_idle  ? ST_IDLE   :          
                            burst_to_busy  ? ST_BUSY   : ST_BURST;
    ST_BUSY:    nxt_state = busy_to_burst  ? ST_BURST  :    
                            busy_to_idle   ? ST_IDLE   : ST_BUSY;
    default: nxt_state = ST_IDLE;
endcase 
end

dff_rstn #(2) r_state (.clk(clk), .rstn(rstn), .d(nxt_state), .q(cur_state));

//This code to show the state in waveform for easily debug
assign current_state = (cur_state == 2'b00) ? ST_IDLE : 
                       (cur_state == 2'b01) ? ST_BUSY : 
                       (cur_state == 2'b10) ? ST_SINGLE :  ST_BURST;

//===================================
//Update New Command
//===================================
assign cmd_vld = cmd_vld_i;
assign get_new_cmd = (nxt_state==ST_IDLE);
dff_rstn #(1) r_cmd_ready (.clk(clk), .rstn(rstn), .d(get_new_cmd), .q(cmd_ready_o));

//Hburst
assign hburst_d = cmd_vld ? burst_i : hburst_o;
dff_rstn #(3) r_hburst (.clk(clk), .rstn(rstn), .d(hburst_d), .q(hburst_o));

//Hsize
assign hsize_d = cmd_vld ? size_i : hsize_o ;
dff_rstn #(3) r_hsize (.clk(clk), .rstn(rstn), .d(hsize_d), .q(hsize_o));


//Read/Write
assign hwrite_d = cmd_vld ? write_i : hwrite_o;
dff_rstn #(1) r_write (.clk(clk), .rstn(rstn), .d(hwrite_d), .q(hwrite_o));

//Write Data
dff_rstn #(DATA_W) r_wdata (.clk(clk), .rstn(rstn), .d(wdata_i), .q(hwdata_o));


//===================================
//Address Phase
assign ap_done = htrans_o[1] &
                 (cur_state != 2'b00)    &
                 hready_i    ;

//Data Phase
assign dp_vld_d = hready_i ? ap_done : dp_vld_r;
dff_rstn #(1) r_dp_vld (.clk(clk), .rstn(rstn), .d(dp_vld_d), .q(dp_vld_r));


//===================================
//Transaction Generator

logic idle_trans;
logic busy_trans;
logic nonseq_trans;
logic seq_trans;

//-Transfer Type 
localparam [1:0] IDLE_TRANS   = 2'b00;
localparam [1:0] BUSY_TRANS   = 2'b01;
localparam [1:0] NONSEQ_TRANS = 2'b10;
localparam [1:0] SEQ_TRANS    = 2'b11;

assign idle_trans   = (nxt_state == ST_IDLE);
assign busy_trans   = (nxt_state == ST_BUSY);
assign nonseq_trans = (nxt_state == ST_SINGLE) ;
                      //((nxt_state == BURST) & (bcnt_d == 5'd1));

assign htrans_d = idle_trans   ? IDLE_TRANS   : 
                  busy_trans   ? BUSY_TRANS   :
                  nonseq_trans ? NONSEQ_TRANS : SEQ_TRANS;

dff_rstn #(3) r_htrans (.clk(clk), .rstn(rstn), .d(htrans_d), .q(htrans_o));

//===================================
// Beat Counter
assign bcnt_en  =   nxt_trans_vld       &
                    (nxt_state != ST_IDLE) &
                    (nxt_state != ST_BUSY);

assign bcnt_clr = cmd_vld;
assign bcnt_d   = bcnt_clr ? '0 : 
                  bcnt_en  ? (bcnt_r + 1'b1) : bcnt_r;
dff_rstn #(5) r_bcnt (.clk(clk), .rstn(rstn), .d(bcnt_d), .q(bcnt_r));

assign last_beat =   //burst_d  == 3'b000 |
                    //(hburst_d[2:1] == 2'b00)  && (bcnt_d == (inc_len_d -1'b1)) |
                    ((hburst_d[2:1] == 2'b01)  && (bcnt_r == 5'd3))              | //WRAP4 or INCR4
                    ((hburst_d[2:1] == 2'b10)  && (bcnt_r == 5'd7))              | //WRAP8 or INCR8
                    ((hburst_d[2:1] == 2'b11)  && (bcnt_r == 5'd15));              //WRAP16 or INCR16

//===================================
//• ADDRESS GENERATOR
//HSIZE [2:0] indicates the size of data transfer
//HSIZE in conjunction with HBURST determines the address boundary for wrapping bursts.


//Address With Increase Mode
//Incrementing bursts access sequential locations and the address of each transfer in the burst is an increment of the previous address.
//HSIZE [2:0] indicates the size of data transfer
//HSIZE [2:0] = 3'b000 - 1 byte
//HSIZE [2:0] = 3'b001 - Halfword
//HSIZE [2:0] = 3'b010 - Word  
//HSIZE [2:0] = 3'b011 - DoubleWord  
//HSIZE [2:0] = 3'b100 - 4-Word Line  
//HSIZE [2:0] = 3'b101 - 8-Word Line  
localparam [2:0] HBURST_SINGLE = 3'b000;
localparam [2:0] HBURST_INCR   = 3'b001;
localparam [2:0] HBURST_WRAP4  = 3'b010;
localparam [2:0] HBURST_INCR4  = 3'b011;
localparam [2:0] HBURST_WRAP8  = 3'b100;
localparam [2:0] HBURST_INCR8  = 3'b101;
localparam [2:0] HBURST_WRAP16 = 3'b110;
localparam [2:0] HBURST_INCR16 = 3'b111;

assign inc_burst_mode  = (cur_state == ST_BURST) & ((hburst_d == HBURST_INCR)     | 
                                                    (hburst_d == HBURST_INCR4)    |
                                                    (hburst_d == HBURST_INCR8)    |
                                                    (hburst_d == HBURST_INCR16));

assign wrap_burst_mode =  (cur_state == ST_BURST) & ((hburst_d == HBURST_WRAP4)    |
                                                    (hburst_d == HBURST_WRAP8)    |
                                                    (hburst_d == HBURST_WRAP16));

assign inc_burst_en    = inc_burst_mode &
                         nxt_trans_vld  &
                         (~last_beat);
assign wrap_burst_en   = wrap_burst_mode &
                         nxt_trans_vld   &
                         (~last_beat);

assign nxt_addr_incr = ((hsize_d == 3'b000) & (cur_state == ST_BURST)) ?  (haddr_o + 8'd1 )  : 
                       ((hsize_d == 3'b001) & (cur_state == ST_BURST)) ?  (haddr_o + 8'd2 )  :
                       ((hsize_d == 3'b010) & (cur_state == ST_BURST)) ?  (haddr_o + 8'd4 )  :
                       ((hsize_d == 3'b011) & (cur_state == ST_BURST)) ?  (haddr_o + 8'd8 )  :
                       ((hsize_d == 3'b100) & (cur_state == ST_BURST)) ?  (haddr_o + 8'd16)  :
                       ((hsize_d == 3'b101) & (cur_state == ST_BURST)) ?  (haddr_o + 8'd32)  :
                       ((hsize_d == 3'b110) & (cur_state == ST_BURST)) ?  (haddr_o + 8'd64)  : (haddr_o + 8'd128);

//• Wrapping bursts wrap when they cross an address boundary. The address boundary is calculated as the 
//product of the number of beats in a burst and the size of the transfer. The number of beats are controlled by 
//HBURST and the transfer size is controlled by HSIZE.

//Boundary = HSIZE x HBURST 
//Example: HSIZE  = WORD  (4-byte)
//         HBURST = WRAP4 (4-beat)
//      => Boundary = 4 x 4 = 16 (bytes)

//Algorism:                     
//                   Addr_input 
//                        & 
//                  (Hsize << 1'b1)
//                ---------------------
//                   BaseAddress        

//Wrap Address = BaseAddress + AddrBoundary
assign wrap_type  = (wrap_burst_mode & (hburst_d == HBURST_WRAP4))  ? 4'b0010 :
                    (wrap_burst_mode & (hburst_d == HBURST_WRAP8))  ? 4'b0100 :
                    (wrap_burst_mode & (hburst_d == HBURST_WRAP16)) ? 4'b1000 : 4'b0000;

assign addr_bound = ((hsize_d == 3'b000) & wrap_burst_mode) ?  (wrap_type << 4'd1)  : 
                    ((hsize_d == 3'b001) & wrap_burst_mode) ?  (wrap_type << 4'd2)  :
                    ((hsize_d == 3'b010) & wrap_burst_mode) ?  (wrap_type << 4'd3)  :
                    ((hsize_d == 3'b011) & wrap_burst_mode) ?  (wrap_type << 4'd4)  :
                    ((hsize_d == 3'b100) & wrap_burst_mode) ?  (wrap_type << 4'd5)  :
                    ((hsize_d == 3'b101) & wrap_burst_mode) ?  (wrap_type << 4'd6)  :
                    ((hsize_d == 3'b110) & wrap_burst_mode) ?  (wrap_type << 4'd7)  : 
                    ((hsize_d == 3'b111) & wrap_burst_mode) ?  (wrap_type << 4'd8)  : '0;

assign addr_store = cmd_vld_i ? addr_i : haddr_r;
dff_rstn #(ADDR_W) r_haddr_1 (.clk(clk), .rstn(rstn), .d(addr_store), .q(haddr_r));

assign addr_base       =  haddr_r   &  (addr_bound); 
assign addr_wrap_point =  addr_base +  (addr_bound - 1'd1);
assign wrap_en         = (nxt_addr_incr >  addr_wrap_point) & 
                         (cur_state == ST_BURST); 

assign nxt_addr_wrap   = wrap_en ? addr_base : nxt_addr_incr;
assign haddr_d         = cmd_vld_i       ? addr_i        :
                         wrap_burst_en   ? nxt_addr_wrap :       
                         inc_burst_en    ? nxt_addr_incr : haddr_o;

dff_rstn #(ADDR_W) r_haddr (.clk(clk), .rstn(rstn), .d(haddr_d), .q(haddr_o));



endmodule
