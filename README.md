# liquid_assets

## Description

Allows you to use the Liquid template language in Rails, both as
templates and as JavaScript via the asset_pipeline.

**Warning!** This is very rough, and has only seen minimally production usage.

Although I'm going to attempt to minimize breaking changes, there may
be a few as I discover bugs and/or better methods of implementing
features.

My future goals for it are to add template inheritance/override
support.

The Ruby bits are via the standard Liquid http://liquidmarkup.org/
gem.

The JavaScript support is possible through the TinyLiquid
https://github.com/leizongmin/tinyliquid JavaScript library, which
execjs calls to compiles the templates to JavaScript.  I did have to
perform a few small modifications to the library in order to get it to
support partials in the same manner as the Ruby library

Javascript version of templates may be rendered by calling

    LQT.Render( path, data );

and partials by:

    LQT.RenderPartial( path, data );

## Rationale
I am currently developing a largish project that has a requirement for
user edited html that needs to be rendered both as a standard website
and as a single page Backbone application.

I'd originally attempted to use Mustache templates but discarded that
idea after not being able to do simple things like formatting numbers
in the views.

Liquid templates were ideal, but they lacked a suitable JS
environment.  I then ran across the TinyLiquid project and created
this gem in order to cleanly unite the them.


## Configuration

Set the root in an initializer, i.e. config/initializers/liquid_assets.rb
The root defaults to app/assets/templates.

     LiquidAssets::Config.configure do |config|
         config.path_prefix        = 'app/assets/templates'
         config.filters            = MyFilterModule
         config.namespace = 'LQT'
         config.globals            = lambda{ { 'website_name': 'A Website of Excellence!' } }
         config.content_provider   = lambda{ |path|
             path == 'hello-world' ? 'Hello World!' : false
         }
     end

By default the Ruby filters are set to Liquid::StandardFilters
http://liquid.rubyforge.org/classes/Liquid/StandardFilters.html. Javascript
versions are also included in the liquid_assets.js file under the
LQT.Filters namespace.


Example
-----

##### Simple rendering

    tmpl = LiquidAssets.parse <<END_TEMPLATE
        Hello {{visitor.name | capitalize }},
        So long and thanks for all the fish!
    END_TEMPLATE

    tmpl.render({'visitor'=>{'name'=>'Bob'}})


Or with a file 'foo/bar.liquid', containing the content *(under Config.path_prefix)*:
    tmpl = LiquidAssets.template( 'foo/bar' ) ``


##### Rendering via rails engine

Given the below configuration:
     LiquidAssets::Config.configure do |config|
         config.globals   = { copyright_holder: 'BigCorp Inc.' }
     end

A liquid template with content:

    Hello {{visitor.name | capitalize }},
    Thanks for stopping by!

    {{ author.name | capitalize }}'s age is {{author.age}}.

    They will be {{ author.age| plus:10 }} in ten years.

    {{ include 'blog/legalease' }}


stored at: app/assets/templates/blog/about.liquid

And a partial:

   This post is copyright {{ copyright_holder }}

stored at: app/assets/templates/blog/_legalease.liquid


### as Rails view


blog_controller.rb:

    def show
        @visitor = { 'name' => 'bob' }
        @author  = { 'name' => 'jimmy smith', 'age'=>23 }
        render :template=>'blog/about'
    end

**Note:** Since the template is written in Liquid, it DOES NOT have access to
the normal rails helper methods.

It does have access to instance variables, but can only interact with
simple Strings, Numbers, Arrays, & Hashes. An additional restriction
is that Hashes must use strings for keys, not symbols.

I'm sure some of these limitations could be worked around, but my
needs do not include supporting them at this time.  *Patches are welcomed*


### as AssetPipeline pre-compiled javascript

You can include your liquid templates in the asset_pipeline by
using the standard //=  syntax in one of your existing JavaScript files

    //=require liquid_assets
    //=require blog/_welcome  // Could also require_tree, or an index.js manifest file
    //=require blog/post

Will compile post.liquid to JavaScript using TinyLiquid and include it at:

    LQT.Templates['blog/post']

It can then be rendered by

    LQT.Render('blog/post',{ author: { name: jimmy smith', age: 23}, visitor: {name: 'bob' } }  )

A set of standard filters are included at LQT.Filters, which may be extended with
custom filter functions.

**Note:** The LQT namespace is short for LiQuid Template, à la JST from underscore.
It can be modified by configuring:

     LiquidAssets::Config.configure do |config|
         config.namespace = 'FANCY_NAME'
     end

If you do modify the namespace, you *may* have to clean Rails asset
cache by running *'rake assets:clean'* In my experience, sometimes
Rails doesn't notice when vendor assets ERB variables change and may
not regenerate the template.

## Result

The output from the template should be identical from both Ruby & Javascript:

    Hello Bob,
    Thanks for stopping by!

    Jimmy Smith's age is 23.

    They will be 33 in ten years.

    This post is copyright BigCorp Inc.


### evaluating liquid templates from string

    template = LiquidAssets.parse( 'A {{name|upcase}} template' )
    template.render({ :name=>'liquid' })

    => 'A Liquid template'


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
further details, *it's MIT*
