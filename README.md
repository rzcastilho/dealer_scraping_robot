# Dealer Scraping Robot  [![Build Status](https://travis-ci.org/rzcastilho/dealer_scraping_robot.svg?branch=master "Build Status")](http://travis-ci.org/rzcastilho/dealer_scraping_robot) [![Coverage Status](https://coveralls.io/repos/github/rzcastilho/dealer_scraping_robot/badge.svg)](https://coveralls.io/github/rzcastilho/dealer_scraping_robot)

Gets the overly positive reviews of the informed dealer and by default returns the first three results from the five first review pages. 

## Running

Before run install and start PhantomJs.

```shell script
$ npm install -f phantomjs
$ phantomjs --wd
```

Build escript.

```shell script
$ mix escript.build
```

Run passing the dealer name.

```shell script
$ ./dealer_scraping_robot -d "McKaig Chevrolet Buick"
```

To get more options, run with `--help` or `-h` flag.

```shell script
$ ./dealer_scraping_robot --help"
```

## Links

  * [github.com](https://github.com/rzcastilho/dealer_scraping_robot)
  * [coveralls.io](https://coveralls.io/github/rzcastilho/dealer_scraping_robot)
  * [travis-ci.org](https://travis-ci.org/rzcastilho/dealer_scraping_robot)

