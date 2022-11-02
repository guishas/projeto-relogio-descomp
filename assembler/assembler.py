# Arquivos de entrada e saída do assembler
entrada = 'entrada.txt'
saida = 'assembly.txt'

# Dicionário para guardar as labels e suas respectivas posições e tipos
labels = {}

# Função para converter endereços, por exemplo @352, para binário
def converteArroba(line):
  items = line.replace("\n", "").split('@')
  addr = bin(int(items[-1]))[2:].zfill(9)
  return addr

# Função para converter números, por exemplo $15, para binário
def converteCifrao(line):
  items = line.replace("\n", "").split('$')
  num = bin(int(items[-1]))[2:].zfill(9)
  return num

def converteHashtag(line):
  items = line.replace("\n", "").split(' ')
  addr = bin(int(items[1].replace("#", "")))[2:].zfill(3)
  return addr

# Função para pegar o mnemônico de uma linha
def converteMnemonico(line):
  return line.replace("\n", "").split(' ')[0]

# Função para converter o que vem do arquivo de entrada para código assembly
def converteParaLabel(line):
  if '@' in line:
    l = converteMnemonico(line) + ' & \"' + converteHashtag(line) + '\" & \"' + converteArroba(line) + '\";'
  elif '$' in line:
    l = converteMnemonico(line) + ' & \"' + converteHashtag(line) + '\" & \"' + converteCifrao(line) + '\";'
  elif '%' in line:
    l = converteMnemonico(line) + ' & \"' + '000\" & \"' + line.split('%')[-1].replace("\n", "") + '\";'
  else:
    l = line

  return l 

# Função para retornar a posição da memória de instruções de uma linha
def pegaPosicaoTmp(line):
  return line.split('(')[0][:1]

# Função para retornar uma label a partir de um JMP, JEQ, JGT ou JSR
def converteLabel(line):
  return line.split('%')[-1].replace("\n", "")

# Abrindo arquivo de entrada, lendo as linhas e salvando em uma variável
with open(entrada, "r") as f:
  lines = f.readlines()

# Código para calcular em que posição cada LABEL vai estar
cont_labels = 0
for index, line in enumerate(lines):
  line = line.replace("\n", "")
  if ':' in line:
    labels[line.split(':')[0]] = {"pos": index-cont_labels}
    cont_labels+=1

# Código para colocar tipos de JUMP nos JUMPs do código
for index, line in enumerate(lines):
  line = line.replace("\n", "")
  if 'JSR' in line:
    label = line.split('%')[-1]
    labels[label]["type"] = "JSR"
  else:
    if line.startswith('J'):
      label = line.split('%')[-1]
      type = line.split('%')[0]
      labels[label]["type"] = type.replace(" ", "")

# Código para de fato escrever no arquivo de saída o código assembly usando todas as funções acima como ajuda
with open(saida, "w+") as f:

  cont = 0
  for line in lines:
    if not ':' in line:
      if '@' in line:
        t = 'tmp(' + str(cont) + ') := ' + converteMnemonico(line) + ' & \"' + converteHashtag(line) + '\" & \"' + converteArroba(line) + '\"; -- ' + line.replace("\n", "") + '\n'
        cont+=1
      elif '$' in line:
        t = 'tmp(' + str(cont) + ') := ' + converteMnemonico(line) + ' & \"' + converteHashtag(line) + '\" & \"' + converteCifrao(line) + '\"; -- ' + line.replace("\n", "") + '\n'
        cont+=1
      elif '%' in line:
        label = converteLabel(line)
        tmp = int(labels[label]["pos"])
        t = 'tmp(' + str(cont) + ') := ' + converteMnemonico(line) + ' & \"000\" & \"' + bin(tmp)[2:].zfill(9) + '\"; -- ' + line.replace("\n", "") + '\n'
        cont+=1
      elif line.replace("\n", "").replace(" ", "") == "RET":
        t = 'tmp(' + str(cont) + ') := ' + line.replace("\n", "") + ' & \"000\" & \"' + bin(0)[2:].zfill(9) + '\"; -- ' + line.replace("\n", "") + '\n'
        cont+=1
      elif line.replace("\n", "") == "NOP":
        t = 'tmp(' + str(cont) + ') := ' + line.replace("\n", "") + ' & \"000\" & \"' + bin(0)[2:].zfill(9) + '\"; -- ' + line.replace("\n", "") + '\n'
        cont+=1
      else:
        t = line
        cont+=1

      f.write(t)
    else:
      label = line.split(':')[0]
      type = labels[label]["type"]
      if type == "JSR":
        t = '-- ' + label + '\n'
        f.write(t)