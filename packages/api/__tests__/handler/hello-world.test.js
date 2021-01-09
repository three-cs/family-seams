const handler = require('../../lib/handler/hello-world')

let status
let json

const mockResponse = {
  status: (code) => {
    status = code
    return mockResponse
  },
  json: (text) => {
    json = text
    return mockResponse
  }
}

test('hello-world', () => {
  handler({}, {}, mockResponse)

  expect(status).toBe(200)
  expect(json).toBe('Hello World!!')
})
