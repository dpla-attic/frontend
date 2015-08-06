module Errors
  ##
  # Exception representing a higher-than-allowed page number having been
  # requested
  class PageLimitError < StandardError; end
end
