module.exports =

  account_collection:
    description: "The collection of accounts"
    actions:
      create:
        method: "POST"
        request_entity: "account"
        response_entity: "session"

  account:
    description: "The account resource"
    actions:
      get:
        method: "GET"
        response_entity: "account"
        authorization: "Capability"
      update:
        method: "PUT"
        request_entity: "account"
        response_entity: "account"
        authorization: "Capability"
      reset:
        method: "POST"
        response_entity: "account"
      delete:
        method: "DELETE"
        authorization: "Capability"

  session_collection:
    description: "The place to get sessions from"
    actions:
      create:
        method: "POST"
        request_entity: "account"
        response_entity: "session"

  session:
    actions:
      get:
        method: "GET"
        response_entity: "session"
        authorization: "Capability"
      delete:
        method: "DELETE"
        authorization: "Capability"

  channel_collection:
    description: "The collection of channels for a particular account"
    actions:
      get_by_name:
        method: "GET"
        query:
          required:
            name:
              description: "The exact name of a channel"
              type: "string"
        response_entity: "channel_dictionary"
        authorization: "Capability"
      all:
        method: "GET"
        response_entity: "channel_dictionary"
        authorization: "Capability"
      create:
        method: "POST"
        request_entity: "channel"
        response_entity: "channel"
        authorization: "Capability"

  channel:
    description: "The channel resource"
    actions:
      get:
        method: "GET"
        authorization: "Capability"
        response_entity: "channel"
      publish:
        method: "POST"
        authorization: "Capability"
        request_entity: "message"
        response_entity: "message"
      delete:
        method: "DELETE"
        authorization: "Capability"

  subscription_collection:
    actions:
      create:
        method: "POST"
        authorization: "Capability"
        request_entity: "subscription"
        response_entity: "subscription"
      get_by_name:
        method: "GET"
        response_entity: "subscription_dictionary"
        query:
          required:
            name:
              description: "The exact name of the subscription"
              type: "string"
        authorization: "Capability"
      all:
        method: "GET"
        response_entity: "subscription"
        authorization: "Capability"
        
  subscription:
    actions:
      events:
        method: "GET"
        authorization: "Capability"
        response_entity: "events"

  message:
    actions:
      get:
        method: "GET"
        authorization: "Capability"
        response_entity: "message"
      update:
        method: "PUT"
        request_entity: "message"
        response_entity: "message"
        authorization: "Capability"
      delete:
        method: "DELETE"
        authorization: "Capability"
