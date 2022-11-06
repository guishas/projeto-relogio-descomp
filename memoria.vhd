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
tmp(28) := JSR & "000" & "010100101"; -- JSR %SETINIT
tmp(29) := LDA & "111" & "111111011"; -- LDA #7 @507
tmp(30) := CEQ & "111" & "000000000"; -- CEQ #7 @0
tmp(31) := JEQ & "000" & "000011000"; -- JEQ %INICIO
tmp(32) := STA & "000" & "111111100"; -- STA #0 @508
tmp(33) := LDA & "111" & "101000001"; -- LDA #7 @321
tmp(34) := CEQ & "111" & "000000001"; -- CEQ #7 @1
tmp(35) := JEQ & "000" & "000100110"; -- JEQ %DECREMENTA
tmp(36) := JSR & "000" & "000101001"; -- JSR %RELOGIO
tmp(37) := JMP & "000" & "000011000"; -- JMP %INICIO
tmp(38) := JSR & "000" & "001110111"; -- JSR %REGRESSIVA
tmp(39) := JMP & "000" & "000011000"; -- JMP %INICIO

-- RELOGIO
tmp(41) := ADDI & "000" & "000000001"; -- ADDI #0 $1
tmp(42) := GRT & "000" & "000001001"; -- GRT #0 @9
tmp(43) := JGT & "000" & "000101110"; -- JGT %INCDEZSEC
tmp(44) := STA & "000" & "100100000"; -- STA #0 @288
tmp(45) := JMP & "000" & "001110101"; -- JMP %FIMRELOGIO
tmp(46) := LDI & "000" & "000000000"; -- LDI #0 $0
tmp(47) := STA & "000" & "100100000"; -- STA #0 @288
tmp(48) := ADDI & "001" & "000000001"; -- ADDI #1 $1
tmp(49) := GRT & "001" & "000000101"; -- GRT #1 @5
tmp(50) := JGT & "000" & "000110101"; -- JGT %INCUNIMIN
tmp(51) := STA & "001" & "100100001"; -- STA #1 @289
tmp(52) := JMP & "000" & "001110101"; -- JMP %FIMRELOGIO
tmp(53) := LDI & "000" & "000000000"; -- LDI #0 $0
tmp(54) := LDI & "001" & "000000000"; -- LDI #1 $0
tmp(55) := STA & "000" & "100100000"; -- STA #0 @288
tmp(56) := STA & "001" & "100100001"; -- STA #1 @289
tmp(57) := ADDI & "010" & "000000001"; -- ADDI #2 $1
tmp(58) := GRT & "010" & "000001001"; -- GRT #2 @9
tmp(59) := JGT & "000" & "000111110"; -- JGT %INCDEZMIN
tmp(60) := STA & "010" & "100100010"; -- STA #2 @290
tmp(61) := JMP & "000" & "001110101"; -- JMP %FIMRELOGIO
tmp(62) := LDI & "000" & "000000000"; -- LDI #0 $0
tmp(63) := LDI & "001" & "000000000"; -- LDI #1 $0
tmp(64) := LDI & "010" & "000000000"; -- LDI #2 $0
tmp(65) := STA & "000" & "100100000"; -- STA #0 @288
tmp(66) := STA & "001" & "100100001"; -- STA #1 @289
tmp(67) := STA & "010" & "100100010"; -- STA #2 @290
tmp(68) := ADDI & "011" & "000000001"; -- ADDI #3 $1
tmp(69) := GRT & "011" & "000000101"; -- GRT #3 @5
tmp(70) := JGT & "000" & "001001001"; -- JGT %INCUNIHORA
tmp(71) := STA & "011" & "100100011"; -- STA #3 @291
tmp(72) := JMP & "000" & "001110101"; -- JMP %FIMRELOGIO
tmp(73) := LDI & "000" & "000000000"; -- LDI #0 $0
tmp(74) := LDI & "001" & "000000000"; -- LDI #1 $0
tmp(75) := LDI & "010" & "000000000"; -- LDI #2 $0
tmp(76) := LDI & "011" & "000000000"; -- LDI #3 $0
tmp(77) := STA & "000" & "100100000"; -- STA #0 @288
tmp(78) := STA & "001" & "100100001"; -- STA #1 @289
tmp(79) := STA & "010" & "100100010"; -- STA #2 @290
tmp(80) := STA & "011" & "100100011"; -- STA #3 @291
tmp(81) := ADDI & "100" & "000000001"; -- ADDI #4 $1
tmp(82) := GRT & "101" & "000000001"; -- GRT #5 @1
tmp(83) := JGT & "000" & "001011000"; -- JGT %LIMITEHORA4
tmp(84) := GRT & "100" & "000001001"; -- GRT #4 @9
tmp(85) := JGT & "000" & "001011100"; -- JGT %INCDEZHORA
tmp(86) := STA & "100" & "100100100"; -- STA #4 @292
tmp(87) := JMP & "000" & "001110101"; -- JMP %FIMRELOGIO
tmp(88) := GRT & "100" & "000000011"; -- GRT #4 @3
tmp(89) := JGT & "000" & "001101001"; -- JGT %ZERATUDO
tmp(90) := STA & "100" & "100100100"; -- STA #4 @292
tmp(91) := JMP & "000" & "001110101"; -- JMP %FIMRELOGIO
tmp(92) := LDI & "000" & "000000000"; -- LDI #0 $0
tmp(93) := LDI & "001" & "000000000"; -- LDI #1 $0
tmp(94) := LDI & "010" & "000000000"; -- LDI #2 $0
tmp(95) := LDI & "011" & "000000000"; -- LDI #3 $0
tmp(96) := LDI & "100" & "000000000"; -- LDI #4 $0
tmp(97) := STA & "000" & "100100000"; -- STA #0 @288
tmp(98) := STA & "001" & "100100001"; -- STA #1 @289
tmp(99) := STA & "010" & "100100010"; -- STA #2 @290
tmp(100) := STA & "011" & "100100011"; -- STA #3 @291
tmp(101) := STA & "100" & "100100100"; -- STA #4 @292
tmp(102) := ADDI & "101" & "000000001"; -- ADDI #5 $1
tmp(103) := STA & "101" & "100100101"; -- STA #5 @293
tmp(104) := JMP & "000" & "001110101"; -- JMP %FIMRELOGIO
tmp(105) := LDI & "000" & "000000000"; -- LDI #0 $0
tmp(106) := LDI & "001" & "000000000"; -- LDI #1 $0
tmp(107) := LDI & "010" & "000000000"; -- LDI #2 $0
tmp(108) := LDI & "011" & "000000000"; -- LDI #3 $0
tmp(109) := LDI & "100" & "000000000"; -- LDI #4 $0
tmp(110) := LDI & "101" & "000000000"; -- LDI #5 $0
tmp(111) := STA & "000" & "100100000"; -- STA #0 @288
tmp(112) := STA & "001" & "100100001"; -- STA #1 @289
tmp(113) := STA & "010" & "100100010"; -- STA #2 @290
tmp(114) := STA & "011" & "100100011"; -- STA #3 @291
tmp(115) := STA & "100" & "100100100"; -- STA #4 @292
tmp(116) := STA & "101" & "100100101"; -- STA #5 @293
tmp(117) := RET & "000" & "000000000"; -- RET

-- REGRESSIVA
tmp(119) := CEQ & "000" & "000000000"; -- CEQ #0 @0
tmp(120) := JEQ & "000" & "001111100"; -- JEQ %DECUNISEC
tmp(121) := SUBI & "000" & "000000001"; -- SUBI #0 $1
tmp(122) := STA & "000" & "100100000"; -- STA #0 @288
tmp(123) := JMP & "000" & "010100011"; -- JMP %FIMREGRESSIVA
tmp(124) := LDI & "000" & "000001001"; -- LDI #0 $9
tmp(125) := STA & "000" & "100100000"; -- STA #0 @288
tmp(126) := CEQ & "001" & "000000000"; -- CEQ #1 @0
tmp(127) := JEQ & "000" & "010000011"; -- JEQ %DECDEZSEC
tmp(128) := SUBI & "001" & "000000001"; -- SUBI #1 $1
tmp(129) := STA & "001" & "100100001"; -- STA #1 @289
tmp(130) := JMP & "000" & "010100011"; -- JMP %FIMREGRESSIVA
tmp(131) := LDI & "001" & "000000101"; -- LDI #1 $5
tmp(132) := STA & "001" & "100100001"; -- STA #1 @289
tmp(133) := CEQ & "010" & "000000000"; -- CEQ #2 @0
tmp(134) := JEQ & "000" & "010001010"; -- JEQ %DECUNIMIN
tmp(135) := SUBI & "010" & "000000001"; -- SUBI #2 $1
tmp(136) := STA & "010" & "100100010"; -- STA #2 @290
tmp(137) := JMP & "000" & "010100011"; -- JMP %FIMREGRESSIVA
tmp(138) := LDI & "010" & "000001001"; -- LDI #2 $9
tmp(139) := STA & "010" & "100100010"; -- STA #2 @290
tmp(140) := CEQ & "011" & "000000000"; -- CEQ #3 @0
tmp(141) := JEQ & "000" & "010010001"; -- JEQ %DECDEZMIN
tmp(142) := SUBI & "011" & "000000001"; -- SUBI #3 $1
tmp(143) := STA & "011" & "100100011"; -- STA #3 @291
tmp(144) := JMP & "000" & "010100011"; -- JMP %FIMREGRESSIVA
tmp(145) := LDI & "011" & "000000101"; -- LDI #3 $5
tmp(146) := STA & "011" & "100100011"; -- STA #3 @291
tmp(147) := CEQ & "100" & "000000000"; -- CEQ #4 @0
tmp(148) := JEQ & "000" & "010011000"; -- JEQ %DECUNIHORA
tmp(149) := SUBI & "100" & "000000001"; -- SUBI #4 $1
tmp(150) := STA & "100" & "100100100"; -- STA #4 @292
tmp(151) := JMP & "000" & "010100011"; -- JMP %FIMREGRESSIVA
tmp(152) := CEQ & "101" & "000000000"; -- CEQ #5 @0
tmp(153) := JEQ & "000" & "010011111"; -- JEQ %RESETA
tmp(154) := LDI & "100" & "000001001"; -- LDI #4 $9
tmp(155) := STA & "100" & "100100100"; -- STA #4 @292
tmp(156) := SUBI & "101" & "000000001"; -- SUBI #5 $1
tmp(157) := STA & "101" & "100100101"; -- STA #5 @293
tmp(158) := JMP & "000" & "010100011"; -- JMP %FIMREGRESSIVA
tmp(159) := LDI & "100" & "000000011"; -- LDI #4 $3
tmp(160) := LDI & "101" & "000000010"; -- LDI #5 $2
tmp(161) := STA & "100" & "100100100"; -- STA #4 @292
tmp(162) := STA & "101" & "100100101"; -- STA #5 @293
tmp(163) := RET & "000" & "000000000"; -- RET

-- SETINIT
tmp(165) := STA & "111" & "111111110"; -- STA #7 @510
tmp(166) := LDI & "111" & "000000001"; -- LDI #7 $1
tmp(167) := STA & "111" & "100000000"; -- STA #7 @256
tmp(168) := LDI & "111" & "000000000"; -- LDI #7 $0
tmp(169) := STA & "111" & "100100000"; -- STA #7 @288
tmp(170) := STA & "111" & "100100001"; -- STA #7 @289
tmp(171) := STA & "111" & "100100010"; -- STA #7 @290
tmp(172) := STA & "111" & "100100011"; -- STA #7 @291
tmp(173) := STA & "111" & "100100100"; -- STA #7 @292
tmp(174) := STA & "111" & "100100101"; -- STA #7 @293
tmp(175) := LDA & "111" & "101100001"; -- LDA #7 @353
tmp(176) := CEQ & "111" & "000000000"; -- CEQ #7 @0
tmp(177) := JEQ & "000" & "010101111"; -- JEQ %SETDEZHORA
tmp(178) := STA & "111" & "111111110"; -- STA #7 @510
tmp(179) := LDA & "101" & "101000000"; -- LDA #5 @320
tmp(180) := GRT & "101" & "000000010"; -- GRT #5 @2
tmp(181) := JGT & "000" & "010101111"; -- JGT %SETDEZHORA
tmp(182) := STA & "101" & "100100101"; -- STA #5 @293
tmp(183) := GRT & "101" & "000000001"; -- GRT #5 @1
tmp(184) := JGT & "000" & "011000010"; -- JGT %SETUNIHORA4
tmp(185) := LDA & "111" & "101100001"; -- LDA #7 @353
tmp(186) := CEQ & "111" & "000000000"; -- CEQ #7 @0
tmp(187) := JEQ & "000" & "010111001"; -- JEQ %SETUNIHORA9
tmp(188) := STA & "111" & "111111110"; -- STA #7 @510
tmp(189) := LDA & "100" & "101000000"; -- LDA #4 @320
tmp(190) := GRT & "100" & "000001001"; -- GRT #4 @9
tmp(191) := JGT & "000" & "010111001"; -- JGT %SETUNIHORA9
tmp(192) := STA & "100" & "100100100"; -- STA #4 @292
tmp(193) := JMP & "000" & "011001010"; -- JMP %SETDEZMIN
tmp(194) := LDA & "111" & "101100001"; -- LDA #7 @353
tmp(195) := CEQ & "111" & "000000000"; -- CEQ #7 @0
tmp(196) := JEQ & "000" & "011000010"; -- JEQ %SETUNIHORA4
tmp(197) := STA & "111" & "111111110"; -- STA #7 @510
tmp(198) := LDA & "100" & "101000000"; -- LDA #4 @320
tmp(199) := GRT & "100" & "000000011"; -- GRT #4 @3
tmp(200) := JGT & "000" & "011000010"; -- JGT %SETUNIHORA4
tmp(201) := STA & "100" & "100100100"; -- STA #4 @292
tmp(202) := LDA & "111" & "101100001"; -- LDA #7 @353
tmp(203) := CEQ & "111" & "000000000"; -- CEQ #7 @0
tmp(204) := JEQ & "000" & "011001010"; -- JEQ %SETDEZMIN
tmp(205) := STA & "111" & "111111110"; -- STA #7 @510
tmp(206) := LDA & "011" & "101000000"; -- LDA #3 @320
tmp(207) := GRT & "011" & "000000101"; -- GRT #3 @5
tmp(208) := JGT & "000" & "011001010"; -- JGT %SETDEZMIN
tmp(209) := STA & "011" & "100100011"; -- STA #3 @291
tmp(210) := LDA & "111" & "101100001"; -- LDA #7 @353
tmp(211) := CEQ & "111" & "000000000"; -- CEQ #7 @0
tmp(212) := JEQ & "000" & "011010010"; -- JEQ %SETUNIMIN
tmp(213) := STA & "111" & "111111110"; -- STA #7 @510
tmp(214) := LDA & "010" & "101000000"; -- LDA #2 @320
tmp(215) := GRT & "010" & "000001001"; -- GRT #2 @9
tmp(216) := JGT & "000" & "011010010"; -- JGT %SETUNIMIN
tmp(217) := STA & "010" & "100100010"; -- STA #2 @290
tmp(218) := LDA & "111" & "101100001"; -- LDA #7 @353
tmp(219) := CEQ & "111" & "000000000"; -- CEQ #7 @0
tmp(220) := JEQ & "000" & "011011010"; -- JEQ %SETDEZSEC
tmp(221) := STA & "111" & "111111110"; -- STA #7 @510
tmp(222) := LDA & "001" & "101000000"; -- LDA #1 @320
tmp(223) := GRT & "001" & "000000101"; -- GRT #1 @5
tmp(224) := JGT & "000" & "011011010"; -- JGT %SETDEZSEC
tmp(225) := STA & "001" & "100100001"; -- STA #1 @289
tmp(226) := LDA & "111" & "101100001"; -- LDA #7 @353
tmp(227) := CEQ & "111" & "000000000"; -- CEQ #7 @0
tmp(228) := JEQ & "000" & "011100010"; -- JEQ %SETUNISEC
tmp(229) := STA & "111" & "111111110"; -- STA #7 @510
tmp(230) := LDA & "000" & "101000000"; -- LDA #0 @320
tmp(231) := GRT & "000" & "000001001"; -- GRT #0 @9
tmp(232) := JGT & "000" & "011100010"; -- JGT %SETUNISEC
tmp(233) := STA & "000" & "100100000"; -- STA #0 @288
tmp(234) := LDI & "111" & "000000000"; -- LDI #7 $0
tmp(235) := STA & "111" & "100000000"; -- STA #7 @256
tmp(236) := RET & "000" & "000000000"; -- RET


		 return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM(to_integer(unsigned(Endereco)));
end architecture;