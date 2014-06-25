require 'colorize'
require 'table_print'

module Mosespa
  class Search
    def initialize(jira_client, config)
      @client = jira_client
      @named_search = config['named_search'] || {}
    end

    def search(search_string)
      real_search = @named_search[search_string] || search_string
      @issues = @client.Issue.jql(real_search).sort_by { |i| i.updated }
    end

    def print_search
      tp @issues,
        "key",
        {:updated => {:formatters => [DateColorFormatter.new]}},
        "status.name",
        "summary"
    end
  end

  class DateColorFormatter
    def format(value)
      date = Time.parse(value)
      now = Time.now
      two_weeks_ago = now - 14*86400
      one_month_ago = now - 30*86400

      c = if date > two_weeks_ago
            :green
          else if date > one_month_ago
            :yellow
          else
            :red
          end end
      date.strftime('%D').colorize( c )
    end
  end

end
