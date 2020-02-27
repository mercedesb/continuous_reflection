# continuous_reflection
A Rails API only application for journaling and reflection. This app feeds the [continuous-reflection-client React application](https://github.com/mercedesb/continuous-reflection-client).

A user can have different journals for different purposes: one journal for tracking their career progress and another for writing daily poetry. Eventually, this application will have analytics features, including sentiment analysis, so you can track your mood, learnings, and goal-progress over time. 

## Built with

- [Rails](https://reactjs.org/)
- [Rspec](https://tailwindcss.com/docs/installation/)
- [Jwt](https://jestjs.io/docs/en/getting-started)

## Dependencies

This project uses [Bundler](https://bundler.io/) for managing Ruby gems. If you don't already have it, you can run the following command to install it

```
gem install bundler
```

## Project set up
```
git clone https://github.com/mercedesb/continuous_reflection.git
cd continuous_reflection
bundle install
```

## Setup database and seed data
    
Setup the database
```
rake db:setup
```

## Run the server
```
rails server
```

## Running the tests
This project uses [Rspec](https://relishapp.com/rspec/rspec-rails/docs) as the unit testing framework.
```
bundle exec rspec
```
