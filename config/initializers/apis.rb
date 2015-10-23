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
      Log.create(title: "Outbound message received.")
      if data.user != client.self['id'] and data['subtype'].blank?
        connector = Connector.find_by(channel: data.channel)
        if !connector
          client.message text: "I don't have a connector for the channel, so I didn't send this message along.", channel: data.channel
        elsif connector.user_number.blank?
          client.message text: "I don't have a user number associated with this channel, so I didn't send this message along.", channel: data.channel
        else
          message = TwilioClient.messages.create(
            from: connector.mug_number,
            to: connector.user_number,
            body: data.text
          )
          Log.create(title: "Text message sent.")
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