#!/bin/bash

PORTA=8000

# 🎨 Cores ANSI
VERDE="\033[32m"
VERMELHO="\033[31m"
AMARELO="\033[33m"
AZUL="\033[34m"
RESET="\033[0m"

# 📂 Pega o caminho da pasta do argumento
PASTA="$1"

# Verifica se foi informado
if [ -z "$PASTA" ]; then
    echo -e "${AMARELO}Uso:${RESET} $0 /caminho/da/pasta"
    exit 1
fi

# Verifica se a pasta existe
if [ ! -d "$PASTA" ]; then
    echo -e "${VERMELHO}❌ ERRO:${RESET} Pasta inválida!"
    exit 1
fi

# 🌐 Descobre o IP da máquina
IP=$(ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -n 1)
if [ -z "$IP" ]; then
    echo -e "${VERMELHO}❌ ERRO:${RESET} Não foi possível detectar o IP."
    exit 1
fi

# 🚪 Função para encerrar e limpar
cleanup() {
    echo ""
    echo -e "${AMARELO}[*] Encerrando servidor e fechando porta...${RESET}"
    kill $SERVER_PID 2>/dev/null
    sudo ufw delete allow $PORTA/tcp >/dev/null
    echo -e "${VERDE}✔ Servidor desligado.${RESET}"
}
trap cleanup EXIT

# 🔓 Abrir porta no firewall
echo -e "${AZUL}[*] Abrindo porta $PORTA...${RESET}"
sudo ufw allow $PORTA/tcp >/dev/null

# ▶️ Iniciar servidor Python na pasta escolhida
cd "$PASTA" || exit
echo -e "${AZUL}[*] Iniciando servidor Python em:${RESET} $PASTA"
python3 -m http.server $PORTA --bind 0.0.0.0 &
SERVER_PID=$!

echo -e "${VERDE}✔ Servidor rodando!${RESET}"
echo -e "📂 Pasta: ${AMARELO}$PASTA${RESET}"
echo -e "🌐 Acesse: ${AZUL}http://$IP:$PORTA/${RESET}"
echo -e "${AMARELO}[*] Pressione CTRL+C para encerrar.${RESET}"

# ⏳ Espera até o usuário encerrar
wait $SERVER_PID
