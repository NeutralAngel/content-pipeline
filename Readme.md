# Content Pipeline.

[![Build Status](https://travis-ci.org/envygeeks/content-pipeline.png?branch=master)](https://travis-ci.org/envygeeks/content-pipeline) [![Coverage Status](https://coveralls.io/repos/envygeeks/content-pipeline/badge.png)](https://coveralls.io/r/envygeeks/content-pipeline) [![Code Climate](https://codeclimate.com/github/envygeeks/content-pipeline.png)](https://codeclimate.com/github/envygeeks/content-pipeline) [![Dependency Status](https://gemnasium.com/envygeeks/content-pipeline.png)](https://gemnasium.com/envygeeks/content-pipeline)


Content pipeline is like `html-pipeline` except it's less restrictive.

## Installing

```
gem install content-pipeline
```

```
gem 'content-pipeline', '~> <VERSION>'
```

## Usage

Content Pipeline is extremely simple to use out of the box:

```ruby

# ---------------------------------------------------------------------
# With custom filters and global-filter options + per-filter options.
# ---------------------------------------------------------------------

pipeline = Content::Pipeline.new([ MyFilter ], {
  :my_filter => {
    :o1 => true
  }
})

pipeline.filter('# Markdown', {
  :my_filter => {
    :o1 => false
  }
})

# ---------------------------------------------------------------------
# With only global-filter options + per-filter options.
# ---------------------------------------------------------------------

pipeline = Content::Pipeline.new({
  :my_filter => {
    :o1 => true
  }
})

pipeline.filter("# Markdown", {
  :my_filter => {
    :o1 => false
  }
})
```

```ruby
Content::Pipeline.new.filter('# Markdown')
```

* Supports global options with overrides.
* By default uses `CodeHighlight`, `Markdown`, `Gemoji`.
* Supports multiple Markdowns.

*It should be noted that if you send a list of filters you wish to use, it will not use the default filters at all.  So where you see `[ MyFilter ]` that will be the only filter that is ran, since it automatically assumes this is the pipeline you wish to use.*

### Filter Options

Filter options are set globally and can be overriden each time the filter is ran, this allows for you to setup a single pipeline and then adjust it on the fly on a per-content basis, for example if you wish to run `Markdown` `:safe` on user comments but not on posts, then you would simply setup the global pipeline and then each time you parse a user comment send the content with the hash `{ :markdown => { :safe => true }}`.

*All options are keyed based on their class name, so `MyFilter` would have the option key `:my_filter` but it also supports `:myfilter`*

### Content::Pipeline::Filters::Markdown

The Markdown filter allows you to choose between `github-markdown` and `kramdown`, and by default will use `kramdown` on jRuby and `github-markdown` on any other Ruby that supports it.  **These dependencies are loose, which means you must install the one you wish to use.**

Options:
* `:type` => [`:gfm`, `:markdown`, `md`, `:kramdown`]
* `:safe` => [`true`, `false`]

*You should not need to adjust any of your "\`\`\`" because the `Markdown` filter will automatically convert those to `~~~` if you choose Kramdown.  This is not done because one way is
better than the other, it's done so that people can remain agnostic.*

### Content::Pipeline::Filters::CodeHighlight

The code highlight filter allows you to highlight code, with or without Pygments.  If Pygments is supported it will require it and syntax highlight, otherwise it will simply wrap your code in the normal code style and not syntax highlight it.  You will still have the line numbers, just not the fancy syntax highlight.

Options:
* `:default` - `:ruby`

### Content::Pipeline::Filters::Gemoji

The Gemoji filter allows you to convert `:gemoji:` into image tags, liquid asset tags and if you really really need it, a custom tag by sending a proc.  By default it will use the path `/asset` which can be overriden.

* `:as_liquid_asset` - `nil`
* `:tag` - `Proc` - 2args - path, name.
* `:asset_path` - `/assets`
