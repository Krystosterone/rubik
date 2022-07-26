# frozen_string_literal: true

module FaqsHelper
  def avatar_url(contributor, size:)
    uri = URI.parse(contributor.profile_image_url)
    uri.query = URI.encode_www_form(
      URI.decode_www_form(uri.query || "") << ["s", size]
    )
    uri.to_s
  end
end
