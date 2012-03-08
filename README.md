# Gifl:  Google I'm Feeling Lucky URL Grabber

Textmate sure was a swift kick in the ass for a lot of the editors:
bundles, integration, carpal-crucifying key bindings?  Yet the old ways
remain seductive and in the expanse between Textmate 1.0 and Textmate
2.0 alpha, many found themselves picking up the tried-and-true editors
and moving them to meet up with features they liked about Textmate.

Lack of this feature was keeping my friend [Daniel
Miessler](http://danielmiessler.com/) from converting to Vim as his
blogging platform -- no more!

This plugin wraps a term set in a URL derived from the term's "I'm
feeling lucky" URL.  This is great for blogging or referencing known /
famous URL identities.  

# Configuration

`g:LuckyOutputFormat` : set to "markdown" or "html" for link formatting

# Examples

## Notation

* <Leader> is `\`
* \* is cursor position
* | | denote visual selection areas

## OK, the examples already

    *lindsay lohan
    \gifl2e
    [lindsay lohan](http://www.myspace.com/lindsaylohan*)

alternatively:

    *Zooey Deschanel  # v2e
    |Zooey Deschanel| # \gifl
    [Zooey Deschanel](http://en.wikipedia.org/wiki/Zooey_Deschanel*)
    
If you like angle brackets:
   :let g:LuckyOutputFormat='html'
   \*Bazinga!  # \gifl$
   <a href=http://www.urbandictionary.com/define.php?term=bazinga>Bazinga!</a>

# Author

Steven G. Harms (@sgharms)

# Thanks

[Steve Losh](http://stevelosh.com/)
