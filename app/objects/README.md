# Non-Standard Objects

In order to provide better separation of business logic this custom folder
contains different kinds of objects that do not fit the classic ActiveRecord
structure but still have very defined purposes.

To find out more, read the [7 Patterns to Refactor Fat ActiveRecord Models](http://blog.codeclimate.com/blog/2012/10/17/7-ways-to-decompose-fat-activerecord-models/).
Policy objects are in `app/policies` because pundit wants it that way.

If possible, try not to use the lib folder as a junk drawer and put supporting
code here.
