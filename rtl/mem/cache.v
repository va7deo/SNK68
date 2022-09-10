
// simple read-only cache 
// todo - parameterize 
module cache
(
    input reset,
    input clk,

    input cache_req,
    input [22:0] cache_addr,

    output reg cache_valid,
    output reg [15:0] cache_data,

    input  [15:0] rom_data,
    input  rom_valid,
    
    output reg rom_req,
    output reg [22:0] rom_addr
);

reg [1023:0] valid ;
reg [2:0]   state = 0;

reg  [9:0] idx_w;
wire [9:0] idx = cache_addr[9:0];
wire hit;

reg [12:0]  tag_din;   // 22:10
reg [12:0]  tag_dout;

reg cache_w;

// if tag value matches the upper bits of the address 
// and valid then no need to pass request to sdram 
// assign hit = ( tag_dout[12:0] == cache_addr[22:10] && valid[idx] == 1 && state == 1 );

// assign cache_data = ( hit == 1 ) ? cache_dout : rom_data;

always @ (posedge clk) begin

    if ( reset == 1 ) begin
        state   <= 0;
        rom_req <= 0;
        cache_valid <= 0;
        // reset bits that indicate tag is valid
        valid <= 0;
    end else begin
        // wait for read request 
        if ( state == 0 ) begin
            // only initiate on state 0
            if ( cache_req == 1 ) begin
                if ( valid[idx] == 0 ) begin
                    // need to read from rom

                    cache_valid <= 0 ;
                    idx_w <= idx;
                    
                    // we need to read from sdram
                    rom_req  <= 1;
                    rom_addr <= cache_addr;

                    state <= 2;
                end else begin
                    // might be valid.  check tag
                    state <= 1;
                end
            end
        end else if ( state == 1 ) begin
            if ( tag_dout[12:0] == cache_addr[22:10] ) begin
                cache_valid <= 1 ;
                cache_data <= cache_dout ;
                state <= 0;
            end else begin
                cache_valid <= 0 ;
                idx_w <= idx;
                
                // we need to read from sdram
                rom_req <= 1;
                rom_addr <= cache_addr;

                state <= 2;
            end
        end else if ( state == 2 && rom_valid == 1 ) begin
            // cancel rom read
            rom_req <= 0;
            valid[idx_w] <= 1;
            
            cache_valid <= 1 ;
            cache_data <= rom_data;
            
            // write updated tag
            tag_din <= rom_addr[22:10] ; // addr
            cache_din <= rom_data;

            cache_w <= 1;
            
            state <= 3;
        end else if ( state == 3 ) begin
            cache_w <= 0;
            state <= 0;
        end
    end
end

reg  [15:0] cache_din;
wire [15:0] cache_dout;

// could be one wider ram
dual_port_ram #(.LEN(1024), .DATA_WIDTH(16)) tag_ram (
    .clock_a ( clk ),
    .address_a ( idx_w ),
    .wren_a ( cache_w  ),
    .data_a ( tag_din ),
    .q_a (  ),

    .clock_b ( clk ),
    .address_b ( idx ),
    .wren_b ( 0 ),
    .q_b ( tag_dout )
    );
    
dual_port_ram #(.LEN(1024), .DATA_WIDTH(16)) cache_ram (
    .clock_a ( clk ),
    .address_a ( idx_w ),
    .wren_a ( cache_w ),
    .data_a ( cache_din ),
    .q_a (  ),

    .clock_b ( clk ),
    .address_b ( idx ),
    .wren_b ( 0 ),
    .q_b ( cache_dout )
    );


endmodule

