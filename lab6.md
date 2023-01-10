# rails相关gem功能调研

## activejob

Active Job 用来声明任务，并把任务放到多种多样的队列后台中执行的框架。从定期地安排清理，费用账单到发送邮件，任何事情都可以是任务。任何可以切分为小的单元和并行执行的任务都可以用 Active Job 来执行。

Active Job 的主要目的是确保所有的 Rails 程序有一致任务框架，即便是以 “立即执行”的形式存在。然后可以基于 Active Job 来新建框架功能和其他的 RubyGems， 而不用担心多种任务后台。之后，选择队列后台更多会变成运维方面的考虑，这样就能切换后台而无需重写任务代码。

## activemodel

Active Model是一个库，其中包含用于开发需要Active Record上的某些特性的类的各种模块。例如，`ActiveModel::API`增加了类使用Action Pack和Action View的能力；`ActiveModel::AttributeMethods`模块可以在类的方法上添加自定义前缀和后缀。它通过定义前缀和后缀以及对象上的哪些方法将使用它们来实现功能；`ActiveModel::Callbacks`提供活动记录样式的回调。这提供了定义在适当时间运行的回调的能力。定义回调后，可以用before、After和around自定义方法包装它们等等。

## activerecord

Active Record 是 MVC中的 M（模型），处理数据和业务逻辑。Active Record 负责创建和使用需要持久存入数据库中的数据。Active Record 实现了 Active Record 模式，是一种对象关系映射系统。在 Active Record 模式中，对象中既有持久存储的数据，也有针对数据的操作。Active Record 模式把数据存取逻辑作为对象的一部分，处理对象的用户知道如何把数据写入数据库，以及从数据库中读出数据。

Active Record 的重要功能如下：

- 表示模型和其中的数据；
- 表示模型之间的关系；
- 通过相关联的模型表示继承关系；
- 持久存入数据库之前，验证模型；
- 以面向对象的方式处理数据库操作；

## activesupport

Active Support 是 Ruby on Rails 的一个组件，可以用来添加 Ruby 语言扩展、工具集以及其他这类事物。它从语言的层面上进行了强化，既可起效于一般 Rails 程序开发，又能增强 Ruby on Rails 框架自身。

除非把`config.active_support.bare`设置为 true, 否则 Ruby on Rails 的程序会加载全部的 Active Support。这样程序只会加载框架为自身需要挑选出来的扩展，同时也可像上文所示，可以从任何级别加载特定扩展。

## actionmailer

Rails 使用 Action Mailer 实现发送邮件功能，邮件由邮件程序和视图控制。邮件程序继承自 `ActionMailer::Base`，作用和控制器类似，保存在文件夹 `app/mailers` 中，对应的视图保存在文件夹 `app/views` 中。

## actionpack

Action Pack是一个处理和响应web请求的框架。它提供了路由机制（将请求URL映射到操作）、定义实现操作的控制器以及生成响应。简而言之，Action Pack提供了MVC范例中的控制器层。

它由几个模块组成：

+ Action Dispatch解析有关web请求的信息，处理用户定义的路由，并执行与HTTP相关的高级处理，例如MIME类型协商，解码POST、PATCH或PUT主体中的参数，处理HTTP缓存逻辑、cookie和会话。
+ Action Controller，它提供了一个基本控制器类，可以将其子类化以实现过滤器和操作来处理请求。操作的结果通常是从视图生成的内容。

使用Ruby on Rails框架，用户只能直接与Action Controller模块交互。默认情况下，会激活必要的Action Dispatch功能，动作视图呈现由动作控制器隐式触发。然而，这些模块设计为独立运行，可以在Rails之外使用。

## actionview

Action View 和 Action Controller 是 Action Pack 的两个主要组件。在 Rails 中，请求由 Action Pack 分两步处理，一步交给控制器（逻辑处理），一步交给视图（渲染视图）。一般来说，Action Controller 的作用是和数据库通信，根据需要执行 CRUD 操作；Action View 用来构建响应。

Action View 模板由嵌入 HTML 的 Ruby 代码编写。为了保证模板代码简洁明了，Action View 提供了很多帮助方法，用来构建表单、日期和字符串等。

每个控制器在 `app/views` 中都对应一个文件夹，用来保存该控制器的模板文件。模板文件的作用是显示控制器动作的视图。


