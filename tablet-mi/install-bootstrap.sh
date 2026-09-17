#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
KEY="${1:-}"
if [ -z "$KEY" ]; then
  echo "ERRO: chave ausente." >&2
  exit 1
fi
BASE="$HOME/Downloads/tablet-mi-installer"
mkdir -p "$BASE"
cd "$BASE"
ENC_URL="https://raw.githubusercontent.com/lucky-freud/lucky-freud/main/tablet-mi/tb311fu-moneroocean-4gb-v0.1.zip.enc"
EXPECTED_ENC_SHA256="23809eea15be0b2a8bfb7a001359bbb6365ba6d3f663e93b3768fe6320171878"
EXPECTED_ZIP_SHA256="f585a2838fb474ff5f05338ff1f464013f242f2812c3faaf60725fe111a10630"

echo "[1/4] Baixando pacote criptografado..."
curl -fL "$ENC_URL" -o package.zip.enc

echo "[2/4] Verificando integridade..."
echo "$EXPECTED_ENC_SHA256  package.zip.enc" | sha256sum -c -

echo "[3/4] Descriptografando..."
openssl enc -d -aes-256-cbc -pbkdf2 -iter 200000 -in package.zip.enc -out package.zip -pass "pass:$KEY"
echo "$EXPECTED_ZIP_SHA256  package.zip" | sha256sum -c -

echo "[4/4] Extraindo..."
rm -rf extracted
mkdir extracted
unzip -q package.zip -d extracted
cd extracted/tb311fu-moneroocean-4gb
chmod +x install.sh scripts/*.sh

echo
echo "Pacote validado. Iniciando instalador..."
exec ./install.sh
