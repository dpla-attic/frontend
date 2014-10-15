require 'spec_helper'

describe Item do

	it "returns valid String" do
		item = Item.new({
			'sourceResource' => {
				'description' => ['this is a', 'description'],
				'title' => ['title', 'subtitle'],
				'date' => [
					{ 
						'displayDate' => 'June 1st, 1901',
						'begin' => '1901-06-01'
					},
					{ 	
						'displayDate' => '08/08/1984',
						'begin' => '1984-08-08' 
					}
				],
				'creator' => ['jack', 'jill'],
			},
			'provider' => {
				'name' => 'The Provider'
			}
		})
		expect(item.description).to eq('this is a. description.')
		expect(item.title).to eq('title')
		expect(item.created_date).to eq('June 1st, 1901; 08/08/1984')
		expect(item.year).to eq('1901')
		expect(item.creator).to eq('jack; jill')
		expect(item.provider).to eq('The Provider')
	end

	it "returns nil or empty String for non-String values where String is expected" do
		item = Item.new({
			'sourceResource' => {
				'description' => [1],
				'title' => 2,
				'date' => {
					'displayDate' => {},
					'begin' => [2]
				},
				'creator' => {'a' => 'b'},
			},
			'provider' => {
				'name' => {}
			}
		})
		expect(item.description).to eq(nil)
		expect(item.title).to eq(nil)
		expect(item.created_date).to eq("")
		expect(item.year).to eq(nil)
		expect(item.creator).to eq(nil)
		expect(item.provider).to eq(nil)
	end

	it "returns valid Array of Strings" do
		item = Item.new({
			'sourceResource' => {
				'publisher' => ['publisher1', 'publisher2'],
				'rights' => 'rights statement',
				'title' => ['title', 'subtitle', 'another subtitle'],
				'spatial' => [
					{
						'name' => 'iowa city',
						'coordinates' => '123,456'
					},
					{
						'name' => 'iowa'
					}
				],
				'subject' => [
					{'name' => 'apples'},
					{'name' => 'bananas'}
				],
				'type' => 'text',
				'format' => ['format a', 'format b']
			},
			'rights' => 'edm rights 1',
			'hasView' => [
				{ 'edmRights' => 'edm rights 2' },
				{ 'edmRights' => 'edm rights 3' },
			]
		})
		expect(item.publisher).to eq(['publisher1', 'publisher2'])
		expect(item.titles).to eq(['subtitle', 'another subtitle'])
		expect(item.titles(:with_first => true)).to eq(['title', 'subtitle', 'another subtitle'])
		expect(item.rights).to eq(['rights statement'])
		expect(item.standardized_rights_statement).to eq(['edm rights 1', 'edm rights 2', 'edm rights 3'])
		expect(item.location).to eq(['iowa city', 'iowa'])
		expect(item.coordinates).to eq([['123', '456']])
		expect(item.subject).to eq(['apples', 'bananas'])
		expect(item.type).to eq(['text'])
		expect(item.format).to eq(['format a', 'format b'])
	end

	it "returns nil if Array contains non-String values" do
		item = Item.new({
			'sourceResource' => {
				'publisher' => ['publisher1', 1],
				'rights' => {:a => 'a'},
				'title' => [{}],
				'spatial' => [
					{'coordinates' => [1,2]}
				],
				'subject' => [
					{'name' => []}
				],
				'type' => [['text']],
				'format' => [{:a => 'a'}]
			},
			'rights' => 1
		})
		expect(item.publisher).to eq(nil)
		expect(item.rights).to eq(nil)
		expect(item.title).to eq(nil)
		expect(item.standardized_rights_statement).to eq(nil)
		expect(item.location).to eq(nil)
		expect(item.coordinates).to eq(nil)
		expect(item.subject).to eq(nil)
		expect(item.type).to eq(nil)
		expect(item.format).to eq(nil)
	end

	it "returns valid url" do
		item = Item.new({
			'isShownAt' => 'http://www.example.com',
			'object' => 'https://www.library.org'
		})
		expect(item.url).to eq('http://www.example.com')
	end

	it "returns nil for invalid url" do
		item = Item.new({
			'isShownAt' => 'example.com',
			'object' => 2
		})
		expect(item.url).to eq(nil)
	end

end