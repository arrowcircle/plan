evil.block '@@tree',

  'click on @trigger': (e)->
    e.preventDefault()
    item = e.el.closest('[data-role=item]')
    
    if e.el.toggleClass('_open').hasClass('_open')
      $.get e.el.siblings('a').attr('href'), (html)->
        item.append(html)
        item.siblings('[data-role=item]').trigger('close') # дублируем строку для более синхронной работы
    else
      item.trigger('close')
      item.find('[data-role=subtree]').remove()
      item.siblings('[data-role=item]').trigger('close')

  'close on @item': (e)->
    e.el.find('[data-role=trigger]').removeClass('_open')
    e.el.find('[data-role=subtree]').remove()
