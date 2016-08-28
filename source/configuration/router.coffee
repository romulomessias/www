'use strict'

###

/source/configuration/router
Router module!

Defines all the routes of the application and its responses.
Calls the controllers to respond to each path. 
 
###

# Imports the definitions.
definitions = require '../../../definitions.json'
folders = definitions.folders
routes = definitions.routes

# Imports the required modules.
router = (require 'koa-router')()
dir = require 'require-dir'

# Defines the basic controller caller functions.
call = (ctrlr) ->
    (next) ->
        ctrlr this
        yield next
        
cally = (ctrlr) ->
    (next) ->
        yield ctrlr this
        yield next

# Gets the controllers.
controller = dir "../../../#{folders.binaries}/#{folders.controllers}/"

# GET -> "/" (index).
router.get '/', call controller.home.index

# GET -> portuguese page.
router.get routes.portuguese.index, call controller.home.pt
router.get (new RegExp routes.portuguese.pattern), call controller.home.pt

# GET -> english page.
router.get routes.english.index, call controller.home.en
router.get (new RegExp routes.english.pattern), call controller.home.en
    
# GET -> static files.
router.get (new RegExp routes.static.pattern), cally controller.static.index

# Function that adds every route on the app.
use = (app) -> app.use router.routes()

module.exports =
    use: use