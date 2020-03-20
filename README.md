![](https://github.com/CustomComm/watir-web_scraper/workflows/Ruby/badge.svg)

## Watir::WebScraper::Scraper

```ruby
  scraper = Watir::WebScraper::Scraper.new(
    actions: [
      SomePath,
      SomeStep
    ],
    params: {}
  )

  scraper.perform
```

The key to Watir::WebScraper is to make sure you inherit from the proper class provided:

## Path

```ruby
class SomePath < Watir::WebScraper::Path
  STEPS = [
    SomeStep, # See Below
    AnotherStep,
    SomeFetcher
  ]
end

path = SomePath.new(browser, params)
path.start # alias for path.perform_steps
```


## Step

```ruby
class SomeStep < Watir::WebScraper::Step
  def instructions
    browser.text_field(id: 'someId').set('foobar')
  end
end

step = SomeStep.new(browser, params)
step.start
```

## Fetcher

```ruby
class SomeFetcher < Watir::WebScraper::Fetcher
  def fetch
    ...
    @fetched_data = fetched_data.merge(data: data)
    ...
  end

  def data
    browser.text_field(id: "someId").value
  end
end
```

## Browser

Two browsers are provided:

- Watir::WebScraper::Chrome
- Watir::WebScraper::Firefox

You may pass an options hash that will be passed down to the Watir::Browser object for custom settings, eg:

```ruby
  Watir::WebScraper::Chrome.new(options: { options: { detach: true }})
```
