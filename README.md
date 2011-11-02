# Jasig CAS project documentation

The documentation is written in `markdown` then converted to HTML and PDF using a static site compiler written in Ruby called `nanoc`.

## Installing Ruby + RubyGems

**OS X**  
The latest and greatest package manager attempt on OS X is [homebrew](http://mxcl.github.com/homebrew/) (skip straight to [installation](https://github.com/mxcl/homebrew/wiki/Installation))

Once you have homebrew it's as simple as:

	brew install ruby

**Ubuntu**  
Follow these instructions [here](https://github.com/Snorby/snorby/wiki/Ubuntu-1.9.2-without-RVM-by-Eric-Peters) (you can skip the Rails section towards the bottom…)

**Windows**  
The easiest way to install Ruby on Windows is [RubyInstaller](http://rubyinstaller.org/)

## Installing Bundler

With ruby good to go

	ruby --version # => ruby 1.9.2p290

you can now install `bundler`, a ruby gem that helps manage a project's gem dependencies. Install `bundler` like any other ruby gem (may require `sudo`):

	gem install bundler

## Installing wkhtmltopdf

`wkhtmltopdf` (i.e. webkit html to pdf) is a simple shell utility to convert HTML to PDF using WebKit and QT. [Click here](https://github.com/jdpace/PDFKit/wiki/Installing-WKHTMLTOPDF) for installation instructions.

## Getting Started

1. Clone this repository

		git clone git@github.com:jdlich/cas-docs.git

2. From the project root, install gem dependencies via `bundle`

		cd cas-docs
		bundle install

	*(NOTE: if the command is not found, make sure you have the rubygems bin folder in your path. It's going to be something like `.../ruby/gems/1.9.2/gems/bin`)*
	
	*(ALSO NOTE: if `bundler` stops because of a system dependency, make sure to run `bundle install` again after you have resolved the issue)*

3. Build the project into a new directory called `output/`

		nanoc compile

4. Start `nanoc`'s autocompile server which runs on `http://localhost:3000`

		nanoc aco
		# => localhost:3000

	*(NOTE: the PDF generation is somewhat of a small bottleneck during compilation, but you can temporarily comment out the `:pdfkit` compile filter in the `Rules` file — or just deal with the extra few seconds.)*

## nanoc Filesystem Breakdown

* `config.rb` - Compass stylesheet framework configuration ([compass](http://compass-style.org/) is built on top of [sass](http://sass-lang.com/))
* `config.yaml` - nanoc configuration
* `content` - Source files (views, stylesheets, images, etc)
* `Gemfile` - Used with bundler to manage gem dependencies
* `layouts` - Content gets injected into HTML layout templates via ERB, a ruby templating language
* `lib` - Custom Ruby code that gets executed during compilation (anything goes, methods are magically available in your views and layouts)
* `Rakefile` - Ruby build tool. Run `rake -T` to see list of available tasks (equivalent to `ant -p`).
* `Rules` - Instructions for routes (URLs) and compiling (e.g. matching content with layouts, converting markdown to HTML, etc)

*For more details, `nanoc` is really well documented [here.](http://nanoc.stoneship.org/docs/)*

## Markdown

`markdown` is one of many simple markup languages that allow you to write HTML without the pain of writing HTML. The syntax is [very easy to learn.](http://daringfireball.net/projects/markdown/syntax)