#= require vendor/jquery-1.7.2.min
#= require vendor/modernizr-touch
$(document).ready(() ->
    socket = io.connect('/vote')
    
    vote = (result) ->
        socket.emit('vote', {vote: result})
        $('#vote').fadeOut('fast', () ->
            $('#thanks').fadeIn('slow')
        )
        
    clickEventType = if Modernizr.touch? then 'touchstart' else 'click'
    
    $('#yes').bind(clickEventType, () ->
        vote('yes')
    )
    
    $('#no').bind(clickEventType, () ->
        vote('no')
    )
)