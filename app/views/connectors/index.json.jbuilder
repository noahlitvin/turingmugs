json.array!(@connectors) do |connector|
  json.extract! connector, :id, :channel, :mug_number, :user_number
  json.url connector_url(connector, format: :json)
end
