#!/bin/bash
# =============================================================================
# INSTALADOR DE NETWORK-KILLER
# =============================================================================

clear
echo -e "\033[0;31m"
echo "███╗   ██╗███████╗████████╗██V
╗ ██╗ ██████╗ ██████╗ ██╗  ██╗██╗██╗     ██╗     ███████╗██████╗ "
echo "████╗  ██║██╔════╝╚══██╔══╝██║ ██╔╝██╔═══██╗██╔══██╗██║ ██╔╝██║██║     ██║     ██╔════╝██╔══██╗"
echo "██╔██╗ ██║█████╗     ██║   █████╔╝ ██║   ██║██████╔╝█████╔╝ ██║██║     ██║     █████╗  ██████╔╝"
echo "██║╚██╗██║██╔══╝     ██║   ██╔═██╗ ██║   ██║██╔══██╗██╔═██╗ ██║██║     ██║     ██╔══╝  ██╔══██╗"
echo "██║ ╚████║███████╗   ██║   ██║  ██╗╚██████╔╝██║  ██║██║  ██╗██║███████╗███████╗███████╗██║  ██║"
echo "╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝"
echo -e "\033[0m"
echo -e "\033[1;33m════════════════════════════════════════════════════════════════\033[0m"
echo -e "\033[1;32m         INSTALADOR DE NETWORK-KILLER\033[0m"
echo -e "\033[1;33m════════════════════════════════════════════════════════════════\033[0m"
echo ""

# Verificar Termux
if [ ! -d "$HOME/.termux" ]; then
    echo -e "\033[0;31m❌ Esto no parece ser Termux\033[0m"
    exit 1
fi

# Paso 1: Permisos
echo -e "\033[0;34m[1/5] Dando permisos de almacenamiento...\033[0m"
termux-setup-storage 2>/dev/null || echo "   ⚠️ Omite si ya tienes permisos"

# Paso 2: Actualizar
echo -e "\033[0;34m[2/5] Actualizando Termux...\033[0m"
pkg update -y && pkg upgrade -y

# Paso 3: Instalar paquetes
echo -e "\033[0;34m[3/5] Instalando paquetes...\033[0m"
pkg install -y python3 git nmap curl wget

# Paso 4: Instalar librerías Python
echo -e "\033[0;34m[4/5] Instalando librerías Python...\033[0m"
pip install --upgrade pip
pip install requests colorama netifaces

# Paso 5: Crear directorios
echo -e "\033[0;34m[5/5] Creando directorios...\033[0m"
mkdir -p herramientas

echo ""
echo -e "\033[0;32m════════════════════════════════════════════════════════════════\033[0m"
echo -e "\033[0;32m✅ INSTALACIÓN COMPLETA\033[0m"
echo -e "\033[0;32m════════════════════════════════════════════════════════════════\033[0m"
echo ""
echo -e "\033[1;33mPara ejecutar:\033[0m"
echo -e "   ./killer.sh"
echo ""
