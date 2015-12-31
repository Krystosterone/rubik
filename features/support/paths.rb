module NavigationHelpers
  def path_to(page_name)
    case page_name
    when /trimestres/
      '/'
    end
  end
end

World(NavigationHelpers)
