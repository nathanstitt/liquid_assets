# liquid_assets version 0.1.0

## Description

Allows you to use the Liquid template language in Rails, both as
templates and as JavaScript via the asset_pipeline.

**Warning!** This is very rough, and only minimally tested.  Version
  0.1 really does mean 0.1 in this case!

Although I'm going to attempt to minimize breaking changes, there may
be a few as I discover bugs and/or better methods of implementing
features.

My future goals for it are to add template inheritance/override
support and read template's from active_record. *(probably via a
supplied Proc)*

The Ruby bits are via the standard Liquid http://liquidmarkup.org/
gem.

The JavaScript support is possible through the TinyLiquid
https://github.com/leizongmin/tinyliquid JavaScript library, which
execjs calls to compiles the templates to JavaScript.  I did have to
perform a few small modifications to the library in order to get it to
support partials in the same manner as the Ruby library

## Rationale
I am currently developing a largish project that has a requirement for
user edited html that needs to be rendered both as a standard website
and as a single page Backbone application.

I'd originally attempted to use Mustache templates but discarded that
idea after not being able to do simple things like formatting numbers
in the views.

Liquid templates were ideal, but they lacked a suitable JS
environment.  I then ran across the TinyLiquid project and decided to
create a gem to unite the two.


## Usage

Set the root in an initializer, i.e. config/initializers/liquid_assets.rb
The root defaults to app/assets/templates.

     LiquidAssets::Config.configure do |config|
         config.path_prefix        = 'app/assets/templates'
         config.filters            = MyFilterModule
         config.template_namespace = 'LQT'
     end


### Use as Rails views

Create a view just like you would with erb, except with .liquid as the extension.

    app/assets/templates/blog/post.liquid

Since the template is written in Liquid, it DOES NOT have access to
the normal rails helper methods.

It does have access to instance variables, but can only interact with
simple Strings, Numbers, Arrays, & Hashes. An additional restriction
is that Hashes must use strings for keys, not symbols.

I'm sure some of these limitations could be worked around, but my
needs do not include supporting them at this time.  *Patches are welcomed*


By default the filters are set to the Liquid::StandardFilters
http://liquid.rubyforge.org/classes/Liquid/StandardFilters.html This
can be changed by including a liquid_filters method on the controller,
or in application_controller to set system-wide. *(assuming you are
inheriting from it)*

A short example:

blog_controller.rb:

    def show
        @ages={'bob'=>28,'joe'=>23}
        render :template=>'blog/post'
    end

app/assets/templates/blog/post.liquid :

     Bob is {{ages.bob}}, older than Joe - who's only {{ages.joe}}.

But this will not since @bob is not a hash.

controller:

    def show
        @old=People.where({:name=>'bob',:age=>100}).first
        render :template=>'blog/post'
    end

(contrived) liquid view:

     Bob's age is {{old.age}}

**Hint:** To get it to work, call as_json on your models:

    @old=People.where({:name=>'bob',:age=>100}).first.as_json


### Use as AssetPipeline pre-compiled javascript

You can include your liquid templates in the asset_pipeline by
using the standard //=  syntax in one of your existing JavaScript files

//=require liquid_assets
//=require templates/blog/post

Will compile post.liquid to JavaScript using TinyLiquid and include it like so

    LQT['templates/blog/post'] = function(locals,filters){ ... }

It can be used similar to underscore's JST template.

With filters:

      LQT['templates/blog/post']( { bob:{ age: 23 } }, {
         plusTen: function(num){  return num+10; }
      })

Template:

     Bob will be {{bob.age | plusTen}} in ten years.

Renders to:
     Bob will be 33 in ten years.

The LQT namespace is short for LiQuid Template, à la JST from underscore.

It can be modified by configuring:

     LiquidAssets::Config.configure do |config|
         config.template_namespace = 'FANCY_NAME'
     end

## Thanks

[Shopify](http://www.shopify.com/)
for creating the liquid template language and Ruby implementation.  [leizongmin](https://github.com/leizongmin/tinyliquid) for the
tinyliquid Javascript support.

I cribbed from [hogan_assets](https://github.com/leshill/hogan_assets/), [Poirot](https://github.com/olivernn/poirot) and [Stache](https://github.com/agoragames/stache/) in creating this gem.  Good parts
are thanks to those projects, mistakes are mine.


## Contributing
Fork on [github](https://github.com/nathanstitt/liquid_assets), implement your change, submit a pull request.


## Copyright

Copyright (c) 2013 Nathan Stitt. See LICENSE.txt for
further details.
