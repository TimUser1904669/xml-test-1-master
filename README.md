# XML Test 1

--

## Introduction

This is an iOS application, created in response to a question on Stack Overflow, [iOS NSXMLParser Value with Category ie. &lt;Product category=“ABC”&gt; in tableviews](http://stackoverflow.com/questions/13883203/). This is an extremely simple demonstration of using `NSXMLParser` to parse a XML file and present the results in a master-detail series of tableviews.

Please note that this is just reading the XML from this project. Clearly, most XML parsing apps would be retrieving it from a remote server. But I assume you are familiar with how to retrieve a XML from remote server rather than from local file.

The last series of comments on Stack Overflow were, essentially, "how do I get the information out of that array of dictionaries and into my table views?" So I would draw your attention to the `UITableView` related methods in `ViewController.m` and `DetailViewController.m` for a demonstration of how you would do that.

## Description

This takes the following XML file:

    <Products>
        <Product category="ABC">
            <Item_number>123</Item_number>
            <Description>Coffee table</Description>
        </Product>

        <Product category="ABC">
            <Item_number>456</Item_number>
            <Description>Lamp shade</Description>
        </Product>

        <Product category="XYZ">
            <Item_number>789</Item_number>
            <Description>Orange chair</Description>
        </Product>
    </Products>

It takes that, parses it with `NSXMLParser` creates a `NSArray` of `NSDictionary` entries, one entry for each product category. Each product category, then has a list of items (another `NSArray` of `NSDictionary` entries) as a property of the category.

## Classes

`AppDelegate` - This is the standard app delegate, unchanged from the standard template.

`ViewController` - This is a `UITableView` subclass for the main view, the list of categories. This class parses the XML, and presents the list of categories. For how to retrieve the category names, take a look at the `UITableViewDataSource` delegate methods in this class. For information on how to pass the category dictionary entry to the `DetailViewController`, look at the `prepareForSegue` method.

`DetailViewController` - This is another `UITableView` subclass, but this time for a list of items in a particular product category. In `viewDidLoad` you can see how I'm grabbing the name of the category to populate the title bar. In the `UITableViewDataSource` delegate methods, you can see how I can retrieve the particulars of the individual items (the products) from the `NSDictionary` for the category that was passed to this from the `ViewController`.

## Notes

This was developed using Xcode 4.5.2 for devices running iOS 5 or later.

Please note that this is a "throw away" demonstration, and in fact I may not keep it around on github for very long. If you want to keep a copy, you may want to download one now.

If you have any questions, I would suggest clicking on the github "issues" button and creating something there. Discussion of this demonstration on Stack Overflow is not a good use of that service, and such discussion and Q&A would likely be deleted promptly as being "too localized", i.e. not of interest to the broader community. I will keep an eye out for issues that are posted here, though.

--

15 December 2012
