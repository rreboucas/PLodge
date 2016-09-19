@isTest
global class WebServiceMockImpl implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {

        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"created_at":"Thu Mar 26 20:30:44 +0000 2009"}');
        res.setStatusCode(200);
        return res;
    }
}