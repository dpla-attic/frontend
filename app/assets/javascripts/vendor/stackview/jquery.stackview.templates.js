(function(undefined) {
	StackView.templates = {
		scaffold: '\
			<div class="ribbon"><%= ribbon %></div>\
			<ul class="stack-items" />',

		navigation: '\
			<div class="stack-navigation<%= empty ? " empty" : ""%>">\
				<div class="upstream">Up</div>\
				<div class="num-found">\
					<span></span><br />items\
				</div>\
				<div class="downstream">Down</div>\
			</div>',

		empty: '<li class="stack-item-empty"><%= message %></li>',

		placeholder: '<li class="stackview-placeholder"></li>'
	}
})();