# ComicWalker

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
item/xhtml/p-cover.xhtml/0.dat -> Ｆａｔｅ／ｋａｌｅｉｄ　ｌｉｎｅｒ　プリズマ☆イリヤ　ドライ！！/KDCW_KS04000001010001_68/000_p-cover.jpg
item/xhtml/p-001.xhtml/0.dat -> Ｆａｔｅ／ｋａｌｅｉｄ　ｌｉｎｅｒ　プリズマ☆イリヤ　ドライ！！/KDCW_KS04000001010001_68/001_p-001.jpg
item/xhtml/p-002.xhtml/0.dat -> Ｆａｔｅ／ｋａｌｅｉｄ　ｌｉｎｅｒ　プリズマ☆イリヤ　ドライ！！/KDCW_KS04000001010001_68/002_p-002.jpg
item/xhtml/p-white.xhtml/0.dat -> Ｆａｔｅ／ｋａｌｅｉｄ　ｌｉｎｅｒ　プリズマ☆イリヤ　ドライ！！/KDCW_KS04000001010001_68/003_p-white.jpg
item/xhtml/p-004.xhtml/0.dat -> Ｆａｔｅ／ｋａｌｅｉｄ　ｌｉｎｅｒ　プリズマ☆イリヤ　ドライ！！/KDCW_KS04000001010001_68/004_p-004.jpg
item/xhtml/p-005.xhtml/0.dat -> Ｆａｔｅ／ｋａｌｅｉｄ　ｌｉｎｅｒ　プリズマ☆イリヤ　ドライ！！/KDCW_KS04000001010001_68/005_p-005.jpg
item/xhtml/p-006.xhtml/0.dat -> Ｆａｔｅ／ｋａｌｅｉｄ　ｌｉｎｅｒ　プリズマ☆イリヤ　ドライ！！/KDCW_KS04000001010001_68/006_p-006.jpg
item/xhtml/p-007.xhtml/0.dat -> Ｆａｔｅ／ｋａｌｅｉｄ　ｌｉｎｅｒ　プリズマ☆イリヤ　ドライ！！/KDCW_KS04000001010001_68/007_p-007.jpg
item/xhtml/p-008.xhtml/0.dat -> Ｆａｔｅ／ｋａｌｅｉｄ　ｌｉｎｅｒ　プリズマ☆イリヤ　ドライ！！/KDCW_KS04000001010001_68/008_p-008.jpg
item/xhtml/p-009.xhtml/0.dat -> Ｆａｔｅ／ｋａｌｅｉｄ　ｌｉｎｅｒ　プリズマ☆イリヤ　ドライ！！/KDCW_KS04000001010001_68/009_p-009.jpg
item/xhtml/p-010.xhtml/0.dat -> Ｆａｔｅ／ｋａｌｅｉｄ　ｌｉｎｅｒ　プリズマ☆イリヤ　ドライ！！/KDCW_KS04000001010001_68/010_p-010.jpg
item/xhtml/p-011.xhtml/0.dat -> Ｆａｔｅ／ｋａｌｅｉｄ　ｌｉｎｅｒ　プリズマ☆イリヤ　ドライ！！/KDCW_KS04000001010001_68/011_p-011.jpg
item/xhtml/p-012.xhtml/0.dat -> Ｆａｔｅ／ｋａｌｅｉｄ　ｌｉｎｅｒ　プリズマ☆イリヤ　ドライ！！/KDCW_KS04000001010001_68/012_p-012.jpg
item/xhtml/p-013.xhtml/0.dat -> Ｆａｔｅ／ｋａｌｅｉｄ　ｌｉｎｅｒ　プリズマ☆イリヤ　ドライ！！/KDCW_KS04000001010001_68/013_p-013.jpg
item/xhtml/p-014.xhtml/0.dat -> Ｆａｔｅ／ｋａｌｅｉｄ　ｌｉｎｅｒ　プリズマ☆イリヤ　ドライ！！/KDCW_KS04000001010001_68/014_p-014.jpg
item/xhtml/p-015.xhtml/0.dat -> Ｆａｔｅ／ｋａｌｅｉｄ　ｌｉｎｅｒ　プリズマ☆イリヤ　ドライ！！/KDCW_KS04000001010001_68/015_p-015.jpg
item/xhtml/p-016.xhtml/0.dat -> Ｆａｔｅ／ｋａｌｅｉｄ　ｌｉｎｅｒ　プリズマ☆イリヤ　ドライ！！/KDCW_KS04000001010001_68/016_p-016.jpg
item/xhtml/p-017.xhtml/0.dat -> Ｆａｔｅ／ｋａｌｅｉｄ　ｌｉｎｅｒ　プリズマ☆イリヤ　ドライ！！/KDCW_KS04000001010001_68/017_p-017.jpg
item/xhtml/p-018.xhtml/0.dat -> Ｆａｔｅ／ｋａｌｅｉｄ　ｌｉｎｅｒ　プリズマ☆イリヤ　ドライ！！/KDCW_KS04000001010001_68/018_p-018.jpg
item/xhtml/p-019.xhtml/0.dat -> Ｆａｔｅ／ｋａｌｅｉｄ　ｌｉｎｅｒ　プリズマ☆イリヤ　ドライ！！/KDCW_KS04000001010001_68/019_p-019.jpg
item/xhtml/p-020.xhtml/0.dat -> Ｆａｔｅ／ｋａｌｅｉｄ　ｌｉｎｅｒ　プリズマ☆イリヤ　ドライ！！/KDCW_KS04000001010001_68/020_p-020.jpg
item/xhtml/p-021.xhtml/0.dat -> Ｆａｔｅ／ｋａｌｅｉｄ　ｌｉｎｅｒ　プリズマ☆イリヤ　ドライ！！/KDCW_KS04000001010001_68/021_p-021.jpg
item/xhtml/p-022.xhtml/0.dat -> Ｆａｔｅ／ｋａｌｅｉｄ　ｌｉｎｅｒ　プリズマ☆イリヤ　ドライ！！/KDCW_KS04000001010001_68/022_p-022.jpg
item/xhtml/p-023.xhtml/0.dat -> Ｆａｔｅ／ｋａｌｅｉｄ　ｌｉｎｅｒ　プリズマ☆イリヤ　ドライ！！/KDCW_KS04000001010001_68/023_p-023.jpg
item/xhtml/p-024.xhtml/0.dat -> Ｆａｔｅ／ｋａｌｅｉｄ　ｌｉｎｅｒ　プリズマ☆イリヤ　ドライ！！/KDCW_KS04000001010001_68/024_p-024.jpg
item/xhtml/p-025.xhtml/0.dat -> Ｆａｔｅ／ｋａｌｅｉｄ　ｌｉｎｅｒ　プリズマ☆イリヤ　ドライ！！/KDCW_KS04000001010001_68/025_p-025.jpg
item/xhtml/p-026.xhtml/0.dat -> Ｆａｔｅ／ｋａｌｅｉｄ　ｌｉｎｅｒ　プリズマ☆イリヤ　ドライ！！/KDCW_KS04000001010001_68/026_p-026.jpg
item/xhtml/p-027.xhtml/0.dat -> Ｆａｔｅ／ｋａｌｅｉｄ　ｌｉｎｅｒ　プリズマ☆イリヤ　ドライ！！/KDCW_KS04000001010001_68/027_p-027.jpg
item/xhtml/p-028.xhtml/0.dat -> Ｆａｔｅ／ｋａｌｅｉｄ　ｌｉｎｅｒ　プリズマ☆イリヤ　ドライ！！/KDCW_KS04000001010001_68/028_p-028.jpg
item/xhtml/p-029.xhtml/0.dat -> Ｆａｔｅ／ｋａｌｅｉｄ　ｌｉｎｅｒ　プリズマ☆イリヤ　ドライ！！/KDCW_KS04000001010001_68/029_p-029.jpg
item/xhtml/p-030.xhtml/0.dat -> Ｆａｔｅ／ｋａｌｅｉｄ　ｌｉｎｅｒ　プリズマ☆イリヤ　ドライ！！/KDCW_KS04000001010001_68/030_p-030.jpg
item/xhtml/p-031.xhtml/0.dat -> Ｆａｔｅ／ｋａｌｅｉｄ　ｌｉｎｅｒ　プリズマ☆イリヤ　ドライ！！/KDCW_KS04000001010001_68/031_p-031.jpg
item/xhtml/p-032.xhtml/0.dat -> Ｆａｔｅ／ｋａｌｅｉｄ　ｌｉｎｅｒ　プリズマ☆イリヤ　ドライ！！/KDCW_KS04000001010001_68/032_p-032.jpg
item/xhtml/p-033.xhtml/0.dat -> Ｆａｔｅ／ｋａｌｅｉｄ　ｌｉｎｅｒ　プリズマ☆イリヤ　ドライ！！/KDCW_KS04000001010001_68/033_p-033.jpg
item/xhtml/p-034.xhtml/0.dat -> Ｆａｔｅ／ｋａｌｅｉｄ　ｌｉｎｅｒ　プリズマ☆イリヤ　ドライ！！/KDCW_KS04000001010001_68/034_p-034.jpg
item/xhtml/p-035.xhtml/0.dat -> Ｆａｔｅ／ｋａｌｅｉｄ　ｌｉｎｅｒ　プリズマ☆イリヤ　ドライ！！/KDCW_KS04000001010001_68/035_p-035.jpg
item/xhtml/p-036.xhtml/0.dat -> Ｆａｔｅ／ｋａｌｅｉｄ　ｌｉｎｅｒ　プリズマ☆イリヤ　ドライ！！/KDCW_KS04000001010001_68/036_p-036.jpg
```

## Contributing

1. Fork it ( https://github.com/eagletmt/comic_walker/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
