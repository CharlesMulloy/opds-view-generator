require_relative '../lib/opds-view-generator.rb'
require 'test/unit'

class TestOpdsViewGenerator < Test::Unit::TestCase
  def setup; end

  def teardown
    ## Nothing really
  end

  def test_book_class_no_arguments
    book = BookEntry.new
    assert_equal(book.title, nil)
    assert_equal(book.author, nil)
    assert_equal(book.description, nil)

    book.title = 'Book title'
    book.author = 'Author'
    book.description = 'A fake book.'

    assert_equal(book.title, 'Book title')
    assert_equal(book.author, 'Author')
    assert_equal(book.description, 'A fake book.')
  end

  def test_book_class_with_arguments
    book = BookEntry.new(title: 'This is a title', author: 'Some author', description: 'The book of pages.')
    assert_equal(book.title, 'This is a title')
    assert_equal(book.author, 'Some author')
    assert_equal(book.description, 'The book of pages.')
  end

  def test_file_entry_with_mimetype
    file = FileEntry.new(path: 'path/to/file.epub', mimetype: 'application/epub+zip.mock')
    assert_equal(file.path, 'path/to/file.epub')
    assert_equal(file.mimetype, 'application/epub+zip.mock')
  end

  def test_file_entry_without_mimetype
    file = FileEntry.new(path: 'path/to/file.epub')
    assert_equal(file.path, 'path/to/file.epub')
    assert_equal(file.mimetype, 'application/epub+zip')
  end

  def test_book_entry_add_file
    book = BookEntry.new
    assert_equal(book.files.length, 0)
    book.add_file(FileEntry.new(path: 'path/to/file'))
    assert_not_equal(book.files.length, 0)
  end

  def test_navigation_list_with_arguments
    nav_list = NavigationEntry.new(title: 'Navigation Title', content: 'Sample Content', link: 'the/path.atom')
    assert_equal(nav_list.title, 'Navigation Title')
    assert_equal(nav_list.content, 'Sample Content')
    assert_equal(nav_list.link, 'the/path.atom')
  end

  def test_navigation_list_without_arguments
    nav_list = NavigationEntry.new
    assert_not_equal(nav_list.title, 'Navigation Title')
    assert_not_equal(nav_list.content, 'Sample Content')
    assert_not_equal(nav_list.link, 'the/path.atom')
    nav_list.title = 'Navigation Title'
    nav_list.content = 'Sample Content'
    nav_list.link = 'the/path.atom'
    assert_equal(nav_list.title, 'Navigation Title')
    assert_equal(nav_list.content, 'Sample Content')
    assert_equal(nav_list.link, 'the/path.atom')
  end

  def test_generating_root
    root = RootList.new
    root.title = 'test title'
    root.author = 'Charles Mulloy'
    assert_true(root.to_s.include?('<title>test title</title'))
  end

  def test_generating_root_with_nav_links
    root = RootList.new
    root.title = 'test title'
    root.author = 'Charles Mulloy'
    list1 = NavigationEntry.new(title: 'Title1', content: 'Title1 content', link: 'shelf1/list.xml')
    list2 = NavigationEntry.new(title: 'Title2', content: 'Title2 content', link: 'shelf2/list.xml')
    root.add_list_link list1
    root.add_list_link list2
  end

  def test_generating_root_with_acquisition_links
    root = RootList.new
    list1 = AcquisitionEntry.new(title: 'Title1', content: 'Title1 content', link: 'shelf1/list.xml')
    list2 = AcquisitionEntry.new(title: 'Title2', content: 'Title2 content', link: 'shelf2/list.xml')
    root.add_list_link list1
    root.add_list_link list2
  end

  def test_generating_acquisition_feed

    ac_list = AcquisitionList.new
    ac_list.title = "Test AcquisitionList"


  end

  def test_generating_acquisition_feed_with_entries
    ac_list = AcquisitionList.new
    ac_list.title = "Test AcquisitionList"
    book1 = BookEntry.new(title: "Book 1", author: "Author", description: "this is a desc")
    book1.add_file(FileEntry.new(path: "feed/123.epub"))
    ac_list.add_book book1
  end

  def test_generating_navigation_feed
    nav_list = NavigationList.new()
    nav_list.title = "Test nav list"

  end

  def test_generating_navigation_feed_with_entries
    nav_list = NavigationList.new()
    nav_list.title = "Test nav list"

    nav_entry1 = NavigationEntry.new(title: "Test title", content: "Test content", link: "path/to/feed1.xml")
    nav_list.add_link nav_entry1

    ac_entry1 = AcquisitionEntry.new(title: "Test title", content: "Test content", link: "path/to/feed2.xml")
    nav_list.add_link ac_entry1
  end
end
