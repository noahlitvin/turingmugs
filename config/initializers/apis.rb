TwilioClient = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']

module MugBot
  class App < SlackRubyBot::App
  end

  class Ping < SlackRubyBot::Commands::Base
    command 'ping' do |client, data, _match|
      client.message text: 'pong', channel: data.channel
    end
  end

  class Sender < SlackRubyBot::Commands::Base
    match /^*/ do |client, data, match|
      if data.user != client.self['id'] and data['subtype'].blank?
        connector = Connector.find_by(channel: data.channel)
        if !connector
          client.message text: "I don't have a connector for the channel, so I didn't send this message along.", channel: data.channel
        elsif connector.user_number.blank?
          client.message text: "I don't have a user number associated with this channel, so I didn't send this message along.", channel: data.channel
        elsif data.text and data.text.start_with?('-send')
          target_number = data.text.split(" ")[1]
          target_number = "+1" + target_number if target_number.length == 10
          text = data.text.split(" ").drop(2).join(" ")
          message = TwilioClient.messages.create(
            from: connector.mug_number,
            to: target_number,
            body: text
          )
          Log.create(title: "Text message sent.", raw_data: {to: target_number,from: connector.mug_number,body: text})
        else
          message = TwilioClient.messages.create(
            from: connector.mug_number,
            to: connector.user_number,
            body: data.text
          )
          Log.create(title: "Text message sent.", raw_data: {to: connector.user_number,from: connector.mug_number,body: data.text})
        end
      end
    end
  end

end

Mugbot = MugBot::App.instance

Thread.new do
  begin
    Mugbot.run
  rescue Exception => e
    STDERR.puts "ERROR: #{e}"
    STDERR.puts e.backtrace
    raise e
  end
end