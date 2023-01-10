 

# ruby case equality operator

`===` 是 case equality operator，用于判断两个对象的相等性，主要用在case...when...语句中判断分支是否匹配。

```ruby
case expression
   when match1 then
       code
   when match2 then
       code
   ...
   when matchn then
       code
   else
       code
end
```

即上述代码等同于：

```ruby
if match1 === expression then
    code
elsif match2 === expression then
    code
...
elsif matchn === expression then
    code
else
    code
end
```

`===` 判断相等的规则是：符号右边的对象能否被包含到左边对象所表示的含义范围内，如果能则返回`true`，否则返回`false`。

### 实验验证

+ 数字比较

```ruby
145 === 145						# => true
2.0 === 2.0						# => true
2 === 2.0						# => true
2.0 ===2						# => true
```

数字比较时不考虑数字类型，**只比较数值**是否相等，与 `==` 相同。符合`===` 判断相等的规则。

+ 字符串比较

```ruby
"acd" === "acd"					# => true
"hello" === "hello world"		# => false
```

+ 数组和哈希比较

```ruby
[1, 4, 6] === [1, 4, 6]			# => true
[1, 4, 5] === [1, 5, 4]			# => true
[1, 4, 5, 6] === [1, 4, 5]		# => false

{1 => 2, 3 => 4} === {3 => 4, 1 => 2}			# => true
{1 => 2, 3 => 4, 5 => 6} == {1 => 2, 3 => 4} 	# => false
```

数组相等时要求数组内元素个数和顺序都相同，哈希相同时只要求键值对的个数以及对应关系相同，与顺序无关。

这些情况 `===` 都和 `==` 含义相同，即判断值的相等，若值相等，则右边的对象自然可以包含到左边对象表示的含义范围内。



+ 比较对象是否是类的实例

```ruby
String === "abcd"				# => true
"hhhh" === String				# => false
Integer === 23					# => true
23 === Integer					# => false
Symbol === :s					# => true
Array === [1,2,3]				# => true
```

当左侧是类名，右侧是该类的实例时，返回 `true`，否则返回 `false`。

+ 比较范围

```ruby
(1..5) === 2					# => true
('a'..'z') === 'c'				# => true
(2...10) === 10					# => false
```

当右侧的值在左侧的范围内时返回 `true`，否则返回 `false`。

+ 字符串匹配

```ruby
/[olleh]*/ === "hello"			#  => true
/[a]+/ === "hhh aa hhh"			#  => true
/^hello/ === "hello world~"		#  => true
```

当字符串匹配左侧的正则表达式时返回 `true`，否则返回 `false`。

+ 符号

```ruby
:abc === :abc					#  => true
:abcd === :abc					#  => true
:abc === "abc"					#  => false
"abc" === :abc					#  => false
```

符号和字符串比较时，`===` 和 `==` 相同


