![livetribe](http://en.gravatar.com/userimage/37511139/d08dfb0c999f540b24b0e042d27e5b17.png)

LiveTribe Debut
===============
[![Build Status](https://secure.travis-ci.org/livetribe/debut-ruby.png?branch=master)](http://travis-ci.org/livetribe/debut-ruby)
[![Gem Version](https://fury-badge.herokuapp.com/rb/debut.png)](http://badge.fury.io/rb/debut)
[![Dependency Status](https://gemnasium.com/livetribe/debut-ruby.png)](https://gemnasium.com/livetribe/debut-ruby)
[![Code Climate](https://codeclimate.com/repos/53030f3669568039c20034f2/badges/9a71d49078ec0980c966/gpa.png)](https://codeclimate.com/repos/53030f3669568039c20034f2/feed)
[![Coverage Status](https://coveralls.io/repos/livetribe/debut-ruby/badge.png)](https://coveralls.io/r/livetribe/debut-ruby)

Register your cloud instance w/ DNS and other lookup services.

## About

LiveTribe's `debut` command can be used to register your cloud instance with a
DNS service, e.g. Amazon Route 53.  It can also be used to unregister your
cloud instance as well.

The `debut` command allows for the addition of providers which allow the
`debut` command to interface with different DNS providers.  At the moment
there is only one Amazon Route 53 provider.  Come join the fun and add one!

## Getting Started

    sudo gem install debut

Now, after
[setting up your Fog credentials](http://fog.io/about/getting_started.html#credentials "Setting up your Fog credentials"),
you are ready to introduce your cloud instance:

    $ debut -h ec2-164-62-8-61.us-west-1.compute.amazonaws.com -s mock.livetribe.org. -n travis hello
    Registered hostname ec2-164-62-8-61.us-west-1.compute.amazonaws.com at travis.mock.livetribe.org.
    $ debut -h ec2-164-62-8-61.us-west-1.compute.amazonaws.com -s mock.livetribe.org. -n travis goodbye
    Unregistered travis.mock.livetribe.org.

If the hostname, sub-domain, and name are not specified, the `aws` provider
will attempt obtain the information from the
[user data of the meta-data service](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AESDG-chapter-instancedata.html).
Here, the `aws` provider will be looking for a valid JSON object:

    {
      "hostname": "ec2-184-72-8-21.us-west-1.compute.amazonaws.com",
      "subdomain": "mock.livetribe.org.",
      "name": "travis"
    }

If any of the above parameters are not specified in the user data they must be
provided on the command line.

### AWS Policies

The AWS security policy for the user must allow for the reading of the list of
zones and for the modification of the zone onto which `CNAME` records will be
added.  The following represents the minimum policy which seems to work:

    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": [
            "route53:Get*",
            "route53:List*"
          ],
          "Resource": [
            "*"
          ]
        },
        {
          "Action": [
            "route53:ChangeResourceRecordSets"
          ],
          "Resource": [
            "arn:aws:route53:::hostedzone/YOURHOSTEDZONEID"
          ],
          "Effect": "Allow"
        }
      ]
    }

Where `YOURHOSTEDZONEID` needs to be replaced with the zone id of your Amazon
Route 53 zone.  The first policy statement allows for the scanning of zones and
the second policy allows for the modification of a specific zone.

## Contributing

* Find something you would like to work on.
  * Look for anything you can help with in the [issue tracker](https://github.com/livetribe/debut-ruby/issues).
  * Look at the [code quality metrics](https://codeclimate.com/github/livetribe/debut-ruby) for anything you can help clean up.
  * Or anything else!
* Fork the project and do your work in a topic branch.
  * Make sure your changes will work on both Ruby 1.9 and Ruby 2.0
* Add minitests tests to prove your code works and run all the tests using `bundle exec rake`.
* Rebase your branch against `livetribe/debut-ruby` to make sure everything is up to date.
* Commit your changes and send a pull request.

## Additional Resources

* [livetribe.org](http://www.livetribe.org)
* [Provider Documentation](http://www.livetribe.org/about/Debut-Provider)


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/livetribe/debut-ruby/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

