`timescale 1ns / 1ps

module test;

reg                    rst;
reg                    clk;
reg                    cen;  // 640kHz
reg                    stn;  // STart (active low)
reg                    cs;
reg                    mdn;  // MODE: 1 for stand alone mode; 0 for slave mode
wire                   busyn;
// CPU interface
reg                    wrn;  // for slave mode only
reg           [ 7:0]   din;
// ROM interface
wire                   rom_cs;      // equivalent to DRQn in original chip
wire          [16:0]   rom_addr;
reg           [ 7:0]   rom_data;
reg                    rom_ok;
// Sound wire  
wire   signed [ 8:0]   sound;

reg [7:0] rom[0:(2**17)-1];
reg       last_busy, last_cs;
reg [16:0] last_addr;

integer f, fcnt;

initial begin
    f=$fopen("test.rom","rb");
    if( f == 0 ) begin
        $display("You need a valid ROM file. You can use one from an arcade game.");
        $display("It must be named test.rom");
        $finish;
    end
    fcnt=$fread(rom,f);
    $fclose(f);
    $display("%d-long file read as ROM",fcnt);
end

initial begin
    clk = 0;
    forever #1562.5 clk = ~clk; // 1280kHz clock
end

initial begin
    cen = 0;
    stn = 1;
    cs  = 1;
    mdn = 1;
    wrn = 1;
    din = 8'd0;
    rst = 1;
    #3000 rst=0;
    //#10_000_000_0000 $finish;
end

always @(posedge clk) cen<=~cen;

always @(posedge clk) begin
    last_busy <= busyn;
    if( !busyn && last_busy ) begin
        $display("Next sample $%X", din);
        din<=din+1'd1;
    end
    if( din>8'h3 ) $finish;
    if( busyn ) begin
        stn <= 0;
    end else begin
        stn <= 1;
    end
end

always @(posedge clk) begin
    if( rst ) begin
        rom_ok <= 0;
    end else begin
        last_addr <= rom_addr;
        last_cs   <= rom_cs;
        rom_ok    <= (rom_cs==last_cs) && (last_addr == rom_addr);
        rom_data  <= rom[rom_addr];
    end
end

jt7759 UUT(
    .rst        ( rst       ),
    .clk        ( clk       ),
    .cen        ( cen       ),  // 640kHz
    .stn        ( stn       ),  // STart (active low)
    .cs         ( cs        ),
    .mdn        ( mdn       ),  // MODE: 1 for stand alone mode, 0 for slave mode
    .busyn      ( busyn     ),
    .wrn        ( wrn       ),  // for slave mode only
    .drqn       (           ),
    .din        ( din       ),
    .rom_cs     ( rom_cs    ),      // equivalent to DRQn in original chip
    .rom_addr   ( rom_addr  ),
    .rom_data   ( rom_data  ),
    .rom_ok     ( rom_ok    ),
    .sound      ( sound     )
);

initial begin
    $dumpfile("test.lxt");
    $dumpvars;
end

endmodule