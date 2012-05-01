express = require('express')
connectAssets = require('connect-assets')
fs = require('fs')
SocketIO = require('socket.io')

app = express.createServer()
io = SocketIO.listen(app, {
    'match origin protocol': true
})

app.use(express.static("#{__dirname}/static"))
app.use(connectAssets({build: false}))

app.set('view engine', 'jade')
app.set('view options', {
    layout: false
})

app.get('/', (req, res) ->
    res.render('index')
)

app.get('/remote', (req, res) ->
    res.render('remote')
)

app.get('/vote', (req, res) ->
    res.render('vote')
)

main = undefined
remote = undefined

io.of('/main')
    .on('connection', (socket) ->
        socket.on('disconnect', () ->
            console.log('main disconnected')
        )
        socket.on('bootRemotes', () ->
            io.of('/remote').clients()?.forEach((s) ->
                console.log('disconnecting remotes')
                s.disconnect()
            )
            remote = undefined
        )
    )

io.of('/remote')
    .on('connection', (socket) ->
        if !remote?
            remote = socket
            socket.on('next', () ->
                io.of('/main').emit('next')
            )
    
            socket.on('previous', () ->
                io.of('/main').emit('previous')
            )
        
            socket.on('disconnect', () ->
                console.log('remote disconnected')
                remote = undefined
            )
        else
            console.log('already a connection for remote')
            socket.emit('alreadyConnected')
    )

io.of('/vote')
    .on('connection', (socket) ->
        socket.on('vote', (result) ->
            switch result.vote
                when "yes" then io.of('/main').emit('yes')
                when "no"  then io.of('/main').emit('no')
                else console.log("bad vote: #{result}")
        )
    )


app.listen(3000)