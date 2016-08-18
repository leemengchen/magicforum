votesChannelFunctions = () ->

    if $(".comments-parent").length > 0
      App.votes_channel = App.cable.subscriptions.create {
        channel: "VotesChannel"
      },
      connected: () ->

      disconnected: () ->

      received: (data) ->
        $(".comment-child[data-id=#{data.comment_id}] .votes-score").html(data.value)

$(document).on 'turbolinks:load', votesChannelFunctions
