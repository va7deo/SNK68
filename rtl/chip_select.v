//

module chip_select
(
    input        clk,
    input  [3:0] pcb,

    input [23:0] m68k_a,
    input        m68k_as_n,
    input        m68k_rw,

    input [15:0] z80_addr,
    input        MREQ_n,
    input        IORQ_n,
    input        M1_n,

    // M68K selects
    output reg m68k_rom_cs,
    output reg m68k_rom_2_cs,
    output reg m68k_ram_cs,
    output reg m68k_spr_cs,
    output reg m68k_pal_cs,
    output reg m68k_fg_ram_cs,
    output reg m68k_spr_flip_cs,
    output reg input_p1_cs,
    output reg input_p2_cs,
    output reg input_dsw1_cs,
    output reg input_dsw2_cs,
    output reg input_coin_cs,
    output reg m_invert_ctrl_cs,
    output reg m68k_latch_cs,
    output reg z80_latch_read_cs,

    // Z80 selects
    output reg   z80_rom_cs,
    output reg   z80_ram_cs,
    output reg   z80_latch_cs,

    output reg   z80_sound0_cs,
    output reg   z80_sound1_cs,
    output reg   z80_upd_cs,
    output reg   z80_upd_r_cs
);


function m68k_cs;
        input [23:0] start_address;
        input [23:0] end_address;
begin
    m68k_cs = ( m68k_a[23:0] >= start_address && m68k_a[23:0] <= end_address) & !m68k_as_n;
end
endfunction

function z80_mem_cs;
        input [15:0] base_address;
        input  [7:0] width;
begin
    z80_mem_cs = ( z80_addr >> width == base_address >> width ) & !MREQ_n;
end
endfunction

function z80_io_cs;
        input [7:0] address_lo;
begin
    z80_io_cs = ( z80_addr[7:0] == address_lo ) && !IORQ_n ;
end
endfunction

localparam pcb_A7007_A8007     = 0;  // [ikari3], [searchar], [streetsmj, streetsm1, streetsmw] - Ikari III, S.A.R., and Street Smart V1 (mame nomenclature, would be V2)
localparam pcb_A7008           = 1;  // [pow], [streetsm] - P.O.W. and Street Smart V2 (mame nomenclature, would be V1)

always @ (*) begin
    // Memory mapping based on PCB type
    case (pcb)
        pcb_A7007_A8007: begin
// 	map(0x000000, 0x03ffff).rom();
    m68k_rom_cs      <= m68k_cs( 24'h000000, 24'h03ffff ) ;
    m68k_rom_2_cs    <= m68k_cs( 24'h300000, 24'h33ffff ) ;

//	map(0x040000, 0x043fff).ram();
    m68k_ram_cs      <= m68k_cs( 24'h040000, 24'h043fff ) ; 

//  write only
//	map(0x080000, 0x080000).w(FUNC(searchar_state::sound_w));
    m68k_latch_cs   <= m68k_cs( 24'h080000, 24'h080001 ) & !m68k_rw ;
    
//  read only
//	map(0x080000, 0x080001).lr8(NAME([this] () -> u8 { return m_p1_io->read() ^ m_invert_controls; }));
    input_p1_cs      <= m68k_cs( 24'h080000, 24'h080001 ) & m68k_rw ;
    
//	map(0x080002, 0x080003).lr8(NAME([this] () -> u8 { return m_p2_io->read() ^ m_invert_controls; }));
    input_p2_cs      <= m68k_cs( 24'h080002, 24'h080003 ) ;

//	map(0x080004, 0x080005).lr8(NAME([this] () -> u8 { return m_system_io->read() ^ m_invert_controls; }));
    input_coin_cs    <= m68k_cs( 24'h080004, 24'h080005 ) ;
    
//	map(0x080006, 0x080007).lw8(NAME([this] (u8 data){ m_invert_controls = ((data & 0xff) == 0x07) ? 0xff : 0x00; } ));
    m_invert_ctrl_cs <= m68k_cs( 24'h080006, 24'h080007 ) ;
    
    m68k_spr_flip_cs <= m68k_cs( 24'h0c0000, 24'h0c0001 );
    
//	map(0x0f0000, 0x0f0001).portr("DSW1");
    input_dsw1_cs    <= m68k_cs( 24'h0f0000, 24'h0f0001 ) ;
    
//	map(0x0f0008, 0x0f0009).portr("DSW2");
    input_dsw2_cs    <= m68k_cs( 24'h0f0008, 24'h0f0009 ) ;
    
//  map(0x0f8000, 0x0f8000).r("soundlatch2", FUNC(generic_latch_8_device::read));    
    z80_latch_read_cs <= m68k_cs( 24'h0f8000, 24'h0f8001 ) ;
    
//	map(0x100000, 0x107fff).rw(m_sprites, FUNC(snk68_spr_device::spriteram_r), FUNC(snk68_spr_device::spriteram_w)).share("spriteram");   // only partially populated
    m68k_spr_cs      <= m68k_cs( 24'h100000, 24'h107fff ) ;

//	map(0x200000, 0x200fff).ram().w(FUNC(searchar_state::fg_videoram_w)).mirror(0x1000).share("fg_videoram"); /* Mirror is used by Ikari 3 */
    m68k_fg_ram_cs   <= m68k_cs( 24'h200000, 24'h200fff ) | m68k_cs( 24'h201000, 24'h201fff ) ;
    
//	map(0x400000, 0x400fff).rw(m_palette, FUNC(alpha68k_palette_device::read), FUNC(alpha68k_palette_device::write));
    m68k_pal_cs      <= m68k_cs( 24'h400000, 24'h400fff ) ;
    
    z80_rom_cs       <= ( MREQ_n == 0 && z80_addr[15:0] < 16'hf000 );
    z80_ram_cs       <= ( MREQ_n == 0 && z80_addr[15:0] >= 16'hf000 && z80_addr[15:0] < 16'hf800 );
    z80_latch_cs     <= ( MREQ_n == 0 && z80_addr[15:0] == 16'hf800 );
    
    z80_sound0_cs    <= z80_io_cs(8'h00); // ym3812 address
    z80_sound1_cs    <= z80_io_cs(8'h20); // ym3812 data
    z80_upd_cs       <= z80_io_cs(8'h40); // 7759 write
    z80_upd_r_cs     <= z80_io_cs(8'h80); // 7759 reset

        end

        pcb_A7008: begin
// 	map(0x000000, 0x03ffff).rom();
    m68k_rom_cs      <= m68k_cs( 24'h000000, 24'h03ffff ) ;

//	map(0x040000, 0x043fff).ram();
    m68k_ram_cs      <= m68k_cs( 24'h040000, 24'h043fff ) ;

//  write only
//	map(0x080000, 0x080000).w(FUNC(snk68_state::sound_w));
    m68k_latch_cs   <= m68k_cs( 24'h080000, 24'h080001 ) & !m68k_rw ;

//	map(0x0c0000, 0x0c0001).portr("SYSTEM");
    input_coin_cs    <= m68k_cs( 24'h0c0000, 24'h0c0001 ) & m68k_rw ;

    m68k_spr_flip_cs <= m68k_cs( 24'h0c0000, 24'h0c0001 ) & !m68k_rw;

//  read only
//	map(0x080000, 0x080000).lr8(NAME([this] () -> u8 { return m_p2_io->read(); }));
    input_p2_cs      <= m68k_cs( 24'h080000, 24'h080001 ) & m68k_rw ;

//  read only
//	map(0x080001, 0x080001).lr8(NAME([this] () -> u8 { return m_p1_io->read(); }));
    input_p1_cs      <= m68k_cs( 24'h080000, 24'h080001 ) ;

//	map(0x0f0000, 0x0f0001).portr("DSW1");
    input_dsw1_cs    <= m68k_cs( 24'h0f0000, 24'h0f0001 ) ;
    
//	map(0x0f0008, 0x0f0009).portr("DSW2");
    input_dsw2_cs    <= m68k_cs( 24'h0f0008, 24'h0f0009 ) ;

//	map(0x200000, 0x207fff).rw(m_sprites, FUNC(snk68_spr_device::spriteram_r), FUNC(snk68_spr_device::spriteram_w)).share("spriteram");   // only partially populated
    m68k_spr_cs      <= m68k_cs( 24'h200000, 24'h207fff ) ;

//	map(0x100000, 0x100fff).rw(FUNC(snk68_state::fg_videoram_r), FUNC(snk68_state::fg_videoram_w)).mirror(0x1000).share("fg_videoram");
    m68k_fg_ram_cs   <= m68k_cs( 24'h100000, 24'h100fff ) | m68k_cs( 24'h101000, 24'h101fff );

//	map(0x400000, 0x400fff).rw(m_palette, FUNC(alpha68k_palette_device::read), FUNC(alpha68k_palette_device::write));
    m68k_pal_cs      <= m68k_cs( 24'h400000, 24'h400fff ) ;

//	snk68_state::sound_map(address_map &map)
    z80_rom_cs       <= ( MREQ_n == 0 && z80_addr[15:0] < 16'hf000 );
    z80_ram_cs       <= ( MREQ_n == 0 && z80_addr[15:0] >= 16'hf000 && z80_addr[15:0] < 16'hf800 );
    z80_latch_cs     <= ( MREQ_n == 0 && z80_addr[15:0] == 16'hf800 );

//	snk68_state::powb_sound_io_map(address_map &map)
    z80_sound0_cs    <= z80_io_cs(8'h00); // ym3812 address
    z80_sound1_cs    <= z80_io_cs(8'h20); // ym3812 data
    z80_upd_cs       <= z80_io_cs(8'h40); // 7759 write
    z80_upd_r_cs     <= z80_io_cs(8'h80); // 7759 reset

        end
        default:;
    endcase

end

//searchar_state:

	/* top byte unknown, bottom is protection in ikari3 and streetsm */
//	map(0x0c0001, 0x0c0001).w(FUNC(searchar_state::flipscreen_w));
//	map(0x0c0000, 0x0c0001).r(FUNC(searchar_state::rotary_1_r)); /* Player 1 rotary */
//	map(0x0c8000, 0x0c8001).r(FUNC(searchar_state::rotary_2_r)); /* Player 2 rotary */
//	map(0x0d0000, 0x0d0001).r(FUNC(searchar_state::rotary_lsb_r)); /* Extra rotary bits */
//	map(0x0e0000, 0x0e0001).nopr(); /* Watchdog or IRQ ack */
//	map(0x0e8000, 0x0e8001).nopr(); /* Watchdog or IRQ ack */
//  map(0x0f0000, 0x0f0001).nopw();    /* ?? */
//	map(0x0f8000, 0x0f8000).r("soundlatch2", FUNC(generic_latch_8_device::read));
//	map(0x300000, 0x33ffff).rom().region("maincpu", 0x40000); /* Extra code bank */

//	map(0x0000, 0xefff).rom();
//	map(0xf000, 0xf7ff).ram();
//	map(0xf800, 0xf800).r(m_soundlatch, FUNC(generic_latch_8_device::read)).w("soundlatch2", FUNC(generic_latch_8_device::write));

//	map(0x00, 0x00).rw("ymsnd", FUNC(ym3812_device::status_r), FUNC(ym3812_device::address_w));
//	map(0x20, 0x20).w("ymsnd", FUNC(ym3812_device::data_w));
//	map(0x40, 0x40).w(FUNC(snk68_state::D7759_write_port_0_w));
//	map(0x80, 0x80).lw8(NAME([this] (u8 data) { m_upd7759->reset_w(BIT(data, 7)); } ));

//snk68_state:

//	map(0x0c0001, 0x0c0001).w(FUNC(snk68_state::flipscreen_w));   // + char bank
//	map(0x0e0000, 0x0e0001).nopr(); /* Watchdog or IRQ ack */
//	map(0x0e8000, 0x0e8001).nopr(); /* Watchdog or IRQ ack */

endmodule
