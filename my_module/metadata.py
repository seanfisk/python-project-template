""":mod:`my_module.metadata` --- Project metadata

Information describing the project.
"""

title = 'my_module'
nice_title = "My Awesome Module"
nice_title_no_spaces = nice_title.replace(' ', '')
version = '0.1'
description = 'It does cool things'
authors = ['Foo Bar', 'John Doe']
authors_string = ', '.join(authors)
emails = ['foobar@example.com', 'johndoe@thisisfake.org']
license = 'ISC'
copyright = '2012 ' + authors_string
url = 'http://example.com/'
