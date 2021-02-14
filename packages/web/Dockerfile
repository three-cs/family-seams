FROM node:12.20.1

RUN mkdir -p /app

WORKDIR /app

COPY package-lock.json package-lock.json
COPY node_modules node_modules
COPY package.json package.json
COPY .next .next
COPY public public
COPY pages pages

ENTRYPOINT [ "npm" ]
CMD [ "start" ]

# Server Information
ENV SERVER_PORT=3000
EXPOSE 3000

# Probe Information
ENV PROBE_PORT=3000
HEALTHCHECK --interval=30s --timeout=1s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:${PROBE_PORT}/ || exit 1

# Configuration
ENV API_BASE_URL=not-set
