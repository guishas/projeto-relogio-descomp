library ieee;
use ieee.std_logic_1164.all;

entity HexReg is

  port(
		CLK 		: in std_logic;
		DATA_IN	: in std_logic_vector(3 DOWNTO 0);
      HABILITA : in std_logic;
		HEX		: out std_logic_vector(6 DOWNTO 0)
  );
  
end entity;

architecture arquitetura of HexReg is

	signal SIG_REG_TO_DECODER7 : std_logic_vector(3 DOWNTO 0);
	signal SIG_HEX					: std_logic_vector(6 DOWNTO 0);
	
begin

REG : entity work.registradorGenerico generic map (larguraDados => 4)
			port map(
				DIN => DATA_IN,
				DOUT => SIG_REG_TO_DECODER7,
				ENABLE => HABILITA,
				CLK => CLK,
				RST => '0'
			);
			
HEX_SEG : entity work.conversorHex7Seg 
			port map(
				dadoHex => SIG_REG_TO_DECODER7,
				apaga => '0',
				negativo => '0',
				overFlow => '0',
				saida7Seg => SIG_HEX
			);

HEX <= SIG_HEX;

end architecture;