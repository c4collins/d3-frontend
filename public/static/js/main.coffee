charts = {
    "Open Percentage": (data) ->
        open = parseInt(data.open)
        d3_data = [
            {"name": "Opened", "value": open.toString() },
            {"name": "Unopened", "value": (parseInt(data.sent) - open).toString() }
        ]
        pieChart(d3_data, "open-percent-chart")
    , "Bounce Percentage": (data) ->
        bounce = parseInt(data.bounce)
        d3_data = [
            {"name": "Bounced", "value": bounce.toString() },
            {"name": "Unbounced", "value": (parseInt(data.sent) - bounce).toString() }
        ]
        pieChart(d3_data, "bounce-percent-chart")
    , "Bounce & Open Percentage": (data) ->
        bounce = parseInt(data.bounce)
        open = parseInt(data.open)
        d3_data = [
            {"name": "Bounced", "value": bounce.toString() },
            {"name": "Opened", "value": open.toString() },
            {"name": "Unbounced & Unopened", "value": (parseInt(data.sent) - bounce - open).toString() }
        ]
        pieChart(d3_data, "open--bounce-percent-chart")
}

pieChart = (d3_data, svg_class, width=450, height=350, color_range=["#98abc5", "#8a89a6", "#7b6888", "#6b486b", "#a05d56", "#d0743c", "#ff8c00"]) ->
    radius = Math.min(width, height) / 2
    color = d3.scale.ordinal()
        .range color_range
    arc = d3.svg.arc()
        .outerRadius radius - 10
        .innerRadius 0
    labelArc = d3.svg.arc()
        .outerRadius radius - 40
        .innerRadius radius - 40
    pie = d3.layout.pie()
        .sort null
        .value (d3_data) -> return d3_data.value
    svg = d3.select "#chart-container"
        .append "svg"
        .attr "class", svg_class + "chart"
        .attr "width", width
        .attr "height", height
        .append "g"
        .attr "transform", "translate(" + width / 2 + "," + height / 2 + ")"
    g = svg.selectAll ".arc"
        .data pie d3_data 
        .enter()
        .append "g" 
        .attr "class", "arc"
    g.append "path"
        .attr "d", arc
        .style "fill", (d) ->
            color parseInt d.data.value
    g.append "text"
        .attr "transform", (d) -> "translate(" + labelArc.centroid(d) + ")"
        .attr "dy", ".75rem"
        .text (d) -> d.data.value + " " + d.data.name

reqListener = (e) ->
    JSON.parse this.responseText

$ document
    .ready () ->
        chartData = {}
        $.getJSON "chart_data.json", (json) ->
            console.log json
            chartData = json
        emailData = {}
        $.getJSON "email_data.json", (json) ->
            console.log json
            emailData = json

        $ "#accordion-menu"
            .accordion {
                active: 3,
                heightStyle: 'content'
            }
        $ ".chart_selector"
            .click (e) =>
                chart_name = $(e.target).data "chart-name"
                thing = charts[chart_name](emailData)
                console.log thing
