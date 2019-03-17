class GistService
  def initialize(url, client = default_client)
    id = find_id(url)
    call(client, id)
  end

  def content
    parse_content(@response)
    @content
  end

  private

  def find_id(url)
    url.split('/').last
  end

  def default_client
    Octokit::Client.new(access_token: ENV['GIST_TOKEN'])
  end

  def call(client, id)
    @response = client.gist(id)
  rescue Octokit::NotFound => @errors
  end

  def parse_content(response)
    if @errors.present?
      @content = 'Not found content in gist'
    else
      response[:files].map { |key, hash| @content = hash[:content] }
    end
  end
end
