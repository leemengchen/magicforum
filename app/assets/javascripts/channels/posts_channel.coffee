postsChannelFunctions = () ->

  checkMe = (comment_id) ->
    if $('meta[name=wizardwonka]').length < 1
      $(".comment-child[data-id=#{comment_id}] .control-panel").remove()
    $(".comment-child[data-id=#{comment_id}]").removeClass("hidden")

  if $('.comments-parent').length > 0
    App.posts_channel = App.cable.subscriptions.create {
      channel: "PostsChannel"
    },
    connected: () ->
      console.log("user logged in");

    disconnected: () ->
      console.log("user logged out");


    received: (data) ->
      console.log(data);
      if $('.comments-parent').data().id 
        $('#comments').append(data.partial)
        checkMe(data.comment.id)

$(document).on 'turbolinks:load', postsChannelFunctions
