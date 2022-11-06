library ieee;
use ieee.std_logic_1164.all;


entity Relogio is

  generic(
		simulacao : boolean := FALSE -- para gravar na placa, altere de TRUE para FALSE
  );

  port(
		CLOCK_50			: in std_logic;
		KEY				: in std_logic_vector(3 DOWNTO 0);
		FPGA_RESET_N	: in std_logic;
		SW					: in std_logic_vector(9 DOWNTO 0);
		LEDR				: out std_logic_vector(9 DOWNTO 0);
		HEX0				: out std_logic_vector(6 DOWNTO 0);
		HEX1				: out std_logic_vector(6 DOWNTO 0);
		HEX2				: out std_logic_vector(6 DOWNTO 0);
		HEX3				: out std_logic_vector(6 DOWNTO 0);
		HEX4				: out std_logic_vector(6 DOWNTO 0);
		HEX5				: out std_logic_vector(6 DOWNTO 0);
		PC_OUT 			: out std_logic_vector(8 DOWNTO 0);
		SAIDA_ULA		: out std_logic_vector(7 DOWNTO 0)
  );
  
end entity;


architecture arquitetura of Relogio is

-- Sinais para o Contador:
	signal SIG_CLK							: std_logic;
	signal SIG_HAB_CLK_1_SEC			: std_logic;
	signal SIG_RD							: std_logic;
	signal SIG_WR							: std_logic;
	signal SIG_HAB_LED_0_TO_7			: std_logic;
	signal SIG_HAB_LED8					: std_logic;
	signal SIG_HAB_LED9					: std_logic;
	signal SIG_FF_LED_TO_LED8			: std_logic;
	signal SIG_FF_LED_TO_LED9			: std_logic;
	signal SIG_HAB_HEX0					: std_logic;
	signal SIG_HAB_HEX1					: std_logic;
	signal SIG_HAB_HEX2					: std_logic;
	signal SIG_HAB_HEX3					: std_logic;
	signal SIG_HAB_HEX4					: std_logic;
	signal SIG_HAB_HEX5					: std_logic;
	signal SIG_HAB_KEY0					: std_logic;
	signal SIG_HAB_KEY1					: std_logic;
   signal SIG_HAB_KEY2					: std_logic;
	signal SIG_HAB_KEY3					: std_logic;
	signal SIG_HAB_FPGA_RESET			: std_logic;
	signal SIG_HAB_SW9					: std_logic;
	signal SIG_HAB_SW8					: std_logic;
	signal SIG_HAB_SW0_TO_7				: std_logic;
	signal SIG_DETECTOR_KEY0_OUT		: std_logic;
	signal SIG_DETECTOR_KEY1_OUT  	: std_logic;
	signal SIG_DETECTOR_KEY2_OUT		: std_logic;
	signal SIG_DETECT_TSTATE_KEY0		: std_logic;
	signal SIG_DETECT_TSTATE_KEY1		: std_logic;
	signal SIG_DETECT_TSTATE_KEY2		: std_logic;
	signal SIG_LIMPA_LEITURA_KEY0		: std_logic;
	signal SIG_LIMPA_LEITURA_KEY1		: std_logic;
	signal SIG_LIMPA_LEITURA_KEY2		: std_logic;
	signal SIG_LIMPA_CLK_1_SEC			: std_logic;
	signal SIG_SAIDA_DIVISOR			: std_logic;
	signal SIG_CLK_1_SEC					: std_logic_vector(7 DOWNTO 0);
	signal SIG_CLK_1_SEC_NORMAL		: std_logic_vector(7 DOWNTO 0);
	signal SIG_CLK_1_SEC_RAPIDO		: std_logic_vector(7 DOWNTO 0);
	signal SIG_CPU_TO_ROM 				: std_logic_vector(8 DOWNTO 0);
	signal SIG_ROM_TO_INSTRUCTION 	: std_logic_vector(15 DOWNTO 0);
	signal SIG_CPU_DATA_ADDR_OUT 		: std_logic_vector(8 DOWNTO 0);
	signal SIG_RAM_TO_CPU_DATA			: std_logic_vector(7 DOWNTO 0);
	signal SIG_CPU_TO_RAM_DATA 		: std_logic_vector(7 DOWNTO 0);
	signal SIG_DECODER_BLOCO_OUT		: std_logic_vector(7 DOWNTO 0);
	signal SIG_DECODER_LED_OUT			: std_logic_vector(7 DOWNTO 0);
	signal SIG_REG_LED_TO_LEDR			: std_logic_vector(7 DOWNTO 0);
	signal SIG_KEY_SW_OUT				: std_logic_vector(7	DOWNTO 0);

begin

-- Na simulação, usamos o KEY(0) para testar, mudamos para outra KEY quando precisamos testar a KEY(0)
gravar:  if simulacao generate

	SIG_CLK <= KEY(0);


else generate

-- Quando estamos na placa, devemos usar o CLOCK_50

	SIG_CLK <= CLOCK_50;
	
end generate;

-- Instanciando os componentes:

interfaceBaseTempo : entity work.divisorGenerico_e_Interface generic map (divisor_normal => 25000000, divisor_rapido => 35000)
			port map (
			  clk => CLOCK_50,
			  habilitaLeitura => SIG_HAB_CLK_1_SEC,
			  limpaLeitura => SIG_LIMPA_CLK_1_SEC,
			  sel_mux => SW(9),
			  leituraUmSegundo => SIG_CLK_1_SEC
			);
			

-- A nossa CPU, dentro dela tem comentários explicando seus componentes, aqui ela tem seu propósito definido
CPU : entity work.CPU 
			port map(
				CLK => SIG_CLK,
				RESET => '0',
				INSTRUCTION_IN => SIG_ROM_TO_INSTRUCTION,
				DATA_IN => SIG_RAM_TO_CPU_DATA,
				RD => SIG_RD,
				WR => SIG_WR,
				ROM_ADDRESS => SIG_CPU_TO_ROM,
				DATA_OUT => SIG_CPU_TO_RAM_DATA,
				DATA_ADDRESS => SIG_CPU_DATA_ADDR_OUT
			);

-- A memória RAM, responsável por de fato armazenar dados importantes para o funcionamente do Contador
RAM : entity work.memoriaRAM generic map(dataWidth => 8, addrWidth => 6)
			port map(
				addr => SIG_CPU_DATA_ADDR_OUT(5 DOWNTO 0),
				we => SIG_WR,
				re => SIG_RD,
				habilita => SIG_DECODER_BLOCO_OUT(0),
				clk => SIG_CLK,
				dado_in => SIG_CPU_TO_RAM_DATA,
				dado_out => SIG_RAM_TO_CPU_DATA
			);
	
-- A memória ROM, reponsável pelo programa a ser rodado (software), chamada também de memória de instruções	
ROM : entity work.memoria generic map(dataWidth => 16, addrWidth => 9)
			port map(
				Endereco => SIG_CPU_TO_ROM,
				Dado => SIG_ROM_TO_INSTRUCTION
			);
			
DECODER_BLOCO : entity work.decoder3x8 
			port map(
				entrada => SIG_CPU_DATA_ADDR_OUT(8 DOWNTO 6),
				saida => SIG_DECODER_BLOCO_OUT
			);

-- Decodificador dos LEDs de 0 até 7		
DECODER_LED : entity work.decoder3x8
			port map(
				entrada => SIG_CPU_DATA_ADDR_OUT(2 DOWNTO 0),
				saida => SIG_DECODER_LED_OUT
			);
	
-- Acumulador dos LEDs de 0 até 7, responsável por guardar a informação que vai aos LEDs	
REG_LED : entity work.registradorGenerico generic map (larguraDados => 8)
			port map(
				DIN => SIG_CPU_TO_RAM_DATA,
				DOUT => SIG_REG_LED_TO_LEDR,
				ENABLE => SIG_HAB_LED_0_TO_7,
				CLK => SIG_CLK,
				RST => '0'
			);

-- Flip Flop do LEDR8, guarda a informação que vai ser de fato enviada para ele	
FF_LED8 : entity work.flipFlop
			port map(
				DIN => SIG_CPU_TO_RAM_DATA(0),
				DOUT => SIG_FF_LED_TO_LED8,
				ENABLE => SIG_HAB_LED8,
				CLK => SIG_CLK,
				RST => '0'
			);

-- Flip Flop do LEDR9, guarda a informação que vai ser de fato enviada para ele			
FF_LED9 : entity work.flipFlop
			port map(
				DIN => SIG_CPU_TO_RAM_DATA(0),
				DOUT => SIG_FF_LED_TO_LED9,
				ENABLE => SIG_HAB_LED9,
				CLK => SIG_CLK,
				RST => '0'
			);
			
-- Componente que cuida do HEX0, tem um acumulador e um decodificador para que o HEX receba o valor que desejamos
HEXREG0 : entity work.HexReg
			port map(
				CLK => SIG_CLK,
				DATA_IN => SIG_CPU_TO_RAM_DATA(3 DOWNTO 0),
				HABILITA => SIG_HAB_HEX0,
				HEX => HEX0
			);

-- Componente que cuida do HEX1, tem um acumulador e um decodificador para que o HEX receba o valor que desejamos
HEXREG1 : entity work.HexReg
			port map(
				CLK => SIG_CLK,
				DATA_IN => SIG_CPU_TO_RAM_DATA(3 DOWNTO 0),
				HABILITA => SIG_HAB_HEX1,
				HEX => HEX1
			);

-- Componente que cuida do HEX2, tem um acumulador e um decodificador para que o HEX receba o valor que desejamos
HEXREG2 : entity work.HexReg
			port map(
				CLK => SIG_CLK,
				DATA_IN => SIG_CPU_TO_RAM_DATA(3 DOWNTO 0),
				HABILITA => SIG_HAB_HEX2,
				HEX => HEX2
			);
			
-- Componente que cuida do HEX3, tem um acumulador e um decodificador para que o HEX receba o valor que desejamos
HEXREG3 : entity work.HexReg
			port map(
				CLK => SIG_CLK,
				DATA_IN => SIG_CPU_TO_RAM_DATA(3 DOWNTO 0),
				HABILITA => SIG_HAB_HEX3,
				HEX => HEX3
			);
		
-- Componente que cuida do HEX4, tem um acumulador e um decodificador para que o HEX receba o valor que desejamos
HEXREG4 : entity work.HexReg
			port map(
				CLK => SIG_CLK,
				DATA_IN => SIG_CPU_TO_RAM_DATA(3 DOWNTO 0),
				HABILITA => SIG_HAB_HEX4,
				HEX => HEX4
			);
	
-- Componente que cuida do HEX5, tem um acumulador e um decodificador para que o HEX receba o valor que desejamos
HEXREG5 : entity work.HexReg
			port map(
				CLK => SIG_CLK,
				DATA_IN => SIG_CPU_TO_RAM_DATA(3 DOWNTO 0),
				HABILITA => SIG_HAB_HEX5,
				HEX => HEX5
			);

-- Detector de borda do KEY(0), utilizado para evitar ruídos e etc
DETECTOR_KEY0 : work.edgeDetector(bordaSubida)
			port map (
				CLK => CLOCK_50, 
				ENTRADA => not KEY(0), 
				SAIDA => SIG_DETECTOR_KEY0_OUT
			);
			
-- Flip Flop do detector de borda do KEY(0), usado para "simular" um clique do KEY(0)
FLIPFLOP_KEY0: work.flipFlop
			port map (
				DIN => '1', 
				DOUT => SIG_DETECT_TSTATE_KEY0,
				ENABLE => '1',
				CLK => SIG_DETECTOR_KEY0_OUT,
				RST => SIG_LIMPA_LEITURA_KEY0
			);	
		
-- Tri-state do KEY(0)
TRI_STATE_KEY0 : entity work.buffer_3_state
			port map(
				ENTRADA => SIG_DETECT_TSTATE_KEY0,
				HABILITA => SIG_HAB_KEY0,
				SAIDA => SIG_KEY_SW_OUT
			);

-- Detector de borda do KEY(1), utilizado para evitar ruídos e etc
DETECTOR_KEY1 : work.edgeDetector(bordaSubida)
			port map (
				CLK => CLOCK_50, 
				ENTRADA => not KEY(1), 
				SAIDA => SIG_DETECTOR_KEY1_OUT
			);

-- Flip Flop do detector de borda do KEY(1), usado para "simular" um clique do KEY(0)
FLIPFLOP_KEY1: work.flipFlop
			port map (
				DIN => '1', 
				DOUT => SIG_DETECT_TSTATE_KEY1,
				ENABLE => '1',
				CLK => SIG_DETECTOR_KEY1_OUT,
				RST => SIG_LIMPA_LEITURA_KEY1
			);	
			
-- Tri-state do KEY(1)
TRI_STATE_KEY1 : entity work.buffer_3_state
			port map(
				ENTRADA => SIG_DETECT_TSTATE_KEY1,
				HABILITA => SIG_HAB_KEY1,
				SAIDA => SIG_KEY_SW_OUT
			);
	
-- Detector de borda do KEY(2), utilizado para evitar ruídos e etc	
DETECTOR_KEY2 : work.edgeDetector(bordaSubida)
			port map (
				CLK => CLOCK_50, 
				ENTRADA => not KEY(2), 
				SAIDA => SIG_DETECTOR_KEY2_OUT
			);

-- Flip Flop do detector de borda do KEY(2), usado para "simular" um clique do KEY(0)	
FLIPFLOP_KEY2: work.flipFlop
			port map (
				DIN => '1', 
				DOUT => SIG_DETECT_TSTATE_KEY2,
				ENABLE => '1',
				CLK => SIG_DETECTOR_KEY2_OUT,
				RST => SIG_LIMPA_LEITURA_KEY2
			);	

-- Tri-state do KEY(2)
TRI_STATE_KEY2 : entity work.buffer_3_state
			port map(
				ENTRADA => SIG_DETECT_TSTATE_KEY2,
				HABILITA => SIG_HAB_KEY2,
				SAIDA => SIG_KEY_SW_OUT
			);
	
-- Tri-state do KEY(3)
TRI_STATE_KEY3 : entity work.buffer_3_state
			port map(
				ENTRADA => KEY(3),
				HABILITA => SIG_HAB_KEY3,
				SAIDA => SIG_KEY_SW_OUT
			);

-- Tri-state do FPGA_RESET			
TRI_STATE_FPGA_RESET : entity work.buffer_3_state
			port map(
				ENTRADA => FPGA_RESET_N,
				HABILITA => SIG_HAB_FPGA_RESET,
				SAIDA => SIG_KEY_SW_OUT
			);

-- Tri-state das chaves SW 0 até 7
TRI_STATE_SW0_TO_7 : entity work.buffer_3_state_8portas
			port map(
				ENTRADA => SW(7 DOWNTO 0),
				HABILITA => SIG_HAB_SW0_TO_7,
				SAIDA => SIG_KEY_SW_OUT
			);
			
-- Tri-state da chave SW8
TRI_STATE_SW8 : entity work.buffer_3_state
			port map(
				ENTRADA => SW(8),
				HABILITA => SIG_HAB_SW8,
				SAIDA => SIG_KEY_SW_OUT
			);
	
-- Tri-state da chave SW9	
TRI_STATE_SW9 : entity work.buffer_3_state
			port map(
				ENTRADA => SW(9),
				HABILITA => SIG_HAB_SW9,
				SAIDA => SIG_KEY_SW_OUT
			);
			

-- Aqui estão todos os sinais que fazem o Contador funcionar, cada um entrando ou saindo de um componente específico
SIG_LIMPA_LEITURA_KEY0 <= SIG_WR AND SIG_CPU_DATA_ADDR_OUT(0) AND SIG_CPU_DATA_ADDR_OUT(1) AND SIG_CPU_DATA_ADDR_OUT(2) AND SIG_CPU_DATA_ADDR_OUT(3) AND SIG_CPU_DATA_ADDR_OUT(4) AND SIG_CPU_DATA_ADDR_OUT(5) AND SIG_CPU_DATA_ADDR_OUT(6) AND SIG_CPU_DATA_ADDR_OUT(7) AND SIG_CPU_DATA_ADDR_OUT(8);
SIG_LIMPA_LEITURA_KEY1 <= SIG_WR AND (NOT SIG_CPU_DATA_ADDR_OUT(0)) AND SIG_CPU_DATA_ADDR_OUT(1) AND SIG_CPU_DATA_ADDR_OUT(2) AND SIG_CPU_DATA_ADDR_OUT(3) AND SIG_CPU_DATA_ADDR_OUT(4) AND SIG_CPU_DATA_ADDR_OUT(5) AND SIG_CPU_DATA_ADDR_OUT(6) AND SIG_CPU_DATA_ADDR_OUT(7) AND SIG_CPU_DATA_ADDR_OUT(8);
SIG_LIMPA_LEITURA_KEY2 <= SIG_WR AND SIG_CPU_DATA_ADDR_OUT(0) AND (not SIG_CPU_DATA_ADDR_OUT(1)) AND SIG_CPU_DATA_ADDR_OUT(2) AND SIG_CPU_DATA_ADDR_OUT(3) AND SIG_CPU_DATA_ADDR_OUT(4) AND SIG_CPU_DATA_ADDR_OUT(5) AND SIG_CPU_DATA_ADDR_OUT(6) AND SIG_CPU_DATA_ADDR_OUT(7) AND SIG_CPU_DATA_ADDR_OUT(8);			
SIG_LIMPA_CLK_1_SEC <= SIG_WR AND
						(not SIG_CPU_DATA_ADDR_OUT(0)) AND
						(not SIG_CPU_DATA_ADDR_OUT(1)) AND
						SIG_CPU_DATA_ADDR_OUT(2) AND
						SIG_CPU_DATA_ADDR_OUT(3) AND
						SIG_CPU_DATA_ADDR_OUT(4) AND
						SIG_CPU_DATA_ADDR_OUT(5) AND
						SIG_CPU_DATA_ADDR_OUT(6) AND
						SIG_CPU_DATA_ADDR_OUT(7) AND
						SIG_CPU_DATA_ADDR_OUT(8); -- 508

SIG_HAB_CLK_1_SEC <= SIG_RD AND
							SIG_CPU_DATA_ADDR_OUT(0) AND
							SIG_CPU_DATA_ADDR_OUT(1) AND
							(not SIG_CPU_DATA_ADDR_OUT(2)) AND
							SIG_CPU_DATA_ADDR_OUT(3) AND
							SIG_CPU_DATA_ADDR_OUT(4) AND
							SIG_CPU_DATA_ADDR_OUT(5) AND
							SIG_CPU_DATA_ADDR_OUT(6) AND
							SIG_CPU_DATA_ADDR_OUT(7) AND
							SIG_CPU_DATA_ADDR_OUT(8); --507

SIG_HAB_SW0_TO_7 <= 	SIG_RD AND SIG_DECODER_LED_OUT(0) AND SIG_DECODER_BLOCO_OUT(5) AND (NOT SIG_CPU_DATA_ADDR_OUT(5));
SIG_HAB_SW8 <= SIG_RD AND SIG_DECODER_LED_OUT(1) AND SIG_DECODER_BLOCO_OUT(5) AND (NOT SIG_CPU_DATA_ADDR_OUT(5));
SIG_HAB_SW9 <= SIG_RD AND SIG_DECODER_LED_OUT(2) AND SIG_DECODER_BLOCO_OUT(5) AND (NOT SIG_CPU_DATA_ADDR_OUT(5));

SIG_HAB_KEY0 <=  SIG_RD AND SIG_DECODER_LED_OUT(0) AND SIG_DECODER_BLOCO_OUT(5) AND SIG_CPU_DATA_ADDR_OUT(5);
SIG_HAB_KEY1 <=  SIG_RD AND SIG_DECODER_LED_OUT(1) AND SIG_DECODER_BLOCO_OUT(5) AND SIG_CPU_DATA_ADDR_OUT(5);
SIG_HAB_KEY2 <=  SIG_RD AND SIG_DECODER_LED_OUT(2) AND SIG_DECODER_BLOCO_OUT(5) AND SIG_CPU_DATA_ADDR_OUT(5);
SIG_HAB_KEY3 <=  SIG_RD AND SIG_DECODER_LED_OUT(3) AND SIG_DECODER_BLOCO_OUT(5) AND SIG_CPU_DATA_ADDR_OUT(5);
SIG_HAB_FPGA_RESET <= SIG_RD AND SIG_DECODER_LED_OUT(4) AND SIG_DECODER_BLOCO_OUT(5) AND SIG_CPU_DATA_ADDR_OUT(5);
			
SIG_HAB_HEX0 <= SIG_WR AND SIG_DECODER_LED_OUT(0) AND SIG_DECODER_BLOCO_OUT(4) AND SIG_CPU_DATA_ADDR_OUT(5);
SIG_HAB_HEX1 <= SIG_WR AND SIG_DECODER_LED_OUT(1) AND SIG_DECODER_BLOCO_OUT(4) AND SIG_CPU_DATA_ADDR_OUT(5);
SIG_HAB_HEX2 <= SIG_WR AND SIG_DECODER_LED_OUT(2) AND SIG_DECODER_BLOCO_OUT(4) AND SIG_CPU_DATA_ADDR_OUT(5);
SIG_HAB_HEX3 <= SIG_WR AND SIG_DECODER_LED_OUT(3) AND SIG_DECODER_BLOCO_OUT(4) AND SIG_CPU_DATA_ADDR_OUT(5);
SIG_HAB_HEX4 <= SIG_WR AND SIG_DECODER_LED_OUT(4) AND SIG_DECODER_BLOCO_OUT(4) AND SIG_CPU_DATA_ADDR_OUT(5);
SIG_HAB_HEX5 <= SIG_WR AND SIG_DECODER_LED_OUT(5) AND SIG_DECODER_BLOCO_OUT(4) AND SIG_CPU_DATA_ADDR_OUT(5);
			
SIG_HAB_LED_0_TO_7 <= SIG_WR AND SIG_DECODER_LED_OUT(0) AND SIG_DECODER_BLOCO_OUT(4) AND (NOT SIG_CPU_DATA_ADDR_OUT(5));
SIG_HAB_LED8 <= SIG_WR AND SIG_DECODER_LED_OUT(1) AND SIG_DECODER_BLOCO_OUT(4) AND (NOT SIG_CPU_DATA_ADDR_OUT(5));
SIG_HAB_LED9 <= SIG_WR AND SIG_DECODER_LED_OUT(2) AND SIG_DECODER_BLOCO_OUT(4) AND (NOT SIG_CPU_DATA_ADDR_OUT(5));

LEDR(7 DOWNTO 0) <= SIG_REG_LED_TO_LEDR;
LEDR(8) <= SIG_FF_LED_TO_LED8;
LEDR(9) <= SIG_FF_LED_TO_LED9;

SIG_RAM_TO_CPU_DATA <= SIG_KEY_SW_OUT;
SIG_RAM_TO_CPU_DATA <= SIG_CLK_1_SEC;
PC_OUT <= SIG_CPU_TO_ROM;

SAIDA_ULA <= SIG_CPU_TO_RAM_DATA;

end architecture;