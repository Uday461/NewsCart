//
//  URLProtocolMock.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 23/10/23.
//

import Foundation

class URLProtocolMock: URLProtocol {
    // this dictionary maps URLs to test data
    static var testURLs = [URL?: Data]()

    // say we want to handle all types of request
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    // ignore this method; just send back what we were given
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        // if we have a valid URL…
        if let url = request.url {
            // …and if we have test data for that URL…
            if let data = URLProtocolMock.testURLs[url] {
                // …load it immediately.
                self.client?.urlProtocol(self, didLoad: data)
            } else {
                let error = NSError(domain: "", code: 401, userInfo: [ NSLocalizedDescriptionKey: "No Data found"])
                self.client?.urlProtocol(self, didFailWithError: error as Error)
            }
        }

        // mark that we've finished
        self.client?.urlProtocolDidFinishLoading(self)
    }

    // this method is required but doesn't need to do anything
    override func stopLoading() { }
}
