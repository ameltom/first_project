# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.FirstProject.changeFriendship = (isFollow, uid, btn) ->
    friend = window.router.friends.find (f)->
      f.get('uid') == uid

    friend[if isFollow then 'unfollow' else 'follow'] $(btn).parent()