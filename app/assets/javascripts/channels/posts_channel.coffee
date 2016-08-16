postsChannelFunctions = () ->

  checkMe = (comment_id) ->
    if $('meta[name=admin]').length < 1
      $(".comment-child[data-id=#{comment_id}] .control-panel").remove()

  createComment = (data) ->
    console.log(data)
    if $('.comments-parent').data().id == data.post.id
      $('#comments').append(data.partial)
      checkMe(data.comment.id)

  updateComment =  (data) ->
    console.log(data)
    if $('.comments-parent').data().id == data.post.id
      $(".comment-child[data-id=#{data.comment.id}] ").replaceWith(data.partial)
      checkMe(data.comment.id)

  destroyComment = (data) ->
    console.log(data)
    $(".comment-child[data-id=#{data.comment.id}] ").remove()

  if $('.comments-parent').length > 0
    App.posts_channel = App.cable.subscriptions.create {
      channel: "PostsChannel"
    },
    connected: () ->
      console.log("user logged in");

    disconnected: () ->
      console.log("user logged out");

    received: (data) ->
      switch data.type
        when "create" then createComment(data)
        when "update" then updateComment(data)
        when "destroy" then destroyComment(data)

$(document).on 'turbolinks:load', postsChannelFunctions
