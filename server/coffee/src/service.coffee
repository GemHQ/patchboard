URL = require("url")

PatchboardAPI = require("./patchboard_api")
Dispatcher = require("./simple_dispatcher")
Documenter = require("./documenter")
Classifier = require("./classifier")
SchemaManager = require("./schema_manager")
SchemaValidator = require("./schema_validator")
Path = require("./path")

class Service

  constructor: (options) ->
    @service_url = options.service_url || "http://localhost:1337"

    SchemaManager.normalize(PatchboardAPI.schema)
    SchemaManager.normalize(options.schema)

    @schema_manager = new SchemaManager(PatchboardAPI.schema, options.schema)
    @validator = new SchemaValidator(@schema_manager)
    @map = options.paths


    @resources = {}
    for key, value of PatchboardAPI.resources
      @resources[key] = value
    for key, value of options.resources
      @resources[key] = value

    @paths = {}
    @directory = {}

    for resource_type, mapping of PatchboardAPI.paths when mapping.publish
      @directory[resource_type] = "#{@service_url}#{mapping.path}"
    for resource_type, mapping of @map when mapping.publish
      @directory[resource_type] = "#{@service_url}#{mapping.path}"

    for resource_type, mapping of @map
      path_string = mapping.path
      @paths[resource_type] = new Path(path_string)

    @documenter = new Documenter(@schema_manager.names, @resources)
    @default_handlers = require("./handlers")(@)

    @classifier = new Classifier(@)

    @description =
      resources: @resources
      schemas: @schema_manager.schemas
      directory: @directory


  classify: (args...) ->
    @classifier.classify(args...)

  validate: (args...) ->
    @validator.validate(args...)

  generate_url: (resource_type, args...) ->
    path = @paths[resource_type]
    if path
      "#{@service_url}#{path.generate(args...)}"
    else
      throw "Problem generating URL. No such resource: #{resource_type}"

  normalize_schema: (schema) ->
    for name, definition of schema.properties
      if definition.id
        if definition.id.indexOf("#") == 0
          definition.id = "#{schema.id}#{definition.id}"
      else
        definition.id = "#{schema.id}##{name}"

      if definition.extends
        if definition.extends.$ref && definition.extends.$ref.indexOf("#") == 0
          definition.extends.$ref = "#{schema.id}#{definition.extends.$ref}"
      if definition.type == "array" && definition.items.$ref.indexOf("#") == 0
        definition.items.$ref = "#{schema.id}#{definition.items.$ref}"


  simple_dispatcher: (app_handlers) ->
    handlers = {}

    # Install Patchboard's default handlers
    for resource, actions of @default_handlers
      handlers[resource] ||= {}
      for name, handler of actions
        handlers[resource][name] = handler

    for resource, actions of app_handlers
      handlers[resource] ||= {}
      for name, handler of actions
        handlers[resource][name] = handler

    dispatcher = new Dispatcher(@, handlers)
    dispatcher.create_handler()

  augment_request: (request) ->
    url = URL.parse(request.url)
    request.path = url.pathname
    if url.query
      query_parts = url.query.split("&")
      query = {}
      for part in query_parts
        [key, value] = part.split("=")
        query[key] = value
    else
      query = {}
    request.query = query

  documentation: () ->
    """
    #{@documenter.document_resources()}
    
    #{@schema_manager.document()}
    """
  



module.exports = Service
