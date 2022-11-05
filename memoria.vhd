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
tmp(20) := LDI & "111" & "000000010"; -- LDI #7 $2
tmp(21) := STA & "111" & "000000010"; -- STA #7 @2
tmp(22) := LDI & "111" & "000000011"; -- LDI #7 $3
tmp(23) := STA & "111" & "000000011"; -- STA #7 @3
tmp(24) := LDA & "111" & "101100001"; -- LDA #7 @353
tmp(25) := CEQ & "111" & "000000001"; -- CEQ #7 @1
tmp(26) := JEQ & "000" & "000011100"; -- JEQ %SETINICIO
tmp(27) := JMP & "000" & "000011101"; -- JMP %PULASETINICIO
tmp(28) := JSR & "000" & "001110010"; -- JSR %SETINIT
tmp(29) := LDA & "111" & "111111011"; -- LDA #7 @507
tmp(30) := CEQ & "111" & "000000000"; -- CEQ #7 @0
tmp(31) := JEQ & "000" & "000011000"; -- JEQ %INICIO
tmp(32) := STA & "000" & "111111100"; -- STA #0 @508
tmp(33) := JSR & "000" & "000100100"; -- JSR %RELOGIO
tmp(34) := JMP & "000" & "000011000"; -- JMP %INICIO

-- RELOGIO
tmp(36) := ADDI & "000" & "000000001"; -- ADDI #0 $1
tmp(37) := GRT & "000" & "000001001"; -- GRT #0 @9
tmp(38) := JGT & "000" & "000101001"; -- JGT %INCDEZSEC
tmp(39) := STA & "000" & "100100000"; -- STA #0 @288
tmp(40) := JMP & "000" & "001110000"; -- JMP %FIMRELOGIO
tmp(41) := LDI & "000" & "000000000"; -- LDI #0 $0
tmp(42) := STA & "000" & "100100000"; -- STA #0 @288
tmp(43) := ADDI & "001" & "000000001"; -- ADDI #1 $1
tmp(44) := GRT & "001" & "000000101"; -- GRT #1 @5
tmp(45) := JGT & "000" & "000110000"; -- JGT %INCUNIMIN
tmp(46) := STA & "001" & "100100001"; -- STA #1 @289
tmp(47) := JMP & "000" & "001110000"; -- JMP %FIMRELOGIO
tmp(48) := LDI & "000" & "000000000"; -- LDI #0 $0
tmp(49) := LDI & "001" & "000000000"; -- LDI #1 $0
tmp(50) := STA & "000" & "100100000"; -- STA #0 @288
tmp(51) := STA & "001" & "100100001"; -- STA #1 @289
tmp(52) := ADDI & "010" & "000000001"; -- ADDI #2 $1
tmp(53) := GRT & "010" & "000001001"; -- GRT #2 @9
tmp(54) := JGT & "000" & "000111001"; -- JGT %INCDEZMIN
tmp(55) := STA & "010" & "100100010"; -- STA #2 @290
tmp(56) := JMP & "000" & "001110000"; -- JMP %FIMRELOGIO
tmp(57) := LDI & "000" & "000000000"; -- LDI #0 $0
tmp(58) := LDI & "001" & "000000000"; -- LDI #1 $0
tmp(59) := LDI & "010" & "000000000"; -- LDI #2 $0
tmp(60) := STA & "000" & "100100000"; -- STA #0 @288
tmp(61) := STA & "001" & "100100001"; -- STA #1 @289
tmp(62) := STA & "010" & "100100010"; -- STA #2 @290
tmp(63) := ADDI & "011" & "000000001"; -- ADDI #3 $1
tmp(64) := GRT & "011" & "000000101"; -- GRT #3 @5
tmp(65) := JGT & "000" & "001000100"; -- JGT %INCUNIHORA
tmp(66) := STA & "011" & "100100011"; -- STA #3 @291
tmp(67) := JMP & "000" & "001110000"; -- JMP %FIMRELOGIO
tmp(68) := LDI & "000" & "000000000"; -- LDI #0 $0
tmp(69) := LDI & "001" & "000000000"; -- LDI #1 $0
tmp(70) := LDI & "010" & "000000000"; -- LDI #2 $0
tmp(71) := LDI & "011" & "000000000"; -- LDI #3 $0
tmp(72) := STA & "000" & "100100000"; -- STA #0 @288
tmp(73) := STA & "001" & "100100001"; -- STA #1 @289
tmp(74) := STA & "010" & "100100010"; -- STA #2 @290
tmp(75) := STA & "011" & "100100011"; -- STA #3 @291
tmp(76) := ADDI & "100" & "000000001"; -- ADDI #4 $1
tmp(77) := GRT & "101" & "000000001"; -- GRT #5 @1
tmp(78) := JGT & "000" & "001010011"; -- JGT %LIMITEHORA4
tmp(79) := GRT & "100" & "000001001"; -- GRT #4 @9
tmp(80) := JGT & "000" & "001010111"; -- JGT %INCDEZHORA
tmp(81) := STA & "100" & "100100100"; -- STA #4 @292
tmp(82) := JMP & "000" & "001110000"; -- JMP %FIMRELOGIO
tmp(83) := GRT & "100" & "000000011"; -- GRT #4 @3
tmp(84) := JGT & "000" & "001100100"; -- JGT %ZERATUDO
tmp(85) := STA & "100" & "100100100"; -- STA #4 @292
tmp(86) := JMP & "000" & "001110000"; -- JMP %FIMRELOGIO
tmp(87) := LDI & "000" & "000000000"; -- LDI #0 $0
tmp(88) := LDI & "001" & "000000000"; -- LDI #1 $0
tmp(89) := LDI & "010" & "000000000"; -- LDI #2 $0
tmp(90) := LDI & "011" & "000000000"; -- LDI #3 $0
tmp(91) := LDI & "100" & "000000000"; -- LDI #4 $0
tmp(92) := STA & "000" & "100100000"; -- STA #0 @288
tmp(93) := STA & "001" & "100100001"; -- STA #1 @289
tmp(94) := STA & "010" & "100100010"; -- STA #2 @290
tmp(95) := STA & "011" & "100100011"; -- STA #3 @291
tmp(96) := STA & "100" & "100100100"; -- STA #4 @292
tmp(97) := ADDI & "101" & "000000001"; -- ADDI #5 $1
tmp(98) := STA & "101" & "100100101"; -- STA #5 @293
tmp(99) := JMP & "000" & "001110000"; -- JMP %FIMRELOGIO
tmp(100) := LDI & "000" & "000000000"; -- LDI #0 $0
tmp(101) := LDI & "001" & "000000000"; -- LDI #1 $0
tmp(102) := LDI & "010" & "000000000"; -- LDI #2 $0
tmp(103) := LDI & "011" & "000000000"; -- LDI #3 $0
tmp(104) := LDI & "100" & "000000000"; -- LDI #4 $0
tmp(105) := LDI & "101" & "000000000"; -- LDI #5 $0
tmp(106) := STA & "000" & "100100000"; -- STA #0 @288
tmp(107) := STA & "001" & "100100001"; -- STA #1 @289
tmp(108) := STA & "010" & "100100010"; -- STA #2 @290
tmp(109) := STA & "011" & "100100011"; -- STA #3 @291
tmp(110) := STA & "100" & "100100100"; -- STA #4 @292
tmp(111) := STA & "101" & "100100101"; -- STA #5 @293
tmp(112) := RET & "000" & "000000000"; -- RET

-- SETINIT
tmp(114) := STA & "111" & "111111110"; -- STA #7 @510
tmp(115) := LDI & "111" & "000000001"; -- LDI #7 $1
tmp(116) := STA & "111" & "100000000"; -- STA #7 @256
tmp(117) := LDI & "111" & "000000000"; -- LDI #7 $0
tmp(118) := STA & "111" & "100100000"; -- STA #7 @288
tmp(119) := STA & "111" & "100100001"; -- STA #7 @289
tmp(120) := STA & "111" & "100100010"; -- STA #7 @290
tmp(121) := STA & "111" & "100100011"; -- STA #7 @291
tmp(122) := STA & "111" & "100100100"; -- STA #7 @292
tmp(123) := STA & "111" & "100100101"; -- STA #7 @293
tmp(124) := LDA & "111" & "101100001"; -- LDA #7 @353
tmp(125) := CEQ & "111" & "000000000"; -- CEQ #7 @0
tmp(126) := JEQ & "000" & "001111100"; -- JEQ %SETDEZHORA
tmp(127) := STA & "111" & "111111110"; -- STA #7 @510
tmp(128) := LDA & "101" & "101000000"; -- LDA #5 @320
tmp(129) := GRT & "101" & "000000010"; -- GRT #5 @2
tmp(130) := JGT & "000" & "001111100"; -- JGT %SETDEZHORA
tmp(131) := STA & "101" & "100100101"; -- STA #5 @293
tmp(132) := GRT & "101" & "000000001"; -- GRT #5 @1
tmp(133) := JGT & "000" & "010001111"; -- JGT %SETUNIHORA4
tmp(134) := LDA & "111" & "101100001"; -- LDA #7 @353
tmp(135) := CEQ & "111" & "000000000"; -- CEQ #7 @0
tmp(136) := JEQ & "000" & "010000110"; -- JEQ %SETUNIHORA9
tmp(137) := STA & "111" & "111111110"; -- STA #7 @510
tmp(138) := LDA & "100" & "101000000"; -- LDA #4 @320
tmp(139) := GRT & "100" & "000001001"; -- GRT #4 @9
tmp(140) := JGT & "000" & "010000110"; -- JGT %SETUNIHORA9
tmp(141) := STA & "100" & "100100100"; -- STA #4 @292
tmp(142) := JMP & "000" & "010010111"; -- JMP %SETDEZMIN
tmp(143) := LDA & "111" & "101100001"; -- LDA #7 @353
tmp(144) := CEQ & "111" & "000000000"; -- CEQ #7 @0
tmp(145) := JEQ & "000" & "010001111"; -- JEQ %SETUNIHORA4
tmp(146) := STA & "111" & "111111110"; -- STA #7 @510
tmp(147) := LDA & "100" & "101000000"; -- LDA #4 @320
tmp(148) := GRT & "100" & "000000011"; -- GRT #4 @3
tmp(149) := JGT & "000" & "010001111"; -- JGT %SETUNIHORA4
tmp(150) := STA & "100" & "100100100"; -- STA #4 @292
tmp(151) := LDA & "111" & "101100001"; -- LDA #7 @353
tmp(152) := CEQ & "111" & "000000000"; -- CEQ #7 @0
tmp(153) := JEQ & "000" & "010010111"; -- JEQ %SETDEZMIN
tmp(154) := STA & "111" & "111111110"; -- STA #7 @510
tmp(155) := LDA & "011" & "101000000"; -- LDA #3 @320
tmp(156) := GRT & "011" & "000000101"; -- GRT #3 @5
tmp(157) := JGT & "000" & "010010111"; -- JGT %SETDEZMIN
tmp(158) := STA & "011" & "100100011"; -- STA #3 @291
tmp(159) := LDA & "111" & "101100001"; -- LDA #7 @353
tmp(160) := CEQ & "111" & "000000000"; -- CEQ #7 @0
tmp(161) := JEQ & "000" & "010011111"; -- JEQ %SETUNIMIN
tmp(162) := STA & "111" & "111111110"; -- STA #7 @510
tmp(163) := LDA & "010" & "101000000"; -- LDA #2 @320
tmp(164) := GRT & "010" & "000001001"; -- GRT #2 @9
tmp(165) := JGT & "000" & "010011111"; -- JGT %SETUNIMIN
tmp(166) := STA & "010" & "100100010"; -- STA #2 @290
tmp(167) := LDA & "111" & "101100001"; -- LDA #7 @353
tmp(168) := CEQ & "111" & "000000000"; -- CEQ #7 @0
tmp(169) := JEQ & "000" & "010100111"; -- JEQ %SETDEZSEC
tmp(170) := STA & "111" & "111111110"; -- STA #7 @510
tmp(171) := LDA & "001" & "101000000"; -- LDA #1 @320
tmp(172) := GRT & "001" & "000000101"; -- GRT #1 @5
tmp(173) := JGT & "000" & "010100111"; -- JGT %SETDEZSEC
tmp(174) := STA & "001" & "100100001"; -- STA #1 @289
tmp(175) := LDA & "111" & "101100001"; -- LDA #7 @353
tmp(176) := CEQ & "111" & "000000000"; -- CEQ #7 @0
tmp(177) := JEQ & "000" & "010101111"; -- JEQ %SETUNISEC
tmp(178) := STA & "111" & "111111110"; -- STA #7 @510
tmp(179) := LDA & "000" & "101000000"; -- LDA #0 @320
tmp(180) := GRT & "000" & "000001001"; -- GRT #0 @9
tmp(181) := JGT & "000" & "010101111"; -- JGT %SETUNISEC
tmp(182) := STA & "000" & "100100000"; -- STA #0 @288
tmp(183) := LDI & "111" & "000000000"; -- LDI #7 $0
tmp(184) := STA & "111" & "100000000"; -- STA #7 @256
tmp(185) := RET & "000" & "000000000"; -- RET

		 return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM(to_integer(unsigned(Endereco)));
end architecture;