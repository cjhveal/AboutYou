$ ->
  maxHeight = $('.box').outerHeight true
  $('.box').on 'mouseenter', ->
    box = $(this)
    box.css
      'border-color': '#333'
      'height': '120px'
    box.find('.icon').css
        'margin-top': '10px'
  $('.box').on 'mouseleave', ->
    box = $(this)
    box.css
        'border-color': '#dfdfdf'
        'height': '60px'
    box.find('.icon').css
        'margin-top': '4px'
  $('.box').trigger 'mouseleave'
