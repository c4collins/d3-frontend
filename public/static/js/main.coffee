charts = {
    "Open Percentage": (data) ->
        open = parseInt(data.open)
        d3_data = [
            {"name": "Opened", "value": open.toString() },
            {"name": "Unopened", "value": (parseInt(data.sent) - open).toString() }
        ]
        width = 700
        height = 400
        radius = Math.min(width, height) / 2
        color = d3.scale.ordinal()
            .range ["#98abc5", "#8a89a6", "#7b6888", "#6b486b", "#a05d56", "#d0743c", "#ff8c00"]
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
                console.log("PATH FILL d")
                console.log(d)
                color parseInt d.data.value
        g.append "text"
            .attr "transform", (d) -> "translate(" + labelArc.centroid(d) + ")"
            .attr "dy", ".35em"
            .text (d) -> d.data.value + " " + d.data.name

}

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
                active: 0,
                heightStyle: 'content'
            }
        $ ".chart_selector"
            .click (e) =>
                chart_name = $(e.target).data "chart-name"
                thing = charts[chart_name](emailData)
                console.log thing
