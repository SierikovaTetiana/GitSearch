# 🔍 GitHub Search public repositories App
 GIT search repositories. Swift 5. Xcode 13.3. iOS 15.
 <br />
 <br />LAYOUTS CREATED IN CODE (UIKIT)
 <br />NAVIGATION WITH COORDINATOR PATTERN
 <br />VIEWCONTROLLERS STACK WITH UINAVIGATIONCONTROLLER

## 📷 Screenshots
![repoSearch](https://user-images.githubusercontent.com/75028505/169700624-a24ed9f0-1cf0-4544-91c2-6bf69aa2f210.jpg)

## 🔖 Features: 
### 📲 First screen
  - On the first screen to avoid API limitation user can provide GitHub personal access token, otherwise app makes unauthenticated requests.
  - Popular repositories are shown on the main screen after downloading the app. 
  - On the top part of the screen, user’ll find an input that’ll allow him to set up a search query. 
  - Every element on the list contain: Repository name, Picture of the owner, Number of repository stars
  - Clicking on the element take user to the second screen.
  - App implements infinite scrolling
### 📲 Second screen
  - Second screen shows repo details: Repository owner’s name, Repository name, Number of repository stars
  - The list contains 3 last repository commits with info about the author's name and e-mail address as well as the message describing this commit.
  - The “VIEW ONLINE” button opens a browser to an address leading to the repository.
  - The “Share Repo” button allows sharing the repository name with the URL address leading to the repository.

## ⚠️ Before starting..
You can use this app like an unauthenticated user. But for better results without errors, to avoid API limitation
[create a personal access token.](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) 
