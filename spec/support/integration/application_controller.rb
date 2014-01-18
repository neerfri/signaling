class ApplicationController
  attr_accessor :params

  def process(action, params)
    self.params = params.with_indifferent_access
    send(action)
  end

  def redirect_to(path)
  end

  def render(template, options = {})
  end

  def item_list_path(item_list)
    "/item_lists/#{item_list.id}"
  end

  def item_lists_path
    "/item_lists"
  end
end
