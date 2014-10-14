# @author Karl Sutt

class Juicer

  # @return [Juicer::Client] The HTTP client for making requests.
  attr_reader :client

  # Initialize the Juicer API client.
  #
  # @param api_key [String] API key obtained from Apigee.
  # @return [Juicer] The API client.
  #
  def initialize(api_key)
    @client = Juicer::Client.new(api_key)
  end

  # List sites.
  # @return [Array<String>] list of available sites.
  #
  def sites
    @client.request(:get, "sites")["sites"]
  end

  # List sections.
  # @return [Array<String>] list of available section.
  #
  def sections
    @client.request(:get, "sections")["sections"]
  end

  # List products.
  # @return [Array<String>] list of available products.
  #
  def products
    @client.request(:get, "products")["products"]
  end

  # List content formats.
  # @return [Array<String>] list of available content formats.
  #
  def formats
    @client.request(:get, "formats")["formats"]
  end

  # Filter/find articles.
  #
  # @note The results will include all entities of an article. Therefore, if
  #   there are many results, the amount of data transferred is quite large.
  #   Just a heads up when doing queries that potentially return a large number
  #   of results.
  #
  # @param opts [Hash] A Hash of filter options.
  #   Possible keys are:
  #
  #     * `text` - a search term, corresponds to Lucene syntax
  #     * `product` - list of products to scope to. See {#products}.
  #     * `content_format` - list of content formats to scope to. See {#formats}.
  #     * `section` - list of sections to scope to. See {#sections}.
  #     * `site` - list of sites to scope to. See {#sites}.
  #     * `published_after` - only retrieve articles published after a certain
  #       date. The format is `yyyy-mm-dd`.
  #     * `published_before` - only retrieve articles published before a certain
  #       date. The format is `yyyy-mm-dd`.
  # @return [Array<Hash>] list of articles.
  def articles(opts)
    @client.request(:get, "articles", opts)["articles"]
  end

  # Fetch an article by its CPS_ID
  #
  # @param cps_id [String] the cps_id of an article.
  # @return [Hash] the serialized article.
  #
  def article(cps_id)
    @client.request(:get, "articles/#{cps_id}")["article"]
  end

  # Fetch articles related (similar) to an article. Uses tf-idf algorithm to
  # find semantically similar documents.
  #
  # @param cps_id [String] the `cps_id` of an article.
  # @return [Array<Hash>] list of similar articles. Currently capped to 10 most
  #   similar.
  #
  def similar_articles(cps_id)
    @client.request(:get, "articles/#{cps_id}/similar")["results"]
  end

  # Fetch articles related (similar) to an arbitrary blob of text. Uses tf-idf
  # algorithm to find semantically similar documents.
  #
  # @param text [String] a blob of text.
  # @return [Array<Hash>] list of similar articles. Currently capped to 10 most
  #   similar.
  #
  def similar_to(text)
    body = { like_text: URI.encode(text) }.to_json
    @client.request(:post, "similar_to", {}, body)["results"]
  end
end
