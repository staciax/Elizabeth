# Elizabeth

Elizabeth is an API testing tool written in Swift and SwiftUI.

## Check List

**The Basics**
- [x] Declaring Constants and Variable
    - [x] Type Annotations
    - [x] Naming Constants and Variables
    - [x] Printing Constants and Variables
- [x] Comments
- [x] Semicolons
- [x] Integers
    - [ ] Integer Bounds
    - [ ] Int
    - [ ] UInt
- [ ] Floating-Point Numbers
- [x] [Type Safety and Type Inference](Elizabeth/Utils2.swift#L52)
- [ ] Numeric Literals
- [ ] Numeric Type Conversion
    - [ ] Integer Conversion
    - [ ] Floating-Point Conversion
- [x] [Type Aliases](Elizabeth/Utils2.swift#L87) <!-- HTTPReponse -->
- [x] [Booleans](Elizabeth/TestRDetail.swift#L46) <!-- isLoading -->
- [x] [Tuples](Elizabeth/Utils2.swift#87) <!-- HTTPReponse -->
- [x] Optionals
    - [ ] Nil
    - [x] [Optional Binding](Elizabeth/Utils2.swift#263) <!-- statusMessage -->
    - [x] [Providing a Fallback Value](Elizabeth/TestRDetail.swift#L301) <!-- statusCode -->
    - [x] [Force Unwrapping](Elizabeth/Utils2.swift#L131) <!--  finalResponse! -->
    - [ ] Implicitly Unwrapped Optionals
- [-] Error Handling
- [x] Assertions and Preconditions
    - [ ] Debugging with Assertions
    - [x] [Enforcing Preconditions](Elizabeth/Utils2.swift#L91)
 
**Basic Operators**
- [x] [Assignment Operator](Elizabeth/ElizabethApp.swift)
- [x] Arithmetic Operators
    - [ ] Addition (+)
    - [x] [Subtraction (-)](Elizabeth/TestRDetail.swift#283) <!-- duration -->
    - [x] [Multiplication (*)](Elizabeth/Utils2.swift#L48) <!-- formatDuration -->
    - [x] [Division (/)](Elizabeth/Utils2.swift#L48)  <!-- formatDuration -->
    - [ ] Remainder Operator
    - [ ] Unary Minus Operator
    - [ ] Unary Plus Operator
- [ ] Compound Assignment Operators
- [x] [Comparison Operators](Elizabeth/Utils2.swift#L289)
- [x] [Ternary Conditional Operator](Elizabeth/TestR.swift#L89) <!-- headers: finalHeaders.isEmpty ? nil : finalHeaders -->
- [x] [Nil-Coalescing Operator](Elizabeth/TestRDetail.swift#L301) <!-- statusCode -->
- [x] Range Operators
    - [x] [Closed Range Operator](Elizabeth/Utils2.swift#L294)
    - [x] [Half-Open Range Operator](Elizabeth/Utils2.swift#L300)
    - [x] [One-Sided Ranges](Elizabeth/Utils2.swift#L305)
- [x] Logical Operators
    - [x] [Logical NOT Operator](Elizabeth/TestR.swift#L185) <!-- !self.isFocused -->
    - [ ] Logical AND Operator
    - [x] [Logical OR Operator](Elizabeth/TestRDetail.swift#L375) <!-- isCollection -->
- [ ] Combining Logical Operators
- [ ] Explicit Parentheses

**Strings and Characters**
- [x] String Literals
    - [ ] Multiline String Literals
    - [ ] Special Characters in String Literals
    - [ ] Extended String Delimiters
- [x] [Initializing an Empty String](Elizabeth/EnvironmentView.swift#L18)
- [ ] String Mutability
- [-] Strings Are Value Types
- [ ] Working with Characters
- [ ] Concatenating Strings and Characters
- [x] [String Interpolation](Elizabeth/RequestDetailView.swift#L356)
- [ ] Unicode
    - [ ] Unicode Scalar Values
    - [ ] Extended Grapheme Clusters
- [ ] Counting Characters
- [ ] Accessing and Modifying a String
    - [ ] String Indices
    - [ ] Inserting and Removing
- [ ] Substrings
- [ ] Comparing Strings
    - [ ] String and Character Equality
    - [ ] Prefix and Suffix Equality
- [ ] Unicode Representations of Strings
    - [ ] UTF-8 Representation
    - [ ] UTF-16 Representation
    - [ ] Unicode Scalar Representation

**Collection Types**
- [x] Array
    - [x] [Array Type Shorthand Syntax](Elizabeth/AppState2.swift#L12)
    - [x] [Creating an Empty Array](Elizabeth/AppState2.swift#L12)
    - [ ] Creating an Array with a Default Value
    - [ ] Creating an Array by Adding Two Arrays Together
    - [ ] Creating an Array with an Array Literal
    - [ ] Accessing and Modifying an Array
    - [ ] Iterating Over an Array
- [ ] Set
    - [ ] Creating and Initializing an Empty Set
    - [ ] Creating a Set with an Array Literal
    - [ ] Accessing and Modifying a Set
    - [ ] Iterating Over a Set
- [ ] Performing Set Operations
    - [ ] Fundamental Set Operations
    - [ ] Set Membership and Equality
- [x] Dictionary
    - [x] [Dictionary Type Shorthand Syntax](Elizabeth/Utils2.swift)
    - [x] [Creating an Empty Dictionary](Elizabeth/Utils2.swift)
    - [ ] Creating a Dictionary with a Dictionary Literal
    - [ ] Accessing and Modifying a Dictionary
    - [x] [Iterating Over a Dictionary](Elizabeth/Utils2.swift)

**Control Flow**
- [x] [For-In Loops](Elizabeth/Utils2.swift#L42)
- [x] While Loops
    - [ ] While
    - [ ] Repeat-While Loops
- [x] Conditional Statements
    - [x] If
        - [ ] If Expression
    - [x] Switch
        - [ ] Switch Expression
        - [x] [Interval Matching](Elizabeth/Utils2.swift#L31) <!-- statusColor -->
        - [-] Tuples
        - [-] Value Bindings
- [x] Patterns
    - [x] [If](Elizabeth/TestR.swift#L123)
    - [ ] For-In
- [ ] Control Transfer Statements
    - [ ] Continue
    - [ ] [Break](Elizabeth/RequestDetailView.swift#L60)
    - [ ] Fallthrough
    - [ ] Labeled Statements
- [x] [Early Exit](Elizabeth/Utils2.swift#L51) <!-- guard statement -->
- [x] [Deferred Actions](Elizabeth/TestRDetail.swift#L335)
- [x] [Checking API Availability](Elizabeth/TestR.swift#L311)

**Functions**
- [x] Defining and Calling Functions
- [x] Function Parameters and Return Values
    - [x] [Functions Without Parameters](Elizabeth/Utils2.swift#L12) <!-- getDefaultUserAgent -->
    - [x] [Functions With Multiple Parameters](Elizabeth/Utils2.swift) <!-- sendHttpRequest2 -->
    - [x] [Functions Without Return Values](Elizabeth/TestR.swift#L122) <!-- deleteChild -->
    - [x] [Functions With Multiple Return Values](Elizabeth/Utils2.swift#L47) <!-- sendHttpRequest2 -->
    - [x] [Functions With an Implicit Return](Elizabeth/Utils2.swift#L29) <!-- getDefaultHeaders --> 
- [x] Function Argument Labels and Parameter Names
    - [x] [Specifying Argument Labels](Elizabeth/Utils2.swift) <!-- getMethodColor(for:) -->
    - [x] [Omitting Argument Labels](Elizabeth/Utils2.swift) <!-- formatDuration(_:) -->
    - [x] [Default Parameter Values](Elizabeth/Utils2.swift#L47)
    - [x] [Variadic Parameters](Elizabeth/Utils2.swift#L21) <!-- buildHeaders, buildParams -->
    - [x] [In-Out Parameters](Elizabeth/TestR.swift#L122) <!-- deleteChild -->
- [x] Function Types
    - [ ] Using Function Types
    - [ ] Function Types as Parameter Types
    - [ ] Function Types as Return Types
- [x] [Nested Functions](Elizabeth/Utils2.swift#L95) <!-- sendHttpRequest2, extractCookies -->

**Closures**
- [x] Closure Expressions
    - [x] [The Sorted Method](Elizabeth/TestRDetail.swift#L158)
    - [x] [Closure Expression Syntax](Elizabeth/TestRDetail.swift#L162)
    - [x] [Inferring Type From Context](Elizabeth/TestRDetail.swift#L257)
    - [x] [Implicit Returns from Single-Expression Closures](Elizabeth/TestRDetail.swift#L260)
    - [x] [Shorthand Argument Names](Elizabeth/TestRDetail.swift#L264)
    - [x] [Operator Methods](Elizabeth/TestRDetail.swift#L268)
- [ ] Trailing Closures
- [ ] Capturing Values
- [ ] Closures Are Reference Types
- [ ] Escaping Closures
- [ ] Autoclosures

**Enumerations**
- [x] [Enumeration Syntax](Elizabeth/Enums.swift) <!-- HTTPMethod -->
- [x] [Matching Enumeration Values with a Switch Statement](Elizabeth/Utils2.swift#L12) <!-- getMethodColor -->
- [x] [Iterating over Enumeration Cases](Elizabeth/TestRDetailsw.swift#L120)  <!-- HTTPMethod.allCases -->
- [x] [Associated Values](Elizabeth/TestR.swift#L40)
- [x] [Raw Values](Elizabeth/Enums.swift)
    - [ ] Implicitly Assigned Raw Values
    - [ ] Initializing from a Raw Value
- [x] [Recursive Enumerations](Elizabeth/TestR.swift#L40)

## Links
- https://developer.apple.com/documentation/SwiftUI/Migrating-from-the-observable-object-protocol-to-the-observable-macro
- https://developer.apple.com/documentation/swiftui/environment
- https://developer.apple.com/documentation/SwiftUI/Applying-Liquid-Glass-to-custom-views
