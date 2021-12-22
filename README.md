# Proximity AQI

## AQIListViewController : `AQIListViewModelDelegate`

1. Displays list of Cities with their latest AQI.
2. Shows AQI color coded with band they belong to.
3. Shows an arrow (Up green or down red) based on AQI band improvement or deterioration
4. Tapping on a city shows a graph of city with realtime AQI (10 sec interval)
5. Conforms to `AQIListViewModelDelegate`. Its implemented method is called when there is some data change event

## AQIListViewController.ViewModel
1. Conforms to `AQIListViewModel` which exposes methods called on by `AQIListViewController`
2. `AQIService` (protocol) is passed in initializer & contains method to open web socket connection & start receiving messages
3. `AQIListRouter` (protocol) is also passed in innitializer whose job is to display appropriate viewController on certain events
4. Keeps history of City's AQI 

## AQIListViewController.Router
1. Conforms to `AQIListRouter`.
2. Takes care of routing. (Displaying different screens)

## CityAQIGraphViewController 
1. Conforms to `CityAQIHistoryViewModelDelegate`. Method is called when data changes.
2. Displays a realtime graph of city's AQI at 30 sec interval

## CityAQIGraphViewController.ViewModel
1. Conforms to `CityAQIGraphViewModel` which provies updates to `CityAQIGraphViewController` allowing it to refresh graph
2. `AQIService` (protocol) is passed in initializer & contains method to open web socket connection & start receiving messages.
3. Corelogic dictates that graph is updated every `n` seconds (10 right now). So for every update between `n` & `n+1` second only the last update is considered. A timer is initialized which processes all AQI's in past 2 minutes & segreagates AQI update in `n` second interval.

## APICliet
1. Conforms to `AQIService`. Provies websocket connection & completion handler for receiving messages.

### PS:
Unfortunately I didn't have time to do this better. There are still lot of changes (UI & logic), unit tests remaining I would have liked to have done. I can see some bugs as well. I have only done a single commit which is unlike I would gave done during work.