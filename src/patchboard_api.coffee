module.exports =
  
  map:
    service:
      paths: ["/"]
      publish: true

  interface:
    service:
      actions:

        documentation:
          method: "GET"
          status: 200

        description:
          method: "GET"
          response_entity: "description"
          status: 200

  schema:
    id: "patchboard"
    properties:
      resource:
        type: "object"
        properties:
          url:
            type: "string"
            format: "uri"
            readonly: true
      service:
        extends: {$ref: "#resource"}

      description:
        type: "object"
        mediaType: "application/json"
        properties:
          schema: {type: "object"}
          interface: {type: "object"}
          directory: {type: "object"}

