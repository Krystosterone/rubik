# Rubik [![CircleCI](https://circleci.com/gh/Krystosterone/rubik/tree/main.svg?style=svg)](https://circleci.com/gh/Krystosterone/rubik/tree/main) [![Maintainability](https://api.codeclimate.com/v1/badges/2fb370c03449e3eb5c2b/maintainability)](https://codeclimate.com/github/Krystosterone/rubik/maintainability) [![codecov](https://codecov.io/gh/Krystosterone/rubik/branch/main/graph/badge.svg?token=xsg8JvQjZx)](https://codecov.io/gh/Krystosterone/rubik)

Rubik is a tool for students to easily and intuitively generate schedule combinations for different school trimesters.

**For now**, Rubik is only used for [l'École de Technologie Supérieure](https://www.etsmtl.ca/) at [ets.rubik.co](http://ets.rubik.co). The hopes is to eventually expand the platform to other schools and/or organizations. As such, the code is written in a way that it does not do make assumptions on a specific domain language. Apart for some hardcoding of banners and translations, the software _should_ be re-usable for other schools fairly easily.

## Dependencies

- Airbrake
- Chromium
- MySQL
- Node and Yarn
- The `pdftotext` command line utility
- PhantomJS 2.1.1
- Redis
- Sendgrid

## Getting it up and running

1. Clone the repository
2. `bundle install`
3. `yarn install`
4. `bundle exec rails db:create db:migrate db:test:prepare db:seed`

## Useful commands

- **Run all specs:** `bundle exec rspec`
- **Run all feature tests:** `bundle exec cucumber`
- **Run the ruby linter:** `bundle exec rubocop`
- **Run the javascript linter:** `yarn run eslint app/assets/javascripts/**/*`

## Adding a new trimester

For [ets.rubik.co](http://ets.rubik.co), there exists an **ETL** to parse PDFs provided by the school and transform it into a dataset useable by the website. The process looks like this:

1. Download all PDFs you want to include on the website here: [Horaires et planification des cours : baccalauréats](https://www.etsmtl.ca/horaires-bac) or try running:

  ```bash
  ./script/ets_download_pdfs
  ```

2. Move them to [db/raw/ets](https://github.com/Krystosterone/rubik/tree/main/db/raw/ets) and name them accordingly for easy debugging.
3. Run `bundle exec thor ets_pdf:etl` with the appropriate file patterns (ending with `.pdf`). For example:
  
  ```bash
  bundle exec thor ets_pdf:etl -d $(find db/raw/ets -iname "2022-*.pdf")
  ```

  **or**

  ```bash
  bundle exec thor ets_pdf:etl
  ```

  to run it on all PDFs.
  
4. This will create `*.txt` files along side the PDFs; if the rake task fails, explore the error that occured while parsing a particular `*.txt` and manually fix it
5. Repeat steps 4 and 5 until done
6. Commit the `*.pdfs` and `*.txt` to git

Once all of this is done and pushed to production, run one last time `bundle exec thor ets_pdf:etl` (again with the appropriate appropriate file patterns, if needed) to import the data to the production database.

## Issues

Feel free to submit issues and enhancement requests. 

Please note though that a good issue is often an issue accompagnied with a pull request.

## Contributing

To contribute:

 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull request** so that we can review your changes

NOTE: Be sure to merge the latest from "upstream" before making a pull request!

## Copyright and Licensing

See [LICENSE](./LICENSE)
