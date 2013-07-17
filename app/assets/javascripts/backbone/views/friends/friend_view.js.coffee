FirstProject.Views.Friends ||= {}

class FirstProject.Views.Friends.FriendView extends Backbone.View
  template: JST["backbone/templates/friends/friend"]

  events:
    "click .destroy" : "destroy"

  tagName: "tr"

  destroy: () ->
    @model.destroy()
    this.remove()

    return false

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
