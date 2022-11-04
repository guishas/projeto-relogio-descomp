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
tmp(20) := LDI & "111" & "000000011"; -- LDI #7 $3
tmp(21) := STA & "111" & "000000011"; -- STA #7 @3
tmp(22) := LDI & "111" & "000000000"; -- LDI #7 $0
tmp(23) := STA & "111" & "000001011"; -- STA #7 @11
tmp(24) := LDA & "111" & "111111011"; -- LDA #7 @507
tmp(25) := CEQ & "111" & "000000000"; -- CEQ #7 @0
tmp(26) := JEQ & "000" & "000011000"; -- JEQ %INICIO
tmp(27) := STA & "000" & "111111100"; -- STA #0 @508
tmp(28) := LDA & "111" & "101000001"; -- LDA #7 @321
tmp(29) := CEQ & "111" & "000000000"; -- CEQ #7 @0
tmp(30) := JEQ & "000" & "000101100"; -- JEQ %RELOGIONORMAL
tmp(31) := JSR & "000" & "010000000"; -- JSR %RELOGIOAMPM
tmp(32) := LDA & "111" & "000001011"; -- LDA #7 @11
tmp(33) := CEQ & "111" & "000000000"; -- CEQ #7 @0
tmp(34) := JEQ & "000" & "000101000"; -- JEQ %AM
tmp(35) := LDI & "111" & "000000000"; -- LDI #7 $0
tmp(36) := STA & "111" & "100000010"; -- STA #7 @258
tmp(37) := LDI & "111" & "000000001"; -- LDI #7 $1
tmp(38) := STA & "111" & "100000001"; -- STA #7 @257
tmp(39) := JMP & "000" & "000011000"; -- JMP %INICIO
tmp(40) := STA & "111" & "100000001"; -- STA #7 @257
tmp(41) := LDI & "111" & "000000001"; -- LDI #7 $1
tmp(42) := STA & "111" & "100000010"; -- STA #7 @258
tmp(43) := JMP & "000" & "000011000"; -- JMP %INICIO
tmp(44) := LDI & "111" & "000000000"; -- LDI #7 $0
tmp(45) := STA & "111" & "100000001"; -- STA #7 @257
tmp(46) := STA & "111" & "100000010"; -- STA #7 @258
tmp(47) := JSR & "000" & "000110010"; -- JSR %RELOGIO
tmp(48) := JMP & "000" & "000011000"; -- JMP %INICIO

-- RELOGIO
tmp(50) := SOMA & "000" & "000000001"; -- SOMA #0 @1
tmp(51) := GRT & "000" & "000001001"; -- GRT #0 @9
tmp(52) := JGT & "000" & "000110111"; -- JGT %INCDEZSEC
tmp(53) := STA & "000" & "100100000"; -- STA #0 @288
tmp(54) := JMP & "000" & "001111110"; -- JMP %FIMRELOGIO
tmp(55) := LDI & "000" & "000000000"; -- LDI #0 $0
tmp(56) := STA & "000" & "100100000"; -- STA #0 @288
tmp(57) := SOMA & "001" & "000000001"; -- SOMA #1 @1
tmp(58) := GRT & "001" & "000000101"; -- GRT #1 @5
tmp(59) := JGT & "000" & "000111110"; -- JGT %INCUNIMIN
tmp(60) := STA & "001" & "100100001"; -- STA #1 @289
tmp(61) := JMP & "000" & "001111110"; -- JMP %FIMRELOGIO
tmp(62) := LDI & "000" & "000000000"; -- LDI #0 $0
tmp(63) := LDI & "001" & "000000000"; -- LDI #1 $0
tmp(64) := STA & "000" & "100100000"; -- STA #0 @288
tmp(65) := STA & "001" & "100100001"; -- STA #1 @289
tmp(66) := SOMA & "010" & "000000001"; -- SOMA #2 @1
tmp(67) := GRT & "010" & "000001001"; -- GRT #2 @9
tmp(68) := JGT & "000" & "001000111"; -- JGT %INCDEZMIN
tmp(69) := STA & "010" & "100100010"; -- STA #2 @290
tmp(70) := JMP & "000" & "001111110"; -- JMP %FIMRELOGIO
tmp(71) := LDI & "000" & "000000000"; -- LDI #0 $0
tmp(72) := LDI & "001" & "000000000"; -- LDI #1 $0
tmp(73) := LDI & "010" & "000000000"; -- LDI #2 $0
tmp(74) := STA & "000" & "100100000"; -- STA #0 @288
tmp(75) := STA & "001" & "100100001"; -- STA #1 @289
tmp(76) := STA & "010" & "100100010"; -- STA #2 @290
tmp(77) := SOMA & "011" & "000000001"; -- SOMA #3 @1
tmp(78) := GRT & "011" & "000000101"; -- GRT #3 @5
tmp(79) := JGT & "000" & "001010010"; -- JGT %INCUNIHORA
tmp(80) := STA & "011" & "100100011"; -- STA #3 @291
tmp(81) := JMP & "000" & "001111110"; -- JMP %FIMRELOGIO
tmp(82) := LDI & "000" & "000000000"; -- LDI #0 $0
tmp(83) := LDI & "001" & "000000000"; -- LDI #1 $0
tmp(84) := LDI & "010" & "000000000"; -- LDI #2 $0
tmp(85) := LDI & "011" & "000000000"; -- LDI #3 $0
tmp(86) := STA & "000" & "100100000"; -- STA #0 @288
tmp(87) := STA & "001" & "100100001"; -- STA #1 @289
tmp(88) := STA & "010" & "100100010"; -- STA #2 @290
tmp(89) := STA & "011" & "100100011"; -- STA #3 @291
tmp(90) := SOMA & "100" & "000000001"; -- SOMA #4 @1
tmp(91) := GRT & "101" & "000000001"; -- GRT #5 @1
tmp(92) := JGT & "000" & "001100001"; -- JGT %LIMITEHORA4
tmp(93) := GRT & "100" & "000001001"; -- GRT #4 @9
tmp(94) := JGT & "000" & "001100101"; -- JGT %INCDEZHORA
tmp(95) := STA & "100" & "100100100"; -- STA #4 @292
tmp(96) := JMP & "000" & "001111110"; -- JMP %FIMRELOGIO
tmp(97) := GRT & "100" & "000000011"; -- GRT #4 @3
tmp(98) := JGT & "000" & "001110010"; -- JGT %ZERATUDO
tmp(99) := STA & "100" & "100100100"; -- STA #4 @292
tmp(100) := JMP & "000" & "001111110"; -- JMP %FIMRELOGIO
tmp(101) := LDI & "000" & "000000000"; -- LDI #0 $0
tmp(102) := LDI & "001" & "000000000"; -- LDI #1 $0
tmp(103) := LDI & "010" & "000000000"; -- LDI #2 $0
tmp(104) := LDI & "011" & "000000000"; -- LDI #3 $0
tmp(105) := LDI & "100" & "000000000"; -- LDI #4 $0
tmp(106) := STA & "000" & "100100000"; -- STA #0 @288
tmp(107) := STA & "001" & "100100001"; -- STA #1 @289
tmp(108) := STA & "010" & "100100010"; -- STA #2 @290
tmp(109) := STA & "011" & "100100011"; -- STA #3 @291
tmp(110) := STA & "100" & "100100100"; -- STA #4 @292
tmp(111) := SOMA & "101" & "000000001"; -- SOMA #5 @1
tmp(112) := STA & "101" & "100100101"; -- STA #5 @293
tmp(113) := JMP & "000" & "001111110"; -- JMP %FIMRELOGIO
tmp(114) := LDI & "000" & "000000000"; -- LDI #0 $0
tmp(115) := LDI & "001" & "000000000"; -- LDI #1 $0
tmp(116) := LDI & "010" & "000000000"; -- LDI #2 $0
tmp(117) := LDI & "011" & "000000000"; -- LDI #3 $0
tmp(118) := LDI & "100" & "000000000"; -- LDI #4 $0
tmp(119) := LDI & "101" & "000000000"; -- LDI #5 $0
tmp(120) := STA & "000" & "100100000"; -- STA #0 @288
tmp(121) := STA & "001" & "100100001"; -- STA #1 @289
tmp(122) := STA & "010" & "100100010"; -- STA #2 @290
tmp(123) := STA & "011" & "100100011"; -- STA #3 @291
tmp(124) := STA & "100" & "100100100"; -- STA #4 @292
tmp(125) := STA & "101" & "100100101"; -- STA #5 @293
tmp(126) := RET & "000" & "000000000"; -- RET

-- RELOGIOAMPM
tmp(128) := SOMA & "000" & "000000001"; -- SOMA #0 @1
tmp(129) := GRT & "000" & "000001001"; -- GRT #0 @9
tmp(130) := JGT & "000" & "010000101"; -- JGT %INCDEZSECAMPM
tmp(131) := STA & "000" & "100100000"; -- STA #0 @288
tmp(132) := JMP & "000" & "011010100"; -- JMP %FIMRELOGIOAMPM
tmp(133) := LDI & "000" & "000000000"; -- LDI #0 $0
tmp(134) := STA & "000" & "100100000"; -- STA #0 @288
tmp(135) := SOMA & "001" & "000000001"; -- SOMA #1 @1
tmp(136) := GRT & "001" & "000000101"; -- GRT #1 @5
tmp(137) := JGT & "000" & "010001100"; -- JGT %INCUNIMINAMPM
tmp(138) := STA & "001" & "100100001"; -- STA #1 @289
tmp(139) := JMP & "000" & "011010100"; -- JMP %FIMRELOGIOAMPM
tmp(140) := LDI & "000" & "000000000"; -- LDI #0 $0
tmp(141) := LDI & "001" & "000000000"; -- LDI #1 $0
tmp(142) := STA & "000" & "100100000"; -- STA #0 @288
tmp(143) := STA & "001" & "100100001"; -- STA #1 @289
tmp(144) := SOMA & "010" & "000000001"; -- SOMA #2 @1
tmp(145) := GRT & "010" & "000001001"; -- GRT #2 @9
tmp(146) := JGT & "000" & "010010101"; -- JGT %INCDEZMINAMPM
tmp(147) := STA & "010" & "100100010"; -- STA #2 @290
tmp(148) := JMP & "000" & "011010100"; -- JMP %FIMRELOGIOAMPM
tmp(149) := LDI & "000" & "000000000"; -- LDI #0 $0
tmp(150) := LDI & "001" & "000000000"; -- LDI #1 $0
tmp(151) := LDI & "010" & "000000000"; -- LDI #2 $0
tmp(152) := STA & "000" & "100100000"; -- STA #0 @288
tmp(153) := STA & "001" & "100100001"; -- STA #1 @289
tmp(154) := STA & "010" & "100100010"; -- STA #2 @290
tmp(155) := SOMA & "011" & "000000001"; -- SOMA #3 @1
tmp(156) := GRT & "011" & "000000101"; -- GRT #3 @5
tmp(157) := JGT & "000" & "010100000"; -- JGT %INCUNIHORAAMPM
tmp(158) := STA & "011" & "100100011"; -- STA #3 @291
tmp(159) := JMP & "000" & "011010100"; -- JMP %FIMRELOGIOAMPM
tmp(160) := LDI & "000" & "000000000"; -- LDI #0 $0
tmp(161) := LDI & "001" & "000000000"; -- LDI #1 $0
tmp(162) := LDI & "010" & "000000000"; -- LDI #2 $0
tmp(163) := LDI & "011" & "000000000"; -- LDI #3 $0
tmp(164) := STA & "000" & "100100000"; -- STA #0 @288
tmp(165) := STA & "001" & "100100001"; -- STA #1 @289
tmp(166) := STA & "010" & "100100010"; -- STA #2 @290
tmp(167) := STA & "011" & "100100011"; -- STA #3 @291
tmp(168) := SOMA & "100" & "000000001"; -- SOMA #4 @1
tmp(169) := GRT & "101" & "000000000"; -- GRT #5 @0
tmp(170) := JGT & "000" & "010101111"; -- JGT %LIMITEHORA2
tmp(171) := GRT & "100" & "000001001"; -- GRT #4 @9
tmp(172) := JGT & "000" & "010110011"; -- JGT %INCDEZHORAAMPM
tmp(173) := STA & "100" & "100100100"; -- STA #4 @292
tmp(174) := JMP & "000" & "011010100"; -- JMP %FIMRELOGIOAMPM
tmp(175) := GRT & "100" & "000000001"; -- GRT #4 @1
tmp(176) := JGT & "000" & "011000000"; -- JGT %ZERATUDOAMPM
tmp(177) := STA & "100" & "100100100"; -- STA #4 @292
tmp(178) := JMP & "000" & "011010100"; -- JMP %FIMRELOGIOAMPM
tmp(179) := LDI & "000" & "000000000"; -- LDI #0 $0
tmp(180) := LDI & "001" & "000000000"; -- LDI #1 $0
tmp(181) := LDI & "010" & "000000000"; -- LDI #2 $0
tmp(182) := LDI & "011" & "000000000"; -- LDI #3 $0
tmp(183) := LDI & "100" & "000000000"; -- LDI #4 $0
tmp(184) := STA & "000" & "100100000"; -- STA #0 @288
tmp(185) := STA & "001" & "100100001"; -- STA #1 @289
tmp(186) := STA & "010" & "100100010"; -- STA #2 @290
tmp(187) := STA & "011" & "100100011"; -- STA #3 @291
tmp(188) := STA & "100" & "100100100"; -- STA #4 @292
tmp(189) := SOMA & "101" & "000000001"; -- SOMA #5 @1
tmp(190) := STA & "101" & "100100101"; -- STA #5 @293
tmp(191) := JMP & "000" & "011010100"; -- JMP %FIMRELOGIOAMPM
tmp(192) := LDI & "000" & "000000000"; -- LDI #0 $0
tmp(193) := LDI & "001" & "000000000"; -- LDI #1 $0
tmp(194) := LDI & "010" & "000000000"; -- LDI #2 $0
tmp(195) := LDI & "011" & "000000000"; -- LDI #3 $0
tmp(196) := LDI & "100" & "000000000"; -- LDI #4 $0
tmp(197) := LDI & "101" & "000000000"; -- LDI #5 $0
tmp(198) := STA & "000" & "100100000"; -- STA #0 @288
tmp(199) := STA & "001" & "100100001"; -- STA #1 @289
tmp(200) := STA & "010" & "100100010"; -- STA #2 @290
tmp(201) := STA & "011" & "100100011"; -- STA #3 @291
tmp(202) := STA & "100" & "100100100"; -- STA #4 @292
tmp(203) := STA & "101" & "100100101"; -- STA #5 @293
tmp(204) := LDA & "111" & "000001011"; -- LDA #7 @11
tmp(205) := CEQ & "111" & "000000000"; -- CEQ #7 @0
tmp(206) := JEQ & "000" & "011010010"; -- JEQ %MUDAPARA1
tmp(207) := LDI & "111" & "000000000"; -- LDI #7 $0
tmp(208) := STA & "111" & "000001011"; -- STA #7 @11
tmp(209) := JMP & "000" & "011010100"; -- JMP %FIMRELOGIOAMPM
tmp(210) := LDI & "111" & "000000001"; -- LDI #7 $1
tmp(211) := STA & "111" & "000001011"; -- STA #7 @11
tmp(212) := RET & "000" & "000000000"; -- RET







		 return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM(to_integer(unsigned(Endereco)));
end architecture;