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

	
  function initMemory
        return blocoMemoria is variable tmp : blocoMemoria := (others => (others => '0'));
  begin
      
      -- Inicializa os endereços:
	
		-- Esse aqui é o LOOP PRINCIPAL do programa do Contador, 
		-- nele ficamos sempre lendo os botões até que um seja pressionado,
		-- assim que um for pressionado, pulamos para a sub rotina desse botão
		tmp(0) := JSR & "111011100"; -- JSR %SETUP
		tmp(1) := LDA & "101100000"; -- LDA @352
		tmp(2) := CEQ & "000000111"; -- CEQ @7
		tmp(3) := JEQ & "000000101"; -- JEQ %KEYZERO
		tmp(4) := JMP & "000001110"; -- JMP %LERKEYONE
		tmp(5) := STA & "111111111"; -- STA @511
		tmp(6) := LDA & "101000010"; -- LDA @322
		tmp(7) := CEQ & "000000111"; -- CEQ @7
		tmp(8) := JEQ & "000001010"; -- JEQ %GOTOREGRESSOR
		tmp(9) := JMP & "000001100"; -- JMP %GOTOCONTADOR
		tmp(10) := JSR & "100111001"; -- JSR %REGRESSOR
		tmp(11) := JMP & "000001110"; -- JMP %LERKEYONE
		tmp(12) := JSR & "011010110"; -- JSR %CONTADOR
		tmp(13) := JSR & "110000111"; -- JSR %CHECALIMITE
		tmp(14) := LDA & "101100001"; -- LDA @353
		tmp(15) := CEQ & "000000111"; -- CEQ @7
		tmp(16) := JEQ & "000010010"; -- JEQ %KEYONE
		tmp(17) := JMP & "000011010"; -- JMP %LERFPGARESET
		tmp(18) := STA & "111111110"; -- STA @510
		tmp(19) := JSR & "001000100"; -- JSR %LIMITE
		tmp(20) := STA & "111111101"; -- STA @509
		tmp(21) := JSR & "000101101"; -- JSR %VERIFICALIMITEMENOR
		tmp(22) := LDA & "000010000"; -- LDA @16
		tmp(23) := CEQ & "000000111"; -- CEQ @7
		tmp(24) := JEQ & "000011010"; -- JEQ %LERFPGARESET
		tmp(25) := JSR & "110111011"; -- JSR %ATUALIZAHEXCONT
		tmp(26) := LDA & "101100100"; -- LDA @356
		tmp(27) := CEQ & "000000110"; -- CEQ @6
		tmp(28) := JEQ & "000011110"; -- JEQ %FPGARESET
		tmp(29) := JMP & "000011111"; -- JMP %LERKEYTWO
		tmp(30) := JSR & "110100011"; -- JSR %RESETACONT
		tmp(31) := LDA & "101100010"; -- LDA @354
		tmp(32) := CEQ & "000000111"; -- CEQ @7
		tmp(33) := JEQ & "000100011"; -- JEQ %KEYTWO
		tmp(34) := JMP & "000000001"; -- JMP %COMECO
		tmp(35) := STA & "111111101"; -- STA @509
		tmp(36) := LDA & "000010000"; -- LDA @16
		tmp(37) := CEQ & "000000111"; -- CEQ @7
		tmp(38) := JEQ & "000011010"; -- JEQ %LERFPGARESET
		tmp(39) := JSR & "010001100"; -- JSR %SETINIT
		tmp(40) := STA & "111111110"; -- STA @510
		tmp(41) := JSR & "111001000"; -- JSR %ATUALIZAHEXREG
		tmp(42) := NOP & "000000000"; -- NOP
		tmp(43) := JMP & "000000001"; -- JMP %COMECO

		-- Sub rotina de verficação do valor atual em relação ao limite
		-- Caso o limite setado seja menor que o valor atual do contador, a placa fica bloqueada para continuar contando
		-- sendo necessário resetá-la
		tmp(45) := LDA & "000000101"; -- LDA @5
		tmp(46) := GRT & "000001111"; -- GRT @15
		tmp(47) := JGT & "001000000"; -- JGT %BLOCKLIMITEMENOR
		tmp(48) := LDA & "000000100"; -- LDA @4
		tmp(49) := GRT & "000001110"; -- GRT @14
		tmp(50) := JGT & "001000000"; -- JGT %BLOCKLIMITEMENOR
		tmp(51) := LDA & "000000011"; -- LDA @3
		tmp(52) := GRT & "000001101"; -- GRT @13
		tmp(53) := JGT & "001000000"; -- JGT %BLOCKLIMITEMENOR
		tmp(54) := LDA & "000000010"; -- LDA @2
		tmp(55) := GRT & "000001100"; -- GRT @12
		tmp(56) := JGT & "001000000"; -- JGT %BLOCKLIMITEMENOR
		tmp(57) := LDA & "000000001"; -- LDA @1
		tmp(58) := GRT & "000001011"; -- GRT @11
		tmp(59) := JGT & "001000000"; -- JGT %BLOCKLIMITEMENOR
		tmp(60) := LDA & "000000000"; -- LDA @0
		tmp(61) := GRT & "000001010"; -- GRT @10
		tmp(62) := JGT & "001000000"; -- JGT %BLOCKLIMITEMENOR
		tmp(63) := JMP & "001000011"; -- JMP %RETORNALIMITEMENOR
		tmp(64) := LDA & "101100100"; -- LDA @356
		tmp(65) := CEQ & "000000111"; -- CEQ @7
		tmp(66) := JEQ & "001000000"; -- JEQ %BLOCKLIMITEMENOR
		tmp(67) := RET & "000000000"; -- RET

		-- Sub rotina para SETAR um LIMITE, usamos somente a KEY(1) e as chaves SW para
		-- isso, vamos de HEX em HEX setando o limite desejado pelo usuário, lembrando que possui um bloqueio
		-- para números maiores que 9, caso isso aconteça, nós ficamos preso em um loop até que o usuário escolha
		-- um número válido
		tmp(68) := LDA & "000010000"; -- LDA @16
		tmp(69) := CEQ & "000000111"; -- CEQ @7
		tmp(70) := JEQ & "010001010"; -- JEQ %BLOCKLIMITE
		tmp(71) := LDA & "000000111"; -- LDA @7
		tmp(72) := STA & "100000010"; -- STA @258
		tmp(73) := LDA & "101100001"; -- LDA @353
		tmp(74) := CEQ & "000000110"; -- CEQ @6
		tmp(75) := JEQ & "001001001"; -- JEQ %UNIDADE
		tmp(76) := STA & "111111110"; -- STA @510
		tmp(77) := LDA & "101000000"; -- LDA @320
		tmp(78) := GRT & "000001001"; -- GRT @9
		tmp(79) := JGT & "001001001"; -- JGT %UNIDADE
		tmp(80) := STA & "000001010"; -- STA @10
		tmp(81) := STA & "100100000"; -- STA @288
		tmp(82) := JMP & "001010011"; -- JMP %DEZENA
		tmp(83) := LDA & "101100001"; -- LDA @353
		tmp(84) := CEQ & "000000110"; -- CEQ @6
		tmp(85) := JEQ & "001010011"; -- JEQ %DEZENA
		tmp(86) := STA & "111111110"; -- STA @510
		tmp(87) := LDA & "101000000"; -- LDA @320
		tmp(88) := GRT & "000001001"; -- GRT @9
		tmp(89) := JGT & "001010011"; -- JGT %DEZENA
		tmp(90) := STA & "000001011"; -- STA @11
		tmp(91) := STA & "100100001"; -- STA @289
		tmp(92) := JMP & "001011101"; -- JMP %CENTENA
		tmp(93) := LDA & "101100001"; -- LDA @353
		tmp(94) := CEQ & "000000110"; -- CEQ @6
		tmp(95) := JEQ & "001011101"; -- JEQ %CENTENA
		tmp(96) := STA & "111111110"; -- STA @510
		tmp(97) := LDA & "101000000"; -- LDA @320
		tmp(98) := GRT & "000001001"; -- GRT @9
		tmp(99) := JGT & "001011101"; -- JGT %CENTENA
		tmp(100) := STA & "000001100"; -- STA @12
		tmp(101) := STA & "100100010"; -- STA @290
		tmp(102) := JMP & "001100111"; -- JMP %UNIMIL
		tmp(103) := LDA & "101100001"; -- LDA @353
		tmp(104) := CEQ & "000000110"; -- CEQ @6
		tmp(105) := JEQ & "001100111"; -- JEQ %UNIMIL
		tmp(106) := STA & "111111110"; -- STA @510
		tmp(107) := LDA & "101000000"; -- LDA @320
		tmp(108) := GRT & "000001001"; -- GRT @9
		tmp(109) := JGT & "001100111"; -- JGT %UNIMIL
		tmp(110) := STA & "000001101"; -- STA @13
		tmp(111) := STA & "100100011"; -- STA @291
		tmp(112) := JMP & "001110001"; -- JMP %DEZMIL
		tmp(113) := LDA & "101100001"; -- LDA @353
		tmp(114) := CEQ & "000000110"; -- CEQ @6
		tmp(115) := JEQ & "001110001"; -- JEQ %DEZMIL
		tmp(116) := STA & "111111110"; -- STA @510
		tmp(117) := LDA & "101000000"; -- LDA @320
		tmp(118) := GRT & "000001001"; -- GRT @9
		tmp(119) := JGT & "001110001"; -- JGT %DEZMIL
		tmp(120) := STA & "000001110"; -- STA @14
		tmp(121) := STA & "100100100"; -- STA @292
		tmp(122) := JMP & "001111011"; -- JMP %CENMIL
		tmp(123) := LDA & "101100001"; -- LDA @353
		tmp(124) := CEQ & "000000110"; -- CEQ @6
		tmp(125) := JEQ & "001111011"; -- JEQ %CENMIL
		tmp(126) := STA & "111111110"; -- STA @510
		tmp(127) := LDA & "101000000"; -- LDA @320
		tmp(128) := GRT & "000001001"; -- GRT @9
		tmp(129) := JGT & "001111011"; -- JGT %CENMIL
		tmp(130) := STA & "000001111"; -- STA @15
		tmp(131) := STA & "100100101"; -- STA @293
		tmp(132) := LDA & "101100001"; -- LDA @353
		tmp(133) := CEQ & "000000110"; -- CEQ @6
		tmp(134) := JEQ & "010000100"; -- JEQ %ENDLIMITE
		tmp(135) := STA & "111111110"; -- STA @510
		tmp(136) := LDA & "000000110"; -- LDA @6
		tmp(137) := STA & "100000010"; -- STA @258
		tmp(138) := NOP & "000000000"; -- NOP
		tmp(139) := RET & "000000000"; -- RET

		-- Sub rotina para SETAR um VALOR INICIAL para a contagem, usamos a KEY(2) e as chaves SW para isso.
		-- Funciona da mesma forma que a sub rotina para SETAR um LIMITE
		tmp(140) := LDA & "000010000"; -- LDA @16
		tmp(141) := CEQ & "000000111"; -- CEQ @7
		tmp(142) := JEQ & "011010010"; -- JEQ %BLOCKREGRESSIVO
		tmp(143) := LDA & "000000111"; -- LDA @7
		tmp(144) := STA & "100000000"; -- STA @256
		tmp(145) := LDA & "101100010"; -- LDA @354
		tmp(146) := CEQ & "000000110"; -- CEQ @6
		tmp(147) := JEQ & "010010001"; -- JEQ %SETUNIDADE
		tmp(148) := STA & "111111101"; -- STA @509
		tmp(149) := LDA & "101000000"; -- LDA @320
		tmp(150) := GRT & "000001001"; -- GRT @9
		tmp(151) := JGT & "010010001"; -- JGT %SETUNIDADE
		tmp(152) := STA & "000010100"; -- STA @20
		tmp(153) := STA & "100100000"; -- STA @288
		tmp(154) := JMP & "010011011"; -- JMP %SETDEZENA
		tmp(155) := LDA & "101100010"; -- LDA @354
		tmp(156) := CEQ & "000000110"; -- CEQ @6
		tmp(157) := JEQ & "010011011"; -- JEQ %SETDEZENA
		tmp(158) := STA & "111111101"; -- STA @509
		tmp(159) := LDA & "101000000"; -- LDA @320
		tmp(160) := GRT & "000001001"; -- GRT @9
		tmp(161) := JGT & "010011011"; -- JGT %SETDEZENA
		tmp(162) := STA & "000010101"; -- STA @21
		tmp(163) := STA & "100100001"; -- STA @289
		tmp(164) := JMP & "010100101"; -- JMP %SETCENTENA
		tmp(165) := LDA & "101100010"; -- LDA @354
		tmp(166) := CEQ & "000000110"; -- CEQ @6
		tmp(167) := JEQ & "010100101"; -- JEQ %SETCENTENA
		tmp(168) := STA & "111111101"; -- STA @509
		tmp(169) := LDA & "101000000"; -- LDA @320
		tmp(170) := GRT & "000001001"; -- GRT @9
		tmp(171) := JGT & "010100101"; -- JGT %SETCENTENA
		tmp(172) := STA & "000010110"; -- STA @22
		tmp(173) := STA & "100100010"; -- STA @290
		tmp(174) := JMP & "010101111"; -- JMP %SETUNIMIL
		tmp(175) := LDA & "101100010"; -- LDA @354
		tmp(176) := CEQ & "000000110"; -- CEQ @6
		tmp(177) := JEQ & "010101111"; -- JEQ %SETUNIMIL
		tmp(178) := STA & "111111101"; -- STA @509
		tmp(179) := LDA & "101000000"; -- LDA @320
		tmp(180) := GRT & "000001001"; -- GRT @9
		tmp(181) := JGT & "010101111"; -- JGT %SETUNIMIL
		tmp(182) := STA & "000010111"; -- STA @23
		tmp(183) := STA & "100100011"; -- STA @291
		tmp(184) := JMP & "010111001"; -- JMP %SETDEZMIL
		tmp(185) := LDA & "101100010"; -- LDA @354
		tmp(186) := CEQ & "000000110"; -- CEQ @6
		tmp(187) := JEQ & "010111001"; -- JEQ %SETDEZMIL
		tmp(188) := STA & "111111101"; -- STA @509
		tmp(189) := LDA & "101000000"; -- LDA @320
		tmp(190) := GRT & "000001001"; -- GRT @9
		tmp(191) := JGT & "010111001"; -- JGT %SETDEZMIL
		tmp(192) := STA & "000011000"; -- STA @24
		tmp(193) := STA & "100100100"; -- STA @292
		tmp(194) := JMP & "011000011"; -- JMP %SETCENMIL
		tmp(195) := LDA & "101100010"; -- LDA @354
		tmp(196) := CEQ & "000000110"; -- CEQ @6
		tmp(197) := JEQ & "011000011"; -- JEQ %SETCENMIL
		tmp(198) := STA & "111111101"; -- STA @509
		tmp(199) := LDA & "101000000"; -- LDA @320
		tmp(200) := GRT & "000001001"; -- GRT @9
		tmp(201) := JGT & "011000011"; -- JGT %SETCENMIL
		tmp(202) := STA & "000011001"; -- STA @25
		tmp(203) := STA & "100100101"; -- STA @293
		tmp(204) := LDA & "101100010"; -- LDA @354
		tmp(205) := CEQ & "000000110"; -- CEQ @6
		tmp(206) := JEQ & "011001100"; -- JEQ %SETENDREGRESSIVO
		tmp(207) := STA & "111111101"; -- STA @509
		tmp(208) := LDA & "000000110"; -- LDA @6
		tmp(209) := STA & "100000010"; -- STA @258
		tmp(210) := LDA & "000000110"; -- LDA @6
		tmp(211) := STA & "100000000"; -- STA @256
		tmp(212) := NOP & "000000000"; -- NOP
		tmp(213) := RET & "000000000"; -- RET

		-- Sub rotina do contador, usamos a KEY(0) para contar, nessa subrotina também é
		-- feito o overflow, CASO NECESSÁRIO, para a dezena, centena, unidade de milhar e etc
		tmp(214) := LDA & "000010000"; -- LDA @16
		tmp(215) := CEQ & "000000111"; -- CEQ @7
		tmp(216) := JEQ & "100101000"; -- JEQ %ESTOROULIMITE
		tmp(217) := LDA & "000000000"; -- LDA @0
		tmp(218) := SOMA & "000000111"; -- SOMA @7
		tmp(219) := CEQ & "000001000"; -- CEQ @8
		tmp(220) := JEQ & "011100000"; -- JEQ %INCDEZ
		tmp(221) := STA & "000000000"; -- STA @0
		tmp(222) := STA & "100100000"; -- STA @288
		tmp(223) := JMP & "100110111"; -- JMP %FIMCONT
		tmp(224) := LDA & "000000110"; -- LDA @6
		tmp(225) := STA & "000000000"; -- STA @0
		tmp(226) := STA & "100100000"; -- STA @288
		tmp(227) := LDA & "000000001"; -- LDA @1
		tmp(228) := SOMA & "000000111"; -- SOMA @7
		tmp(229) := CEQ & "000001000"; -- CEQ @8
		tmp(230) := JEQ & "011101010"; -- JEQ %INCCEN
		tmp(231) := STA & "000000001"; -- STA @1
		tmp(232) := STA & "100100001"; -- STA @289
		tmp(233) := JMP & "100110111"; -- JMP %FIMCONT
		tmp(234) := LDA & "000000110"; -- LDA @6
		tmp(235) := STA & "000000000"; -- STA @0
		tmp(236) := STA & "000000001"; -- STA @1
		tmp(237) := STA & "100100000"; -- STA @288
		tmp(238) := STA & "100100001"; -- STA @289
		tmp(239) := LDA & "000000010"; -- LDA @2
		tmp(240) := SOMA & "000000111"; -- SOMA @7
		tmp(241) := CEQ & "000001000"; -- CEQ @8
		tmp(242) := JEQ & "011110110"; -- JEQ %INCUNIMIL
		tmp(243) := STA & "000000010"; -- STA @2
		tmp(244) := STA & "100100010"; -- STA @290
		tmp(245) := JMP & "100110111"; -- JMP %FIMCONT
		tmp(246) := LDA & "000000110"; -- LDA @6
		tmp(247) := STA & "000000000"; -- STA @0
		tmp(248) := STA & "000000001"; -- STA @1
		tmp(249) := STA & "000000010"; -- STA @2
		tmp(250) := STA & "100100000"; -- STA @288
		tmp(251) := STA & "100100001"; -- STA @289
		tmp(252) := STA & "100100010"; -- STA @290
		tmp(253) := LDA & "000000011"; -- LDA @3
		tmp(254) := SOMA & "000000111"; -- SOMA @7
		tmp(255) := CEQ & "000001000"; -- CEQ @8
		tmp(256) := JEQ & "100000100"; -- JEQ %INCDEZMIL
		tmp(257) := STA & "000000011"; -- STA @3
		tmp(258) := STA & "100100011"; -- STA @291
		tmp(259) := JMP & "100110111"; -- JMP %FIMCONT
		tmp(260) := LDA & "000000110"; -- LDA @6
		tmp(261) := STA & "000000000"; -- STA @0
		tmp(262) := STA & "000000001"; -- STA @1
		tmp(263) := STA & "000000010"; -- STA @2
		tmp(264) := STA & "000000011"; -- STA @3
		tmp(265) := STA & "100100000"; -- STA @288
		tmp(266) := STA & "100100001"; -- STA @289
		tmp(267) := STA & "100100010"; -- STA @290
		tmp(268) := STA & "100100011"; -- STA @291
		tmp(269) := LDA & "000000100"; -- LDA @4
		tmp(270) := SOMA & "000000111"; -- SOMA @7
		tmp(271) := CEQ & "000001000"; -- CEQ @8
		tmp(272) := JEQ & "100010100"; -- JEQ %INCCENMIL
		tmp(273) := STA & "000000100"; -- STA @4
		tmp(274) := STA & "100100100"; -- STA @292
		tmp(275) := JMP & "100110111"; -- JMP %FIMCONT
		tmp(276) := LDA & "000000110"; -- LDA @6
		tmp(277) := STA & "000000000"; -- STA @0
		tmp(278) := STA & "000000001"; -- STA @1
		tmp(279) := STA & "000000010"; -- STA @2
		tmp(280) := STA & "000000011"; -- STA @3
		tmp(281) := STA & "000000100"; -- STA @4
		tmp(282) := STA & "000000101"; -- STA @5
		tmp(283) := STA & "100100000"; -- STA @288
		tmp(284) := STA & "100100001"; -- STA @289
		tmp(285) := STA & "100100010"; -- STA @290
		tmp(286) := STA & "100100011"; -- STA @291
		tmp(287) := STA & "100100100"; -- STA @292
		tmp(288) := STA & "100100101"; -- STA @293
		tmp(289) := LDA & "000000101"; -- LDA @5
		tmp(290) := SOMA & "000000111"; -- SOMA @7
		tmp(291) := CEQ & "000001000"; -- CEQ @8
		tmp(292) := JEQ & "100110111"; -- JEQ %FIMCONT
		tmp(293) := STA & "000000101"; -- STA @5
		tmp(294) := STA & "100100101"; -- STA @293
		tmp(295) := JMP & "100110111"; -- JMP %FIMCONT
		tmp(296) := LDI & "011111111"; -- LDI $255
		tmp(297) := STA & "100000000"; -- STA @256
		tmp(298) := LDA & "000000111"; -- LDA @7
		tmp(299) := STA & "100000010"; -- STA @258
		tmp(300) := LDI & "000001011"; -- LDI $11
		tmp(301) := STA & "100100000"; -- STA @288
		tmp(302) := LDI & "000001100"; -- LDI $12
		tmp(303) := STA & "100100001"; -- STA @289
		tmp(304) := LDI & "000001101"; -- LDI $13
		tmp(305) := STA & "100100010"; -- STA @290
		tmp(306) := LDI & "000001100"; -- LDI $12
		tmp(307) := STA & "100100011"; -- STA @291
		tmp(308) := STA & "100100100"; -- STA @292
		tmp(309) := LDI & "000001110"; -- LDI $14
		tmp(310) := STA & "100100101"; -- STA @293
		tmp(311) := NOP & "000000000"; -- NOP
		tmp(312) := RET & "000000000"; -- RET

		-- Sub rotina da contagem regressiva, usamos a KEY(0) novamente mas essa sub rotina só é chamada
		-- se a SW9 estiver acionada, isso porque ela é nosso 
		tmp(313) := LDA & "000000000"; -- LDA @0
		tmp(314) := CEQ & "000000110"; -- CEQ @6
		tmp(315) := JEQ & "101000000"; -- JEQ %SUBDEZ
		tmp(316) := SUB & "000000111"; -- SUB @7
		tmp(317) := STA & "000000000"; -- STA @0
		tmp(318) := STA & "100100000"; -- STA @288
		tmp(319) := JMP & "110000110"; -- JMP %FIMCONTREG
		tmp(320) := LDA & "000000001"; -- LDA @1
		tmp(321) := CEQ & "000000110"; -- CEQ @6
		tmp(322) := JEQ & "101001010"; -- JEQ %SUBCEN
		tmp(323) := SUB & "000000111"; -- SUB @7
		tmp(324) := STA & "000000001"; -- STA @1
		tmp(325) := STA & "100100001"; -- STA @289
		tmp(326) := LDA & "000001001"; -- LDA @9
		tmp(327) := STA & "000000000"; -- STA @0
		tmp(328) := STA & "100100000"; -- STA @288
		tmp(329) := JMP & "110000110"; -- JMP %FIMCONTREG
		tmp(330) := LDA & "000000010"; -- LDA @2
		tmp(331) := CEQ & "000000110"; -- CEQ @6
		tmp(332) := JEQ & "101010110"; -- JEQ %SUBUNIMIL
		tmp(333) := SUB & "000000111"; -- SUB @7
		tmp(334) := STA & "000000010"; -- STA @2
		tmp(335) := STA & "100100010"; -- STA @290
		tmp(336) := LDA & "000001001"; -- LDA @9
		tmp(337) := STA & "000000001"; -- STA @1
		tmp(338) := STA & "100100001"; -- STA @289
		tmp(339) := STA & "000000000"; -- STA @0
		tmp(340) := STA & "100100000"; -- STA @288
		tmp(341) := JMP & "110000110"; -- JMP %FIMCONTREG
		tmp(342) := LDA & "000000011"; -- LDA @3
		tmp(343) := CEQ & "000000110"; -- CEQ @6
		tmp(344) := JEQ & "101100100"; -- JEQ %SUBDEZMIL
		tmp(345) := SUB & "000000111"; -- SUB @7
		tmp(346) := STA & "000000011"; -- STA @3
		tmp(347) := STA & "100100011"; -- STA @291
		tmp(348) := LDA & "000001001"; -- LDA @9
		tmp(349) := STA & "000000010"; -- STA @2
		tmp(350) := STA & "100100010"; -- STA @290
		tmp(351) := STA & "000000001"; -- STA @1
		tmp(352) := STA & "100100001"; -- STA @289
		tmp(353) := STA & "000000000"; -- STA @0
		tmp(354) := STA & "100100000"; -- STA @288
		tmp(355) := JMP & "110000110"; -- JMP %FIMCONTREG
		tmp(356) := LDA & "000000100"; -- LDA @4
		tmp(357) := CEQ & "000000110"; -- CEQ @6
		tmp(358) := JEQ & "101110100"; -- JEQ %SUBCENMIL
		tmp(359) := SUB & "000000111"; -- SUB @7
		tmp(360) := STA & "000000100"; -- STA @4
		tmp(361) := STA & "100100100"; -- STA @292
		tmp(362) := LDA & "000001001"; -- LDA @9
		tmp(363) := STA & "000000011"; -- STA @3
		tmp(364) := STA & "100100011"; -- STA @291
		tmp(365) := STA & "000000010"; -- STA @2
		tmp(366) := STA & "100100010"; -- STA @290
		tmp(367) := STA & "000000001"; -- STA @1
		tmp(368) := STA & "100100001"; -- STA @289
		tmp(369) := STA & "000000000"; -- STA @0
		tmp(370) := STA & "100100000"; -- STA @288
		tmp(371) := JMP & "110000110"; -- JMP %FIMCONTREG
		tmp(372) := LDA & "000000101"; -- LDA @5
		tmp(373) := CEQ & "000000110"; -- CEQ @6
		tmp(374) := JEQ & "110000110"; -- JEQ %FIMCONTREG
		tmp(375) := SUB & "000000111"; -- SUB @7
		tmp(376) := STA & "000000101"; -- STA @5
		tmp(377) := STA & "100100101"; -- STA @293
		tmp(378) := LDA & "000001001"; -- LDA @9
		tmp(379) := STA & "000000100"; -- STA @4
		tmp(380) := STA & "100100100"; -- STA @292
		tmp(381) := STA & "000000011"; -- STA @3
		tmp(382) := STA & "100100011"; -- STA @291
		tmp(383) := STA & "000000010"; -- STA @2
		tmp(384) := STA & "100100010"; -- STA @290
		tmp(385) := STA & "000000001"; -- STA @1
		tmp(386) := STA & "100100001"; -- STA @289
		tmp(387) := STA & "000000000"; -- STA @0
		tmp(388) := STA & "100100000"; -- STA @288
		tmp(389) := JMP & "110000110"; -- JMP %FIMCONTREG
		tmp(390) := RET & "000000000"; -- RET

		-- Sub rotina para checar se o LIMITE foi atingido
		tmp(391) := LDA & "000000000"; -- LDA @0
		tmp(392) := CEQ & "000001010"; -- CEQ @10
		tmp(393) := JEQ & "110001011"; -- JEQ %CHECADEZENA
		tmp(394) := JMP & "110100010"; -- JMP %FIMCHECALIMITE
		tmp(395) := LDA & "000000001"; -- LDA @1
		tmp(396) := CEQ & "000001011"; -- CEQ @11
		tmp(397) := JEQ & "110001111"; -- JEQ %CHECACENTENA
		tmp(398) := JMP & "110100010"; -- JMP %FIMCHECALIMITE
		tmp(399) := LDA & "000000010"; -- LDA @2
		tmp(400) := CEQ & "000001100"; -- CEQ @12
		tmp(401) := JEQ & "110010011"; -- JEQ %CHECAUNIMIL
		tmp(402) := JMP & "110100010"; -- JMP %FIMCHECALIMITE
		tmp(403) := LDA & "000000011"; -- LDA @3
		tmp(404) := CEQ & "000001101"; -- CEQ @13
		tmp(405) := JEQ & "110010111"; -- JEQ %CHECADEZMIL
		tmp(406) := JMP & "110100010"; -- JMP %FIMCHECALIMITE
		tmp(407) := LDA & "000000100"; -- LDA @4
		tmp(408) := CEQ & "000001110"; -- CEQ @14
		tmp(409) := JEQ & "110011011"; -- JEQ %CHECACENMIL
		tmp(410) := JMP & "110100010"; -- JMP %FIMCHECALIMITE
		tmp(411) := LDA & "000000101"; -- LDA @5
		tmp(412) := CEQ & "000001111"; -- CEQ @15
		tmp(413) := JEQ & "110011111"; -- JEQ %LIMITEIGUAL
		tmp(414) := JMP & "110100010"; -- JMP %FIMCHECALIMITE
		tmp(415) := LDA & "000000111"; -- LDA @7
		tmp(416) := STA & "000010000"; -- STA @16
		tmp(417) := STA & "100000001"; -- STA @257
		tmp(418) := RET  & "000000000"; -- RET 

		-- Sub rotina para resetar a contagem e outros componentes, é chamada pela FPGA_RESET
		tmp(419) := LDA & "000000110"; -- LDA @6
		tmp(420) := STA & "000000000"; -- STA @0
		tmp(421) := STA & "000000001"; -- STA @1
		tmp(422) := STA & "000000010"; -- STA @2
		tmp(423) := STA & "000000011"; -- STA @3
		tmp(424) := STA & "000000100"; -- STA @4
		tmp(425) := STA & "000000101"; -- STA @5
		tmp(426) := STA & "000001010"; -- STA @10
		tmp(427) := STA & "000001011"; -- STA @11
		tmp(428) := STA & "000001100"; -- STA @12
		tmp(429) := STA & "000001101"; -- STA @13
		tmp(430) := STA & "000001110"; -- STA @14
		tmp(431) := STA & "000001111"; -- STA @15
		tmp(432) := STA & "100100000"; -- STA @288
		tmp(433) := STA & "100100001"; -- STA @289
		tmp(434) := STA & "100100010"; -- STA @290
		tmp(435) := STA & "100100011"; -- STA @291
		tmp(436) := STA & "100100100"; -- STA @292
		tmp(437) := STA & "100100101"; -- STA @293
		tmp(438) := STA & "000010000"; -- STA @16
		tmp(439) := STA & "100000000"; -- STA @256
		tmp(440) := STA & "100000001"; -- STA @257
		tmp(441) := STA & "100000010"; -- STA @258
		tmp(442) := RET & "000000000"; -- RET

		-- Sub rotina para ATUALIZAR os HEXs com os valores desejados
		tmp(443) := LDA & "000000000"; -- LDA @0
		tmp(444) := STA & "100100000"; -- STA @288
		tmp(445) := LDA & "000000001"; -- LDA @1
		tmp(446) := STA & "100100001"; -- STA @289
		tmp(447) := LDA & "000000010"; -- LDA @2
		tmp(448) := STA & "100100010"; -- STA @290
		tmp(449) := LDA & "000000011"; -- LDA @3
		tmp(450) := STA & "100100011"; -- STA @291
		tmp(451) := LDA & "000000100"; -- LDA @4
		tmp(452) := STA & "100100100"; -- STA @292
		tmp(453) := LDA & "000000101"; -- LDA @5
		tmp(454) := STA & "100100101"; -- STA @293
		tmp(455) := RET & "000000000"; -- RET

		-- Sub rotina para ATUALIZAR os HEXs com seus valores mas apenas para a contagem regressiva
		tmp(456) := LDA & "000010100"; -- LDA @20
		tmp(457) := STA & "100100000"; -- STA @288
		tmp(458) := STA & "000000000"; -- STA @0
		tmp(459) := LDA & "000010101"; -- LDA @21
		tmp(460) := STA & "100100001"; -- STA @289
		tmp(461) := STA & "000000001"; -- STA @1
		tmp(462) := LDA & "000010110"; -- LDA @22
		tmp(463) := STA & "100100010"; -- STA @290
		tmp(464) := STA & "000000010"; -- STA @2
		tmp(465) := LDA & "000010111"; -- LDA @23
		tmp(466) := STA & "100100011"; -- STA @291
		tmp(467) := STA & "000000011"; -- STA @3
		tmp(468) := LDA & "000011000"; -- LDA @24
		tmp(469) := STA & "100100100"; -- STA @292
		tmp(470) := STA & "000000100"; -- STA @4
		tmp(471) := LDA & "000011001"; -- LDA @25
		tmp(472) := STA & "100100101"; -- STA @293
		tmp(473) := STA & "000000101"; -- STA @5
		tmp(474) := RET & "000000000"; -- RET

		-- Sub rotina de SETUP, usada apenas uma vez no início do código
		tmp(476) := LDI & "000000000"; -- LDI $0
		tmp(477) := STA & "100100000"; -- STA @288
		tmp(478) := STA & "100100001"; -- STA @289
		tmp(479) := STA & "100100010"; -- STA @290
		tmp(480) := STA & "100100011"; -- STA @291
		tmp(481) := STA & "100100100"; -- STA @292
		tmp(482) := STA & "100100101"; -- STA @293
		tmp(483) := STA & "100000000"; -- STA @256
		tmp(484) := STA & "100000001"; -- STA @257
		tmp(485) := STA & "100000010"; -- STA @258
		tmp(486) := STA & "000000000"; -- STA @0
		tmp(487) := STA & "000000001"; -- STA @1
		tmp(488) := STA & "000000010"; -- STA @2
		tmp(489) := STA & "000000011"; -- STA @3
		tmp(490) := STA & "000000100"; -- STA @4
		tmp(491) := STA & "000000101"; -- STA @5
		tmp(492) := STA & "000000110"; -- STA @6
		tmp(493) := STA & "000001010"; -- STA @10
		tmp(494) := STA & "000001011"; -- STA @11
		tmp(495) := STA & "000001100"; -- STA @12
		tmp(496) := STA & "000001101"; -- STA @13
		tmp(497) := STA & "000001110"; -- STA @14
		tmp(498) := STA & "000001111"; -- STA @15
		tmp(499) := STA & "000010000"; -- STA @16
		tmp(500) := LDI & "000000001"; -- LDI $1
		tmp(501) := STA & "000000111"; -- STA @7
		tmp(502) := LDI & "000001010"; -- LDI $10
		tmp(503) := STA & "000001000"; -- STA @8
		tmp(504) := LDI & "000001001"; -- LDI $9
		tmp(505) := STA & "000001001"; -- STA @9
		tmp(506) := RET & "000000000"; -- RET


		 return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM(to_integer(unsigned(Endereco)));
end architecture;