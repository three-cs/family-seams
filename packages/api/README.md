# family-seams : api

REST API used by the family-seams application.

## Development

This project is designed to be written specification first.
This specifications will be maintained in `./specification` directroy.
All specifications will be in yaml format and follow the [Open API Specification](https://swagger.io/specification/)
`operationId` are mapped to handlers using [openapi-backend](https://github.com/anttiviljami/openapi-backend/blob/master/DOCS.md)

Watch the server locally using:
```
npm run watch
```

## Configuration

The following are environment variables used to configure various aspects of
the application.

| Variable       | Default | Description                                 |
|----------------|---------|---------------------------------------------|
| `SERVER_PORT`  | `9000`  | Server port to listen for incoming requests |
| `LOG_REQUESTS` | `false` | Log basic request information               |
| `PROBE_PORT`   | `9001`  | Port to listen for probe requests           |

