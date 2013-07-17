class FirstProject.Routers.FriendsRouter extends Backbone.Router
  initialize: (options) ->
    @friends = new FirstProject.Collections.FriendsCollection()
    @friends.reset options.friends

  routes:
    index: 'index'

  index: ->
    @view = new FirstProject.Views.Friends.IndexView(friends: @friends)
    $("#friends").html(@view.render().el)