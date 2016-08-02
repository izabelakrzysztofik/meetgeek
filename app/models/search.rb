class Search < ActiveRecord::Base

	def search_events

		events = Event.all

		events = events.where(["name LIKE ?","%#{tags}%"]) if tags.present?
		events = events.where(["start_date = ?", start_date]) if start_date.present?
		events = events.where(["address = ?", address]) if address.present?
		events = events.where(["price = ?", price]) if price.present?

		return events
	end
end
