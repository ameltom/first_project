FirstProject.Views.Friends ||= {}

class FirstProject.Views.Friends.IndexView extends Backbone.View
  template: JST["backbone/templates/friends/index"]

  initialize: () ->
    @options.friends.bind('reset', @addAll)

  addAll: () =>
    @options.friends.each(@addOne)

  addOne: (friend) =>
    view = new FirstProject.Views.Friends.FriendView({model: friend})
    @$("tbody").append(view.render().el)

  render: =>
    $(@el).html(@template(friends: @options.friends.toJSON() ))
    @addAll()

    return this
