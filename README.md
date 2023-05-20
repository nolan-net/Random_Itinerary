Each collaborator began with their respective branch (named after each member's GitHub username) tasked with specific pages to implement. The final product will be placed here in the main branch. NOTE: Beefus, Working, and Bookmarks are sub-branches where we grouped to accomplish a specific task, 

Overview:
Our project is essentially a random itinerary generator. Which heavily relies on the use of the Google Places API to interact with location data and provide locations for users. The app randomly generates locations within a radius specified by the user from their current position. The user can also set filters for specific types of locations to appear. They can search for specific locations through the search bar at the top of the map page as well. Locations can be saved as bookmarks and act as a favorite spot for a user. A list of bookmarks can be created by the user as well and acts as a way to bundle favorite locations These bookmarks, Lists, as well as a user’s profile, are stored in our Firebase database. A user login page acts as a form of authentication where they can use their email and password to log in and or make a new account if need be. Once logged in and a user has saved some locations and made a list or two they can view their profile information at any time within the profile page.

How to use Random Itinerary:

Login:
The user is prompted to enter in an email and password at the login page. There is a remember me option that can be used to save the email address. If you do not have an existing account, you can create a new account by pressing the button below the login button. You will be prompted to enter a username, email, and password. After entering in the details, you must then hit create account and then press the back button to log in with your newly created account. 

Map Page:
If your account details are entered correctly, it will take you to the map page. There is a navigation bar on the bottom of the page denoting the different parts of the app. The app will then ask for location permissions. If you accept, the searches on the map will be based on your location, otherwise it will be based around Chico. The map page is the main part of this app. There is a radius slider from 0-50 miles and filters that you can apply to narrow your search. Finally you can choose an amount of markers on count to highlight with markers(Please do not try to query more than 5, our money is running dry :(). Finally after setting those parameters, you can hit the + button to generate your random itinerary markers. You can click on any marker produced and if you would like to add any to your bookmarks, just hit the textbox that contains the name and address. 

Bookmarks:
The next icon on the navigation bar is user bookmarks. Any locations saved on the map page are stored here. You can then create a list of places by checkmarking any combination of bookmarks and then finally hitting the checkmark button on the bottom. The user will be prompted to enter in a name for the list before saving. The saved list is then created and stored in firebase. 

Lists:
The next icon after bookmarks is the list page. This page contains saved lists that are created from the bookmarks page. You can tap on each list name to expand the list showing all location names in said list. 

Profile:
The profile page is the last icon and contains the user’s information. It should have your email and username. 


