DPLA Frontend
-------------
This is the frontend Ruby on Rails application for DPLA platform.

We welcome pull requests for bug fixes and new features.  Please use a
separate feature branch for each pull request.

[![BrowserStack Status](https://www.browserstack.com/automate/badge.svg?badge_key=UzZRL0QwZzR1Mlc4V2tuMi9XMS9RUm5hZ0lCL2tDaVhJU0xnRU1KdjcrOD0tLXRmQkRDTnZLekZLM0RWdGMyMCtHNUE9PQ==--24287c43017fc50481ab631e86244f9db3ec9257)](https://www.browserstack.com/automate/public-build/UzZRL0QwZzR1Mlc4V2tuMi9XMS9RUm5hZ0lCL2tDaVhJU0xnRU1KdjcrOD0tLXRmQkRDTnZLekZLM0RWdGMyMCtHNUE9PQ==--24287c43017fc50481ab631e86244f9db3ec9257)


Quickstart for hacking on the DPLA front end
--------------------------------------------

Here's what you need to do if you want to get set up to, for example, 
fix a bug or add a feature -- and submit a pull request, of course.

This will also allow you to build a whitebox version of the dpla.org
web site.

NOTE: Because the current dependencies include native Gems, it may be
difficult to install them on Windows. Two known extensions include 
Rmagic & debug_inspector.

Prerequisites
-------------
* Git
* Ruby - ruby, ruby-dev, build-essential
* RMagic gem prereqs - imagemagick and libmagickwand-dev
* Postgresql - postgresql-common, postgresql, pgadmin3

Setup
-----
This procedure was tested on Ubuntu.  It may need to be adapted for
other operating systems.

1. Install Git

    `sudo apt-get install git`

2. Download sources

    ```git clone https://github.com/dpla/frontend.git dpla-frontend
cd dpla-frontend```

3. Install Ruby & related dependencies

    ```sudo apt-get install ruby ruby-dev build-essential
sudo apt-get install imagemagick libmagickwand-dev```

4. Install necessary Ruby Gems

    `bundle install --deployment`

5. Install PostgreSQL

    `sudo apt-get postgresql-common, postgresql, pgadmin3`

6. Configure PostgreSQL & create development database

    ```sudo -u postgres psql postgres
psql (9.1.10)
Type "help" for help.
postgres=# pwd
postgres-# \password postgres```

ie enter the command `\password postgres` at the `postgres-#` prompt

After entering the new password twice, press ctrl/D to exit.

Now create the development database:

    sudo -u postgres createdb dpla_development

Finally, copy `config/database.yml.example` to `config/database.yml` and edit
it to provide your username, password, and database for the `development`
configuration:

    development:
      adapter: postgresql
      host: localhost
      encoding: unicode
      database: dpla_development
      username: postgres
      password: <postgres password>

7. Copy `config/environments/development.yml.example` to 
`config/environments/development.yml`, and edit it to provide your DPLA API key

8. Build the front end assets

    `rake assets:precompile`

9. Run the database migrations

    `rake db:migrate`

10. Start the local Rails server

    `rails server`

You should now be able to point your browser at `http://localhost:3000/` and
see your local copy of the DPLA front end.


License
--------
This application is released under an AGPLv3 license.

* Copyright Digital Public Library of America, 2015 -- 2017

[<img src="browserstack-logo-600x315.png" height="100" alt="" />](http://browserstack.com/)

We use BrowserStack to test this code in as many different devices and platforms as we can.
