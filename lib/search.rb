require 'colorize'

module Mosespa
  class Search
    def initialize(jira_client, config)
      @client = jira_client
      @named_search = config['named_search'] || {}
    end

    def search(search_string)
      real_search = @named_search[search_string] || search_string
      @issues = @client.Issue.jql(real_search)
    end

    def print_search
      @issues.each do |ticket|
        color = color_for_update(ticket.updated)
        $stdout.puts "#{ticket.key} #{ticket.updated} #{ticket.status.name} #{ticket.summary}".colorize(color)
      end
    end

    def color_for_update(date)
      :green
    end
  end
end
