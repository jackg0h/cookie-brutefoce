require 'mechanize'
def run
    found = "nope"
    key = "auth_token"
    url = "https://twitter.com"
    agent = Mechanize.new
    count = 0
    
    while found == "nope" do
        #value = SecureRandom.urlsafe_base64
        value = SecureRandom.hex(20)
        cookie = Mechanize::Cookie.new(key, value)
        cookie.domain = ".twitter.com"
        cookie.path = "/"
        agent.cookie_jar.add(cookie)
        page = agent.get(url) #Get the starting page
    
        #if link = page.link_with(:text => "Sign in") # As long as there is still a nextpage link...
        if link = page.link_with(:text => "Log in")
            agent.cookie_jar.clear!
        else 
            #print "authorize\n"
            found = "yes"
            open('token.txt', 'a') { |f|
                f.puts value
            }
        end
        count = count + 1
    end
    print count
end


puts "Started At #{Time.now}"
puts "Running..."
threads = (1..10).map do |i|
  Thread.new(i) do |i|
    run
  end
end

threads.each {|t| t.join}

puts "End at #{Time.now}"


