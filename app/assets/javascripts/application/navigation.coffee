((window, document, undefined_) ->

  transformProp = window.Modernizr.prefixed("transform")
  transitionProp = window.Modernizr.prefixed("transition")
  transitionEnd = (->
    props =
      WebkitTransition: "webkitTransitionEnd"
      MozTransition: "transitionend"
      OTransition: "oTransitionEnd otransitionend"
      msTransition: "MSTransitionEnd"
      transition: "transitionend"

    (if props.hasOwnProperty(transitionProp) then props[transitionProp] else false)
  )()
  hasTT = transitionEnd and transitionProp and transitionProp

  window.Menu = (->
    _init = false
    menu = {}
    menu.init = ->
      return if _init
      _init         = true

      menu.win      = $(window)
      menu.docEl    = $(document.documentElement)
      menu.bodyEl   = $(document.body)
      menuLinkEl    = $("#menu-link")
      menuEl        = $("#sidebar")
      wrapEl        = $(".wrapper")
      maskEl        = $("#menu-mask")

      menu.docEl.addClass "js-ready js-" + ((if hasTT then "advanced" else "basic"))

      closeMenu = ->
        if hasTT
          menuEl.one transitionEnd, (e) ->
            menu.docEl.removeClass "js-offcanvas"
        else
          menu.docEl.removeClass "js-offcanvas"
        menu.docEl.removeClass "js-menu"

      openMenu = ->
        menu.docEl.addClass "js-offcanvas js-menu"

      menuLinkEl.on "click", (e) ->
        if menu.docEl.hasClass("js-menu")
          closeMenu()
        else
          openMenu()
        e.preventDefault()

      menuEl.on "click", "a.close", closeMenu

      maskEl.on "click", (e) ->
        if menu.docEl.hasClass("js-menu")
          closeMenu()

    menu
  )()

  $(document).ready ->
    Menu.init()

) window, window.document