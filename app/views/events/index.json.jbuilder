json.array!(@events) do |event|
  json.extract! event, :id, :name, :time, :host, :desc, :people, :price, :uid, :start_date, :adr, :event_url
  json.url event_url(event, format: :json)
end
