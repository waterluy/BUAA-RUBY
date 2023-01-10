# rails s启动过程分析

## 1 Rails引导和初始化过程

### 1.1 rails 可执行文件

`rails server` 命令中的 `rails` 是位于加载路径中的一个 Ruby 可执行文件。这个文件包含如下内容：

```ruby
version = ">= 0"
load Gem.bin_path('railties', 'rails', version)
```

上面代码会加载 `railties/exe/rails` 文件，`railties/exe/rails` 文件的部分内容如下：

```ruby
require "rails/cli"
```

`railties/lib/rails/cli` 文件又会调用 `Rails::AppLoader.exec_app` 方法。

`exec_app` 方法的主要作用是执行**应用**中的 `bin/rails` 文件。如果在当前文件夹中未找到 `bin/rails` 文件，就会继续在上层文件夹中查找，直到找到为止。因此可以在 Rails 应用中的任何位置执行 `rails` 命令。

执行 `rails server` 命令时，实际执行的是等价的下述命令：

```ruby
exec ruby bin/rails server
```

### 1.2 bin/rails.rb 文件

此文件包含下面内容：

```ruby
#!/usr/bin/env ruby
APP_PATH = File.expand_path("../config/application", __dir__)
require_relative "../config/boot"
require "rails/commands"
```

其中 `APP_PATH` 常量将在 `rails/commands` 中使用。所加载的 `config/boot` 是应用中的 `config/boot.rb` 文件，用于加载并设置 Bundler。

### 1.3 config/boot.rb 文件

Gemfile 把所需要的gem包和它们的版本列出来，rails工程就依赖这些特定版本的包。`config/boot.rb` 文件会把 `ENV['BUNDLE_GEMFILE']` 设置为 `Gemfile` 文件的路径。如果 `Gemfile` 文件存在，就会加载 `bundler/setup`，Bundler 通过它设置 Gemfile 中依赖关系的加载路径，以便后续 require。

此文件包含如下内容：

```ruby
ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.
require "bootsnap/setup" # Speed up boot time by caching expensive operations.
```

### 1.4 rails/commands.rb 文件

执行完 `config/boot.rb` 文件，下一步加载 `rails/commands`，其作用是解析 rails 命令参数，根据不同的参数执行不同的任务。

```ruby
ARGV << '--help' if ARGV.empty?

aliases = {
  "g"  => "generate",
  "d"  => "destroy",
  "c"  => "console",
  "s"  => "server",
  "db" => "dbconsole",
  "r"  => "runner",
  "t"  => "test"
}

command = ARGV.shift
command = aliases[command] || command

require 'rails/commands/commands_tasks'

Rails::CommandsTasks.new(ARGV).run_command!(command)
```

 `run_command!` 函数调用 server 方法，server 方法首先设置应用程序目录，即包含 config.ru 文件的目录。然后加载 `Rails::Server` 模块。然后加载 APP_PATH。

### 1.5 config/application.rb 文件

 `config/application.rb` 文件加载了 rails 的全部组件 `require "rails/all"`，并定义了我们自己的 rails 应用程序类，如 `class Application < Rails::Application`，然后调用 `server.start` 方法启动服务器。start 方法如下：

```ruby
def start
  print_boot_information
  trap(:INT) { exit }
  create_tmp_directories
  setup_dev_caching
  log_to_stdout if options[:log_stdout]
 
  super
  ...
end
 
private
  def print_boot_information
    ...
    puts "=> Run `rails server -h` for more startup options"
  end
 
  def create_tmp_directories
    %w(cache pids sockets).each do |dir_to_make|
      FileUtils.mkdir_p(File.join(Rails.root, 'tmp', dir_to_make))
    end
  end
 
  def setup_dev_caching
    if options[:environment] == "development"
      Rails::DevCaching.enable_by_argument(options[:caching])
    end
  end
 
  def log_to_stdout
    wrapped_app # 对应用执行 touch 操作，以便设置记录器
 
    console = ActiveSupport::Logger.new(STDOUT)
    console.formatter = Rails.logger.formatter
    console.level = Rails.logger.level
 
    unless ActiveSupport::Logger.logger_outputs_to?(Rails.logger, STDOUT)
    Rails.logger.extend(ActiveSupport::Logger.broadcast(console))
  end
```

这是 Rails 初始化过程中第一次输出信息。`start` 方法为 `INT` 信号创建了一个陷阱，只要在服务器运行时按下 `CTRL-C`，服务器进程就会退出。上述代码会创建 `tmp/cache`、`tmp/pids` 和 `tmp/sockets` 文件夹。然后，如果运行 `rails server` 命令时指定了 `--dev-caching` 参数，在开发环境中启用缓存。最后，调用 `wrapped_app` 方法，其作用是先创建 Rack 应用，再创建 `ActiveSupport::Logger` 类的实例。

`super` 方法会调用 `Rack::Server.start` 方法，后者的定义如下：

```ruby
def start &blk
  if options[:warn]
    $-w = true
  end
 
  if includes = options[:include]
    $LOAD_PATH.unshift(*includes)
  end
 
  if library = options[:require]
    require library
  end
 
  if options[:debug]
    $DEBUG = true
    require 'pp'
    p options[:server]
    pp wrapped_app
    pp app
  end
 
  check_pid! if options[:pid]
 
  # Touch the wrapped app, so that the config.ru is loaded before
  # daemonization (i.e. before chdir, etc).
  wrapped_app
 
  daemonize_app if options[:daemonize]
 
  write_pid if options[:pid]
 
  trap(:INT) do
    if server.respond_to?(:shutdown)
      server.shutdown
    else
      exit
    end
  end
 
  server.run wrapped_app, options, &blk
end
```

最后一行中的 `server.run` 调用 `wrapped_app` 方法，会读取 `config.ru` 文件的内容，并使用如下代码解析：

```ruby
app = new_from_string cfgfile, config
 
...
 
def self.new_from_string(builder_script, file="(rackup)")
  eval "Rack::Builder.new {\n" + builder_script + "\n}.to_app",
    TOPLEVEL_BINDING, file, 0
end
```

`Rack::Builder` 类的 `initialize` 方法会把接收到的代码块在 `Rack::Builder` 类的实例中执行，Rails 初始化过程中的大部分工作都在这一步完成。在 `config.ru` 文件中，加载 `config/environment.rb` 文件的这一行代码首先被执行：

```ruby
require_relative 'config/environment'
```

### 1.6 `config/environment.rb` 文件

`config.ru` 文件需要加载此文件。此文件以加载 `config/application.rb` 文件开始：

```ruby
require_relative 'application'
```

### 1.7 `config/application.rb` 文件

此文件会加载 `config/boot.rb` 文件：

```ruby
require_relative 'boot'
```

## 2 加载 Rails

`config/application.rb` 文件的下一行是：

```ruby
require 'rails/all'
```

###  2.1 railties/lib/rails/all.rb 文件

此文件负责加载 Rails 中所有独立的框架，这些框架加载完成后，就可以在 Rails 应用中使用了。Rails 的常见功能都在这里定义好。

### 2.2 回到 config/environment.rb 文件

`config/application.rb` 文件的其余部分定义了 `Rails::Application` 的配置，当应用的初始化全部完成后就会使用这些配置。当 `config/application.rb` 文件完成了 Rails 的加载和应用命名空间的定义后，程序执行流程再次回到 `config/environment.rb` 文件。在这里会通过 `rails/application.rb` 文件中定义的 `Rails.application.initialize!` 方法完成应用的初始化。

### 2.3 railties/lib/rails/application.rb 文件

`initialize!` 方法的定义如下：

```ruby
def initialize!(group=:default) #:nodoc:
  raise "Application has been already initialized." if @initialized
  run_initializers(group, self)
  @initialized = true
  self
end
```

一个应用只能初始化一次。`railties/lib/rails/initializable.rb` 文件中定义的 `run_initializers` 方法负责运行初始化程序：

```ruby
def run_initializers(group=:default, *args)
  return if instance_variable_defined?(:@ran)
  initializers.tsort_each do |initializer|
    initializer.run(*args) if initializer.belongs_to?(group)
  end
  @ran = true
end
```

`run_initializers` 方法的代码比较复杂，Rails 会遍历所有类的祖先，以查找能够响应 `initializers` 方法的类。对于找到的类，首先按名称排序，然后依次调用 `initializers` 方法。例如，`Engine` 类通过为所有的引擎提供 `initializers` 方法而使它们可用。

`railties/lib/rails/application.rb` 文件中定义的 `Rails::Application` 类，定义了 `bootstrap`、`railtie` 和 `finisher` 初始化程序。`bootstrap` 初始化程序负责完成应用初始化的准备工作（例如初始化记录器），而 `finisher` 初始化程序（例如创建中间件栈）总是最后运行。`railtie` 初始化程序在 `Rails::Application` 类自身中定义，在 `bootstrap` 之后、`finishers` 之前运行。

应用初始化完成后，程序执行流程再次回到 `Rack::Server` 类。在 `Server#start` 方法定义的最后一行代码中，通过 `wrapped_app` 方法调用了 `build_app` 方法。

```ruby
server.run wrapped_app, options, &blk
```

`server.run` 方法的实现方式取决于我们所使用的服务器，这也是 Rails 初始化过程的最后一步。
