Nelson Scandela
===============

A barebones Sinatra app for generating barcodes.

![Demo screenshot of
app](https://raw.githubusercontent.com/rlue/i/master/nelson-scandela/screenshot.png)

Try It
------

```sh
$ git clone https://github.com/rlue/nelson-scandela
$ cd nelson-scandela
$ bundle install
$ ruby app.rb
```

Then, visit http://localhost:4567/xxx, where `xxx` is the string you wish to
encode.

Why?
----

![Barcode checkout at Family Mart convenience store](https://raw.githubusercontent.com/rlue/i/master/nelson-scandela/family_mart_checkout.jpg)

In Taiwan (where I live), many commercial services can be purchased online and
paid for in person at a convenience store by presenting a vendor-supplied
barcode to the cashier.

Some of these barcodes are provided to the consumer via mobile apps. If you
wish to avoid installing unnecessary software on your phone and know the
content of your desired barcode, you can use this web app to generate the
barcode instead.

Of course, many existing web apps do just this, but the ones I’ve found work
via an HTML form and POST request, meaning generated barcodes cannot be
bookmarked for future use. In contrast, this app uses a URL parameter and GET
request.

### Caveat: Why don’t other apps use GET endpoints?

Search engines build their indices using so-called spiders to “crawl the web”.
This is one example of many different kinds of bots that, depending on which
source you consult, [account for 20–50% of all traffic on the
Internet](https://www.google.com/search?q=internet+traffic+percentage+bots).

Spiders work by recursively following every link they find; _i.e.,_ by finding
and visiting GET endpoints. This means that if you deploy this application and
someone places a link to it on their website or a forum, your application will
end up serving some non-human traffic.

At least, I think that’s why other apps use POST endpoints.
