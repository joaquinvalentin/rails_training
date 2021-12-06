# frozen_string_literal: true

module Paginated
  def paginate(collection)
    collection = collection.page(params[:page])
    put_pagination_headers(collection)
    collection
  end

  def put_pagination_headers(collection)
    headers['X-total-pages'] = collection.total_pages
    headers['X-page'] = collection.current_page
    headers['X-per-page'] = collection.limit_value
    headers['X-total-entities'] = collection.total_count
  end
end
