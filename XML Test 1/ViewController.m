//
//  ViewController.m
//  XML Test 1
//
//  Created by Robert Ryan on 12/15/12.
//  Copyright (c) 2012 Robert Ryan. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "XMLParser.h"

NSString * const kCategoryNameKey = @"name";
NSString * const kCategoryProductsKey = @"items";

//XML Product Attributes
NSString * const kCategoryProductCDKey = @"PRODUCT_CD"; 
NSString * const kCategoryEnglishProductNameKey = @"ENGLISH_PRODUCT_NAME";
NSString * const kCategoryProduct_Image = @"PRODUCT_IMAGE";  //display in DetailViewCOntroller_B Only

@interface ViewController () <NSXMLParserDelegate>

// this is our final result, an array of dictionaries for each category


@property (nonatomic, strong) NSMutableArray *categories;


//  these are just temporary variables used during the parsing

@property (nonatomic, strong) NSMutableString *parserElementValue;
@property (nonatomic, strong) NSMutableDictionary *parserProduct;

@end

@implementation ViewController

//@synthesize categories;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.categories = [[NSMutableArray alloc] init]; //Made categories (array of dictionaries Global)
    [self parse];
}

- (void)parse
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"PRODUCT_CATALOG_2" withExtension:@"xml"];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    parser.delegate = self;
    [parser parse];
}

#pragma mark - Segue methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DetailSegue"])
    {
        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        DetailViewController *controller = segue.destinationViewController;
        controller.category = self.categories[indexPath.row];
    }
}

#pragma mark - UITableViewDataSource delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CategoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *category = self.categories[indexPath.row];
    
    cell.textLabel.text = category[kCategoryNameKey];
    
    return cell;
}

#pragma mark - NSXMLParser delegate methods

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    self.categories = [NSMutableArray array];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    /********************************
     Add additional elements here ...
     ********************************/

    NSArray *subElementNames = @[kCategoryProductCDKey, kCategoryEnglishProductNameKey, kCategoryProduct_Image];
    
    if ([elementName isEqualToString:@"PRODUCT"])
    {
        // get the name of the category attribute
        
        NSString *categoryName = [attributeDict objectForKey:@"category"];
        NSAssert(categoryName, @"no category found");
        
        // search our array of dictionaries of cateogries to see if we have one with a name equal to categoryName
        
        __block NSMutableDictionary *parserCurrentCategory = nil;
        [self.categories enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([categoryName isEqualToString:[obj objectForKey:kCategoryNameKey]])
            {
                parserCurrentCategory = obj;
                *stop = YES;
            }
        }];
        
        // if we didn't find one, let's create one and add it to our array of cateogires
        
        if (!parserCurrentCategory)
        {
            parserCurrentCategory = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     categoryName, kCategoryNameKey,
                                     [NSMutableArray array], kCategoryProductsKey,
                                     nil];
            [self.categories addObject:parserCurrentCategory];
        }
        
        // Now let's add an entry to the items array for the product being added
        
        self.parserProduct = [NSMutableDictionary dictionary];
        [[parserCurrentCategory objectForKey:kCategoryProductsKey] addObject:self.parserProduct];
    }
    else if ([subElementNames containsObject:elementName])
    {
        self.parserElementValue = [NSMutableString string];
        [self.parserProduct setObject:self.parserElementValue forKey:elementName];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (self.parserElementValue)
        [self.parserElementValue appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"PRODUCT"])
    {
        self.parserProduct = nil;
    }
    else if (self.parserElementValue)
    {
        self.parserElementValue = nil;
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self.tableView reloadData];
    NSLog(@"%s categories = %@", __FUNCTION__, self.categories);
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    [[[UIAlertView alloc] initWithTitle:nil
                                message:[parseError description]
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

@end
