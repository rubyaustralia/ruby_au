RubyAU Styleguide
=================

Installation
------------

    $ npm install

Updating the CSS
----------------

The project uses cssnext so needs to be compiled if you change the CSS.
Edit the files in assets/stylesheets_source and then recompile.

    $ npm run build

I'm sure this can be improved on, it's just a super light build cycle to get you started.

We've taken maybe a unique approach to CSS, hopefully this manifesto helps clarify our approach.
Remix/debate/ignore as you see fit.

DF CSS Manifesto
----------------

0. The old "laws" of CSS have failed us, it's time to try new approaches.
1. Naming things in CSS is a hard problem and a form of waste, just stop.
2. Cultivate a healthy aversion to writing new CSS classes.
3. Utilise a comprehensive library to provide composable "[CSS functions](http://www.jon.gold/2015/07/functional-css)" that cover the vast majority of the CSS spec and common use cases.
4. Where the provided library functions are missing, extend the library in functions.css, keep names short and follow library conventions. [Classes only here, no native elements or ids]
5. The identity.css file is to define *only* native html elements. It's CSS reset for your brand.
(native elements only, no classes, no ids). One exception, can define .button classes here as everyone imagines styled link buttons are native html elements.
6. CSS Animations are their own thing, use animations.css for that stuff.
7. If you're using variables you can give them their own CSS file too if you have a decent build process.
8. The Styleguide (styleguide.html) is not just for looks, it's a detailed receipe book featuring key ingredients as well as the canonical recipies for making composite components (anything that's beyond a native html elements), hence the copyable code examples.
9. UI components and more sophisticated UI elements are not documented in the stylesheets, document them in the Style/Identity Guide (just as designers always have).
10. Strong opinions, loosely held. Iterate.
