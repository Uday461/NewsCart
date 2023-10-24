//
//  APINewsManagerTests.swift
//  NewsCartTests
//
//  Created by UdayKiran Naik on 23/10/23.
//

import XCTest
@testable import NewsCart

final class APINewsManagerTests: XCTestCase {
    let apiNewsManager = APINewsManager()
    var articleNewsModel: APINewsModel? = nil
    func testApiNewsManager(){
        // this is the URL we expect to call
        let url = URL(string: "https://newsapi.org/v2/top-headlines?country=in&apiKey=\(Constants.apiKey)&pageSize=5&page=1")

        // attach that to some fixed data in our protocol handler
        URLProtocolMock.testURLs = [url: Data("Testing Data11".utf8)]

        // now set up a configuration to use our mock
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]

        // and create the URLSession from that
        let session = URLSession(configuration: config)
        let expectation = XCTestExpectation(description: "API request")

        apiNewsManager.apiRequest(url: "https://newsapi.org/v2/top-headlines?country=in&apiKey=\(Constants.apiKey)&pageSize=5&page=1", urlSessionWithConfiguration: session) { data, response, error, key in
            XCTAssertEqual(String(data: data!, encoding: .utf8), "Testing Data11")
            if let httpResponse = response as? HTTPURLResponse {
                XCTAssertEqual(httpResponse.statusCode, 200,  "Expected a 200 OK response.")
            }
            XCTAssertNil(error, "Expected no errors for fetching data.")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testCategoryConstants(){
      let arrayOfCategories = ["Business","Health","Technology","Science","Sports", "SomeString"]
        for index in 0..<arrayOfCategories.count {
            let categoryConstant = apiNewsManager.categoryConstants(category: arrayOfCategories[index])
            switch(arrayOfCategories[index]) {
            case "Business":
            let constant = try! XCTUnwrap(categoryConstant)
            XCTAssertEqual(constant, Constants.businessNewsApiQuery)
            break
            case "Health":
            let constant = try! XCTUnwrap(categoryConstant)
            XCTAssertEqual(constant, Constants.healthNewsApiQuery)
            break
            case "Technology":
            let constant = try! XCTUnwrap(categoryConstant)
            XCTAssertEqual(constant, Constants.technologyNewsApiQuery)
            break
            case "Science":
            let constant = try! XCTUnwrap(categoryConstant)
            XCTAssertEqual(constant, Constants.scienceNewsApiQuery)
            break
            case "Sports":
            let constant = try! XCTUnwrap(categoryConstant)
            XCTAssertEqual(constant, Constants.sportsNewsApiQuery)
            break
            case "SomeString":
            XCTAssertNil(categoryConstant)
            break
            default:
            break
            }
        }
        
    }
    
    func testParseJson() {
        apiNewsManager.fetchNewsDelegate = self
        let jsonString = """
              {
                  "totalResults": 1,
                  "articles": [
                      {
                          "source": {
                              "name": "Test Source"
                          },
                          "title": "Test Title",
                          "description": "Test Description",
                          "url": "https://test.com",
                          "urlToImage": "https://test.com/image.jpg"
                      }
                  ]
              }
          """
        let jsonData = jsonString.data(using: .utf8)!
        apiNewsManager.parseJSON(data: jsonData)
        XCTAssertEqual(articleNewsModel?.totalResults, 1)
        XCTAssertEqual(articleNewsModel?.articles.count, 1)
        XCTAssertEqual(articleNewsModel?.articles[0].source.name, "Test Source")
        XCTAssertEqual(articleNewsModel?.articles[0].title, "Test Title")
        XCTAssertEqual(articleNewsModel?.articles[0].description, "Test Description")
        XCTAssertEqual(articleNewsModel?.articles[0].url, "https://test.com")
        XCTAssertEqual(articleNewsModel?.articles[0].urlToImage, "https://test.com/image.jpg")

    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

}


extension APINewsManagerTests: FetchNews {
    func fetchAndUpdateNews(_ apiNewsModel: NewsCart.APINewsModel) {
        articleNewsModel = apiNewsModel
    }
    
    func didFailErrorDueToNetwork(_ networkError: Error) {
        
    }
    
}
