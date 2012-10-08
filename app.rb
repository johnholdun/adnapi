require 'open-uri'

class App < Sinatra::Application
  get '/' do
    <<-form
      <form action="/status">
        <label for="url">URL</label>
        <input type="text" id="url" name="url">
        <button>Fetch</button>
      </form>
    form
  end
  
  get '/status' do
    result = nil
    
    doc = Nokogiri::HTML(open(params[:url])) rescue nil

    if doc
      user, status = doc.css("meta[name='description']").first.attributes['content'].value.split(': ', 2)
      # user = doc.css('span.username').first.text
      # status = doc.css('span.post-content').text
      
      result = { user: user, status: status }
    else
      result = { error: true, body: open(params[:url]).read }
    end
    
    [200, { 'Content-Type' => 'text/json' }, result.to_json]
  end
end
