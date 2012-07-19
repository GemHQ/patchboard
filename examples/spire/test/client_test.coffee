assert = require("assert")

helpers = require("./helpers")
test = helpers.test
client_interface = helpers.interface
schema = helpers.schema



# response handling helper
expected_response = (status, callback) ->
  callbacks =
    response: (response) ->
      throw "unexpected response status: #{response.status}"
    error: (response) ->
      throw "Error: #{response.status}"

  callbacks[status] = callback
  callbacks

# Spire api tests
test_channels = (resources) ->
  resources.channels.create
    content:
      name: "monkey"
    on:
      expected_response 201,
        (response, channel) ->
          helpers.validate.channel(channel)
          list_channels(resources)


list_channels = (resources) ->
  resources.channels.all
    on:
      expected_response 200,
        (response, channel_dict) ->
          publish_to_channel(resources, channel_dict.monkey)

publish_to_channel = (resources, channel) ->
  channel.publish
    content:
      content: "bologna"
    on:
      expected_response 201,
        (response, message) ->
          test "Message is wrapped", ->
            assert.equal(message.constructor.resource_type, "message")
            test_subscriptions(resources, channel.url)


test_subscriptions = (resources, channel_url) ->
  resources.subscriptions.create
    content:
      channels: [channel_url]
    on:
      expected_response 201,
        (response, subscription) ->
          get_events(subscription)
          get_current_events(subscription)

get_events = (subscription) ->
  subscription.events
    on:
      expected_response 200,
        (response, events) ->
          test "Received expected message", ->
            assert.equal(events.messages.length, 1)
            assert.equal(events.messages[0].content, "bologna")
            delete_message(events.messages[0])
          test "Subscription messages are wrapped", ->
            assert.equal(events.messages[0].constructor.resource_type, "message")

get_current_events = (subscription) ->
  subscription.events
    query:
      min_timestamp: "now"
    on:
      expected_response 200,
        (response, events) ->
          test "Received no messages", ->
            assert.equal(events.messages.length, 0)

delete_message = (message) ->
  assert.equal(message.constructor.resource_type, "message")
  message.delete
    on:
      expected_response 204,
        (response, events) ->
          test "Deleted message", ->

#
Client = require("patchboard/src/client")
# Set up the Patchboard client
client = new Client
  interface: client_interface
  schema: schema


# Fake out the discovery of public resources
account_collection = client.wrappers.account_collection
  url: "http://localhost:1337/accounts"

# run actual tests
account_collection.create
  content:
    email: "foo#{Math.random()}@bar.com", password: "monkeyshines",
  on:
    201: (response, session) ->
      helpers.validate.session(session)

      session_collection = client.wrappers.session_collection
        url: "http://localhost:1337/sessions"

      session_collection.create
        content:
          secret: session.resources.account.secret
        on:
          201: (response, session) ->
            channel_collection = session.resources.channels
            helpers.validate.channel_collection(channel_collection)
            test_channels(session.resources)
          response: (response) ->
            throw "unexpected response status: #{response.status}"
          error: (response) ->
            throw "Error: #{response.status}"

    response: (response) ->
      throw "unexpected response status: #{response.status}"
    error: (response) ->
      throw "Error: #{response.status}"



