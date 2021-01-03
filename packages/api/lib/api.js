const { OpenAPIBackend } = require('openapi-backend')
const express = require('express')
const { createLightship } = require('lightship')
const path = require('path')

// Used for health probes
const lightship = createLightship({
  detectKubernetes: false,
  port: process.env.PROBE_PORT || 9001
})

// Open API Backend Configuration
const api = new OpenAPIBackend({ definition: './specification/hello-world.yml' })

// Register specification handlers here
api.register({
  apiGetHelloWorld: require('./handler/hello-world.js')
})

// add default error handlers
api.register('validationFail', (c, req, res) => res.status(400).json({ status: 400, err: c.validation.errors }))
api.register('notFound', (c, req, res) => res.status(404).json({ status: 404, err: 'Not found' }))
api.register('methodNotAllowed', (c, req, res) => res.status(405).json({ status: 405, err: 'Method not allowed' }))
api.register('notImplemented', (c, req, res) => res.status(404).json({ status: 501, err: 'No handler registered for operation' }))
api.register('unauthorizedHandler', (c, req, res) => res.status(401).json({ status: 401, err: 'Please authenticate first' }))

api.init()

const app = express()

// add logging middleware
if (process.env.LOG_REQUESTS == 'true') {
  app.use((req, res, next) => {
    console.log(`[${req.method}] ${req.path}`)
    next()
  })
}

// add json middleware
app.use(express.json())

// add static handler for spcifications
app.use('/spec', express.static(path.join(__dirname, '../specification')))

// add openapi-backend handler for all mapped requests
app.use((req, res) => api.handleRequest(req, req, res))

// start server
const server = app.listen(process.env.SERVER_PORT || 9000, () => {
  lightship.signalReady()
})

// add graceful shutdown
lightship.registerShutdownHandler(() => {
  server.close()
})
