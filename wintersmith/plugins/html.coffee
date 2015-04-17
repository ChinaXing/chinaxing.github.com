async = require 'async'
yaml = require 'js-yaml'
fs = require 'fs'




module.exports = (env, callback) ->

  defaults =
    introSize: 400 # number of charactors of introduce

  # assign defaults any option not set in the config file
  options = env.config.html or {}
  for key, value of defaults
    options[key] ?= defaults[key]

  findTag = (str) ->
    len = str.length
    s = -1
    e = -1
    n = "none"
    t = "none"
    for i in [0...len-1]
      if str[i] is '<'
        if str[i+1] is '/'
          t = "end"
          s = i + 2
        else
          t = "start"
          s = i + 1
        continue
      if str[i] is ' ' and s != -1 and n is "none"
        n = str.substr s, i - s
        continue
      if str[i] is ">"
        e = i
        if n is "none"
          n = str.substr s, e - s
        break
    return { "start" : s, "end" : e , "type" : t, "name" : n}

  createIntro = (str) ->
    tags = []
    saveStr = str
    while true
      # console.log str
      { start, end, type, name } = findTag(str)
      # console.log start, end, type, name
      # not found
      if start == -1
        break

      # unclosed
      if end == -1
        if str[start - 1] is '/'
          saveStr = saveStr.substr 0, saveStr.length - (str.length - start  + 2)
        else
          saveStr = saveStr.substr 0, saveStr.length - (str.length - start  + 1)
        break

      if type is 'end'
        while tags.length > 0
          tag = tags.pop()
          if tag is name
            break
      else
        tags.push name
      str = str.substr end + 1

    for t in tags.reverse()
      saveStr += "</" + t + ">"
    return saveStr

  class HtmlPage extends env.plugins.Page

    constructor: (@filepath, @metadata, @result) ->

    getHtml: (base=env.config.baseUrl) ->
      rv = @result.replace /( src=("|')?)(file:)?..\/..\//g, '$1/'
      return rv

    getIntro: (base) ->
      html = @getHtml(base)
      tt_len = html.length
      if tt_len < options.introSize
        return html
      intro = html.substr 0, options.introSize
      # if @filepath.relative is "articles\\Perl\\2013-01-09-perl-array-unique.html"
      #   console.log intro
      if intro[options.introSize - 1] is '<'
        intro = intro.substr 0, options.introSize - 1
      return createIntro intro

  HtmlPage.fromFile = (filepath, callback) ->
    async.waterfall [
      (callback) ->
        fs.readFile filepath.full, callback
      (buffer, callback) ->
        HtmlPage.extractMetadata buffer.toString(), callback
      (result, callback) =>
        {html, metadata} = result
        page = new this filepath, metadata, html
        callback null, page
    ], callback

  HtmlPage.extractMetadata = (content, callback) ->
    parseMetadata = (source, callback) ->
      return callback(null, {}) unless source.length > 0
      try
        callback null, yaml.load(source) or {}
      catch error
        if error.problem? and error.problemMark?
          lines = error.problemMark.buffer.split '\n'
          markerPad = (' ' for [0...error.problemMark.column]).join('')
          error.message = """YAML: #{ error.problem }

              #{ lines[error.problemMark.line] }
              #{ markerPad }^

          """
        else
          error.message = "YAML Parsing error #{ error.message }"
        callback error

    # split metadata and html content
    metadata = ''
    html = content

    if content[0...3] is '---'
      # "Front Matter"
      result = content.match /^-{3,}\s([\s\S]*?)-{3,}(\s[\s\S]*|\s?)$/
      if result?.length is 3
        metadata = result[1]
        html = result[2]
    else if content[0...12] is '```metadata\n'
      # "Winter Matter"
      end = content.indexOf '\n```\n'
      if end isnt -1
        metadata = content.substring 12, end
        html = content.substring end + 5

    async.parallel
      metadata: (callback) ->
        parseMetadata metadata, callback
      html: (callback) ->
        callback null, html
    , callback

  # register the plugins
  env.registerContentPlugin 'pages', '**/*.*(html|htm)', HtmlPage

  # done!
  callback()
