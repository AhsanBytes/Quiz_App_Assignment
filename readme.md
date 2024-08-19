for vs while loop
Ans: we use for loop when we have fixed number of iterations and use while when don't know exact number of iterations.

integers comaprsion with other data types, to_i vs Integer, type of Integer
Ans: to_i and to_f tries to convert as much as possible, while FLOAT and INTEGER classes are more strict and they accept keyword argument exception.

length vs size method
Ans: length is a method of String class, while size is a method of Array class.

slice method
Ans: It is used to slice in array and string. In array we can use slice(start, length), but in String we can use slice(index_or_regex_range)

escape characters, double quotes, single quotes
Ans: Ruby has default double quotes, if you use single or double quotes, it returns double quotes result. Double quote translate the escape chars(\n, #{}) to newline, while in single quote it shows as it is. Double quotes also translates interpolation. %() and %Q behaves like double quotes. While %q behaves like single quote.

heredoc
Ans: Heredoc is a way to define multi-line strings in Ruby. It allows for easier formatting and readability of large text blocks instead of file or writing test cases for codes. It allows interpolation and you can disable interpolation by encapsulating the name with single quote. Its name should be string. <<- ignores identation at closing tag/name of heredoc. <<~(Squiggly) and heredoc. strip is similar in functionality but it will be used after heredoc defining. %Q is a way to create a string with double-quoted behavior, meaning it supports interpolation and escape sequences.

Chomp is used to remove escape characters from a string.

const updates
Ans: const can be updated in ruby, but gives warning

times with_index, index of times
Ans: Yes we can get the get times in a temp variable |i|, and also with with_index

-99.step(-80, -5) {|i| print i, " "}, 1.upto(5) {|i| print i, " "}, 'a'.upto('c') {|i| print i, " "}, upto, downto 
Ans: If in upto and downto values are reverse, then it only print first one. And step problem still here

.with_index and _with_index, and where it can be used, times, untill?/
Ans: _with_index is bit faster than .with_index. and .with_index takes a optional starting index parammter

& vs && vs AND
Ans: & is binary operator and && is logical operator with higher precendence, and (and) is also lgical operator with lower precendence used for control flow.

x ||= 5, |, ||, or
Ans: | is bitwise operator and can also be used to add arrays with unique element(union of arrays), || and or are logical operators but || has high precedence than or.
and x ||= 5 is equal to x = x || 5.

?(predicate) and !(bang) difference methods
Ans: ? is used to find in string something and return true or false. bang method the method will modify the object it's called on. Ruby calls these as "dangerous methods" because they change state that someone else might have a reference to.

join()
Ans: delete use to delete first element in string or array

hash.fetch method
Ans: It takes keys as parameter and give error if not found, you can use block to give operations or errors, can also do default values. 

Strings vs Symbols.
Ans: Strings are modifiable but symbols are not.

%w vs %W vs []
Ans: %W has string interpolation and can have special/escape character. while %w don't have interpolation and escape characters. [] can have words, chars, integers or anything. %w and %W has only strings

Can we use each iterator over a hash?
Yes, we can use

Block vs function?
Blocks are anonymous pieces of code that can be passed to methods. They are not objects and cannot exist on their own. While Methods are defined with a name and can be called using that name. They are objects and can take arguments and return values.

Time.now vs Time.zone.now
Ans: time.now gives you current time of system or local machine in both ruby and rails, time.zone.now is rails-specific method that returns current configured in rails app.

let time = Time.now. How can I get list of available methods on this time object?
yes, time.methods

module A
  def say_hello
    puts 'Hello from module'
  end
end
class B
  include A
  def say_hello
    puts 'Hello from B'
  end
end
class C
 def say_hello
   puts 'Hello from C'
 end
 include A
end
B.new.say_hello => ?
C.new.say_hello => ?
Ans: It both calls class hello first, if not present then modules hello

use of Bitwise and operator?
Ans: Provide low-level control over individual bits, are efficient for performance-critical tasks, and are used in specific applications like flags, encryption, and custom data structures.

x = true && false
y = true and false
x = 20
x ||= 10
puts x => ?

Multiple Inheritance vs Multi level Inheritance. Which one is supported in ruby?
Multiple inheritance is not supported in ruby. Multi level inheritance is  supported in ruby.

Why we need to use modules as same functionality can be achieved by inheritance?
Ans: Inheritance don't allow multiple inheritance, we can use modules for that.

send vs public_send
Ans: send and public_send are used to get protected and private method call and public_send only call public method. One thing imp, if we have methods with same name, then it will call last one/

include vs extend vs prepend.
Ans: extend: Adds module methods as singleton methods on the specific instance. It overrides instance methods for that instance.
include: Adds module methods as instant methods in the class, which means the methods are mixed into the class and its instances.
prepend: Adds module methods before the class methods in the method lookup path, giving module methods precedence.

Use of freeze? Can we freeze integers and symbols?
Ans: We can call freeze on string, array, hashes and constants. And int and symobls are by default immutable, so no effect on them. It guranatee immutability but allows reassigning.

hash = Hash.new([])
hash[:key1] << 20
puts hash[:key1]  => ?
puts hash[:key2]  => ?
Ans: We are setting default value of hash key which even don't exist, and when we change value, the default value changes, and when access a non-existed key, it returns default value. So ans is 20, 20.
And better approach is to make it like this: 
hash = Hash.new { |hash, key| hash[key] = [] }, it makes different arrays for each key

<< is used to add element or array to other array or string.

Will to_stdout will work in specs if we use print, p?
Ans: 

expect() vs expect{}
Ans:

Is there any alternative of to_stdout?
Ans:

Benefits of freeze. How does it effect memory?
Ans: Prevents object from modification which lead to performance improvement by avoiding unnecessary allocations.

Can we use ensure without begin?
Ans: No, it must be used with begin ensure end.

Why inject method supports block instead of method? Blocks vs Methods
Ans: Blocks provide more flexibility in defining inline logic.

Is it possible to nest multiple it blocks?
Ans: No, separate blocks in RSpec

super vs self
Ans: Super calls the same method from parent(super) class, while self calls the current object.

what is class of key 'a b' in hash { 'a b': 'a' }?
Ans: Class is Symbol, {'a b': 'a'}.keys.first.class

Section 3.3 => Call a private method with explicit receiver in ruby?
Ans: No, private methods cannot be called with an explicit receiver. But we can use send function to get private methods.

use of inject method.
Ans: Used for aggregration operations. 
[1, 2, 3].inject(0) { |sum, num| sum + num } # => 6

%Q and %W.
Ans: %Q creates double quoted string. While %W creates an array of strings using double quotes for interpolation.
%Q{Hello #{name}} # => "Hello Bob"
%W[hello #{name}] # => ["hello", "Bob"]

Use of freeze. How does it work?
Ans: Prevents modification. Every object has its object_id.

How to run specific block of code only if there are no errors raised.
Ans:  begin
        # code that might raise an error
      rescue
        # handle error
      else
        # code to run if no errors
      ensure
        # code that always runs
      end

class A
  @@name =  'abc'
end
A.instance_variable_get(@@name) => ?
Ans: Not work, have to make getter function

class A
 @@name 
end
A.instance_variable_get(@@name) => ?  
Ans: No, have to make getter function

class B
 @name1
end
B.instance_variable_get(:@name1) => ?
Ans:  Work, but gives no output bcz unintialized

How instance_variable_get method works?
Ans: Retrieves the value of instance

How Ruby Garbage Collector works?
Ans: Ruby uses a mark-and-sweep garbage collector to manage memory. It tracks objects that are no longer referenced and reclaims that memory.

Why we need blocks. Same functionality can be achieved by methods.
Ans: Blocks allow us to pass chunks of code to methods for execution

str1 = '00#003'. How can we replace first 2 zeros
Ans: str1 = '00#003', str1.sub(/^00/, '') # => "#003"

Is it possible to nest multiple it blocks(RSpec).
Ans: No, separate blocks

super vs super() vs super(a, b)
Ans: super: Call method with same arguments
     super(): Call method and don't pass arguments
     super(a, b): Call method with specific arguments

String vs Symbols
Ans: String are mutable while symbols are immutable.

Can we insert values in hash with integer, Float, String as key e.g, hash1 = { 1: 'abc' }
Ans: Yes

How can we check that a key is present in hash?
Ans: hash.key?(:a) or hash.has_key?(:a)

Why there is need of a block (we can use a method instead of a block)?
Ans: Blocks allow inline code to be passed and executed.
def my_method
  yield if block_given?
end
my_method { puts "Hello" }

How to pass values to a block?
An: def my_method
      yield(5) if block_given?
    end
    my_method { |num| puts num }

How to return a value from block?
Ans: Implicit return: The last expression in the block is returned.
result = [1, 2, 3].map { |num| num * 2 } # => [2, 4, 6]

How to access the class variables?
Ans: class Example
      @@var = "value"
      def self.var
        @@var
      end
    end
    Example.var

Types of loops?
Ans: for, while, each, until

map vs each
Ans: map returns a new array with the results. While each Iterates and returns the original array.

Difference between private and protected methods?
Ans: Private: Cannot be called with an explicit receiver. 
Protected: Can be called with self or other instances of the same class.

How to access a private method with arguments?
Ans: example.send(:private_method, "hello")

Can we achieve Multi-level inheritance in ruby?
Ans: Yes, it suppots multi-level inheritance.

what does the gsub method do?
Ans: Replaces all occurrences of a pattern with a replacement,
"hello".gsub(/l/, "x") # => "hexxo"

Alternative of try in ruby?
Ans: Using safe navigation operator &. (obj&.method)

raise and rescue? How can we raise an error?
Ans: begin
      raise "error"
    rescue => e
      puts e.message
    end

How to ensure that specific block of code should run whether there is exception or not?
Ans: use ensure also with begin rescue else ensure end.

How to check that a specific method is defined in class or not?
Ans: example.respond_to?(:my_method) # => true

Use of %q, %w, %i.
Ans: %q{} single quotes string (not interpolation and escape characters),
%w[] array of strings without interpolation (double quoted)
%i[] array of symbols without interpolation

use of freeze.
Ans: Prevents modification

let's say a = 1,How can we check which methods are available to variable a?
Ans: a.methods

How to write an if condition in one line(without using end keyword)?
Ans: puts "heloo" if num = 0

Difference between tertary operator and single line if condition?
Ans: ternary operator: condition ? "true" : "false"
single line if condition: puts "hello" if condition, Executes only if condition is true.

Use of unless keyword?
Ans: this is negative 'if'
puts "Not true" unless condition

Use of until ?
Ans: 

before each, before all, before do (RSpec)
Ans:

expect() vs expect{} in RSpec
Ans:

Can we replace context keyword with it?
Ans:

Default value of subject? How it's populated in it block?
Ans:

described_class and describe in RSpec.
Ans:

Is there any way to pass this spec:
result = cal.sub(5, 2)
expect(result).to eql(3.0)
Ans:

attr_accessor vs  attr_reader vs attr_writer.
Ans:

How can we split an array, retrieve specific values from the array.
Ans:

Can we convert a string to integer?
Ans:

Difference between def method_name, def method_name? and def method_name!.
Ans:

What does class.ancestors returns?
Ans:

Difference between && and and.
Ans:

Why do we need to write test cases? Do you believe writing them and covering all edge cases adds extra effort? If we have already handled all edge cases in the code, do we still need to write test cases?
Ans:

Use of single splat operator * and double splat operator **.
Ans: 

Difference between include and extend ?
Ans:

Use of rescue?
Ans: 

Can we call a private method outside of class?
Ans: Yes, ClassName.class_variable_get(:@@class_var).

What is parent class of nil.
Ans: nil.class = NilClass, nil.class.superclass = Object, nil.class.superclass.superclass = BasicObject, nil.class.superclass.superclass.superclass = nil

what does ancestors method returns?
Ans: Purpose: The ancestors method returns the method lookup path for a class or module. For module, it only shows modules included.
Output: An array of modules and classes, starting with the class/module itself, followed by included modules, its superclass, and all the way up to BasicObject.

Strings vs Symbols, advantage of making string immutable
Ans: Strings are mutable, every instance is unique. Each time string made (even with same content) new object is allocated in memory. Slower performance due to each char check. to_sym convert to symbol.
     While symbols are immutable, once a symbol is created, same object is reused. Comparison is faster bcz they check object ids. to_s convert to string.

How to access a value from hash by symbol key?
Ans: When we write symbol as a key in hash, we write symbol_key: value, and to access it we use hash[:symbol_key]

Is there any way to get class variables without adding a getter method?
Ans: Yes, puts A.class_variable_get(:@@name), for class variable you have to write in symbol form. 

Error handling in ruby. begin, rescue, raise & ensure else end.
Ans: We can also use raise to achieve same function as throw. Begin contains code that has error chances. Rescue has conditions if error cames, ensure always work no matter error comes or not, else code runs when their is no error and end is closing of begin.

Implicit receiver vs Explicit receiver.
Ans: self.obj is explicit receiver (self) and obj is implicit receiver.

Method calling other method
Ans: If a method is calling other method and you are consuming the implicit return, then it will returns nil to caller. 

Private Methods:
Ans: Private methods are most commonly used to provide methods for a class that are only accessible to other methods in the same class. These methods are for the class' internal use only and are not callable from outside.

Opposite of if.
Ans: Unless work when condition is false, so to achieve same functionality as if, just reverse the condition

until vs unless.
Ans: unless is if not condition it runs only once and untill is loop. But both work when condition is false and stops when condition meets.

garbage collector, freeze, mutable (Why we use freeze, if Garbage collector will eventually frees memory):
Ans: 
GC will continously allocating and deallocating memory (this is computational expensive)
It leads to pauses in program execution as GC does it works. Effect performance and responsivness
It leads to memory fragmentation

Freeze Benefits:
Single instance reuse, one object and multiple references pointing to it
Improved performance (reducing allocation and deallocation)
GC Optimization (less memory fragmentation, less work GC has to do)

Garbage Collector:
Ans: 

Using freeze on strings reduces memory usage and improves performance by reusing a single object, thus minimizing memory allocation and garbage collector workload. This leads to more efficient memory management and faster execution.

blocks, lambda, proc:
Ans: 
Blocks: 
Methods are best for encapsulating reusable logic that doesn't change often.
Blocks provide a way to customize behavior dynamically, making your methods more flexible and adaptable to different scenarios.

Blocks: We want to make an app for printing bank statements that contains list of transactions. And we want that every bank can use it and every bank has their own format of printing details. And we want to write code once? If a bank wants to print in their own way, they just provide format and boom. We can't use methods here bcz for this every bank has to write their method and call in main method. 

Lambda: We can store blocks to a variable by using lambda, it has two representations, lambda keyword and stabby lambda. If we are using lambda keyword then we will pass arguments in pipes inside block ||. And if we are using stabby lambda(->) then we will use round brackets() to pass arguments. And you can call them in multiple ways. Using var.call("arg"), var.("arg"), var["arg"], var.==="arg". Best way to use is call.

Proc: Proc is just an object used to store blocks and pass them in variables. Its looks similar to lambda. Actually lambda is a type of Proc object with different behavior. We can use Proc.new {||} or proc to use this.

Proc vs Lambda:
Ans: There is no dedicated Lambda class. A lambda is just a special Proc object.
Differences:
Proc don't care about agruments, if have more argument or no agrument it accepts and don't rasie an error. If you return from proc without any top level context (class or method), it gives error. 
Lambda cares about arguments and raise error. While lambda can return without any context.

Similarties:
Proc and lambda both supports default parameters.
Both can be passsed to method as arguments.

Block to Proc and Proc to block:
Ans: To convert a Proc Object to block, when you call a method you pass the proc as argument, you will use &(ampersand) to convert it into block. And in function you can call this by using yield. 
And for converting block to proc, you will write method last argument with &block to convert the block into proc object. Explicit block means that you give it a name in your parameter list (&block). You can pass an explicit block to another method or save it into a variable to use later.

Class vs Instance Variables:
Ans: Class Variables are shared among class and subclasses. (Class variable can be changed )

Global vs Constant Variable
Ans: Global variables are accessible anywhere, even they are defined inside a class or local scope, but constant are accessible 
within defined scope, and they give uninitialized constant error if called directly without ::.

Singleton Method:
Ans: You can change the specific object by definig class << sep_obj.

hash = {"ahsan": 1233}. here, key is string or symbol?
Ans:

Purpose of raise. Why we need to throw errors?
Ans: 

Why there is need of Class level variables?
Ans: We can do similar functionality for all instances. Counting instances (population)
Class Variables (@@): Suitable for shared state across a class hierarchy but can lead to issues if subclasses inadvertently modify the shared state.
Class Instance Variables (@): Better for encapsulating data within a class, providing isolation from subclasses and avoiding unintended side effects.

str = 'foo'
100.times do
  str.gsub!('b'.freeze, 'c'.freeze)
end
Ans: 

why initialize is private method?
Ans:

rescue without begin?
Ans:

class A
end
A.new => ?
Ans:

Difference in Block and Method with some examples.
Ans: It allows you to save a bit of logic (code) & use it later. 
One thing is with blocks we can achieve generic-code and dynamic behavior (printing different format of bank statement) rather than methods we have to define conditions for each case.
other is 
Blocks are particularly useful for iterating, passing custom behavior, and managing resources efficiently.
Efficient resource management using blocks in Ruby ensures that resources are properly allocated and deallocated, preventing resource leaks.

throw vs raise, try, catch, begin, rescue
Ans: 
throw and catch are defined in Kernel Module. Throw takes a tag and a optional object, When you call the throw method, the Ruby interpreter walks up the stack until it finds a corresponding catch. While throw transfers control to end of active catch and if their is no catch, their will be an error(UncagutThrowError). Throw works like return. 
Typically, you'll use throw and catch to escape from multiple levels of loops and conditionals, just like a good old GOTO statement.
Catch/throw is faster than raise/rescue
throw-catch is used for jumping out of control statements, when no further work is required. In contrast, raise-rescue is used for error handling.

Raise If no specific exception class is given, rescue handles StandardError and its subclasses.
An unrescued raise will propagate up the call stack, potentially terminating the program if unhandled.
Raise will send the error to nearest rescue, and if rescue is not present, it will send it to higher call stack. 
raise is used to trigger an exception, and rescue is used to handle it.

Use of Inject
Ans: Inject is same as reduce. If memo is not their first value is initial value.
puts [1,2,3,4,5].inject(1, :+) # inject(initial, symbol)
puts [1,2,3,4,5].inject(:+) # inject(symbol) default start value is zero
puts [1,2,3,4,5].inject(1) {|memo, val| memo += val} # inject(initial) {memory, value}
puts [1,2,3,4,5].inject {|memo, val| memo += val} # inject {memory, value}
puts [1,2,3,4,5].inject {|val| val += val} # inject {value}

Why self in terms of explicit?
Ans: In Ruby, self is used to refer to the receiver of the current method. Using self explicitly helps in differentiating between local variables and method calls. It makes the code clearer, especially when there is a naming conflict.
Self’ allows us to access object attributes and methods, differentiate between local variables and object attributes, and invoke other methods within the same object. 

eq when we want to check if the values are almost equal.
eql when we want to check if the values are exactly equal.
equal when we want to check if the objects are same.

gsub vs sub
Ans: sub replaces the first occurrence of a pattern in a string with a specified replacement.
gsub (global substitute) replaces all occurrences of a pattern in a string with a specified replacement.

Rspec matchers 
Ans: eq, eql, equal, be >, be <, be >=, be_nil, be_empty, include, have_key, be_a, be_an_instance_of, be true, be false, raise_error, throw_symbol

Subject, subject!, let, let! in Rspec:
Ans: Subject represent the object under test. RSpec allows for implicit and explicit definition of subject.

Implicit:
If describe or context first argument is Class, then RSpec auto creates and assign to subject. 

Explicit:
You can define explicit subject (subject {A.new}), and can assign a name (subject(:a) {A.new}). It also can be one-liner (it {is_expected.to be_an(A)}). 

Subject!:
Subject by default is lazy instantiate (means when it is referenced in a class, then it will be created), but subject! instanitate without being referenced in example.

let:
It is used to memorized helper function. The value is first time computed it is referneced and cached and used for other examples.
It is invoked when we call in example

let!:
It is eager. The value is computed before each example.
It evaluates value but dont store unitl invoked

Run a specific spec from a file.
Ans: rspec path/to/spec_file.rb:line_number (rspec spec/models/user_spec.rb:10)

Shared examples in rspecs(Optional).
Ans: Shared examples allow you to define a common set of examples that can be reused across multiple tests. be_an(check its an object of class).

is_a and === methods
Ans: An object belongs to a specific class or is an instance of a class. Developers can verify inheritance, handle polymorphism, and validate object type in their programs by utilizing the is_a? function. It is secure, it does not raise error.

=== (Case equality operator, membership operator, triple equals): 

Used in case statements(implicit triple equal) to check if an object belongs to a certain class or matches a condition. The === operator's meaning is context-dependent, determined by the left-hand operand's class. 
Range: Checks if a value falls within a range.
Regexp: Checks if a string matches a regular expression.
Class: Checks if an object is an instance of a class or subclass.
Proc: Evaluates a block.

Gemset’s in RVM.
Ans: Default gemset, when no gemset is selected.
rvm gemset create name (to create a gem)
rvm gemset use name (to use gem)
rvm gemset list (to list all gemsets)
rvm gemset list_all
rvm gemset use default (to use default gem)
rvm use version@name (to use it )
rvm use version@name --default (to make it default gem)
$ rvm gemset copy 2.1.1@rails4 2.1.2@rails4
$ rvm 2.1.1@teddy do gemset export
rvm @global do gem install ... (ruby provides global gemset per ruby version, which will be available in all gemsets in that particular version)

nil vs empty:
Ans: Empty checks if something is declared and it has no values. And nil check something is not even declared.

the carriage return moves the cursor to the beginning of the line after printing "Hello", so "World" overwrites "Hello". 

Ruby Assignment:
user does not exist => done
divide n conqure  => done
remove quiz module  => 
call create_quiz from the teacher class =>
q = Quiz.new                      =>
q.add_questions -> loop           => 
ques = Question.new -> ques.add_title, ques.add_options, ques.add_corret_answer -> q.questions << ques      => 

student class -> attempt_quiz     => 
quiz.attempt -> loop questions -> ques.display    => 
input                             =>
ques.check_answer -> update score   =>
attempts class    => 

if teacher wants to unlock,lock, publish, unpublish the quiz? => done
if a user is loggedin, then save his email and check at backend rather than input it from user at every action. => done
if a user is logged-in, then he has option of log-out. And then it allows to signup for new email. => done
implement score system, by inputting correct answer from user at quiz creation time. => 
questions, answer



Rails

Why names of model are singular and lowercase? and why controller name is plural?
Ans: In Rails, model names are singular and lowercase to reflect the single instance of that model.
Controller names are plural because they are responsible for handling multiple instances of a model.

What is Migration? How it stores info about model?
Ans: 
Migration: A migration is a Ruby class that is used to modify the database schema over time. It allows you to create, modify, or drop database tables and columns. Migrations are a way to manage changes to your database schema in a version-controlled manner.

Storing Information: Migrations don’t store information about the model directly but rather modify the database schema to accommodate the model’s attributes. For example, if you add a new column to a table in a migration, the model can then interact with that new column.

Why their is need of model, as we can achieve functionality in controller?
Ans: 
Separation of Concerns: 
Models encapsulate the business logic and data interactions, while controllers handle the request/response cycle and user interactions. By separating these concerns, Rails promotes cleaner, more maintainable code. Models interact with the database and contain validations and relationships, while controllers manage how data is presented and how user actions are handled.

What views directory contains?
Ans: views by default contains the layouts folder which has three files, application.html.erb contain the default layout for all pages with body dynamically rendered. And other view folders which you ahve created.

Is always controller interact with model?
Ans: Not Always: While controllers often interact with models to fetch, create, update, or delete records, they don’t always have to. For example, a controller might handle rendering a static page or process data that doesn’t involve models.

What is schema? we can apply validation of it? So why need Model?
Ans: Schema: The schema represents the structure of the database, including tables and columns. It’s defined by migrations and stored in db/schema.rb.
Validation: Schema itself does not handle validation. Instead, models handle validations to ensure data integrity before saving it to the database.
# Schema example (db/schema.rb)
create_table "users", force: :cascade do |t|
  t.string "email"
end

# Model validation
class User < ApplicationRecord
  validates :email, presence: true
end

What does require function do? Permit function?
Ans: 
require: Ensures that a certain parameter is present. It raises an error if the parameter is missing.
permit: Specifies which parameters are allowed. It helps to prevent mass assignment vulnerabilities by filtering the parameters that can  be used in model creation or updates.

I want to get one parameter out of ten, how can i get that in rails comtroller? code?
Ans: 
def show
  specific_param = params[:param1]  # Extracting one parameter
end

When you make model, how many and which files are created?
Ans: db/migrate/2024_create_checks.rb, app/models/check.rb, test/models/check_test.rb, test/fixtures/check.yml

When you make controller, which files are created? Which tests are created?
Ans: app/controllers/check_controller.rb, app/views/check, test/controllers/check_controller_test.rb, app/helpers/check_helper.rb

How to store data in Model?
Ans: Storing Data: You create instances of a model and use save or update methods to store data in the database.

Agile Development, rails is ideally for agile?
Ans: Yes, Rails is often used in Agile development due to its emphasis on convention over configuration, rapid development, and built-in testing frameworks. Its conventions help teams quickly implement features and adapt to changes.

What does params.require & params.permit do?
Ans: params.require: Ensures that a certain parameter is present in the request. It raises an error if it is missing.
params.permit: Allows only specified parameters to be used in mass assignment, helping to prevent security issues.

How rails keep record that which migration's effect is not present in DataBase?
Ans: Schema Migrations Table:
Rails keeps track of which migrations have been applied using a special table called schema_migrations in the database. This table stores the version numbers of the applied migrations.

Why controller name is plural while model name is singular?
Ans: Controllers handle actions related to multiple instances of a model, so their names are plural. This convention reflects their role in managing collections of resources.

Purpose of layouts?
Ans: Layouts: Layouts provide a consistent structure for your views, allowing you to define common elements like headers, footers, and navigation bars that are shared across multiple views.

<%= vs <% ?
Ans: <%= %>: Used to output the result of Ruby code to the view. It evaluates the Ruby code and inserts the result into the HTML.

<% %>: Used to execute Ruby code without outputting anything. It’s typically used for control flow (loops, conditionals) and other operations that don’t produce output directly.



























