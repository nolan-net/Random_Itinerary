## Random Itinerary: An Intuitive Random Travel Itinerary Generator

**Random Itinerary** intends to provide a spontaneous travel planning experience, leveraging the robust Google Places API to curate and present location data tailored to users' preferences. With options to create a spontaneous adventure or meticulously curate your favorite spots, our platform accommodates all sorts of travelers. Here's a comprehensive guide on how it's used.

---

### Features:

#### 1. **User Authentication**:
- **Login**: Input your email and password to access your account.
  - Utilize the `Remember Me` feature for quicker future logins.
- **New User Registration**: If you don’t have an account:
  1. Click on `Create New Account`.
  2. Fill in your desired username, email, and password.
  3. After registration, navigate back and login using your credentials.

#### 2. **Map Page**: 
- Upon successful login, you'll be navigated to the central element of our app.
- **Location Permissions**: Grant access for a personalized experience based on your current location. Declining will default the map to center around Chico.
- **Customizable Exploration**:
  1. Set your exploration radius (ranging from 0 to 50 miles).
  2. Apply filters to refine the type of locations presented.
  3. Specify the number of locations (we recommend up to 5 markers to maintain optimal performance and cost efficiency).
  4. Hit the `+` button, and your tailored random itinerary will populate on the map.
  5. For bookmarking any location, simply tap on the location's marker and then on its displayed name and address.

#### 3. **Bookmarks**: 
- View your curated list of saved locations.
- **Creating Lists**:
  1. Select desired locations via checkmarks.
  2. Click on the checkmark button below.
  3. Name your list, which will then be saved securely to our Firebase database.

#### 4. **Lists**:
- Access all your saved lists, giving you a compiled view of your favorite spots.
- Tap on a list name to view its constituent locations.

#### 5. **Profile**: 
- A snapshot of your account details, showcasing your email and username.

---

### Technical Note:
Our application's backend infrastructure relies on Firebase, ensuring data integrity, security, and seamless user experience. We also integrate with the Google Places API, providing accurate and expansive location data. If you plan on utilizing these methods, be mindful of the number of markers used and number of queries sent.
