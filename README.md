# Gaddress

Google APIから返ってくるアドレスを扱うライブラリ

## Why?

### Google API Address Components

Google APIでは、いくつかのAPIから共通の属性を持つ住所情報がかえってきます.

- [Google Place Details API](https://developers.google.com/places/web-service/details#PlaceDetailsResults)
- [Google Reverse Geocoding API](https://developers.google.com/maps/documentation/geocoding/overview#ReverseGeocoding)

```json
[
  {
    "long_name" : "277",
    "short_name" : "277",
    "types" : [ "street_number" ]
  },
  {
    "long_name" : "Bedford Avenue",
    "short_name" : "Bedford Ave",
    "types" : [ "route" ]
  },
  {
    "long_name" : "Williamsburg",
    "short_name" : "Williamsburg",
    "types" : [ "neighborhood", "political" ]
  },
]
```

このレスポンスには、`types` というフィールドが含まれており、ここのそれぞれの値は

https://developers.google.com/places/web-service/supported_types

で示される値となっています。

### 解決したい課題

この `types` の値は階層を構造をもっており、また一方で階層に属さない意味をもつよな値も存在します。
このライブラリはそれらから階層構造を持つもののみを抽出し、
郵便番号からはじまり、段々と詳細化していく形式の日本式の住所表記に変換するのをサポートするライブラリです.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gaddress'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install gaddress

## Usage

### アドレスの整形

指定の範囲の詳細度のコンポーネントに絞ってアドレスを整形します

```ruby
address = Gaddress::Address.new(
  [
    Gaddress::AddressComponent.new(
        long_name: "日本",
        short_name: "日本",
        types: %w[country]
    ),
    Gaddress::AddressComponent.new(
        long_name: "渋谷区",
        short_name: "渋谷",
        types: %w[locality]
    ),
    Gaddress::AddressComponent.new(
        long_name: "1丁目",
        short_name: "1丁目",
        types: %w[sublocality_level_1]
    ),
    Gaddress::AddressComponent.new(
        long_name: "2",
        short_name: "2", 
        types: %w[sublocality_level_2]
    ),
    Gaddress::AddressComponent.new(
        long_name: "3",
        short_name: "3", 
        types: %w[sublocality_level_3]
    ),
  ]
)
address.format_address(
  min_type: Gaddress::AddressType::LOC,
  max_type: Gaddress::Address::SUB_L1,
  delimiter: '@'
)
=> "渋谷区@1丁目"
```

#### オプション

- `max_type` 最も詳細なコンポーネントのレベルを指定する
- `min_type` 最も曖昧なコンポーネントのレベルを指定する
- `delimiter` コンポーネント間を結合するのに利用する文字列を指定する (だだし、数字のコンポーネントの間は `-` で結合される)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pocket7878/gaddress. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/pocket7878/gaddress/blob/master/CODE_OF_CONDUCT.md).


## Code of Conduct

Everyone interacting in the Gaddress project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/pocket7878/gaddress/blob/master/CODE_OF_CONDUCT.md).
