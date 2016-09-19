public class PositionControllerExtension {
    
    private final Position__c position;
    
    // The extension constructor initializes the private member
    // variable acct by using the getRecord method from the standard
    // controller.
    public PositionControllerExtension(ApexPages.StandardController stdController) {
        this.position = (Position__c)stdController.getRecord();
    }

    public String getGreeting() {
        return 'Hello ' + position.name + ' (' + position.id + ')';
    }
    
    public List<Candidate__c> getTopCandidates() {
        List<Candidate__c> candidates = [SELECT id, Name,Average_Score__c,
                                                          Number_of_Interviews__c FROM Candidate__c 
                                                          where Position__c =: position.id 
                                                          order by Number_of_Interviews__c desc, Average_Score__c desc limit 3]; 
        return candidates; 
    }

}