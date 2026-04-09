# 🔥 NETWORK-KILLER - Tumba cualquier IP de tu red WiFi

[![Version](https://img.shields.io/badge/version-3.0-red.svg)](https://github.com/)
[![Termux](https://img.shields.io/badge/Termux-Compatible-brightgreen.svg)](https://termux.com/)

## ⚡ Características

- ✅ **Escanea automáticamente** todas las IPs conectadas a tu WiFi
- ✅ **Interfaz gráfica en terminal** (elige con números)
- ✅ **Tumba la IP seleccionada** con múltiples ataques
- ✅ **Monitoreo en tiempo real** del estado de la víctima
- ✅ **SIN ROOT** (funciona en cualquier Android)

## 🎯 Cómo funciona

1. Escanea tu red local (192.168.1.0/24)
2. Muestra todas las IPs conectadas con su estado
3. Eliges qué IP quieres tumbar (por número)
4. El script lanza 8 ataques simultáneos contra esa IP
5. Monitoreo en vivo de la desconexión

## 📱 Requisitos

| Requisito | Mínimo |
|-----------|--------|
| Android | 7.0+ |
| Termux | F-Droid |
| WiFi | Conectado |
| Root | No necesario |

## 🚀 Instalación Rápida

```bash
# 1. Clonar repositorio
git clone https://github.com/Diego-kaly/NETWORK-KILLER.git
cd NETWORK-KILLER

# 2. Dar permisos
chmod +x install.sh killer.sh

# 3. Instalar dependencias
./install.sh

# 4. Ejecutar
./killer.sh
