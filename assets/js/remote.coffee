#= require vendor/jquery-1.7.2.min
#= require vendor/modernizr-touch
#= require vendor/jquery.countdown.pack

$(document).ready(() ->
    socket = io.connect('/remote')
    socket.on('alreadyConnected', () ->
        $('#msg').text('Remote already connected')
    )
    
    next = () ->
        socket.emit('next')
        
    previous = () ->
        socket.emit('previous')
        
    clickEventType = if Modernizr.touch? then 'touchstart' else 'click'
    
    $('#next').bind(clickEventType, next)
    
    $('#previous').bind(clickEventType, previous)
    
    timerLabel = undefined
    
    $('#start').toggle(() ->
        timerLabel = $(this).text()
        $(this).countdown({since: new Date(), compact: true, format: 'HMS'})
    ,
    () ->
        $(this).countdown('destroy').text(timerLabel)
    )
)