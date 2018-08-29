# Todoable

A simple gem that provides a client for the Todoable API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'todoable'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install todoable

## Usage

There are `List`s and `Item`s, defined and implemented via [Dry-struct](https://dry-rb.org/gems/dry-struct/).

### Todoable::Repository

Gateway to query the API.

#### Todoable::Repository::Lists

##### Query Methods

- `.all` returns an array of `List` objects
- `.by_id(:id[, :id[, ...]])` returns an array of `List` objects whose `ID`s match the provided `:id`s
- `.[:id]` returns a `List` object with the matching `:id`

##### Mutation Methods

- `.create(name: '')` creates a new `List` via the API and returns a `List` object
- `.update(id: :id, name: '')` updates the given `List` via the API and returns a `List` object with the new attributes
- `.delete(<List>[, <List>[, ...]])` deletes list(s)

#### Todoable::Repository::Items

##### Query Methods

Items are only queryable through Lists

- `.all` raises a `Todoable::NotAccessibleError`
- `.by_id` raises a `Todoable::NotAccessibleError`
- `.[:id]` raises a `Todoable::NotAccessibleError`

##### Mutation Methods

- `.create(list_id: :id, name: ''[, finished_at: <ISO8601 Formatted String>])` creates a new `Item` on `List` via the API and returns an `Item` object
  - [Information on ISO8601 Format](https://en.wikipedia.org/wiki/ISO_8601)
- `.finish(<Item>)` updates the `Item` as finished, and returns the updated `Item` object
- `.update` (with any parameters) raises an exception
- `.delete(<Item>[, <Item>[, ...]])` deletes items

### Todoable::List

The class for an immutable struct-like object that has `name`, `src`, `id`, and has zero or more `Item`s.

- `#refetch` fetches and returns a new `List` with this object's ID
- `#delete` deletes the `List` via the API, returns true or false

### Todoable::Item

The class for an immutable struct-like object that has `name`, `finished_at`, `src`, `id`, and has one `List`.

- `#refetch` fetches and returns a new `Item` with this object's ID
- `#delete` deletes the `Item` via the API, returns true or false

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/todoable. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Todoable project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/todoable/blob/master/CODE_OF_CONDUCT.md).
