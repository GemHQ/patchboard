module.exports =

  capability_dictionary:
    type: "dictionary"
    items: {type: "string"}

  account:
    type: "resource"
    media_type: "application/vnd.spire-io.account+json;version=1.0"
    properties:
      url: {type: "string"}
      capabilities: {type: "capability_dictionary"}
      id: {type: "string", readonly: true}
      secret: {type: "string", readonly: true}
      created_at: {type: "number"}
      email: {type: "string"}
      name: {type: "string"}
      password: {type: "string"}
    required: ["email", "password"]

  account_collection:
    type: "resource"
    media_type: "application/vnd.spire-io.accounts+json;version=1.0"
    properties:
      url: {type: "string"}

  session:
    type: "resource"
    media_type: "application/vnd.spire-io.session+json;version=1.0"
    properties:
      url: {type: "string"}
      capabilities: {type: "capability_dictionary"}
      resources:
        type: "object"
        properties:
          account: {type: "account"}
          channels: {type: "channel_collection"}
          #applications: {}
          #subscriptions: {}
          #notifications: {}
          

  channel:
    type: "resource"
    media_type: "application/vnd.spire-io.channel+json;version=1.0"
    properties:
      url: {type: "string"}
      capabilities: {type: "capability_dictionary"}
      name: {type: "string"}
      application_key: {type: "string", readonly: true}
      limit: {type: "number"}
    required: ["name"]

  channel_collection:
    type: "resource"
    media_type: "application/vnd.spire-io.channels+json;version=1.0"
    properties:
      url: {type: "string"}
      capabilities: {type: "capability_dictionary"}

  channel_dictionary:
    type: "dictionary"
    media_type: "application/vnd.spire-io.channels+json;version=1.0"
    items: {type: "channel"}

  message:
    type: "resource"
    media_type: "application/vnd.spire-io.message+json;version=1.0"
    items: {type: "channel"}
    properties:
      url: {type: "string"}
      capabilities: {type: "capability_dictionary"}
      channel_name: {type: "string"}
      content: {type: "object"}
      timestamp: {type: "number"}

