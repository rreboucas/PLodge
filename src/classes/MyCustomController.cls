public class MyCustomController {

    public String CandidateSelectedId {get; set;}
    public DisplayCandidate SelectCandidate {get; set;}

    
    public MyCustomController() {

    }

    public List<Candidate__c> getTopCandidates() {
        List<Candidate__c> candidates = [SELECT id, Name,Average_Score__c,
                                                          Number_of_Interviews__c FROM Candidate__c 
                                                          order by Number_of_Interviews__c desc, Average_Score__c desc limit 3]; 
        return candidates; 
    }
    
    
    public List<Position__c> getUpcomingPositions() {
        List<Position__c> positions = [SELECT Id,Name,owner.name, ownerid, Fullfilment_Date_Limit__c,Hiring_Manager__c, Hiring_Manager__r.Name,Status__c 
                                                        FROM Position__c 
                                                        where Fullfilment_Date_Limit__c > TODAY 
                                                        order by Fullfilment_Date_Limit__c desc limit 3]; 
        return positions; 
    }
    
    
    public List<Interview__c> getTodaysInterviews() {
        List<Interview__c> interviews = [SELECT Id,name,Candidate__c,Candidate__r.Name, Interview_Type__c 
                                                          FROM Interview__c limit 3]; 
        return interviews; 
    }

    public PageReference save() {
        
        return null;
    }
    
    public List<Interview__c> getInterviewsForCandidates() {
        
        List<Interview__c> listInts = [Select id, Interview_Type__c, Score_Total__c, Average_Score__c,
                                       Score_Color__c, Candidate__c FROM Interview__c
                                       WHERE Candidate__c =: CandidateSelectedId];
        
        return listInts;
        
    }
    
    // handle the action of the commandlink
    public PageReference processLinkClick() {
        // now process the variable by doing something...
        System.debug('processLinkClick method - CandidateSelectedId: '+ CandidateSelectedId);
        return null;
    }
    
    public List<DisplayCandidate> getDisplayCandidates() {
        
        System.debug('getDisplayCandidates method - : ');
        List<DisplayCandidate> candidates = new List<DisplayCandidate>();
        
        List<Candidate__c> lstCandidates = [SELECT id, Name,Average_Score__c, ExternalUser__c,
                                            Number_of_Interviews__c, Position__r.Name FROM Candidate__c 
                                            where id =: CandidateSelectedId];
        
        
        
        
        if (lstCandidates.size() > 0)
        {
            for (Candidate__c e: lstCandidates)
            {
                
                String phUrl = '';
                ConnectApi.Photo userPhoto = ConnectApi.ChatterUsers.getPhoto(null, e.ExternalUser__c);
                if (userPhoto != null)
                    phUrl = userPhoto.smallPhotoUrl;
                
                
                
                
                String cName = e.Name;
                
                String posName = e.Position__r.Name;
                
                
                DisplayCandidate cnd = new DisplayCandidate(cname, posName, phUrl);
                candidates.add(cnd);
            }
            
            
            
        }
        else
        {
           DisplayCandidate cnd2 = new DisplayCandidate('Candidate Name', 'Position Name', 'https://www.lightningdesignsystem.com/assets/images/avatar1.jpg');
           candidates.add(cnd2); 
        }
        
        return candidates;
    }
    
    
    // Inner class to hold store details for candidate
    public class DisplayCandidate {

        public DisplayCandidate(String name, String positionName, String picUrl) {
            this.candidateName = name;
            this.positionName = positionName;
            this.iconUrl = picUrl;
        }

        // Properties for use in the Visualforce view
        
        public String candidateName { get; set; }
        public String positionName { get; set; }
        public String iconUrl { get; set; }
    }
    
    public class DisplayInterviews {

        public DisplayInterviews(String eventsDate, List<Interview__c> interviews) {
            this.interViewDate = eventsDate;
            this.lstInterviews = interviews;
        }

        // Properties for use in the Visualforce view
        
        public String interViewDate { get; set; }
        public List<Interview__c> lstInterviews { get; set; }
    }

   public List<DisplayInterviews> getUpcomingInterviews() {
        
        List<DisplayInterviews> lstDispInterviews = new List<DisplayInterviews>();
        
        Map<String, List<Interview__c>> mapIntvwsByDate = new Map<String, List<Interview__c>>();
        ID currentUserID = UserInfo.getUserId();
        
        List<Interview__c> lstUserInterviews = [SELECT Candidate__c, Candidate__r.Name,Candidate__r.Position__r.Name, Id,Interview_Date__c,Interview_Type__c,Number_of_Interviewers__c FROM Interview__c 
                                                where id in 
                                                (SELECT Interview__c FROM Interviewer__c where Interviewer__c =: currentUserID) 
                                                and Interview_Date__c > TODAY order by Interview_Date__c asc];
        
        for (Interview__c i : lstUserInterviews)
        {
            String myDate = i.Interview_Date__c.format('EEEE MM/dd');
            
            if (mapIntvwsByDate.containsKey(myDate))
            {
                List<Interview__c> lstExistIntOnaDay = mapIntvwsByDate.get(myDate);
                lstExistIntOnaDay.add(i);
                mapIntvwsByDate.put(myDate, lstExistIntOnaDay);
            }
            else
            {
                List<Interview__c> lstNewIntOnaDay = new List<Interview__c>();
            	lstNewIntOnaDay.add(i);
            	mapIntvwsByDate.put(myDate, lstNewIntOnaDay); 
            }
  
        }
        
        for (String intDate : mapIntvwsByDate.keySet())
        {
            DisplayInterviews dp = new DisplayInterviews(intDate, mapIntvwsByDate.get(intDate));

            lstDispInterviews.add(dp);
        }
        
        return lstDispInterviews;
        
    } 
    
}