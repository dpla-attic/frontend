class BookshelfController < ApplicationController
  helper_method :permitted_params
  rescue_from Errors::PageLimitError, with: :render_503

  def show
    respond_to do |format|
      format.json do
        # Bookshelf gives a list of books.
        @search = Bookshelf.new *permitted_params.search
        @items = @search.result permitted_params.args
        render json: @items
      end
      format.html do
        # This Search gives facets for the navigation.
        @search = Search.new permitted_params.term, permitted_params.filters,
                             { spec_type: 'Book', page_size: 0 }
        render :show
      end
    end
  end

  private

    def permitted_params
      @permitted_params ||= PermittedParams.new(params)
    end

end
