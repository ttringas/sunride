# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  
  api_base_url = 'www.solarlistapi.com/'
  
  $('.step').hide()
  $('#step1').show()
  
  $('.step_button').on 'click', ->
    next_step = $(this).attr('data-step')
    console.log(next_step)
    $('.step').hide()
    $(next_step).show()
    false
    
  $('#driving_icons a').on 'click', ->
    miles = $(this).data('miles')
    $('input#miles_year').val(miles)
    false

  $.getJSON 'http://www.solarlistapi.com/api/cars.json', (data) ->
    console.log(data)
    $(data).each (i, el) ->
      $('select#vehicle_type').append("<option value='#{el.id}'>#{el.car_model}</option>")