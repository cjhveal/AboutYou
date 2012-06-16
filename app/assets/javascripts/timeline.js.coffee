window.Timeline = class Timeline

    constructor: (data) ->

        kudo.type = 'work' for kudo in data.work
        kudo.type = 'education' for kudo in data.education
        kudos = data.work.concat data.education

        box = $('<div class="box padfront"></div>')
        @wrap = $('<div id="timeline"></div>')
        @boxHash = kudos.map (kudo) => @decorateBoxNode box.clone(), kudo

    decorateBoxNode: (node, kudo) ->

        html = []

        if kudo.type is 'work'

            html.push "<img class='icon' src='http://static.ak.fbcdn.net/rsrc.php/v2/yE/r/4U1vSOqKlpj.png' />"
            html.push "<h1>Working at #{kudo.employer.name}</h1>" unless kudo.end_date
            html.push "<h1>Worked at #{kudo.employer.name}</h1>" if kudo.end_date

            html.push "<h2>#{kudo.start_date} - #{kudo.position.name}</h2>"
            html.push "<h2 class='bottom'>#{kudo.location.name}</h2>"

        else if kudo.type is 'education'

            html.push "<div class='cap icon'></div>"
            html.push "<h1>Graduated from #{kudo.school.name}</h1>"
            html.push "<h2 class='bottom'>#{kudo.year.name}</h2>" if kudo.year

        $('body').prepend @wrap
        node.append html.join ''
        node.appendTo @wrap
        maxHeight = node.outerHeight true
        console.log maxHeight
        node.remove()
        node.height(40)
        @wrap.remove()

        @giveJSGoodies node, maxHeight

        year: @getYear kudo
        node: node

    getYear: (kudo) ->

        date = kudo.start_date or kudo.year?.name
        date?.split('-')[0] or 0

    dumpNodesTo: (container) ->

        container.prepend @wrap

        sorted = @boxHash.sort (item1, item2) -> item1.year < item2.year

        lastYear = sorted[0].year
        for box in sorted
            if box.year and box.year isnt lastYear
                @wrap.append $("<div class='date'>#{box.year}</div>")
                lastYear = box.year
            @wrap.append box.node

    giveJSGoodies: (node, maxHeight) ->
        node.mouseenter ->
            node.css
                'border-color': '#333'
                'height': maxHeight

            node.find('.icon').css
                'margin-top': '20px'

        node.mouseleave ->
            node.css
                'border-color': '#dfdfdf'
                'height': '40px'

            node.find('.icon').css
                'margin-top': '4px'

testData =
    'work': [
        {
            'employer': {
                'id': '121841901176802'
                'name': 'Xtreme Labs'
            }, 
            'location': {
                'id': '110941395597405'
                'name': 'Toronto, Ontario'
            }, 
            'position': {
                'id': '144609565576376'
                'name': 'Agile Engineer'
            }, 
            'start_date': '2012-05'
            'end_date': '2012-09'
        },
        {
            'employer': {
                'id': '152361548143668'
                'name': 'Bookneto'
            }, 
            'location': {
                'id': '104045032964460'
                'name': 'Kitchener, Ontario'
            }, 
            'position': {
                'id': '109542932398298'
                'name': 'Software Engineer'
            }, 
            'start_date': '2011-09'
            'end_date': '2012-01'
        },
        {
            'employer': {
                'id': '107146985986320'
                'name': 'Nav Canada'
            }, 
            'location': {
                'id': '109870912368806'
                'name': 'Ottawa, Ontario'
            }, 
            'position': {
                'id': '139901252703261'
                'name': 'System Software Developer'
            }, 
            'start_date': '2011-01'
            'end_date': '2011-04'
        }]
    'education': [
        {
            'school': {
                'id': '108006165887469'
                'name': 'E.L. Crossley Secondary School'
            }, 
            'type': 'High School'
        }, 
        {
            'school': {
                'id': '103773232995164'
                'name': 'University of Waterloo'
            }, 
            'year': {
                'id': '143641425651920'
                'name': '2014'
            }, 
            'concentration': [
                {
                    'id': '104076956295773'
                    'name': 'Computer Science'
                }
            ],
            'type': 'College'
        }
    ]

window.timeline = new Timeline testData
timeline.dumpNodesTo $('#timeline-wrap')

