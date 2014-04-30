module Mosespa
  class Search
    def initialize(jira_client, config)
      @client = jira_client
      @named_search = config['named_search'] || {}
    end

    def search(search_string)
      real_search = @named_search[search_string] || search_string
      @client.Issue.jql(real_search)
    end
  end
end
