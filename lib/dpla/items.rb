module DPLA
	class Items
		include HTTParty
		base_uri 'content1.qa.dp.la/api/v1'

		def find ids
			ids = ids.join ',' if ids.is_a? Array
			self.class.get '/items/' + ids.to_s
		end

		def where conditions
			self.class.get '/items', query: conditions
		end
	end
end