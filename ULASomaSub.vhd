library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;    -- Biblioteca IEEE para funções aritméticas

entity ULASomaSub is
    generic(
			larguraDados : natural := 4
	 );
    port(
			entradaA, entradaB:  in STD_LOGIC_VECTOR((larguraDados-1) downto 0);
			seletor:  in STD_LOGIC_VECTOR(2 DOWNTO 0);
			saida:    out STD_LOGIC_VECTOR((larguraDados-1) downto 0);
			saida_flag_zero: out STD_LOGIC;
			saida_gt: out STD_LOGIC
    );
end entity;

architecture comportamento of ULASomaSub is
   signal soma :      STD_LOGIC_VECTOR((larguraDados-1) downto 0);
   signal subtracao : STD_LOGIC_VECTOR((larguraDados-1) downto 0);
	signal ceq : STD_LOGIC_VECTOR((larguraDados-1) downto 0);
	signal gt : STD_LOGIC_VECTOR((larguraDados-1) downto 0);

	begin
      soma      <= STD_LOGIC_VECTOR(unsigned(entradaA) + unsigned(entradaB));
      subtracao <= STD_LOGIC_VECTOR(unsigned(entradaA) - unsigned(entradaB));
		
		ceq <= "00000001" when (subtracao = "00000000") else "00000000"; 
		gt  <= "00000001" when entradaA > entradaB else "00000000";
		
      saida <= soma when (seletor = "001") else 
					subtracao when (seletor = "000") else
					entradaB when (seletor = "010") else
					ceq when (seletor = "011") else
					gt when (seletor = "100") else
					entradaA;
					
		saida_flag_zero <= ceq(0);
		saida_gt <= gt(0);
					
end architecture;