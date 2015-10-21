json.array!(@logs) do |log|
  json.extract! log, :id, :title, :raw_data
  json.url log_url(log, format: :json)
end
