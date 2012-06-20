$ ->
  maxHeight = $('.box').outerHeight true
  $('.box').on 'mouseenter', ->
    box = $(this)
    box.css
      'border-color': '#333'
      'height': maxHeight
    box.find('.icon').css
        'margin-top': '20px'
  $('.box').on 'mouseleave', ->
    box = $(this)
    box.css
        'border-color': '#dfdfdf'
        'height': '40px'
    box.find('.icon').css
        'margin-top': '4px'
  $('.box').trigger 'mouseleave'
