library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity memoria is
   generic (
          dataWidth: natural := 4;
          addrWidth: natural := 3
    );
   port (
          Endereco : in std_logic_vector (addrWidth-1 DOWNTO 0);
          Dado : out std_logic_vector (dataWidth-1 DOWNTO 0)
    );
end entity;

architecture assincrona of memoria is

  type blocoMemoria is array(0 TO 2**addrWidth - 1) of std_logic_vector(dataWidth-1 DOWNTO 0);
	
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
	
  function initMemory
        return blocoMemoria is variable tmp : blocoMemoria := (others => (others => '0'));
  begin
      
tmp(0) := LDI & "000" & "000000000"; -- LDI #0 $0
tmp(1) := LDI & "001" & "000000000"; -- LDI #1 $0
tmp(2) := LDI & "010" & "000000000"; -- LDI #2 $0
tmp(3) := LDI & "011" & "000000000"; -- LDI #3 $0
tmp(4) := LDI & "100" & "000000000"; -- LDI #4 $0
tmp(5) := LDI & "101" & "000000000"; -- LDI #5 $0
tmp(6) := LDI & "110" & "000000000"; -- LDI #6 $0
tmp(7) := STA & "110" & "100100000"; -- STA #6 @288
tmp(8) := STA & "110" & "100100001"; -- STA #6 @289
tmp(9) := STA & "110" & "100100010"; -- STA #6 @290
tmp(10) := STA & "110" & "100100011"; -- STA #6 @291
tmp(11) := STA & "110" & "100100100"; -- STA #6 @292
tmp(12) := STA & "110" & "100100101"; -- STA #6 @293
tmp(13) := STA & "110" & "000000000"; -- STA #6 @0
tmp(14) := LDI & "111" & "000001001"; -- LDI #7 $9
tmp(15) := STA & "111" & "000001001"; -- STA #7 @9
tmp(16) := LDI & "111" & "000000101"; -- LDI #7 $5
tmp(17) := STA & "111" & "000000101"; -- STA #7 @5
tmp(18) := LDI & "111" & "000000001"; -- LDI #7 $1
tmp(19) := STA & "111" & "000000001"; -- STA #7 @1
tmp(20) := LDA & "111" & "000000010"; -- LDA #7 $2
tmp(21) := STA & "111" & "000000010"; -- STA #7 @2
tmp(22) := LDA & "111" & "000000100"; -- LDA #7 $4
tmp(23) := STA & "111" & "000000100"; -- STA #7 @4
tmp(24) := LDA & "111" & "000000000"; -- LDA #7 $0
tmp(25) := LDA & "111" & "111111011"; -- LDA #7 @507
tmp(26) := CEQ & "111" & "000000000"; -- CEQ #7 @0
tmp(27) := JEQ & "000" & "000011001"; -- JEQ %INICIO
tmp(28) := STA & "000" & "111111100"; -- STA #0 @508
tmp(29) := JSR & "000" & "000100000"; -- JSR %RELOGIO
tmp(30) := JMP & "000" & "000011001"; -- JMP %INICIO

-- RELOGIO
tmp(32) := SOMA & "000" & "000000001"; -- SOMA #0 @1
tmp(33) := GRT & "000" & "000001001"; -- GRT #0 @9
tmp(34) := JGT & "000" & "000100101"; -- JGT %INCDEZSEC
tmp(35) := STA & "000" & "100100000"; -- STA #0 @288
tmp(36) := JMP & "000" & "001101010"; -- JMP %FIMRELOGIO
tmp(37) := LDI & "000" & "000000000"; -- LDI #0 $0
tmp(38) := STA & "000" & "100100000"; -- STA #0 @288
tmp(39) := SOMA & "001" & "000000001"; -- SOMA #1 @1
tmp(40) := GRT & "001" & "000000101"; -- GRT #1 @5
tmp(41) := JGT & "000" & "000101100"; -- JGT %INCUNIMIN
tmp(42) := STA & "001" & "100100001"; -- STA #1 @289
tmp(43) := JMP & "000" & "001101010"; -- JMP %FIMRELOGIO
tmp(44) := LDI & "000" & "000000000"; -- LDI #0 $0
tmp(45) := LDI & "001" & "000000000"; -- LDI #1 $0
tmp(46) := STA & "000" & "100100000"; -- STA #0 @288
tmp(47) := STA & "001" & "100100001"; -- STA #1 @289
tmp(48) := SOMA & "010" & "000000001"; -- SOMA #2 @1
tmp(49) := GRT & "010" & "000001001"; -- GRT #2 @9
tmp(50) := JGT & "000" & "000110101"; -- JGT %INCDEZMIN
tmp(51) := STA & "010" & "100100010"; -- STA #2 @290
tmp(52) := JMP & "000" & "001101010"; -- JMP %FIMRELOGIO
tmp(53) := LDI & "000" & "000000000"; -- LDI #0 $0
tmp(54) := LDI & "001" & "000000000"; -- LDI #1 $0
tmp(55) := LDI & "010" & "000000000"; -- LDI #2 $0
tmp(56) := STA & "000" & "100100000"; -- STA #0 @288
tmp(57) := STA & "001" & "100100001"; -- STA #1 @289
tmp(58) := STA & "010" & "100100010"; -- STA #2 @290
tmp(59) := SOMA & "011" & "000000001"; -- SOMA #3 @1
tmp(60) := GRT & "011" & "000000101"; -- GRT #3 @5
tmp(61) := JGT & "000" & "001000000"; -- JGT %INCUNIHORA
tmp(62) := STA & "011" & "100100011"; -- STA #3 @291
tmp(63) := JMP & "000" & "001101010"; -- JMP %FIMRELOGIO
tmp(64) := LDI & "000" & "000000000"; -- LDI #0 $0
tmp(65) := LDI & "001" & "000000000"; -- LDI #1 $0
tmp(66) := LDI & "010" & "000000000"; -- LDI #2 $0
tmp(67) := LDI & "011" & "000000000"; -- LDI #3 $0
tmp(68) := STA & "000" & "100100000"; -- STA #0 @288
tmp(69) := STA & "001" & "100100001"; -- STA #1 @289
tmp(70) := STA & "010" & "100100010"; -- STA #2 @290
tmp(71) := STA & "011" & "100100011"; -- STA #3 @291
tmp(72) := SOMA & "100" & "000000001"; -- SOMA #4 @1
tmp(73) := GRT & "101" & "000000010"; -- GRT #5 @2
tmp(74) := JGT & "000" & "001001111"; -- JGT %LIMITEHORA4
tmp(75) := GRT & "100" & "000001001"; -- GRT #4 @9
tmp(76) := JGT & "000" & "001010001"; -- JGT %INCDEZHORA
tmp(77) := STA & "100" & "100100100"; -- STA #4 @292
tmp(78) := JMP & "000" & "001101010"; -- JMP %FIMRELOGIO
tmp(79) := GRT & "100" & "000000100"; -- GRT #4 @4
tmp(80) := JGT & "000" & "001011110"; -- JGT %ZERATUDO
tmp(81) := LDI & "000" & "000000000"; -- LDI #0 $0
tmp(82) := LDI & "001" & "000000000"; -- LDI #1 $0
tmp(83) := LDI & "010" & "000000000"; -- LDI #2 $0
tmp(84) := LDI & "011" & "000000000"; -- LDI #3 $0
tmp(85) := LDI & "100" & "000000000"; -- LDI #4 $0
tmp(86) := STA & "000" & "100100000"; -- STA #0 @288
tmp(87) := STA & "001" & "100100001"; -- STA #1 @289
tmp(88) := STA & "010" & "100100010"; -- STA #2 @290
tmp(89) := STA & "011" & "100100011"; -- STA #3 @291
tmp(90) := STA & "100" & "100100100"; -- STA #4 @292
tmp(91) := SOMA & "101" & "000000001"; -- SOMA #5 @1
tmp(92) := STA & "101" & "100100101"; -- STA #5 @293
tmp(93) := JMP & "000" & "001101010"; -- JMP %FIMRELOGIO
tmp(94) := LDI & "000" & "000000000"; -- LDI #0 $0
tmp(95) := LDI & "001" & "000000000"; -- LDI #1 $0
tmp(96) := LDI & "010" & "000000000"; -- LDI #2 $0
tmp(97) := LDI & "011" & "000000000"; -- LDI #3 $0
tmp(98) := LDI & "100" & "000000000"; -- LDI #4 $0
tmp(99) := LDI & "101" & "000000000"; -- LDI #5 $0
tmp(100) := STA & "000" & "100100000"; -- STA #0 @288
tmp(101) := STA & "001" & "100100001"; -- STA #1 @289
tmp(102) := STA & "010" & "100100010"; -- STA #2 @290
tmp(103) := STA & "011" & "100100011"; -- STA #3 @291
tmp(104) := STA & "100" & "100100100"; -- STA #4 @292
tmp(105) := STA & "101" & "100100101"; -- STA #5 @293
tmp(106) := RET & "000" & "000000000"; -- RET



		 return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM(to_integer(unsigned(Endereco)));
end architecture;