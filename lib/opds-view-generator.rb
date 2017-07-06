require 'slim'

module Generator
  def render_root
    title = 'Application Title'
    Slim::Engine.options[:pretty] = true
    template = Slim::Template.new('lib/templates/root.slim').render(Object.new, title: title)
    puts template
  end
end

# Generates a string that represents the Root feed
class RootList
  attr_reader :links
  attr_accessor :title, :author, :updated, :self_link, :start

  def initialize
    @links = []
    @self_link = nil
    @start = nil
  end

  def to_s
    template = Slim::Template.new('lib/templates/root.slim')
      .render(Object.new, {title: title, links: links, self_link: self_link, start: start})
    write template
  end

  def add_list_link(nav)
    @links.push nav
  end
end

# Represents a list of books to be downloaded
class AcquisitionList
  attr_accessor :title, :id, :author, :entries

  def initialize
    @entries = []
  end

  def to_s
    template = Slim::Template.new('lib/templates/acquisition.slim').render(Object.new, title: title, entries: entries)
    write template
  end

  def add_book(book)
    entries.push book
  end
end

# Represents a list of links that lead to other navigation links
class NavigationList
  attr_accessor :title, :id, :author, :entries

  def initialize
    @entries = []
  end

  def to_s
    template = Slim::Template.new('lib/templates/navigation.slim').render(Object.new, title: title, entries: entries)
    write template
  end

  def add_link(link)
    entries.push link
  end
end

# Represents a entry that goes to a list of another navigation list or aquisition list
class NavigationEntry
  attr_accessor :title, :content, :link
  def initialize(title: nil, content: nil, link: nil)
    @title = title
    @content = content
    @link = link
  end
end

# Represents a entry that goes to a list of Book Entries
class AcquisitionEntry
  attr_accessor :title, :content, :link
  def initialize(title: nil, content: nil, link: nil)
    @title = title
    @content = content
    @link = link
  end
end

# Represents a certain book. Can represent multiple files per book.
class BookEntry
  attr_accessor :title, :author, :description, :id, :files

  def initialize(title: nil, author: nil, description: nil)
    @title = title
    @author = author
    @description = description
    @files = []
  end

  def add_file(file)
    @files.push(file)
  end
end

# Represents a single file for a book. Default mimetype is for epub.
class FileEntry
  attr_accessor :path, :mimetype
  def initialize(mimetype: nil, path: nil)
    @path = path
    @mimetype = if mimetype.nil?
                  'application/epub+zip'
                else
                  mimetype
                end
  end
end
