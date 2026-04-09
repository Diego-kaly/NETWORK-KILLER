#!/usr/bin/env python3
# =============================================================================
# VERIFICADOR DE REQUISITOS
# =============================================================================

import subprocess
import sys

ROJO = '\033[0;31m'
VERDE = '\033[0;32m'
AMARILLO = '\033[1;33m'
AZUL = '\033[0;34m'
NC = '\033[0m'

def verificar_python():
    version = sys.version_info
    if version.major >= 3:
        print(f"{VERDE}✅ Python {version.major}.{version.minor}{NC}")
        return True
    print(f"{ROJO}❌ Python {version.major}.{version.minor}{NC}")
    return False

def verificar_pip():
    try:
        r = subprocess.run(['pip', '--version'], capture_output=True, text=True)
        print(f"{VERDE}✅ {r.stdout.split()[1]}{NC}")
        return True
    except:
        print(f"{ROJO}❌ Pip no instalado{NC}")
        return False

def verificar_libreria(lib):
    try:
        __import__(lib)
        print(f"{VERDE}✅ {lib}{NC}")
        return True
    except:
        print(f"{ROJO}❌ {lib}{NC}")
        return False

def main():
    print(f"\n{AZUL}{'='*50}{NC}")
    print(f"{AZUL}   VERIFICADOR DE REQUISITOS{NC}")
    print(f"{AZUL}{'='*50}{NC}\n")
    
    verificar_python()
    verificar_pip()
    print()
    
    for lib in ['requests', 'colorama', 'netifaces']:
        verificar_libreria(lib)
    
    print(f"\n{AZUL}{'='*50}{NC}\n")

if __name__ == "__main__":
    main()
