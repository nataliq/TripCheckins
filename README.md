# TripCheckins - WIP

[![Build Status](https://travis-ci.org/nataliq/TripCheckins.svg?branch=master)](https://travis-ci.org/nataliq/TripCheckins)
 
Swift application that helps you create a "trip view" for your Swarm checkins for particular time interval.
It fetches all of your last Swarm checkins or the ckeckins for a specific time period (currently up to 250 because paging is not implemented).

I gave a talk about it at the [try!swift conference in New York](https://www.tryswift.co/events/2017/nyc/) and you can find the slides [here](https://www.slideshare.net/NataliyaPatsovska/mvvm-at-scale-not-so-simple-tryswift-nyc17)

# TODO
## Store trips
* ~~Add a title field to the "Add trip" view~~
* ~~Store trips (title & date filter) locally~~
* ~~Add a view that shows a list of the locally saved trips~~
* Add validation for the trip name and remove the default one

## Enhance the checkin list view
* Show text and photos (maybe collection view items)
* Add navigation to Swarm when a checkin item is tapped
* Handle errors
* Implement paging

## Improve the authorization
* Don't save the auth token locally
* Handle errors
