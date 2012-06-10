# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  
  api_base_url = 'www.solarlistapi.com/'
  data2 = {}
  
  $('.step').hide()
  $('#step1').show()
  
  $('.step_button').on 'click', ->
    next_step = $(this).attr('data-step')
    console.log(next_step)
    $('.step').hide()
    $(next_step).show()
    false
  
  $('.get_calc_button').on 'click', ->
    # picked_mileage = $('input#miles_year').val()
    # picked_car = $('select#vehicle_type').val()
    # data = 
    #   
    # $.ajax
    #   type: 'POST'
    #   url: 'www.solarlistapi.com/api/vehicles'
    #   data: 
    getFinalData()
    false
    
  $('#driving_icons a').on 'click', ->
    img = $(this)
    miles = img.data('miles')
    $('#driving_icons a').removeClass('active')
    img.addClass('active')
    $('input#miles_year').val(miles)
    false

  $.getJSON 'http://www.solarlistapi.com/api/cars.json', (data) ->
    console.log(data)
    $(data).each (i, el) ->
      $('select#vehicle_type').append("<option value='#{el.id}'>#{el.car_model}</option>")
      
  getFinalData = ->
    $.getJSON 'http://www.solarlistapi.com/api/combinations/1111.json', (data) ->
      console.log(data)
      data2 = data
      buildChart4()
      
      
      
  buildChart4 = ->
    h = 270
    w = 470
    p = [10, 50, 15, 50]
    data_before = [data2.gas_costs_before, data2.electric_costs_before]
    data_after = data2.electric_costs_after
    console.log(data_before)
    console.log(data_after)
    barWidth = 16
    colors = ["green","blue"]
    y = d3.scale.linear().range([0,h - p[0] - p[2]])
    x = d3.scale.ordinal().rangeRoundBands([0,w - p[1] - p[3]])

    chart3 = d3.select('#graph_1')
      .append("svg:svg")
      .attr("height", h)
      .attr("width", w)
      .append("svg:g")
      .attr("transform", "translate(" + p[3] + "," + (h - p[2]) + ")")

    streams_data = []

    $.each data_before, (key, val) ->
      temp_a = []
      $.map data_before[key], (n,i) ->
        val = { x: i, y: n }
        temp_a.push(val)
      streams_data.push(temp_a)

    streams = d3.layout.stack()(streams_data)

    x.domain streams[0].map (d) -> d.x
    y.domain([0, d3.max(streams[streams.length - 1], (d) -> d.y0 + d.y)])

    stream = chart3.selectAll("g.stream")
      .data(streams)
      .enter().append("svg:g")
      .attr("fill",(d,i) -> colors[i])
      .style("stroke", "#333")

    rect = stream.selectAll("rect")
      .data(Object)
      .enter().append("svg:rect")
      .attr("x", (d) -> x(d.x))
      .attr("y", (d) -> -y(d.y0) - y(d.y))
      .attr("height", (d) -> y(d.y))
      .attr("width", x.rangeBand() - 1)

    label = chart3.selectAll("text")
      .data(x.domain())
      .enter()
      .append("svg:text")
      .attr("x", (d) -> x(d) + x.rangeBand()/2 )
      .attr("y", 5)
      .attr("text-anchor", "middle")
      .attr("dy", ".71em")
      .text((d,i) -> i + 1 )

    rule = chart3.selectAll("g.rule")
      .data(y.ticks(5))
      .enter()
      .append("svg:g")
      .attr("class", "rule")
      .attr("transform", (d) -> "translate(0,#{-y(d)})")

    rule.append("svg:line")
      .attr("x2", w - p[1] - p[3])
      .attr("stroke", (d) -> if d then "#fff" else "#000")
      .attr("stroke-opacity", (d) -> if d then .7 else null)

    rule.append("svg:text")
      .attr("x", w - p[1] - p[3] + 6)
      .attr("dy", ".35em")
      .text d3.format(",d")
  