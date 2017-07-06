Opds-View-Generator
===================

This project aims to make it as easy as possible to generate atom feeds for the OPDS format which is used by many EReaders to make titles available in a clean and simple format. This design was adapted from the example catalog at [http://feedbooks.github.io/opds-test-catalog/](http://feedbooks.github.io/opds-test-catalog/), so an overwhelmingly large portion of the credit goes to them.

To create your own OPDS feeds, please see the examples below.

Generating a Root View.
---
The various pages are split up and can be put under three categories: root, navigation, and acquisition. The starting point is the root feed, what the end user will type into their client to access the catalog. Creating the root catalog is very simple...
```ruby
  require 'opds-view-generator'

  #create the object
  root = RootList.new

  #create a couple items in to include in the root's view
  nav_entry1 = NavigationEntry.new(title: 'Title1', content: 'Title1 content', link: 'shelf1/list.xml')
  nav_entry2 = NavigationEntry.new(title: 'Title2', content: 'Title2 content', link: 'shelf2/list.xml')

  #add said objects to the root.
  root.add_nav_link list1
  root.add_nav_link list2

  #print out the view. The RootList class uses a to_s method that evaluates to the end result.
  puts root
```

Which results in...

```xml
<feed xmlns="http://www.w3.org/2005/Atom" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:opds="http://opds-spec.org/2010/catalog" xmlns:opensearch="http://a9.com/-/spec/opensearch/1.1/" xmlns:thr="http://purl.org/syndication/thread/1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xml:lang="en">
   <title>test title</title>
   <updated>Today</updated>
   <author>
      <name>Charles Mulloy</name>
   </author>
   <entry>
      <title>Title1</title>
      <content>Title1 content</content>
      <link href="shelf1/list.xml" rel="subsection" type="application/atom+xml;profile=opds-catalog; kind=navigation"/>
   </entry>
   <entry>
      <title>Title2</title>
      <content>Title2 content</content>
      <link href="shelf2/list.xml" rel="subsection" type="application/atom+xml;profile=opds-catalog; kind=navigation"/>
   </entry>
</feed>```

Generating a Navigation View
---
The second kind of feed is the navigation feed. This contains entries that either point to another navigation feed or an Acquisition Feed. This kind is somewhat simple to to understand. An example is below.

```ruby
# Create the object
nav_list = NavigationList.new()

# Set a title for the list.
nav_list.title = "Test nav list"

# Creates a entry for the navigation list.
nav_entry1 = NavigationEntry.new(title: "Test title", content: "Test content", link: "path/to/feed.xml")

# Add the entry to the list.
nav_list.add_link nav_entry1

# See the result.
puts nav_list
```

Which gets you...

```xml
<feed xmlns="http://www.w3.org/2005/Atom" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:opds="http://opds-spec.org/2010/catalog" xmlns:opensearch="http://a9.com/-/spec/opensearch/1.1/" xmlns:thr="http://purl.org/syndication/thread/1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xml:lang="en">
   <title>Test nav list</title>
   <updated>Today</updated>
   <author>
      <name>Charles Mulloy</name>
   </author>
   <entry>
      <title>Test title</title>
      <content>Test content</content>
      <link href="path/to/feed1.xml" rel="subsection" type="application/atom+xml; profile=opds-catalog; kind=navigation"/>
   </entry>
   <entry>
      <title>Test title</title>
      <content>Test content</content>
      <link href="path/to/feed2.xml" rel="subsection" type="application/atom+xml; profile=opds-catalog; kind=acquisition"/>
   </entry>
</feed>
```

Generating an Acquisition View
---
The last type of view is the Acquisition View. This is what makes the books available to the user to download. Please keep in mind that neither Navigation views nor other Acquisition Views should be used in an Acquisition View, only book views.

```ruby
#Create the object.
ac_list = AcquisitionList.new

#set the title
ac_list.title = "Test AcquisitionList"

#Create a book.
book1 = BookEntry.new(title: "Book 1", author: "Author", description: "this is a desc")

#Add file to the book. Please note that unless a mimetype is specified, epub format is assumed, regardless of the file name.
book1.add_file(FileEntry.new(path: "feed/123.epub"))

#Add book to the list.
ac_list.add_book book1

#View the results.
puts ac_list
```

Output should be...

```xml
<feed xmlns="http://www.w3.org/2005/Atom" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:opds="http://opds-spec.org/2010/catalog" xmlns:opensearch="http://a9.com/-/spec/opensearch/1.1/" xmlns:thr="http://purl.org/syndication/thread/1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xml:lang="en">
   <title>Test AcquisitionList</title>
   <updated>Today</updated>
   <author>
      <name>Charles Mulloy</name>
   </author>
   <entry>
      <title>Book 1</title>
      <author>
         <name>Author</name>
      </author>
      <content>this is a desc</content>
      <link href="feed/123.epub" rel="http://opds-spec.org/acquisition" type="application/epub+zip"/>
   </entry>
</feed>
```

Classes, Methods, and Examples
---
Below is a comprehensive overview of the classes and their methods and attributes. There are also examples on hows to use every aspect of the Class

<table>
  <tr>
    <th colspan="3">RootList</th>
  </tr>
  <tr>
    <td colspan="3">Attributes</td>
  </tr>
  <tr>
    <td>title</td>
    <td>String</td>
    <td>Sets the title of the feed.</td>
  </tr>
  <tr>
    <td>author</td>
    <td>String</td>
    <td>Set the author of the feed.</td>
  </tr>
  <tr>
    <td>updated</td>
    <td>String</td>
    <td>The date that the feed was last updated.</td>
  </tr>
  <tr>
    <td>self_link</td>
    <td>String</td>
    <td>Path to get to itself. Likely the path that the user will enter to access the cataglog to begin with.</td>
  </tr>
  <tr>
    <td>start</td>
    <td>String</td>
    <td>Path to the starting point of the catalog. Likely the same as self_link.</td>
  </tr>
  <tr>
    <td colspan="3">Methods</td>
  </tr>
  <tr>
    <td>add_list_link()</td>
    <td colspan="2">Adds a link to the Root object. Can be either an AcquisitionEntry or a NavigationEntry</td>
  </tr>
  <tr>
    <td colspan="3">Example</td>
  </tr>
  <tr>
    <td colspan="3">
    	#Create the Root list.<br>
    	root = RootList.new()<br>
        #Set the Title of the list.<br>
        root.title= "Root title"<br>
        #Set the Author of the list.<br>
        root.author= "Name of the author"<br>
        #Set the updated time.<br>
        root.title= "2017-05-20T712:00:00Z"<br>
        #Set the url that points to this feed.<br>
        root.self_link= "http://example.com/root.xml"<br>
        #Set the url that points to the starting point of the catalog. probably the same as the self link.<br>
        root.self_link= "http://example.com/root.xml"<br>
        #Add links to the list. You can add an NavigationEntry or an AcquisitionEntry to point to the type of link to be referenced. You can probably use which ever you want, but I recomend that you use the appropriate class, not just because of readability, but also because the list changes the output slightly depending the the class you selected.<br>
        nav_entry = NavigationEntry.new(title: 'Title1', content: 'Title1 content', link: 'shelf1/list.xml')<br>
  		acq_entry = AcquisitionEntry.new(title: 'Title2', content: 'Title2 content', link: 'shelf2/list.xml')<br>
        root.add_list_link nav_entry<br>
  		root.add_list_link acq_entry<br>
        puts root
        </td>
  </tr>
</table>

<table>
  <tr>
    <th colspan="3">AcquisitionList</th>
  </tr>
  <tr>
    <td colspan="3">Attributes</td>
  </tr>
  <tr>
    <td>title</td>
    <td>String</td>
    <td>Sets the title of the feed.</td>
  </tr>
  <tr>
    <td>author</td>
    <td>String</td>
    <td>Set the author of the feed.</td>
  </tr>
  <tr>
    <td colspan="3">Methods</td>
  </tr>
  <tr>
    <td>add_book(BookEntry)</td>
    <td colspan="2">Adds a BookEntry object into the feed. The object must have files to be usable, but that will not keep the module from making the entry.</td>
  </tr>
  <tr>
    <td colspan="3">Example</td>
  </tr>
  <tr>
  	<td colspan="3">
      #Create the list<br>
      acq_list = AcquisitionList.new()<br>
      #Create a book. The attributes can be set outside of the new() method, if you are so inclined because the author, title, and description attributes are all exposed.<br>
      book = BookEntry.new(title: "title", author: "Author", description: "Description of the book")<br>
      #Add a file to the book<br>
      book.add_file(path: "path/to/file.epub", mimetype: "application/epub+zip")<br>
      #Add book to the list.<br>
      acq_list.add_book(book)<br>
      #print the list.<br>
      puts aqc_list
    </td>
  </tr>
</table>

<table>
  <tr>
    <th colspan="3">NavigationList</th>
  </tr>
  <tr>
    <td colspan="3">Attributes</td>
  </tr>
  <tr>
    <td>title</td>
    <td>String</td>
    <td>Sets the title of the feed.</td>
  </tr>
  <tr>
    <td>author</td>
    <td>String</td>
    <td>Set the author of the feed.</td>
  </tr>
  <tr>
    <td colspan="3">Methods</td>
  </tr>
  <tr>
    <td>add_link()</td>
    <td colspan="2">Adds an entry to the list to allow navigation to other feeds. Can be an AcquisitionEntry or another NavigationEntry</td>
  </tr>
  <tr>
    <td colspan="3">Example</td>
  </tr>
  <tr>
  	<td colspan="3">
      #Create the list<br>
      nav_list = AcquisitionList.new()<br>
      #Create NavigationEntries and/or AcquisitionEntries.<br>
      nav_entry = NavigationEntry.new(title: "Title", content: "A Summary of the entry", link: "path/to/entry1.xml")<br>
      acq_entry = NavigationEntry.new(title: "Title", content: "A Summary of the entry", link: "path/to/entry2.xml")<br>
      #Add them to the list.<br>
      nav_list.add_link nav_entry<br>
      nav_list.add_link acq_entry<br>
      #print the list.<br>
      puts nav_list
    </td>
  </tr>
</table>

<table>
  <tr>
    <th colspan="3">NavigationEntry</th>
  </tr>
  <tr>
    <td colspan="3">Attributes</td>
  </tr>
  <tr>
    <td>title</td>
    <td>String</td>
    <td>Sets the title of the feed.</td>
  </tr>
  <tr>
    <td>content</td>
    <td>String</td>
    <td>Set the description of the feed.</td>
  </tr>
  <tr>
    <td>link</td>
    <td>String</td>
    <td>Set the path to reach the NavigationFeed.</td>
  </tr>
  <tr>
    <td colspan="3">Example</td>
  </tr>
  <tr>
  	<td colspan="3">
      # Creating the entry. Keep in mind that it should only be added to a root or navigation list. Attributes can also be modified directly.<br>
      nav_entry = NavigationEntry.new(title: "Title", content: "A Summary of the entry", link: "path/to/entry1.xml")<br>
    </td>
  </tr>
</table>

<table>
  <tr>
    <th colspan="3">AcquisitionEntry</th>
  </tr>
  <tr>
    <td colspan="3">Attributes</td>
  </tr>
  <tr>
    <td>title</td>
    <td>String</td>
    <td>Sets the title of the feed.</td>
  </tr>
  <tr>
    <td>content</td>
    <td>String</td>
    <td>Set the description of the feed.</td>
  </tr>
  <tr>
    <td>link</td>
    <td>String</td>
    <td>Sets the URL to the AcquisitionFeed</td>
  </tr>
  <tr>
    <td colspan="3">Example</td>
  </tr>
  <tr>
  	<td colspan="3">
   		# Creating a AcquisitionEntry<br>
        acq_entry = NavigationEntry.new(title: "Title", content: "A Summary of the entry", link: "path/to/entry2.xml")
    </td>
  </tr>
</table>

<table>
  <tr>
    <th colspan="3">BookEntry</th>
  </tr>
  <tr>
    <td colspan="3">Attributes</td>
  </tr>
  <tr>
    <td>title</td>
    <td>String</td>
    <td>Sets the title of the book.</td>
  </tr>
  <tr>
    <td>author</td>
    <td>String</td>
    <td>Set the author of the book.</td>
  </tr>
  <tr>
    <td>description</td>
    <td>String</td>
    <td>Set the description of the book.</td>
  </tr>
  <tr>
    <td colspan="3">Methods</td>
  </tr>
  <tr>
    <td>add_file(file)</td>
    <td colspan="2">Adds an entry to the book so that the files can be listed. Takes a FileEntry objects</td>
  </tr>
  <tr>
  	<td colspan="3">Example</td>
  </tr>
  <tr>
  	<td colspan="3">
      #Creating a book is really simple.<br>
      book = BookEntry.new(title: "Book title", author: "Author of the book", description: "The description of the book.")<br>
      #Adding a file is even moreso.<br>
      book.add_file(FileEntry.new(path: "path/to/file.epub"))
    </td>
  </tr>
</table>

<table>
  <tr>
    <th colspan="3">FileEntry</th>
  </tr>
  <tr>
    <td colspan="3">Attributes</td>
  </tr>
  <tr>
    <td>path</td>
    <td>String</td>
    <td>Sets the path of the file so the client can find it.</td>
  </tr>
  <tr>
    <td>mimetype</td>
    <td>String</td>
    <td>Set the mimetype of the file. This setting is not mandatory, but it will assume 'application/epub+zip' if it is not specified.</td>
  </tr>
  <tr><td colspan="3">Example</td></tr>
  <tr>
  	<td colspan="3">
    	#Creating files is the most straightforward function of this project. <br>
      file = FileEntry.new(path: "path/to/file.mobi", mimetype: "application/x-mobipocket-ebook")
  	</td>
  </tr>
</table>
