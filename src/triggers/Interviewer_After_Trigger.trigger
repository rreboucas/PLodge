trigger Interviewer_After_Trigger on Interviewer__c (after insert, after update) {
    
    Interviewer__c intv = Trigger.new[0];
    String relatePositionId = intv.Position__c;
    System.debug('relatePositionId: '+ relatePositionId);
    String intvType = intv.Interview_Type__c;
    System.debug('intvType: '+ intvType);
    String intvId = intv.id;
    System.debug('intvId: '+ intvId);
    List<Interview_Questions__c> intvQuestions = [select id, Interview_Type__c, Question__c
                                                                from Interview_Questions__c where Position__c =: relatePositionId and Interview_Type__c =: intvType ];
    System.debug('intvQuestions: '+ intvQuestions);
    List<Interview_Answer__c> lstToAdd = new List<Interview_Answer__c>();
    
    for(Interview_Questions__c a: intvQuestions){
      Interview_Answer__c rec =  new Interview_Answer__c();
      rec.Question__c = a.Question__c;
      rec.Interview_Question__c = a.id;
      rec.Interviewer__c = intvId;
      lstToAdd.add(rec);  
   }
    System.debug('lstToAdd: '+ lstToAdd);
    insert lstToAdd;
    

}