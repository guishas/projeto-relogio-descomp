library ieee;
use ieee.std_logic_1164.all;


entity CPU is
  port(
		CLK					: in std_logic;
		RESET					: in std_logic;
		INSTRUCTION_IN		: in std_logic_vector(15 DOWNTO 0);
		DATA_IN				: in std_logic_vector(7 DOWNTO 0);
		RD						: out std_logic;
		WR						: out std_logic;
		ROM_ADDRESS			: out std_logic_vector(8 DOWNTO 0);
		DATA_OUT				: out std_logic_vector(7 DOWNTO 0);
		DATA_ADDRESS		: out std_logic_vector(8 DOWNTO 0)
  );
end entity;


architecture arquitetura of CPU is

-- Sinais para a CPU:
  signal SIG_FLAGEQ_TO_JMPLOGIC 	: std_logic;
  signal SIG_FLAGGT_TO_JMPLOGIC	: std_logic;
  signal SIG_SAIDA_ULA_FLAG0		: std_logic;
  signal SIG_SAIDA_ULA_GT			: std_logic;
  signal SIG_MUX_TO_ULA 			: std_logic_vector (7 downto 0);
  signal SIG_REGA_TO_ULA 			: std_logic_vector (7 downto 0);
  signal SIG_SAIDA_ULA 				: std_logic_vector (7 downto 0);
  signal SIG_SAIDA_INCREMENTA_PC : std_logic_vector (8 downto 0);
  signal SIG_SAIDA_DECODER 		: std_logic_vector(14 downto 0);
  signal SIG_JMPLOGIC_TO_MUXJMP 	: std_logic_vector(1 DOWNTO 0);
  signal SIG_MUXJMP_TO_PC			: std_logic_vector(8 DOWNTO 0);
  signal SIG_REGRET_TO_MUXJMP 	: std_logic_vector (8 downto 0);
  signal SIG_ROM_ADDR_TO_INC_PC	: std_logic_vector(8 DOWNTO 0);

begin

-- Instanciando os componentes:

-- MUX referente à ULA, para poder escolher entre o valor do imediato e o que vem da memória
MUX_ULA :  entity work.muxGenerico2x1 	generic map (larguraDados => 8)
			port map(
				entradaA_MUX => DATA_IN,
				entradaB_MUX =>  INSTRUCTION_IN(7 DOWNTO 0),
				seletor_MUX => SIG_SAIDA_DECODER(8),
				saida_MUX => SIG_MUX_TO_ULA
			);

-- MUX referente ao program counter, para poder escolher entre PC+1, endereço de JUMPs e endereço de retorno da sub rotina
MUX_PC : entity work.muxGenerico4x1  generic map (larguraDados => 9)
			port map(
				entradaA_MUX =>  SIG_SAIDA_INCREMENTA_PC, 
				entradaB_MUX =>  INSTRUCTION_IN(8 DOWNTO 0),
				entradaC_MUX =>  SIG_REGRET_TO_MUXJMP,
				entradaD_MUX =>  "000000000",
				seletor_MUX =>  SIG_JMPLOGIC_TO_MUXJMP,
				saida_MUX =>  SIG_MUXJMP_TO_PC
			);

-- Acumulador A, para armazenar o dado necessário durante cada clock
--REGA : entity work.registradorGenerico   generic map (larguraDados => 8)
--          port map(DIN => SIG_SAIDA_ULA, DOUT => SIG_REGA_TO_ULA, ENABLE => SIG_SAIDA_DECODER(7), CLK => CLK, RST => RESET);

BAN_REG_A: entity work.bancoRegistradoresArqRegMem   generic map (larguraDados => 8, larguraEndBancoRegs => 3)
			port map ( 
				clk => CLK,
				endereco => INSTRUCTION_IN(11 DOWNTO 9),
				dadoEscrita => SIG_SAIDA_ULA,
				habilitaEscrita => SIG_SAIDA_DECODER(7),
				saida => SIG_REGA_TO_ULA
			);
			 
-- Acumulador do endereço de retorno de sub rotinas, armazena sempre o endereço + 1 da chamada da sub rotina
REG_RET : entity work.registradorGenerico   generic map (larguraDados => 9)
          port map(DIN => SIG_SAIDA_INCREMENTA_PC, DOUT => SIG_REGRET_TO_MUXJMP, ENABLE => SIG_SAIDA_DECODER(14), CLK => CLK, RST => RESET);

-- Flip Flop da flag de igualdade, armazena a saída da ULA quando usamos a instrução CEQ
FLAG_EQ : entity work.flipFlop 
          port map(DIN => SIG_SAIDA_ULA_FLAG0, DOUT => SIG_FLAGEQ_TO_JMPLOGIC, ENABLE => SIG_SAIDA_DECODER(3), CLK => CLK, RST => RESET);

-- Flip Flop da flag de maior que, armazena a saída da ULA quando usamos a instrução GRT
FLAG_GT : entity work.flipFlop 
          port map(DIN => SIG_SAIDA_ULA_GT, DOUT => SIG_FLAGGT_TO_JMPLOGIC, ENABLE => SIG_SAIDA_DECODER(2), CLK => CLK, RST => RESET);

-- Componente que cuida da Lógica de Desvio dos JUMPs, 
-- dentro dele verificamos qual é o tipo do jump que deve ser feito
JMP_LOGIC : entity work.jumpLogic 
          port map(flagEqual => SIG_FLAGEQ_TO_JMPLOGIC, flagGreater => SIG_FLAGGT_TO_JMPLOGIC, jmpIn => SIG_SAIDA_DECODER(13), jeqIn => SIG_SAIDA_DECODER(10), jgtIn => SIG_SAIDA_DECODER(9), retIn => SIG_SAIDA_DECODER(12), jsrIn => SIG_SAIDA_DECODER(11), saida => SIG_JMPLOGIC_TO_MUXJMP);	
		
-- Componente do Program Counter, usado para definir qual a próxima e atual instrução da memória de instruções
PC : entity work.registradorGenerico   generic map (larguraDados => 9)
          port map(DIN => SIG_MUXJMP_TO_PC, DOUT => SIG_ROM_ADDR_TO_INC_PC, ENABLE => '1', CLK => CLK, RST => RESET);

-- Componente para incrementar o program counter, usado para fazer PC+1, 
-- usado sempre que NÃO tem JUMPs ou retornos de sub rotinas
INCREMENTA_PC :  entity work.somaConstante  generic map (larguraDados => 9, constante => 1)
        port map(entrada => SIG_ROM_ADDR_TO_INC_PC, saida => SIG_SAIDA_INCREMENTA_PC);


-- A nossa ULA, responsável por fazer operações como adição, subtração, comparação e etc
ULA : entity work.ULASomaSub  generic map(larguraDados => 8)
          port map(entradaA => SIG_REGA_TO_ULA, entradaB => SIG_MUX_TO_ULA, saida => SIG_SAIDA_ULA, seletor => SIG_SAIDA_DECODER(6 DOWNTO 4), saida_flag_zero => SIG_SAIDA_ULA_FLAG0, saida_gt => SIG_SAIDA_ULA_GT);

-- Decodificador de instruções, usado para traduzir o OpCode em seus determinados pontos de controle			 
DECODER : entity work.decoderInstru port map(opCode => INSTRUCTION_IN(15 DOWNTO 12), saida => SIG_SAIDA_DECODER);
			 

-- Atribuindo os respectivos valores aos sinais de saída da CPU para serem usados no Contador
ROM_ADDRESS <= SIG_ROM_ADDR_TO_INC_PC;
DATA_ADDRESS <= INSTRUCTION_IN(8 DOWNTO 0);
DATA_OUT <= SIG_REGA_TO_ULA;
RD <= SIG_SAIDA_DECODER(1);
WR <= SIG_SAIDA_DECODER(0);

end architecture;