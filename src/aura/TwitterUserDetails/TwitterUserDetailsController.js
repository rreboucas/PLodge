({
	doInit : function(component, event, helper) {
        alert("TEST");
        $A.log("TwitterUserDetailsController.doInit: entered");

        // load initial values when there are no records selected 

        component.set("v.fullName", "User Name");
        var listHasRecords = component.get("v.hasRecords");

        //Example 1: Unauthorized use of Aura Framework Util Class isBoolean method:
        
        /*

        if ($A.util.isBoolean(listHasRecords))
        {
            $A.log("this is an attribute of type boolean");
        }
        
        */
       
        
       
        if(typeof(variable) === "boolean"){
            $A.log("this is an attribute of type boolean");
        }
        
        
        
	},

    initJS : function(component, event, helper) {
        
        $A.log("TestJSAccessController.initJS: entered");
        
        //Example 2: ES5 Strict Mode Enforcement: Locker Service runs your script in strict mode (eval'd with "use strict") so global variables won't work:

        //$A.log(myTestVariable);


        $A.log("TestJSAccessController.initJS: exit");
        
    },
    
    pressButton : function(component, event, helper) {
        
        // Not Allowed with Locker Service:
        //var div = document.querySelector(".testClass");
        //$A.log("Value = " + div.parentNode.innerHTML);

        // Allowed with Locker Service:
        var el = document.getElementById('myButton');
        $A.log("Value of El = " + el);
        


    },
    
    handleApplicationEvent : function(component, event, helper) {
        
        $A.log("TwitterUserDetailsController.handleApplicationEvent: entered");
        component.set("v.rec", null);
        var params = event.getParams();
        component.set("v.record", params.recordDetails);
    	        
        var recObject = component.get("v.record");
        $A.log("TwitterUserDetailsController.handleApplicationEvent: recObject: " + recObject);
        $A.log("TwitterUserDetailsController.handleApplicationEvent: recObject.firstName: " + recObject.firstName);


		
        helper.getTwitterUserDetails(component);
       
        

        $A.log("TwitterUserDetailsController.handleApplicationEvent: exit");
        
	},

	OpenTweet:function(component,event,helper) {
        
        $A.log("TwitterUserDetailsController.OpenTweet: entered");
       
        // Open Modal
		//var toggleText = component.find("modal");
		//$A.util.removeClass(toggleText,'toggle');

        // Navigvate to VF Page:
        
        var recObject = component.get("v.rec");
        
        //window.setImmediate();
















        //window.open(recObject.tweetLink);

        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": recObject.tweetLink
        });
        urlEvent.fire();
        
        
        
        
        $A.log("TwitterUserDetailsController.OpenTweet: exit");
	}
})