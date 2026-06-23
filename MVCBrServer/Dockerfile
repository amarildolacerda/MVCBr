# Dockerfile — ODataBr Server (Linux runtime)
#
# Esta imagem EXECUTA o servidor ODataBr pré-compilado para Linux.
# A compilação deve ser feita separadamente (IDE Delphi ou GitHub Actions).
#
# Uso:
#   1. Compile MVCBrServer_Linux.dpr (produz bin/MVCBrServer_Linux)
#   2. docker build -t odatabr-server -f MVCBrServer/Dockerfile .
#   3. docker run -p 8080:8080 -v /meu/config:/app/config odatabr-server

# Estágio base
FROM ubuntu:22.04 AS base
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    libc6 \
    && rm -rf /var/lib/apt/lists/*

# Estágio Firebird
FROM base AS fb
RUN apt-get update && apt-get install -y --no-install-recommends \
    libfbclient2 \
    && rm -rf /var/lib/apt/lists/*

# Estágio PostgreSQL
FROM base AS pg
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq5 \
    && rm -rf /var/lib/apt/lists/*

# Imagem final com suporte a Firebird + PostgreSQL
FROM fb
COPY --from=pg /usr/lib/x86_64-linux-gnu/libpq* /usr/lib/x86_64-linux-gnu/

WORKDIR /app

COPY --chmod=755 bin/MVCBrServer_Linux /app/ODataBrServer
COPY --chmod=644 MVCBrServer/MVCBrServer.config /app/ODataBrServer.config

EXPOSE 8080
ENTRYPOINT ["/app/ODataBrServer"]
