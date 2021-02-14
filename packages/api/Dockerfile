FROM node:12.20.1

RUN mkdir -p /app

WORKDIR /app

COPY package-lock.json package-lock.json
COPY node_modules node_modules
COPY package.json package.json
COPY specification specification
COPY lib lib

ENTRYPOINT [ "node" ]
CMD [ "lib/api.js" ]

# Server Information
ENV SERVER_PORT=9000
EXPOSE 9000

# Probe Information
ENV PROBE_PORT=9001
EXPOSE 9001
HEALTHCHECK --interval=30s --timeout=1s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:${PROBE_PORT}/health || exit 1

# Logging Information
ENV LOG_REQUESTS=false
