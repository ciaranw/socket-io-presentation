#= require vendor/jquery-1.7.2.min
#= require vendor/highlight
#= require vendor/classList

$(document).ready(() ->
    
    query = {};
    location.search.replace( /[A-Z0-9]+?=(\w*)/gi, (a) ->
        query[ a.split( '=' ).shift() ] = a.split( '=' ).pop()
    )
    
    Reveal.initialize({
        controls: true,
        progress: true,
        history: true,
        mouseWheel: true,
        rollingLinks: true,
        theme: 'default',
        transition: 'concave'
    })

    hljs.initHighlightingOnLoad()
    
    socket = io.connect('/main')
    
    socket.emit('bootRemotes') if query.bootRemotes
    
    socket.on('next', () ->
        Reveal.navigateRight()
    )
    
    socket.on('previous', () ->
        Reveal.navigateLeft()
    )
    
    counts = {
        yes: 0,
        no: 0
    }
    incrementCount = (counter) ->
        counts[counter] = counts[counter] + 1
        $("#vote .#{counter} .count").text(counts[counter])
    
    socket.on('yes', () ->
        incrementCount('yes')
    )
    
    socket.on('no', () ->
        incrementCount('no')
    )
)