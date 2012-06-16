class Stream

    constructor: (node, username) ->



node = $('.stream').eq 0
username = 'mhluska'
stream = new Stream node, username
stream.getTweets()
