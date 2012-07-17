assert = require("assert")

helpers = require("./helpers")
test = helpers.test

Patchboard = helpers.Patchboard

classifier = new Patchboard.Classifier
  interface: helpers.interface
  schema: helpers.schema
  map: helpers.map

media_type = (type) ->
  "application/vnd.spire-io.#{type}+json;version=1.0"

class MockRequest

  constructor: (options) ->
    @url = options.url
    @method = options.method
    @headers = options.headers

test_classification = (name, want, options) ->
  test name, ->
    request = new MockRequest(options)
    result = classifier.classify(request)
    helpers.partial_equal(result, want)

test_classification "Classifying account_collection.create",
  {
    match: {resource_type: "account_collection", action_name: "create"}
  },
  url: "http://host/accounts"
  method: "POST"
  headers:
    "Content-Type": media_type("account")
    "Accept": media_type("session")

test_classification "Classifying account.get",
  {
    match: {resource_type: "account", action_name: "get"}
  },
  url: "http://localhost:1337/account/12345"
  method: "GET"
  headers:
    "Accept": media_type("account")
    "Authorization": "Capability <token>"

test_classification "Classifying channel_collection.create",
  {
    match: {resource_type: "channel_collection", action_name: "create"}
  },
  url: "http://host/account/12345/channels"
  method: "POST"
  headers:
    "Content-Type": media_type("channel")
    "Accept": media_type("channel")
    "Authorization": "Capability <token>"

test_classification "Classifying channel_collection.get_by_name",
  {
    match: {resource_type: "channel_collection", action_name: "get_by_name"}
  },
  url: "http://localhost:1337/account/12345/channels?name=smurf"
  method: "GET"
  headers:
    "Accept": media_type("channels")
    "Authorization": "Capability <token>"

test_classification "failure to match Accept header",
  {error: "accept"},
  url: "http://localhost:1337/account/12345/channels"
  method: "GET"
  headers:
    "Accept": "bogus"
    "Authorization": "Capability <token>"

test_classification "failure to match Content-Type header",
  {error: "content_type"},
  url: "http://localhost:1337/account/12345/channels"
  method: "POST"
  headers:
    "Accept": media_type("channels")
    "Content-Type": "bogus"
    "Authorization": "Capability <token>"

test_classification "failure to match method",
  {error: "method"},
  url: "http://localhost:1337/account/12345/channels"
  method: "PUT"
  headers:
    "Authorization": "Capability <token>"

test_classification "failure to match authorization scheme",
  {error: "authorization"},
  url: "http://localhost:1337/account/12345/channels"
  method: "GET"
  headers:
    "Accept": media_type("channels")
    "Authorization": "Basic <token>"
