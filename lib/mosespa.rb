require 'thread'
require 'colorize'
require 'tempfile'

module Mosespa
  class Mosespa
    def show(ticket, json, verbose)
      p = Puts.new
      if json
        puts ticket.to_json
      else
        puts "#{ticket.key} #{ticket.summary}"
        if verbose
          puts ticket.summary
          ticket.comments.each do |c|
            p.puts(c.author['name'], c.body)
          end
        end
      end
    end

    def comment(ticket, comment)
      c = ticket.comments.build
      c.save({'body' => comment})
    end

    def create(client, project, summary, description)
      file = Tempfile.new('mosespa')
      need_external_editor = summary.nil?
      if need_external_editor
        summary, description = create_get_options(file, project, summary, description)
      end
      fail "Won't create a ticket without summary" if summary.nil?
      t = client.Issue.build
      request = {'summary' => summary, 'description' => description, 'project' => {'key' => project.key}, 'issuetype' => {'name'=> 'Task'} }
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

    def create_get_options(file, project, summary, description)
      file.write(summary || "")
      file.write("\n")
      file.write("\n")
      file.write(description ||"")
      file.write("\n")
      file.write("# Here you can edit the ticket you want to create\n")
      file.write("# Line starting with a # will be ignored\n")
      file.write("# The format is the same as a git commit\n")
      file.write("# /* vim: set filetype=gitcommit : */")
      file.close #need to flush
      file.open
      system "$EDITOR #{file.path}"
      all = file.read.lines.reject {|l| l.start_with? "#"}.map {|l| l.chop}
      summary = all[0]
      description = all.drop(2).join("\n")
      puts "summary: #{summary}"
      puts "description: #{description}"
      file.close
      [summary, description]
    end
  end


  class Puts
    def initialize()
      @colors = Hash.new
      @available_colors = Queue.new
      String.colors
      .select{ |c| not [:black, :light_black, :white].include? c}
      .each { |c| @available_colors.push c }
    end

    def puts(author, text)
      unless @colors.has_key? author
        a_color = @available_colors.pop
        @colors[author] = a_color
      end
      c = @colors[author]
      author = author.colorize( c )
      $stdout.puts "#{author}: #{text}"
    end
  end
end
