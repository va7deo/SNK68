
// simple read-only cache 
// todo - parameterize 
module tile_cache
(
    input reset,
    input clk,

    input cache_req,
    input [19:0] cache_addr,

    output reg cache_valid,
    output reg [31:0] cache_data,

    input  [31:0] rom_data,
    input  rom_valid,
    
    output reg rom_req,
    output reg [19:0] rom_addr
);

reg  [1023:0] valid ;
reg  [15:0] cache_din;
wire [15:0] cache_dout;
reg  [2:0]  state;
reg  [9:0]  idx;
reg  [9:0]  idx_w;
reg         cache_w;

reg  [9:0]  tag_din;
reg  [9:0]  tag_dout;
reg  [19:0] last_addr;

always @ (posedge clk) begin
    if ( reset == 1 ) begin
        valid <= 0;
        state <= 0;
        rom_req <= 0;
        cache_w <= 0;
        cache_valid <= 0;
    end else begin
        if ( state == 0 && cache_req == 1) begin
            // setup read
            idx <= cache_addr[9:0] ;
            state <= 1;
        end else if ( state == 1 ) begin
            // idx valid
            state <= 2;
        end else if ( state == 2 ) begin            
            last_addr <= cache_addr;

            // tag valid
            if ( tag_dout[9:0] == cache_addr[19:10] && valid[idx] == 1 ) begin
                // cache hit
                cache_valid <= 1;
                cache_data  <= cache_dout ;
                state <= 4;
            end else begin
                rom_req <= 1;
                rom_addr <= cache_addr;
                state <= 3;
            end
        end else if ( state == 3 && rom_valid == 1 ) begin                        
            cache_valid <= 1;
            cache_data  <= rom_data ;
            state <= 4;
            
            idx_w <= idx;
            valid[idx] <= 1;
            tag_din <= cache_addr[19:10];
            cache_din <= rom_data ;
            cache_w <= 1;
        end else if ( state == 4 ) begin 
            cache_w <= 0;
            rom_req <= 0;        
            if ( cache_req == 0 || cache_addr != last_addr ) begin
                cache_valid <= 0;
                state <= 0;
            end
        end
    end
end

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
    
dual_port_ram #(.LEN(1024), .DATA_WIDTH(32)) cache_ram (
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