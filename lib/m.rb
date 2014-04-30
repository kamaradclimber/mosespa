require 'thread'
require 'colorize'
require 'tempfile'

module Mosespa
  class Mosespa
    def show(ticket, json, verbose, colorize)
      p = Puts.new(colorize)
      if json
        puts ticket.to_json
      else
        puts "#{ticket.key} (#{ticket.status.name}) #{ticket.summary}"
        if verbose
          puts ticket.summary
          ticket.comments.each do |c|
            p.puts(c.author['name'], c.body)
          end
        end
      end
    end

    def browse(url)
      `#{ENV['BROWSER']} #{url}`
    end

    def comment(ticket, comment)
      c = ticket.comments.build
      c.save({'body' => comment})
    end

    def create(client, project, summary, description)
      file = Tempfile.new('mosespa')
      need_external_editor = summary.nil?
      if need_external_editor
        task_type, summary, description = create_get_options(file, project,'Task' ,summary, description)
        $stderr.puts "Ticket type was: #{task_type}"
        $stderr.puts "Summary was: #{summary}"
      end
      fail "Won't create a ticket without summary" if summary.nil? or summary.empty?
      t = client.Issue.build
      request = {'summary' => summary, 'description' => description, 'project' => {'key' => project.key}, 'issuetype' => {'name'=> task_type || 'Task'} }
      begin
      resp = t.save!({'fields' =>request})
      rescue Exception => e
        $stderr.puts "Error while creating your ticket"
        $stderr.puts "Your ticket information was saved in #{file.path}" if need_external_editor
        raise e
      end
      puts "Created #{t.key}"
      file.unlink
    end

    def create_get_options(file, project, task_type, summary, description)
      file.write(summary || "Task:")
      file.write("\n")
      file.write("\n")
      file.write(description ||"")
      file.write("\n")
      file.write("# Here you can edit the ticket you want to create\n")
      file.write("# Line starting with a # will be ignored\n")
      file.write("# The format is the same as a git commit\n")
      file.write("\n")
      file.write("# Summary line follows this template : [TaskType]: [Title]\n")
      file.write("# This means that if you write: Story: Create a prototype of SOA\n")
      file.write("# You'll get a new story about creating a SOA prototype")
      file.write("# The summary line is always followed by an empty line and may be followed by a description")
      file.write("\n\n")
      file.write("# /* vim: set filetype=gitcommit : */")
      file.close #need to flush
      file.open
      system "$EDITOR #{file.path}"
      all = file.read.lines.reject {|l| l.start_with? "#"}.map {|l| l.chop}
      summary = all[0]
      m = /^(\w+):(.*)/.match(summary)
      task_type, summary = m.to_a.drop(1) if m

      description = all.drop(2).join("\n")
      $stderr.puts "Type: #{task_type}"
      $stderr.puts "summary: #{summary}"
      $stderr.puts "description: #{description}"
      file.close
      [task_type, summary, description]
    end
  end


  class Puts
    def initialize(colorize)
      @colorize = colorize
      @colors = Hash.new
      @available_colors = Queue.new
      String.colors
      .select{ |c| not [:black, :light_black, :white].include? c}
      .each { |c| @available_colors.push c }
    end

    def puts(author, text)
      if @colorize
        unless @colors.has_key? author
          a_color = @available_colors.pop
          @colors[author] = a_color
        end
        c = @colors[author]
        author = author.colorize( c )
      end
      $stdout.puts "#{author}: #{text}"
    end
  end
end
