(function($, window, undefined) {
	/*
	   Extend StackView defaults to include options for this item type.

	   max_height_percentage
	      Books with the maximum height will render as this percentage
	      width in the stack.

	   max_height
		    The maximum height in centimeters that an item will render as,
		    regardless of the true height of the item.

		 max_pages
		    The maximum number of pages that a book will render as,
		    regardless of the true number of pages.

		 min_height_percentage
		    Books with the minimum height will render as this percentage
		    width in the stack.

		 min_height
		    The minimum height in centimeters that an item will render as,
		    regardless of the true height of the item.

		 min_pages
		    The minimum number of pages that a book will render as,
		    regardless of the true number of pages.

		 page_multiple
		    A number that when multiplied by the number of pages in a book
		    gives us the total pixel height to be rendered.

		 selectors.book
		    Item selector specific to the book type.
	*/
	$.extend(true, window.StackView.defaults, {
		book: {
			max_height_percentage: 100,
			max_height: 30,
			max_pages: 270,
			min_height_percentage: 70,
			min_height: 15,
			min_pages: 100,
			page_multiple: 0.40
		},

		selectors: {
			book: '.stack-book'
		}
	});

	/*
	   #translate(number, number, number, number, number) - Private

	   Takes a value (the first argument) and two ranges of numbers. Translates
	   this value from the first range to the second range.  E.g.:

	   translate(0, 0, 10, 50, 100) returns 50.
	   translate(10, 0, 10, 50, 100) returns 100.
	   translate(5, 0, 10, 50, 100) returns 75.

	   http://stackoverflow.com/questions/1969240/mapping-a-range-of-values-to-another
	*/
	var translate = function(value, start_min, start_max, end_min, end_max) {
		var start_range = start_max - start_min,
		    end_range = end_max - end_min,
		    scale = (value - start_min) / (start_range);

		return end_min + scale * end_range;
	};

	/*
	   #get_height(StackView, object) - Private

	   Takes a StackView options object and a book object. Returns a
	   normalized book height percentage, taking into account the minimum
	   height, maximum height, height multiple, and translating them onto
	   the percentage range specified in the stack options.
	*/
	var get_height = function(options, book) {
		var min = options.book.min_height,
		    max = options.book.max_height,
		    height = book.sourceResource.extent;

		if (height) {
			height = height[0].replace(/\W/g, '').match(/([0-9])+(?=( )*cm)/);
		}
		height = height ? height[0] : (max + min) / 2;
		height = Math.min(Math.max(height, min), max);
		height = translate(
			height,
			options.book.min_height,
			options.book.max_height,
			options.book.min_height_percentage,
			options.book.max_height_percentage
		);
		return height + '%';
	};

	/*
	   #get_thickness(StackView, object) - Private

	   Takes a StackView instance and a book object. Returns a normalized
	   book thickness using the number of book pages, taking into account
	   the minimum pages, maximum pages, and pages multiple.
	*/
	var get_thickness = function(options, book) {
		var min = options.book.min_pages,
		    max = options.book.max_pages,
		    multiple = options.book.page_multiple,
		    thickness = book.sourceResource.extent;

		if (thickness) {
			thickness = thickness[0].replace(/\W/g, '').match(/([0-9])+(?=( )*p)/)
		}
		thickness = thickness ? thickness[0] : min;
		thickness = Math.floor(Math.min(Math.max(thickness, min), max) * multiple);
		return thickness + 'px';
	};

	/*
	   #get_author(object) - Private

	   Takes an item and returns the item's author, taking the first
	   author if an array of authors is defined.
	*/
	var get_author = function(item) {
		var author = item.creator && item.creator.length ? item.creator[0] : '';

		if(/^([^,]*)/.test(author)) {
			author = author.match(/^[^,]*/);
		}

		return author;
	};

	/*
	   #parse_year(object) - Private

	   Takes an item and returns the item's display year.
	*/
	var parse_year = function(item) {
		var year = item.sourceResource.date

		if (year) {
			year = year.displayDate;
			_.each(['/', ' '], function(splitChar) {
				year = year.split(splitChar);
				year = year[year.length - 1];
			});
			year = parseInt(year, 10);
		}

		return year;
	};


	/*
	   #get_heat(object) - Private

	   Takes an item and returns a heat number based on Lucene relevance.
	*/
	var get_heat = function(score) {
		return Math.round(Math.max(1, Math.min(score, 10)));
	};


	/*
	   Book type definition.
	*/
	window.StackView.register_type({
		name: 'book',

		match: function(item) {
			return (item.format && item.format === 'book') || !item.format;
		},

		adapter: function(item, options) {
			return {
				heat: get_heat(item.score),
				book_height: get_height(options, item),
				book_thickness: get_thickness(options, item),
				title: item.sourceResource.title,
				author: item.sourceResource.creator,
				year: parse_year(item),
				id: item.id
			};
		},

		template: '\
			<li class="stack-item stack-book heat<%= heat %>" style="width:<%= book_height %>; height:<%= book_thickness %>;">\
				<a class="stack-item-link" href="#<%= id %>" title="<%= _.compact([title, author, year]).join(\', \') %>">\
					<span class="spine-text">\
						<span class="spine-title"><%= title %></span>\
						<span class="spine-author"><%= author %></span>\
					</span>\
					<% if (year) { %><span class="spine-year"><%= year %></span><% } %>\
					<span class="stack-pages" />\
					<span class="stack-cover" />\
				</a>\
			</li>'
	});
})(jQuery, window);