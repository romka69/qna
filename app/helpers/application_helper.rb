module ApplicationHelper
  def gist(url)
    gist = GistService.new(url)
    gist.content
  end
end
