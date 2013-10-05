module.exports = (env, callback) ->

  defaults =
    template: 'category.jade'

  options = env.config.category or {}
  for key, value of defaults
    options[key] ?= defaults[key]

  getCateArticles = (tree) ->
    result = {} 
    contents = env.ContentTree.flatten tree
    for index, content  of contents
      if content.metadata? and content.metadata.category?
        cate = content.metadata.category
        unless result[cate]? 
          result[cate] = []
        result[cate].push content
    return result

  class CategoryPage extends env.ContentPlugin

    constructor: (@category, @articles) ->

    getFilename: ->
      debugger
      @category + "/index.html"

    @property 'template', ->
      options.template

    getView: ->
      'template'

  env.registerGenerator 'category', (contents, callback) ->

    # find all articles by category
    result = getCateArticles contents

    pages = {}
    for cate, articles of result
      pages[cate] = new CategoryPage cate, articles
    
    rv = { categories: pages }

    callback null, rv

  env.helpers.getCateArticles = getCateArticles

  # tell the plugin manager we are done
  callback()
