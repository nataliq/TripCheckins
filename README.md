# TripCheckins - WIP 
Swift application that helps you create a "trip view" for your Swarm checkins for particular time interval.
It fetches all of your last Swarm checkins or the ckeckins for a specific time period (currently up to 250 because paging is not implemented).

I gave a talk about it at the [try!swift conference in New York](https://www.tryswift.co/events/2017/nyc/) and you can find the slides [here](https://github.com/nataliq/TripCheckins/blob/master/MVVM%20at%20scale%20@try!swift%20conference,%20NY,%202017.pdf)

# TODO
## Store trips
* Add a title field to the "Add trip" view
* Store trips (title & date filter) locally
* Add a view that shows a list of the locally saved trips

## Enhance the checkin list view
* Show text and photos (maybe collection view items)
* Add navigation to Swarm when a checkin item is tapped
* Handle errors
* Implement paging

## Improve the authorization
* Don't save the auth token locally
* Handle errors
