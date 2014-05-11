# ComicWalker
[![Gem Version](https://badge.fury.io/rb/comic_walker.svg)](http://badge.fury.io/rb/comic_walker)
[![Code Climate](https://codeclimate.com/github/eagletmt/comic_walker.png)](https://codeclimate.com/github/eagletmt/comic_walker)

Client library for [ComicWalker](http://comic-walker.com/).

## Installation

Add this line to your application's Gemfile:

    gem 'comic_walker'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install comic_walker

## Usage

### CLI

```
% comic-walker save KDCW_KS04000001010001_68
item/xhtml/p-cover.xhtml/0.dat -> Ｆａｔｅ／ｋａｌｅｉｄ　ｌｉｎｅｒ　プリズマ☆イリヤ　ドライ！！/KDCW_KS04000001010001_68/000_p-cover.jpg
item/xhtml/p-001.xhtml/0.dat -> Ｆａｔｅ／ｋａｌｅｉｄ　ｌｉｎｅｒ　プリズマ☆イリヤ　ドライ！！/KDCW_KS04000001010001_68/001_p-001.jpg
item/xhtml/p-002.xhtml/0.dat -> Ｆａｔｅ／ｋａｌｅｉｄ　ｌｉｎｅｒ　プリズマ☆イリヤ　ドライ！！/KDCW_KS04000001010001_68/002_p-002.jpg
item/xhtml/p-white.xhtml/0.dat -> Ｆａｔｅ／ｋａｌｅｉｄ　ｌｉｎｅｒ　プリズマ☆イリヤ　ドライ！！/KDCW_KS04000001010001_68/003_p-white.jpg
item/xhtml/p-004.xhtml/0.dat -> Ｆａｔｅ／ｋａｌｅｉｄ　ｌｉｎｅｒ　プリズマ☆イリヤ　ドライ！！/KDCW_KS04000001010001_68/004_p-004.jpg
(snip)
```

```
% comic-walker contents
冴えない彼女の育てかた http://comic-walker.com/contents/detail/KDCW_FS02000006010000_68
  Updated: 2014-03-24 13:39:24
  Deliver: 2014-03-24 13:35:00 - 2064-03-12 17:54:00
  Episodes:
    第1話 http://comic-walker.com/viewer/?cid=KDCW_FS02000006010001_68
  Next: 2014-04-01 00:00:00
(snip)
```

## Contributing

1. Fork it ( https://github.com/eagletmt/comic_walker/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
