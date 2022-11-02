library ieee;
use ieee.std_logic_1164.all;

entity decoderInstru is
  port(
		opcode : in std_logic_vector(3 downto 0);
      saida : out std_logic_vector(14 downto 0)
  );
end entity;

architecture comportamento of decoderInstru is

  constant NOP  : std_logic_vector(3 downto 0) := "0000";
  constant LDA  : std_logic_vector(3 downto 0) := "0001";
  constant SOMA : std_logic_vector(3 downto 0) := "0010";
  constant SUB  : std_logic_vector(3 downto 0) := "0011";
  constant LDI  : std_logic_vector(3 downto 0) := "0100";
  constant STA  : std_logic_vector(3 downto 0) := "0101";
  constant JMP  : std_logic_vector(3 downto 0) := "0110";
  constant JEQ  : std_logic_vector(3 downto 0) := "0111";
  constant CEQ  : std_logic_vector(3 downto 0) := "1000";
  constant JSR  : std_logic_vector(3 downto 0) := "1001";
  constant RET  : std_logic_vector(3 downto 0) := "1010";
  constant GRT  : std_logic_vector(3 downto 0) := "1011";
  constant JGT  : std_logic_vector(3 downto 0) := "1100";
  constant ADDI : std_logic_vector(3 downto 0) := "1101";
  constant SUBI : std_logic_vector(3 downto 0) := "1110";

  alias WR 			  : std_logic is saida(0);
  alias RD 			  : std_logic is saida(1);
  alias HAB_FLAG_GT : std_logic is saida(2);
  alias HAB_FLAG_EQ : std_logic is saida(3);
  alias OP_ULA      : std_logic_vector is saida(6 DOWNTO 4);
  alias HAB_BAN_REG : std_logic is saida(7);
  alias SEL_MUX     : std_logic is saida(8);
  alias JMP_GT      : std_logic is saida(9);
  alias JMP_EQ 	  : std_logic is saida(10);
  alias JMP_SR 	  : std_logic is saida(11);
  alias RET_SR 	  : std_logic is saida(12);
  alias JUMP 		  : std_logic is saida(13);
  alias HAB_RET 	  : std_logic is saida(14);
	
 begin
		
	WR 			<= '1' when (OPCODE = STA) else '0';
	RD 			<= '1' when (OPCODE = STA OR OPCODE = SOMA OR OPCODE = SUB OR OPCODE = CEQ OR OPCODE = GRT) else '0';
	HAB_FLAG_GT <= '1' when (OPCODE = GRT) else '0';
	HAB_FLAG_EQ <= '1' when (OPCODE = CEQ) else '0';
	HAB_BAN_REG <= '1' when (OPCODE = LDA OR OPCODE = SOMA OR OPCODE = SUB OR OPCODE = LDI OR OPCODE = ADDI OR OPCODE = SUBI) else '0';
	SEL_MUX 		<= '1' when (OPCODE = LDI OR OPCODE = ADDI OR OPCODE = SUBI) else '0';
	JMP_GT 		<= '1' when (OPCODE = JGT) else '0';
	JMP_EQ 		<= '1' when (OPCODE = JEQ) else '0';
	JMP_SR 		<= '1' when (OPCODE = JSR) else '0';
	RET_SR 		<= '1' when (OPCODE = RET) else '0';
	JUMP 			<= '1' when (OPCODE = JMP) else '0';
	HAB_RET 		<= '1' when (OPCODE = JSR) else '0';
	OP_ULA 		<= "100" when (OPCODE = GRT) else 
						"011" when (OPCODE = CEQ) else
						"010" when (OPCODE = LDA OR OPCODE = LDI) else 
						"001" when (OPCODE = SOMA OR OPCODE = ADDI) else 
						"000";
 
saida <= HAB_RET & JUMP & RET_SR & JMP_SR & JMP_EQ & JMP_GT & SEL_MUX & HAB_BAN_REG & OP_ULA & HAB_FLAG_EQ & HAB_FLAG_GT & RD & WR;
--			
end architecture;