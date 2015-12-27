class UqamSite::Etl::Download < Pipeline
  include Capybara::DSL

  delegate :raw_page_path, :website, to: :input

  def execute
    download unless File.exist?(raw_page_path)
    raw_page_path
  end

  private

  def input
    OpenStruct.new(super)
  end

  def download
    setup
    visit website
    open_links
    create_folder
    save_page raw_page_path
  end

  def setup
    Capybara.register_driver(:chrome) { |app| Capybara::Selenium::Driver.new(app, browser: :chrome) }
    Capybara.run_server = true
    Capybara.default_selector = :css
    Capybara.default_driver = :chrome
    Capybara.javascript_driver  = :chrome
  end

  def open_links
    all('.liste > li > a[onclick]').each { |link| link.click; sleep(0.1) }
  end

  def create_folder
    FileUtils.mkdir_p(folder_path)
  end

  def folder_path
    File.dirname(raw_page_path)
  end
end
