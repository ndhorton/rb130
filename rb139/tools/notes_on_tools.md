## Gems

"RubyGems, often just called Gems, are packages of code that you can download, install, and use in your Ruby programs or from the command line. The `gem` command manages your Gems; all versions of Ruby since version 1.9 supply `gem` as part of the standard installation."

* RubyGems, most commonly just called Gems, are packages of code that we can download, install, and use in Ruby programs or run from the command line. Gems are managed by the `gem` command, which comes installed with recent versions of Ruby (specifically, version 1.9 onward).
* Most Ruby projects use RubyGems as the distribution mechanism. A Ruby project must observe certain practices in order to be packaged as a Gem. This includes conforming to a common directory structure and maintaining a `.gemspec` file.

Gems include libraries, frameworks, and programs. There are thousands of Gems.

Gems are downloaded and installed by the `gem` command from a Remote Library, usually `rubygems.org`. Gems are installed in the Local Library. Where exactly the local library is within the file system depends on your Ruby installation type (whether you are using a Ruby version manager, and which one).

* Gems are downloaded by the `gem` command from a RubyGems remote library, usually `rubygems.org`. Gems are then installed in a local library, the precise location of which within the filesytem depends on the type of Ruby installation, especially whether we are using a Ruby version manager

`gem install [GEM_NAME]`

"When `gem` installs a Gem, it places the files that comprise the Gem on your local file system in a location where Ruby and your system can find the files and commands it needs. This is the local library."

`gem env` - prints a long list of information about your Ruby Gems installation. 



Summary:

"RubyGems provide a library of code that you can download and run or use directly inside your Ruby programs. You use the `gem` command to manage the Gems you need"

"RubyGems also provide the mechanisms you need to release your own Gems, which can either be packages of code you `require` into your Ruby programs, or independent ruby programs that you can run (e.g., the `bundle` program from the Bundler gem)"

(of course, a Gem might be a package containing both libraries we can use in our own Ruby programs AND programs to be executed in their own right)

"Ruby projects usually use the RubyGems format"



## Ruby Version Managers

"Ruby is an evolving languages with features added, changed, and removed with every new version. Eventually, you're going to write or use a Ruby program that needs a different version of Ruby, and that's when you will find that you need a Ruby version manager"

"Every new version has some changes; sometimes, programs that run on older versions of Ruby no longer work on more recent versions. Someday, you will need to install another version of Ruby without removing your current Ruby"

"Another reason to use Ruby version managers is when working on multiple applications. Software applications tend to standardize on a specific Ruby version in order to guarantee developers don't use unsupported language features. For example, you may be asked to help out with an existing project that has standardized on Ruby version 2.1, but your current local Ruby version is 2.3, which you need to work on your current projects. In that case, you will need the assistance of a Ruby version manager to help you manage and move between different Rubies as you switch between different projects"

"Ruby version managers let you manage multiple version of Ruby, the utilities (such as `irb`) associated with each version, and the RubyGems installed for each Ruby. With version managers, you can install and uninstall ruby versions and gems, and run specific versions of ruby with specific programs and environments"

* Ruby version managers are programs that allow us to install, manage, and utilize multiple versions of Ruby
* Since Ruby has features added, removed, or changed with each new release, eventually we will need to work with a program that requires a different version of Ruby, and that is when Ruby version managers are useful.
* Ruby version managers allow us to install an older version of Ruby without removing our current version.
* The two most common Ruby version managers are `RVM` and `rbenv`
* Ruby version managers allow us to work with multiple versions of the utilities associated with each Ruby version, as well as the different RubyGems installed for each Ruby. Version managers thus allow us to install and uninstall different versions of Ruby with different associated programs and environments

Benefits

* Installing an older Ruby without removing our current version is useful when we need to work with an older program that will not run on recent versions
* Software projects generall standardize on a particular version of a language. Therefore, if we need to work on multiple Ruby projects, all standardized on different versions of Ruby, Ruby version managers allow us to manage and move between multiple different Rubies as we switch between different projects



Summary:

"Ruby Version Managers help you manage multiple versions of Ruby on a single system. Each Ruby version has its own set of tools such as the `gem` and `bundle` commands"



## Bundler and `Gemfile`

"You may need to use [e.g.] Ruby 2.2.2 for two different projects ... but you may also need separate versions of the Rails Gem, say 4.2.7 for one project, and version 5.0.0 for the other. While both RVM and rbenv (with the aid of a plugin) can handle these requirements, the easier and more common path is to use a RubyGem called Bundler."

"Dealing with dependencies -- multiple versions of Ruby and multiple versions of Gems -- is a significant issue in Ruby. A project may need a Ruby version that differs from your default Ruby. Even if it requires the same version of Ruby, it may need a different version of a RubyGem."

"This problem is not unique to Ruby; dependency issues arise in all languages. The techniques used to deal with the dilemma differ with each language. In Ruby, most developers use a Ruby version manager such as RVM or rbenv to manage multiple Ruby versions. You can also use your version manager to manage Gem dependencies, but the favored approach is to use a **dependency manager**."

The most widely used dependency manager in the Ruby community, by far, is the Bundler Gem. This Gem lets you configure which Ruby and which Gems each of your projects need.

* Since Ruby 2.5, Bundler comes installed with the Ruby installation

`Gemfile` and `Gemfile.lock`

'Bundler relies on a text file named `Gemfile` to tell it which version of Ruby and its Gems it should use. This file is a simple Ruby program that uses a Domain Specific Language (DSL) to provide details about the Ruby and Gem versions. It's the configuration or instruction file for Bundler.

After you create `Gemfile`, the `bundle install` command scans it, downloads and installs all the dependencies listed, and produces a `Gemfile.lock` file. `Gemfile.lock` shows all the dependencies for your program; this includes the Gems listed in `Gemfile`, as well as the Gems they depend on (the dependencies), 

* Bundler uses a text file named `Gemfile` to know which version of Ruby and its Gems are needed for a particular project. The `Gemfile` is a configuration or instruction file for Bundler.
* The `Gemfile` is a Ruby program written in a DSL, which provides details to Bundler about the Ruby version and Gem versions used for a project
* When we run `bundle install`, Bundler scans the `Gemfile`, downloads and installs the dependencies listed, and produces a file called `Gemfile.lock`
* The `Gemfile.lock` file lists all the dependencies for the project, not only the Gems listed in the `Gemfile` but all of their dependencies (other Gems)



"It is very common for RubyGems you install for use in your project to rely on many other gems, creating a large dependency tree."

<u>Understanding `Gemfile.lock`</u>

Say we have the `Gemfile`,

```ruby
source 'https://rubygems.org'

ruby '2.3.1'
gem 'sinatra'
gem 'erubis'
gem 'rack'
gem 'rake'
```

Then this is the corresponding `Gemfile.lock` produced by `bundle install`:

```
GEM
  remote: https://RubyGems.org/
  specs:
    erubis (2.7.0)
    rack (1.6.4)
    rack-protection (1.5.3)
      rack
    rake (10.4.2)
    sinatra (1.4.7)
      rack (~> 1.5)
      rack-protection (~> 1.4)
      tilt (>= 1.3, < 3)
    tilt (2.0.5)

PLATFORMS
  ruby

DEPENDENCIES
  erubis
  rack
  rake
  sinatra

RUBY VERSION
   ruby 2.3.1p112

BUNDLED WITH
   1.13.6
```

The `specs` section under  the `GEM` heading provides a list of the Gems (and their versions) that your app will load. Beneath each listed Gem is a list of *the Gem's* dependencies; that is, the Gems and versions it needs to work.

We didn't have to provide any information about [e.g.] `rack-protection` and `tilt` in our `Gemfile`; Bundler found this information on its own by examining the `Gemfile`s for those Gems -- that is, not our application's `Gemfile`, but the `Gemfile` that came with the Gems specified in our `Gemfile`. It then added the information to our `Gemfile.lock`

In the `Gemfile.lock` notation, `>`, `>=`, `<`, and `<=` are obvious and combined in obvious ways. The notation that is not at all obvious, is the `~>` notation. This `~>` means 'equal to or greater than in the last digit'. Which is to say, greater than or equal to the named version but less than the version that rolls over the last digit (meaning only the last digit can vary). For example,

```
~> 2.3		# means (>= 2.3, < 3.0)
~> 2.3.0  # means (>= 2.3.0, < 2.4.0)
```





<u>Running Apps with Bundler</u>

Once Bundler creates your Gemfile.lock, add:

```ruby
require 'bundler/setup'
```

to the beginning of your app, meaning the first Ruby file that your application loads (the one with the launch code), before you `require` any other Gems. (This is unneeded if your app is a Rails app. For a Sinatra app, this would be the Ruby file where you `require 'sinatra'`).

`bendler/setup` first removes all Gem directories from Ruby's `$LOAD_PATH` global array. Ruby uses `$LOAD_PATH` to list the directories that it searches when it needs to locate a `require`d file. When `bundler/setup` removes those directories from `$LOAD_PATH`, Ruby can no longer find Gems.

To fix this, `bundler/setup` reads `Gemfile.lock`; for each Gem listed, it adds the directory that contains that Gem back to `$LOAD_PATH`. When finished, `require` only finds the proper versions of each Gem. This ensures that the specific Gem and version your app depends on is loaded, and not a conflicting version of that Gem.

Now, all you have to do is run your app and the correct Gem will be loaded when you `require` files.



Steps to using bundler

* Add remote Gem library, Ruby version, and Gems to `Gemfile`
* Run `bundle install` 
* Add `require 'bundler/setup'` to the launch file of your Ruby project (the first file loaded in the project) before any other `require` statement. This gives Bundler control over Ruby's `$LOAD_PATH` internal array, allowing Bundler to determine which versions of Gems are found when we `require` them. This means that only the specific version of a Gem that your overall project needs gets loaded, preventing the dependency conflicts that could arise otherwise.



`bundle exec`

"[A non-Rails app] that relies on Bundler should `require` the `bundler/setup` package before it loads any Gems. This package ensure that the app loads the desired Gems."

"Unfortunately, you will surely encounter situations where you can't just add `require 'bundler/setup'` to the code, or the program itself may run code that has conflicting needs. When this happens, you need the often mysterious `bundle exec` command."

"You can use `bundle exec` to run most any command in an environment that conforms to the `Gemfile.lock` versioning info"

You generally use `bundle exec` to run commands written in Ruby and installed as Gems, e.g. Rake, Pry, and Rackup. We use it to resolve dependency conflicts when issuing shell commands. For instance, if we run `rake` from the command line, the shell will load the version of Rake that is in the `PATH` shell variable. Rake sometimes runs commands that Bundler manages, and when this happens, Bundler will attempt to load the version of Rake specified in the `Gemfile`. If this is different to the version of Rake that is already running, this will result in a `Gem::LoadError`. To fix this, we can run Rake from the command line using `bundle exec rake` and the conflict will be solved.

It is good advice to simply always run `bundle exec rake` instead of just `rake`, but it is important to be aware that similar problems can happen with other Ruby command line applications and using `bundle exec` can solve those too.



`binstubs`

`binstubs` is an alternative to using `bundle exec`. It sets up a directory of short Ruby scripts (wrappers) with the same names as executables installed by your Gems. By default, `binstubs` names this directory as `bin`, but you should override that if your app also needs a `bin` directory of its own.

The scripts in the `binstubs`-provided directory effectively replace `bundle exec`; if you include the directory in your `PATH`, you can avoid using `bundle exec`. The scripts are generated by running `bundle install --binstubs`.

The `binstubs` feature only installs wrappers for the Gems listed by `Gemfile.lock` ... This can be an issue with Gems that you don't require in your apps, but use externally. For example, Rubocop and Pry.



* Bundler is a **dependency manager** for Ruby. Bundler lets you determine exactly which Ruby and Gem versions your project will use. It lets you install multiple versions of each Gem under a specific version of Ruby and ensures the correct Gem versions will be used in your app. Bundler thus prevents dependency conflicts.
* Bundler is a Gem, and since Ruby 2.5 it comes installed with Ruby. Bundler uses a text file named `Gemfile` to know which version of Ruby and its Gems are needed for a particular project. The `Gemfile` is a configuration or instruction file for Bundler. The `Gemfile` is a Ruby program written in a Domain Specific Language, which provides details to Bundler about the Ruby version and Gem versions used for a project.
* When using Bundler, we add `require 'bundler/setup'` before any other `require` statements in the first Ruby file loaded in our app. The `bundler/setup` package ensures the application loads the correct Gem versions/

* When we run `bundle install`, Bundler scans the `Gemfile`, downloads and installs the dependencies listed, and produces a file called `Gemfile.lock`. The `Gemfile.lock` file lists all the dependencies for the project, not only the Gems listed in the `Gemfile` but all of their dependencies (i.e. other Gems).
* The `bundle exec` command ensures that executable programs installed by Gems don't clash with our app's requirements.





3:4: Setting Up the `Gemfile`

'Once you've set up your project directory, you're ready to configure Bundler. Bundler uses a file named `Gemfile` to determine the dependencies of your project. The dependencies specified in this file will let other developers know how to run your project. It'll come in handy if we must deploy our project to run on another server; it will install all of our dependencies so we can use the project at the new site.'

* The `Gemfile` is Ruby code. It uses a DSL supplied by Bundler



'A `Gemfile` typically needs four main pieces of information:

* Where should Bundler look for RubyGems it needs to install?
* Do you need a `.gemspec` file?
* What version of Ruby does your program need? (Recommended, not required)
* What RubyGems does your program use?'



So these correspond to:

1. `source` statement - points Bundler to a Gem library, usually `rubygems.org`
2. `gemspec` statement - points Bundler to a `.gemspec` file if there is one
3. `ruby` statement - tells Bundler which Ruby version we will use, which is optional but recommended
4. RVM will also use this to switch to that Ruby version when we are in the project directory, though the `.ruby-version` file takes precedence
5. `gem` statements - tells Bundler what Gems and which versions the project needs







The Remote Library (`source`)

'Most projects find RubyGems at the official RubyGems site [`rubygems.org`]'

```ruby
source 'https://rubygems.org'
```



The `.gemspec` file (`gemspec`)

* A `.gemspec` file is a file with the information required to package and distribute a Ruby project as a Gem, with the file extension `.gemspec`. For example, `my_cool_project.gemspec`.
* When we are packaging a project as a Gem, we need to add the statement `gemspec` to our `Gemfile` after first creating a `.gemspec` file in the project's main directory. Then we need to run `bundle install`. Bundler only looks for a `.gemspec` file if there is a `gemspec` statement in the `Gemfile`.

Summary:

"The .gemspec file provides information about a Gem. If you decide to release a program or library as a Gem, you must include a `.gemspec` file"



The Ruby Version (`ruby`)

For example,  `ruby '3.1.0'`

"You must decide whether you want to support an older version of Ruby or a more recent version. Ideally, you should support the newest version, but this isn't always possible: some users may need to use older versions."

"If you omit [the Ruby version],  Bundler will use whatever version of Ruby it finds by default"



The Gems (`gem`)

Lastly, you must decide which Gems your program needs. You can look through the `require` statements in all Ruby code used in the project and if necessary, match the names used in the `require` statements with the names of the Gems they actually come from (looking through the Gem directories should let you know). E.g., the statement `require 'minitest/reporters'` loads the `minitest-reporters` Gem, and `require 'minitest/autorun'` makes use of the `minitest` Gem. We can search the Gems directories for `minitest/autorun.rb` and find it under e.g. the `...gems/minitest-5.10.1/lib` directory. These directory names tell us the Gem name and the version number we are currently using.

We then list these names in the `Gemfile` using the `gem` statement:

```ruby
gem 'minitest', '~> 5.10'
gem 'minitest-reporters', '~> 1.1'
```

We specify version numbers for our Gems using the same syntax as the `ruby` statement. For instance, `'~> 5.10'` tells Bundler that we want a version of at least 5.10 of `minitest`, but prior to version `6.0`. Depending on your requirements, you can omit the version number, or be more or less specific about the version you want. The `'~>'` version info, though, is typically the best choice to prevent version compatibility issues.

* If we later add more Gems to our project, we must add them to the `Gemfile` and run `bundle install` again.





After we have run `bundle install`, we must tell each Ruby program in our project to use Bundler by adding `require 'bundler/setup'` to all our main program files, before any other `require` statement. (For instance, whichever file is loaded first for a particular Ruby program. A test suite file, for instance, needs its own `require 'bundler/setup'`, as well as the launch file for an app, etc.)

Note:

It is easy to see the names `Gemfile` and `Gemfile.lock` and assume these files must be part of RubyGems. Bundler uses both files; it depends on `Gemfile` to provide information on the Gems your project uses, and it creates `Gemfile.lock` based on that. If you ever create your own RubyGem, you will probably use Bundler, but you don't have to. Hence, you don't need `Gemfile` or `Gemfile.lock` to create a RubyGem. Similarly, we don't actually need to use Bundler to use Gems, though for anything but small projects, Bundler is extremely useful for avoiding dependency conflicts.

Bundler will download and install any Gems (or versions of Gems) listed in the `Gemfile` that are not already installed on the system.



Summary:

"Bundler provides the tools you need to describe the dependencies for your Ruby programs. This makes it easy to distribute your program to other systems: Bundler installs all the necessary components, and even ensures that the program uses the correct version of each Gem"





## Rake

"Rake is a RubyGem that automates many common functions required to build, test, package, and install programs; it is part of every modern Ruby installation, so you don't need to install it yourself."

Common Rake tasks you may encounter:

* Set up required environment by creating directories and files
* Set up and initialize databases
* Run tests
* Package your application and all of its files for distribution
* Install the application
* Perform common Git tasks
* Rebuild certain files and directories (assets) based on changes to other files and directories

"You can write Rake tasks to automate anything you may want to do with your application during the development, testing, and release cycles"



* Rake is a RubyGem installed with the Ruby installation that allows us to automate tasks required to build, test, package, and install Ruby programs. we can write Rake tasks to automate anything we need to for the development, testing, and release cycles of an application.

"Rake uses a file named `Rakefile` that lives in your project directory; this file describes the tasks that Rake can perform for your project, and how to perform those tasks."

```ruby
desc 'Say hello'
task :hello do
  puts "Hello there. This is the `hello` task."
end

desc 'Say goodbye'
task :bye do
  puts 'Bye now!'
end

desc 'Do everything'
task :default => [:hello, :bye]
```

This `Rakefile` contains three **tasks**: two that simply display a single message, and one task that has the other tasks as **prerequisites** or **dependencies**. The first two tasks are named `:hello` and `:goodbye`, while the final task is the **default task**; Rake runs the default task if you do not provide a specific task name when you invoke Rake.

Each of the above tasks calls two Rake methods: `desc` and `task`. The `desc` method provides a short description that Rake displays when you run `rake -T` and the `task` method associates a name with either a block of Ruby code or a list of dependencies. Here, the `:default` task depends on the `:hello` and `:bye` tasks: when you run the `:default` task, Rake will run the `:hello` and `:bye` tasks first.

We can find out what tasks a Rakefile can run by executing `rake -T`

"One very important thing to notice is that `Rakefile` is actually a Ruby program. You can put any Ruby code you want in a `Rakefile` and run it as part of a task. Commands like `desc` and `task` are just method calls to parts of Rake; these method calls comprise a Domain Specific Language (DSL) for writing automated Rake tasks."

* We define automated Rake tasks in the `Rakefile` using a DSL that consists of methods such as `desc` and `task`
* We can discover what tasks a `Rakefile` can perform by executing `rake -T`
* We will often have to run `bundle exec rake` rather than just `rake` to ensure the correct version of Rake for a given project is invoked

Benefits

"One reason why you need rake is that nearly every Ruby project you can find has a `Rakefile`, and the presence of that file means you need to use Rake if you want to work on that project."

"Every project that aims to produce a finished project that either you or other people intend to use in the future has repetitive tasks the developer needs."

"Run all tests associated with the program"

"Increment the version number"

"Create your release notes"

"Make a complete backup of your local repo"

"Each step is easy enough to do manually, but you want to make sure you execute them in the proper order... You also don't want to be at the mercy of arbitrary typos that may do the wrong thing. It's far better to have a way to perform these tasks automatically with just one command, which is where Rake becomes extremely useful."

* Many tasks commonly performed by Rake are sensitive to the order in which steps are carried out, and mistakes or typos at the command line can have serious consequences. Rake allows us to reduce the chance of errors by automating these tasks. And since nearly every existing Ruby project has a `Rakefile`, Ruby developers need to know how to work with Rake.



Summary:

"Rake provides a way to easily manage and run repetitive tasks that a developer needs when working on a project"





## Overall relationships

"Your Ruby version manager is at the top level -- it controls multiple installations of Ruby and all the other tools."

"Within each installation of Ruby, you can have multiple Gems -- even 1000s of Gems if you want. Each Gem becomes accessible to the Ruby version under which it is installed. If you want to run a Gem in multiple versions of Ruby , you need to install it in all of the versions you want to use it with."

"Each Gem in a Ruby installation can itself have multiple versions. This frequently occurs naturally as you install updated Gems, but can also be a requirement; sometimes you just need a specific version of a Gem for one project, but want to use another version for your other projects."

"Ruby projects are programs and libraries that make use of Ruby as the primary development language. Each Ruby project is typically designed to use a specific version (or versions) of Ruby, and may also use a variety of different Gems."

"The Bundler program is itself a Gem that is used to manage the Gem dependencies of your projects. That is, it determines and controls the Ruby version and Gems that your project uses, and attempts to ensure that the proper items are installed and used when you run the program."

Finally, Rake is another Gem. It isn't tied to any one Ruby project, but is, instead, a tool that you use to perform repetitive tasks, such as running tests, building databases, packaging and releasing the software, etc. The tasks that Rake performs are varied, and frequently change from one project to another; you use the `Rakefile` file to control which tasks your project needs.



So the Ruby version manager and RubyGems package manager are responsible for getting Rubies and packages of Ruby code onto your system to use.

Bundler and Rake manage aspects of individual Ruby projects. Bundler manages the dependencies required by a project to avoid version conflicts, and Rake automates tasks at every stage of the development, testing, and release phases of a project.



Bundler and Rake working in tandem can make it easy to package and release our project as a RubyGem.

















