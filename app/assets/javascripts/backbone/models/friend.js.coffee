class FirstProject.Models.Friend extends Backbone.Model
  paramRoot: 'friend'

  follow: (tr)->
    @changeFreindship 'follow', tr
    return

  unfollow: (tr)->
    @changeFreindship 'unfollow', tr
    return

  changeFreindship: (url, td)->
    $.post(
      '/users/' + url
      this.toJSON()
      (data) ->
        $(td).hide(
          duration: 200
          complete: ->
            $(td).siblings(':hidden').show(duration: 200)
        )
      'json'
    )
    return


class FirstProject.Collections.FriendsCollection extends Backbone.Collection
  model: FirstProject.Models.Friend
  url: '/users/friends'
