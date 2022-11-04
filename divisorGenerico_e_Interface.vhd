LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity divisorGenerico_e_Interface is
	generic (
		divisor_normal : natural := 1;
		divisor_rapido : natural := 2
	);
   port(
		clk      		 	:   in std_logic;
      habilitaLeitura 	: in std_logic;
      limpaLeitura 	 	: in std_logic;
		sel_mux 				: in std_logic;
      leituraUmSegundo 	:   out std_logic_vector(7 DOWNTO 0)
   );
end entity;

architecture interface of divisorGenerico_e_Interface is
  signal sinalUmSegundo 			: std_logic;
  signal saidaclk_reg1seg_normal : std_logic;
  signal saidaclk_reg1seg_rapido : std_logic;
  signal saidaclk_reg1seg 			: std_logic_vector(7 DOWNTO 0);

begin

baseTempo_normal: entity work.divisorGenerico generic map (divisor => divisor_normal) 
           port map (
					clk => clk, 
					saida_clk => saidaclk_reg1seg_normal
			  );
			  
baseTempo_rapida: entity work.divisorGenerico generic map (divisor => divisor_rapido) 
           port map (
					clk => clk, 
					saida_clk => saidaclk_reg1seg_rapido
			  );

MUX_CLOCK : entity work.muxGenerico2x1 generic map (larguraDados => 8)
			port map(
				entradaA_MUX => "0000000" & saidaclk_reg1seg_normal,
				entradaB_MUX => "0000000" & saidaclk_reg1seg_rapido,
				seletor_MUX => sel_mux,
				saida_MUX => saidaclk_reg1seg
			);

registraUmSegundo: entity work.flipFlop
   port map (DIN => '1', DOUT => sinalUmSegundo,
         ENABLE => '1', CLK => saidaclk_reg1seg(0),
         RST => limpaLeitura);

-- Faz o tristate de saida:
leituraUmSegundo <= "0000000" & sinalUmSegundo when habilitaLeitura = '1' else "ZZZZZZZZ";

end architecture interface;
