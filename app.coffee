fs = require('fs')
ntwitter = require('ntwitter')

config = require('config')

twit = new ntwitter(config)

# http://boundingbox.klokantech.com/
salt_lake_city = "-112.0974710082,40.4743797656,-111.7547399906,40.8163925608"

twit.stream 'statuses/filter', {'locations': salt_lake_city}, (stream)->
    stream.on 'data', (data)->

        try

            csv_string = [
                data.created_at
                data.id
                data.user.id
                data.user.followers_count
                data.user.friends_count
                data.user.listed_count
                data.user.favourites_count
                data.user.statuses_count
                data.retweet_count
                data.geo.coordinates[0] # latitude
                data.geo.coordinates[1] # longitude
            ].join(',')

            console.log '---'
            console.log 'data', data.user.screen_name, data.text, csv_string

            fs.appendFile "#{__dirname}/twitter_data.csv", csv_string + '\n', (err)->
                console.log('error appending to csv', err) if err

            fs.appendFile "#{__dirname}/twitter_data.json", JSON.stringify(data) + '\n', (err)->
                console.log('error appending to json', err) if err

        catch e
            console.log 'try error', e, data.geo, data.coordinates

    stream.on 'end', (response)->
        console.log 'end', response

    stream.on 'error', (response, code)->
        console.log 'error', response, code

    stream.on 'destroy', (response)->
        console.log 'destroy', response

    stream.on 'close', (response)->
        console.log 'close', response
