""":mod:`my_module.metadata` --- Project metadata

Information describing the project.
"""

# The package name, which is also the so-call "UNIX name" for the project.
package = 'my_module'
project = "My Awesome Module"
project_no_spaces = project.replace(' ', '')
version = '0.1'
description = 'It does cool things'
authors = ['Foo Bar', 'John Doe']
authors_string = ', '.join(authors)
emails = ['foobar@example.com', 'johndoe@thisisfake.org']
license = 'MIT'
copyright = '2013 ' + authors_string
url = 'http://example.com/'
