#!/bin/bash
# net.sh - utilitários de rede e gerenciamento de portas locais

# ⚙️ Verifica se uma porta está livre. Se ocupada, oferece finalização do processo.
# Uso: freeport <porta>
freeport() {
  if [ -z "$1" ]; then
    echo "❌ Porta não informada. Uso: freeport <porta>"
    return 1
  fi

  if ! [[ "$1" =~ ^[0-9]+$ ]] || [ "$1" -lt 1 ] || [ "$1" -gt 65535 ]; then
    echo "❌ Porta inválida. Informe um número entre 1 e 65535."
    return 1
  fi

  local PORT=$1
  local PID
  PID=$(lsof -ti :$PORT)

  if [ -z "$PID" ]; then
    echo "✅ Porta $PORT está livre."
  else
    echo "⚠️ Porta $PORT está sendo usada pelo processo PID: $PID"
    lsof -nP -i :$PORT

    read -rp "Deseja finalizar o processo? [s/N]: " CONFIRM
    if [[ "$CONFIRM" =~ ^[sS]$ ]]; then
      kill -15 "$PID" 2>/dev/null
      sleep 1

      if ps -p "$PID" > /dev/null; then
        echo "⏳ Processo ainda em execução. Tentando kill -9..."
        kill -9 "$PID" 2>/dev/null

        if ps -p "$PID" > /dev/null; then
          echo "❌ Não foi possível finalizar o processo $PID."
        else
          echo "✅ Processo $PID foi finalizado com sucesso (force kill)."
        fi
      else
        echo "✅ Processo $PID foi finalizado com sucesso (graceful kill)."
      fi
    else
      echo "❌ Ação cancelada. Processo continua rodando."
    fi
  fi
}

# 🌐 Retorna o IP local da máquina (excluindo 127.0.0.1)
# Uso: my_ip
my_ip() {
  ip addr show | grep inet | grep -v 127 | awk '{print $2}' | cut -d/ -f1
}

# 🌎 Retorna o IP externo da máquina (necessita conexão)
# Uso: external_ip
external_ip() {
  curl -s https://ipinfo.io/ip
}

# 📶 Verifica se um host está acessível via ping
# Uso: test_connection <host>
test_connection() {
  if [ -z "$1" ]; then
    echo "❌ Uso: test_connection <host>"
    return 1
  fi

  if ping -c 1 "$1" > /dev/null 2>&1; then
    echo "✅ Host $1 está acessível."
  else
    echo "❌ Não foi possível alcançar o host $1."
  fi
}

# 🚪 Verifica se uma porta específica está aberta em um host
# Uso: check_port <host> <porta>
check_port() {
  if [ -z "$1" ] || [ -z "$2" ]; then
    echo "❌ Uso: check_port <host> <porta>"
    return 1
  fi

  nc -zv "$1" "$2"
}

# 📡 Exibe as portas em escuta no sistema
# Uso: open_ports
open_ports() {
  sudo lsof -i -P -n | grep LISTEN
}

# 🧭 Mostra os servidores DNS configurados
# Uso: dns_info
dns_info() {
  grep nameserver /etc/resolv.conf
}

# 🌐 Verifica o status HTTP de um site (HEAD request)
# Uso: http_check <url>
http_check() {
  if [ -z "$1" ]; then
    echo "❌ Uso: http_check <url>"
    return 1
  fi

  curl -Is "$1" | head -n 1
}
