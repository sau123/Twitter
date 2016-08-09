### Twitter

This is an example of how to implement an OAuth 1.0a Twitter API client. The Twitter API provides an application token that allows applications to make unauthenticated requests to their search API. It includes the following features :


User Stories

The following user stories are completed:
* [x] User can sign in using OAuth login flow
* [x] User can view last 20 tweets from their home timeline
* [x] The current signed in user will be persisted across restarts
* [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp. In other words, design the custom cell with the proper Auto Layout settings. You will also need to augment the model classes.
* [x] User can pull to refresh
* [x] User can compose a new tweet by tapping on a compose button.
* [x] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
* [x] Optional: When composing, you should have a countdown in the upper right for the tweet limit.
* [x] Optional: After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
* [x] Optional: Retweeting and favoriting should increment the retweet and favorite count.
* [x] Optional: User should be able to unretweet and unfavorite and should decrement the retweet and favorite count. Refer to this guide for help on implementing unretweeting.
* [x] Optional: Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
* [x] Optional: User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.


##Video Walkthrough
![](./Twitter.gif)

Second Part

The following user stories must be completed:

* [x] Hamburger menu
    * [x] Dragging anywhere in the view should reveal the menu.
    * [x] The menu should include links to your profile, the home timeline, and the mentions view.
    * [x] The menu can look similar to the menu below or feel free to take liberty with the UI.
* [x] Profile page
    * [x] Contains the user header view
    * [x] Contains a section with the users basic stats: # tweets, # following, # followers
    * [x] Shows the user timeline
* [x] Home Timeline
    * [x] Tapping on a user image should bring up that user's profile page


* Profile Page
    * [ ] Optional: Implement the paging view for the user description. (med)
    * [ ] Optional: As the paging view moves, increase the opacity of the background screen. See the actual Twitter app for this effect (med)
    * [ ] Optional: Pulling down the profile page should blur and resize the header image. (high)
* Account switching
    * [ ] Optional: Long press on tab bar to bring up Account view with animation (low)
    * [ ] Optional: Tap account to switch to (low)
    * [ ] Optional: Include a plus button to Add an Account (med)
    * [ ] Optional: Swipe to delete an account (med)

##Video Walkthrough
![](./Twitter1.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).

