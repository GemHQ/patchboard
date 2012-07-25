
module.exports =
  Client: require("./client")
  Service: require("./service")
  SchemaManager: require("./service/schema_manager")
  Classifier: require("./service/classifier")
  Dispatcher: require("./service/simple_dispatcher")
  middleware: require("./service/middleware")

