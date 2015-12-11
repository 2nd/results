'use strict'

# selector
window.$ = (src, sel) ->
  unless sel?
    sel = src
    src = document
  return src.querySelectorAll(sel)

window.$$ = (src, sel) -> $(src, sel)[0]

# event handler with optional delegation
EventTarget.prototype.on = (name, handler, delegate) ->
  @addEventListener name, (e) ->
    return true if delegate? && !e.target.matches(delegate)
    e.stopPropagation()
    handler(e)
    return false
  @

# extend NodeList with
Object.getOwnPropertyNames(Array.prototype).forEach (name) ->
  NodeList.prototype[name] = Array.prototype[name] unless name == 'length'
  null

# class helpers
Element.prototype.show = -> @style.display = 'block'; @
Element.prototype.hide = -> @style.display = 'none'; @
Element.prototype.toggle = -> if @style.display == 'block' then @hide() else @show()

# add class (+active), remove class (-active),
Element.prototype.classes = (cls, condition) ->
  if condition == true
    @classList.add(cls)
  else if condition == false
    @classList.remove(cls)
  else
    prefix = cls[0]
    cls = cls.substr(1)
    if prefix == '+'
      @classList.add(cls)
    else if prefix == '-'
      @classList.remove(cls)
    else if prefix == '!'
      @classList.toggle(cls)
  @
